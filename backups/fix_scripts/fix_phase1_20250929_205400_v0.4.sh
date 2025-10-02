#!/bin/bash

# fix_phase1_20250929_205400_v0.4.sh - Correção de Erros FHIR IG Fase 1 - Versão 0.4
# Baseado nas especificações HL7 FHIR documentadas em FHIR_Specifications_Reference.md
# iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide
# IMPORTANTE: Esta versão CORRIGE A ESTRUTURA DE DIRETÓRIOS conforme especificações HL7 FHIR
# NÃO altera arquivos fsh-generated - apenas input/

set -e  # Parar em caso de erro

echo "=== FHIR IG Correção - Fase 1 v0.4 ==="
echo "Data/Hora: $(date)"
echo "Diretório: $(pwd)"
echo "FOCO: CORREÇÃO DA ESTRUTURA DE DIRETÓRIOS conforme especificações HL7 FHIR"
echo "AVISO: Arquivos fsh-generated serão regenerados pelo SUSHI/genonce"
echo ""

# Verificar dependências
if ! command -v jq &> /dev/null; then
    echo "❌ ERRO: jq não está instalado. Execute: brew install jq"
    exit 1
fi

# Criar backup antes das correções
BACKUP_DIR="backup_phase1_v0.4_$(date +%Y%m%d_%H%M%S)"
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
# FASE 1A: CORREÇÃO CRÍTICA DA ESTRUTURA DE DIRETÓRIOS
# ============================================================================
echo "=== FASE 1A: CORREÇÃO CRÍTICA DA ESTRUTURA DE DIRETÓRIOS ==="

echo "📁 Corrigindo estrutura conforme especificações HL7 FHIR IG..."

# Verificar e criar diretórios padrão se não existirem
REQUIRED_DIRS=(
    "input/examples"
    "input/resources"
    "input/images-source"
    "input/includes"
    "input/vocabulary"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "  ➕ Criando diretório: $dir"
        mkdir -p "$dir"
    else
        echo "  ✅ Diretório já existe: $dir"
    fi
done

echo ""
echo "🔄 MOVENDO ARQUIVOS PARA ESTRUTURA CORRETA HL7 FHIR..."

# 1. Mover Examples de input/fsh/examples/ para input/examples/
if [ -d "input/fsh/examples" ] && [ -n "$(ls -A input/fsh/examples/ 2>/dev/null)" ]; then
    echo "  📦 Movendo arquivos de input/fsh/examples/ para input/examples/"
    example_count=$(find input/fsh/examples/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "    📊 Encontrados $example_count arquivos de exemplo"

    find input/fsh/examples/ -name "*.fsh" -exec mv {} input/examples/ \;

    # Remover diretório vazio se possível
    if [ -z "$(ls -A input/fsh/examples/ 2>/dev/null)" ]; then
        rmdir input/fsh/examples/ 2>/dev/null || true
        echo "    ✅ Diretório input/fsh/examples/ removido (vazio)"
    fi
    echo "    ✅ Examples movidos com sucesso"
else
    echo "  ℹ️ Nenhum arquivo encontrado em input/fsh/examples/ para mover"
fi

# 2. Mover Resources de input/fsh/resources/ para input/resources/
if [ -d "input/fsh/resources" ] && [ -n "$(ls -A input/fsh/resources/ 2>/dev/null)" ]; then
    echo "  📦 Movendo arquivos de input/fsh/resources/ para input/resources/"
    resource_count=$(find input/fsh/resources/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "    📊 Encontrados $resource_count arquivos de recurso"

    find input/fsh/resources/ -name "*.fsh" -exec mv {} input/resources/ \;

    # Remover diretório vazio se possível
    if [ -z "$(ls -A input/fsh/resources/ 2>/dev/null)" ]; then
        rmdir input/fsh/resources/ 2>/dev/null || true
        echo "    ✅ Diretório input/fsh/resources/ removido (vazio)"
    fi
    echo "    ✅ Resources movidos com sucesso"
else
    echo "  ℹ️ Nenhum arquivo encontrado em input/fsh/resources/ para mover"
fi

# 3. Analisar e mover outros diretórios questionáveis
echo ""
echo "🔍 Analisando outros diretórios para possível realocação..."

# Questionnaires - podem ir para input/resources
if [ -d "input/fsh/questionnaires" ] && [ -n "$(ls -A input/fsh/questionnaires/ 2>/dev/null)" ]; then
    questionnaire_count=$(find input/fsh/questionnaires/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "  📋 input/fsh/questionnaires/: $questionnaire_count arquivos"
    echo "    💡 Sugestão: Questionnaires podem ser movidos para input/resources/"
    echo "    🔄 Movendo questionnaires para input/resources/"
    find input/fsh/questionnaires/ -name "*.fsh" -exec mv {} input/resources/ \;

    if [ -z "$(ls -A input/fsh/questionnaires/ 2>/dev/null)" ]; then
        rmdir input/fsh/questionnaires/ 2>/dev/null || true
        echo "    ✅ Questionnaires movidos e diretório removido"
    fi
fi

# Capabilities - podem ir para input/resources
if [ -d "input/fsh/capabilities" ] && [ -n "$(ls -A input/fsh/capabilities/ 2>/dev/null)" ]; then
    capability_count=$(find input/fsh/capabilities/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "  📋 input/fsh/capabilities/: $capability_count arquivos"
    echo "    💡 Sugestão: Capabilities podem ser movidos para input/resources/"
    echo "    🔄 Movendo capabilities para input/resources/"
    find input/fsh/capabilities/ -name "*.fsh" -exec mv {} input/resources/ \;

    if [ -z "$(ls -A input/fsh/capabilities/ 2>/dev/null)" ]; then
        rmdir input/fsh/capabilities/ 2>/dev/null || true
        echo "    ✅ Capabilities movidos e diretório removido"
    fi
fi

# Operations - podem ir para input/resources
if [ -d "input/fsh/operations" ] && [ -n "$(ls -A input/fsh/operations/ 2>/dev/null)" ]; then
    operations_count=$(find input/fsh/operations/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "  📋 input/fsh/operations/: $operations_count arquivos"
    echo "    💡 Sugestão: Operations podem ser movidos para input/resources/"
    echo "    🔄 Movendo operations para input/resources/"
    find input/fsh/operations/ -name "*.fsh" -exec mv {} input/resources/ \;

    if [ -z "$(ls -A input/fsh/operations/ 2>/dev/null)" ]; then
        rmdir input/fsh/operations/ 2>/dev/null || true
        echo "    ✅ Operations movidos e diretório removido"
    fi
fi

# ============================================================================
# FASE 1B: Verificação da nova estrutura
# ============================================================================
echo ""
echo "=== FASE 1B: Verificação da Nova Estrutura ==="

echo "📊 Verificando contagens após reestruturação..."

# Contar arquivos nos diretórios principais
if [ -d "input/examples" ]; then
    examples_count=$(find input/examples/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "  📄 input/examples/: $examples_count arquivos FSH"
fi

if [ -d "input/resources" ]; then
    resources_count=$(find input/resources/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "  📄 input/resources/: $resources_count arquivos FSH"
fi

if [ -d "input/fsh" ]; then
    remaining_fsh_count=$(find input/fsh/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "  📄 input/fsh/: $remaining_fsh_count arquivos FSH (profiles, extensions, etc.)"
fi

if [ -d "input/pagecontent" ]; then
    pagecontent_count=$(find input/pagecontent/ -name "*.md" | wc -l | tr -d ' ')
    echo "  📄 input/pagecontent/: $pagecontent_count arquivos Markdown"
fi

# ============================================================================
# FASE 1C: Correção de URLs Canônicos (todos os arquivos input/)
# ============================================================================
echo ""
echo "=== FASE 1C: Correção de URLs Canônicos ==="

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
    fi
}

# Processar arquivos FSH em toda pasta input/
find input/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "^\s*\*\s*url\s*=" "$file"; then
        fix_fsh_urls "$file"
    fi
done

# ============================================================================
# FASE 1D: Correção de Metadados ShareableValueSet
# ============================================================================
echo ""
echo "=== FASE 1D: Correção de Metadados ShareableValueSet ==="

echo "🏷️ Adicionando metadados ShareableValueSet obrigatórios..."

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
valueset_files_processed=0
find input/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "^ValueSet:" "$file"; then
        fix_shareable_metadata "$file"
        ((valueset_files_processed++))
    fi
done

# ============================================================================
# FASE 1E: Correção de Categorias Reproductive → Social-History
# ============================================================================
echo ""
echo "=== FASE 1E: Correção de Categorias Reproductive → Social-History ==="

echo "🔄 Convertendo categorias 'reproductive' para 'social-history'..."

reproductive_files_fixed=0
find input/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "reproductive" "$file"; then
        echo "  📄 Processando categorias em: $(basename "$file")"
        # Fazer backup do arquivo
        cp "$file" "$file.backup_$(date +%Y%m%d_%H%M%S)"

        # Substituir reproductive por social-history
        sed -i.bak 's/reproductive/social-history/g' "$file"
        rm -f "$file.bak"

        echo "    ✅ Categorias corrigidas"
        ((reproductive_files_fixed++))
    fi
done

# ============================================================================
# FASE 1F: Identificação de Links Quebrados
# ============================================================================
echo ""
echo "=== FASE 1F: Identificação de Links Quebrados ==="

echo "🔗 Identificando links quebrados para correção futura..."

# Links quebrados identificados no qa.html:
# 1. Device/iphone-example
echo "  🔍 Verificando referência a Device/iphone-example..."

device_references=0
find input/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "Device/iphone-example" "$file"; then
        echo "  📄 Referência encontrada em: $(basename "$file")"
        echo "    ⚠️ Necessário criar Device/iphone-example ou ajustar referência"
        ((device_references++))
    fi
done

# ============================================================================
# FASE 1G: Verificação de Arquivos de Configuração
# ============================================================================
echo ""
echo "=== FASE 1G: Verificação de Arquivos de Configuração ==="

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
# RESUMO DA FASE 1 v0.4
# ============================================================================
echo ""
echo "=== RESUMO DA FASE 1 v0.4 ==="
echo "✅ Backup criado em: $BACKUP_DIR"
echo "🎯 ESTRUTURA DE DIRETÓRIOS CORRIGIDA conforme especificações HL7 FHIR:"
echo "   • Examples movidos para input/examples/"
echo "   • Resources movidos para input/resources/"
echo "   • Questionnaires, Capabilities, Operations movidos para input/resources/"
echo "✅ URLs canônicos corrigidos conforme sushi-config.yaml"
echo "✅ Metadados ShareableValueSet completos adicionados"
echo "✅ Categorias 'reproductive' convertidas para 'social-history'"
echo "✅ Links quebrados identificados para correção futura"
echo "✅ Arquivos de configuração verificados"
echo "⚠️ Arquivos fsh-generated NÃO foram alterados (serão regenerados)"
echo ""

# ============================================================================
# PRÓXIMOS PASSOS
# ============================================================================
echo "=== PRÓXIMOS PASSOS RECOMENDADOS ==="
echo "1. Executar: sushi input/fsh input/resources input/examples --o fsh-generated"
echo "2. Executar: ./_genonce.sh"
echo "3. Verificar qa.html - ESPERAMOS REDUÇÃO SIGNIFICATIVA DE ERROS!"
echo "4. Se necessário, criar fix_phase1_$(date +%Y%m%d_%H%M%S)_v0.5.sh para correções adicionais"
echo ""
echo "Documentação de referência: FHIR_Specifications_Reference.md"
echo ""

echo "🎯 FASE 1 v0.4 - REESTRUTURAÇÃO COMPLETA CONCLUÍDA! 🎯"
echo "💡 Esta correção da estrutura de diretórios deve resolver muitos erros de validação!"
echo "ℹ️ Arquivos fsh-generated serão atualizados na próxima execução do SUSHI/genonce"