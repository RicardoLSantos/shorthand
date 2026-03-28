// =============================================================================
// CFM Resolution 2.454/2026 — Phase 1: ValueSets + Extensions
// Created: 2026-03-28 T1 S15
// Reference: CFM Resolution 2.454/2026 (effective August 2026)
// Gaps covered: CFM-GAP-01, CFM-GAP-03, CFM-GAP-07
// =============================================================================

// =============================================================================
// VALUE SETS
// =============================================================================

ValueSet: CFMDefinitionsVS
Id: cfm-definitions-vs
Title: "CFM 2.454 Definition Reference Codes"
Description: "Codes referencing CFM 2.454 Art. 2 definitions for AI system classification in Brazilian healthcare."
* ^status = #active
* ^experimental = false
* AgentDecisionSupportCS#ia-medica
* AgentDecisionSupportCS#sistema-apoio-decisao

ValueSet: AIAutonomyLevelVS
Id: ai-autonomy-level-vs
Title: "AI Autonomy Level ValueSet"
Description: "Levels of AI system autonomy per CFM 2.454 Art. 3 risk classification criteria."
* ^status = #active
* ^experimental = false
* AgentDecisionSupportCS#autonomy-fully-autonomous
* AgentDecisionSupportCS#autonomy-semi-autonomous
* AgentDecisionSupportCS#autonomy-assistive
* AgentDecisionSupportCS#autonomy-informational

ValueSet: AIDisclosureCategoryVS
Id: ai-disclosure-category-vs
Title: "AI Disclosure Category ValueSet"
Description: "Categories of AI-related patient disclosure events per CFM 2.454 Art. 4 and Art. 9."
* ^status = #active
* ^experimental = false
* AgentDecisionSupportCS#ai-disclosure-completed
* AgentDecisionSupportCS#patient-second-opinion-requested
* AgentDecisionSupportCS#patient-refused-ai

ValueSet: DataRetentionPolicyVS
Id: data-retention-policy-vs
Title: "Data Retention Policy ValueSet"
Description: "Data retention strategies for audit trail compliance per CFM 2.454 Art. 6."
* ^status = #active
* ^experimental = false
* AgentDecisionSupportCS#retention-automatic
* AgentDecisionSupportCS#retention-manual-review
* AgentDecisionSupportCS#retention-permanent

// =============================================================================
// EXTENSIONS
// =============================================================================

Extension: AIAutonomyLevel
Id: ai-autonomy-level
Title: "AI Autonomy Level"
Description: "Degree of autonomy of an AI system, mapped to CFM 2.454 Art. 3 risk classification."
Context: DeviceDefinition, ClinicalImpression, RiskAssessment
* value[x] only CodeableConcept
* valueCodeableConcept from AIAutonomyLevelVS (extensible)

Extension: DataRetentionPolicy
Id: data-retention-policy
Title: "Data Retention Policy"
Description: """
Data retention policy for audit records per CFM 2.454 Art. 6 traceability requirements.
Specifies retention period, regulatory basis, and deletion strategy.
"""
Context: AuditEvent, Provenance
* extension contains
    retentionPeriod 1..1 MS and
    retentionBasis 0..1 and
    deletionPolicy 1..1 MS
* extension[retentionPeriod].value[x] only Duration
* extension[retentionPeriod] ^short = "How long to retain audit records"
* extension[retentionBasis].value[x] only CodeableConcept
* extension[retentionBasis] ^short = "Regulatory basis (e.g., cfm-2454, lgpd)"
* extension[deletionPolicy].value[x] only CodeableConcept
* extension[deletionPolicy].valueCodeableConcept from DataRetentionPolicyVS (extensible)
* extension[deletionPolicy] ^short = "Deletion strategy after retention period"
