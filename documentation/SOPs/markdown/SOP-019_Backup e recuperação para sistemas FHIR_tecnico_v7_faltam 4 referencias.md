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
FHIR_BASE_URL="${FHIR_BASE_URL:-http://localhost:8. Google Cloud. **Disaster Recovery Planning Guide**. Disponível em: [https://cloud.google.com/architecture/dr-scenarios-planning-guide](https://cloud.google.com/architecture/dr-scenarios-planning-guide). Acesso em: 2024.

9. HIPAA Journal. **HIPAA Compliance Checklist 2024**. Disponível em: [https://www.hipaajournal.com/hipaa-compliance-checklist/](https://www.hipaajournal.com/hipaa-compliance-checklist/). Acesso em: 2024.

10. Brasil. **Lei Geral de Proteção de Dados Pessoais (LGPD) - Lei nº 13.709/2018**. Disponível em: [http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm](http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm). Acesso em: 2024.

11. European Union. **General Data Protection Regulation (GDPR) - Article 32 (Security of processing)**. Disponível em: [https://gdpr-info.eu/art-32-gdpr/](https://gdpr-info.eu/art-32-gdpr/). Acesso em: 2024.

12. OpenSSL. **OpenSSL Cryptography and SSL/TLS Toolkit Documentation**. Disponível em: [https://www.openssl.org/docs/](https://www.openssl.org/docs/). Acesso em: 2024.

---

**Histórico de Revisões:**
- v1.0.0 (2024): Versão inicial

**Aprovações:**
- Gerente de Infraestrutura: _________________
- CISO (Chief Information Security Officer): _________________
- DPO (Data Protection Officer): _________________

**Distribuição:**
- Equipe de Infraestrutura
- Equipe de Segurança
- Equipe de Operações
- Auditoria Interna080/fhir}"
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

# Função principal
main() {
    log_info "=== Iniciando backup FHIR ==="
    
    # Criar estrutura de backup
    local backup_path=$(create_backup_structure)
    
    # Escolher estratégia de backup
    if [ "${BACKUP_TYPE:-incremental}" = "full" ]; then
        perform_bulk_export "$backup_path" || exit 1
    else
        perform_incremental_backup "$backup_path" || exit 1
    fi
    
    # Comprimir e criptografar
    local archive_path=$(compress_and_encrypt "$backup_path")
    
    # Upload para S3
    upload_to_s3 "$archive_path"
    
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
            # Converter para transaction bundle se necessário
            local bundle_type=$(jq -r '.type' "$data_file")
            
            if [ "$bundle_type" != "transaction" ] && [ "$bundle_type" != "batch" ]; then
                log_info "Convertendo para transaction bundle..."
                
                jq '.type = "transaction" | 
                    .entry[]?.request = {
                        method: "PUT",
                        url: (.resource.resourceType + "/" + .resource.id)
                    }' "$data_file" > "${data_file}.transaction"
                
                data_file="${data_file}.transaction"
            fi
            
            # Enviar Bundle para o servidor
            local response=$(curl -X POST \
                "${FHIR_BASE_URL}/" \
                -H "Content-Type: application/fhir+json" \
                -d "@${data_file}" \
                -s -w "\n%{http_code}")
            
            local http_code=$(echo "$response" | tail -n1)
            
            if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
                log_info "Bundle restaurado com sucesso"
            else
                log_error "Falha ao restaurar bundle: HTTP $http_code"
            fi
        fi
    done
    
    log_info "Restauração de recursos concluída"
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
      to: this.config.alertTo,
      subject: 'FHIR Backup Alert',
      html: htmlContent
    });
  }
  
  generateAlertHTML(alerts) {
    const severityColors = {
      'CRITICAL': '#e74c3c',
      'HIGH': '#e67e22',
      'MEDIUM': '#f39c12',
      'LOW': '#95a5a6'
    };
    
    return `
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; }
          .alert { margin: 10px; padding: 15px; border-radius: 5px; }
          .critical { background-color: ${severityColors.CRITICAL}; color: white; }
          .high { background-color: ${severityColors.HIGH}; color: white; }
          .medium { background-color: ${severityColors.MEDIUM}; }
          .low { background-color: ${severityColors.LOW}; }
        </style>
      </head>
      <body>
        <h2>FHIR Backup System Alerts</h2>
        ${alerts.map(a => `
          <div class="alert ${a.severity.toLowerCase()}">
            <strong>${a.severity}:</strong> ${a.message}
          </div>
        `).join('')}
        <p>Generated: ${new Date().toISOString()}</p>
      </body>
      </html>
    `;
  }
}

module.exports = BackupMonitor;
```

## 7. MÉTRICAS E INDICADORES

### 7.1 KPIs de Backup

**Métricas Primárias**⁶:
- **Taxa de sucesso de backup**: >99% (meta: 99.9%)
- **Tempo médio de backup**: <30 minutos para backup incremental
- **Volume de dados protegidos**: 100% dos dados críticos
- **Taxa de compressão**: >60% para redução de armazenamento
- **Validação de integridade**: 100% dos backups testados

### 7.2 KPIs de Recuperação

**Indicadores de Recovery**⁷:
- **RTO alcançado vs planejado**: ±10% do objetivo
- **RPO alcançado vs planejado**: ±5% do objetivo
- **Taxa de sucesso de recuperação**: >99.5%
- **Tempo médio de recuperação (MTTR)**: <2 horas
- **Dados recuperados com sucesso**: >99.9%

### 7.3 Fórmulas de Cálculo

```javascript
// Cálculo de eficiência de backup
backupEfficiency = (originalSize - compressedSize) / originalSize * 100;

// Cálculo de disponibilidade
availability = (totalTime - downtime) / totalTime * 100;

// Cálculo de RPO real
actualRPO = currentTime - lastSuccessfulBackupTime;

// Health Score do Sistema de Backup
backupHealthScore = (
  (backupSuccessRate * 0.3) +
  (compressionRate * 0.2) +
  (validationRate * 0.3) +
  (recoveryTestSuccessRate * 0.2)
) * 100;
```

## 8. FERRAMENTAS E RECURSOS

### 8.1 Ferramentas de Backup Enterprise

1. **Veeam Backup & Replication**: Solução enterprise líder
2. **Commvault**: Plataforma de proteção de dados
3. **Veritas NetBackup**: Backup empresarial
4. **Rubrik**: Backup cloud-native
5. **Cohesity**: Gestão de dados secundários

### 8.2 Ferramentas Open Source

1. **Bacula**: Sistema de backup em rede
2. **Amanda**: Advanced Maryland Automatic Network Disk Archiver
3. **Duplicity**: Backup criptografado incremental
4. **BorgBackup**: Backup com deduplicação
5. **Restic**: Backup rápido e seguro

### 8.3 Ferramentas de Monitoramento

- **Zabbix**: Monitoramento de infraestrutura completa
- **Nagios**: Sistema de alertas e notificações
- **Datadog**: Observabilidade e APM
- **New Relic**: Monitoramento de aplicações
- **Prometheus + Grafana**: Stack de métricas

## 9. RESOLUÇÃO DE PROBLEMAS

### 9.1 Problemas Comuns e Soluções

| Problema | Causa Provável | Solução |
|----------|---------------|---------|
| Backup falha repetidamente | Espaço insuficiente | Implementar rotação automática |
| Restore muito lento | Largura de banda limitada | Usar backup local ou aumentar bandwidth |
| Checksum inválido | Corrupção durante transferência | Retentar com verificação inline |
| Chave de criptografia perdida | Gestão inadequada de chaves | Recuperar do HSM/Key Vault |
| Backup incompleto | Timeout da operação | Dividir em jobs menores |
| Falha na replicação | Latência de rede alta | Implementar replicação assíncrona |

### 9.2 Checklist de Troubleshooting

```markdown
- [ ] Verificar logs de erro detalhados
- [ ] Confirmar conectividade de rede (ping, traceroute)
- [ ] Validar credenciais e permissões (IAM, filesystem)
- [ ] Verificar espaço em disco (origem e destino)
- [ ] Testar integridade do backup anterior
- [ ] Confirmar versão do schema do banco
- [ ] Verificar status dos serviços dependentes
- [ ] Validar configuração de criptografia
- [ ] Testar restore em ambiente isolado
- [ ] Revisar políticas de retenção
```

## 10. REFERÊNCIAS

1. HL7 FHIR. **Bulk Data Access (Flat FHIR) v2.0.0**. Disponível em: [https://hl7.org/fhir/uv/bulkdata/STU2/](https://hl7.org/fhir/uv/bulkdata/STU2/). Acesso em: 2024.

2. Veeam Software. **3-2-1-1-0 Backup Best Practice Rule**. Disponível em: [https://www.veeam.com/blog/321-backup-rule.html](https://www.veeam.com/blog/321-backup-rule.html). Acesso em: 2024.

3. NIST. **Contingency Planning Guide for Federal Information Systems**. NIST SP 800-34 Rev. 1. Disponível em: [https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-34r1.pdf](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-34r1.pdf). Acesso em: 2024.

4. ISO. **ISO/IEC 27031:2011 - Information technology — Security techniques — Guidelines for ICT readiness for business continuity**. Disponível em: [https://www.iso.org/standard/44374.html](https://www.iso.org/standard/44374.html). Acesso em: 2024.

5. HL7 FHIR. **Asynchronous Request Pattern and Bulk Data Export**. Disponível em: [https://www.hl7.org/fhir/async.html](https://www.hl7.org/fhir/async.html). Acesso em: 2024.

6. AWS. **AWS Backup Best Practices and Design Patterns**. Disponível em: [https://docs.aws.amazon.com/prescriptive-guidance/latest/backup-recovery/best-practices.html](https://docs.aws.amazon.com/prescriptive-guidance/latest/backup-recovery/best-practices.html). Acesso em: 2024.

7. Microsoft Azure. **Azure Backup Service Documentation**. Disponível em: [https://docs.microsoft.com/en-us/azure/backup/backup-overview](https://docs.microsoft.com/en-us/azure/backup/backup-overview). Acesso em: 2024.

8. Google Cloud. Disaster Recovery Planning Guide. Disponível em: https://cloud.google.com/architecture/dr-scenarios-planning-guide. Acesso em: 2024.

9. HIPAA Journal. HIPAA Compliance Checklist 2024. Disponível em: https://www.hipaajournal.com/hipaa-compliance-checklist/. Acesso em: 2024.
10. Brasil. Lei Geral de Proteção de Dados Pessoais (LGPD) - Lei nº 13.709/2018. Disponível em: http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm. Acesso em: 2024.
11. European Union. General Data Protection Regulation (GDPR) - Article 32 (Security of processing). Disponível em: https://gdpr-info.eu/art-32-gdpr/. Acesso em: 2024.
12. OpenSSL. OpenSSL Cryptography and SSL/TLS Toolkit Documentation. Disponível em: https://www.openssl.org/docs/. Acesso em: 2024.
Estas são as referências que completam o documento SOP-019, abordando os aspectos de conformidade regulatória (HIPAA, LGPD, GDPR) e a documentação técnica de criptografia (OpenSSL).