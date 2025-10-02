#!/bin/bash
# Sincronização segura para GitHub
# Apenas input/ e output/ (FSH + IG gerado)
# NÃO inclui backups/ nem documentation/

set -e  # Parar em caso de erro

echo "=== Sincronização GitHub ==="
echo "Data/Hora: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Verificar se há mudanças
if [[ -z $(git status -s) ]]; then
    echo "✓ Nenhuma mudança para commitar"
    exit 0
fi

# Mostrar status
echo "Status atual:"
git status --short

echo ""
echo "Arquivos que serão adicionados ao GitHub:"
git status --short | grep -E "^\?\?|^ M|^M " | grep -E "^.*(input/|output/)" || echo "  (nenhum arquivo input/ ou output/ modificado)"

echo ""
read -p "Continuar com commit e push para GitHub? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado pelo usuário"
    exit 0
fi

# Adicionar apenas input/ e output/
echo ""
echo "Adicionando arquivos..."
git add input/
git add output/ 2>/dev/null || echo "  (output/ não modificado)"

# Commit
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
read -p "Mensagem do commit (enter para usar padrão): " COMMIT_MSG
if [[ -z "$COMMIT_MSG" ]]; then
    COMMIT_MSG="Update FHIR IG - ${TIMESTAMP}"
fi

git commit -m "$COMMIT_MSG

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>" || echo "Nada para commitar"

# Push
echo ""
echo "Pushing para GitHub (origin)..."
git push origin main

echo ""
echo "✅ Sincronização GitHub completa!"
