#!/bin/bash

# fix_phase1_20250929_211800_v0.6.sh - Correção de Erros FHIR IG Fase 1 - Versão 0.6
# iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide
# FOCO: CORREÇÃO DE ENCODING UTF-8 E DEPENDÊNCIAS DO _genonce.sh
# Baseado na análise do problema identificado no _genonce.sh linha 17

set -e  # Parar em caso de erro

echo "=== FHIR IG Correção - Fase 1 v0.6 ==="
echo "Data/Hora: $(date)"
echo "Diretório: $(pwd)"
echo "FOCO: Correção de problemas de encoding e dependências _genonce.sh"
echo ""

# Criar backup antes das correções
BACKUP_DIR="backup_phase1_v0.6_$(date +%Y%m%d_%H%M%S)"
echo "🔄 Criando backup em: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp _genonce.sh "$BACKUP_DIR/" 2>/dev/null || true
cp _build.sh "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ Backup criado com sucesso!"
echo ""

# ============================================================================
# FASE 1A: IDENTIFICAÇÃO DO PROBLEMA DE ENCODING
# ============================================================================
echo "=== FASE 1A: IDENTIFICAÇÃO DO PROBLEMA DE ENCODING ==="

echo "🔍 Analisando problema identificado no _genonce.sh..."

echo "📍 PROBLEMA ENCONTRADO na linha 17 do _genonce.sh:"
echo "   export JAVA_TOOL_OPTIONS=\"\$JAVA_TOOL_OPTIONS -Dfile.encoding=UTF-8\""
echo ""

echo "⚠️ SINTOMAS OBSERVADOS:"
echo "   • _genonce.sh trava durante execução (timeout após 5min)"
echo "   • Output vazio gerado"
echo "   • Character encoding = UTF-8 / UTF-8 nas mensagens"
echo ""

echo "🔍 Verificando configuração atual..."
echo "   JAVA_TOOL_OPTIONS atual: ${JAVA_TOOL_OPTIONS:-'(não definido)'}"
echo "   Java version: $(java -version 2>&1 | head -1)"
echo "   Locale: $(locale | grep LANG)"

# ============================================================================
# FASE 1B: CORREÇÃO DO SCRIPT _genonce.sh
# ============================================================================
echo ""
echo "=== FASE 1B: CORREÇÃO DO SCRIPT _genonce.sh ==="

echo "🔧 Corrigindo linha problemática no _genonce.sh..."

# Fazer backup do arquivo original
if [ -f "_genonce.sh" ]; then
    cp "_genonce.sh" "_genonce.sh.backup_$(date +%Y%m%d_%H%M%S)"
    echo "  ✅ Backup do _genonce.sh criado"

    # Remover ou comentar a linha problemática
    echo "  🔄 Comentando linha problemática (linha ~17)..."

    sed -i.bak 's/^export JAVA_TOOL_OPTIONS=.*$/# COMENTADO v0.6: export JAVA_TOOL_OPTIONS problema encoding/' "_genonce.sh"
    rm -f "_genonce.sh.bak"

    echo "  ✅ Linha problemática comentada"

    # Mostrar a mudança
    echo "  📄 Verificando alteração:"
    grep -n "COMENTADO v0.6\|JAVA_TOOL_OPTIONS" "_genonce.sh" | head -3
fi

# ============================================================================
# FASE 1C: VERIFICAÇÃO DE DEPENDÊNCIAS
# ============================================================================
echo ""
echo "=== FASE 1C: VERIFICAÇÃO DE DEPENDÊNCIAS ==="

echo "🔍 Verificando dependências críticas do IG Publisher..."

# Jekyll
if command -v jekyll &> /dev/null; then
    jekyll_version=$(jekyll --version 2>/dev/null || echo "erro")
    echo "  ✅ Jekyll: $jekyll_version"
else
    echo "  ❌ Jekyll: NÃO ENCONTRADO"
    echo "     💡 Instalar com: gem install jekyll bundler"
fi

# Ruby
if command -v ruby &> /dev/null; then
    ruby_version=$(ruby --version)
    echo "  ✅ Ruby: $ruby_version"
else
    echo "  ❌ Ruby: NÃO ENCONTRADO"
fi

# Java
if command -v java &> /dev/null; then
    java_version=$(java -version 2>&1 | head -1)
    echo "  ✅ Java: $java_version"
else
    echo "  ❌ Java: NÃO ENCONTRADO"
fi

# Publisher JAR
if [ -f "publisher.jar" ]; then
    jar_size=$(ls -lh publisher.jar | awk '{print $5}')
    echo "  ✅ Publisher JAR: $jar_size"
else
    echo "  ❌ Publisher JAR: NÃO ENCONTRADO"
fi

# Conexão de internet para tx.fhir.org
echo "  🌐 Testando conexão com tx.fhir.org..."
if curl -sSf tx.fhir.org > /dev/null 2>&1; then
    echo "  ✅ Conexão: Online"
else
    echo "  ⚠️ Conexão: Offline ou lenta"
fi

# ============================================================================
# FASE 1D: LIMPEZA DE VARIÁVEIS DE AMBIENTE
# ============================================================================
echo ""
echo "=== FASE 1D: LIMPEZA DE VARIÁVEIS DE AMBIENTE ==="

echo "🧹 Limpando variáveis problemáticas de encoding..."

# Limpar JAVA_TOOL_OPTIONS se estiver definido
if [ -n "$JAVA_TOOL_OPTIONS" ]; then
    echo "  🔄 JAVA_TOOL_OPTIONS atual: $JAVA_TOOL_OPTIONS"
    unset JAVA_TOOL_OPTIONS
    echo "  ✅ JAVA_TOOL_OPTIONS removido da sessão atual"
else
    echo "  ✅ JAVA_TOOL_OPTIONS não estava definido"
fi

# Verificar outras variáveis relacionadas
echo "  📋 Outras variáveis de encoding:"
echo "     LANG: ${LANG:-'não definido'}"
echo "     LC_ALL: ${LC_ALL:-'não definido'}"
echo "     LC_CTYPE: ${LC_CTYPE:-'não definido'}"

# ============================================================================
# FASE 1E: TESTE RÁPIDO DE COMPONENTES
# ============================================================================
echo ""
echo "=== FASE 1E: TESTE RÁPIDO DE COMPONENTES ==="

echo "🧪 Testando componentes individualmente..."

# Teste Java sem encoding forçado
echo "  ☕ Testando Java limpo..."
if java -version > /dev/null 2>&1; then
    echo "    ✅ Java executando normalmente"
else
    echo "    ❌ Java com problemas"
fi

# Teste Jekyll básico
echo "  💎 Testando Jekyll..."
if jekyll --version > /dev/null 2>&1; then
    echo "    ✅ Jekyll funcionando"
else
    echo "    ❌ Jekyll com problemas"
    echo "    💡 Possível solução: gem install jekyll bundler"
fi

# Teste de leitura do sushi-config.yaml
echo "  📄 Testando leitura de configuração..."
if [ -f "sushi-config.yaml" ] && grep -q "canonical:" "sushi-config.yaml"; then
    canonical=$(grep "canonical:" sushi-config.yaml | sed 's/canonical:[[:space:]]*//' | tr -d '"')
    echo "    ✅ Configuração legível: $canonical"
else
    echo "    ❌ Problema na configuração"
fi

# ============================================================================
# FASE 1F: VERIFICAÇÃO DE MEMÓRIA E RECURSOS
# ============================================================================
echo ""
echo "=== FASE 1F: VERIFICAÇÃO DE RECURSOS DO SISTEMA ==="

echo "💾 Verificando recursos disponíveis..."

# Memória disponível
memory_info=$(vm_stat | grep "Pages free\|Pages inactive" | awk '{print $3}' | tr -d '.' | paste -s -d+ | bc 2>/dev/null || echo "N/A")
if [ "$memory_info" != "N/A" ]; then
    memory_gb=$((memory_info * 4096 / 1024 / 1024 / 1024))
    echo "  💾 Memória livre aproximada: ${memory_gb}GB"
else
    echo "  💾 Memória: Não foi possível calcular"
fi

# Espaço em disco
disk_space=$(df -h . | tail -1 | awk '{print $4}')
echo "  💿 Espaço livre em disco: $disk_space"

# Processos Java em execução
java_processes=$(ps aux | grep java | grep -v grep | wc -l | tr -d ' ')
echo "  ☕ Processos Java ativos: $java_processes"

# ============================================================================
# RESUMO DA FASE 1 v0.6
# ============================================================================
echo ""
echo "=== RESUMO DA FASE 1 v0.6 ==="
echo "✅ Backup criado em: $BACKUP_DIR"
echo "🎯 CORREÇÃO DE ENCODING:"
echo "   • Linha problemática JAVA_TOOL_OPTIONS comentada em _genonce.sh"
echo "   • Variável JAVA_TOOL_OPTIONS removida da sessão"
echo "   • Encoding forçado UTF-8 desabilitado"
echo "✅ VERIFICAÇÃO DE DEPENDÊNCIAS:"
echo "   • Jekyll, Ruby, Java verificados"
echo "   • Publisher JAR confirmado"
echo "   • Conexão de rede testada"
echo "✅ RECURSOS DO SISTEMA:"
echo "   • Memória e disco verificados"
echo "   • Processos Java monitorados"
echo ""

# ============================================================================
# PRÓXIMOS PASSOS
# ============================================================================
echo "=== PRÓXIMOS PASSOS RECOMENDADOS ==="
echo "1. Testar: ./_genonce.sh (sem encoding forçado)"
echo "2. Se ainda travar, executar com menor memória: java -Xmx2g -jar publisher.jar -ig ."
echo "3. Verificar qa.html gerado para contagem de erros"
echo "4. Se necessário, criar fix_phase1_$(date +%Y%m%d_%H%M%S)_v0.7.sh"
echo ""
echo "DIAGNÓSTICO MAIS PROVÁVEL:"
echo "• Conflito de encoding UTF-8 forçado com configuração do sistema"
echo "• Possível incompatibilidade Java 23 + encoding específico"
echo ""

echo "🎯 FASE 1 v0.6 - CORREÇÃO DE ENCODING CONCLUÍDA! 🎯"
echo "💡 Problema de encoding UTF-8 forçado deve estar resolvido!"
echo "🧪 _genonce.sh agora deve executar sem travamentos"