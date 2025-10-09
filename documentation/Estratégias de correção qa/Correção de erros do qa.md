# Correção de Erros em HL7 FHIR Implementation Guides

Este guia técnico abrangente fornece soluções práticas e comandos específicos para correção sistemática de erros em HL7 FHIR Implementation Guides, otimizado para macOS e seguindo rigorosamente especificações oficiais HL7.

## Especificações oficiais para códigos de observation-category

**Sistema oficial**: `http://terminology.hl7.org/CodeSystem/observation-category`

### Categorias válidas R4 padrão

```json
{
  "coding": [{
    "system": "http://terminology.hl7.org/CodeSystem/observation-category",
    "code": "laboratory",
    "display": "Laboratory"
  }]
}
```

**Lista completa de categorias válidas**:
- `laboratory` - Resultados laboratoriais (química, hematologia, sorologia, histologia)
- `vital-signs` - Sinais vitais (pressão arterial, frequência cardíaca, temperatura, peso)
- `imaging` - Observações de imagem (raio-X, ultrassom, CT, MRI, angiografia)
- `social-history` - História social (ocupacional, pessoal, estilo de vida, familiar)
- `procedure` - Observações de procedimentos (intervencionais e não-intervencionais)
- `survey` - Instrumentos de avaliação (Scores Apgar, Avaliação Cognitiva Montreal)
- `exam` - Achados de exame físico (observações diretas, instrumentos simples)
- `therapy` - Observações de terapia (ocupacional, física, radiação, nutricional)
- `activity` - Observações de atividade (atividade corporal, fitness, bem-estar)

### Criação de categorias customizadas

**Método 1: Extensão do ValueSet padrão**
```json
{
  "resourceType": "ValueSet",
  "url": "http://example.org/fhir/ValueSet/custom-observation-categories",
  "compose": {
    "include": [
      {"valueSet": ["http://hl7.org/fhir/ValueSet/observation-category"]},
      {
        "system": "http://example.org/fhir/CodeSystem/custom-categories",
        "concept": [{"code": "environmental", "display": "Monitoramento Ambiental"}]
      }
    ]
  }
}
```

## Resolução do erro "Unknown code '150'"

**Problema identificado**: O código "150" refere-se ao padrão UN M49, não ISO 3166-1.

### Solução correta para código "150" (Europa)

```json
{
  "jurisdiction": [{
    "coding": [{
      "system": "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code": "150",
      "display": "Europe"
    }]
  }]
}
```

### Sistemas de códigos de jurisdição válidos

1. **ISO 3166-1**: `urn:iso:std:iso:3166` (códigos de país: BR, DE, US)
2. **UN M49**: `http://unstats.un.org/unsd/methods/m49/m49.htm` (códigos regionais: 150=Europa, 001=Mundo)
3. **ISO 3166-2**: `urn:iso:std:iso:3166:-2` (códigos de subdivisão de país)

## Validação de códigos LOINC e SNOMED-CT

### Especificações LOINC

**URI oficial**: `http://loinc.org`

**Servidor de terminologia LOINC**: `https://fhir.loinc.org/`

**Aviso de copyright obrigatório**:
```xml
<copyright value="This material contains content from LOINC (http://loinc.org). LOINC® is available at no cost under the license at http://loinc.org/license."/>
```

**Validação com FHIR Validator**:
```bash
java -jar validator_cli.jar resource.json -tx https://fhir.loinc.org/ -txLog loinc-validation.log
```

### Especificações SNOMED-CT

**URI oficial**: `http://snomed.info/sct`

**URI específica por edição**:
```
http://snomed.info/sct/[sctid]/version/[YYYYMMDD]
```

**Edições comuns**:
- Internacional: `900000000000207008`
- EUA: `731000124108`
- Reino Unido: `999000041000000102`

**Validação com edição específica**:
```bash
java -jar validator_cli.jar resource.json -sct intl -tx tx.fhir.org
```

## Configuração do ignoreWarnings.txt

### Localização e formato

**Arquivo**: `input/ignoreWarnings.txt` ou `[project-root]/ignoreWarnings.txt`

```
== Suppressed Messages ==
# Sistemas de códigos externos não suportados pelo servidor de terminologia
Code System URI 'http://www.ama-assn.org/go/cpt' is unknown so the code cannot be validated

# Links quebrados que serão resolvidos no pós-processamento
The link 'history.html' for "History" cannot be resolved

# Aprovação de variação em CGP call 12-03-2020 - Eric Haas/Floyd Eisenberg: 8-0-0
%WARNING: StructureDefinition.where(url = 'http://example.org/StructureDefinition/custom-profile')%
```

### Opções de correspondência de mensagens

- **Correspondência exata**: Comparação case-insensitive da mensagem completa
- **Correspondência parcial**: Use `%` no início e/ou fim (`%error` ou `message%`)
- **ID da mensagem**: Use ID interno do arquivo qa.html

## Scripts e ferramentas oficiais HL7 para automatização

### Scripts do IG Publisher (repositório oficial HL7/ig-publisher-scripts)

**_updatePublisher.sh** - Baixa/atualiza IG Publisher:
```bash
#!/bin/sh
set -e

check_online() {
    curl -s --connect-timeout 10 "https://tx.fhir.org/r4/metadata" > /dev/null 2>&1
}

download_publisher() {
    local cache_dir="${1:-input-cache}"
    mkdir -p "$cache_dir"
    curl -L "https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar" \
         -o "$cache_dir/publisher.jar"
}

if check_online; then
    download_publisher
    echo "Publisher atualizado com sucesso"
fi
```

**_genonce.sh** - Executa build único:
```bash
#!/bin/sh
java -Xmx4g -jar input-cache/publisher.jar -ig .
```

### Configuração do FHIR Validator

**Parâmetros essenciais para QA**:
```bash
java -jar validator_cli.jar resource.json \
    -version r4 \
    -tx tx.fhir.org \
    -txLog terminology.log \
    -display-issues-are-warnings \
    -clear-tx-cache
```

**Parâmetros avançados**:
- `-resetTx`: Limpar cache de terminologia
- `-tx n/a`: Desabilitar validação de terminologia
- `-sct [edition]`: Especificar edição SNOMED-CT
- `-unknown-codesystems-cause-errors`: Tratar sistemas desconhecidos como erro

## Comandos bash para correção sistemática de arquivos (macOS)

### Script de correção de arquivos FSH

```bash
#!/bin/sh
# Correção sistemática de arquivos FSH - compatível com macOS bash 3.2.57
set -e

FSH_DIR="${1:-input/fsh}"
BACKUP_DIR="fsh-backup-$(date +%Y%m%d_%H%M%S)"

# Backup de segurança
backup_fsh_files() {
    if [ -d "$FSH_DIR" ]; then
        cp -r "$FSH_DIR" "$BACKUP_DIR"
        echo "Backup criado em: $BACKUP_DIR"
    fi
}

# Correção de sintaxe FSH
fix_fsh_syntax() {
    local file="$1"
    local temp_file=$(mktemp)
    
    # Correções usando sed compatível com macOS/BSD
    sed -e 's/[[:space:]]*$//' \
        -e 's/\t/    /g' \
        -e '/^[[:space:]]*$/N;/^\n$/d' \
        "$file" > "$temp_file"
    
    mv "$temp_file" "$file"
    echo "Corrigido: $file"
}

# Validação estrutural FSH
validate_fsh_file() {
    local file="$1"
    
    if ! grep -q "^Profile:\|^Extension:\|^ValueSet:\|^CodeSystem:" "$file"; then
        echo "Aviso: $file - Nenhuma declaração FSH encontrada"
    fi
    
    if grep -q '"""[^"]*$' "$file"; then
        echo "Erro: $file - String com três aspas não fechada"
        return 1
    fi
    
    return 0
}

# Processamento principal
backup_fsh_files

find "$FSH_DIR" -name "*.fsh" -type f | while read -r fsh_file; do
    echo "Processando: $fsh_file"
    fix_fsh_syntax "$fsh_file"
    validate_fsh_file "$fsh_file"
done

echo "Processamento FSH concluído. Execute 'sushi .' para compilar."
```

### Script de processamento de arquivos Markdown

```bash
#!/bin/sh
# Processamento em lote de arquivos Markdown para FHIR IGs - macOS compatível
set -e

PAGES_DIR="${1:-input/pagecontent}"
BACKUP_DIR="md-backup-$(date +%Y%m%d_%H%M%S)"

# Backup e configuração
setup_directories() {
    mkdir -p "$BACKUP_DIR"
    if [ -d "$PAGES_DIR" ]; then
        cp -r "$PAGES_DIR" "$BACKUP_DIR/"
    fi
}

# Correção de formatação markdown
fix_markdown_formatting() {
    local file="$1"
    local temp_file=$(mktemp)
    
    sed -e 's/[[:space:]]*$//' \
        -e 's/\t/    /g' \
        -e 's/–/-/g' \
        -e 's/—/--/g' \
        -e 's/'/'"'"'/g' \
        -e 's/'/'"'"'/g' \
        "$file" > "$temp_file"
    
    mv "$temp_file" "$file"
}

# Adicionar front matter FHIR
add_fhir_frontmatter() {
    local file="$1"
    local basename=$(basename "$file" .md)
    local temp_file=$(mktemp)
    
    if ! head -n1 "$file" | grep -q "^---"; then
        cat > "$temp_file" << EOF
---
title: $basename
layout: default
active: $basename
---

EOF
        cat "$file" >> "$temp_file"
        mv "$temp_file" "$file"
        echo "Front matter adicionado a: $file"
    fi
}

# Processamento principal
setup_directories

find "$PAGES_DIR" -name "*.md" -type f | while read -r md_file; do
    echo "Processando: $md_file"
    fix_markdown_formatting "$md_file"
    add_fhir_frontmatter "$md_file"
done

echo "Backup dos arquivos originais em: $BACKUP_DIR"
```

### Workflow completo de automação

```bash
#!/bin/sh
# Workflow completo de automação FHIR IG - macOS compatível
set -e

PROJECT_DIR="${1:-$(pwd)}"
LOG_FILE="fhir-ig-automation.log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

error_exit() {
    log "ERRO: $1"
    exit 1
}

# Verificar pré-requisitos
check_prerequisites() {
    log "Verificando pré-requisitos..."
    
    command -v java > /dev/null || error_exit "Java não encontrado"
    command -v node > /dev/null || error_exit "Node.js não encontrado"
    
    if ! command -v sushi > /dev/null; then
        log "Instalando SUSHI..."
        npm install -g fsh-sushi || error_exit "Falha ao instalar SUSHI"
    fi
}

# Atualizar IG Publisher
update_publisher() {
    log "Atualizando IG Publisher..."
    mkdir -p input-cache
    curl -L "https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar" \
         -o input-cache/publisher.jar || error_exit "Falha ao baixar IG Publisher"
}

# Processar arquivos FSH
process_fsh() {
    log "Processando arquivos FSH..."
    if [ -d "input/fsh" ]; then
        sushi . || error_exit "Compilação SUSHI falhou"
    fi
}

# Construir IG
build_ig() {
    log "Construindo Implementation Guide..."
    java -Xmx4g -jar input-cache/publisher.jar -ig . || error_exit "Build do IG falhou"
}

# Gerar relatório QA
generate_qa_report() {
    log "Gerando relatório QA..."
    local qa_file="qa-report-$TIMESTAMP.txt"
    
    {
        echo "Relatório de QA FHIR IG"
        echo "Gerado: $(date)"
        echo "======================="
        echo
        echo "Contadores de arquivos:"
        echo "- Arquivos FSH: $(find input/fsh -name "*.fsh" 2>/dev/null | wc -l || echo 0)"
        echo "- Arquivos Markdown: $(find input/pagecontent -name "*.md" 2>/dev/null | wc -l || echo 0)"
        
        if [ -f "output/qa.html" ]; then
            echo "- Resultados QA disponíveis em: output/qa.html"
        fi
        
    } > "$qa_file"
    
    log "Relatório QA gerado: $qa_file"
}

# Workflow principal
main() {
    log "Iniciando workflow de automação FHIR IG"
    
    cd "$PROJECT_DIR" || error_exit "Não foi possível acessar: $PROJECT_DIR"
    
    check_prerequisites
    update_publisher
    process_fsh
    build_ig
    generate_qa_report
    
    log "Workflow concluído com sucesso"
    echo "Logs disponíveis em: $LOG_FILE"
    echo "Output disponível em: output/"
}

main "$@"
```

## Especificações para ValueSets e CodeSystems customizados

### Estrutura correta de ValueSet

```json
{
  "resourceType": "ValueSet",
  "url": "http://example.org/fhir/ValueSet/exemplo",
  "version": "1.0.0",
  "name": "ExemploValueSet",
  "status": "active",
  "compose": {
    "include": [{
      "system": "http://example.org/fhir/CodeSystem/exemplo-codes",
      "concept": [
        {"code": "code1", "display": "Código 1"},
        {"code": "code2", "display": "Código 2"}
      ]
    }]
  }
}
```

### Estrutura correta de CodeSystem

```json
{
  "resourceType": "CodeSystem",
  "url": "http://example.org/fhir/CodeSystem/exemplo-codes",
  "version": "1.0.0",
  "name": "ExemploCodeSystem",
  "status": "active",
  "content": "complete",
  "concept": [
    {"code": "code1", "display": "Código 1", "definition": "Primeiro código de exemplo"},
    {"code": "code2", "display": "Código 2", "definition": "Segundo código de exemplo"}
  ]
}
```

### Especificações de binding

**Forças de binding FHIR R4**:

1. **Required** - Deve usar o conjunto de valores especificado
```json
{"binding": {"strength": "required", "valueSet": "http://example.org/ValueSet/required"}}
```

2. **Extensible** - Use o conjunto especificado se aplicável, caso contrário, pode usar outros códigos
```json
{"binding": {"strength": "extensible", "valueSet": "http://example.org/ValueSet/extensible"}}
```

3. **Preferred** - Encorajado a usar o conjunto especificado
```json
{"binding": {"strength": "preferred", "valueSet": "http://example.org/ValueSet/preferred"}}
```

4. **Example** - Conjunto de valores fornece apenas exemplos
```json
{"binding": {"strength": "example", "valueSet": "http://example.org/ValueSet/example"}}
```

## Melhores práticas para correção de erros

1. **Sempre use URLs canônicas** para referências de ValueSet e CodeSystem
2. **Valide códigos de jurisdição** contra sistemas de códigos apropriados
3. **Escolha forças de binding apropriadas** baseado em requisitos de flexibilidade
4. **Documente categorias customizadas** com definições claras e orientações de uso
5. **Execute validação incremental** durante desenvolvimento para detectar problemas cedo
6. **Use terminologia oficial HL7** sempre que possível antes de criar códigos customizados

Este guia técnico fornece as especificações exatas e exemplos de código necessários para resolver erros comuns em FHIR IG relacionados a categorias de observação, códigos de jurisdição, conjuntos de valores e bindings, seguindo rigorosamente os padrões oficiais HL7 FHIR R4 e otimizado para macOS bash 3.2.57.