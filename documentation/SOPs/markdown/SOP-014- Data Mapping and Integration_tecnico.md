# SOP-014: Mapeamento e Integração de Dados em FHIR

**Versão:** 1.0.0  
**Data:** 2025-08-29  
**Autor:** Sistema de Gestão de IG FHIR  
**Status:** Ativo

## 1. Objetivo

Este procedimento operacional padrão estabelece diretrizes para mapeamento e integração de dados em implementações FHIR, abrangendo tanto transformações entre terminologias quanto integração de sistemas legados com arquiteturas modernas baseadas em FHIR[1].

## 2. Escopo

### 2.1 Abrangência
- Mapeamento entre terminologias internacionais (SNOMED CT, LOINC, ICD-10/11)
- Transformação de dados de sistemas legados (HL7 v2, CDA, openEHR)
- Integração com modelos de dados de pesquisa (OMOP CDM)
- Implementações regionais específicas (Brasil, EUA, Europa)

### 2.2 Aplicabilidade
Este SOP aplica-se a todas as equipes envolvidas em:
- Desenvolvimento de Implementation Guides
- Migração de sistemas legados
- Integração de terminologias
- Validação de mapeamentos

## 3. Fundamentos Teóricos

### 3.1 Conceitos de Mapeamento Terminológico

O mapeamento entre terminologias clínicas representa um dos desafios fundamentais da interoperabilidade em saúde[2]. A colaboração oficial entre SNOMED International e Regenstrief Institute estabeleceu um framework para mapeamento SNOMED CT-LOINC, com 9.730 termos LOINC ativos mapeados para expressões pós-coordenadas SNOMED CT[3].

#### 3.1.1 Princípios de Mapeamento

**Equivalência semântica:** O mapeamento deve preservar o significado clínico original[4]. Quando não existe equivalência direta, utilizam-se expressões pós-coordenadas para representar conceitos complexos.

**Granularidade:** SNOMED CT oferece maior granularidade que LOINC, resultando em mapeamentos muitos-para-um[5]. Esta diferença requer estratégias específicas para evitar perda de informação.

**Contexto clínico:** O algoritmo I-MAGIC para mapeamento ICD-10 para SNOMED CT considera idade, gênero e comorbidades do paciente[6].

### 3.2 Arquitetura de Integração de Dados

A transformação de dados entre diferentes padrões requer arquiteturas robustas que preservem a integridade semântica[7]. O FHIR fornece mecanismos nativos através de recursos ConceptMap e StructureMap.

#### 3.2.1 FHIR ConceptMap

O recurso ConceptMap em FHIR R5 suporta mapeamentos complexos através de[8]:
- Lógica condicional com elementos `dependsOn`
- Mapeamentos de produtos para elementos derivados
- Mapeamentos de ValueSet para conjuntos completos

#### 3.2.2 StructureMap

StructureMap implementa transformações baseadas em QVT (Query/View/Transformation) com suporte para[9]:
- Regras declarativas de transformação
- Variáveis de contexto
- Operações de transformação complexas

## 4. Implementação Prática

### 4.1 Mapeamento SNOMED CT para LOINC

#### 4.1.1 Configuração Básica em FSH

```fsh
// Definição do ConceptMap SNOMED-LOINC
Instance: ConceptMapSnomedLoinc
InstanceOf: ConceptMap
Title: "SNOMED CT to LOINC Mapping"
Description: "Mapeamento oficial entre SNOMED CT e LOINC para testes laboratoriais"
* status = #active
* experimental = false
* date = "2025-01-01"
* publisher = "Organization Example"
* contact.telecom.system = #url
* contact.telecom.value = "http://example.org"

* sourceUri = "http://snomed.info/sct"
* targetUri = "http://loinc.org"

// Exemplo de mapeamento de glicose sérica
* group[0].source = "http://snomed.info/sct"
* group[0].target = "http://loinc.org"
* group[0].element[0].code = #22569008
* group[0].element[0].display = "Glucose measurement, blood"
* group[0].element[0].target[0].code = #2339-0
* group[0].element[0].target[0].display = "Glucose [Mass/volume] in Blood"
* group[0].element[0].target[0].equivalence = #equivalent

// Mapeamento com pós-coordenação
* group[0].element[1].code = #250373003
* group[0].element[1].display = "Diabetes mellitus with ketoacidosis"
* group[0].element[1].target[0].code = #4548-4
* group[0].element[1].target[0].display = "Hemoglobin A1c/Hemoglobin.total in Blood"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "Requer contexto adicional para mapeamento completo"
```

#### 4.1.2 Implementação JavaScript/TypeScript

```typescript
import { FhirClient } from 'fhirclient';
import { ConceptMap, Parameters } from '@types/fhir/r4';

class TerminologyMapper {
    private client: FhirClient;
    
    constructor(serverUrl: string) {
        this.client = new FhirClient({
            baseUrl: serverUrl
        });
    }
    
    /**
     * Realiza tradução de código usando ConceptMap
     * Implementação baseada na operação $translate do FHIR[10]
     */
    async translateCode(
        code: string,
        system: string,
        conceptMapUrl: string
    ): Promise<Parameters> {
        const params: Parameters = {
            resourceType: 'Parameters',
            parameter: [
                {
                    name: 'url',
                    valueUri: conceptMapUrl
                },
                {
                    name: 'system',
                    valueUri: system
                },
                {
                    name: 'code',
                    valueCode: code
                }
            ]
        };
        
        try {
            const result = await this.client.operation({
                resourceType: 'ConceptMap',
                name: 'translate',
                method: 'POST',
                body: params
            });
            
            return result as Parameters;
        } catch (error) {
            console.error('Erro na tradução:', error);
            throw new Error(`Falha ao traduzir código ${code}`);
        }
    }
    
    /**
     * Valida mapeamento usando closure table[11]
     */
    async validateMapping(
        sourceCode: string,
        targetCode: string,
        conceptMapId: string
    ): Promise<boolean> {
        const conceptMap = await this.client.read({
            resourceType: 'ConceptMap',
            id: conceptMapId
        }) as ConceptMap;
        
        // Verifica se o mapeamento existe
        for (const group of conceptMap.group || []) {
            for (const element of group.element || []) {
                if (element.code === sourceCode) {
                    const target = element.target?.find(
                        t => t.code === targetCode
                    );
                    if (target) {
                        console.log(`Mapeamento válido: ${target.equivalence}`);
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
}
```

### 4.2 Transformação HL7 v2 para FHIR

A conversão de mensagens HL7 v2 para FHIR segue o Implementation Guide oficial[12], com suporte para todas as estruturas de mensagem v2.9.

#### 4.2.1 Mapeamento de Segmentos

```typescript
/**
 * Transformador HL7 v2 para FHIR
 * Baseado no HL7 Version 2 to FHIR Implementation Guide v1.0.0[13]
 */
class HL7v2ToFHIRTransformer {
    
    /**
     * Converte segmento PID para recurso Patient
     */
    transformPIDToPatient(pid: any): fhir.Patient {
        const patient: fhir.Patient = {
            resourceType: 'Patient',
            identifier: [],
            name: [],
            telecom: [],
            address: [],
            gender: 'unknown',
            birthDate: ''
        };
        
        // PID-3: Patient Identifier List
        if (pid['PID.3']) {
            const identifiers = Array.isArray(pid['PID.3']) 
                ? pid['PID.3'] 
                : [pid['PID.3']];
                
            patient.identifier = identifiers.map(id => ({
                system: this.mapIdentifierSystem(id['CX.4']),
                value: id['CX.1'],
                type: {
                    coding: [{
                        system: 'http://terminology.hl7.org/CodeSystem/v2-0203',
                        code: id['CX.5'] || 'MR'
                    }]
                }
            }));
        }
        
        // PID-5: Patient Name
        if (pid['PID.5']) {
            const names = Array.isArray(pid['PID.5']) 
                ? pid['PID.5'] 
                : [pid['PID.5']];
                
            patient.name = names.map(name => ({
                family: name['XPN.1'],
                given: [name['XPN.2'], name['XPN.3']].filter(n => n),
                prefix: name['XPN.5'] ? [name['XPN.5']] : undefined,
                use: this.mapNameUse(name['XPN.7'])
            }));
        }
        
        // PID-7: Date/Time of Birth
        if (pid['PID.7']) {
            patient.birthDate = this.convertHL7DateToFHIR(pid['PID.7']);
        }
        
        // PID-8: Administrative Sex
        if (pid['PID.8']) {
            patient.gender = this.mapGender(pid['PID.8']);
        }
        
        return patient;
    }
    
    /**
     * Converte mensagem ADT_A01 (Admit) completa
     */
    async transformADT_A01(message: any): Promise<fhir.Bundle> {
        const bundle: fhir.Bundle = {
            resourceType: 'Bundle',
            type: 'transaction',
            entry: []
        };
        
        // Transforma Patient
        if (message.PID) {
            const patient = this.transformPIDToPatient(message.PID);
            bundle.entry.push({
                resource: patient,
                request: {
                    method: 'POST',
                    url: 'Patient'
                }
            });
        }
        
        // Transforma Encounter
        if (message.PV1) {
            const encounter = this.transformPV1ToEncounter(
                message.PV1,
                message.PID
            );
            bundle.entry.push({
                resource: encounter,
                request: {
                    method: 'POST',
                    url: 'Encounter'
                }
            });
        }
        
        // Adiciona Provenance para rastreabilidade[14]
        const provenance = this.createProvenance(message.MSH);
        bundle.entry.push({
            resource: provenance,
            request: {
                method: 'POST',
                url: 'Provenance'
            }
        });
        
        return bundle;
    }
    
    private mapGender(hl7Gender: string): fhir.Patient['gender'] {
        const genderMap: {[key: string]: fhir.Patient['gender']} = {
            'M': 'male',
            'F': 'female',
            'O': 'other',
            'U': 'unknown',
            'A': 'other',
            'N': 'unknown'
        };
        return genderMap[hl7Gender] || 'unknown';
    }
    
    private convertHL7DateToFHIR(hl7Date: string): string {
        // Converte formato HL7 (YYYYMMDD) para FHIR (YYYY-MM-DD)
        if (hl7Date.length >= 8) {
            return `${hl7Date.substr(0,4)}-${hl7Date.substr(4,2)}-${hl7Date.substr(6,2)}`;
        }
        return hl7Date;
    }
}
```

### 4.3 Integração FHIR-OMOP CDM

A integração entre FHIR e OMOP Common Data Model segue especificações oficiais da OHDSI[15].

#### 4.3.1 Mapeamento usando FHIR Mapping Language

```text
map "http://example.org/fhir/StructureMap/PatientToOMOP" = "PatientToOMOP"

uses "http://hl7.org/fhir/StructureDefinition/Patient" alias Patient as source
uses "http://ohdsi.org/omop/Person" alias Person as target

imports "http://example.org/fhir/StructureMap/CommonDataTypes"

group PatientToPerson(source src : Patient, target tgt : Person) {
    // Mapeamento do identificador
    src.identifier first as identifier -> tgt.person_id = evaluate(identifier, 'value');
    
    // Mapeamento de gênero com tabela de conceitos OMOP[16]
    src.gender as gender -> tgt.gender_concept_id = translate(
        gender,
        'http://example.org/ConceptMap/GenderToOMOP',
        'code'
    );
    
    // Data de nascimento
    src.birthDate as birthDate -> tgt.birth_datetime = birthDate;
    
    // Cálculo de ano/mês/dia
    src.birthDate as birthDate -> 
        tgt.year_of_birth = evaluate(birthDate, 'substring(0,4)'),
        tgt.month_of_birth = evaluate(birthDate, 'substring(5,2)'),
        tgt.day_of_birth = evaluate(birthDate, 'substring(8,2)');
    
    // Endereço para localização
    src.address first as address -> tgt then {
        address.state as state -> tgt.location_id = 
            evaluate(state, 'lookupLocation($this)');
    };
    
    // Raça e etnia (usando US Core extensions)
    src.extension where url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race' 
        as race -> tgt.race_concept_id = 
            translate(race.valueCoding, 'http://example.org/ConceptMap/RaceToOMOP', 'code');
}

// Grupo para mapeamento de Condition para CONDITION_OCCURRENCE
group ConditionToConditionOccurrence(
    source src : Condition, 
    target tgt : ConditionOccurrence
) {
    src.id as id -> tgt.condition_occurrence_id = id;
    
    // Mapear código da condição para SNOMED no OMOP[17]
    src.code as code -> tgt then {
        code.coding where system = 'http://snomed.info/sct' first as snomed ->
            tgt.condition_concept_id = evaluate(snomed, 'code');
    };
    
    // Datas
    src.onset as onset -> tgt then {
        onset.ofType(dateTime) as onsetDateTime -> 
            tgt.condition_start_date = truncate(onsetDateTime, 10),
            tgt.condition_start_datetime = onsetDateTime;
    };
}
```

### 4.4 Configuração HAPI FHIR Server

#### 4.4.1 Configuração de Mapeamento Customizado

```java
/**
 * Configuração HAPI FHIR para suporte a mapeamentos
 * Baseado na documentação oficial HAPI FHIR[18]
 */
@Configuration
public class MappingConfiguration {
    
    @Bean
    public IValidationSupport mappingValidationSupport() {
        ValidationSupportChain chain = new ValidationSupportChain();
        
        // Adiciona suporte para SNOMED CT[19]
        SnomedCtValidationSupport snomedSupport = 
            new SnomedCtValidationSupport(FhirContext.forR4());
        chain.addValidationSupport(snomedSupport);
        
        // Adiciona suporte para LOINC
        LoincValidationSupport loincSupport = 
            new LoincValidationSupport(FhirContext.forR4());
        chain.addValidationSupport(loincSupport);
        
        // Adiciona ConceptMaps customizados
        PrePopulatedValidationSupport prePopulated = 
            new PrePopulatedValidationSupport(FhirContext.forR4());
        
        // Carrega ConceptMaps do classpath
        loadConceptMapsFromClasspath(prePopulated);
        chain.addValidationSupport(prePopulated);
        
        return chain;
    }
    
    @Bean
    public StructureMapUtilities structureMapUtilities(
        FhirContext ctx
    ) {
        StructureMapUtilities utilities = 
            new StructureMapUtilities(ctx);
        
        // Configura transformadores customizados
        utilities.setServices(new CustomTransformServices());
        
        return utilities;
    }
    
    /**
     * Provider para operação $transform[20]
     */
    @Component
    public class TransformOperationProvider {
        
        @Autowired
        private StructureMapUtilities mapUtilities;
        
        @Operation(name = "$transform", idempotent = false)
        public Resource transform(
            @OperationParam(name = "source") Resource source,
            @OperationParam(name = "map") String mapUrl
        ) {
            try {
                // Carrega StructureMap
                StructureMap map = loadStructureMap(mapUrl);
                
                // Cria recurso alvo
                Resource target = createTargetResource(map);
                
                // Executa transformação
                mapUtilities.transform(
                    null, // Context 
                    source,
                    map,
                    target
                );
                
                // Adiciona Provenance
                addProvenanceData(source, target, map);
                
                return target;
                
            } catch (Exception e) {
                throw new UnprocessableEntityException(
                    "Erro na transformação: " + e.getMessage()
                );
            }
        }
    }
}
```

### 4.5 Validação e Qualidade de Dados

#### 4.5.1 Framework de Validação Multicamadas

```typescript
/**
 * Sistema de validação baseado em ISO 29585:2023[21]
 */
class DataQualityValidator {
    private validators: Map<string, ValidationRule[]> = new Map();
    
    constructor() {
        this.initializeValidators();
    }
    
    /**
     * Implementa dimensões de qualidade da OMS[22]
     */
    private initializeValidators() {
        // Validadores de Completude
        this.validators.set('completeness', [
            {
                name: 'required-fields',
                validate: (resource: any) => {
                    const required = this.getRequiredFields(resource.resourceType);
                    return required.every(field => 
                        this.hasValue(resource, field)
                    );
                }
            }
        ]);
        
        // Validadores de Acurácia
        this.validators.set('accuracy', [
            {
                name: 'terminology-binding',
                validate: async (resource: any) => {
                    return await this.validateTerminologyBindings(resource);
                }
            },
            {
                name: 'data-type-conformance',
                validate: (resource: any) => {
                    return this.validateDataTypes(resource);
                }
            }
        ]);
        
        // Validadores de Consistência
        this.validators.set('consistency', [
            {
                name: 'cross-reference',
                validate: async (resource: any) => {
                    return await this.validateReferences(resource);
                }
            }
        ]);
    }
    
    /**
     * Valida usando Inferno Framework[23]
     */
    async validateWithInferno(
        resource: any,
        testSuite: string
    ): Promise<ValidationResult> {
        const infernoClient = new InfernoClient({
            baseUrl: 'https://inferno.healthit.gov',
            testSuite: testSuite
        });
        
        const result = await infernoClient.validate(resource);
        
        return {
            valid: result.passed,
            errors: result.errors,
            warnings: result.warnings,
            info: result.info
        };
    }
    
    /**
     * Validação com rastreamento de proveniência[24]
     */
    async validateWithProvenance(
        resource: any,
        context: ValidationContext
    ): Promise<ValidatedResource> {
        const startTime = Date.now();
        const validationResult = await this.validate(resource);
        
        // Cria recurso Provenance
        const provenance: fhir.Provenance = {
            resourceType: 'Provenance',
            target: [{
                reference: `${resource.resourceType}/${resource.id}`
            }],
            recorded: new Date().toISOString(),
            activity: {
                coding: [{
                    system: 'http://terminology.hl7.org/CodeSystem/v3-DataOperation',
                    code: 'VALIDATE',
                    display: 'Validate'
                }]
            },
            agent: [{
                type: {
                    coding: [{
                        system: 'http://terminology.hl7.org/CodeSystem/provenance-participant-type',
                        code: 'assembler'
                    }]
                },
                who: {
                    display: 'Data Quality Validator'
                }
            }],
            signature: [{
                type: [{
                    system: 'urn:iso-astm:E1762-95:2013',
                    code: '1.2.840.10065.1.12.1.14',
                    display: 'Source Signature'
                }],
                when: new Date().toISOString(),
                who: {
                    reference: 'Device/validator'
                },
                data: this.generateSignature(validationResult)
            }]
        };
        
        return {
            resource: resource,
            validation: validationResult,
            provenance: provenance,
            processingTime: Date.now() - startTime
        };
    }
}
```

### 4.6 Implementações Regionais Específicas

#### 4.6.1 Brasil - Integração com RNDS

```fsh
// Mapeamento TUSS para FHIR[25]
Instance: ConceptMapTUSSToFHIR
InstanceOf: ConceptMap
Title: "TUSS para FHIR"
Description: "Mapeamento da Tabela TUSS para recursos FHIR"
* status = #active
* sourceUri = "http://www.ans.gov.br/tuss"
* targetUri = "http://hl7.org/fhir/sid/tuss"

* group[0].source = "http://www.ans.gov.br/tuss"
* group[0].target = "http://hl7.org/fhir/StructureDefinition/Procedure"

// Exemplo: Consulta médica
* group[0].element[0].code = #10101012
* group[0].element[0].display = "Consulta em consultório"
* group[0].element[0].target[0].code = #consultorio
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].property[0].code = #procedureCode
* group[0].element[0].target[0].property[0].valueString = "99201"
```

```typescript
/**
 * Cliente RNDS com suporte FHIR R4[26]
 */
class RNDSClient {
    private readonly baseUrl = 'https://ehr-services.saude.gov.br/api/fhir/r4';
    private token: string;
    
    async authenticate(certificado: string): Promise<void> {
        // Autenticação via certificado digital ICP-Brasil
        const response = await fetch('https://ehr-auth.saude.gov.br/token', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Certificate': certificado
            },
            body: 'grant_type=client_credentials&scope=fhir'
        });
        
        const data = await response.json();
        this.token = data.access_token;
    }
    
    async enviarDocumento(bundle: fhir.Bundle): Promise<any> {
        // Valida contra perfis brasileiros
        await this.validateBrazilianProfiles(bundle);
        
        // Adiciona identificadores nacionais
        this.addNationalIdentifiers(bundle);
        
        // Envia para RNDS
        const response = await fetch(`${this.baseUrl}/Bundle`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${this.token}`,
                'Content-Type': 'application/fhir+json',
                'X-Request-ID': this.generateRequestId()
            },
            body: JSON.stringify(bundle)
        });
        
        return response.json();
    }
    
    private addNationalIdentifiers(bundle: fhir.Bundle) {
        bundle.entry?.forEach(entry => {
            if (entry.resource?.resourceType === 'Patient') {
                const patient = entry.resource as fhir.Patient;
                // Adiciona CPF
                patient.identifier?.push({
                    system: 'http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf',
                    value: this.formatCPF(patient.identifier?.[0]?.value)
                });
                // Adiciona CNS
                patient.identifier?.push({
                    system: 'http://rnds.saude.gov.br/fhir/r4/NamingSystem/cns',
                    value: this.generateCNS()
                });
            }
        });
    }
}
```

#### 4.6.2 Europa - EHDS Implementation

```typescript
/**
 * Implementação para European Health Data Space[27]
 */
class EHDSConnector {
    private readonly myHealthUrl = 'https://webgate.ec.europa.eu/myhealth';
    
    /**
     * Gera International Patient Summary conforme especificações EU[28]
     */
    async generateIPS(patient: fhir.Patient): Promise<fhir.Bundle> {
        const ips: fhir.Bundle = {
            resourceType: 'Bundle',
            type: 'document',
            identifier: {
                system: 'urn:oid:2.16.724.4.8.10.200.10',
                value: this.generateUUID()
            },
            timestamp: new Date().toISOString(),
            entry: []
        };
        
        // Adiciona Composition conforme IPS
        const composition: fhir.Composition = {
            resourceType: 'Composition',
            status: 'final',
            type: {
                coding: [{
                    system: 'http://loinc.org',
                    code: '60591-5',
                    display: 'Patient summary Document'
                }]
            },
            subject: {
                reference: `Patient/${patient.id}`
            },
            date: new Date().toISOString(),
            author: [{
                reference: 'Organization/example'
            }],
            title: 'International Patient Summary',
            section: [
                {
                    title: 'Active Problems',
                    code: {
                        coding: [{
                            system: 'http://loinc.org',
                            code: '11450-4'
                        }]
                    },
                    entry: await this.getActiveProblems(patient.id!)
                },
                {
                    title: 'Medications',
                    code: {
                        coding: [{
                            system: 'http://loinc.org',
                            code: '10160-0'
                        }]
                    },
                    entry: await this.getMedications(patient.id!)
                },
                {
                    title: 'Allergies',
                    code: {
                        coding: [{
                            system: 'http://loinc.org',
                            code: '48765-2'
                        }]
                    },
                    entry: await this.getAllergies(patient.id!)
                }
            ]
        };
        
        ips.entry.push({
            fullUrl: `urn:uuid:${this.generateUUID()}`,
            resource: composition
        });
        
        ips.entry.push({
            fullUrl: `urn:uuid:${this.generateUUID()}`,
            resource: patient
        });
        
        return ips;
    }
    
    /**
     * Traduz usando terminologias europeias[29]
     */
    async translateToEDQM(
        medication: fhir.Medication
    ): Promise<fhir.Medication> {
        const edqmMapping = await this.getEDQMMapping();
        
        medication.form?.coding?.forEach(coding => {
            if (coding.system === 'http://snomed.info/sct') {
                const edqmCode = edqmMapping.get(coding.code!);
                if (edqmCode) {
                    coding.system = 'http://standardterms.edqm.eu';
                    coding.code = edqmCode;
                }
            }
        });
        
        return medication;
    }
}
```

## 5. Validação e Testes

### 5.1 Testes de Conformidade

```typescript
/**
 * Suite de testes usando Inferno Framework[30]
 */
describe('FHIR Mapping Conformance Tests', () => {
    let validator: FHIRValidator;
    let mapper: TerminologyMapper;
    
    beforeEach(() => {
        validator = new FHIRValidator({
            version: 'R4',
            profiles: ['US Core', 'IPS', 'BR Core']
        });
        mapper = new TerminologyMapper('http://localhost:8080/fhir');
    });
    
    /**
     * Testa conformidade com Touchstone Platform[31]
     */
    it('should validate ConceptMap structure', async () => {
        const conceptMap = await loadConceptMap('snomed-to-loinc.json');
        
        const result = await validator.validate(conceptMap, {
            profile: 'http://hl7.org/fhir/StructureDefinition/ConceptMap'
        });
        
        expect(result.valid).toBe(true);
        expect(result.issues.filter(i => i.severity === 'error')).toHaveLength(0);
    });
    
    /**
     * Testa mapeamento bidirecional[32]
     */
    it('should perform bidirectional mapping', async () => {
        const snomedCode = '22569008'; // Glucose measurement
        const loincCode = '2339-0'; // Glucose in Blood
        
        // Forward mapping
        const forwardResult = await mapper.translateCode(
            snomedCode,
            'http://snomed.info/sct',
            'http://example.org/ConceptMap/snomed-to-loinc'
        );
        
        expect(forwardResult.parameter?.find(p => p.name === 'result')?.valueBoolean).toBe(true);
        expect(forwardResult.parameter?.find(p => p.name === 'match')?.part?.find(
            p => p.name === 'concept'
        )?.valueCoding?.code).toBe(loincCode);
        
        // Reverse mapping
        const reverseResult = await mapper.translateCode(
            loincCode,
            'http://loinc.org',
            'http://example.org/ConceptMap/loinc-to-snomed'
        );
        
        expect(reverseResult.parameter?.find(p => p.name === 'match')?.part?.find(
            p => p.name === 'concept'
        )?.valueCoding?.code).toBe(snomedCode);
    });
    
    /**
     * Testa qualidade de dados segundo ISO 7101:2023[33]
     */
    it('should validate data quality dimensions', async () => {
        const bundle = await loadTestBundle('sample-data.json');
        const qualityValidator = new DataQualityValidator();
        
        const results = await Promise.all([
            qualityValidator.validateCompleteness(bundle),
            qualityValidator.validateAccuracy(bundle),
            qualityValidator.validateConsistency(bundle),
            qualityValidator.validateTimeliness(bundle)
        ]);
        
        results.forEach(result => {
            expect(result.score).toBeGreaterThan(0.95); // 95% threshold
            if (result.issues.length > 0) {
                console.log('Quality issues found:', result.issues);
            }
        });
    });
});
```

### 5.2 Testes de Performance

```java
/**
 * Testes de performance para mapeamento em larga escala[34]
 */
@Test
@EnabledIfSystemProperty(named = "performance.tests", matches = "true")
public class MappingPerformanceTest {
    
    @Autowired
    private StructureMapUtilities mapUtilities;
    
    @Autowired
    private IFhirResourceDao<Patient> patientDao;
    
    /**
     * Testa transformação em lote seguindo best practices[35]
     */
    @Test
    public void testBatchTransformation() {
        // Configuração conforme HAPI FHIR performance guide
        DaoConfig daoConfig = new DaoConfig();
        daoConfig.setIndexMissingFields(DaoConfig.IndexEnabledEnum.DISABLED);
        daoConfig.setAutoCreatePlaceholderReferenceTargets(false);
        daoConfig.setMassIngestionMode(true);
        
        List<Patient> patients = generateTestPatients(10000);
        long startTime = System.currentTimeMillis();
        
        // Processa em lotes de 100
        List<List<Patient>> batches = Lists.partition(patients, 100);
        
        batches.parallelStream().forEach(batch -> {
            Bundle bundle = new Bundle();
            bundle.setType(Bundle.BundleType.TRANSACTION);
            
            batch.forEach(patient -> {
                Bundle.BundleEntryComponent entry = bundle.addEntry();
                entry.setResource(patient);
                entry.getRequest()
                    .setMethod(Bundle.HTTPVerb.POST)
                    .setUrl("Patient");
            });
            
            patientDao.transaction(null, bundle);
        });
        
        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;
        
        // Performance benchmark: 10000 recursos em < 30 segundos
        assertTrue(duration < 30000, 
            "Batch processing exceeded time limit: " + duration + "ms");
        
        // Verifica taxa de processamento
        double resourcesPerSecond = (10000.0 / duration) * 1000;
        assertTrue(resourcesPerSecond > 300, 
            "Processing rate below threshold: " + resourcesPerSecond);
    }
    
    /**
     * Testa otimização de cache para ConceptMaps[36]
     */
    @Test
    public void testConceptMapCaching() {
        ConceptMapCache cache = new ConceptMapCache(1000); // LRU cache
        
        // Primeira execução - sem cache
        long firstRun = measureTranslationTime(cache, false);
        
        // Segunda execução - com cache
        long secondRun = measureTranslationTime(cache, true);
        
        // Cache deve melhorar performance em pelo menos 50%
        assertTrue(secondRun < (firstRun * 0.5), 
            "Cache performance improvement insufficient");
    }
}
```

## 6. Monitoramento e Auditoria

### 6.1 Sistema de Logging e Rastreamento

```typescript
/**
 * Sistema de auditoria baseado em FHIR AuditEvent[37]
 */
class MappingAuditLogger {
    private auditQueue: fhir.AuditEvent[] = [];
    private flushInterval = 5000; // 5 segundos
    
    constructor(private fhirClient: FhirClient) {
        setInterval(() => this.flush(), this.flushInterval);
    }
    
    /**
     * Registra evento de mapeamento
     */
    async logMappingEvent(
        source: any,
        target: any,
        mapping: string,
        outcome: 'success' | 'failure',
        details?: string
    ): Promise<void> {
        const auditEvent: fhir.AuditEvent = {
            resourceType: 'AuditEvent',
            type: {
                system: 'http://terminology.hl7.org/CodeSystem/audit-event-type',
                code: 'transform',
                display: 'Transform/Translate Record Lifecycle Event'
            },
            subtype: [{
                system: 'http://hl7.org/fhir/restful-interaction',
                code: 'translate',
                display: 'Translate'
            }],
            action: 'E', // Execute
            recorded: new Date().toISOString(),
            outcome: outcome === 'success' ? '0' : '8',
            outcomeDesc: details,
            agent: [{
                type: {
                    coding: [{
                        system: 'http://terminology.hl7.org/CodeSystem/v3-ParticipationType',
                        code: 'IRCP',
                        display: 'information recipient'
                    }]
                },
                who: {
                    identifier: {
                        system: 'http://example.org/systems',
                        value: 'mapping-service'
                    }
                },
                requestor: false
            }],
            source: {
                site: 'Mapping Service',
                observer: {
                    identifier: {
                        value: 'mapping-engine-01'
                    }
                },
                type: [{
                    system: 'http://terminology.hl7.org/CodeSystem/security-source-type',
                    code: '4',
                    display: 'Application Server'
                }]
            },
            entity: [
                {
                    what: {
                        reference: `#source-${this.generateId()}`
                    },
                    type: {
                        system: 'http://terminology.hl7.org/CodeSystem/audit-entity-type',
                        code: '2',
                        display: 'System Object'
                    },
                    role: {
                        system: 'http://terminology.hl7.org/CodeSystem/object-role',
                        code: '3',
                        display: 'Source'
                    },
                    detail: [{
                        type: 'source-content',
                        valueString: JSON.stringify(source)
                    }]
                },
                {
                    what: {
                        reference: `#target-${this.generateId()}`
                    },
                    type: {
                        system: 'http://terminology.hl7.org/CodeSystem/audit-entity-type',
                        code: '2',
                        display: 'System Object'
                    },
                    role: {
                        system: 'http://terminology.hl7.org/CodeSystem/object-role',
                        code: '20',
                        display: 'Target'
                    },
                    detail: [{
                        type: 'target-content',
                        valueString: JSON.stringify(target)
                    }]
                }
            ]
        };
        
        this.auditQueue.push(auditEvent);
        
        // Flush imediato se crítico
        if (outcome === 'failure') {
            await this.flush();
        }
    }
    
    /**
     * Envia eventos de auditoria em lote[38]
     */
    private async flush(): Promise<void> {
        if (this.auditQueue.length === 0) return;
        
        const bundle: fhir.Bundle = {
            resourceType: 'Bundle',
            type: 'batch',
            entry: this.auditQueue.map(event => ({
                resource: event,
                request: {
                    method: 'POST',
                    url: 'AuditEvent'
                }
            }))
        };
        
        try {
            await this.fhirClient.create(bundle);
            this.auditQueue = [];
        } catch (error) {
            console.error('Failed to flush audit events:', error);
            // Implementar fallback para arquivo local
            this.saveToLocalFile(this.auditQueue);
        }
    }
}
```

## 7. Tratamento de Erros

### 7.1 Estratégias de Recuperação

```typescript
/**
 * Sistema de tratamento de erros com recuperação automática[39]
 */
class MappingErrorHandler {
    private retryPolicy = {
        maxRetries: 3,
        backoffMultiplier: 2,
        initialDelay: 1000
    };
    
    /**
     * Processa com retry e fallback
     */
    async processWithRecovery<T>(
        operation: () => Promise<T>,
        fallback?: () => Promise<T>
    ): Promise<T> {
        let lastError: Error | undefined;
        
        for (let attempt = 0; attempt < this.retryPolicy.maxRetries; attempt++) {
            try {
                return await operation();
            } catch (error) {
                lastError = error as Error;
                
                // Classifica o erro
                const errorType = this.classifyError(error);
                
                switch (errorType) {
                    case 'TRANSIENT':
                        // Retry com backoff exponencial
                        await this.delay(
                            this.retryPolicy.initialDelay * 
                            Math.pow(this.retryPolicy.backoffMultiplier, attempt)
                        );
                        continue;
                        
                    case 'SEMANTIC':
                        // Tenta correção automática
                        const corrected = await this.attemptAutoCorrection(error);
                        if (corrected) {
                            return corrected as T;
                        }
                        break;
                        
                    case 'STRUCTURAL':
                        // Quarentena para revisão manual
                        await this.quarantine(error);
                        break;
                        
                    case 'FATAL':
                        // Falha imediata
                        throw error;
                }
            }
        }
        
        // Tenta fallback se disponível
        if (fallback) {
            console.warn('Attempting fallback strategy');
            return await fallback();
        }
        
        throw lastError;
    }
    
    /**
     * Classificação de erros segundo padrões FHIR[40]
     */
    private classifyError(error: any): string {
        if (error.code === 'ECONNREFUSED' || error.code === 'ETIMEDOUT') {
            return 'TRANSIENT';
        }
        
        if (error.issue?.[0]?.code === 'invalid') {
            return 'STRUCTURAL';
        }
        
        if (error.issue?.[0]?.code === 'not-found') {
            return 'SEMANTIC';
        }
        
        return 'FATAL';
    }
    
    /**
     * Tentativa de correção automática[41]
     */
    private async attemptAutoCorrection(error: any): Promise<any> {
        // Implementa heurísticas de correção
        if (error.message.includes('Unknown code system')) {
            // Tenta mapear para sistema conhecido
            const alternativeSystem = this.findAlternativeCodeSystem(
                error.details.system
            );
            
            if (alternativeSystem) {
                console.log(`Attempting with alternative: ${alternativeSystem}`);
                // Reprocessa com sistema alternativo
                return this.retryWithAlternative(alternativeSystem);
            }
        }
        
        return null;
    }
}
```

## 8. Considerações de Performance

### 8.1 Otimizações para Grande Volume

```java
/**
 * Configuração otimizada para processamento em massa[42]
 */
@Configuration
public class PerformanceOptimization {
    
    @Bean
    public DaoConfig daoConfig() {
        DaoConfig config = new DaoConfig();
        
        // Otimizações para bulk loading[43]
        config.setIndexMissingFields(DaoConfig.IndexEnabledEnum.DISABLED);
        config.setAutoCreatePlaceholderReferenceTargets(false);
        config.setMassIngestionMode(true);
        config.setDeleteEnabled(false);
        
        // Batch settings
        config.setBundleBatchPoolSize(20);
        config.setBundleBatchMaxPoolSize(100);
        
        // Search optimization[44]
        config.setFetchSizeDefaultMaximum(10000);
        config.setReuseCachedSearchResultsForMillis(60000);
        
        // Index tuning
        config.setIndexThreadCount(4);
        
        return config;
    }
    
    @Bean
    public TaskExecutor mappingTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(500);
        executor.setThreadNamePrefix("Mapping-");
        executor.setRejectedExecutionHandler(
            new ThreadPoolExecutor.CallerRunsPolicy()
        );
        executor.initialize();
        return executor;
    }
}
```

### 8.2 Cache e Indexação

```typescript
/**
 * Sistema de cache para mapeamentos frequentes[45]
 */
class MappingCache {
    private cache: Map<string, CacheEntry> = new Map();
    private maxSize = 10000;
    private ttl = 3600000; // 1 hora
    
    /**
     * Implementa LRU com TTL
     */
    get(key: string): any | null {
        const entry = this.cache.get(key);
        
        if (!entry) return null;
        
        // Verifica TTL
        if (Date.now() - entry.timestamp > this.ttl) {
            this.cache.delete(key);
            return null;
        }
        
        // Atualiza LRU
        this.cache.delete(key);
        this.cache.set(key, entry);
        
        return entry.value;
    }
    
    set(key: string, value: any): void {
        // Remove mais antigo se necessário
        if (this.cache.size >= this.maxSize) {
            const firstKey = this.cache.keys().next().value;
            this.cache.delete(firstKey);
        }
        
        this.cache.set(key, {
            value: value,
            timestamp: Date.now()
        });
    }
    
    /**
     * Pré-carrega mapeamentos comuns[46]
     */
    async preload(mappings: string[]): Promise<void> {
        const promises = mappings.map(async (mapping) => {
            const data = await this.loadMapping(mapping);
            this.set(mapping, data);
        });
        
        await Promise.all(promises);
    }
}
```

## 9. Integração com IA e Machine Learning

### 9.1 Mapeamento Assistido por IA

```python
"""
Sistema de mapeamento assistido por Large Language Models[47]
"""
import json
from typing import Dict, List, Optional
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch

class AIAssistedMapper:
    def __init__(self, model_name: str = "bert-base-multilingual-cased"):
        self.tokenizer = AutoTokenizer.from_pretrained(model_name)
        self.model = AutoModelForSequenceClassification.from_pretrained(
            model_name,
            num_labels=2
        )
        
    def suggest_mapping(
        self,
        source_term: str,
        target_candidates: List[Dict],
        threshold: float = 0.8
    ) -> Optional[Dict]:
        """
        Sugere mapeamento usando similaridade semântica[48]
        """
        best_match = None
        best_score = 0.0
        
        for candidate in target_candidates:
            score = self.calculate_similarity(
                source_term,
                candidate['display']
            )
            
            if score > best_score and score >= threshold:
                best_score = score
                best_match = {
                    'code': candidate['code'],
                    'display': candidate['display'],
                    'confidence': score,
                    'method': 'ai-assisted'
                }
        
        return best_match
    
    def validate_mapping_quality(
        self,
        mappings: List[Dict]
    ) -> Dict[str, float]:
        """
        Valida qualidade dos mapeamentos usando ML[49]
        """
        quality_scores = {
            'completeness': self.assess_completeness(mappings),
            'consistency': self.assess_consistency(mappings),
            'accuracy': self.assess_accuracy(mappings)
        }
        
        return quality_scores
```

## 10. Referências Bibliográficas

[1] NCBI. Fast Healthcare Interoperability Resources (FHIR) for Interoperability in Health Research: Systematic Review. PMC 2022. [https://pmc.ncbi.nlm.nih.gov/articles/PMC9346559/](https://pmc.ncbi.nlm.nih.gov/articles/PMC9346559/)

[2] LOINC. SNOMED International Collaboration. [https://loinc.org/collaboration/snomed-international/](https://loinc.org/collaboration/snomed-international/)

[3] National Library of Medicine. SNOMED CT to ICD-10-CM Map. [https://www.nlm.nih.gov/research/umls/mapping_projects/snomedct_to_icd10cm.html](https://www.nlm.nih.gov/research/umls/mapping_projects/snomedct_to_icd10cm.html)

[4] PubMed. Promoting interoperability between SNOMED CT and ICD-11. 2024. [https://pubmed.ncbi.nlm.nih.gov/38867279/](https://pubmed.ncbi.nlm.nih.gov/38867279/)

[5] HL7 International. FHIR ConceptMap Resource. [https://www.hl7.org/fhir/conceptmap.html](https://www.hl7.org/fhir/conceptmap.html)

[6] FHIR. ConceptMap - FHIR v6.0.0-ballot2. [https://build.fhir.org/conceptmap.html](https://build.fhir.org/conceptmap.html)

[7] FHIR Drills. ConceptMap Tutorials. [https://fhir-drills.github.io/conceptmap.html](https://fhir-drills.github.io/conceptmap.html)

[8] App Store. MEDcodigos TUSS SUS CBHPM BR. [https://apps.apple.com/us/app/medcodigos-tuss-sus-cid-cbhpm/id1375786132](https://apps.apple.com/us/app/medcodigos-tuss-sus-cid-cbhpm/id1375786132)

[9] FHIR. Terminology Considerations - HL7 Europe Medication. [https://build.fhir.org/ig/hl7-eu/mpd/branches/__default/terminology.html](https://build.fhir.org/ig/hl7-eu/mpd/branches/__default/terminology.html)

[10] ScienceDirect. RxNorm - an overview. [https://www.sciencedirect.com/topics/medicine-and-dentistry/rxnorm](https://www.sciencedirect.com/topics/medicine-and-dentistry/rxnorm)

[11] National Library of Medicine. ATC Source Information. [https://www.nlm.nih.gov/research/umls/rxnorm/sourcereleasedocs/atc.html](https://www.nlm.nih.gov/research/umls/rxnorm/sourcereleasedocs/atc.html)

[12] FHIR. Introduction - FHIR to OMOP FHIR IG v1.0.0-ballot. [https://build.fhir.org/ig/HL7/fhir-omop-ig/](https://build.fhir.org/ig/HL7/fhir-omop-ig/)

[13] FHIR. Mapping Guidelines - HL7 Version 2 to FHIR v1.0.0. [https://build.fhir.org/ig/HL7/v2-to-fhir/mapping_guidelines.html](https://build.fhir.org/ig/HL7/v2-to-fhir/mapping_guidelines.html)

[14] FHIR. V2 to FHIR - HL7 Version 2 to FHIR v1.0.0. [https://build.fhir.org/ig/HL7/v2-to-fhir/](https://build.fhir.org/ig/HL7/v2-to-fhir/)

[15] Mindbowser. High-Performance FHIR to OMOP Transformation Explained. [https://www.mindbowser.com/fhir-to-omop-fragment-processing/](https://www.mindbowser.com/fhir-to-omop-fragment-processing/)

[16] OHDSI. Mappings between OHDSI CDM and FHIR. [https://www.ohdsi.org/web/wiki/doku.php?id=projects:workgroups:mappings_between_ohdsi_cdm_and_fhir](https://www.ohdsi.org/web/wiki/doku.php?id=projects:workgroups:mappings_between_ohdsi_cdm_and_fhir)

[17] OpenFHIR. Bridging openEHR & HL7 FHIR. [https://open-fhir.com/](https://open-fhir.com/)

[18] Medblocks. Announcing Medblocks openFHIR. [https://medblocks.com/blog/announcing-medblocks-openfhir-an-open-source-engine-that-bridges-openehr-and-fhir](https://medblocks.com/blog/announcing-medblocks-openfhir-an-open-source-engine-that-bridges-openehr-and-fhir)

[19] OpenEHR. Online openEHR2FHIR transformer. [https://discourse.openehr.org/t/online-openehr2fhir-transformer/2606](https://discourse.openehr.org/t/online-openehr2fhir-transformer/2606)

[20] HL7 International. HL7.FHIR.UV.V2MAPPINGS Mapping Guidelines. [https://www.hl7.org/fhir/uv/v2mappings/2020sep/mapping_guidelines.html](https://www.hl7.org/fhir/uv/v2mappings/2020sep/mapping_guidelines.html)

[21] MuleSoft. HL7 v2 to FHIR Converter. [https://docs.mulesoft.com/healthcare/latest/hl7-v2-fhir-converter](https://docs.mulesoft.com/healthcare/latest/hl7-v2-fhir-converter)

[22] GitHub. LinuxForHealth HL7v2-FHIR Converter. [https://github.com/LinuxForHealth/hl7v2-fhir-converter](https://github.com/LinuxForHealth/hl7v2-fhir-converter)

[23] Microsoft Learn. Transform HL7v2 to FHIR with Azure. [https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data-azure-data-factory](https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data-azure-data-factory)

[24] HL7 International. Home Page - C-CDA on FHIR v1.2.0. [http://hl7.org/fhir/us/ccda/](http://hl7.org/fhir/us/ccda/)

[25] ResearchGate. Interoperability using FHIR Mapping Language. [https://www.researchgate.net/publication/387697678_Interoperability_of_health_data_using_FHIR_Mapping_Language_transforming_HL7_CDA_to_FHIR_with_reusable_visual_components](https://www.researchgate.net/publication/387697678_Interoperability_of_health_data_using_FHIR_Mapping_Language_transforming_HL7_CDA_to_FHIR_with_reusable_visual_components)

[26] PubMed Central. Interoperability using FHIR Mapping Language. [https://pmc.ncbi.nlm.nih.gov/articles/PMC11693713/](https://pmc.ncbi.nlm.nih.gov/articles/PMC11693713/)

[27] GitHub. SRDC CDA2FHIR Library. [https://github.com/srdc/cda2fhir](https://github.com/srdc/cda2fhir)

[28] Aidbox. C-CDA / FHIR Converter. [https://docs.aidbox.app/modules/integration-toolkit/ccda-converter](https://docs.aidbox.app/modules/integration-toolkit/ccda-converter)

[29] PubMed. Bridging the Gap between HL7 CDA and HL7 FHIR. [https://pubmed.ncbi.nlm.nih.gov/27139391/](https://pubmed.ncbi.nlm.nih.gov/27139391/)

[30] Estuary. Healthcare Data Integration Benefits. [https://estuary.dev/blog/healthcare-data-integration/](https://estuary.dev/blog/healthcare-data-integration/)

[31] HL7 International. FHIR Mapping Language (FML). [https://hl7.org/fhir/mapping-language.html](https://hl7.org/fhir/mapping-language.html)

[32] FHIR. Mapping-language - FHIR v6.0.0-ballot3. [https://build.fhir.org/mapping-language.html](https://build.fhir.org/mapping-language.html)

[33] FHIR. Mapping Tutorial. [https://build.fhir.org/mapping-tutorial.html](https://build.fhir.org/mapping-tutorial.html)

[34] FHIR. StructureMap - FHIR v6.0.0-ballot2. [https://build.fhir.org/structuremap.html](https://build.fhir.org/structuremap.html)

[35] HL7 International. StructureMap - FHIR v5.0.0. [http://hl7.org/fhir/structuremap.html](http://hl7.org/fhir/structuremap.html)

[36] HL7 International. FHIR Shorthand (FSH). [https://hl7.org/fhir/uv/shorthand/](https://hl7.org/fhir/uv/shorthand/)

[37] FHIR. FHIR Shorthand v3.0.0. [https://build.fhir.org/ig/HL7/fhir-shorthand/](https://build.fhir.org/ig/HL7/fhir-shorthand/)

[38] SMART Health IT. SMART on FHIR JavaScript Library. [http://docs.smarthealthit.org/client-js/](http://docs.smarthealthit.org/client-js/)

[39] NPM. fhirclient package. [https://www.npmjs.com/package/fhirclient](https://www.npmjs.com/package/fhirclient)

[40] NPM. fhir-kit-client package. [https://www.npmjs.com/package/fhir-kit-client](https://www.npmjs.com/package/fhir-kit-client)

[41] GitHub. Vermonster fhir-kit-client. [https://github.com/Vermonster