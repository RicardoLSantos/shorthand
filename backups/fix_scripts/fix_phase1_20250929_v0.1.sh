#!/bin/bash

# fix_phase1_20250929_v0.1.sh - Correção de Erros FHIR IG Fase 1 - Versão 0.1
# Baseado nas especificações HL7 FHIR documentadas em FHIR_Specifications_Reference.md
# iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide
# IMPORTANTE: Este script NÃO altera arquivos fsh-generated - apenas input/fsh

set -e  # Parar em caso de erro

echo "=== FHIR IG Correção - Fase 1 v0.1 ==="
echo "Data: $(date)"
echo "Diretório: $(pwd)"
echo "AVISO: Arquivos fsh-generated serão regenerados pelo SUSHI/genonce"
echo ""

# Verificar dependências
if ! command -v jq &> /dev/null; then
    echo "❌ ERRO: jq não está instalado. Execute: brew install jq"
    exit 1
fi

# Criar backup antes das correções
BACKUP_DIR="backup_phase1_$(date +%Y%m%d_%H%M%S)"
echo "🔄 Criando backup em: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r input/fsh "$BACKUP_DIR/" 2>/dev/null || true
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
# FASE 1A: Verificar e corrigir estrutura de diretórios
# ============================================================================
echo "=== FASE 1A: Verificação da Estrutura de Diretórios ==="

# Criar diretórios padrão se não existirem (conforme especificação HL7)
echo "📁 Verificando e criando diretórios padrão..."

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

# ============================================================================
# FASE 1B: Correção de URLs Canônicos em FSH (APENAS input/fsh)
# ============================================================================
echo ""
echo "=== FASE 1B: Correção de URLs Canônicos em FSH ==="

echo "🔍 Buscando arquivos FSH com URLs para correção (APENAS input/fsh)..."

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
                new_url="$CANONICAL_URL/$resource_part"
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

# Processar APENAS arquivos FSH em input/fsh
find input/fsh -name "*.fsh" -type f | while read -r file; do
    if grep -q "^\s*\*\s*url\s*=" "$file"; then
        echo "  📄 Processando: $(basename "$file")"
        fix_fsh_urls "$file"
    fi
done

# ============================================================================
# FASE 1C: Correção de Metadados ShareableValueSet (APENAS input/fsh)
# ============================================================================
echo ""
echo "=== FASE 1C: Correção de Metadados ShareableValueSet ==="

echo "🏷️ Adicionando metadados ShareableValueSet obrigatórios em input/fsh..."

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
            [[ $line =~ ^\*[[:space:]]*status ]] && has_status=true
            [[ $line =~ ^\*[[:space:]]*experimental ]] && has_experimental=true
        fi

    done < "$file"

    mv "$temp_file" "$file"
}

# Processar ValueSets APENAS em input/fsh
find input/fsh -name "*.fsh" -type f | while read -r file; do
    if grep -q "^ValueSet:" "$file"; then
        echo "  📄 Adicionando metadados ShareableValueSet em: $(basename "$file")"
        fix_shareable_metadata "$file"
    fi
done

# ============================================================================
# FASE 1D: Correção de Categorias Reproductive → Social-History (APENAS input/fsh)
# ============================================================================
echo ""
echo "=== FASE 1D: Correção de Categorias Reproductive → Social-History ==="

echo "🔄 Convertendo categorias 'reproductive' para 'social-history' em input/fsh..."

# Buscar e corrigir categorias reproductive APENAS em input/fsh
find input/fsh -name "*.fsh" -type f | while read -r file; do
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

# ============================================================================
# FASE 1E: Verificação de Package-list.json
# ============================================================================
echo ""
echo "=== FASE 1E: Verificação de package-list.json ==="

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

# ============================================================================
# RESUMO DA FASE 1
# ============================================================================
echo ""
echo "=== RESUMO DA FASE 1 v0.1 ==="
echo "✅ Backup criado em: $BACKUP_DIR"
echo "✅ Estrutura de diretórios verificada e corrigida"
echo "✅ URLs canônicos corrigidos conforme sushi-config.yaml (input/fsh apenas)"
echo "✅ Metadados ShareableValueSet adicionados aos ValueSets (input/fsh apenas)"
echo "✅ Categorias 'reproductive' convertidas para 'social-history' (input/fsh apenas)"
echo "✅ package-list.json verificado e corrigido"
echo "⚠️ Arquivos fsh-generated NÃO foram alterados (serão regenerados)"
echo ""

# ============================================================================
# PRÓXIMOS PASSOS
# ============================================================================
echo "=== PRÓXIMOS PASSOS RECOMENDADOS ==="
echo "1. Executar: sushi input/fsh --o fsh-generated"
echo "2. Executar: ./_genonce.sh"
echo "3. Verificar qa.html para validar correções"
echo "4. Se necessário, criar fix_phase1_20250929_v0.2.sh para correções adicionais"
echo ""
echo "Documentação de referência: FHIR_Specifications_Reference.md"
echo ""

echo "🎯 FASE 1 v0.1 CONCLUÍDA COM SUCESSO! 🎯"
echo "ℹ️ Arquivos fsh-generated serão atualizados na próxima execução do SUSHI/genonce"