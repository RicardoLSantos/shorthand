# SOP-014: FHIR Data Mapping and Integration
## Comprehensive Implementation Guide for Healthcare Interoperability

### Version 4.0 - Complete Edition with Full Bibliography
### Date: December 2024
### Status: Production Ready

---

## Executive Summary

This Standard Operating Procedure (SOP-014) establishes comprehensive guidelines for implementing FHIR data mapping and integration across healthcare systems. Drawing from 142 authoritative sources including HL7 International specifications, IHE frameworks, and production implementations, this document provides technical teams with validated approaches for achieving semantic interoperability while maintaining compliance with international privacy regulations.

## 1. Introduction and Scope

### 1.1 Purpose
This SOP defines standardized procedures for mapping healthcare data between FHIR and other healthcare standards including HL7 v2, CDA, openEHR, OMOP CDM, and proprietary formats. It establishes quality assurance frameworks, validation methodologies, and governance structures required for production-grade implementations.

### 1.2 Scope
- **Technical Coverage**: FHIR R4/R5, HL7 v2.x, CDA R2, openEHR, OMOP CDM v5.4
- **Regulatory Compliance**: LGPD (Brazil), GDPR (Europe), HIPAA (USA)
- **Integration Patterns**: RESTful APIs, message queues, ETL pipelines, real-time streaming
- **Deployment Models**: Cloud-native, on-premises, hybrid architectures

### 1.3 Key Stakeholders
- Technical architects and developers
- Clinical informaticists
- Data governance teams
- Quality assurance specialists
- Regulatory compliance officers

## 2. Terminology Mapping Foundations

### 2.1 Core Terminology Systems

**SNOMED CT Integration**
- 370,000+ active concepts across 19 hierarchies
- Monthly international releases with national extensions
- GPS (General Practice Subset) with 10,000+ commonly used terms
- ECL (Expression Constraint Language) for complex queries

**LOINC Implementation**
- 104,000+ observation codes
- Biannual releases (June/December)
- LOINC-SNOMED CT Cooperative Agreement mappings
- Answer lists and panel hierarchies

**ICD Integration Patterns**
- ICD-10-CM: 72,000+ diagnosis codes
- ICD-10-PCS: 78,000+ procedure codes
- ICD-11 MMS: 35,000+ entities with post-coordination
- Bidirectional SNOMED CT mappings via NLM I-MAGIC

### 2.2 FHIR ConceptMap Resources

The ConceptMap resource enables formal terminology mappings with:
- Source and target code systems
- Equivalence relationships (equivalent, wider, narrower, inexact, unmatched)
- Dependency mappings for context-sensitive translations
- Group-based mappings for complex transformations

**Implementation Pattern**:
```json
{
  "resourceType": "ConceptMap",
  "url": "http://example.org/fhir/ConceptMap/snomed-to-icd10",
  "version": "2024.1",
  "name": "SNOMED_CT_to_ICD10_CM",
  "status": "active",
  "sourceUri": "http://snomed.info/sct",
  "targetUri": "http://hl7.org/fhir/sid/icd-10-cm",
  "group": [{
    "source": "http://snomed.info/sct",
    "target": "http://hl7.org/fhir/sid/icd-10-cm",
    "element": [{
      "code": "73211009",
      "target": [{
        "code": "E11.9",
        "equivalence": "equivalent"
      }]
    }]
  }]
}
```

### 2.3 Cross-Regional Terminology Challenges

**Brazilian TUSS/CBHPM Integration**
- ANS governance through PQDAS project
- Open Concept Lab management
- Quarterly updates synchronized with SUS requirements

**European EDQM Harmonization**
- 35 language translations
- Pharmaceutical dose form mappings
- IDMP compliance requirements

**US RxNorm Integration**
- Monthly updates from NLM
- NDC to RxCUI mappings
- ATC classification linkages

## 3. Data Integration Patterns

### 3.1 FHIR to OMOP CDM Mapping

**Official HL7 Specification v1.0.0**
- Targets OMOP CDM v5.4 with FHIR R4
- International Patient Access profile compliance
- Bidirectional transformation support

**Core Resource Mappings**:
| FHIR Resource | OMOP Table | Mapping Complexity |
|--------------|------------|-------------------|
| Patient | PERSON | Simple |
| Condition | CONDITION_OCCURRENCE | Moderate |
| Observation | OBSERVATION | Complex |
| MedicationRequest | DRUG_EXPOSURE | Complex |
| Procedure | PROCEDURE_OCCURRENCE | Moderate |

**Implementation Tools**:
- OHDSI FHIR Working Group specifications
- Georgia Tech Release 2 mappings
- CDMH Project implementation guides
- FHIR Ontop OHDSI repository

### 3.2 OpenEHR to FHIR Transformation

**openFHIR Engine Architecture**:
- YAML-based bidirectional mappings
- FHIR Connect specification compliance
- Docker containerized deployment
- Atlas management interface

**Mapping Components**:
1. Model mappings (archetype to resource)
2. Context mappings (profile connections)
3. Extension mappings (profile-specific)
4. Terminology bindings

**Production Tools**:
- Medblocks openFHIR (Apache 2.0)
- VeraTech online transformer
- IntelliJ FHIR Connect Plugin
- openEHR CKM with mapping publication

### 3.3 HL7 v2 to FHIR Conversion

**Implementation Guide v1.0.0 Coverage**:
- All v2.9 message types
- Legacy version support (v2.3-v2.8)
- Segment-level mappings
- Context-aware transformations

**Supported Message Types**:
- ADT: A01, A03, A04, A08, A28, A31, A34, A40
- ORU: Observation results
- ORM: Order messages
- MDM: Medical documents

**Production Solutions**:
- Microsoft Azure FHIR Converter
- LinuxForHealth Converter
- MuleSoft enterprise platform
- Smile CDR commercial server

### 3.4 CDA to FHIR Document Mapping

**C-CDA on FHIR v1.2.0 Patterns**:
- Composition-based document structure
- US Core profile integration
- Template-level mapping approach
- "Required if known" paradigm

**Available Tools**:
- SRDC CDA2FHIR Java library
- Aidbox RESTful converter
- Estonian ENHIS visual components
- Azure Data Factory templates

## 4. Technical Implementation

### 4.1 FHIR Mapping Language (FML)

**Language Specification**:
- QVT-based transformation model
- FHIRPath expression support
- Media type: `text/fhir-mapping`
- Reserved keywords: map, uses, alias, imports, group, extends

**Transformation Functions**:
```
create(type) - Create new resource
copy(source) - Direct value copy
evaluate(expression) - FHIRPath evaluation
reference(source) - Create reference
uuid() - Generate UUID
truncate(source, length) - String truncation
```

**Example Mapping**:
```
map "http://example.org/PatientTransform" = "PatientTransform"

uses "http://hl7.org/fhir/StructureDefinition/Patient" as source
uses "http://hl7.org/fhir/StructureDefinition/Patient" as target

group PatientTransform(source src : Patient, target tgt : Patient) {
  src.identifier -> tgt.identifier;
  src.name as vn -> tgt.name as tn then {
    vn.given -> tn.given;
    vn.family -> tn.family;
  };
  src.birthDate -> tgt.birthDate;
}
```

### 4.2 StructureMap Resources

**JSON Structure**:
```json
{
  "resourceType": "StructureMap",
  "url": "http://example.org/fhir/StructureMap/example",
  "name": "ExampleTransform",
  "status": "active",
  "structure": [{
    "url": "http://hl7.org/fhir/StructureDefinition/Source",
    "mode": "source"
  }],
  "group": [{
    "name": "MainGroup",
    "input": [{
      "name": "source",
      "type": "Source",
      "mode": "source"
    }],
    "rule": [{
      "name": "CopyIdentifier",
      "source": [{
        "context": "source",
        "element": "identifier"
      }],
      "target": [{
        "context": "target",
        "element": "identifier",
        "transform": "copy"
      }]
    }]
  }]
}
```

### 4.3 FHIR Shorthand (FSH)

**Profile Definition**:
```fsh
Profile: BrazilianPatient
Parent: Patient
Id: br-patient
Title: "Brazilian Patient Profile"
Description: "Patient profile for Brazil with CPF"

* identifier 1..* MS
* identifier ^slicing.discriminator.type = #pattern
* identifier ^slicing.discriminator.path = "system"
* identifier contains cpf 1..1 MS

* identifier[cpf].system = "http://rnds.saude.gov.br/fhir/r4/NamingSystem/cpf"
* identifier[cpf].value 1..1 MS
```

### 4.4 JavaScript/TypeScript Clients

**SMART on FHIR Client**:
```javascript
import FHIR from 'fhirclient';

const client = await FHIR.oauth2.ready();
const patient = await client.request('Patient/123');
const observations = await client.request('Observation', {
  flat: true,
  pageLimit: 0,
  parameters: {
    patient: '123',
    code: 'http://loinc.org|55284-4'
  }
});
```

**FHIR Kit Client**:
```javascript
import Client from 'fhir-kit-client';

const client = new Client({
  baseUrl: 'https://fhir.example.org/r4'
});

const searchResult = await client.search({
  resourceType: 'Patient',
  searchParams: {
    name: 'Smith',
    birthdate: 'ge1980-01-01'
  }
});
```

## 5. Validation and Quality Assurance

### 5.1 FHIR Validation Framework

**Multi-Layer Validation**:
1. **Structural Validation**: XML/JSON schema compliance
2. **FHIR Validation**: Resource type requirements
3. **Profile Validation**: Constraint compliance
4. **Terminology Validation**: Code system verification
5. **Business Rule Validation**: Invariant checking

**Validation Tools**:
- HAPI FHIR Validator (Java)
- FHIR.js Validator (JavaScript)
- .NET FHIR Validator (C#)
- Inferno Test Framework
- Touchstone Testing Platform

### 5.2 Data Quality Metrics

**Required Quality Indicators**:
- Completeness: >95% required fields
- Accuracy: <0.1% error rate
- Consistency: 100% referential integrity
- Timeliness: <5 second processing
- Uniqueness: Zero duplicate resources

**Monitoring Implementation**:
```python
def calculate_quality_metrics(fhir_bundle):
    metrics = {
        'total_resources': 0,
        'valid_resources': 0,
        'missing_required': 0,
        'terminology_errors': 0,
        'reference_errors': 0
    }
    
    for entry in fhir_bundle.entry:
        metrics['total_resources'] += 1
        validation_result = validator.validate(entry.resource)
        
        if validation_result.is_valid:
            metrics['valid_resources'] += 1
        else:
            categorize_errors(validation_result.errors, metrics)
    
    return calculate_percentages(metrics)
```

### 5.3 Testing Strategies

**Test Coverage Requirements**:
- Unit tests: >80% code coverage
- Integration tests: All API endpoints
- E2E tests: Critical workflows
- Performance tests: Load scenarios
- Security tests: OWASP Top 10

**Test Data Management**:
- Synthea synthetic data generation
- De-identified production samples
- Edge case scenarios
- Error condition coverage

## 6. Security and Privacy Compliance

### 6.1 LGPD Compliance (Brazil)

**Key Requirements**:
- Explicit consent management
- Data minimization principles
- Right to erasure implementation
- Cross-border transfer controls
- Data Protection Officer designation

**Implementation Patterns**:
```json
{
  "resourceType": "Consent",
  "status": "active",
  "scope": {
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/consentscope",
      "code": "patient-privacy"
    }]
  },
  "category": [{
    "coding": [{
      "system": "http://loinc.org",
      "code": "59284-0"
    }]
  }],
  "policy": [{
    "authority": "https://www.gov.br/lgpd",
    "uri": "https://rnds.saude.gov.br/privacy-policy"
  }]
}
```

### 6.2 GDPR Compliance (Europe)

**Technical Safeguards**:
- Encryption at rest (AES-256)
- Encryption in transit (TLS 1.3)
- Pseudonymization techniques
- Audit logging (immutable)
- Access control (RBAC/ABAC)

**Privacy by Design**:
- Data minimization defaults
- Purpose limitation enforcement
- Storage limitation controls
- Consent withdrawal mechanisms

### 6.3 HIPAA Compliance (USA)

**Required Safeguards**:
- Access controls (unique user IDs)
- Audit controls (6-year retention)
- Integrity controls (checksums)
- Transmission security (encryption)
- Physical safeguards documentation

**De-identification Methods**:
- Safe Harbor (18 identifiers)
- Expert Determination
- Limited Data Sets
- Synthetic data generation

## 7. Deployment and Operations

### 7.1 Infrastructure Requirements

**Minimum Specifications**:
- CPU: 8 cores (16 recommended)
- RAM: 32GB (64GB recommended)
- Storage: 500GB SSD (NVMe preferred)
- Network: 1Gbps (10Gbps recommended)
- Database: PostgreSQL 14+ or MongoDB 5+

**Scaling Considerations**:
- Horizontal scaling for APIs
- Read replicas for databases
- CDN for static resources
- Message queues for async processing
- Cache layers (Redis/Memcached)

### 7.2 Monitoring and Observability

**Key Performance Indicators**:
- API response time (p50, p95, p99)
- Throughput (requests/second)
- Error rates by category
- Resource utilization
- Queue depths and processing times

**Monitoring Stack**:
```yaml
monitoring:
  metrics:
    - prometheus
    - grafana
  tracing:
    - opentelemetry
    - jaeger
  logging:
    - elasticsearch
    - logstash
    - kibana
  alerting:
    - alertmanager
    - pagerduty
```

### 7.3 Disaster Recovery

**Recovery Objectives**:
- RPO (Recovery Point Objective): 15 minutes
- RTO (Recovery Time Objective): 2 hours
- Backup frequency: Continuous replication
- Backup retention: 90 days
- Geographic distribution: 3+ regions

**Backup Strategies**:
- Database snapshots (hourly)
- Transaction log shipping
- File system backups
- Configuration management (Git)
- Infrastructure as Code (Terraform)

## 8. Governance and Maintenance

### 8.1 Change Management

**Change Control Process**:
1. Impact assessment
2. Risk evaluation
3. Testing requirements
4. Approval workflow
5. Deployment planning
6. Rollback procedures
7. Post-implementation review

**Version Control**:
- Semantic versioning (MAJOR.MINOR.PATCH)
- Git-based workflows
- Feature branching
- Pull request reviews
- Automated testing gates

### 8.2 Documentation Requirements

**Required Documentation**:
- Architecture diagrams
- Data flow diagrams
- API specifications (OpenAPI)
- Mapping specifications
- Runbooks and playbooks
- Training materials
- Compliance attestations

### 8.3 Continuous Improvement

**Quality Metrics Review**:
- Monthly performance reviews
- Quarterly security assessments
- Semi-annual compliance audits
- Annual architecture reviews

**Innovation Tracking**:
- FHIR specification updates
- Terminology releases
- Regulatory changes
- Technology advancements

## 9. Advanced Topics

### 9.1 AI/ML Integration

**Current Capabilities**:
- NLP for unstructured data extraction
- Predictive analytics for risk scoring
- Anomaly detection for data quality
- Automated coding assistance

**Implementation Considerations**:
- Model governance and versioning
- Explainability requirements
- Bias detection and mitigation
- Performance monitoring
- Regulatory compliance (FDA, CE)

### 9.2 Blockchain Integration

**Use Cases**:
- Consent management
- Audit trail integrity
- Credential verification
- Cross-organization identity

**Technical Patterns**:
- Off-chain data storage
- Hash-based verification
- Smart contract integration
- Decentralized identifiers (DIDs)

### 9.3 Real-World Implementations

**Epic Integration**:
- 305 million patient records
- 2.9 billion annual transactions
- FHIR R4 native support
- SMART on FHIR apps

**Cerner/Oracle Health**:
- 225+ million patient records
- HealtheIntent platform
- FHIR-first architecture
- Real-time event streaming

**National Implementations**:
- UK NHS: 65 million citizens
- Australian My Health Record: 23 million
- Estonian ENHIS: 1.3 million
- Austrian ELGA: 9 million

## 10. Future Directions

### 10.1 FHIR R5 Evolution

**Key Enhancements**:
- 145+ resources (15% increase)
- Improved subscription framework
- Enhanced terminology services
- GraphQL support maturity
- Bulk data v2.0 specifications

### 10.2 Emerging Standards

**Standards Convergence**:
- FHIR + openEHR integration
- IHE profile harmonization
- WHO SMART Guidelines
- HL7 Da Vinci initiatives
- USCDI v4 requirements

### 10.3 Technology Trends

**2025-2027 Roadmap**:
- Quantum-resistant cryptography
- Edge computing for IoMT
- 5G-enabled real-time sync
- Federated learning models
- Zero-trust architectures

## Conclusion

This comprehensive SOP provides healthcare organizations with validated, production-tested approaches for implementing FHIR data mapping and integration. Success requires balancing technical excellence with regulatory compliance, operational efficiency, and strategic innovation positioning.

Organizations should prioritize:
1. Official HL7 specifications as foundation
2. Comprehensive testing frameworks
3. Automated quality monitoring
4. Strategic AI/ML integration planning
5. Continuous standards alignment

The maturity of FHIR mapping tools, validation frameworks, and real-world implementations creates unprecedented opportunities for achieving true semantic interoperability across global healthcare systems.

---

## Referências Bibliográficas

[1] PubMed Central. Fast Healthcare Interoperability Resources (FHIR) for Interoperability in Health Research: Systematic Review. 2022. [https://pmc.ncbi.nlm.nih.gov/articles/PMC9346559/](https://pmc.ncbi.nlm.nih.gov/articles/PMC9346559/)

[2] LOINC. SNOMED International Collaboration. [https://loinc.org/collaboration/snomed-international/](https://loinc.org/collaboration/snomed-international/)

[3] National Library of Medicine. SNOMED CT to ICD-10-CM Map. [https://www.nlm.nih.gov/research/umls/mapping_projects/snomedct_to_icd10cm.html](https://www.nlm.nih.gov/research/umls/mapping_projects/snomedct_to_icd10cm.html)

[4] National Library of Medicine. I-MAGIC Algorithm Documentation. [https://www.nlm.nih.gov/research/umls/mapping_projects/snomedct_to_icd10cm.html](https://www.nlm.nih.gov/research/umls/mapping_projects/snomedct_to_icd10cm.html)

[5] PubMed. Promoting interoperability between SNOMED CT and ICD-11. 2024. [https://pubmed.ncbi.nlm.nih.gov/38867279/](https://pubmed.ncbi.nlm.nih.gov/38867279/)

[6] HL7 International. ConceptMap - FHIR v5.0.0. [https://www.hl7.org/fhir/conceptmap.html](https://www.hl7.org/fhir/conceptmap.html)

[7] FHIR. ConceptMap - FHIR v6.0.0-ballot2. [https://build.fhir.org/conceptmap.html](https://build.fhir.org/conceptmap.html)

[8] FHIR Drills. ConceptMap Tutorials. [https://fhir-drills.github.io/conceptmap.html](https://fhir-drills.github.io/conceptmap.html)

[9] App Store. MEDcodigos TUSS SUS CBHPM BR. [https://apps.apple.com/us/app/medcodigos-tuss-sus-cid-cbhpm/id1375786132](https://apps.apple.com/us/app/medcodigos-tuss-sus-cid-cbhpm/id1375786132)

[10] FHIR. Terminology Considerations - HL7 Europe Medication. [https://build.fhir.org/ig/hl7-eu/mpd/branches/__default/terminology.html](https://build.fhir.org/ig/hl7-eu/mpd/branches/__default/terminology.html)

[11] ScienceDirect. RxNorm - An Overview. [https://www.sciencedirect.com/topics/medicine-and-dentistry/rxnorm](https://www.sciencedirect.com/topics/medicine-and-dentistry/rxnorm)

[12] National Library of Medicine. ATC Source Information. [https://www.nlm.nih.gov/research/umls/rxnorm/sourcereleasedocs/atc.html](https://www.nlm.nih.gov/research/umls/rxnorm/sourcereleasedocs/atc.html)

[13] FHIR. FHIR to OMOP Implementation Guide. [https://build.fhir.org/ig/HL7/fhir-omop-ig/](https://build.fhir.org/ig/HL7/fhir-omop-ig/)

[14] FHIR. V2 to FHIR Mapping Guidelines. [https://build.fhir.org/ig/HL7/v2-to-fhir/mapping_guidelines.html](https://build.fhir.org/ig/HL7/v2-to-fhir/mapping_guidelines.html)

[15] OHDSI. Mappings between OHDSI CDM and FHIR. [https://www.ohdsi.org/web/wiki/doku.php?id=projects:workgroups:mappings_between_ohdsi_cdm_and_fhir](https://www.ohdsi.org/web/wiki/doku.php?id=projects:workgroups:mappings_between_ohdsi_cdm_and_fhir)

[16] Mindbowser. FHIR to OMOP Fragment Processing. [https://www.mindbowser.com/fhir-to-omop-fragment-processing/](https://www.mindbowser.com/fhir-to-omop-fragment-processing/)

[17] OpenFHIR. Bridging openEHR & HL7 FHIR. [https://open-fhir.com/](https://open-fhir.com/)

[18] Medblocks. Announcing Medblocks openFHIR. [https://medblocks.com/blog/announcing-medblocks-openfhir-an-open-source-engine-that-bridges-openehr-and-fhir](https://medblocks.com/blog/announcing-medblocks-openfhir-an-open-source-engine-that-bridges-openehr-and-fhir)

[19] OpenEHR. Online openEHR2FHIR transformer. [https://discourse.openehr.org/t/online-openehr2fhir-transformer/2606](https://discourse.openehr.org/t/online-openehr2fhir-transformer/2606)

[20] HL7 International. HL7.FHIR.UV.V2MAPPINGS. [https://www.hl7.org/fhir/uv/v2mappings/2020sep/mapping_guidelines.html](https://www.hl7.org/fhir/uv/v2mappings/2020sep/mapping_guidelines.html)

[21] MuleSoft. HL7 v2 to FHIR Converter. [https://docs.mulesoft.com/healthcare/latest/hl7-v2-fhir-converter](https://docs.mulesoft.com/healthcare/latest/hl7-v2-fhir-converter)

[22] GitHub. LinuxForHealth HL7v2-FHIR Converter. [https://github.com/LinuxForHealth/hl7v2-fhir-converter](https://github.com/LinuxForHealth/hl7v2-fhir-converter)

[23] Microsoft Learn. Transform HL7v2 to FHIR R4. [https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data-azure-data-factory](https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data-azure-data-factory)

[24] HL7 International. C-CDA on FHIR v1.2.0. [http://hl7.org/fhir/us/ccda/](http://hl7.org/fhir/us/ccda/)

[25] ResearchGate. Interoperability using FHIR Mapping Language. [https://www.researchgate.net/publication/387697678_Interoperability_of_health_data_using_FHIR_Mapping_Language_transforming_HL7_CDA_to_FHIR_with_reusable_visual_components](https://www.researchgate.net/publication/387697678_Interoperability_of_health_data_using_FHIR_Mapping_Language_transforming_HL7_CDA_to_FHIR_with_reusable_visual_components)

[26] PubMed Central. Transforming HL7 CDA to FHIR. [https://pmc.ncbi.nlm.nih.gov/articles/PMC11693713/](https://pmc.ncbi.nlm.nih.gov/articles/PMC11693713/)

[27] GitHub. SRDC CDA2FHIR Transformer. [https://github.com/srdc/cda2fhir](https://github.com/srdc/cda2fhir)

[28] Aidbox. C-CDA / FHIR Converter. [https://docs.aidbox.app/modules/integration-toolkit/ccda-converter](https://docs.aidbox.app/modules/integration-toolkit/ccda-converter)

[29] PubMed. Bridging the Gap between HL7 CDA and HL7 FHIR. [https://pubmed.ncbi.nlm.nih.gov/27139391/](https://pubmed.ncbi.nlm.nih.gov/27139391/)

[30] Estuary. Healthcare Data Integration Benefits. [https://estuary.dev/blog/healthcare-data-integration/](https://estuary.dev/blog/healthcare-data-integration/)

[31] HL7 International. FHIR Mapping Language (FML). [https://hl7.org/fhir/mapping-language.html](https://hl7.org/fhir/mapping-language.html)

[32] FHIR. Mapping-language v6.0.0-ballot3. [https://build.fhir.org/mapping-language.html](https://build.fhir.org/mapping-language.html)

[33] FHIR. Mapping Tutorial. [https://build.fhir.org/mapping-tutorial.html](https://build.fhir.org/mapping-tutorial.html)

[34] FHIR. StructureMap v6.0.0-ballot2. [https://build.fhir.org/structuremap.html](https://build.fhir.org/structuremap.html)

[35] HL7 International. StructureMap v5.0.0. [http://hl7.org/fhir/structuremap.html](http://hl7.org/fhir/structuremap.html)

[36] HL7 International. FHIR Shorthand (FSH). [https://hl7.org/fhir/uv/shorthand/](https://hl7.org/fhir/uv/shorthand/)

[37] FHIR. FHIR Shorthand v3.0.0. [https://build.fhir.org/ig/HL7/f