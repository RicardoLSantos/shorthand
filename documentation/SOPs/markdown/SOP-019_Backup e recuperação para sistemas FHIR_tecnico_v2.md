# SOP-019: Backup e Recuperação para Sistemas FHIR

**Versão:** 1.0.0  
**Data de Criação:** 2024  
**Última Atualização:** 2024  
**Responsável:** Equipe de Infraestrutura e Interoperabilidade  
**Status:** Ativo

## 1. OBJETIVO

Estabelecer procedimentos padronizados para backup, recuperação e continuidade de negócios em sistemas FHIR, garantindo integridade dos dados clínicos, conformidade regulatória e recuperação rápida em caso de desastres¹.

## 2. ESCOPO

Este SOP abrange:
- Estratégias de backup para dados FHIR
- Procedimentos de recuperação (Recovery)
- Plano de Continuidade de Negócios (BCP)
- Disaster Recovery (DR)
- Testes de recuperação
- Retenção e arquivamento
- Conformidade com LGPD, GDPR e HIPAA

## 3. DEFINIÇÕES E CONCEITOS

### 3.1 Fundamentos Teóricos

**Modelo 3-2-1 de Backup**²:
- **3 cópias** dos dados importantes
- **2 tipos diferentes** de mídia de armazenamento
- **1 cópia offsite** (geograficamente distante)

**Métricas Críticas**³:
- **RPO (Recovery Point Objective)**: Máxima perda de dados aceitável
- **RTO (Recovery Time Objective)**: Tempo máximo para recuperação
- **MTTR (Mean Time To Recovery)**: Tempo médio de recuperação
- **MTBF (Mean Time Between Failures)**: Tempo médio entre falhas

### 3.2 Classificação de Dados FHIR

**Níveis de Criticidade**⁴:
1. **Crítico**: Dados vitais para operação (Patient, AllergyIntolerance)
2. **Essencial**: Dados importantes mas não vitais (Observation, Encounter)
3. **Importante**: Dados operacionais (Appointment, Schedule)
4. **Auxiliar**: Dados de suporte (AuditEvent, Provenance)

## 4. RESPONSABILIDADES

### 4.1 Equipe de Infraestrutura
- Executar backups conforme cronograma
- Monitorar integridade dos backups
- Manter infraestrutura de backup

### 4.2 DBA/Administrador de Dados
- Validar consistência dos dados
- Gerenciar retenção e purga
- Otimizar processos de backup

### 4.3 Equipe de Segurança
- Garantir criptografia dos backups
- Gerenciar chaves de criptografia
- Auditar acessos aos backups

## 5. PROCEDIMENTOS - PARTE TEÓRICA

### 5.1 Arquitetura de Backup Multi-Camadas

**Camada 1 - Backup Local**:
- Snapshots do sistema de arquivos
- Replicação síncrona de banco de dados
- RPO: 15 minutos, RTO: 1 hora

**Camada 2 - Backup Regional**:
- Replicação assíncrona para datacenter secundário
- Backup incremental diário
- RPO: 1 hora, RTO: 4 horas

**Camada 3 - Backup em Nuvem**:
- Armazenamento de longo prazo
- Backup completo semanal
- RPO: 24 horas, RTO: 24 horas

### 5.2 Estratégias de Backup FHIR

**Backup por Recurso**⁵:
- Export bulk via operação $export
- Versionamento de recursos
- Backup incremental baseado em _lastUpdated

**Backup Transacional**:
- Backup de bundles completos
- Preservação de integridade referencial
- Manutenção de ordem transacional

## 6. PROCEDIMENTOS - PARTE PRÁTICA

### 6.1 Script de Backup Automatizado

```bash
#!/bin/bash
# fhir-backup.sh - Script de backup automatizado para FHIR Server

# Configurações
FHIR_BASE_URL="${FHIR_BASE_URL:-http://localhost:8080/fhir}"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/fhir}"
S3_BUCKET="${S3_BUCKET:-s3://company-fhir-backups}"
ENCRYPTION_KEY="${ENCRYPTION_KEY:-/etc/fhir/backup.key}"
RETENTION_DAYS="${RETENTION_DAYS:-30}"
LOG_FILE="${LOG_FILE:-/var/log/fhir-backup.log}"

# Funções de logging
log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" | tee -a "$LOG_FILE" >&2
}

# Criar estrutura de diretórios
create_backup_structure() {
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_path="${BACKUP_DIR}/${timestamp}"
    
    mkdir -p "${backup_path}"/{data,metadata,audit}
    echo "$backup_path"
}

# Backup usando FHIR Bulk Export
perform_bulk_export() {
    local backup_path="$1"
    
    log_info "Iniciando bulk export..."
    
    # Iniciar operação $export
    local response=$(curl -X POST \
        -H "Accept: application/fhir+json" \
        -H "Prefer: respond-async" \
        "${FHIR_BASE_URL}/\$export" \
        -s -w "\n%{http_code}")
    
    local http_code=$(echo "$response" | tail -n1)
    local content_location=$(echo "$response" | grep -i "content-location:" | cut -d' ' -f2)
    
    if [ "$http_code" != "202" ]; then
        log_error "Falha ao iniciar export: HTTP $http_code"
        return 1
    fi
    
    # Aguardar conclusão do export
    local status="in-progress"
    while [ "$status" = "in-progress" ]; do
        sleep 10
        local check_response=$(curl -s "$content_location")
        status=$(echo "$check_response" | jq -r '.status // "in-progress"')
    done
    
    if [ "$status" != "completed" ]; then
        log_error "Export falhou com status: $status"
        return 1
    fi
    
    # Download dos arquivos exportados
    local output_files=$(echo "$check_response" | jq -r '.output[]?.url')
    
    for file_url in $output_files; do
        local filename=$(basename "$file_url")
        log_info "Baixando: $filename"
        curl -s "$file_url" -o "${backup_path}/data/${filename}"
    done
    
    log_info "Bulk export concluído"
    return 0
}

# Backup incremental baseado em timestamp
perform_incremental_backup() {
    local backup_path="$1"
    local last_backup_file="${BACKUP_DIR}/.last_backup"
    local last_backup_time=""
    
    if [ -f "$last_backup_file" ]; then
        last_backup_time=$(cat "$last_backup_file")
    else
        # Se não houver backup anterior, fazer backup completo
        last_backup_time="1970-01-01T00:00:00Z"
    fi
    
    log_info "Backup incremental desde: $last_backup_time"
    
    # Lista de recursos para backup
    local resources=("Patient" "Observation" "Encounter" "Condition" 
                    "MedicationRequest" "AllergyIntolerance" "Procedure")
    
    for resource in "${resources[@]}"; do
        log_info "Backing up ${resource}..."
        
        local page=1
        local has_next=true
        
        while [ "$has_next" = "true" ]; do
            local response=$(curl -s \
                "${FHIR_BASE_URL}/${resource}?_lastUpdated=gt${last_backup_time}&_count=100&_page=${page}" \
                -H "Accept: application/fhir+json")
            
            # Salvar bundle
            echo "$response" | jq '.' > "${backup_path}/data/${resource}_page${page}.json"
            
            # Verificar se há próxima página
            has_next=$(echo "$response" | jq -r '.link[]? | select(.relation=="next") | .url' | wc -l)
            [ "$has_next" -gt 0 ] && has_next=true || has_next=false
            
            ((page++))
        done
    done
    
    # Atualizar timestamp do último backup
    date -u '+%Y-%m-%dT%H:%M:%SZ' > "$last_backup_file"
    
    log_info "Backup incremental concluído"
}

# Backup de metadados e configurações
backup_metadata() {
    local backup_path="$1"
    
    log_info "Salvando metadados..."
    
    # CapabilityStatement
    curl -s "${FHIR_BASE_URL}/metadata" \
        -H "Accept: application/fhir+json" \
        > "${backup_path}/metadata/capability-statement.json"
    
    # StructureDefinitions
    curl -s "${FHIR_BASE_URL}/StructureDefinition" \
        -H "Accept: application/fhir+json" \
        > "${backup_path}/metadata/structure-definitions.json"
    
    # ValueSets
    curl -s "${FHIR_BASE_URL}/ValueSet" \
        -H "Accept: application/fhir+json" \
        > "${backup_path}/metadata/value-sets.json"
    
    # CodeSystems
    curl -s "${FHIR_BASE_URL}/CodeSystem" \
        -H "Accept: application/fhir+json" \
        > "${backup_path}/metadata/code-systems.json"
    
    log_info "Metadados salvos"
}

# Compressão e criptografia
compress_and_encrypt() {
    local backup_path="$1"
    local archive_name="$(basename "$backup_path").tar.gz.enc"
    local archive_path="${BACKUP_DIR}/${archive_name}"
    
    log_info "Comprimindo backup..."
    tar -czf - -C "$(dirname "$backup_path")" "$(basename "$backup_path")" | \
        openssl enc -aes-256-cbc -salt -pass file:"$ENCRYPTION_KEY" \
        > "$archive_path"
    
    # Calcular checksum
    sha256sum "$archive_path" > "${archive_path}.sha256"
    
    # Remover diretório não comprimido
    rm -rf "$backup_path"
    
    echo "$archive_path"
}

# Upload para S3
upload_to_s3() {
    local archive_path="$1"
    
    log_info "Enviando para S3: ${S3_BUCKET}"
    
    aws s3 cp "$archive_path" "${S3_BUCKET}/" \
        --storage-class GLACIER_IR \
        --server-side-encryption AES256 \
        --metadata "backup-date=$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    
    aws s3 cp "${archive_path}.sha256" "${S3_BUCKET}/"
    
    log_info "Upload concluído"
}

# Limpeza de backups antigos
cleanup_old_backups() {
    log_info "Removendo backups antigos (>${RETENTION_DAYS} dias)..."
    
    # Limpar backups locais
    find "$BACKUP_DIR" -name "*.tar.gz.enc" -mtime +${RETENTION_DAYS} -delete
    
    # Limpar backups S3
    aws s3 ls "${S3_BUCKET}/" | while read -r line; do
        create_date=$(echo "$line" | awk '{print $1" "$2}')
        create_date_seconds=$(date -d "$create_date" +%s)
        current_date_seconds=$(date +%s)
        age_days=$(( ($current_date_seconds - $create_date_seconds) / 86400 ))
        
        if [ $age_days -gt $RETENTION_DAYS ]; then
            file_name=$(echo "$line" | awk '{print $4}')
            aws s3 rm "${S3_BUCKET}/${file_name}"
            log_info "Removido do S3: $file_name"
        fi
    done
}

# Validação de backup
validate_backup() {
    local archive_path="$1"
    
    log_info "Validando backup..."
    
    # Verificar checksum
    if ! sha256sum -c "${archive_path}.sha256" > /dev/null 2>&1; then
        log_error "Falha na validação do checksum"
        return 1
    fi
    
    # Testar descompressão
    local test_dir=$(mktemp -d)
    if ! openssl enc -aes-256-cbc -d -pass file:"$ENCRYPTION_KEY" < "$archive_path" | \
         tar -tzf - > /dev/null 2>&1; then
        log_error "Falha ao testar descompressão"
        rm -rf "$test_dir"
        return 1
    fi
    rm -rf "$test_dir"
    
    log_info "Backup validado com sucesso"
    return 0
}

# Função principal
main() {
    log_info "=== Iniciando backup FHIR ==="
    
    # Verificar pré-requisitos
    for cmd in curl jq tar openssl aws; do
        if ! command -v $cmd &> /dev/null; then
            log_error "Comando $cmd não encontrado"
            exit 1
        fi
    done
    
    # Criar estrutura de backup
    local backup_path=$(create_backup_structure)
    
    # Escolher estratégia de backup
    if [ "${BACKUP_TYPE:-incremental}" = "full" ]; then
        perform_bulk_export "$backup_path" || exit 1
    else
        perform_incremental_backup "$backup_path" || exit 1
    fi
    
    # Backup de metadados
    backup_metadata "$backup_path"
    
    # Comprimir e criptografar
    local archive_path=$(compress_and_encrypt "$backup_path")
    
    # Validar backup
    validate_backup "$archive_path" || exit 1
    
    # Upload para S3
    upload_to_s3 "$archive_path"
    
    # Limpeza
    cleanup_old_backups
    
    log_info "=== Backup FHIR concluído com sucesso ==="
}

# Executar se não estiver sendo importado
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
```

### 6.2 Procedimento de Recuperação

```bash
#!/bin/bash
# fhir-restore.sh - Script de recuperação para FHIR Server

# Configurações
FHIR_BASE_URL="${FHIR_BASE_URL:-http://localhost:8080/fhir}"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/fhir}"
S3_BUCKET="${S3_BUCKET:-s3://company-fhir-backups}"
ENCRYPTION_KEY="${ENCRYPTION_KEY:-/etc/fhir/backup.key}"
RESTORE_DIR="${RESTORE_DIR:-/tmp/fhir-restore}"
LOG_FILE="${LOG_FILE:-/var/log/fhir-restore.log}"

# Funções de logging
log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" | tee -a "$LOG_FILE" >&2
}

# Listar backups disponíveis
list_available_backups() {
    echo "=== Backups Locais ==="
    ls -lh "${BACKUP_DIR}"/*.tar.gz.enc 2>/dev/null || echo "Nenhum backup local encontrado"
    
    echo -e "\n=== Backups S3 ==="
    aws s3 ls "${S3_BUCKET}/" --human-readable --summarize | grep ".tar.gz.enc"
}

# Download do backup do S3
download_from_s3() {
    local backup_name="$1"
    local local_path="${BACKUP_DIR}/${backup_name}"
    
    log_info "Baixando backup do S3: $backup_name"
    
    aws s3 cp "${S3_BUCKET}/${backup_name}" "$local_path"
    aws s3 cp "${S3_BUCKET}/${backup_name}.sha256" "${local_path}.sha256"
    
    echo "$local_path"
}

# Descomprimir e descriptografar
decompress_and_decrypt() {
    local archive_path="$1"
    
    log_info "Verificando integridade do arquivo..."
    if ! sha256sum -c "${archive_path}.sha256"; then
        log_error "Checksum inválido"
        return 1
    fi
    
    log_info "Descriptografando e descomprimindo..."
    mkdir -p "$RESTORE_DIR"
    
    openssl enc -aes-256-cbc -d -pass file:"$ENCRYPTION_KEY" < "$archive_path" | \
        tar -xzf - -C "$RESTORE_DIR"
    
    # Retornar o diretório extraído
    local extracted_dir=$(ls -d "${RESTORE_DIR}"/*/ | head -n1)
    echo "$extracted_dir"
}

# Restaurar recursos no FHIR Server
restore_resources() {
    local restore_path="$1"
    local data_dir="${restore_path}/data"
    
    log_info "Iniciando restauração de recursos..."
    
    # Verificar se servidor está acessível
    if ! curl -s "${FHIR_BASE_URL}/metadata" > /dev/null; then
        log_error "FHIR Server não está acessível"
        return 1
    fi
    
    # Processar arquivos de dados
    for data_file in "${data_dir}"/*.json; do
        [ -f "$data_file" ] || continue
        
        local filename=$(basename "$data_file")
        log_info "Restaurando: $filename"
        
        # Verificar se é um Bundle
        local resource_type=$(jq -r '.resourceType' "$data_file")
        
        if [ "$resource_type" = "Bundle" ]; then
            # Restaurar Bundle
            restore_bundle "$data_file"
        else
            # Restaurar recurso individual
            restore_single_resource "$data_file"
        fi
    done
    
    log_info "Restauração de recursos concluída"
}

# Restaurar Bundle
restore_bundle() {
    local bundle_file="$1"
    
    # Converter para transaction bundle se necessário
    local bundle_type=$(jq -r '.type' "$bundle_file")
    
    if [ "$bundle_type" != "transaction" ] && [ "$bundle_type" != "batch" ]; then
        log_info "Convertendo para transaction bundle..."
        
        jq '.type = "transaction" | 
            .entry[]?.request = {
                method: "PUT",
                url: (.resource.resourceType + "/" + .resource.id)
            }' "$bundle_file" > "${bundle_file}.transaction"
        
        bundle_file="${bundle_file}.transaction"
    fi
    
    # Enviar Bundle para o servidor
    local response=$(curl -X POST \
        "${FHIR_BASE_URL}/" \
        -H "Content-Type: application/fhir+json" \
        -d "@${bundle_file}" \
        -s -w "\n%{http_code}")
    
    local http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
        log_info "Bundle restaurado com sucesso"
        
        # Contar recursos restaurados
        local count=$(echo "$response" | head -n-1 | jq '.entry | length')
        log_info "Recursos restaurados: $count"
    else
        log_error "Falha ao restaurar bundle: HTTP $http_code"
        echo "$response" | head -n-1 | jq '.' >> "$LOG_FILE"
        return 1
    fi
}

# Restaurar recurso individual
restore_single_resource() {
    local resource_file="$1"
    
    local resource_type=$(jq -r '.resourceType' "$resource_file")
    local resource_id=$(jq -r '.id' "$resource_file")
    
    if [ "$resource_id" = "null" ] || [ -z "$resource_id" ]; then
        # POST se não houver ID
        local response=$(curl -X POST \
            "${FHIR_BASE_URL}/${resource_type}" \
            -H "Content-Type: application/fhir+json" \
            -d "@${resource_file}" \
            -s -w "\n%{http_code}")
    else
        # PUT se houver ID
        local response=$(curl -X PUT \
            "${FHIR_BASE_URL}/${resource_type}/${resource_id}" \
            -H "Content-Type: application/fhir+json" \
            -d "@${resource_file}" \
            -s -w "\n%{http_code}")
    fi
    
    local http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
        log_info "Recurso restaurado: ${resource_type}/${resource_id}"
    else
        log_error "Falha ao restaurar: ${resource_type}/${resource_id} (HTTP $http_code)"
        return 1
    fi
}

# Validação pós-restauração
validate_restoration() {
    local restore_path="$1"
    
    log_info "Validando restauração..."
    
    local total_resources=0
    local validated_resources=0
    
    # Contar recursos no backup
    for data_file in "${restore_path}/data"/*.json; do
        [ -f "$data_file" ] || continue
        
        local resource_type=$(jq -r '.resourceType' "$data_file")
        
        if [ "$resource_type" = "Bundle" ]; then
            local count=$(jq '.entry | length' "$data_file")
            total_resources=$((total_resources + count))
            
            # Verificar cada recurso do bundle
            jq -r '.entry[]?.resource | "\(.resourceType)/\(.id)"' "$data_file" | \
            while read resource_ref; do
                if curl -s "${FHIR_BASE_URL}/${resource_ref}" > /dev/null; then
                    ((validated_resources++))
                fi
            done
        else
            ((total_resources++))
            local resource_id=$(jq -r '.id' "$data_file")
            
            if curl -s "${FHIR_BASE_URL}/${resource_type}/${resource_id}" > /dev/null; then
                ((validated_resources++))
            fi
        fi
    done
    
    log_info "Recursos validados: ${validated_resources}/${total_resources}"
    
    if [ "$validated_resources" -eq "$total_resources" ]; then
        log_info "Validação completa com sucesso"
        return 0
    else
        log_error "Alguns recursos não foram restaurados corretamente"
        return 1
    fi
}

# Função principal de restauração
main() {
    log_info "=== Iniciando recuperação FHIR ==="
    
    # Listar backups disponíveis
    list_available_backups
    
    # Selecionar backup para restaurar
    echo -e "\nDigite o nome do arquivo de backup para restaurar:"
    read backup_file
    
    # Verificar se é backup S3
    if [[ ! -f "${BACKUP_DIR}/${backup_file}" ]]; then
        log_info "Backup não encontrado localmente, tentando S3..."
        archive_path=$(download_from_s3 "$backup_file")
    else
        archive_path="${BACKUP_DIR}/${backup_file}"
    fi
    
    # Descomprimir e descriptografar
    restore_path=$(decompress_and_decrypt "$archive_path")
    
    # Confirmar restauração
    echo -e "\n⚠️  ATENÇÃO: Isso irá restaurar dados no servidor FHIR."
    echo "Servidor: ${FHIR_BASE_URL}"
    echo "Continuar? (yes/no)"
    read confirmation
    
    if [ "$confirmation" != "yes" ]; then
        log_info "Restauração cancelada pelo usuário"
        exit 0
    fi
    
    # Restaurar recursos
    restore_resources "$restore_path"
    
    # Validar restauração
    validate_restoration "$restore_path"
    
    # Limpar arquivos temporários
    rm -rf "$RESTORE_DIR"
    
    log_info "=== Recuperação FHIR concluída ==="
}

# Executar se não estiver sendo importado
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
```

### 6.3 Monitoramento e Alertas

```javascript
// monitoring/backupMonitor.js
const cron = require('node-cron');
const nodemailer = require('nodemailer');
const { S3Client, ListObjectsV2Command } = require('@aws-sdk/client-s3');

class BackupMonitor {
  constructor(config) {
    this.config = config;
    this.s3Client = new S3Client({ region: config.awsRegion });
    this.mailer = nodemailer.createTransport(config.smtp);
    
    this.setupMonitoring();
  }
  
  setupMonitoring() {
    // Verificar backups diariamente
    cron.schedule('0 9 * * *', () => {
      this.checkBackupStatus();
    });
    
    // Teste de recuperação mensal
    cron.schedule('0 0 1 * *', () => {
      this.performRecoveryTest();
    });
  }
  
  async checkBackupStatus() {
    console.log('Verificando status dos backups...');
    
    const alerts = [];
    
    // Verificar último backup
    const lastBackup = await this.getLastBackupTime();
    const hoursSinceBackup = (Date.now() - lastBackup) / (1000 * 60 * 60);
    
    if (hoursSinceBackup > 24) {
      alerts.push({
        severity: 'HIGH',
        message: `Último backup há ${Math.round(hoursSinceBackup)} horas`
      });
    }
    
    // Verificar integridade
    const integrityCheck = await this.verifyBackupIntegrity();
    if (!integrityCheck.success) {
      alerts.push({
        severity: 'CRITICAL',
        message: `Falha na verificação de integridade: ${integrityCheck.error}`
      });
    }
    
    // Verificar espaço em disco
    const diskSpace = await this.checkDiskSpace();
    if (diskSpace.percentUsed > 80) {
      alerts.push({
        severity: 'MEDIUM',
        message: `Espaço em disco: ${diskSpace.percentUsed}% usado`
      });
    }
    
    // Enviar alertas
    if (alerts.length > 0) {
      await this.sendAlerts(alerts);
    }
  }
  
  async getLastBackupTime() {
    const command = new ListObjectsV2Command({
      Bucket: this.config.s3Bucket,
      Prefix: 'fhir-backups/',
      MaxKeys: 1
    });
    
    const response = await this.s3Client.send(command);
    
    if (response.Contents && response.Contents.length > 0) {
      return response.Contents[0].LastModified.getTime();
    }
    
    return 0;
  }
  
  async verifyBackupIntegrity() {
    // Implementar verificação de checksum
    try {
      // Verificar último backup
      const lastBackup = await this.getLatestBackup();
      
      // Baixar e verificar checksum
      const checksumValid = await this.verifyChecksum(lastBackup);
      
      return {
        success: checksumValid,
        backup: lastBackup,
        timestamp: new Date()
      };
    } catch (error) {
      return {
        success: false,
        error: error.message
      };
    }
  }
  
  async performRecoveryTest() {
    console.log('Iniciando teste de recuperação...');
    
    const testResult = {
      timestamp: new Date(),
      success: false,
      metrics: {}
    };
    
    try {
      const startTime = Date.now();
      
      // 1. Selecionar backup para teste
      const testBackup = await this.selectTestBackup();
      
      // 2. Restaurar em ambiente de teste
      const restoreResult = await this.restoreToTestEnvironment(testBackup);
      
      // 3. Validar dados restaurados
      const validationResult = await this.validateRestoredData();
      
      // 4. Calcular métricas
      testResult.metrics = {
        recoveryTime: Date.now() - startTime,
        dataIntegrity: validationResult.integrityScore,
        resourcesRestored: validationResult.resourceCount,
        validationErrors: validationResult.errors
      };
      
      testResult.success = validationResult.success;
      
      // 5. Gerar relatório
      await this.generateRecoveryTestReport(testResult);
      
    } catch (error) {
      testResult.error = error.message;
      await this.sendAlerts([{
        severity: 'CRITICAL',
        message: `Teste de recuperação falhou: ${error.message}`
      }]);
    }
    
    return testResult;
  }
  
  async sendAlerts(alerts) {
    const htmlContent = this.generateAlertHTML(alerts);
    
    await this.mailer.sendMail({
      from: this.config.alertFrom,
      to: this.config.alertTo