# CFM Resolution 2.454/2026 Compliance

This page documents how the iOS Lifestyle Medicine FHIR IG addresses the requirements of **CFM Resolution 2.454/2026** — the Brazilian Federal Council of Medicine regulation on artificial intelligence in medical practice, effective August 2026.

## Overview

CFM 2.454/2026 establishes requirements for AI systems used in medical practice in Brazil, covering risk classification, transparency, traceability, physician autonomy, patient rights, and institutional governance. This IG provides FHIR artifacts that enable structured documentation of compliance with each article.

## Article-by-Article Compliance Mapping

| Article | Requirement | FHIR Artifact | Status |
|:-------:|-------------|---------------|:------:|
| **Art. 1** | Scope — applies to all AI in medical practice | DeviceDefinitionSLM, AgentDecisionSupportCS | Covered |
| **Art. 2** | Definitions (IA Médica, Sistema de Apoio à Decisão) | CFMDefinitionsVS, AgentDecisionSupportCS codes | Covered |
| **Art. 3** | Risk Classification (4 levels) | AIRiskClassificationVS + AIAutonomyLevel extension | Covered |
| **Art. 4** | Transparency — patient notification of AI use | CommunicationAIDisclosure profile | Covered |
| **Art. 5** | Data Protection (LGPD compliance) | See [Data Protection Policies](data-protection-policies.html) | Covered |
| **Art. 6** | Traceability — audit trail and logging | AuditEventAIInteraction + DataRetentionPolicy extension | Covered |
| **Art. 7** | Physician Autonomy — override rights | AIOverrideWorkflowBundle, PhysicianOverrideReasonVS | Covered |
| **Art. 8** | Institutional Governance — AI Commission | OrganizationAIGovernance, PractitionerRoleAIDirector | Covered |
| **Art. 9** | Patient Rights — consent, second opinion, refusal | AIDisclosureCategoryVS, Consent (deny provision) | Covered |
| **Art. 10** | Liability — diligent use documentation | AuditEventAIInteraction, ClinicalImpressionAIAssessment | Covered |
| **Art. 11** | AI Communication Prohibition | CommunicationAIDisclosure (sender = Practitioner only) | Covered |
| **Art. 12** | Training — physician AI competency | Implementation guidance (organizational) | N/A |
| **Art. 13** | Transitional — 180-day window (Aug 2026) | Timeline tracking | N/A |

## Key Profiles

### CommunicationAIDisclosure (Art. 4, 9, 11)

Documents AI transparency notifications to patients. The `sender` element is constrained to `Practitioner` or `PractitionerRole` — never `Device` — enforcing Art. 11 prohibition against AI communicating diagnoses directly to patients.

### OrganizationAIGovernance (Art. 8)

Represents the institutional AI Commission required by Art. 8, including the Technical Director designation and governance contacts.

### PractitionerRoleAIDirector (Art. 8)

Designates the physician responsible for AI governance (Responsável Técnico de IA) within the institution.

## Extensions

### AIAutonomyLevel

Classifies the degree of AI system autonomy, mapped to Art. 3 risk levels:
- **Fully Autonomous** → Risco Inaceitável (prohibited)
- **Semi-Autonomous** → Alto Risco (requires enhanced oversight)
- **Assistive** → Médio Risco (physician approval required)
- **Informational** → Baixo Risco (information only)

### DataRetentionPolicy

Specifies audit record retention per Art. 6 traceability requirements, including retention period, regulatory basis, and deletion strategy.

## Cross-Jurisdictional Alignment

CFM 2.454 shares concepts with other regulatory frameworks implemented in this IG:

| Concept | CFM 2.454 | LGPD | GDPR | EU AI Act |
|---------|:---------:|:----:|:----:|:---------:|
| Risk classification | Art. 3 | — | — | Art. 6 |
| Transparency | Art. 4 | Art. 6 | Art. 13-14 | Art. 13 |
| Data protection | Art. 5 | Full | Full | Art. 10 |
| Audit trail | Art. 6 | Art. 37 | Art. 30 | Art. 12 |
| Human oversight | Art. 7 | — | — | Art. 14 |
| Governance | Art. 8 | Art. 41 | Art. 37 | Art. 26 |
| Patient rights | Art. 9 | Art. 18 | Art. 15-22 | Art. 86 |

Shared artifacts (DataAnonymizationStatus, DataMinimizationScope) are documented in the [Data Protection Policies](data-protection-policies.html) page.

---

*CFM 2.454/2026 implementation: Phase 1-2 complete (codes, extensions, profiles). Phase 3 (examples) included. Effective date: August 2026.*
