# Guia de Sincronização: GitHub e Radicle

**Data de criação:** 2025-10-02
**Versão:** 1.0

---

## 📋 Visão Geral

Este projeto mantém dois repositórios remotos com estratégias de sincronização diferentes:

- **GitHub (`origin`)**: Repositório público - contém apenas código FHIR (FSH) e IG gerado
- **Radicle (`rad`)**: Repositório completo - contém tudo, incluindo backups e documentação

---

## 🗂️ Estrutura de Pastas

### Pastas Sincronizadas com GitHub
✅ `input/` - Arquivos fonte FHIR Shorthand (FSH)
✅ `output/` - Implementation Guide gerado (HTML, JSON, etc)

### Pastas APENAS no Radicle (não vão para GitHub)
🔒 `backups/` - Scripts, logs, backups de configuração
🔒 `documentation/` - Documentação interna do projeto

### Pastas Ignoradas (não vão para nenhum repo)
❌ `temp/` - Arquivos temporários do build
❌ `fsh-generated/` - Arquivos gerados pelo SUSHI
❌ `input-cache/` - Cache de pacotes FHIR

---

## 🛠️ Scripts Disponíveis

### 1. `sync_github.sh`
**Propósito:** Sincronizar apenas código FHIR com GitHub

**O que faz:**
- Adiciona apenas `input/` e `output/`
- Cria commit com timestamp automático
- Push para `origin main` (GitHub)
- Solicita confirmação antes de executar

**Uso:**
```bash
./sync_github.sh
# ou
backups/utilities/sync_github.sh
```

**Exemplo de execução:**
```
=== Sincronização GitHub ===
Data/Hora: 2025-10-02 07:30:00

Status atual:
 M input/fsh/profiles/MindfulnessProfiles.fsh
 M output/StructureDefinition-mindfulness-observation.json

Arquivos que serão adicionados ao GitHub:
 M input/fsh/profiles/MindfulnessProfiles.fsh
 M output/StructureDefinition-mindfulness-observation.json

Continuar com commit e push para GitHub? (s/N): s

Mensagem do commit (enter para usar padrão): Fix mindfulness observation binding

Pushing para GitHub (origin)...
✅ Sincronização GitHub completa!
```

---

### 2. `sync_radicle.sh`
**Propósito:** Sincronizar TUDO com Radicle (backup completo)

**O que faz:**
- Adiciona `input/`, `output/`, `backups/`, `documentation/`
- Cria commit com timestamp automático
- Push para `rad main` (Radicle)
- Solicita confirmação antes de executar

**Uso:**
```bash
./sync_radicle.sh
# ou
backups/utilities/sync_radicle.sh
```

**Exemplo de execução:**
```
=== Sincronização Radicle (Completa) ===
Data/Hora: 2025-10-02 07:35:00

Status atual:
 M input/fsh/profiles/MindfulnessProfiles.fsh
 M backups/fix_scripts/fix_phase3.16_20251002_073000.sh
 M documentation/phase_reports/phase3.16_report_20251002_073500.md

Arquivos que serão adicionados ao Radicle (incluindo backups/):
[lista completa de arquivos]

Continuar com commit e push para Radicle? (s/N): s

Mensagem do commit (enter para usar padrão):

Pushing para Radicle (rad)...
✅ Sincronização Radicle completa!
```

---

## 📝 Workflows Recomendados

### Workflow 1: Desenvolvimento Normal (FSH)
**Cenário:** Modificou arquivos FSH, rodou build, quer publicar

```bash
# 1. Fazer modificações em input/fsh/
vim input/fsh/profiles/MyProfile.fsh

# 2. Rodar build
./_genonce.sh

# 3. Sincronizar com GitHub (apenas código)
./sync_github.sh

# 4. (Opcional) Sincronizar com Radicle (backup completo)
./sync_radicle.sh
```

---

### Workflow 2: Criação de Documentação
**Cenário:** Criou relatórios de fase, backups, scripts

```bash
# 1. Criar documentação/backups
echo "Phase 3.16 completed" > backups/phase_reports/phase3.16_report.md
cp fix_phase3.16.sh backups/fix_scripts/

# 2. Sincronizar APENAS com Radicle (GitHub não precisa desses arquivos)
./sync_radicle.sh
```

---

### Workflow 3: Sincronização Completa
**Cenário:** Fim do dia, quer garantir que tudo está salvo

```bash
# 1. Sincronizar GitHub (código público)
./sync_github.sh

# 2. Sincronizar Radicle (backup completo)
./sync_radicle.sh
```

---

### Workflow 4: Após Recuperação de Desastre
**Cenário:** Acabou de fazer reset/recovery, quer sincronizar estado atual

```bash
# 1. Verificar estado
git status

# 2. NÃO sincronizar com GitHub ainda (pode ter output/ desatualizado)
# Rodar build primeiro
./_genonce.sh

# 3. Agora sim, sincronizar
./sync_github.sh
./sync_radicle.sh
```

---

## ⚠️ Pontos de Atenção

### 1. **Ordem de Sincronização**
- ✅ **Recomendado:** GitHub primeiro, depois Radicle
- ❌ **Evitar:** Radicle primeiro pode criar divergências

### 2. **Quando NÃO sincronizar com GitHub**
- ❌ Se `output/` tem conflitos de merge
- ❌ Se SUSHI falhou (0 errors esperados)
- ❌ Se não rodou build após modificar FSH

### 3. **Quando sincronizar APENAS com Radicle**
- ✅ Criou/modificou arquivos em `backups/`
- ✅ Criou/modificou arquivos em `documentation/`
- ✅ Quer backup de scripts temporários

### 4. **Proteção Contra Erros**
- Ambos os scripts pedem **confirmação** antes de push
- Mostram **exatamente** quais arquivos serão enviados
- Permitem **cancelar** a operação (N ou Ctrl+C)

---

## 🔧 Configuração Técnica

### .gitignore (raiz do projeto)
```gitignore
# Pastas privadas (NÃO vão para GitHub)
/backups/
/documentation/

# Pastas geradas (NÃO vão para nenhum repo)
/temp/
/fsh-generated/
/output/
/input-cache/
```

**Efeito:**
- `backups/` e `documentation/` são ignorados pelo Git por padrão
- Apenas scripts de sync específicos podem adicioná-los (força com `git add`)
- GitHub **nunca** receberá essas pastas (protegido pelo .gitignore)
- Radicle recebe porque o script faz `git add backups/` explicitamente

### Remotes Configurados
```bash
git remote -v
# origin  https://github.com/seu-usuario/seu-repo.git (GitHub)
# rad     rad://z3rQKqZn289A7DxB9wpQpW6dWHhj... (Radicle)
```

---

## 🚨 Resolução de Problemas

### Problema 1: "Updates were rejected"
**Causa:** Branch local está atrás do remote

**Solução:**
```bash
# Para GitHub
git pull origin main --rebase
./sync_github.sh

# Para Radicle
git pull rad main --rebase
./sync_radicle.sh
```

---

### Problema 2: Conflitos de Merge
**Causa:** Modificações simultâneas em diferentes máquinas

**Solução:**
```bash
# 1. Fazer backup
cp -R backups backups_temp_$(date +%Y%m%d_%H%M%S)

# 2. Resolver conflitos manualmente
git status  # ver arquivos em conflito
vim arquivo_em_conflito.fsh  # resolver conflitos

# 3. Finalizar merge
git add arquivo_resolvido.fsh
git commit -m "Resolve merge conflicts"

# 4. Sincronizar
./sync_github.sh
./sync_radicle.sh
```

---

### Problema 3: Enviou backups/ para GitHub acidentalmente
**Causa:** Usou `git add .` em vez do script

**Solução:**
```bash
# 1. Desfazer commit (SEM push ainda)
git reset --soft HEAD~1

# 2. Remover backups do staging
git reset HEAD backups/
git reset HEAD documentation/

# 3. Usar script correto
./sync_github.sh
```

---

### Problema 4: Script de sync não funciona
**Causa:** Permissões incorretas ou symlink quebrado

**Solução:**
```bash
# 1. Verificar symlinks
ls -la sync_*.sh

# 2. Recriar symlinks se necessário
ln -sf backups/utilities/sync_github.sh sync_github.sh
ln -sf backups/utilities/sync_radicle.sh sync_radicle.sh

# 3. Garantir permissões de execução
chmod +x backups/utilities/sync_*.sh
```

---

## 📚 Histórico de Mudanças

### 2025-10-02
- **v1.0** - Criação inicial do documento
- Criados scripts `sync_github.sh` e `sync_radicle.sh`
- Estratégia de sincronização diferenciada implementada
- Movidos scripts para `backups/utilities/`
- Criados symlinks no root para facilitar uso

---

## 📞 Suporte

**Em caso de dúvidas:**
1. Consultar este documento
2. Verificar `.gitignore` para entender o que é ignorado
3. Usar `git status` para ver estado atual
4. Scripts sempre mostram preview antes de executar - leia com atenção!

**Regra de Ouro:**
> Quando em dúvida, NÃO faça push. Use os scripts que mostram preview e pedem confirmação.

---

**Última atualização:** 2025-10-02 07:35:00
