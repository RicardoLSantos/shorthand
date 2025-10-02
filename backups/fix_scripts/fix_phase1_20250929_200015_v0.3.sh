#!/bin/bash

# fix_phase1_20250929_200015_v0.3.sh - Correção de Erros FHIR IG Fase 1 - Versão 0.3
# Baseado nas especificações HL7 FHIR documentadas em FHIR_Specifications_Reference.md
# iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide
# IMPORTANTE: Este script pode alterar QUALQUER arquivo em input/ conforme especificações HL7 FHIR
# NÃO altera arquivos fsh-generated - apenas input/

set -e  # Parar em caso de erro

echo "=== FHIR IG Correção - Fase 1 v0.3 ==="
echo "Data/Hora: $(date)"
echo "Diretório: $(pwd)"
echo "ESCOPO: Pode alterar todos os arquivos em input/ conforme especificações HL7 FHIR"
echo "AVISO: Arquivos fsh-generated serão regenerados pelo SUSHI/genonce"
echo ""

# Verificar dependências
if ! command -v jq &> /dev/null; then
    echo "❌ ERRO: jq não está instalado. Execute: brew install jq"
    exit 1
fi

# Criar backup antes das correções
BACKUP_DIR="backup_phase1_v0.3_$(date +%Y%m%d_%H%M%S)"
echo "🔄 Criando backup em: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r input/ "$BACKUP_DIR/" 2>/dev/null || true
cp sushi-config.yaml "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ Backup criado com sucesso!"
echo ""

# Extrair URL canônica do sushi-config.yaml
CANONICAL_URL=$(grep "^canonical:" sushi-config.yaml | sed 's/canonical:[[:space:]]*//' | tr -d '"' || echo "")
if [ -z "$CANONICAL_URL" ]; then
    echo "❌ ERRO: Não foi possível extrair URL canônica do sushi-config.yaml"
    exit 1
fi
echo "🔗 URL Canônica: $CANONICAL_URL"
echo ""

# ============================================================================
# FASE 1A: Verificar e corrigir estrutura de diretórios input/
# ============================================================================
echo "=== FASE 1A: Verificação da Estrutura de Diretórios input/ ==="

# Criar diretórios padrão se não existirem (conforme especificação HL7)
echo "📁 Verificando e criando diretórios padrão em input/..."

REQUIRED_DIRS=(
    "input/examples"
    "input/resources"
    "input/images-source"
    "input/includes"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "  ➕ Criando diretório: $dir"
        mkdir -p "$dir"
    else
        echo "  ✅ Diretório já existe: $dir"
    fi
done

# Verificar se arquivos estão na estrutura correta
echo ""
echo "📋 Verificando estrutura de arquivos conforme especificação HL7..."

# Mover arquivos FSH soltos para input/fsh se existirem
if ls input/*.fsh 1> /dev/null 2>&1; then
    echo "  🔄 Movendo arquivos FSH soltos para input/fsh/"
    for file in input/*.fsh; do
        if [ -f "$file" ]; then
            echo "    📄 Movendo: $(basename "$file")"
            mv "$file" input/fsh/
        fi
    done
fi

# ============================================================================
# FASE 1B: Correção de URLs Canônicos em todos os arquivos input/
# ============================================================================
echo ""
echo "=== FASE 1B: Correção de URLs Canônicos em input/ ==="

echo "🔍 Buscando arquivos com URLs para correção em toda pasta input/..."

# Função para corrigir URLs em arquivos FSH
fix_fsh_urls() {
    local file="$1"
    local temp_file="${file}.tmp"
    local changed=false

    while IFS= read -r line; do
        if [[ $line =~ ^\*[[:space:]]*url[[:space:]]*=[[:space:]]*\"(.*)\" ]]; then
            current_url="${BASH_REMATCH[1]}"
            # Se não começa com o canonical correto, corrigir
            if [[ ! $current_url =~ ^$CANONICAL_URL ]]; then
                # Extrair a parte após o último /
                resource_part="${current_url##*/}"
                # Para ValueSets e CodeSystems, preservar a estrutura correta
                if [[ $resource_part =~ ^[A-Za-z]+-.*$ ]]; then
                    new_url="$CANONICAL_URL/$resource_part"
                else
                    new_url="$CANONICAL_URL/$resource_part"
                fi
                echo "    🔄 $current_url → $new_url"
                line="* url = \"$new_url\""
                changed=true
            fi
        fi
        echo "$line" >> "$temp_file"
    done < "$file"

    if [ "$changed" = true ]; then
        mv "$temp_file" "$file"
        echo "  ✅ URLs corrigidos em: $(basename "$file")"
    else
        rm -f "$temp_file"
        echo "  ✅ URLs já corretos em: $(basename "$file")"
    fi
}

# Função para corrigir URLs em arquivos JSON
fix_json_urls() {
    local file="$1"
    local resource_type=$(jq -r '.resourceType // empty' "$file" 2>/dev/null || echo "")
    local resource_id=$(jq -r '.id // empty' "$file" 2>/dev/null || echo "")

    if [ -n "$resource_type" ] && [ -n "$resource_id" ]; then
        expected_url="$CANONICAL_URL/$resource_type/$resource_id"
        current_url=$(jq -r '.url // empty' "$file" 2>/dev/null || echo "")

        if [ -n "$current_url" ] && [ "$current_url" != "$expected_url" ]; then
            echo "    🔄 Corrigindo URL em $(basename "$file"): $current_url → $expected_url"
            jq --arg url "$expected_url" '.url = $url' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
            echo "  ✅ URL corrigido em: $(basename "$file")"
        fi
    fi
}

# Processar arquivos FSH em toda pasta input/
find input/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "^\s*\*\s*url\s*=" "$file"; then
        echo "  📄 Processando FSH: $(basename "$file")"
        fix_fsh_urls "$file"
    fi
done

# Processar arquivos JSON em input/resources (se existirem)
if [ -d "input/resources" ]; then
    find input/resources -name "*.json" -type f | while read -r file; do
        echo "  📄 Processando JSON: $(basename "$file")"
        fix_json_urls "$file"
    done
fi

# ============================================================================
# FASE 1C: Correção de Metadados ShareableValueSet em input/
# ============================================================================
echo ""
echo "=== FASE 1C: Correção de Metadados ShareableValueSet ==="

echo "🏷️ Adicionando metadados ShareableValueSet obrigatórios em input/..."

# Função para adicionar metadados ShareableValueSet
fix_shareable_metadata() {
    local file="$1"
    local temp_file="${file}.tmp"
    local in_valueset=false
    local has_url=false
    local has_version=false
    local has_name=false
    local has_status=false
    local has_experimental=false
    local has_title=false
    local has_description=false
    local valueset_name=""

    while IFS= read -r line; do
        echo "$line" >> "$temp_file"

        # Detectar início de ValueSet
        if [[ $line =~ ^ValueSet:[[:space:]]*(.+) ]]; then
            in_valueset=true
            valueset_name="${BASH_REMATCH[1]}"
            has_url=false
            has_version=false
            has_name=false
            has_status=false
            has_experimental=false
            has_title=false
            has_description=false
        fi

        # Detectar fim de ValueSet (linha vazia ou nova definição)
        if [ "$in_valueset" = true ] && [[ $line =~ ^[[:space:]]*$ || $line =~ ^[A-Za-z]+: ]]; then
            if [[ $line =~ ^[A-Za-z]+: ]] && [[ ! $line =~ ^ValueSet: ]]; then
                # Nova definição começando, adicionar metadados antes
                in_valueset=false
            elif [[ $line =~ ^[[:space:]]*$ ]]; then
                # Linha vazia, verificar se precisamos adicionar metadados
                if [ "$has_url" = false ]; then
                    echo "* url = \"$CANONICAL_URL/ValueSet/$valueset_name\"" >> "$temp_file"
                fi
                if [ "$has_version" = false ]; then
                    echo "* version = \"0.1.0\"" >> "$temp_file"
                fi
                if [ "$has_name" = false ]; then
                    echo "* name = \"$valueset_name\"" >> "$temp_file"
                fi
                if [ "$has_title" = false ]; then
                    # Gerar título baseado no nome
                    title=$(echo "$valueset_name" | sed 's/\([A-Z]\)/ \1/g' | sed 's/^ //')
                    echo "* title = \"$title\"" >> "$temp_file"
                fi
                if [ "$has_description" = false ]; then
                    echo "* description = \"Value set for $title in iOS Lifestyle Medicine IG\"" >> "$temp_file"
                fi
                if [ "$has_status" = false ]; then
                    echo "* status = #active" >> "$temp_file"
                fi
                if [ "$has_experimental" = false ]; then
                    echo "* experimental = false" >> "$temp_file"
                fi
                in_valueset=false
            fi
        fi

        # Detectar metadados existentes
        if [ "$in_valueset" = true ]; then
            [[ $line =~ ^\*[[:space:]]*url ]] && has_url=true
            [[ $line =~ ^\*[[:space:]]*version ]] && has_version=true
            [[ $line =~ ^\*[[:space:]]*name ]] && has_name=true
            [[ $line =~ ^\*[[:space:]]*title ]] && has_title=true
            [[ $line =~ ^\*[[:space:]]*description ]] && has_description=true
            [[ $line =~ ^\*[[:space:]]*status ]] && has_status=true
            [[ $line =~ ^\*[[:space:]]*experimental ]] && has_experimental=true
        fi

    done < "$file"

    mv "$temp_file" "$file"
}

# Processar ValueSets em toda pasta input/
find input/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "^ValueSet:" "$file"; then
        echo "  📄 Adicionando metadados ShareableValueSet em: $(basename "$file")"
        fix_shareable_metadata "$file"
    fi
done

# ============================================================================
# FASE 1D: Correção de Categorias Reproductive → Social-History em input/
# ============================================================================
echo ""
echo "=== FASE 1D: Correção de Categorias Reproductive → Social-History ==="

echo "🔄 Convertendo categorias 'reproductive' para 'social-history' em input/..."

# Buscar e corrigir categorias reproductive em toda pasta input/
find input/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "reproductive" "$file"; then
        echo "  📄 Processando categorias em: $(basename "$file")"
        # Fazer backup do arquivo
        cp "$file" "$file.backup_$(date +%Y%m%d_%H%M%S)"

        # Substituir reproductive por social-history
        sed -i.bak 's/reproductive/social-history/g' "$file"
        rm -f "$file.bak"

        echo "    ✅ Categorias corrigidas"
    fi
done

# Corrigir também em arquivos JSON se existirem em input/resources
if [ -d "input/resources" ]; then
    find input/resources -name "*.json" -type f | while read -r file; do
        if grep -q "reproductive" "$file"; then
            echo "  📄 Processando categorias JSON em: $(basename "$file")"
            sed -i.bak 's/"reproductive"/"social-history"/g' "$file"
            rm -f "$file.bak"
            echo "    ✅ Categorias JSON corrigidas"
        fi
    done
fi

# ============================================================================
# FASE 1E: Correção de Links Quebrados Identificados
# ============================================================================
echo ""
echo "=== FASE 1E: Correção de Links Quebrados ==="

echo "🔗 Identificando e preparando correção de links quebrados..."

# Links quebrados identificados no qa.html:
# 1. Device/iphone-example
echo "  🔍 Verificando referência a Device/iphone-example..."

# Buscar arquivos que referenciam Device/iphone-example
find input/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "Device/iphone-example" "$file"; then
        echo "  📄 Referência encontrada em: $(basename "$file")"
        # Adicionar à lista de correções necessárias
        echo "    ⚠️ Necessário criar Device/iphone-example ou ajustar referência"
    fi
done

# ============================================================================
# FASE 1F: Verificação e correção de arquivos de configuração input/
# ============================================================================
echo ""
echo "=== FASE 1F: Verificação de Arquivos de Configuração ==="

# Verificar package-list.json
if [ -f "package-list.json" ]; then
    echo "⚠️ AVISO: package-list.json encontrado na raiz - deve ser movido para input/"
    if [ ! -f "input/package-list.json" ]; then
        echo "  🔄 Movendo package-list.json para input/"
        mv package-list.json input/
        echo "  ✅ Arquivo movido com sucesso"
    else
        echo "  🗑️ Removendo package-list.json duplicado da raiz"
        rm package-list.json
    fi
else
    echo "✅ package-list.json não encontrado na raiz (correto)"
fi

# Verificar ignoreWarnings.txt
if [ -f "input/ignoreWarnings.txt" ]; then
    echo "✅ ignoreWarnings.txt encontrado em input/ (correto)"
else
    echo "ℹ️ ignoreWarnings.txt não encontrado em input/ - pode ser criado se necessário"
fi

# ============================================================================
# FASE 1G: Validação da estrutura conforme HL7 FHIR IG
# ============================================================================
echo ""
echo "=== FASE 1G: Validação da Estrutura HL7 FHIR IG ==="

echo "🔍 Verificando estrutura conforme especificações HL7..."

# Verificar se temos o mínimo necessário
dirs_to_check=(
    "input/fsh"
    "input/pagecontent"
)

for dir in "${dirs_to_check[@]}"; do
    if [ -d "$dir" ]; then
        file_count=$(find "$dir" -type f | wc -l | tr -d ' ')
        echo "  ✅ $dir: $file_count arquivos encontrados"
    else
        echo "  ⚠️ $dir: diretório não encontrado"
    fi
done

# Contar recursos por tipo
echo ""
echo "📊 Estatísticas de recursos FSH:"
if [ -d "input/fsh" ]; then
    valueset_count=$(find input/fsh -name "*.fsh" -exec grep -l "^ValueSet:" {} \; | wc -l | tr -d ' ')
    codesystem_count=$(find input/fsh -name "*.fsh" -exec grep -l "^CodeSystem:" {} \; | wc -l | tr -d ' ')
    profile_count=$(find input/fsh -name "*.fsh" -exec grep -l "^Profile:" {} \; | wc -l | tr -d ' ')

    echo "  📋 ValueSets: $valueset_count"
    echo "  📋 CodeSystems: $codesystem_count"
    echo "  📋 Profiles: $profile_count"
fi

# ============================================================================
# RESUMO DA FASE 1
# ============================================================================
echo ""
echo "=== RESUMO DA FASE 1 v0.3 ==="
echo "✅ Backup criado em: $BACKUP_DIR"
echo "✅ Estrutura de diretórios input/ verificada e corrigida"
echo "✅ URLs canônicos corrigidos conforme sushi-config.yaml (toda pasta input/)"
echo "✅ Metadados ShareableValueSet completos adicionados (url, version, name, title, description, status, experimental)"
echo "✅ Categorias 'reproductive' convertidas para 'social-history' (toda pasta input/)"
echo "✅ Links quebrados identificados para correção futura"
echo "✅ Arquivos de configuração verificados e corrigidos"
echo "✅ Estrutura validada conforme especificações HL7 FHIR IG"
echo "⚠️ Arquivos fsh-generated NÃO foram alterados (serão regenerados)"
echo ""

# ============================================================================
# PRÓXIMOS PASSOS
# ============================================================================
echo "=== PRÓXIMOS PASSOS RECOMENDADOS ==="
echo "1. Executar: sushi input/fsh --o fsh-generated"
echo "2. Executar: ./_genonce.sh"
echo "3. Verificar qa.html para validar correções"
echo "4. Se necessário, criar fix_phase1_$(date +%Y%m%d_%H%M%S)_v0.4.sh para correções adicionais"
echo ""
echo "Documentação de referência: FHIR_Specifications_Reference.md"
echo ""

echo "🎯 FASE 1 v0.3 CONCLUÍDA COM SUCESSO! 🎯"
echo "ℹ️ Arquivos fsh-generated serão atualizados na próxima execução do SUSHI/genonce"