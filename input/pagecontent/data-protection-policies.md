---
title: Data Protection Policies
---

# Healthcare Data Protection Policies

This Implementation Guide complies with multiple international data protection regulations.

## Supported Jurisdictions

### 🇪🇺 European Union - GDPR
- **Regulation**: General Data Protection Regulation (EU) 2016/679
- **Official URL**: [EUR-Lex GDPR](https://eur-lex.europa.eu/eli/reg/2016/679/oj)
- **Key Requirements**:
  - Explicit consent for data processing
  - Right to erasure ("right to be forgotten")
  - Data portability
  - Privacy by design

### 🇺🇸 United States - HIPAA
- **Regulation**: Health Insurance Portability and Accountability Act
- **Official URL**: [HHS HIPAA](https://www.hhs.gov/hipaa/index.html)
- **Key Requirements**:
  - Minimum necessary standard
  - Administrative, physical, and technical safeguards
  - Breach notification
  - Business Associate Agreements

### 🇧🇷 Brazil - LGPD
- **Regulation**: Lei Geral de Proteção de Dados (Law 13.709/2018)
- **Official URL**: [Planalto LGPD](http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm)
- **Key Requirements**:
  - Legal basis for processing
  - Data subject rights
  - International transfer restrictions
  - Data Protection Officer requirement

## LGPD Implementation Phases

This IG implements LGPD compliance through three incremental phases, creating reusable FHIR artifacts that also serve GDPR and HIPAA requirements.

### Phase 1: Foundation (Data Classification + Consent)
- [DataAnonymizationStatus](StructureDefinition-data-anonymization-status.html) extension — classifies data as identified, pseudonymized, anonymized, or de-identified (shared: LGPD/GDPR/HIPAA)
- [LGPDProcessingPurposeVS](ValueSet-lgpd-processing-purpose-vs.html) — legal bases for processing (Art. 7)
- [AIConsentCategoryVS](ValueSet-ai-consent-category-vs.html) — granular AI consent categories (Art. 8, Art. 20)

### Phase 2: Governance Roles + Data Subject Rights
- [OrganizationDataController](StructureDefinition-organization-data-controller.html) — controller profile with DPO reference (Art. 5-VI)
- [PractitionerRoleDPO](StructureDefinition-practitioner-role-dpo.html) — Data Protection Officer role (Art. 37-38)
- [TaskDataSubjectRequest](StructureDefinition-task-data-subject-request.html) — all 8 Art. 18 data subject rights + Art. 20 automated decision review

### Phase 3: Data Governance + Incident Notification
- [DataMinimizationScope](StructureDefinition-data-minimization-scope.html) extension — documents necessity justification per Art. 6-III (shared: LGPD/GDPR/HIPAA)
- [BiasDetectionFlag](StructureDefinition-bias-detection-flag.html) extension — AI non-discrimination compliance (Art. 6-IV)
- [CommunicationSecurityIncident](StructureDefinition-communication-security-incident.html) — ANPD notification profile (Art. 46-48)
- [DataAnonymizationMethodVS](ValueSet-data-anonymization-method-vs.html) — anonymization techniques (Art. 12)

## LGPD Article-to-Artifact Mapping

| LGPD Article | Requirement | FHIR Artifact |
|:-------------|:------------|:--------------|
| Art. 5-III | Anonymization definition | [DataAnonymizationStatus](StructureDefinition-data-anonymization-status.html) |
| Art. 5-VI | Controller definition | [OrganizationDataController](StructureDefinition-organization-data-controller.html) |
| Art. 6-III | Data minimization | [DataMinimizationScope](StructureDefinition-data-minimization-scope.html) |
| Art. 6-IV | Non-discrimination | [BiasDetectionFlag](StructureDefinition-bias-detection-flag.html) |
| Art. 7 | Legal bases for processing | [LGPDProcessingPurposeVS](ValueSet-lgpd-processing-purpose-vs.html) |
| Art. 8/11 | Consent requirements | [AIConsentCategoryVS](ValueSet-ai-consent-category-vs.html) |
| Art. 12 | Anonymization methods | [DataAnonymizationMethodVS](ValueSet-data-anonymization-method-vs.html) |
| Art. 18 | Data subject rights (8 rights) | [TaskDataSubjectRequest](StructureDefinition-task-data-subject-request.html) |
| Art. 20 | Automated decision review | [LGPDDataSubjectRightVS](ValueSet-lgpd-data-subject-right-vs.html) |
| Art. 37-38 | DPO designation | [PractitionerRoleDPO](StructureDefinition-practitioner-role-dpo.html) |
| Art. 46 | Security measures | [CommunicationSecurityIncident](StructureDefinition-communication-security-incident.html) |
| Art. 48 | Incident notification | [SecurityIncidentTypeVS](ValueSet-security-incident-type-vs.html) |

## Cross-Jurisdictional Shared Artifacts

Several artifacts serve multiple regulatory frameworks simultaneously:

| Artifact | LGPD | GDPR | HIPAA |
|:---------|:----:|:----:|:-----:|
| DataAnonymizationStatus | Art. 5/12 | Art. 4(5)/Rec.26 | §164.514 |
| DataMinimizationScope | Art. 6-III | Art. 5(1)(c) | §164.502(b) |
| DataAnonymizationMethodVS | Art. 12 | Recital 26 | §164.514(b) |
| SecurityIncidentTypeVS | Art. 48 | Art. 33-34 | §164.408 |
| TaskDataSubjectRequest | Art. 18 | Art. 15-22 | §164.524-526 |

This cross-jurisdictional approach reduces implementation burden: organizations operating across Brazil, EU, and US can reuse the same FHIR artifacts with jurisdiction-specific ValueSet bindings.

## Implementation in FHIR

This IG uses the [IHE Privacy Consent on FHIR (PCF)](https://profiles.ihe.net/ITI/PCF/) profile for consent management.

### Consent Resources
- [Multi-Jurisdictional Consent Profile](StructureDefinition-multi-jurisdictional-consent.html)
- [Mindfulness Access Policy](Consent-MindfulnessAccessPolicy.html)
- [Security Definition](Consent-MindfulnessSecurityDefinition.html)

### Security Implementation
- OAuth 2.0 with SMART on FHIR
- TLS 1.2+ for all communications
- Audit logging per BALP specification
- Role-based access control (RBAC)
