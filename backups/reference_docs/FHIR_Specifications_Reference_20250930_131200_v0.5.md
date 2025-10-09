# FHIR IG Specifications Reference - iOS Lifestyle Medicine
**Version:** 0.5 - PÓS-PHASE 2.2 (Quick Wins Iniciado)
**Timestamp:** 2025-09-30 13:12:00
**Project:** iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide
**Status:** 283 errors (-39.7% from initial 469)

---

## HISTÓRICO DE PROGRESSO

### Phase 0: Baseline
- **Errors:** 469
- **Status:** Análise inicial completa

### Phase 1: Jurisdiction Fix (2025-09-30 12:47:38)
- **Ação:** Corrigido display name "Northern America" → "Northern America a/" em sushi-config.yaml
- **Resultado:** 469 → **291 errors** (-178 errors, -38.0%)
- **Impacto:** Correção em cascata para 35+ recursos

### Phase 2.2: ValueSet Binding Codes (2025-09-30 13:08:13)
- **Ação:** Corrigidos códigos inválidos em audit configurations
  - `#detailed` → `$AuditLevels#high` (código "detailed" não existe)
  - `#fhir` → `$AuditFormats#structured` (código "fhir" não existe)
- **Arquivos:** MindfulnessAuditConfig.fsh, MindfulnessAudit.fsh
- **Resultado:** 291 → **283 errors** (-8 errors, -2.7%)
- **Impacto:** 2 instâncias corrigidas (4 code errors no total)

### Progresso Total
```
Início:   469 errors
Atual:    283 errors
Redução:  -186 errors (-39.7%)
```

---

## ANÁLISE DOS 283 ERROS REMANESCENTES

### ESTATÍSTICAS ATUAIS
- **ERRORs:** 283
- **WARNINGs:** 188 (estável)
- **INFOs:** 30 (estável)
- **Broken Links:** 0 ✅
- **Build Time:** 6min 30s
- **Recursos validados:** 221

---

## CATEGORIAS DE ERROS (Por Prioridade)

### 🟢 **QUICK WINS - PHASE 2.3-2.6 (~29 errors restantes)**

#### **PHASE 2.3: Canonical URL Mismatches (~7 errors)**
**Prioridade:** Alta | **Complexidade:** Baixa | **Impacto:** -7 errors

**Problema:**
```
ERROR: URL Mismatch  vs
```

**Causa Raiz:**
- CodeSystem ID não corresponde ao último segmento da URL canônica
- Exemplo: `CodeSystem/MindfulnessSettingCS` mas URL termina com `/mindfulness-setting`

**Solução:**
1. Padronizar IDs para kebab-case
2. Atualizar referências nos ValueSets
3. Regenerar recursos

**Recursos Afetados:** ~7 CodeSystems identificados em canonical_url_analysis.txt

**Estimativa:** 15 minutos de execução

---

#### **PHASE 2.4: Observation Category Codes (~8 errors)**
**Prioridade:** Alta | **Complexidade:** Baixa | **Impacto:** -8 errors

**Problema:**
```
ERROR: Código desconhecido 'nutrition' no CodeSystem observation-category
ERROR: Código desconhecido 'environment' no CodeSystem observation-category
```

**Causa Raiz:**
- Usando categorias customizadas não existentes no HL7 observation-category CodeSystem
- Categorias válidas: `social-history`, `vital-signs`, `imaging`, `laboratory`, `procedure`, `survey`, `exam`, `therapy`, `activity`

**Solução:**
```fsh
// ❌ ERRADO
* category = http://terminology.hl7.org/CodeSystem/observation-category#nutrition

// ✅ CORRETO
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
```

**Arquivos Afetados:**
- StructureDefinition profiles de nutrition
- StructureDefinition profiles de environmental
- Observation examples correspondentes

**Estimativa:** 20 minutos de execução

---

#### **PHASE 2.5: Consent Display Names (~6 errors)**
**Prioridade:** Média | **Complexidade:** Baixa | **Impacto:** -6 errors

**Problema:**
```
ERROR: Wrong Display Name 'Patient Consent' for http://loinc.org#59284-0.
Valid display is 'Consent Document'

ERROR: Código desconhecido 'TREAT' no CodeSystem v3-RoleCode

ERROR: URL não encontrado 'http://terminology.hl7.org/CodeSystem/practitioner-identifier'
```

**Solução:**
1. Corrigir display LOINC#59284-0 para "Consent Document"
2. Validar RoleCode 'TREAT' (pode ser válido, verificar versão)
3. Corrigir system URL do practitioner-identifier

**Arquivos Afetados:**
- Consent/MindfulnessAccessPolicy
- Consent/MindfulnessSecurityDefinition

**Estimativa:** 10 minutos de execução

---

#### **PHASE 2.6: MessageDefinition Constraints (~4 errors)**
**Prioridade:** Média | **Complexidade:** Baixa | **Impacto:** -4 errors

**Problema:**
```
ERROR: MessageDefinition.focus[0]: md-1: 'Max must be postive int or *'
```

**Causa Raiz:**
- MessageDefinition.focus.max tem valor inválido
- FHIR R4 requer: positive integer ou "*"

**Solução:**
```fsh
* focus.max = "*"  // ou valor positivo válido
```

**Arquivos Afetados:**
- MessageDefinition/EndSessionMessage
- MessageDefinition/StartSessionMessage

**Estimativa:** 5 minutos de execução

---

### **TOTAL QUICK WINS (Phase 2.3-2.6):**
- **Errors estimados:** -29 errors
- **Target pós Quick Wins:** ~254 errors
- **Tempo estimado total:** ~50 minutos

---

## 🔴 **RESEARCH-INTENSIVE TASKS - PHASE 3 (~230 errors)**

### **PHASE 3.1: SNOMED CT Code Validation (~20 errors)**
**Prioridade:** Alta | **Complexidade:** Alta | **Requer:** Opus 4

**Problemas Identificados:**
```
ERROR: Unknown code '37016008' in SNOMED CT (Observation.method)
ERROR: Unknown code '725854004' in SNOMED CT (component codes)
ERROR: Unknown code '118682006' in SNOMED CT (component codes)
ERROR: Unknown code '364311006' in SNOMED CT (ValueSet)
ERROR: Wrong Display Name for multiple SNOMED codes
```

**Códigos SNOMED Inválidos:**
- `37016008` - usado em Observation.method (2x)
- `725854004` - usado em component codes (2x)
- `118682006` - usado em component codes (2x)
- `364311006` - usado em ValueSet (1x)
- `285854004` - Wrong Display Name
- `276241001` - Wrong Display Name (should be "Fear of heights")
- `130991005` - Wrong Display Name (should be "Transcortical sensory aphasia")
- `373931001` - Wrong Display Name

**Causa Raiz:**
- Códigos podem estar retired/deprecated no SNOMED CT
- Display names não correspondem à edição SNOMED usada pelo FHIR TX Server
- FHIR TX Server usa: `http://snomed.info/sct/900000000000207008/version/20250201`

**Estratégia de Correção:**
1. Validar cada código contra SNOMED International Edition
2. Verificar se códigos estão ativos na versão 20250201
3. Buscar códigos alternativos válidos se retired
4. Atualizar display names para oficiais SNOMED
5. Considerar usar SNOMED GPS (General Purpose Subset) para maior estabilidade

**Tempo Estimado:** 2-3 horas (requer pesquisa profunda)

---

### **PHASE 3.2: LOINC Code Validation (~12 errors)**
**Prioridade:** Alta | **Complexidade:** Alta | **Requer:** Opus 4

**Problemas Identificados:**
```
ERROR: Unknown code 'LA29043-2' in LOINC
ERROR: Unknown code 'LA29042-4' in LOINC
ERROR: Unknown code 'LA33058-8' in LOINC
ERROR: Wrong Display Name 'UV intensity' for 89027-7
       Valid: 'Hearing threshold Ear - right --6000 Hz'
ERROR: Wrong Display Name 'Social interaction participants' for 89600-1
       Valid: 'FDA-init label compl act drug list inact'
```

**Códigos LOINC Problemáticos:**
- `LA29043-2` - LOINC Answer code (3x)
- `LA29042-4` - LOINC Answer code (3x)
- `LA33058-8` - LOINC Answer code (3x)
- `89027-7` - LOINC code com display errado (usado para UV, mas é audiometria)
- `89600-1` - LOINC code com display errado (usado para social, mas é FDA)

**Causa Raiz:**
- Códigos LOINC Answer (LA*) podem não estar no TX Server
- Códigos LOINC principais sendo usados incorretamente (semântica errada)
- Display names não correspondem ao LOINC official short name

**Estratégia de Correção:**
1. Validar códigos LA* em loinc.org
2. Buscar códigos LOINC corretos para:
   - UV exposure/intensity
   - Social interaction metrics
3. Usar LOINC short names oficiais para displays
4. Considerar criar extensões se não houver códigos LOINC adequados

**Tempo Estimado:** 2-3 horas (requer pesquisa em loinc.org)

---

### **PHASE 3.3: StructureDefinition Snapshot Errors (~200 errors)**
**Prioridade:** Alta | **Complexidade:** Muito Alta | **Requer:** Opus 4

**Problemas Identificados:**
- Pattern value mismatches em snapshots
- Cardinality constraint violations
- Unknown codes em pattern definitions
- Inconsistências entre differential e snapshot

**Principais StructureDefinitions Afetados:**
- `advanced-vital-signs` (20 errors)
- `mindfulness-observation` (16 errors)
- `body-composition-observation` (12 errors)
- `noise-exposure-observation` (11 errors)
- `uv-exposure-observation` (11 errors)
- `social-interaction` (10 errors)
- `stress-level` (10 errors)
- `walking-speed-observation` (9 errors)
- `walking-steadiness-observation` (9 errors)
- `macronutrients-observation` (9 errors)

**Causa Raiz:**
- Erros em cascata de terminologia (SNOMED/LOINC)
- Constraints complexos em profiles
- Snapshot generation issues

**Estratégia de Correção:**
1. **Primeiro:** Corrigir todos os erros de terminologia (Phase 3.1 e 3.2)
2. **Depois:** Regenerar snapshots com SUSHI
3. **Validar:** Constraints e cardinality
4. **Ajustar:** Patterns e bindings conforme necessário

**Tempo Estimado:** 4-6 horas (após Phase 3.1 e 3.2)

---

### **PHASE 3.4: StructureMap Validation (~5 errors)**
**Prioridade:** Baixa | **Complexidade:** Média

**Problemas:**
```
ERROR: O tipo HealthKitMindfulness não é conhecido
ERROR: O tipo CSVMindfulness não é conhecido
ERROR: Trajetória de destino desconhecida
```

**Solução:**
1. Definir Logical Models para HealthKitMindfulness e CSVMindfulness
2. OU simplificar StructureMaps para não usar tipos unknowns
3. Validar paths de destino

**Tempo Estimado:** 1 hora

---

## ROADMAP RECOMENDADO

### **Fase Atual: Quick Wins (Phase 2.3-2.6)**
```
✅ Phase 2.2: ValueSet Codes (CONCLUÍDO - 8 errors)
⏭️  Phase 2.3: Canonical URLs (~7 errors) - PRÓXIMO
⏭️  Phase 2.4: Observation Categories (~8 errors)
⏭️  Phase 2.5: Consent Display Names (~6 errors)
⏭️  Phase 2.6: MessageDefinition (~4 errors)
────────────────────────────────────────────────
Target: 254 errors (from 283)
Tempo: ~50 minutos
Modelo: Sonnet (suficiente)
```

### **Próxima Fase: Research Tasks (Phase 3)**
```
📋 Phase 3.1: SNOMED CT Validation (~20 errors)
📋 Phase 3.2: LOINC Validation (~12 errors)
📋 Phase 3.3: StructureDefinition Fixes (~200 errors)
📋 Phase 3.4: StructureMap Validation (~5 errors)
────────────────────────────────────────────────
Target: <50 errors (from 254)
Tempo: 8-12 horas
Modelo: OPUS 4 RECOMENDADO
```

---

## ARTEFATOS TÉCNICOS

### CodeSystems Importantes
**audit-levels** (CodeSystem/audit-levels):
- `low` - Low Level
- `medium` - Medium Level
- `high` - High Level

**audit-formats** (CodeSystem/audit-formats):
- `text` - Text Format
- `structured` - Structured Format
- `mixed` - Mixed Format

### Valid Observation Categories (HL7)
- `social-history`
- `vital-signs`
- `imaging`
- `laboratory`
- `procedure`
- `survey`
- `exam`
- `therapy`
- `activity`

### Jurisdiction Codes Válidos
**ISO 3166-1:**
- `urn:iso:std:iso:3166#PT` "Portugal"
- `urn:iso:std:iso:3166#BR` "Brazil"
- `urn:iso:std:iso:3166#US` "United States of America"

**UN M49:**
- `http://unstats.un.org/unsd/methods/m49/m49.htm#150` "Europe"
- `http://unstats.un.org/unsd/methods/m49/m49.htm#021` "Northern America a/"
- `http://unstats.un.org/unsd/methods/m49/m49.htm#005` "South America"

---

## DOCUMENTOS RELACIONADOS

### Backups e Análises
- `backups/backup_docs/error_analysis_phase2_20250930_130000.txt` - Análise detalhada 291 errors
- `backups/backup_docs/phase2_progress_20250930_130830.md` - Progress tracking completo
- `backups/backup_phases/backup_phase2.2_v0.1_20250930_125650/` - Backup Phase 2.2

### Scripts de Correção
- `fix_phase2.2_20250930_130000_v0.1.sh` - ValueSet codes fix (EXECUTADO ✅)
- `backups/backup_phases/fix_phase2_20250929_222745_v0.1.sh` - Phase 2.1 (não executado)
- `backups/backup_phases/fix_phase2_20250930_121940_v0.2.sh` - Phase 2 alt (não executado)

### Análises Anteriores
- `canonical_url_analysis.txt` - Análise de 31 CodeSystems com URL mismatch

---

## LIÇÕES APRENDIDAS

### Phase 2.2 Insights
1. **Sempre verificar CodeSystem concepts antes de usar códigos**
   - SUSHI valida códigos contra definições
   - Erro "Code not defined" é mais claro que runtime errors

2. **Aliases melhoram legibilidade**
   - `$AuditLevels#high` vs URL completa
   - Facilita manutenção futura

3. **Impacto pode variar da estimativa**
   - Estimado: -12 errors
   - Real: -8 errors
   - Causa: Menos instâncias afetadas que o esperado

4. **Correção em cascata é poderosa**
   - Phase 1: 1 linha mudada = -178 errors
   - Buscar root causes em configs globais

### Estratégia Geral
1. **Quick Wins primeiro** - Momentum e validação
2. **Research tasks depois** - Com Opus 4
3. **Terminologia antes de Profiles** - Evita retrabalho
4. **Backups sempre** - Segurança e rastreabilidade

---

## MÉTRICAS DE QUALIDADE

### Error Density
- **Início:** 469 errors / 221 resources = 2.12 errors/resource
- **Atual:** 283 errors / 221 resources = 1.28 errors/resource
- **Melhoria:** 39.7% reduction

### Velocidade de Correção
- **Phase 1:** 178 errors em ~30 min = 5.9 errors/min
- **Phase 2.2:** 8 errors em ~10 min = 0.8 errors/min
- **Média:** 186 errors em ~40 min = 4.65 errors/min

### Target Final
- **Meta:** < 50 errors (90% reduction)
- **Restante:** 233 errors
- **Estimativa:** 8-12 horas (Phase 3 completa)

---

**Última atualização:** 2025-09-30 13:12:00
**Status:** Ready for Phase 2.3 (Canonical URL Mismatches)
**Próximo passo:** Executar fix_phase2.3 script (~7 errors)