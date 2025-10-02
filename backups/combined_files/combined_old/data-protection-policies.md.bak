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
