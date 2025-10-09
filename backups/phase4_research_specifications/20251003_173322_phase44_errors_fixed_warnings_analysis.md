# Análise dos 83 Warnings (Build: 2025-10-03 17:29)

## 📊 Sumário Executivo

**Total de Warnings:** 83
**Errors:** 0 (✅ corrigidos de 11 → 0)

---

## Categorização dos Warnings

### 1️⃣ **HTML Fragments não incluídos (4 warnings)** - Prioridade: BAIXA
- `ip-statements.xhtml` não incluído
- `cross-version-analysis.xhtml` não incluído
- `dependency-table.xhtml` não incluído
- `globals-table.xhtml` não incluído

**Ação:** Ignorar (warnings de template padrão)

---

### 2️⃣ **URLs não resolvíveis - Consent Policies (12 warnings)** - Prioridade: MÉDIA

#### MindfulnessAccessPolicy (6 warnings):
- `urn:oid:2.16.840.1.113883.3.4.5.1` (authority)
- `urn:eu:gdpr:2016:679` (uri)
- `urn:oid:2.16.840.1.113883.3.4.5.2` (authority)
- `urn:us:hipaa:privacy` (uri)
- `urn:oid:2.16.840.1.113883.3.4.5.3` (authority)
- `urn:br:lgpd:2018` (uri)

#### MultiJurisdictionalConsentExample (6 warnings):
- `https://eur-lex.europa.eu/eli/reg/2016/679/oj` (authority)
- `urn:eu:gdpr:2016:679` (uri)
- `https://www.hhs.gov/hipaa/index.html` (authority)
- `urn:us:hipaa:privacy` (uri)
- `http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm` (authority)
- `urn:br:lgpd:2018` (uri)

**Ação:** URNs regulatórios esperados - manter como estão

---

### 3️⃣ **Device Identifier URL (1 warning)** - Prioridade: BAIXA
- `urn:oid:2.16.840.1.113883.3.4.5.4` (EnvironmentalDeviceExample)

**Ação:** OID válido - ignorar

---

### 4️⃣ **CQL Expression não suportada (2 warnings)** - Prioridade: BAIXA
- Measure.group[0].stratifier[0].criteria - `text/cql-identifier`
- Measure.group[1].stratifier[0].criteria - `text/cql-identifier`

**Ação:** Linguagem CQL esperada - ignorar

---

### 5️⃣ **UCUM Annotations (1 warning)** - Prioridade: BAIXA
- AdvancedVitalSignsExample: `{ratio}` em autonomicBalance

**Ação:** Válido mas com nota - manter

---

### 6️⃣ **Observation sem Performer (3 warnings)** - Prioridade: MÉDIA
- Observation examples sem `performer` (boas práticas)

**Ação:** Adicionar `performer` a exemplos

---

### 7️⃣ **Patient Identifier URL (1 warning)** - Prioridade: BAIXA
- `urn:oid:2.16.858.1.1.1` (sistema português)

**Ação:** OID válido - ignorar

---

### 8️⃣ **Extensions sem Exemplos (18 warnings)** 🎯 **ALVO PRINCIPAL**

#### Extensions SEM exemplos:
1. `activity-quality`
2. `advanced-vital-signs-context`
3. `allostatic-load`
4. `circadian-phase`
5. `data-localization`
6. `environmental-context`
7. `exposure-conditions`
8. `exposure-location`
9. `homeostasis-index`
10. `jurisdiction-applicability`
11. `measurement-context`
12. `measurement-quality`
13. `mindfulness-import-map`
14. `mobility-alert-level`
15. `nutrition-data-source`
16. `physiological-stress-index`
17. `recovery-efficiency`
18. `regulatory-basis`

**Meta Phase 4.4:** Adicionar estas extensions a exemplos existentes
**Redução esperada:** -18 warnings

---

### 9️⃣ **Profile sem Exemplo (1 warning)** 🎯
- `social-history-observation` profile

**Ação:** Criar exemplo para este profile
**Redução esperada:** -1 warning

---

### 🔟 **Extension Context Type Issues (40 warnings)** - Prioridade: BAIXA/MÉDIA

#### Tipo A: "Element context" - deve ser específico (22 warnings)
Extensions com `context[0] = Element` (muito genérico):
- `activity-quality`
- `advanced-vital-signs-context`
- `alert-message`, `alert-timing`
- `audit-format`, `audit-level`, `audit-retention`
- `data-localization`
- `environmental-context`
- `jurisdiction-applicability`
- `measurement-context`
- `mindfulness-*` (8 extensions)
- `regulatory-basis`
- `social-activity`, `social-context`, `social-support`
- `stress-coping`, `stress-triggers`

#### Tipo B: FHIRPath quando deveria ser "element" (18 warnings)
Extensions com contexto FHIRPath mas deveria ser tipo "element":
- `allostatic-load` → Observation
- `circadian-phase` → Observation
- `exposure-conditions` → Observation
- `exposure-location` → Observation
- `homeostasis-index` → Observation
- `measurement-conditions` → Observation
- `measurement-device-type` → Observation
- `measurement-quality` → Observation
- `mobility-alert-level` → Observation
- `nutrition-data-source` → Observation
- `physiological-stress-index` → Observation
- `recovery-efficiency` → Observation

**Ação:** Fase 4.5 - Corrigir context types nas extensions
**Redução esperada:** ~40 warnings (Fase 4.5)

---

### 1️⃣1️⃣ **ValueSet Version Ambiguity (1 warning)** - Prioridade: BAIXA
- `v3-PurposeOfUse` tem múltiplas versões (2.0.0, 3.1.0)
- Usando 3.1.0 mas sem fixar versão

**Ação:** Pin canonical version no IG parameters

---

## 🎯 Estratégia de Correção - Fase 4.4

### Meta: 83 → 57 warnings (-26)

#### **Ações Imediatas** (podem resolver ~19 warnings):
1. ✅ Adicionar 18 extensions a exemplos existentes → -18 warnings
2. ✅ Criar exemplo para `social-history-observation` → -1 warning

#### **Fase 4.5** (pode resolver ~40 warnings):
- Corrigir context types de 40 extensions

#### **Ignoráveis** (25 warnings):
- HTML fragments (4)
- URNs regulatórios (13)
- CQL expression (2)
- OIDs válidos (2)
- UCUM annotations (1)
- ValueSet version (1)
- Observation performer (3) - adicionar se tempo

---

## 📋 Plano de Ação Phase 4.4

### **Batch 1: Adicionar Extensions a Exemplos Existentes (18 extensions)**

#### Sleep Examples:
- `SleepObservationExample1` adicionar:
  - `activity-quality`
  - `circadian-phase`
  - `recovery-efficiency`

#### Vital Signs Examples:
- `AdvancedVitalSignsExample` adicionar:
  - `advanced-vital-signs-context`
  - `measurement-context`
  - `measurement-quality`

#### Environmental Examples:
- `EnvironmentalObservationExample` adicionar:
  - `environmental-context`

- `UVExposureExample` adicionar:
  - `exposure-conditions`
  - `exposure-location`

#### Nutrition Examples:
- `NutritionIntakeObservationExample` adicionar:
  - `nutrition-data-source`

#### Stress Examples:
- `StressLevelExample` adicionar:
  - `allostatic-load`
  - `physiological-stress-index`

#### Mobility Examples:
- `MobilityProfileExample` adicionar:
  - `mobility-alert-level`
  - `homeostasis-index`

#### Consent Examples:
- `MultiJurisdictionalConsentExample` adicionar:
  - `data-localization`
  - `jurisdiction-applicability`
  - `regulatory-basis`

#### Mindfulness Examples:
- `DefaultMindfulnessConfig` adicionar:
  - `mindfulness-import-map`

### **Batch 2: Criar Profile Example (1 profile)**
- Criar `SocialHistoryObservationExample`

---

## 🔢 Contagem Final Esperada

| Categoria | Atual | Após 4.4 | Redução |
|-----------|-------|----------|---------|
| Extensions sem exemplo | 18 | 0 | -18 |
| Profiles sem exemplo | 1 | 0 | -1 |
| Extension context types | 40 | 40 | 0 (Fase 4.5) |
| Outros (ignoráveis) | 24 | 24 | 0 |
| **TOTAL** | **83** | **64** | **-19** |

**Nota:** Meta original era 57, mas com -19 chegamos a 64. Os restantes 7 warnings requerem correção de extension contexts (Fase 4.5).

---

## ✅ Próximos Passos

1. ✅ Documentar correção dos 11 errors (este arquivo)
2. ⏳ Commit: "Phase 4.4: Fix 11 validation errors with researched LOINC codes"
3. ⏳ Adicionar 18 extensions a exemplos existentes
4. ⏳ Criar 1 exemplo de profile (social-history)
5. ⏳ Build e verificar: esperado 83 → 64 warnings
6. ⏳ Commit progresso
7. ⏳ Fase 4.5: Corrigir extension contexts

---

## 📝 Notas Técnicas

### Códigos LOINC Corrigidos (Commit atual):
1. `45687-1` → `10570-0` ✅ "Consistency of Cervical mucus"
2. `45700-2` → `11976-8` ✅ "Ovulation date"
3. `82810-3` → (mantido) ✅ "Pregnancy status" (já estava correto)
4. `69968-8` → `60832-3` ✅ "Room temperature"

### Pesquisa Realizada:
- https://loinc.org (verificação de códigos válidos)
- Todos os códigos validados em terminology server

### Tempo de Build:
- SUSHI: ~47s (0 errors, 0 warnings)
- IG Publisher: ~8m26s (0 errors, 83 warnings)

---

**Última atualização:** 2025-10-03 17:33:22
**Commit:** (pendente)
**Status:** ✅ Errors corrigidos | ⏳ Warnings Phase 4.4 em andamento
