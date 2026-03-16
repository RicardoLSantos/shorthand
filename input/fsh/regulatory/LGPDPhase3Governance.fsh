// =============================================================================
// LGPD PHASE 3 — Data Governance Extensions + Incident Notification
// =============================================================================
// Date: 2026-03-16
// Purpose: LGPD Art. 6 (necessity, non-discrimination), Art. 46 (security),
//          Art. 48 (incident notification to ANPD and data subjects)
// Context: PLAN_REGULATORY_LGPD_20260305.md — Phase 3
// Dependencies: AppLogicCS (Phase 3 codes), AgentDecisionSupportCS
// =============================================================================

// ============================================================================
// Extension: DataMinimizationScope
// LGPD Art. 6-III: "limitação do tratamento ao mínimo necessário"
// Cross-jurisdictional: GDPR Art. 5(1)(c), HIPAA §164.502(b)
// ============================================================================
Extension: DataMinimizationScope
Id: data-minimization-scope
Title: "Data Minimization Scope"
Description: """
Indicates the data minimization justification for collecting this data element.

LGPD Art. 6-III requires that personal data processing be limited to the minimum
necessary for the stated purpose. This extension documents WHY specific data
categories are collected and which legal basis supports the necessity.

Applies to:
- Consent: Documents which data categories the subject consented to
- CarePlan: Justifies data needs for each intervention
- PlanDefinition: Specifies data requirements for protocol steps

Cross-jurisdictional applicability:
- GDPR Art. 5(1)(c): Data minimisation principle
- HIPAA §164.502(b): Minimum necessary standard
"""
* ^context[0].type = #element
* ^context[0].expression = "Consent"
* ^context[1].type = #element
* ^context[1].expression = "CarePlan"
* ^context[2].type = #element
* ^context[2].expression = "PlanDefinition"
* value[x] only CodeableConcept
* valueCodeableConcept from DataMinimizationScopeVS (required)

// ============================================================================
// Extension: BiasDetectionFlag
// LGPD Art. 6-IV: "não discriminação" (non-discrimination principle)
// EU AI Act Art. 10 (data governance) + Art. 15 (accuracy, robustness)
// ============================================================================
Extension: BiasDetectionFlag
Id: bias-detection-flag
Title: "Bias Detection Flag"
Description: """
Flags when AI/ML processing detects potential bias in clinical outputs.

LGPD Art. 6-IV prohibits discriminatory data processing. When AI models are used
for clinical decision support, bias detection results should be documented to
ensure transparency and accountability.

LGPD Art. 20 further grants the right to request review of automated decisions,
making bias documentation essential for regulatory compliance.

Applies to:
- ClinicalImpression: AI-generated clinical assessments
- RiskAssessment: AI risk stratification outputs
- Observation: AI-derived clinical observations

Cross-jurisdictional applicability:
- EU AI Act Art. 10: Data governance for training datasets
- EU AI Act Art. 15: Accuracy, robustness, cybersecurity requirements
"""
* ^context[0].type = #element
* ^context[0].expression = "ClinicalImpression"
* ^context[1].type = #element
* ^context[1].expression = "RiskAssessment"
* ^context[2].type = #element
* ^context[2].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from BiasTypeVS (required)

// ============================================================================
// Profile: CommunicationSecurityIncident
// LGPD Art. 48: Communication of security incidents to ANPD and data subjects
// LGPD Art. 46: Security measures obligation
// ============================================================================
Profile: CommunicationSecurityIncident
Parent: Communication
Id: communication-security-incident
Title: "LGPD Security Incident Notification"
Description: """
Communication profile for LGPD security incident notification (Art. 48).

When a security incident occurs that may cause significant risk or damage to data
subjects, the controller must communicate to:
1. ANPD (Autoridade Nacional de Proteção de Dados) — within a reasonable time (Art. 48, §1)
2. Affected data subjects — when the incident may cause relevant damage (Art. 48)

The notification must include (Art. 48, §1):
- (I) Description of the nature of the affected personal data
- (II) Information about the affected data subjects
- (III) Technical and security measures used for data protection
- (IV) Risks related to the incident
- (V) Reasons for delay, if notification was not immediate
- (VI) Measures adopted or to be adopted to reverse or mitigate the effects

Cross-jurisdictional: GDPR Art. 33-34 (72h notification), HIPAA §164.408 (60 days)
"""
* status MS
* status = #completed
* category 1..1 MS
* category from SecurityIncidentTypeVS (required)
* category ^short = "Type of security incident (breach, unauthorized access, etc.)"
* subject 0..1 MS
* subject only Reference(Patient)
* subject ^short = "Affected data subject(s), if identifiable"
* sender 1..1 MS
* sender only Reference(Organization)
* sender ^short = "Controller organization reporting the incident (Art. 48)"
* recipient 1..* MS
* recipient ^short = "ANPD and/or affected data subjects"
* sent 1..1 MS
* sent ^short = "Date and time of notification"
* payload 1..* MS
* payload ^short = "Incident details per Art. 48, §1 (description, measures, risks)"
* payload.content[x] only string
* extension contains
    DataAnonymizationStatus named dataImpactLevel 0..1 MS

// ============================================================================
// ValueSets
// ============================================================================
ValueSet: DataMinimizationScopeVS
Id: data-minimization-scope-vs
Title: "Data Minimization Scope"
Description: """
Justification categories for data collection under the data minimization principle.
LGPD Art. 6-III, GDPR Art. 5(1)(c), HIPAA §164.502(b).
"""
* ^experimental = false
* ^status = #active
* AppLogicCS#data-minimization-minimum-necessary "Minimum Necessary"
* AppLogicCS#data-minimization-research-essential "Research Essential"
* AppLogicCS#data-minimization-treatment-required "Treatment Required"
* AppLogicCS#data-minimization-legal-mandated "Legally Mandated"

ValueSet: BiasTypeVS
Id: bias-type-vs
Title: "AI Bias Detection Type"
Description: """
Types of bias that may be detected in AI/ML clinical outputs.
LGPD Art. 6-IV (non-discrimination), EU AI Act Art. 10 (data governance).
"""
* ^experimental = false
* ^status = #active
* AppLogicCS#bias-none "No Bias Detected"
* AppLogicCS#bias-demographic "Demographic Bias"
* AppLogicCS#bias-data "Data Bias"
* AppLogicCS#bias-algorithmic "Algorithmic Bias"

ValueSet: SecurityIncidentTypeVS
Id: security-incident-type-vs
Title: "Security Incident Type"
Description: """
Types of security incidents requiring notification under LGPD Art. 48.
Cross-jurisdictional: GDPR Art. 33-34, HIPAA §164.408.
"""
* ^experimental = false
* ^status = #active
* AppLogicCS#security-incident-breach "Data Breach"
* AppLogicCS#security-incident-unauthorized-access "Unauthorized Access"
* AppLogicCS#security-incident-data-loss "Data Loss"

ValueSet: DataAnonymizationMethodVS
Id: data-anonymization-method-vs
Title: "Data Anonymization Method"
Description: """
Anonymization and de-identification techniques applicable to health data.

LGPD Art. 12 defines anonymized data as that which cannot reasonably be used to
identify a natural person, considering available means at the time of processing.
LGPD Art. 16-II requires anonymization of data upon termination of processing.

These methods range from statistical (k-anonymity, differential privacy) to
field-level (generalization, suppression) to regulatory-defined (HIPAA Safe Harbor).

Cross-jurisdictional applicability:
- GDPR Recital 26: Anonymisation renders re-identification unreasonably likely
- HIPAA §164.514: Safe Harbor (18 identifiers) or Expert Determination
"""
* ^experimental = false
* ^status = #active
* AppLogicCS#method-k-anonymity "k-Anonymity"
* AppLogicCS#method-differential-privacy "Differential Privacy"
* AppLogicCS#method-generalization "Generalization"
* AppLogicCS#method-suppression "Suppression"
* AppLogicCS#method-safe-harbor "Safe Harbor Method"
