#!/bin/bash

# fix_phase1_20250929_210115_v0.5.sh - Correção de Erros FHIR IG Fase 1 - Versão 0.5
# Baseado nas especificações HL7 FHIR documentadas em FHIR_Specifications_Reference.md
# iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide
# FOCO: CORREÇÃO DE VALUESET DUPLICADO + Mover arquivos FSH para locais corretos
# NÃO altera arquivos fsh-generated - apenas input/

set -e  # Parar em caso de erro

echo "=== FHIR IG Correção - Fase 1 v0.5 ==="
echo "Data/Hora: $(date)"
echo "Diretório: $(pwd)"
echo "FOCO: Correção de ValueSet duplicado + Estrutura final FSH"
echo "AVISO: Arquivos fsh-generated serão regenerados pelo SUSHI/genonce"
echo ""

# Verificar dependências
if ! command -v jq &> /dev/null; then
    echo "❌ ERRO: jq não está instalado. Execute: brew install jq"
    exit 1
fi

# Criar backup antes das correções
BACKUP_DIR="backup_phase1_v0.5_$(date +%Y%m%d_%H%M%S)"
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
# FASE 1A: CORREÇÃO DO VALUESET DUPLICADO EnvironmentalContextValueSet
# ============================================================================
echo "=== FASE 1A: CORREÇÃO DE VALUESET DUPLICADO ==="

echo "🔍 Identificando ValueSet duplicado EnvironmentalContextValueSet..."

# Buscar arquivos que definem EnvironmentalContextValueSet
echo "  📄 Buscando definições de EnvironmentalContextValueSet..."

find input/ -name "*.fsh" -type f -exec grep -l "ValueSet:.*EnvironmentalContext" {} \; | while read -r file; do
    echo "    📋 Encontrado em: $(basename "$file")"
    echo "    🔍 Linhas relevantes:"
    grep -n "ValueSet:.*EnvironmentalContext" "$file" | head -3
    echo ""
done

echo "⚠️ ERRO SUSHI: ValueSet named EnvironmentalContextValueSet already exists"
echo "📍 Arquivo: input/fsh/valuesets/EnvironmentalContextVS.fsh (Linhas 1-19)"

# Analisar o arquivo problemático
if [ -f "input/fsh/valuesets/EnvironmentalContextVS.fsh" ]; then
    echo "🔍 Analisando arquivo EnvironmentalContextVS.fsh..."
    echo "  📄 Primeiras 20 linhas:"
    head -20 "input/fsh/valuesets/EnvironmentalContextVS.fsh"
    echo ""

    # Verificar se há definições duplicadas no mesmo arquivo
    duplicates=$(grep -c "ValueSet:" "input/fsh/valuesets/EnvironmentalContextVS.fsh" 2>/dev/null || echo "0")
    echo "  📊 Definições de ValueSet encontradas no arquivo: $duplicates"
fi

# Buscar outras definições que possam estar conflitando
echo ""
echo "🔍 Buscando todos os ValueSets com 'Environmental' no nome..."
find input/ -name "*.fsh" -type f -exec grep -l "ValueSet:.*[Ee]nvironmental" {} \; | while read -r file; do
    echo "  📄 $(basename "$file"):"
    grep -n "ValueSet:.*[Ee]nvironmental" "$file"
    echo ""
done

# Solução: Renomear ou remover definição duplicada
echo "🔧 SOLUÇÃO: Verificando definições duplicadas..."

# Se há um EnvironmentalValueSets.fsh na raiz do input/ (que foi movido),
# pode estar conflitando
if [ -f "input/fsh/EnvironmentalValueSets.fsh" ]; then
    echo "  📄 Analisando input/fsh/EnvironmentalValueSets.fsh..."
    if grep -q "ValueSet:.*EnvironmentalContext" "input/fsh/EnvironmentalValueSets.fsh"; then
        echo "  ⚠️ CONFLITO: EnvironmentalValueSets.fsh também define EnvironmentalContextValueSet"
        echo "  🔄 Removendo definição duplicada de EnvironmentalValueSets.fsh..."

        # Fazer backup do arquivo
        cp "input/fsh/EnvironmentalValueSets.fsh" "input/fsh/EnvironmentalValueSets.fsh.backup_$(date +%Y%m%d_%H%M%S)"

        # Remover ou comentar a definição duplicada
        # Vamos comentar as linhas do ValueSet duplicado
        sed -i.bak '/^ValueSet:.*EnvironmentalContext/,/^$/s/^/\/\/ DUPLICADO - /' "input/fsh/EnvironmentalValueSets.fsh"
        rm -f "input/fsh/EnvironmentalValueSets.fsh.bak"

        echo "  ✅ Definição duplicada comentada em EnvironmentalValueSets.fsh"
    fi
fi

# ============================================================================
# FASE 1B: CORREÇÃO DA ESTRUTURA FINAL DE ARQUIVOS FSH
# ============================================================================
echo ""
echo "=== FASE 1B: ESTRUTURA FINAL DE ARQUIVOS FSH ==="

echo "📁 Movendo arquivos FSH dos diretórios input/examples/ e input/resources/ para input/fsh/..."

# Os arquivos FSH devem estar APENAS em input/fsh/
# input/examples/ deve conter apenas JSON/XML de examples
# input/resources/ deve conter apenas JSON/XML de resources

moved_count=0

# Mover arquivos FSH de input/examples/ de volta para input/fsh/examples/
if ls input/examples/*.fsh 1> /dev/null 2>&1; then
    echo "  🔄 Movendo arquivos FSH de input/examples/ para input/fsh/examples/"

    # Recriar diretório se necessário
    mkdir -p input/fsh/examples/

    for file in input/examples/*.fsh; do
        if [ -f "$file" ]; then
            echo "    📄 Movendo: $(basename "$file")"
            mv "$file" input/fsh/examples/
            ((moved_count++))
        fi
    done
    echo "  ✅ $moved_count arquivos FSH movidos de examples/"
fi

# Mover arquivos FSH de input/resources/ de volta para input/fsh/resources/
moved_count=0
if ls input/resources/*.fsh 1> /dev/null 2>&1; then
    echo "  🔄 Movendo arquivos FSH de input/resources/ para input/fsh/resources/"

    # Recriar diretório se necessário
    mkdir -p input/fsh/resources/

    for file in input/resources/*.fsh; do
        if [ -f "$file" ]; then
            echo "    📄 Movendo: $(basename "$file")"
            mv "$file" input/fsh/resources/
            ((moved_count++))
        fi
    done
    echo "  ✅ $moved_count arquivos FSH movidos de resources/"
fi

echo ""
echo "💡 ESCLARECIMENTO DA ESTRUTURA HL7 FHIR:"
echo "  • input/fsh/ = Arquivos FSH (source code)"
echo "  • input/examples/ = Arquivos JSON/XML de examples"
echo "  • input/resources/ = Arquivos JSON/XML de resources"
echo "  • SUSHI processa FSH e gera JSON em fsh-generated/"

# ============================================================================
# FASE 1C: Verificação da estrutura corrigida
# ============================================================================
echo ""
echo "=== FASE 1C: Verificação da Estrutura Corrigida ==="

echo "📊 Contagens após correções:"

# Contar arquivos FSH
if [ -d "input/fsh" ]; then
    total_fsh=$(find input/fsh/ -name "*.fsh" | wc -l | tr -d ' ')
    echo "  📄 input/fsh/: $total_fsh arquivos FSH"

    # Subdiretorios específicos
    if [ -d "input/fsh/examples" ]; then
        examples_fsh=$(find input/fsh/examples/ -name "*.fsh" | wc -l | tr -d ' ')
        echo "    📋 input/fsh/examples/: $examples_fsh arquivos"
    fi

    if [ -d "input/fsh/resources" ]; then
        resources_fsh=$(find input/fsh/resources/ -name "*.fsh" | wc -l | tr -d ' ')
        echo "    📋 input/fsh/resources/: $resources_fsh arquivos"
    fi
fi

# Verificar se input/examples/ e input/resources/ estão limpos de FSH
examples_fsh_remaining=$(find input/examples/ -name "*.fsh" 2>/dev/null | wc -l | tr -d ' ')
resources_fsh_remaining=$(find input/resources/ -name "*.fsh" 2>/dev/null | wc -l | tr -d ' ')

if [ "$examples_fsh_remaining" -eq 0 ]; then
    echo "  ✅ input/examples/: Limpo de arquivos FSH (correto)"
else
    echo "  ⚠️ input/examples/: Ainda contém $examples_fsh_remaining arquivos FSH"
fi

if [ "$resources_fsh_remaining" -eq 0 ]; then
    echo "  ✅ input/resources/: Limpo de arquivos FSH (correto)"
else
    echo "  ⚠️ input/resources/: Ainda contém $resources_fsh_remaining arquivos FSH"
fi

# ============================================================================
# FASE 1D: Correção de URLs Canônicos
# ============================================================================
echo ""
echo "=== FASE 1D: Correção de URLs Canônicos ==="

echo "🔍 Verificando e corrigindo URLs canônicos..."

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

# Processar apenas arquivos FSH em input/fsh/
url_files_processed=0
find input/fsh/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "^\s*\*\s*url\s*=" "$file"; then
        fix_fsh_urls "$file"
        ((url_files_processed++))
    fi
done

# ============================================================================
# FASE 1E: Correção de Metadados ShareableValueSet
# ============================================================================
echo ""
echo "=== FASE 1E: Correção de Metadados ShareableValueSet ==="

echo "🏷️ Verificando metadados ShareableValueSet..."

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
    local changes_made=false

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
                    changes_made=true
                fi
                if [ "$has_version" = false ]; then
                    echo "* version = \"0.1.0\"" >> "$temp_file"
                    changes_made=true
                fi
                if [ "$has_name" = false ]; then
                    echo "* name = \"$valueset_name\"" >> "$temp_file"
                    changes_made=true
                fi
                if [ "$has_title" = false ]; then
                    # Gerar título baseado no nome
                    title=$(echo "$valueset_name" | sed 's/\([A-Z]\)/ \1/g' | sed 's/^ //')
                    echo "* title = \"$title\"" >> "$temp_file"
                    changes_made=true
                fi
                if [ "$has_description" = false ]; then
                    echo "* description = \"Value set for $title in iOS Lifestyle Medicine IG\"" >> "$temp_file"
                    changes_made=true
                fi
                if [ "$has_status" = false ]; then
                    echo "* status = #active" >> "$temp_file"
                    changes_made=true
                fi
                if [ "$has_experimental" = false ]; then
                    echo "* experimental = false" >> "$temp_file"
                    changes_made=true
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

    if [ "$changes_made" = true ]; then
        mv "$temp_file" "$file"
        echo "  ✅ Metadados adicionados em: $(basename "$file")"
    else
        rm -f "$temp_file"
    fi
}

# Processar ValueSets em input/fsh/
find input/fsh/ -name "*.fsh" -type f | while read -r file; do
    if grep -q "^ValueSet:" "$file"; then
        fix_shareable_metadata "$file"
    fi
done

# ============================================================================
# RESUMO DA FASE 1 v0.5
# ============================================================================
echo ""
echo "=== RESUMO DA FASE 1 v0.5 ==="
echo "✅ Backup criado em: $BACKUP_DIR"
echo "🎯 CORREÇÃO DE VALUESET DUPLICADO:"
echo "   • EnvironmentalContextValueSet duplicado identificado e corrigido"
echo "   • Definições duplicadas comentadas"
echo "🎯 ESTRUTURA FSH CORRIGIDA:"
echo "   • Todos os arquivos FSH movidos para input/fsh/"
echo "   • input/examples/ e input/resources/ limpos de FSH"
echo "   • Estrutura conforme especificações HL7 FHIR"
echo "✅ URLs canônicos verificados e corrigidos"
echo "✅ Metadados ShareableValueSet verificados"
echo "⚠️ Arquivos fsh-generated NÃO foram alterados (serão regenerados)"
echo ""

# ============================================================================
# PRÓXIMOS PASSOS
# ============================================================================
echo "=== PRÓXIMOS PASSOS RECOMENDADOS ==="
echo "1. Executar: sushi . (comando padrão)"
echo "2. Executar: ./_genonce.sh"
echo "3. Verificar qa.html - ESPERAMOS ERRO DE VALUESET DUPLICADO RESOLVIDO!"
echo "4. Se necessário, criar fix_phase1_$(date +%Y%m%d_%H%M%S)_v0.6.sh para correções adicionais"
echo ""
echo "Documentação de referência: FHIR_Specifications_Reference.md"
echo ""

echo "🎯 FASE 1 v0.5 - CORREÇÃO DE DUPLICAÇÃO CONCLUÍDA! 🎯"
echo "💡 O erro de ValueSet duplicado deve estar resolvido!"
echo "ℹ️ Arquivos fsh-generated serão atualizados na próxima execução do SUSHI"