# SOP-004: Integração openEHR com HL7 FHIR Implementation Guides
**Standard Operating Procedure para Persistência de Dados e Interoperabilidade openEHR-FHIR**

## 1. INTRODUÇÃO

### 1.1 Objetivo
Estabelecer procedimentos para integração entre sistemas openEHR e Implementation Guides FHIR, garantindo persistência semântica de dados clínicos e interoperabilidade bidirecional.

### 1.2 Escopo
Aplicável a projetos que necessitam combinar a persistência de longo prazo do openEHR com a interoperabilidade do FHIR, incluindo mapeamento de arquétipos, templates e linguagens de decisão.

### 1.3 Referências Fundamentais
- openEHR Specifications¹: https://specifications.openehr.org/
- openEHR Architecture Overview²: https://specifications.openehr.org/releases/BASE/latest/architecture_overview.html
- Archetype Definition Language (ADL)³: https://specifications.openehr.org/releases/AM/latest/ADL2.html
- Guideline Definition Language (GDL)⁴: https://specifications.openehr.org/releases/CDS/latest/GDL.html
- Decision Language (DL)⁵: https://specifications.openehr.org/releases/PROC/latest/decision_language.html

## 2. FUNDAMENTOS openEHR

### 2.1 Arquitetura de Modelo Dual
O openEHR utiliza uma abordagem de modelo dual⁶:

#### 2.1.1 Reference Model (RM)
```xml
<!-- Modelo de Referência openEHR -->
<composition archetype_node_id="openEHR-EHR-COMPOSITION.encounter.v1">
  <content xsi:type="OBSERVATION" archetype_node_id="openEHR-EHR-OBSERVATION.blood_pressure.v2">
    <data>
      <events xsi:type="POINT_EVENT">
        <data xsi:type="ITEM_TREE">
          <items xsi:type="ELEMENT" archetype_node_id="at0004">
            <value xsi:type="DV_QUANTITY">
              <magnitude>120</magnitude>
              <units>mm[Hg]</units>
            </value>
          </items>
        </data>
      </events>
    </data>
  </content>
</composition>
```

#### 2.1.2 Archetype Model (AM)
```adl
archetype (adl_version=2.0.0)
    openEHR-EHR-OBSERVATION.blood_pressure.v2

concept
    [at0000]    -- Blood pressure

language
    original_language = <[ISO_639-1::en]>
    
definition
    OBSERVATION[at0000] matches {
        data matches {
            HISTORY[at0001] matches {
                events cardinality matches {1..*; unordered} matches {
                    EVENT[at0006] occurrences matches {0..*} matches {
                        data matches {
                            ITEM_TREE[at0003] matches {
                                items cardinality matches {0..*; unordered} matches {
                                    ELEMENT[at0004] occurrences matches {0..1} matches {
                                        value matches {
                                            DV_QUANTITY matches {
                                                property matches {[openehr::125]}
                                                magnitude matches {|0.0..<1000.0|}
                                                units matches {"mm[Hg]"}
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
```

### 2.2 Templates Operacionais (OPT)
Templates combinam arquétipos para casos de uso específicos⁷:

```xml
<template xmlns="http://schemas.openehr.org/v1">
    <id>emergency_encounter</id>
    <name>Emergency Encounter Template</name>
    <definition>
        <root_archetype>openEHR-EHR-COMPOSITION.encounter.v1</root_archetype>
        <include_archetypes>
            <archetype>openEHR-EHR-OBSERVATION.blood_pressure.v2</archetype>
            <archetype>openEHR-EHR-OBSERVATION.pulse.v2</archetype>
            <archetype>openEHR-EHR-EVALUATION.problem_diagnosis.v1</archetype>
        </include_archetypes>
    </definition>
</template>
```

## 3. MAPEAMENTO openEHR-FHIR

### 3.1 Estratégias de Mapeamento⁸

#### 3.1.1 Arquétipos para Recursos FHIR
```javascript
// Mapeamento de Arquétipo para Recurso FHIR
function mapArchetypeToFHIR(archetype) {
    const mapping = {
        'openEHR-EHR-OBSERVATION.blood_pressure.v2': {
            fhirResource: 'Observation',
            profileUrl: 'http://hl7.org/fhir/StructureDefinition/bp',
            mappings: {
                '/data[at0001]/events[at0006]/data[at0003]/items[at0004]': 'component[systolic].valueQuantity',
                '/data[at0001]/events[at0006]/data[at0003]/items[at0005]': 'component[diastolic].valueQuantity',
                '/data[at0001]/events[at0006]/time': 'effectiveDateTime',
                '/subject': 'subject',
                '/protocol[at0011]/items[at0013]': 'bodySite'
            }
        }
    };
    
    return mapping[archetype.archetypeId];
}
```

#### 3.1.2 Templates para Profiles FHIR
```fsh
// Profile FHIR baseado em Template openEHR
Profile: OpenEHRBloodPressure
Parent: Observation
Id: openehr-blood-pressure
Title: "openEHR Blood Pressure Observation"
Description: "Blood pressure mapped from openEHR archetype"

* code = $LOINC#85354-9 "Blood pressure panel"
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component contains
    systolic 1..1 MS and
    diastolic 1..1 MS
* component[systolic].code = $LOINC#8480-6 "Systolic blood pressure"
* component[systolic].value[x] only Quantity
* component[systolic].valueQuantity.system = $UCUM
* component[systolic].valueQuantity.code = #mm[Hg]
* component[diastolic].code = $LOINC#8462-4 "Diastolic blood pressure"
* component[diastolic].value[x] only Quantity
* component[diastolic].valueQuantity.system = $UCUM
* component[diastolic].valueQuantity.code = #mm[Hg]

// Extension para metadados openEHR
* extension contains OpenEHRMetadata named openehrMetadata 0..1 MS

Extension: OpenEHRMetadata
Id: openehr-metadata
Title: "openEHR Metadata"
Description: "Metadados do arquétipo openEHR original"
* extension contains
    archetypeId 1..1 MS and
    templateId 0..1 MS and
    rmVersion 0..1 MS
* extension[archetypeId].value[x] only string
* extension[templateId].value[x] only string
* extension[rmVersion].value[x] only string
```

### 3.2 Conversão Bidirecional⁹

#### 3.2.1 openEHR para FHIR
```javascript
class OpenEHRToFHIRConverter {
    convertComposition(composition) {
        const bundle = {
            resourceType: "Bundle",
            type: "document",
            entry: []
        };
        
        // Converter Composition para Bundle
        const fhirComposition = {
            resourceType: "Composition",
            status: "final",
            type: this.mapConceptToCodeableConcept(composition.category),
            subject: this.mapSubject(composition.subject),
            date: composition.context.start_time,
            author: this.mapComposer(composition.composer),
            section: []
        };
        
        // Converter conteúdo
        composition.content.forEach(content => {
            if (content._type === "OBSERVATION") {
                const observation = this.convertObservation(content);
                bundle.entry.push({
                    resource: observation
                });
                fhirComposition.section.push({
                    entry: [{
                        reference: `Observation/${observation.id}`
                    }]
                });
            }
        });
        
        bundle.entry.unshift({
            resource: fhirComposition
        });
        
        return bundle;
    }
    
    convertObservation(observation) {
        const fhirObs = {
            resourceType: "Observation",
            id: this.generateId(),
            status: "final",
            code: this.mapArchetypeToLOINC(observation.archetype_node_id),
            effectiveDateTime: observation.data.events[0].time,
            value: this.convertDataValue(observation.data.events[0].data)
        };
        
        // Adicionar metadados openEHR
        fhirObs.extension = [{
            url: "http://openehr.org/fhir/StructureDefinition/openehr-metadata",
            extension: [
                {
                    url: "archetypeId",
                    valueString: observation.archetype_node_id
                },
                {
                    url: "rmVersion",
                    valueString: "1.0.4"
                }
            ]
        }];
        
        return fhirObs;
    }
}
```

## 10. MELHORES PRÁTICAS

### 10.1 Design Patterns²³
1. **Use openEHR para persistência de longo prazo**
2. **Use FHIR para interoperabilidade e APIs**
3. **Mantenha mapeamentos versionados**
4. **Implemente cache inteligente**
5. **Sincronize de forma assíncrona**

### 10.2 Checklist de Integração
- [ ] Arquétipos mapeados para Profiles FHIR
- [ ] Templates documentados
- [ ] Conversores bidirecionais testados
- [ ] Validação semântica implementada
- [ ] Performance otimizada
- [ ] Sincronização configurada
- [ ] Fallback strategies definidas
- [ ] Auditoria completa

## 11. TROUBLESHOOTING

### 11.1 Problemas Comuns
| Problema | Causa | Solução |
|----------|-------|---------|
| Perda de dados na conversão | Mapeamento incompleto | Usar extensões FHIR para dados openEHR |
| Performance lenta | Queries complexas | Implementar cache e índices |
| Sincronização falha | Conflitos de versão | Usar event sourcing |
| Validação falha | Incompatibilidade de tipos | Normalizar tipos de dados |

## 12. REFERÊNCIAS

1. openEHR International. openEHR Specifications. https://specifications.openehr.org/
2. openEHR. Architecture Overview. https://specifications.openehr.org/releases/BASE/latest/architecture_overview.html
3. openEHR. Archetype Definition Language 2. https://specifications.openehr.org/releases/AM/latest/ADL2.html
4. openEHR. Guideline Definition Language. https://specifications.openehr.org/releases/CDS/latest/GDL.html
5. openEHR. Decision Language. https://specifications.openehr.org/releases/PROC/latest/decision_language.html
6. Beale T, Heard S. openEHR Architecture: Architecture Overview. openEHR Foundation. 2018.
7. openEHR. Template Object Model. https://specifications.openehr.org/releases/AM/latest/OPT2.html
8. Moner D, et al. Combining Archetypes with Fast Healthcare Interoperability Resources. Stud Health Technol Inform. 2014.
9. LinkEHR. Archetype-based Data Transformation. https://linkehr.com/
10. Anani N, et al. Guideline Definition Language (GDL) - Design Specifications. Cambio Healthcare Systems. 2013.
11. openEHR. Process Model and Decision Language. https://specifications.openehr.org/releases/PROC/latest/
12. openEHR. EHR Information Model. https://specifications.openehr.org/releases/RM/latest/ehr.html
13. Sundvall E, et al. Integration of openEHR and FHIR. MedInfo 2019.
14. Gamma E, et al. Design Patterns: Elements of Reusable Object-Oriented Software. Addison-Wesley. 1994.
15. Ma C, et al. EHR Query Language (EQL). Stud Health Technol Inform. 2007.
16. EHRBase. openEHR Clinical Data Repository. https://ehrbase.org/
17. openEHR. Clinical Knowledge Manager. https://ckm.openehr.org/
18. openEHR. Implementation Technology Specifications. https://specifications.openehr.org/releases/ITS/latest/
19. openEHR. Archetype Object Model. https://specifications.openehr.org/releases/AM/latest/AOM2.html
20. openEHR. Conformance Specifications. https://specifications.openehr.org/releases/CNF/latest/
21. Ocean Health Systems. openEHR Platform Integration Guide. 2021.
22. Better Platform. FHIR-openEHR Migration Guide. 2022.
23. openEHR. Implementation Guide. https://specifications.openehr.org/releases/ITS/latest/implementation_guide.html

---
**Documento aprovado por:** [Comitê de Arquitetura e Integração]  
**Data de vigência:** 2024-2025  
**Próxima revisão:** Janeiro 2026
```

#### 3.2.2 FHIR para openEHR
```javascript
class FHIRToOpenEHRConverter {
    convertBundle(bundle) {
        const composition = {
            _type: "COMPOSITION",
            archetype_node_id: this.mapProfileToArchetype(bundle.entry[0].resource.meta?.profile),
            language: {
                terminology_id: {value: "ISO_639-1"},
                code_string: "en"
            },
            territory: {
                terminology_id: {value: "ISO_3166-1"},
                code_string: "US"
            },
            category: this.mapCodeableConceptToDvCodedText(bundle.entry[0].resource.type),
            composer: this.mapAuthorToComposer(bundle.entry[0].resource.author),
            content: []
        };
        
        // Converter recursos para conteúdo openEHR
        bundle.entry.slice(1).forEach(entry => {
            if (entry.resource.resourceType === "Observation") {
                composition.content.push(
                    this.convertObservationToOpenEHR(entry.resource)
                );
            }
        });
        
        return composition;
    }
}
```

## 4. LINGUAGENS DE DECISÃO CLÍNICA

### 4.1 Guideline Definition Language (GDL)¹⁰

#### 4.1.1 GDL versão 2
```gdl2
(GUIDE) <
    gdl_version = <"2.0">
    id = <"CHA2DS2VASc_Score.v1">
    concept = <"gt0001">
    
    definition = (GUIDE_DEFINITION) <
        archetype_bindings = <
            ["gt0002"] = (ARCHETYPE_BINDING) <
                archetype_id = <"openEHR-EHR-OBSERVATION.chadsvasc_score.v1">
                domain = <"CDS">
                elements = <
                    ["gt0003"] = (ELEMENT_BINDING) <
                        path = <"/data[at0001]/events[at0002]/data[at0003]/items[at0004]">
                    >
                >
            >
        >
        
        rules = <
            ["gt0010"] = (RULE) <
                when = <"$gt0003 != null">
                then = <"$gt0004 = $gt0003.value">
                priority = <1>
            >
        >
    >
>
```

#### 4.1.2 Integração GDL com FHIR CQL
```cql
// CQL equivalente ao GDL
library CHA2DS2VAScScore version '1.0'

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

context Patient

define "CHA2DS2-VASc Score":
  let
    AgeScore: if AgeInYears() >= 75 then 2
              else if AgeInYears() >= 65 then 1
              else 0,
    SexScore: if Patient.gender = 'female' then 1 else 0,
    CHFScore: if exists([Condition: "Congestive Heart Failure"]) then 1 else 0,
    HypertensionScore: if exists([Condition: "Hypertension"]) then 1 else 0,
    StrokeScore: if exists([Condition: "Stroke"]) then 2 else 0,
    VascularScore: if exists([Condition: "Vascular Disease"]) then 1 else 0,
    DiabetesScore: if exists([Condition: "Diabetes"]) then 1 else 0
  return
    AgeScore + SexScore + CHFScore + HypertensionScore + 
    StrokeScore + VascularScore + DiabetesScore
```

### 4.2 Decision Language (DL)¹¹

#### 4.2.1 Decision Logic Module (DLM)
```yaml
dlm_version: "1.0"
id: "medication_check"
description: "Check medication interactions"

preconditions:
  - "has_active_medications"
  
data_context:
  medications:
    source: "EHR"
    archetype: "openEHR-EHR-INSTRUCTION.medication_order.v3"
    
  allergies:
    source: "EHR"  
    archetype: "openEHR-EHR-EVALUATION.adverse_reaction_risk.v2"

rules:
  - id: "check_allergy"
    when:
      all:
        - "$medications.agent matches $allergies.substance"
    then:
      - create_alert:
          severity: "high"
          message: "Potential allergic reaction"
          
  - id: "check_interaction"
    when:
      all:
        - "$medications.count() > 1"
        - "has_interaction($medications)"
    then:
      - create_warning:
          severity: "medium"
          message: "Drug interaction detected"
```

#### 4.2.2 Mapeamento DL para CDS Hooks
```javascript
// Converter DLM para CDS Hooks Card
function convertDLMToCDSHooks(dlm, context) {
    const cards = [];
    
    dlm.rules.forEach(rule => {
        if (evaluateCondition(rule.when, context)) {
            rule.then.forEach(action => {
                if (action.create_alert || action.create_warning) {
                    cards.push({
                        summary: action.message,
                        indicator: mapSeverityToIndicator(action.severity),
                        source: {
                            label: dlm.description,
                            url: `http://openehr.org/dlm/${dlm.id}`
                        }
                    });
                }
            });
        }
    });
    
    return cards;
}
```

## 5. PERSISTÊNCIA DE DADOS

### 5.1 Arquitetura de Persistência¹²

#### 5.1.1 Clinical Data Repository (CDR)
```yaml
# Configuração CDR openEHR
cdr_configuration:
  type: "openEHR"
  version: "1.0.4"
  
  storage:
    type: "postgresql"
    schema: "versioned"
    
  indices:
    - archetype_id
    - template_id
    - uid
    - time_created
    
  partitioning:
    strategy: "by_date"
    interval: "monthly"
    
  archetype_repository:
    url: "https://ckm.openehr.org/ckm"
    cache: true
    
  template_repository:
    local: "/opt/openehr/templates"
    
  api_endpoints:
    rest: "http://localhost:8080/ehrbase/rest/v1"
    fhir: "http://localhost:8080/fhir/r4"
```

#### 5.1.2 Versionamento de Dados
```sql
-- Estrutura de versionamento openEHR
CREATE TABLE ehr.versioned_composition (
    uid UUID PRIMARY KEY,
    ehr_id UUID NOT NULL,
    time_created TIMESTAMPTZ NOT NULL,
    
    -- Versionamento
    version_tree_id TEXT NOT NULL,
    preceding_version_uid UUID,
    lifecycle_state TEXT NOT NULL,
    
    -- Dados
    data JSONB NOT NULL,
    
    -- Auditoria
    committer_name TEXT NOT NULL,
    committer_id TEXT NOT NULL,
    change_type TEXT NOT NULL,
    description TEXT,
    
    -- Índices para busca
    archetype_node_id TEXT NOT NULL,
    template_id TEXT,
    
    CONSTRAINT fk_ehr 
        FOREIGN KEY (ehr_id) 
        REFERENCES ehr.ehr(id)
);

-- Índices otimizados
CREATE INDEX idx_archetype ON ehr.versioned_composition(archetype_node_id);
CREATE INDEX idx_template ON ehr.versioned_composition(template_id);
CREATE INDEX idx_time ON ehr.versioned_composition(time_created);
CREATE INDEX idx_data_gin ON ehr.versioned_composition USING gin(data);
```

### 5.2 Sincronização openEHR-FHIR¹³

#### 5.2.1 Event-Driven Synchronization
```javascript
class OpenEHRFHIRSynchronizer {
    constructor(openehrClient, fhirClient) {
        this.openehr = openehrClient;
        this.fhir = fhirClient;
        this.converter = new OpenEHRToFHIRConverter();
    }
    
    async syncComposition(compositionUid) {
        try {
            // Buscar composition do openEHR
            const composition = await this.openehr.getComposition(compositionUid);
            
            // Converter para FHIR Bundle
            const bundle = this.converter.convertComposition(composition);
            
            // Adicionar metadados de sincronização
            bundle.meta = {
                lastUpdated: new Date().toISOString(),
                tag: [{
                    system: "http://openehr.org/sync",
                    code: "synchronized",
                    display: `Synced from openEHR composition ${compositionUid}`
                }]
            };
            
            // Enviar para servidor FHIR
            const result = await this.fhir.transaction(bundle);
            
            // Registrar sincronização
            await this.logSync(compositionUid, result.id, 'success');
            
            return result;
            
        } catch (error) {
            await this.logSync(compositionUid, null, 'error', error.message);
            throw error;
        }
    }
    
    async setupWebhook() {
        // Configurar webhook no openEHR para mudanças
        await this.openehr.registerWebhook({
            url: 'http://fhir-sync/webhook',
            events: ['composition.created', 'composition.updated'],
            filters: {
                archetypes: ['openEHR-EHR-COMPOSITION.encounter.v1']
            }
        });
    }
}
```

## 6. ARQUITETURA DE INTEGRAÇÃO

### 6.1 Padrão Facade¹⁴
```javascript
// Facade para unificar acesso openEHR/FHIR
class ClinicalDataFacade {
    constructor() {
        this.openehrRepo = new OpenEHRRepository();
        this.fhirRepo = new FHIRRepository();
        this.cache = new RedisCache();
    }
    
    async getPatientData(patientId, format = 'fhir') {
        // Verificar cache
        const cacheKey = `patient:${patientId}:${format}`;
        const cached = await this.cache.get(cacheKey);
        if (cached) return cached;
        
        // Buscar dados do openEHR (fonte de verdade)
        const ehrId = await this.openehrRepo.getEhrId(patientId);
        const compositions = await this.openehrRepo.getCompositions(ehrId);
        
        // Retornar no formato solicitado
        let result;
        if (format === 'fhir') {
            result = await this.convertToFHIR(compositions);
        } else if (format === 'openehr') {
            result = compositions;
        } else {
            throw new Error(`Unsupported format: ${format}`);
        }
        
        // Cachear resultado
        await this.cache.set(cacheKey, result, 300); // 5 minutos
        
        return result;
    }
    
    async saveObservation(observation, source = 'fhir') {
        let openehrData;
        
        if (source === 'fhir') {
            // Converter FHIR para openEHR
            openehrData = await this.convertToOpenEHR(observation);
        } else {
            openehrData = observation;
        }
        
        // Salvar no openEHR (persistência principal)
        const result = await this.openehrRepo.saveObservation(openehrData);
        
        // Sincronizar com FHIR (para interoperabilidade)
        if (source === 'openehr') {
            const fhirData = await this.convertToFHIR(openehrData);
            await this.fhirRepo.saveObservation(fhirData);
        }
        
        // Invalidar cache
        await this.cache.invalidate(`patient:${observation.subject}`);
        
        return result;
    }
}
```

### 6.2 Query Integration¹⁵

#### 6.2.1 Archetype Query Language (AQL)
```aql
-- Query AQL para buscar pressões arteriais
SELECT
    c/context/start_time as encounter_time,
    o/data[at0001]/events[at0006]/data[at0003]/items[at0004]/value/magnitude as systolic,
    o/data[at0001]/events[at0006]/data[at0003]/items[at0005]/value/magnitude as diastolic
FROM
    EHR e
    CONTAINS COMPOSITION c[openEHR-EHR-COMPOSITION.encounter.v1]
    CONTAINS OBSERVATION o[openEHR-EHR-OBSERVATION.blood_pressure.v2]
WHERE
    e/ehr_id/value = $ehrId
    AND c/context/start_time > $startDate
ORDER BY
    c/context/start_time DESC
```

#### 6.2.2 Conversão AQL para FHIR Search
```javascript
class AQLToFHIRSearchConverter {
    convertAQL(aql) {
        // Parser simplificado de AQL
        const parsed = this.parseAQL(aql);
        
        // Mapear para parâmetros FHIR
        const searchParams = {};
        
        if (parsed.archetypes.includes('blood_pressure')) {
            searchParams.code = 'http://loinc.org|85354-9';
        }
        
        if (parsed.where.ehrId) {
            searchParams.patient = this.mapEhrIdToPatientId(parsed.where.ehrId);
        }
        
        if (parsed.where.startDate) {
            searchParams.date = `ge${parsed.where.startDate}`;
        }
        
        if (parsed.orderBy) {
            searchParams._sort = '-date';
        }
        
        return searchParams;
    }
    
    async executeHybridQuery(aql) {
        // Tentar primeiro no FHIR (mais rápido)
        const searchParams = this.convertAQL(aql);
        let results = await this.fhirClient.search('Observation', searchParams);
        
        // Se não encontrar, buscar no openEHR
        if (results.total === 0) {
            const openehrResults = await this.openehrClient.query(aql);
            results = await this.convertResults(openehrResults);
        }
        
        return results;
    }
}
```

## 7. FERRAMENTAS E PLATAFORMAS

### 7.1 Plataformas openEHR¹⁶
- **EHRBase**: https://ehrbase.org/
- **Better Platform**: https://platform.better.care/
- **Ocean Platform**: https://oceanhealthsystems.com/
- **EtherCIS**: https://ethercis.org/ (descontinuado)

### 7.2 Ferramentas de Modelagem¹⁷
- **Archetype Designer**: https://tools.openehr.org/designer/
- **LinkEHR**: https://linkehr.com/
- **Template Designer**: https://tools.openehr.org/templateDesigner/
- **CKM (Clinical Knowledge Manager)**: https://ckm.openehr.org/

### 7.3 Bibliotecas de Integração¹⁸
```json
{
  "dependencies": {
    "openehr-js": "^2.0.0",
    "fhir": "^4.11.0",
    "archetype-validator": "^1.0.0",
    "aql-parser": "^0.5.0",
    "gdl-tools": "^1.2.0"
  }
}
```

## 8. VALIDAÇÃO E CONFORMIDADE

### 8.1 Validação de Arquétipos¹⁹
```javascript
class ArchetypeValidator {
    validateAgainstRM(data, archetype) {
        const errors = [];
        
        // Validar estrutura do RM
        if (!this.isValidRMType(data._type)) {
            errors.push(`Invalid RM type: ${data._type}`);
        }
        
        // Validar constraints do arquétipo
        archetype.definition.attributes.forEach(attr => {
            if (attr.existence.lower > 0 && !data[attr.rm_attribute_name]) {
                errors.push(`Missing required attribute: ${attr.rm_attribute_name}`);
            }
            
            if (data[attr.rm_attribute_name]) {
                const validation = this.validateAttribute(
                    data[attr.rm_attribute_name],
                    attr.children[0]
                );
                errors.push(...validation.errors);
            }
        });
        
        return {
            valid: errors.length === 0,
            errors
        };
    }
}
```

### 8.2 Testes de Integração²⁰
```javascript
describe('openEHR-FHIR Integration', () => {
    test('Should convert blood pressure observation bidirectionally', async () => {
        // openEHR para FHIR
        const openehrObs = createOpenEHRBloodPressure(120, 80);
        const fhirObs = await converter.toFHIR(openehrObs);
        
        expect(fhirObs.resourceType).toBe('Observation');
        expect(fhirObs.component[0].valueQuantity.value).toBe(120);
        
        // FHIR para openEHR
        const backToOpenEHR = await converter.toOpenEHR(fhirObs);
        
        expect(backToOpenEHR.archetype_node_id).toBe(
            'openEHR-EHR-OBSERVATION.blood_pressure.v2'
        );
    });
    
    test('Should preserve semantic meaning', async () => {
        const original = createComplexComposition();
        const fhir = await converter.toFHIR(original);
        const restored = await converter.toOpenEHR(fhir);
        
        expect(semanticCompare(original, restored)).toBe(true);
    });
});
```

## 9. CASOS DE USO

### 9.1 Caso: Hospital com openEHR expondo API FHIR²¹
```yaml
architecture:
  components:
    - name: "Legacy EHR"
      type: "proprietary"
      
    - name: "openEHR CDR"
      type: "ehrbase"
      purpose: "Long-term clinical data storage"
      
    - name: "FHIR Facade"
      type: "custom"
      purpose: "FHIR API for external integration"
      
    - name: "Sync Service"
      type: "kafka-connect"
      purpose: "Real-time synchronization"
      
  flow:
    1: "Legacy EHR → ETL → openEHR CDR"
    2: "openEHR CDR → Converter → FHIR Facade"
    3: "External Apps ← FHIR API ← FHIR Facade"
```

### 9.2 Caso: Migração FHIR para openEHR²²
```javascript
class FHIRToOpenEHRMigration {
    async migrate(fhirServerUrl, openehrServer) {
        const stats = {
            total: 0,
            migrated: 0,
            errors: []
        };
        
        // Buscar todos os pacientes
        const patients = await this.fhirClient.search('Patient', {
            _count: 1000
        });
        
        for (const patient of patients.entry) {
            try {
                // Criar EHR no openEHR
                const ehrId = await this.createEHR(patient.resource);
                
                // Migrar observações
                const observations = await this.fhirClient.search('Observation', {
                    patient: patient.resource.id
                });
                
                for (const obs of observations.entry) {
                    const openehrObs = await this.converter.toOpenEHR(obs.resource);
                    await this.openehrClient.saveObservation(ehrId, openehrObs);
                }
                
                stats.migrated++;
            } catch (error) {
                stats.errors.push({
                    patient: patient.resource.id,
                    error: error.message
                });
            }
            
            stats.total++;
        }
        
        return stats;
    }
}