# Radicle Sync Workflow - Documentação Completa

**Data:** 2025-10-09 12:08:34
**Contexto:** Sincronização completa backups/ e documentation/ para Radicle
**Commit:** 9ee90021f7735efb841ee6408434963b3f33a397

---

## 📖 Visão Geral

Este documento descreve o **workflow completo de sincronização Git/Radicle** estabelecido para este projeto FHIR IG.

### Problema Resolvido

O projeto precisa manter:
- **Código limpo no GitHub** para colaboração pública
- **Histórico completo no Radicle** incluindo backups e documentação

### Solução Implementada

Uso de `.gitignore` para bloquear backups/ e documentation/ do GitHub, mas permitir sincronização manual forçada para Radicle.

---

## 🏗️ Arquitetura dos Repositórios

### Configuração dos Remotes

```bash
$ git remote -v
origin  https://github.com/RicardoLSantos/shorthand.git (fetch)
origin  https://github.com/RicardoLSantos/shorthand.git (push)
rad     rad://z3rQKqZn289A7DxB9wpQpW6dWHhj/z6MkouHvF7YsgN5ESWwG2ZYKaQERD9DrS5jmuFJ5sfZaAvLA (fetch)
rad     rad://z3rQKqZn289A7DxB9wpQpW6dWHhj/z6MkouHvF7YsgN5ESWwG2ZYKaQERD9DrS5jmuFJ5sfZaAvLA (push)
```

### Estrutura de Diretórios

```
iOS_Lifestyle_Medicine_HEADS2_FMUP/
├── .gitignore              ← Bloqueia backups/ e documentation/
├── input/                  ← Código FHIR (ambos repos)
│   └── fsh/
├── output/                 ← IG gerado (ambos repos)
├── backups/                ← APENAS Radicle (git add -f)
│   ├── daily_summaries/
│   ├── phase_reports/
│   ├── phase4_research_specifications/
│   └── utilities/
└── documentation/          ← APENAS Radicle (git add -f)
    ├── SOPs/
    ├── templates/
    └── references/
```

### Conteúdo do .gitignore

```gitignore
# Generated directories (excluded from GitHub, but output/ will be force-added)
/temp/
/input-cache/
/fsh-generated/
/qa/

# Local IG Publisher files
/template/
publisher.jar
validator_cli.jar
*.jar

# Internal use only - NOT for GitHub
/backups/
/documentation/

# Backups and temporary files
backup_descriptions-*.tar.gz
*_old/
preprocessed/
ls_*.txt

# Build logs (keep local only)
*.log

# System specific files
.DS_Store
Thumbs.db
```

---

## 🔄 Fluxos de Trabalho

### Fluxo 1: Sincronização Normal (Código)

**Quando usar:**
- Modificações em arquivos FSH (input/fsh/)
- Mudanças em sushi-config.yaml
- Updates em output/ (IG gerado)
- Qualquer código FHIR principal

**Comandos:**

```bash
# 1. Adicionar mudanças
git add input/ output/ sushi-config.yaml

# 2. Commit
git commit -m "Sua mensagem descritiva

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# 3. Push para GitHub
git push origin main

# 4. Push para Radicle
git push rad main
```

**Resultado:**
- ✅ Código sincronizado em ambos repositórios
- ✅ backups/ e documentation/ permanecem ignorados
- ✅ GitHub limpo, Radicle limpo (sem backups neste commit)

---

### Fluxo 2: Sincronização Completa Radicle (Com Backups)

**Quando usar:**
- Depois de completar uma fase do projeto
- Quando houver novos documentos em backups/
- Para sincronizar daily summaries
- Atualizações em documentation/

**Passo a Passo Detalhado:**

#### Passo 1: Verificar Estado Atual

```bash
# Ver último commit em cada repositório
git log origin/main --oneline -1  # GitHub
git log rad/main --oneline -1     # Radicle
git log HEAD --oneline -1         # Local

# Verificar arquivos modificados
git status --short
```

#### Passo 2: Forçar Add de Pastas Ignoradas

```bash
# Adicionar backups/ e documentation/ (forçado)
git add -f backups/ documentation/

# Verificar o que foi adicionado (primeiras 30 linhas)
git status --short | head -30
```

**Exemplo de output esperado:**
```
A  backups/.DS_Store
A  backups/phase4_research_specifications/20251004_150000_radicle_update_phase47.md
A  backups/daily_summaries/20251004_daily_summary.md
A  documentation/SOPs/validation_procedure.md
...
```

#### Passo 3: Commit com Descrição Detalhada

```bash
git commit -m "Radicle sync: Add complete backups/ and documentation/

Sincronização completa incluindo:
- Pasta backups/ (phase4 reports, daily summaries desde 2025-10-04)
- Pasta documentation/ (SOPs atualizados, templates, referências)
- Histórico completo das Fases 4.4 até 4.7
- Daily summaries de 2025-10-03 e 2025-10-04

Estatísticas:
- 4,459 arquivos adicionados
- ~1.7M linhas de documentação
- Fase 4.7 completa (20 warnings, 0 errors)

Este commit é EXCLUSIVO para Radicle.
GitHub mantém .gitignore bloqueando estas pastas.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

#### Passo 4: Push Apenas para Radicle

```bash
# Push para Radicle
git push rad main
```

**Output esperado:**
```
✓ Canonical head updated to 9ee90021f7735efb841ee6408434963b3f33a397
No seeds found for rad:z3rQKqZn289A7DxB9wpQpW6dWHhj.
To rad://z3rQKqZn289A7DxB9wpQpW6dWHhj/z6MkouHvF7YsgN5ESWwG2ZYKaQERD9DrS5jmuFJ5sfZaAvLA
   fa4321bb..9ee90021  main -> main
```

#### Passo 5: Verificação Final

```bash
# Verificar estado final
echo "=== Estado Final dos Repositórios ===" && \
echo "" && \
echo "GitHub (origin/main):" && git log origin/main --oneline -1 && \
echo "" && \
echo "Radicle (rad/main):" && git log rad/main --oneline -1 && \
echo "" && \
echo "Local (HEAD):" && git log HEAD --oneline -1
```

**Output esperado:**
```
=== Estado Final dos Repositórios ===

GitHub (origin/main):
13cfe44b Remove backups/ from GitHub tracking (preserve locally)

Radicle (rad/main):
9ee90021 Radicle sync: Add complete backups/ and documentation/

Local (HEAD):
9ee90021 Radicle sync: Add complete backups/ and documentation/
```

**Resultado:**
- ✅ Local sincronizado com Radicle
- ✅ Radicle contém backups/ e documentation/
- ✅ GitHub permanece limpo (commit anterior sem backups)
- ✅ backups/ e documentation/ preservados localmente

---

### Fluxo 3: Limpeza do GitHub (Remover Backups)

**Quando usar:**
- Se backups/ foi acidentalmente commitado no GitHub
- Para limpar histórico do GitHub

**Comandos:**

```bash
# 1. Remover do índice Git (mantém arquivos locais)
git rm --cached -r backups/ documentation/

# 2. Verificar remoção
git status --short

# 3. Commit a remoção
git commit -m "Remove backups/ from GitHub tracking (preserve locally)

- Removed backups/ from Git index (preserved locally)
- Removed documentation/ from Git index (preserved locally)
- Updated .gitignore to block these directories
- Files remain intact in local filesystem
- Radicle will continue to track these directories

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# 4. Push para GitHub
git push origin main
```

**Resultado:**
- ✅ backups/ removido do GitHub
- ✅ documentation/ removido do GitHub
- ✅ Arquivos preservados localmente
- ✅ .gitignore ativo

---

## 🛡️ Regras de Segurança

### ✅ DO (Fazer)

1. **Sempre verifique `git status`** antes de qualquer push
2. **Use `git add -f`** ao adicionar backups/ e documentation/
3. **Verifique o remote** antes de push com backups/
4. **Documente** cada sincronização Radicle
5. **Mantenha .gitignore** atualizado

### ❌ DON'T (Não Fazer)

1. **NUNCA** faça `git push origin main` após `git add -f backups/`
2. **NUNCA** remova backups/ do .gitignore permanentemente
3. **NUNCA** force push para GitHub com backups/
4. **NUNCA** assuma que um commit está no repositório certo
5. **NUNCA** delete backups/ localmente sem backup

---

## 🔍 Comandos de Verificação

### Verificar Estado dos Repositórios

```bash
# Estado completo
git log origin/main..HEAD --oneline  # Commits locais não no GitHub
git log rad/main..HEAD --oneline     # Commits locais não no Radicle
git log origin/main..rad/main --oneline  # Commits no Radicle mas não no GitHub
```

### Verificar .gitignore

```bash
# Verificar se pastas estão ignoradas
git check-ignore backups/ documentation/
# Deve retornar: backups/ e documentation/

# Ver todos arquivos ignorados
git status --ignored
```

### Ver Diferenças Entre Repositórios

```bash
# Commits apenas no Radicle
git log origin/main..rad/main --oneline --graph

# Arquivos diferentes entre repos
git diff origin/main rad/main --name-only
```

### Estatísticas de Commit

```bash
# Tamanho do último commit
git show --stat HEAD

# Arquivos adicionados no último commit
git show --name-status HEAD | grep "^A"
```

---

## 📊 Histórico de Sincronizações

### Sincronização 2025-10-09 (Esta)

**Commit:** 9ee90021f7735efb841ee6408434963b3f33a397
**Data:** 2025-10-09 09:00
**Descrição:** Primeira sincronização completa com novo workflow

**Conteúdo:**
- 4,459 arquivos
- 1,711,940 linhas adicionadas
- Todas as pastas backups/ (desde início do projeto)
- Toda pasta documentation/

**Commits incluídos:**
```
fa4321bb..9ee90021
  - 13cfe44b Remove backups/ from GitHub tracking
  - 9ee90021 Radicle sync: Add complete backups/ and documentation/
```

### Sincronização 2025-10-04 (Fase 4.7)

**Commit:** 37a9c037f523d7930fb142640e4144d72954d619
**Data:** 2025-10-04 15:00
**Descrição:** Fase 4.7 complete com documentação

**Documentado em:**
- `20251004_150000_radicle_update_phase47.md`

---

## 🚨 Solução de Problemas

### Problema: Backups/ foi commitado no GitHub

**Sintomas:**
```bash
git log origin/main --oneline -1
# Mostra commit com backups/
```

**Solução:**
```bash
# Use Fluxo 3: Limpeza do GitHub
git rm --cached -r backups/ documentation/
git commit -m "Remove backups/ from GitHub tracking"
git push origin main
```

### Problema: Conflito após git add -f

**Sintomas:**
```bash
git status
# Mostra muitos arquivos staged não desejados
```

**Solução:**
```bash
# Resetar staging area
git reset HEAD backups/ documentation/

# Verificar .gitignore
cat .gitignore | grep -E "backups|documentation"

# Tentar novamente
git add -f backups/ documentation/
```

### Problema: Push bloqueado por hook

**Sintomas:**
```
error: failed to push some refs
```

**Solução:**
```bash
# Verificar qual remote está rejeitando
git push origin main --verbose

# Se for GitHub, verificar se há backups/ no commit
git show HEAD --name-only | grep backups/

# Se sim, remover (ver Fluxo 3)
```

---

## 📚 Referências

### Documentos Relacionados

- **CONTINUE_HERE.md** - Estado atual e quick start
- **20251004_150730_CONTINUE_HERE.md** - Estado anterior (Fase 4.7)
- **20251004_150000_radicle_update_phase47.md** - Sync anterior
- **backups/utilities/sync_radicle.sh** - Script de automação (legado)

### Commits Importantes

| Commit | Data | Descrição |
|--------|------|-----------|
| 9ee90021 | 2025-10-09 | Radicle sync completo (backups + doc) |
| 13cfe44b | 2025-10-09 | Remove backups/ do GitHub |
| fa4321bb | 2025-10-04 | Documentação Fase 4.7 |
| 37a9c037 | 2025-10-04 | Fase 4.7 complete |

### Links Úteis

- **Radicle Docs:** https://docs.radicle.xyz
- **Git Docs:** https://git-scm.com/doc
- **GitHub Repo:** https://github.com/RicardoLSantos/shorthand

---

## ✅ Checklist para Futuros Chats

Ao iniciar uma nova conversa:

- [ ] Ler CONTINUE_HERE.md
- [ ] Verificar `git status`
- [ ] Confirmar .gitignore contém backups/ e documentation/
- [ ] Verificar último commit em origin/main e rad/main
- [ ] Entender qual fluxo usar (Normal vs. Completo)

Antes de fazer commit com backups/:

- [ ] Usar `git add -f backups/ documentation/`
- [ ] Verificar `git status --short` antes de commit
- [ ] Commit message menciona "Radicle sync"
- [ ] Push APENAS para rad (não origin)
- [ ] Verificar estado final dos repositórios

---

**Documento criado:** 2025-10-09 12:08:34
**Última sincronização:** 2025-10-09 09:00
**Próxima revisão sugerida:** Após próxima sincronização completa
