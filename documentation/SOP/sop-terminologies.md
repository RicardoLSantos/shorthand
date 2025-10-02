# SOP-002: Terminologias e Vocabulários em FHIR
**Standard Operating Procedure para Gestão de Terminologias em Implementation Guides**

## 1. INTRODUÇÃO

### 1.1 Objetivo
Este SOP estabelece os procedimentos para implementação, mapeamento e gestão de terminologias em Implementation Guides FHIR, garantindo interoperabilidade semântica entre sistemas de saúde.

### 1.2 Escopo
Aplica-se a todos os aspectos de terminologia incluindo CodeSystems, ValueSets, ConceptMaps e NamingSystems em projetos FHIR.

### 1.3 Referências Fundamentais
- HL7 Terminology (THO)¹: https://terminology.hl7.org/
- FHIR Terminology Service²: http://hl7.org/fhir/R5/terminology-service.html
- Using Codes in FHIR³: http://hl7.org/fhir/R5/terminologies.html
- ISO TR 21300:2014⁴: Principles of Mapping Between Terminological Systems

## 2. TERMINOLOGIAS PADRÃO INTERNACIONAIS

### 2.1 SNOMED CT
**Systematized Nomenclature of Medicine Clinical Terms**

#### 2.1.1 Identificação
- **URI**: `http://snomed.info/sct`
- **OID**: `2.16.840.1.113883.6.96`
- **Versão**: Especificar sempre (ex: `http://snomed.info/sct|http://snomed.info/sct/900000000000207008/version/20230901`)

#### 2.1.2 Uso em FHIR⁵
```fsh
// Alias para SNOMED CT
Alias: $SCT = http://snomed.info/sct

// Uso em ValueSet
ValueSet: ConditionsVS
* $SCT#38341003 "Hypertensive disorder"
* $SCT#73211009 "Diabetes mellitus"

// Uso em Binding
* code from http://hl7.org/fhir/ValueSet/condition-code (extensible)
* code.coding ^slicing.discriminator.type = #pattern
* code.coding ^slicing.discriminator.path = "system"
* code.coding contains snomed 1..1 MS
* code.coding[snomed].system = $SCT
```

#### 2.1.3 SNOMED CT IPS Free Set⁶
Subconjunto gratuito para International Patient Summary:
- URI: `http://hl7.org/fhir/uv/ips/ValueSet/snomed-intl-ips`
- Não requer licença nacional SNOMED

### 2.2 LOINC
**Logical Observation Identifiers Names and Codes**

#### 2.2.1 Identificação⁷
- **URI**: `http://loinc.org`
- **OID**: `2.16.840.1.113883.6.1`

#### 2.2.2 Estrutura de Códigos LOINC
```
[Componente]:[Propriedade]:[Tempo]:[Sistema]:[Escala]:[Método]
Exemplo: 8867-4 = Heart rate:NRat:Pt:XXX:Qn
```

#### 2.2.3 Implementação em FHIR
```fsh
Profile: LabResult
Parent: Observation
* code from http://hl7.org/fhir/ValueSet/observation-codes (preferred)
* code.coding ^slicing.discriminator.type = #pattern
* code.coding ^slicing.discriminator.path = "system"
* code.coding contains loinc 1..1 MS
* code.coding[loinc].system = "http://loinc.org"

// Exemplo de uso
Instance: lab-glucose
InstanceOf: LabResult
* code.coding[loinc] = http://loinc.org#15074-8 "Glucose [Mass/volume] in Blood"
* valueQuantity = 95 'mg/dL'
```

### 2.3 ICD-10 e ICD-11
**International Classification of Diseases**

#### 2.3.1 ICD-10-CM/PCS⁸
```fsh
// ICD-10-CM (Clinical Modification)
Alias: $ICD10CM = http://hl7.org/fhir/sid/icd-10-cm

// ICD-10-PCS (Procedure Coding System)  
Alias: $ICD10PCS = http://www.cms.gov/Medicare/Coding/ICD10

// Uso em ValueSet
ValueSet: DiabetesConditions
* $ICD10CM#E11 "Type 2 diabetes mellitus"
* $ICD10CM#E11.9 "Type 2 diabetes mellitus without complications"
* $ICD10CM#E11.65 "Type 2 diabetes mellitus with hyperglycemia"
```

#### 2.3.2 ICD-11⁹
```fsh
// ICD-11 MMS (Mortality and Morbidity Statistics)
Alias: $ICD11 = http://id.who.int/icd11/mms

// Exemplo de uso
* code = $ICD11#5A11 "Type 2 diabetes mellitus"
```

### 2.4 Terminologias de Medicamentos

#### 2.4.1 RxNorm¹⁰
```fsh
Alias: $RXNORM = http://www.nlm.nih.gov/research/umls/rxnorm

ValueSet: CommonMedications
* $RXNORM#314076 "lisinopril 10 MG Oral Tablet"
* $RXNORM#860975 "metformin hydrochloride 500 MG Oral Tablet"
```

#### 2.4.2 ATC (Anatomical Therapeutic Chemical)¹¹
```fsh
Alias: $ATC = http://www.whocc.no/atc

* medication.code = $ATC#C09AA03 "lisinopril"
```

## 3. COMPONENTES DE TERMINOLOGIA EM FHIR

### 3.1 CodeSystem
Define um sistema de códigos completo ou suplemento¹².

#### 3.1.1 Estrutura FSH
```fsh
CodeSystem: CustomConditionStatus
Id: custom-condition-status
Title: "Status de Condições Customizado"
Description: "Estados específicos para condições clínicas"
* #preliminary "Preliminar" "Diagnóstico preliminar, aguardando confirmação"
* #confirmed "Confirmado" "Diagnóstico confirmado por exames"
* #ruled-out "Descartado" "Condição descartada após investigação"
* #in-remission "Em remissão" "Condição em remissão"
```

#### 3.1.2 Hierarquia em CodeSystem
```fsh
CodeSystem: BodySites
* #head "Cabeça"
  * #face "Face"
    * #eye "Olho"
      * #left-eye "Olho esquerdo"
      * #right-eye "Olho direito"
  * #scalp "Couro cabeludo"
```

### 3.2 ValueSet
Define subconjunto de códigos para uso específico¹³.

#### 3.2.1 ValueSet Extensional
Lista explícita de códigos:
```fsh
ValueSet: EmergencyConditions
Id: emergency-conditions
Title: "Condições de Emergência"
* $SCT#410429000 "Cardiac arrest"
* $SCT#230690007 "Stroke"
* $ICD10CM#I21 "Acute myocardial infarction"
```

#### 3.2.2 ValueSet Intensional
Definido por regras:
```fsh
ValueSet: AllDiabetesConditions
* include codes from system $SCT where concept is-a #73211009 "Diabetes mellitus"
* include codes from system $ICD10CM where code regex "^E1[0-4].*"
```

#### 3.2.3 ValueSet com Filtros Complexos
```fsh
ValueSet: ActiveMedicationStatus
* include codes from system http://hl7.org/fhir/CodeSystem/medication-statement-status
  where concept is-a #active
* exclude http://hl7.org/fhir/CodeSystem/medication-statement-status#entered-in-error
```

### 3.3 ConceptMap
Mapeia conceitos entre sistemas diferentes¹⁴.

#### 3.3.1 Estrutura de ConceptMap
```fsh
ConceptMap: ConditionSeverityMap
Id: condition-severity-map
Source: LocalSeverityVS
Target: http://hl7.org/fhir/ValueSet/condition-severity
* group[0].source = "http://example.org/severity"
* group[0].target = $SCT
* group[0].element[0].code = #mild
* group[0].element[0].target[0].code = #255604002
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #moderate  
* group[0].element[1].target[0].code = #6736007
* group[0].element[1].target[0].equivalence = #equivalent
```

#### 3.3.2 Tipos de Equivalência¹⁵
- **equivalent**: Conceitos são equivalentes
- **wider**: Target é mais amplo
- **narrower**: Target é mais específico
- **inexact**: Mapeamento aproximado
- **unmatched**: Sem correspondência

### 3.4 NamingSystem
Define identificadores únicos para sistemas¹⁶.

```fsh
Instance: cpf-naming-system
InstanceOf: NamingSystem
* name = "CPF"
* status = #active
* kind = #identifier
* description = "Cadastro de Pessoas Físicas brasileiro"
* uniqueId[0].type = #uri
* uniqueId[0].value = "http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf"
* uniqueId[1].type = #oid
* uniqueId[1].value = "2.16.840.1.113883.13.18"
```

## 4. BINDING DE TERMINOLOGIAS

### 4.1 Tipos de Binding¹⁷

#### 4.1.1 Required
Deve usar código do ValueSet:
```fsh
* status from http://hl7.org/fhir/ValueSet/observation-status (required)
```

#### 4.1.2 Extensible
Deve usar se aplicável, pode estender:
```fsh
* code from http://hl7.org/fhir/ValueSet/observation-codes (extensible)
```

#### 4.1.3 Preferred
Recomendado, mas opcional:
```fsh
* bodySite from http://hl7.org/fhir/ValueSet/body-site (preferred)
```

#### 4.1.4 Example
Apenas sugestão:
```fsh
* category from http://hl7.org/fhir/ValueSet/observation-category (example)
```

## 5. MAPEAMENTO DE TERMINOLOGIAS

### 5.1 Estratégias de Mapeamento¹⁸

#### 5.1.1 Mapeamento Direto
```javascript
// Função de mapeamento
function mapLocalToSNOMED(localCode) {
  const mappings = {
    "HT": "38341003",  // Hypertension
    "DM": "73211009",  // Diabetes
    "CHF": "42343007"  // Congestive heart failure
  };
  return mappings[localCode];
}
```

#### 5.1.2 Mapeamento com ConceptMap
```fsh
// Uso do ConceptMap via operação $translate
GET [base]/ConceptMap/$translate?system=http://local&code=HT&target=http://snomed.info/sct
```

### 5.2 Qualidade de Mapeamento¹⁹

#### 5.2.1 Critérios de Avaliação
- **Completude**: Todos os conceitos origem mapeados
- **Precisão**: Correspondência semântica correta
- **Consistência**: Mapeamentos uniformes
- **Manutenibilidade**: Facilidade de atualização

#### 5.2.2 Validação de Mapeamentos
```bash
# Validar mapeamentos usando FHIR Validator
java -jar validator_cli.jar -ig [ig-package] -profile http://hl7.org/fhir/StructureDefinition/ConceptMap [conceptmap.json]
```

## 6. TRADUÇÃO E LOCALIZAÇÃO

### 6.1 Designations (Traduções)²⁰
```fsh
CodeSystem: LocalConditions
* #hypertension "Hypertension"
* #hypertension ^designation[0].language = #pt-BR
* #hypertension ^designation[0].value = "Hipertensão"
* #hypertension ^designation[1].language = #es
* #hypertension ^designation[1].value = "Hipertensión"
```

### 6.2 Preferred Display
```fsh
ValueSet: ConditionsVS
* $SCT#38341003 "Hypertensive disorder"
* $SCT#38341003 ^designation[0].language = #pt-BR
* $SCT#38341003 ^designation[0].use = http://terminology.hl7.org/CodeSystem/designation-usage#display
* $SCT#38341003 ^designation[0].value = "Transtorno hipertensivo"
```

## 7. SERVIDOR DE TERMINOLOGIA

### 7.1 Operações de Terminologia²¹

#### 7.1.1 $expand
Expande ValueSet para lista de códigos:
```http
GET [base]/ValueSet/[id]/$expand?filter=diabetes
```

#### 7.1.2 $validate-code
Valida se código pertence ao ValueSet:
```http
GET [base]/ValueSet/[id]/$validate-code?system=http://snomed.info/sct&code=73211009
```

#### 7.1.3 $lookup
Obtém detalhes de um código:
```http
GET [base]/CodeSystem/$lookup?system=http://loinc.org&code=15074-8
```

#### 7.1.4 $translate
Traduz código entre sistemas:
```http
GET [base]/ConceptMap/[id]/$translate?system=http://local&code=DM
```

### 7.2 Configuração de Servidor Tx²²
```yaml
# hapi-fhir-server config
hapi:
  fhir:
    terminology:
      validation:
        enabled: true
      servers:
        - url: https://r4.ontoserver.csiro.au/fhir
        - url: https://tx.fhir.org/r4
```

## 8. BOAS PRÁTICAS

### 8.1 Reutilização de Terminologias²³
1. **Verificar existência**: Sempre procurar ValueSets existentes antes de criar novos
2. **Usar THO**: Terminology.hl7.org para terminologias HL7
3. **VSAC**: Value Set Authority Center para US-specific
4. **Simplifier**: Para IGs publicados

### 8.2 Documentação de Terminologias
```markdown
### Terminologias Utilizadas

| Sistema | URI | Versão | Licença |
|---------|-----|--------|---------|
| SNOMED CT | http://snomed.info/sct | 2023-09-01 | Requer licença nacional |
| LOINC | http://loinc.org | 2.74 | Gratuito com registro |
| ICD-10-CM | http://hl7.org/fhir/sid/icd-10-cm | 2024 | Domínio público |
```

### 8.3 Versionamento de Terminologias²⁴
```fsh
// Especificar versão quando crítico
ValueSet: CriticalConditions
* $SCT|http://snomed.info/sct/900000000000207008/version/20230901#410429000
```

## 9. INTEGRAÇÃO COM TERMINOLOGIAS NACIONAIS

### 9.1 Brasil
#### 9.1.1 TUSS (Terminologia Unificada da Saúde Suplementar)²⁵
```fsh
Alias: $TUSS = http://www.ans.gov.br/tuss

ValueSet: ProcedimentosTUSS
* $TUSS#30101018 "Consulta médica em pronto socorro"
* $TUSS#40301354 "Hemograma completo"
```

#### 9.1.2 CBHPM (Classificação Brasileira Hierarquizada de Procedimentos Médicos)
```fsh
Alias: $CBHPM = http://amb.org.br/cbhpm

* procedure.code = $CBHPM#1.01.01.01-2 "Consulta em consultório"
```

#### 9.1.3 Tabela SUS (SIGTAP)²⁶
```fsh
Alias: $SIGTAP = http://sigtap.datasus.gov.br

ValueSet: ProcedimentosSUS
* $SIGTAP#0301010072 "Consulta médica em atenção básica"
* $SIGTAP#0202010503 "Hemograma completo"
```

### 9.2 Mapeamento Internacional para Nacional
```fsh
ConceptMap: LOINCtoSIGTAP
* group[0].source = "http://loinc.org"
* group[0].target = "http://sigtap.datasus.gov.br"
* group[0].element[0].code = #58410-2  // CBC panel
* group[0].element[0].target[0].code = #0202010503
* group[0].element[0].target[0].equivalence = #equivalent
```

## 10. GESTÃO DE MUDANÇAS EM TERMINOLOGIAS

### 10.1 Monitoramento de Atualizações²⁷
- **SNOMED CT**: Releases semestrais (Janeiro/Julho)
- **LOINC**: Releases semestrais (Junho/Dezembro)
- **ICD-10-CM**: Atualizações anuais (Outubro)
- **RxNorm**: Atualizações mensais

### 10.2 Processo de Atualização
```bash
# 1. Baixar nova versão
wget https://download.loinc.org/loinc-2.74.zip

# 2. Validar compatibilidade
java -jar validator_cli.jar -version 2.74 -ig [seu-ig]

# 3. Testar mapeamentos
npm run test-terminology

# 4. Atualizar documentação
echo "LOINC atualizado para versão 2.74" >> CHANGELOG.md
```

### 10.3 Deprecação de Códigos²⁸
```fsh
ValueSet: ActiveConditions
* $SCT#73211009 "Diabetes mellitus"
// Código deprecated - usar conceito mais específico
* exclude $SCT#46635009 "Diabetes mellitus type 1" 
* ^compose.inactive = false  // Excluir códigos inativos
```

## 11. TESTES E VALIDAÇÃO

### 11.1 Testes de Terminologia
```javascript
// Teste unitário para ValueSet
describe('Emergency Conditions ValueSet', () => {
  test('should contain cardiac arrest', async () => {
    const expanded = await expandValueSet('emergency-conditions');
    expect(expanded.contains).toContainEqual(
      expect.objectContaining({
        system: 'http://snomed.info/sct',
        code: '410429000'
      })
    );
  });
});
```

### 11.2 Validação de Bindings²⁹
```bash
# Validar todas as bindings do IG
java -jar validator_cli.jar -ig [ig-package] -txLog tx.log

# Verificar log de terminologia
grep "ERROR" tx.log
```

### 11.3 Cobertura de Terminologia
```sql
-- Query para verificar cobertura
SELECT 
  vs.url as valueset,
  COUNT(DISTINCT c.code) as total_codes,
  COUNT(DISTINCT CASE WHEN c.display IS NOT NULL THEN c.code END) as with_display,
  COUNT(DISTINCT CASE WHEN c.definition IS NOT NULL THEN c.code END) as with_definition
FROM valuesets vs
JOIN codes c ON vs.id = c.valueset_id
GROUP BY vs.url;
```

## 12. PERFORMANCE E OTIMIZAÇÃO

### 12.1 Cache de Terminologias³⁰
```yaml
# Configuração de cache
terminology:
  cache:
    enabled: true
    ttl: 86400  # 24 horas
    max-entries: 10000
```

### 12.2 Pré-expansão de ValueSets
```fsh
// Marcar para pré-expansão
ValueSet: CommonConditions
* ^experimental = false
* ^immutable = true  // Permite cache agressivo
* ^compose.lockedDate = "2024-01-01"  // Data de congelamento
```

## 13. CONFORMIDADE COM PADRÕES

### 13.1 ISO/TS 21564:2019³¹
Requisitos para classificações de saúde:
- Completude
- Não-redundância
- Não-ambiguidade
- Múltipla hierarquia permitida
- Definições formais

### 13.2 HL7 Terminology Infrastructure³²
```fsh
// Conformidade com THO
ValueSet: MyValueSet
* ^meta.profile = "http://terminology.hl7.org/StructureDefinition/shareablevalueset"
* ^url = "http://example.org/fhir/ValueSet/my-valueset"
* ^version = "1.0.0"
* ^name = "MyValueSet"
* ^status = #active
* ^experimental = false
* ^publisher = "Example Organization"
```

## 14. FERRAMENTAS E RECURSOS

### 14.1 Ferramentas de Desenvolvimento³³
- **FHIR Shorthand**: https://fshschool.org/
- **Ontoserver**: https://ontoserver.csiro.au/
- **Snowstorm**: https://github.com/IHTSDO/snowstorm
- **OCL (Open Concept Lab)**: https://openconceptlab.org/

### 14.2 Navegadores de Terminologia
- **VSAC**: https://vsac.nlm.nih.gov/
- **SNOMED Browser**: https://browser.ihtsdotools.org/
- **LOINC Search**: https://loinc.org/search/
- **RxNav**: https://rxnav.nlm.nih.gov/

### 14.3 Validadores
```bash
# FHIR Validator
java -jar validator_cli.jar -txServer https://tx.fhir.org -ig [seu-ig]

# Terminology Server Tester
curl -X POST https://tx.fhir.org/r4/ValueSet/$validate-code \
  -H "Content-Type: application/fhir+json" \
  -d '{"resourceType":"Parameters","parameter":[...]}'
```

## 15. TROUBLESHOOTING COMUM

### 15.1 Problemas Frequentes e Soluções

#### Erro: "Code not found in ValueSet"
```fsh
// Verificar:
// 1. Sistema correto
* code.system = "http://snomed.info/sct"  // não "http://snomed.org"

// 2. Código ativo
* ^compose.inactive = false

// 3. Versão correta
* $SCT|http://snomed.info/sct/900000000000207008/version/20230901#12345
```

#### Erro: "Binding strength violation"
```fsh
// Não pode relaxar binding strength
// Parent: required → Child: ❌ extensible
// Parent: extensible → Child: ✓ required
```

#### Erro: "Duplicate codes in ValueSet"
```fsh
// Usar exclude para remover duplicatas
ValueSet: UniqueConditions
* include codes from system $SCT where concept is-a #64572001
* exclude $SCT#duplicated-code
```

## 16. REFERÊNCIAS

1. HL7 International. HL7 Terminology (THO). https://terminology.hl7.org/
2. HL7. FHIR Terminology Service. http://hl7.org/fhir/R5/terminology-service.html
3. HL7. Using Codes in FHIR. http://hl7.org/fhir/R5/terminologies.html
4. ISO. ISO/TR 21300:2014. Health Informatics - Principles of Mapping Between Terminological Systems.
5. SNOMED International. SNOMED CT Implementation Guide. https://confluence.ihtsdotools.org/
6. HL7. SNOMED CT IPS Free Set. http://hl7.org/fhir/uv/ips/terminology.html
7. Regenstrief Institute. LOINC Users' Guide. https://loinc.org/get-started/
8. CDC. ICD-10-CM Official Guidelines. https://www.cdc.gov/nchs/icd/icd-10-cm.htm
9. WHO. ICD-11 Implementation Guide. https://icd.who.int/icd11refguide/
10. NLM. RxNorm Technical Documentation. https://www.nlm.nih.gov/research/umls/rxnorm/
11. WHO. ATC Classification. https://www.whocc.no/atc_ddd_index/
12. HL7. CodeSystem Resource. http://hl7.org/fhir/R5/codesystem.html
13. HL7. ValueSet Resource. http://hl7.org/fhir/R5/valueset.html
14. HL7. ConceptMap Resource. http://hl7.org/fhir/R5/conceptmap.html
15. HL7. ConceptMap Equivalence. http://hl7.org/fhir/R5/valueset-concept-map-equivalence.html
16. HL7. NamingSystem Resource. http://hl7.org/fhir/R5/namingsystem.html
17. HL7. Binding Strength. http://hl7.org/fhir/R5/terminologies.html#strength
18. ISO/TS 21564:2019. Terminology mapping.
19. Bodenreider O. The Unified Medical Language System (UMLS). Nucleic Acids Res. 2004.
20. HL7. Translation and Localization. http://hl7.org/fhir/R5/languages.html
21. HL7. Terminology Service Operations. http://hl7.org/fhir/R5/terminology-service.html#4.6
22. HAPI FHIR. Terminology Configuration. https://hapifhir.io/hapi-fhir/docs/server_jpa/terminology.html
23. HL7. Best Practices for Terminology. https://confluence.hl7.org/display/FHIR/Terminology+Best+Practices
24. HL7. Terminology Versioning. http://hl7.org/fhir/R5/terminologies.html#versioning
25. ANS. TUSS - Terminologia Unificada da Saúde Suplementar. http://www.ans.gov.br/tuss
26. DATASUS. SIGTAP. http://sigtap.datasus.gov.br
27. HL7. Terminology Maintenance. https://confluence.hl7.org/display/TA/Maintenance
28. HL7. Deprecated Codes. http://hl7.org/fhir/R5/codesystem-definitions.html#CodeSystem.concept.deprecated
29. HL7. Terminology Validation. http://hl7.org/fhir/R5/validation.html#terminology
30. HL7. Terminology Performance. https://confluence.hl7.org/display/FHIR/Terminology+Performance
31. ISO/TS 21564:2019. Health informatics — Terminology classifications.
32. HL7. Terminology Infrastructure. https://confluence.hl7.org/display/TA/Terminology+Infrastructure
33. HL7. Terminology Tools. https://confluence.hl7.org/display/FHIR/Terminology+Tools

---
**Documento aprovado por:** [Gerência de Terminologias Clínicas]  
**Data de vigência:** 2024-2025  
**Próxima revisão:** Janeiro 2026