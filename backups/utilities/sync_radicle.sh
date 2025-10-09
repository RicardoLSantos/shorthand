#!/bin/bash
# Sincronização completa para Radicle
# Inclui TUDO: input/, output/, backups/, documentation/

set -e  # Parar em caso de erro

echo "=== Sincronização Radicle (Completa) ==="
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
echo "Arquivos que serão adicionados ao Radicle (incluindo backups/):"
git status --short

echo ""
read -p "Continuar com commit e push para Radicle? (s/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado pelo usuário"
    exit 0
fi

# Adicionar TUDO (exceto o que está em .gitignore)
echo ""
echo "Adicionando arquivos..."
git add input/
git add output/ 2>/dev/null || echo "  (output/ não modificado)"
git add backups/ 2>/dev/null || echo "  (backups/ não modificado)"
git add documentation/ 2>/dev/null || echo "  (documentation/ não modificado)"

# Commit
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
read -p "Mensagem do commit (enter para usar padrão): " COMMIT_MSG
if [[ -z "$COMMIT_MSG" ]]; then
    COMMIT_MSG="Complete sync with backups - ${TIMESTAMP}"
fi

git commit -m "$COMMIT_MSG

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>" || echo "Nada para commitar"

# Push
echo ""
echo "Pushing para Radicle (rad)..."
git push rad main

echo ""
echo "✅ Sincronização Radicle completa!"
