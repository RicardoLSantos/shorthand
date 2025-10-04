# FHIR IG Specifications Reference - iOS Lifestyle Medicine
**Version:** 0.4 - PESQUISA INTENSIVA HL7 FHIR R4 + FÓRUNS
**Timestamp:** 2025-09-30 12:04:46
**Project:** iOS Lifestyle Medicine HEADS2 FMUP Implementation Guide
**Baseado em:** Pesquisa extensiva em hl7.org/fhir/R4, chat.fhir.org, FHIR Zulip

---

## ANÁLISE COMPLETA DOS 469 ERROS REMANESCENTES

### ESTATÍSTICAS ATUALIZADAS (Pós-Fase 2)
- **ERRORs:** 469 (redução de 479 → 469, -10 erros)
- **WARNINGs:** 188 (aumento de 184 → 188, +4 warnings)
- **Broken Links:** 0 ✅ (100% resolvidos)
- **Build Time:** 4min 54s
- **Recursos validados:** 221

---

## PADRÕES DE ERROS IDENTIFICADOS (Pesquisa Profunda)

### 🔴 **CATEGORIA 1: CANONICAL URL MISMATCHES (35+ erros)**

#### Problema Identificado:
```
ERROR: CodeSystem.url: Resource id/url mismatch:
MindfulnessSettingCS/https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-setting
```

#### Causa Raiz (FHIR R4 Spec):
- **StructureDefinition.url deve ser igual ao StructureDefinition.id**
- Padrão FHIR: `{canonical-base}/{resource-type}/{id}`
- Publisher valida: `id` == última parte de `url`

#### Exemplos do Projeto:
| Recurso | ID (Atual) | URL (Atual) | Problema |
|---------|------------|-------------|----------|
| CodeSystem-MindfulnessSettingCS | MindfulnessSettingCS | .../mindfulness-setting | ❌ Mismatch |
| CodeSystem-advanced-vital-signs-context-cs | advanced-vital-signs-context-cs | .../advanced-vital-signs-context | ✅ Match |

#### Solução (HL7 FHIR R4 Best Practices):
1. **Opção A:** Padronizar IDs com kebab-case (recomendado)
   ```fsh
   CodeSystem: MindfulnessSettingCS
   Id: mindfulness-setting-cs  // ← Fix aqui
   ```

2. **Opção B:** Usar special-url parameter (não recomendado)

#### Impacto: **~35 CodeSystems** com este padrão

---

### 🔴 **CATEGORIA 2: JURISDICTION DISPLAY NAMES (35+ erros)**

#### Problema Identificado:
```
ERROR: CodeSystem.jurisdiction[1].coding[0].display:
Wrong Display Name 'Northern America' for http://unstats.un.org/unsd/methods/m49/m49.htm#021.
Valid display is 'Northern America a/' (for the language(s) 'en-US')
```

#### Causa Raiz (UN M49 Standard):
- UN Statistics Division M49 requer sufixo `/` em alguns displays
- FHIR R4 valida display names contra terminology server
- Código 021 = "Northern America a/" (não "Northern America")

#### Solução Universal:
```fsh
* jurisdiction[+] = urn:iso:std:iso:3166#PT "Portugal"
* jurisdiction[+] = http://unstats.un.org/unsd/methods/m49/m49.htm#021 "Northern America a/"
//                                                                                         ^^^
//                                                                         Adicionar " a/"
```

#### Impacto: **~35 recursos** (todos com jurisdiction Northern America)

---

### 🔴 **CATEGORIA 3: VALUESET BINDING ERRORS (16+ erros)**

#### Problema Identificado:
```
ERROR: Basic/DefaultAuditConfig: Basic.extension[0].value.ofType(code):
Não foi possível determinar o URI do sistema para o código 'detailed' no ValueSet
'https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-levels|0.1.0'
```

#### Causa Raiz (FHIR R4 Validation):
- Código `'detailed'` está sendo usado sem system
- ValueSet `audit-levels` não contém código `#detailed`
- FHIR requer: `system#code` format ou binding correto

#### Exemplos do Projeto:
```fsh
// ❌ ERRADO (código sem system)
* extension[auditLevel].valueCode = #detailed

// ✅ CORRETO (código com system completo)
* extension[auditLevel].valueCode = $AuditLevelsCS#detailed
```

#### Códigos Problemáticos Identificados:
1. `audit-levels`: `detailed`, `minimal`, `comprehensive`
2. `audit-formats`: `fhir`, `json`, `xml`

#### Solução:
1. Verificar se CodeSystem contém todos os códigos necessários
2. Usar binding correto com `$alias#code` syntax
3. Validar ValueSet expansion no terminology server

#### Impacto: **16 erros** em Basic resources (audit/config)

---

### 🔴 **CATEGORIA 4: STRUCTUREDEFINITION SNAPSHOT ERRORS (155+ erros)**

#### Problema Identificado:
- **advanced-vital-signs**: 21 erros
- **mindfulness-observation**: 17 erros
- **activity-observation**: 15 erros
- **body-composition-observation**: 13 erros
- **Mais 14 profiles** com 7-12 erros cada

#### Causa Raiz (FHIR Zulip + chat.fhir.org):

**1. Cardinality Constraints Violation:**
```
Setting an element to a minimum cardinality of 1 does not ensure that data will be present;
specific FHIRPath constraints are required.
```

**2. Snapshot Generation Issues:**
```
The generateSnapshot method of ProfileUtilities expects a snapshot StructureDefinition
as a base and a differential StructureDefinition as the one to apply to the base.
```

**3. Must-Support Misunderstanding:**
```
There has been confusion with implementers sometimes interpreting "must support" flags
in profiles beyond the intended scope.
```

#### Soluções (FHIR R4 Best Practices):

##### A. Cardinality Fixes:
```fsh
// ❌ ERRADO - só cardinality não garante validação
* component 1..* MS

// ✅ CORRETO - cardinality + FHIRPath constraint
* component 1..* MS
* obeys component-must-have-code
Invariant: component-must-have-code
Description: "Component must have a code"
Expression: "component.exists() implies component.code.exists()"
Severity: #error
```

##### B. Snapshot Generation (SUSHI):
```yaml
# sushi-config.yaml
# Garantir que SUSHI gera snapshots
FSHOnly: false
```

##### C. BaseDefinition Correto:
```fsh
// ✅ Sempre herdar de perfil FHIR base ou US Core
Profile: AdvancedVitalSigns
Parent: Observation  // ← Deve ser recurso FHIR base válido
```

#### Impacto: **155+ erros concentrados** em StructureDefinitions

---

### 🟡 **CATEGORIA 5: MISSING IG DESCRIPTIONS (9 warnings)**

#### Problema:
```
WARNING: Unable to find ImplementationGuide.definition.resource.description
for the resource CodeSystem/MindfulnessSettingCS
```

#### Solução (sushi-config.yaml):
```yaml
resources:
  CodeSystem/MindfulnessSettingCS:
    name: Mindfulness Setting Code System
    description: Defines settings where mindfulness activities can occur
  StructureMap/MindfulnessCSVTransform:
    name: Mindfulness CSV Transform
    description: Transforms CSV mindfulness data to FHIR resources
```

#### Impacto: 9 recursos sem descrição

---

### 🟡 **CATEGORIA 6: SHAREABLECODESYSTEM COMPLIANCE (35 warnings)**

#### Problema:
```
WARNING: CodeSystem: Os sistemas de códigos publicados DEVERIAM estar em conformidade
com o perfil ShareableCodeSystem, que diz que o elemento CodeSystem.description
é obrigatório, mas não está presente
```

#### Spec FHIR R4 ShareableCodeSystem:
**Elementos obrigatórios:**
- `url` (canonical)
- `version`
- `name`
- `status`
- `experimental`
- **`description`** ← Faltando em muitos CodeSystems
- `publisher`

#### Solução Universal:
```fsh
CodeSystem: MindfulnessTypeCS
Id: mindfulness-type
Title: "Mindfulness Type Code System"
Description: "Defines types of mindfulness practices (meditation, breathing, etc.)"  // ← Adicionar
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-type"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc"
```

#### Impacto: **35 CodeSystems** precisam de `description`

---

## DESCOBERTAS CRÍTICAS DA PESQUISA HL7 FHIR

### 🔍 **Device.property NO FHIR R4**

**DESCOBERTA IMPORTANTE:**
```
Device.property NÃO existe nativamente em FHIR R4!
```

#### Confirmado em:
- HL7.org/fhir/R4/device.html
- HAPI FHIR R4 API documentation
- Cross-Version Extension docs

#### O que EXISTE:
```json
// DeviceDefinition.property (não Device.property!)
"property": [{
  "type": { "CodeableConcept" },  // Required
  "valueQuantity": [{ "Quantity" }],  // 0..*
  "valueCode": [{ "CodeableConcept" }]  // 0..*
}]
```

#### Correção Aplicada (Fase 2):
```fsh
// ✅ Usar Device.note para properties descritivas
Instance: iphone-example
InstanceOf: Device
* deviceName.name = "iPhone"
* manufacturer = "Apple Inc."
* version.value = "iOS 17.0"
* note.text = "iPhone 15 Pro running iOS 17.0 - Apple Inc."
```

---

### 🔍 **Observation Validation Requirements**

#### Required Elements (FHIR R4):
1. **`status`** - required code (final, amended, etc.)
2. **`code`** - required CodeableConcept
3. **`subject`** - optional but recommended

#### Common Validation Errors:
```
"dataAbsentReason SHALL only be present if Observation.value[x] is not present"
```

#### Must-Support Interpretation:
> Must Support does NOT mean "must always include data"
> It means "must process if present"

#### Category Bindings:
- **Preferred** (não required) binding
- Use: `social-history` para reproductive health
- Extensible: pode adicionar códigos locais

---

### 🔍 **StructureDefinition Snapshot vs Differential**

#### Descoberta (FHIR Zulip):
```
Although the specification does not require a snapshot,
constraint generation mechanisms DO require it.
```

#### Geradores de Snapshot:
1. **SUSHI** (recomendado): `sushi . -s`
2. **Forge**: Options → "Save snapshot component"
3. **HAPI FHIR**: ProfileUtilities.generateSnapshot()

#### Erro Comum:
```
"has an element that is not marked with a snapshot match"
→ Indica differential mal estruturado
```

---

## ESTRATÉGIA DE CORREÇÃO PRIORIZADA

### 🎯 **FASE 2.1: Quick Wins (Target: -70 erros)**

#### 1. Jurisdiction Display Names (35 erros → 0)
**Tempo estimado:** 10min
**Complexidade:** Baixa
**Script:** Search & replace em massa

```bash
# Substituir em todos os .fsh files
find input/fsh -name "*.fsh" -exec sed -i '' \
  's/"Northern America"/"Northern America a\/"/g' {} \;
```

#### 2. Canonical URL Mismatches (35 erros → 0)
**Tempo estimado:** 20min
**Complexidade:** Média
**Approach:** Padronizar IDs

```fsh
# Pattern: Converter PascalCase → kebab-case
MindfulnessSettingCS → mindfulness-setting-cs
AdvancedVitalSignsContextCS → advanced-vital-signs-context-cs
```

---

### 🎯 **FASE 2.2: Medium Priority (Target: -80 erros)**

#### 3. ValueSet Binding Errors (16 erros → 0)
**Tempo estimado:** 30min
**Ação:** Corrigir códigos sem system

#### 4. ShareableCodeSystem Descriptions (35 warnings → 0)
**Tempo estimado:** 40min
**Ação:** Adicionar description a todos CodeSystems

#### 5. IG Resource Descriptions (9 warnings → 0)
**Tempo estimado:** 15min
**Ação:** Atualizar sushi-config.yaml

---

### 🎯 **FASE 3: StructureDefinitions (Target: -155 erros)**

#### Approach Sistemático:
1. **advanced-vital-signs** (21 erros)
2. **mindfulness-observation** (17 erros)
3. **activity-observation** (15 erros)
4. **body-composition-observation** (13 erros)
5. Demais profiles (7-12 erros cada)

#### Técnicas:
- Revisar cardinality constraints
- Adicionar FHIRPath invariants
- Validar baseDefinition
- Garantir snapshot generation

---

## RECURSOS DE REFERÊNCIA UTILIZADOS

### 📚 Especificações Oficiais:
1. **FHIR R4 Conformance Rules:**
   https://hl7.org/fhir/R4/conformance-rules.html

2. **StructureDefinition:**
   https://hl7.org/fhir/R4/structuredefinition.html

3. **ElementDefinition:**
   https://hl7.org/fhir/R4/elementdefinition.html

4. **Validation Guide:**
   https://hl7.org/fhir/R4/validation.html

5. **Device Resource:**
   https://hl7.org/fhir/R4/device.html

6. **Observation Resource:**
   https://hl7.org/fhir/R4/observation.html

### 💬 Fóruns e Discussões:
1. **FHIR Chat - Structure Definition:**
   https://chat-archive.fhir.org/stream/179166-implementers/topic/Structure.20Definition.html

2. **FHIR Chat - Snapshot Generation:**
   https://chat-archive.fhir.org/stream/179167-hapi/topic/Generate.20Snapshot.20from.20StructureDefinition.html

3. **FHIR Zulip - Implementation Guide Validation:**
   https://chat-archive.fhir.org/stream/179166-implementers/

### 🛠️ Ferramentas:
1. **SUSHI** (FSH → FHIR): https://fshschool.org/
2. **IG Publisher**: https://github.com/HL7/fhir-ig-publisher
3. **Validator**: https://github.com/hapifhir/org.hl7.fhir.core

---

## META FINAL DO PROJETO

### Objetivo:
**469 ERRORs → <50 ERRORs** (redução de ~90%)

### Roadmap:
- ✅ **Fase 1:** Estrutura + encoding (479 → 469)
- ✅ **Fase 2.0:** Links quebrados (479 → 469, -10)
- 🎯 **Fase 2.1:** Quick wins (469 → 399, -70)
- 🎯 **Fase 2.2:** Medium priority (399 → 319, -80)
- 🎯 **Fase 3:** StructureDefinitions (319 → 164, -155)
- 🎯 **Fase 4:** Polimento final (164 → <50)

### Tempo Estimado Total:
- Fase 2.1: 30min
- Fase 2.2: 1h 25min
- Fase 3: 3-4 sessões
- **Total:** 6-8 horas de trabalho focado

---

**Documento criado:** 2025-09-30 12:04:46
**Baseado em:** Pesquisa extensiva HL7 FHIR R4 + chat.fhir.org + FHIR Zulip
**Próximo passo:** fix_phase2_v0.2 com correções quick wins
**Status:** 469 ERRORs mapeados e estratégia de correção definida