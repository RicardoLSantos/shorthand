# Continue Aqui - Workflow Git/Radicle Atualizado

**Data:** 2025-10-09 12:08
**Arquivo anterior:** `20251004_150730_CONTINUE_HERE.md`

---

## 📋 Estado Atual do Projeto

**Warnings:** 20
**Errors:** 0 ✅
**Fase:** 4.7 COMPLETA
**Redução acumulada:** 105 → 20 warnings (-85, 81.0%) 🎉

### Commits Atuais

```
Local HEAD:     9ee90021 - Radicle sync: Add complete backups/ and documentation/
GitHub (origin): 13cfe44b - Remove backups/ from GitHub tracking (preserve locally)
Radicle (rad):   9ee90021 - Radicle sync: Add complete backups/ and documentation/
```

---

## 🔄 IMPORTANTE: Workflow Git/Radicle

### Estratégia Dual-Repository

Este projeto mantém **dois repositórios com conteúdos diferentes**:

| Repositório | Conteúdo | Propósito |
|-------------|----------|-----------|
| **GitHub** | Código principal apenas | Colaboração pública, código limpo |
| **Radicle** | Código + backups/ + documentation/ | Backup completo, histórico total |

### Arquitetura

```
├── input/              ✅ GitHub ✅ Radicle
├── output/             ✅ GitHub ✅ Radicle
├── backups/            ❌ GitHub ✅ Radicle (via git add -f)
├── documentation/      ❌ GitHub ✅ Radicle (via git add -f)
└── .gitignore          (bloqueia backups/ e documentation/)
```

---

## 📝 Comandos de Sincronização

### 1. Sincronização Normal (Código Principal)

**Use para:** Mudanças em input/, output/, sushi-config.yaml, etc.

```bash
# Adicionar e commitar
git add input/ output/
git commit -m "Sua mensagem de commit"

# Push para ambos (backups/ bloqueado automaticamente)
git push origin main  # GitHub
git push rad main     # Radicle
```

### 2. Sincronização Completa Radicle (Com Backups)

**Use para:** Sincronizar backups/ e documentation/ com Radicle

```bash
# 1. Forçar add das pastas ignoradas
git add -f backups/ documentation/

# 2. Verificar o que será commitado
git status --short | head -30

# 3. Commit separado para Radicle
git commit -m "Radicle sync: Add complete backups/ and documentation/

Sincronização completa incluindo:
- Pasta backups/ (phase reports, daily summaries)
- Pasta documentation/ (SOPs, templates, referências)
- [descreva outras mudanças aqui]

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# 4. Push APENAS para Radicle
git push rad main

# ⚠️ NÃO fazer push para GitHub após este commit!
```

### 3. Manter GitHub Limpo

Se backups/ foi acidentalmente commitado para GitHub:

```bash
# Remover do índice (mantém arquivos localmente)
git rm --cached -r backups/ documentation/

# Commit a remoção
git commit -m "Remove backups/ from GitHub tracking (preserve locally)"

# Push para GitHub
git push origin main
```

---

## ⚠️ Regras Críticas

1. ✅ **SEMPRE** verifique `git status` antes de push para GitHub
2. ✅ **SEMPRE** use `git add -f` quando sincronizar backups/ para Radicle
3. ❌ **NUNCA** faça `git push origin main` após adicionar backups/ com `-f`
4. ✅ backups/ e documentation/ **DEVEM** estar no `.gitignore`
5. ✅ Commits com backups/ vão **APENAS** para Radicle

---

## 🔍 Verificação Rápida

```bash
# Estado dos repositórios
echo "=== Estado dos Repositórios ===" && \
echo "" && \
echo "GitHub (origin/main):" && git log origin/main --oneline -1 && \
echo "" && \
echo "Radicle (rad/main):" && git log rad/main --oneline -1 && \
echo "" && \
echo "Local (HEAD):" && git log HEAD --oneline -1

# Verificar .gitignore
git check-ignore backups/ documentation/
# Deve retornar: backups/ e documentation/

# Ver diferenças entre repositórios
git log origin/main..rad/main --oneline  # Commits só no Radicle
git log rad/main..origin/main --oneline  # Commits só no GitHub
```

---

## 📚 Documentação Relacionada

### Workflow Completo
- **Documento detalhado:** `20251009_120834_radicle_sync_workflow.md`
- **Último sync Radicle:** 2025-10-09 09:00 (commit 9ee90021)

### Histórico de Fases
- **CONTINUE_HERE anterior:** `20251004_150730_CONTINUE_HERE.md` (Fase 4.7 completa)
- **Fase 4.7:** `20251004_144900_phase47_complete.md`
- **Radicle Fase 4.7:** `20251004_150000_radicle_update_phase47.md`

### Daily Summaries
- **2025-10-04:** `backups/daily_summaries/20251004_daily_summary.md`

---

## 🎯 Próximos Passos Sugeridos

### Opção 1: Considerar Fase 4 COMPLETA ✅
- 81% de redução alcançada (105 → 20 warnings)
- 0 errors mantido
- IG production-ready
- Warnings restantes são informativos

### Opção 2: Fase 4.8 (Polimento Opcional)
- Suppress 6 warnings triviais (HTML fragments, CQL)
- Meta: 20 → 12-15 warnings
- Usar `ignoreWarnings.txt`

### Opção 3: Fase 5 - Testing & Validation
- Testes de integração
- Validação clínica
- Performance testing

---

## 📞 Quick Start para Novo Chat

```
"Continue do CONTINUE_HERE.md.
Estado: 20 warnings, 0 errors.
Fase 4.7: COMPLETA ✅ (81% redução).
Ver workflow Git/Radicle no CONTINUE_HERE.md antes de fazer commits.
Último commit: 9ee90021 (Radicle sync completo)."
```

---

**Criado:** 2025-10-09 12:08
**Versão anterior:** `20251004_150730_CONTINUE_HERE.md`
**Última sincronização:** 2025-10-09 09:00
