# FHIR IG Specifications Reference - iOS Lifestyle Medicine
**Version:** 0.2
**Timestamp:** 2025-09-29 22:09:58
**Project:** iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide

## QUANTIFICAÇÃO EXATA DE ERROS - ANÁLISE qa.txt

### Resumo Estatístico
- **Total de ERRORs:** 479
- **Total de WARNINGs:** 184
- **Total de INFOs:** 30
- **Build Errors:** 7 / 13 / 0

### ERRORs por Tipo (479 total) - Ordem Decrescente de Incidência

| Frequência | Tipo de Erro | Categoria |
|------------|--------------|-----------|
| 21 | StructureDefinition/advanced-vital-signs | StructureDefinition |
| 17 | StructureDefinition/mindfulness-observation | StructureDefinition |
| 15 | StructureDefinition/activity-observation | StructureDefinition |
| 13 | StructureDefinition/body-composition-observation | StructureDefinition |
| 12 | StructureDefinition/uv-exposure-observation | StructureDefinition |
| 12 | StructureDefinition/noise-exposure-observation | StructureDefinition |
| 11 | StructureDefinition/stress-level | StructureDefinition |
| 11 | StructureDefinition/social-interaction | StructureDefinition |
| 10 | StructureDefinition/walking-steadiness-observation | StructureDefinition |
| 10 | StructureDefinition/walking-speed-observation | StructureDefinition |
| 10 | StructureDefinition/macronutrients-observation | StructureDefinition |
| 8 | Observation/UVExposureExample | Observation |
| 8 | Observation/NoiseExposureExample | Observation |
| 8 | Observation/CompleteMindfulnessSession | Observation |
| 7 | StructureDefinition/physical-activity-observation | StructureDefinition |
| 7 | StructureDefinition/mobility-profile | StructureDefinition |
| 7 | Questionnaire | Questionnaire |
| 7 | Observation/WalkingSteadinessExample | Observation |
| 7 | Observation/SleepObservationExample1 | Observation |
| 7 | Observation/MindfulnessObservationExample | Observation |

### WARNINGs por Tipo (184 total) - Ordem Decrescente de Incidência

| Frequência | Tipo de Warning | Categoria |
|------------|-----------------|-----------|
| 33 | StructureDefinition (genérico) | StructureDefinition |
| 10 | Measure/MindfulnessProgressReport | Measure |
| 9 | Unable to find ImplementationGuide | IG Configuration |
| 7 | ValueSet (genérico) | ValueSet |
| 6 | Consent/MindfulnessAccessPolicy | Consent |
| 5 | StructureDefinition/mindfulness-observation | StructureDefinition |
| 3 | StructureDefinition/advanced-vital-signs-context | StructureDefinition |
| 3 | Observation/StressLevelExample | Observation |
| 2 | StructureDefinition/mindfulness-schedule | StructureDefinition |
| 2 | StructureDefinition/mindfulness-configuration | StructureDefinition |
| 2 | StructureDefinition/mindfulness-audit | StructureDefinition |
| 2 | StructureDefinition/mindfulness-audit-config | StructureDefinition |
| 2 | StructureDefinition/mindfulness-alert | StructureDefinition |
| 2 | StructureDefinition/measurement-quality | StructureDefinition |
| 2 | StructureDefinition/exposure-location | StructureDefinition |

### Principais Problemas Identificados

#### 1. StructureDefinition Issues (Mais Crítico)
- **Total de ERRORs em StructureDefinitions:** 142+ erros
- **Perfis mais problemáticos:**
  - advanced-vital-signs (21 erros)
  - mindfulness-observation (17 erros)
  - activity-observation (15 erros)

#### 2. Device Reference Issues
- **Observações com links quebrados:** Device/iphone-example
- **Afetados:** NoiseExposureExample, UVExposureExample, WalkingSpeedExample, WalkingSteadinessExample

#### 3. Missing Implementation Guide Descriptions
- **9 WARNINGs** sobre recursos sem descrição no ImplementationGuide
- **Recursos afetados:** CodeSystem, StructureMap, Consent, Organization, Patient, Practitioner

#### 4. HTML Link Resolution Errors
- **7 ERRORs** de links não resolvidos em páginas HTML
- **Páginas afetadas:** bodymetrics.html, observation examples

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

### Fase 1 (v0.1 - v0.6) - Estrutural
- ✅ Correção de estrutura de diretórios
- ✅ Resolução de ValueSet duplicados
- ✅ Fix de encoding UTF-8 em _genonce.sh
- ✅ SUSHI: 1 error → 0 errors, 0 warnings

### Próximas Fases Recomendadas
- **Fase 2:** Correção de StructureDefinitions (142+ erros críticos)
- **Fase 3:** Resolução de Device references quebradas
- **Fase 4:** Adição de descrições em ImplementationGuide
- **Fase 5:** Correção de links HTML quebrados

---

**Documento criado:** 2025-09-29 22:09:58
**Base de análise:** qa.txt gerado por HL7 FHIR IG Publisher
**Status do projeto:** 479 ERRORs, 184 WARNINGs identificados e categorizados