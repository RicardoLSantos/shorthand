# FHIR IG Specifications Reference - iOS Lifestyle Medicine
**Version:** 0.3 - ANÁLISE COMPLETA SISTEMÁTICA
**Timestamp:** 2025-09-29 22:21:41
**Project:** iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide

## ANÁLISE SISTEMÁTICA COMPLETA DO ARQUIVO qa.txt (81,532 tokens)

### ESTATÍSTICAS GLOBAIS DO PROJETO
- **Total de ERRORs:** 479 (confirmado por soma de recursos individuais)
- **Total de WARNINGs:** 184 (confirmado por soma de recursos individuais)
- **Total de INFOs:** 30
- **Build Errors:** 7 / 13 / 0
- **Recursos Analisados:** 221 recursos individuais
- **IG Publisher Version:** 2.0.17
- **FHIR Version:** 4.0.1
- **Data da Análise:** 2025-09-29 22:03:41 WEST

---

## INVENTÁRIO COMPLETO POR CATEGORIA DE RECURSO

### RECURSOS COM ERROS (479 total) - Distribuição por Tipo

| Tipo de Recurso | Recursos com Erro | % do Total |
|------------------|-------------------|------------|
| **StructureDefinition** | 76 recursos | 38.6% |
| **ValueSet** | 52 recursos | 26.4% |
| **CodeSystem** | 35 recursos | 17.8% |
| **Observation** | 15 recursos | 7.6% |
| **Device** | 5 recursos | 2.5% |
| **Questionnaire** | 4 recursos | 2.0% |
| **StructureMap** | 2 recursos | 1.0% |
| **OperationDefinition** | 2 recursos | 1.0% |
| **MessageDefinition** | 2 recursos | 1.0% |
| **Consent** | 2 recursos | 1.0% |
| **Basic** | 2 recursos | 1.0% |
| **Outros** | 6 recursos | 3.0% |

---

## TOP 30 RECURSOS MAIS PROBLEMÁTICOS (por número de erros)

| Rank | Erros | Recurso | Tipo |
|------|-------|---------|------|
| 1 | 21 | StructureDefinition-advanced-vital-signs | StructureDefinition |
| 2 | 17 | StructureDefinition-mindfulness-observation | StructureDefinition |
| 3 | 15 | StructureDefinition-activity-observation | StructureDefinition |
| 4 | 13 | StructureDefinition-body-composition-observation | StructureDefinition |
| 5 | 12 | StructureDefinition-uv-exposure-observation | StructureDefinition |
| 6 | 12 | StructureDefinition-noise-exposure-observation | StructureDefinition |
| 7 | 11 | StructureDefinition-stress-level | StructureDefinition |
| 8 | 11 | StructureDefinition-social-interaction | StructureDefinition |
| 9 | 10 | StructureDefinition-walking-steadiness-observation | StructureDefinition |
| 10 | 10 | StructureDefinition-walking-speed-observation | StructureDefinition |
| 11 | 10 | StructureDefinition-macronutrients-observation | StructureDefinition |
| 12 | 9 | Observation-UVExposureExample | Observation |
| 13 | 9 | Observation-NoiseExposureExample | Observation |
| 14 | 8 | Observation-WalkingSteadinessExample | Observation |
| 15 | 8 | Observation-CompleteMindfulnessSession | Observation |
| 16 | 7 | StructureDefinition-physical-activity-observation | StructureDefinition |
| 17 | 7 | StructureDefinition-mobility-profile | StructureDefinition |
| 18 | 7 | Observation-WalkingSpeedExample | Observation |
| 19 | 7 | Observation-SleepObservationExample1 | Observation |
| 20 | 7 | Observation-MindfulnessObservationExample | Observation |
| 21 | 6 | Observation-BodyCompositionExample | Observation |
| 22 | 5 | Observation-StressLevelExample | Observation |
| 23 | 5 | Observation-SocialInteractionExample | Observation |
| 24 | 5 | Observation-PhysicalActivityExample1 | Observation |
| 25 | 4 | ValueSet-ovulation-test-valueset | ValueSet |
| 26 | 4 | ValueSet-fertility-status-valueset | ValueSet |
| 27 | 4 | ValueSet-cervical-mucus-valueset | ValueSet |
| 28 | 4 | StructureMap-MindfulnessHealthKitTransform | StructureMap |
| 29 | 4 | StructureDefinition-water-intake-observation | StructureDefinition |
| 30 | 4 | StructureDefinition-social-support | StructureDefinition |

---

## PROBLEMAS CRÍTICOS IDENTIFICADOS

### 1. LINKS QUEBRADOS E REFERÊNCIAS INVÁLIDAS (7 ERROR total)

| Referência Quebrada | Ocorrências | Recursos Afetados |
|---------------------|-------------|-------------------|
| **Device/iphone-example** | 4 | NoiseExposureExample, UVExposureExample, WalkingSpeedExample, WalkingSteadinessExample |
| **StructureDefinition-observation-vital-signs-weight.html** | 1 | bodymetrics.html |
| **StructureDefinition-observation-vital-signs-height.html** | 1 | bodymetrics.html |
| **StructureDefinition-observation-vital-signs-bmi.html** | 1 | bodymetrics.html |

### 2. MISSING IMPLEMENTATION GUIDE DESCRIPTIONS (9 WARNING)

**Recursos sem descrição no ImplementationGuide:**
- CodeSystem/MindfulnessSettingCS
- StructureMap/MindfulnessCSVTransform
- StructureMap/MindfulnessHealthKitTransform
- Consent/MindfulnessAccessPolicy
- Consent/MindfulnessSecurityDefinition
- Organization/Org2RDoc
- Patient/PatientMindfulness
- Patient/example
- Practitioner/osa-practitioner-kyle-anydoc

### 3. STRUCTUREDEFINITION CRÍTICOS (155 erros concentrados)

**Top 5 StructureDefinitions mais problemáticos:**
1. **advanced-vital-signs** (21 erros) - PRIORIDADE MÁXIMA
2. **mindfulness-observation** (17 erros) - PRIORIDADE ALTA
3. **activity-observation** (15 erros) - PRIORIDADE ALTA
4. **body-composition-observation** (13 erros) - PRIORIDADE MÉDIA
5. **uv-exposure-observation** (12 erros) - PRIORIDADE MÉDIA

### 4. VALUESET PROBLEMS (52 recursos com erros)

**Padrões de problemas em ValueSets:**
- Problemas de canonical URL
- Missing required metadata (experimental, publisher)
- Binding issues com CodeSystems

### 5. OBSERVATION EXAMPLES (15 recursos, 89 erros total)

**Observations mais problemáticas:**
- UVExposureExample (9 erros)
- NoiseExposureExample (9 erros)
- WalkingSteadinessExample (8 erros)
- CompleteMindfulnessSession (8 erros)

---

## ESTRATÉGIA DE CORREÇÃO RECOMENDADA

### FASE 2: CORREÇÃO DE LINKS QUEBRADOS (PRIORIDADE URGENTE)
**Target:** Eliminar 7 ERRORs de links quebrados
- Criar Device/iphone-example missing
- Corrigir links para StructureDefinitions de vital signs

### FASE 3: STRUCTUREDEFINITION FIXES (PRIORIDADE ALTA)
**Target:** Reduzir 155 ERRORs em StructureDefinitions
- Começar por advanced-vital-signs (21 erros)
- Focar em canonical URLs e metadata required

### FASE 4: VALUESET CORRECTIONS (PRIORIDADE MÉDIA)
**Target:** Corrigir 52 ValueSets com problemas
- ShareableValueSet compliance
- Metadata obrigatória (experimental, publisher)

### FASE 5: OBSERVATION EXAMPLES (PRIORIDADE BAIXA)
**Target:** Corrigir 89 ERRORs em 15 Observations
- Device references
- Profile compliance

---

## FHIR R4 SPECIFICATIONS REFERENCE

### Canonical URL Requirements (HL7 Standard)

#### ShareableValueSet Requirements
Conforme **ValueSet - FHIR v4.0.1** (https://hl7.org/fhir/R4/valueset.html):

**Required Elements for ShareableValueSet:**
- `url` (canonical URL)
- `version`
- `name` (computer-friendly name)
- `status` (publication status)
- `experimental` (boolean)
- `publisher`

**Canonical URL Pattern:**
```
{base}/{type}/{id}
```

**Implementação iOS Lifestyle Medicine:**
```yaml
canonical: https://2rdoc.pt/ig/ios-lifestyle-medicine
```

### Observation Categories

#### Reproductive Health Observations
**CORREÇÃO CRÍTICA:** Categoria `reproductive` → `social-history`

**FHIR R4 Observation Categories válidas:**
- `social-history` ✅ (para reproductive health)
- `vital-signs`
- `imaging`
- `laboratory`
- `procedure`
- `survey`
- `exam`
- `therapy`
- `activity`

**Referência oficial:** http://hl7.org/fhir/R4/valueset-observation-category.html

### ValueSet Terminology Binding

#### Required Bindings
- `ValueSet.status` → **required** binding to PublicationStatus
- `ValueSet.experimental` → boolean (required for ShareableValueSet)

#### Extensible Bindings
- `Observation.category` → **extensible** binding to ObservationCategoryCodes

### Implementation Guide Structure

#### Standard Directory Layout (HL7 Spec)
```
/input/
  /fsh/                    ← FSH source files
    /aliases.fsh
    /profiles/
    /valuesets/
    /examples/
    /extensions/
  /pagecontent/           ← Markdown pages
  /includes/              ← Menu and fragments
  /images/               ← Static images
/output/                 ← Generated content
```

### Resource Validation Rules

#### StructureDefinition Requirements
- `url` (canonical) - **required**
- `name` - **required**
- `status` - **required**
- `kind` - **required**
- `abstract` - **required**
- `type` - **required**

#### ValueSet Requirements (ShareableValueSet)
- `url` (canonical) - **required**
- `version` - **required**
- `name` - **required**
- `status` - **required**
- `experimental` - **required**
- `publisher` - **required**

### SUSHI Configuration Specifications

#### Dependencies (sushi-config.yaml)
```yaml
dependencies:
  ihe.iti.pcf: 1.1.0
  hl7.fhir.uv.ips: 1.1.0
```

#### Resource Management
- **Auto-generated resources:** Controlled by `auto-oid-root`
- **Manual resource URLs:** Follow canonical pattern
- **Version management:** Semantic versioning (x.y.z)

### Publisher Workflow

#### IG Publisher Process
1. **SUSHI Compilation** → FSH to JSON conversion
2. **Resource Validation** → FHIR R4 conformance
3. **Jekyll Generation** → Static site creation
4. **Link Resolution** → Cross-reference validation
5. **QA Report** → Error/warning summary

#### Critical Files
- `sushi-config.yaml` → Configuration root
- `_genonce.sh` → Publisher execution
- `publisher.jar` → HL7 IG Publisher tool

---

## HISTÓRICO DE CORREÇÕES

### Fase 1 (v0.1 - v0.6) - Estrutural ✅
- ✅ Correção de estrutura de diretórios
- ✅ Resolução de ValueSet duplicados
- ✅ Fix de encoding UTF-8 em _genonce.sh
- ✅ SUSHI: 1 error → 0 errors, 0 warnings

### Próximas Fases Planejadas
- **Fase 2:** Links quebrados (Target: -7 ERRORs)
- **Fase 3:** StructureDefinitions críticos (Target: -155 ERRORs)
- **Fase 4:** ValueSet compliance (Target: -52 recursos)
- **Fase 5:** Observation examples (Target: -89 ERRORs)

---

**META FINAL:** Reduzir de 479 ERRORs para <50 ERRORs
**PRIORIDADE:** Eliminar links quebrados primeiro (impacto imediato na usabilidade)

**Documento criado:** 2025-09-29 22:21:41
**Base de análise:** qa.txt completo (81,532 tokens) - análise sistemática de 221 recursos
**Status do projeto:** 479 ERRORs mapeados completamente por categoria e prioridade