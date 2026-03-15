// =============================================================================
// LGPD FOUNDATION — Phase 1 (Lei 13.709/2018)
// =============================================================================
// Date: 2026-03-15
// Purpose: Foundation artifacts for Brazilian LGPD compliance in FHIR IG.
//          Phase 1 covers: processing purpose ValueSet, AI consent ValueSet,
//          and DataAnonymizationStatus extension (shared with GDPR/HIPAA).
// Context: LGPD regulatory plan (knowledge_base/plans/PLAN_REGULATORY_LGPD_20260305.md)
//          Gaps addressed: LGPD-GAP-04, LGPD-GAP-09, LGPD-GAP-03
// =============================================================================

// ============================================================================
// ValueSet: LGPD Data Processing Purpose
// LGPD Art. 7 (legal bases) + Art. 11 (sensitive data legal bases)
// ============================================================================
ValueSet: LGPDProcessingPurposeVS
Id: lgpd-processing-purpose-vs
Title: "LGPD Data Processing Purpose"
Description: """
Legal bases for personal data processing under Brazil's Lei Geral de Proteção de Dados (LGPD, Lei 13.709/2018).

Art. 7 enumerates 10 legal bases for processing personal data.
Art. 11 restricts sensitive data (including health) to explicit consent or specific exceptions.

For health AI applications, the most common bases are:
- Consent (Art. 7-I, Art. 8, Art. 11-I) — requires explicit, specific, informed consent
- Health protection (Art. 7-VIII, Art. 11-II-f) — by healthcare professional
- Research (Art. 7-IV, Art. 11-II-c) — with anonymization when possible
"""
* ^experimental = false
* ^status = #active
* AppLogicCS#lgpd-consent "Consent-Based Processing"
* AppLogicCS#lgpd-legal-obligation "Legal Obligation"
* AppLogicCS#lgpd-research "Research Processing"
* AppLogicCS#lgpd-health-protection "Health Protection"
* AppLogicCS#lgpd-vital-interest "Vital Interest"
* AppLogicCS#lgpd-legitimate-interest "Legitimate Interest"
* AppLogicCS#lgpd-public-interest "Public Interest"

// ============================================================================
// ValueSet: AI Consent Categories
// LGPD Art. 8 (consent requirements) + Art. 11 (sensitive data) + Art. 20 (automated decisions)
// Shared applicability: GDPR Art. 22, EU AI Act Art. 14
// ============================================================================
ValueSet: AIConsentCategoryVS
Id: ai-consent-category-vs
Title: "AI Consent Category"
Description: """
Consent categories for AI-assisted healthcare processing, based on LGPD granularity requirements.

LGPD Art. 8 requires that consent be specific and informed. When AI is involved in health
data processing, three distinct consent categories apply:
- General AI consent (non-sensitive data processing)
- Health-specific AI consent (sensitive data, requires explicit consent per Art. 11)
- Automated decision consent (right to review per Art. 20)

These categories enable granular consent management in the Consent resource,
supporting opt-in/opt-out at each processing level.
"""
* ^experimental = false
* ^status = #active
* AgentDecisionSupportCS#ai-consent-general "AI General Consent"
* AgentDecisionSupportCS#ai-consent-health "AI Health Data Consent"
* AgentDecisionSupportCS#ai-consent-automated-decision "AI Automated Decision Consent"

// ============================================================================
// ValueSet: Data Anonymization Status
// Cross-jurisdictional: LGPD Art. 5/12, GDPR Art. 4(5)/Rec.26, HIPAA §164.514
// ============================================================================
ValueSet: DataAnonymizationStatusVS
Id: data-anonymization-status-vs
Title: "Data Anonymization Status"
Description: """
Levels of data anonymization/pseudonymization for cross-jurisdictional compliance.

Each jurisdiction defines these differently:
- LGPD (Brazil): 'anonimização' (Art. 5-III) — anonymized data is not personal data (Art. 12)
- GDPR (EU): 'pseudonymisation' (Art. 4(5)) — still personal data; anonymisation (Recital 26) — not personal data
- HIPAA (US): 'de-identification' via Safe Harbor (18 identifiers) or Expert Determination (§164.514)

This ValueSet provides a unified vocabulary across jurisdictions.
"""
* ^experimental = false
* ^status = #active
* AppLogicCS#data-identified "Identified"
* AppLogicCS#data-pseudonymized "Pseudonymized"
* AppLogicCS#data-anonymized "Anonymized"
* AppLogicCS#data-de-identified "De-identified"

// ============================================================================
// Extension: Data Anonymization Status
// Applicable to: Patient, Observation, Bundle (any resource with personal data)
// Shared: LGPD/GDPR/HIPAA
// ============================================================================
Extension: DataAnonymizationStatus
Id: data-anonymization-status
Title: "Data Anonymization Status"
Description: """
Indicates the anonymization/pseudonymization level of the data in this resource.

Used for:
- LGPD compliance: Art. 12 exempts anonymized data from LGPD scope
- GDPR compliance: Pseudonymized data has different obligations than identified data
- HIPAA compliance: De-identified data (§164.514) exempt from Privacy Rule
- Research data governance: Track anonymization through data pipelines

This extension should be applied at the Bundle level for batch operations
or at individual resource level for granular tracking.
"""
* ^context[0].type = #element
* ^context[0].expression = "Patient"
* ^context[1].type = #element
* ^context[1].expression = "Bundle"
* ^context[2].type = #element
* ^context[2].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from DataAnonymizationStatusVS (required)
