// ============================================================================
// AuditEvent AI Interaction Profile
// ============================================================================
// Date: 2026-03-05
// Purpose: AuditEvent profile for logging AI/CDSS interactions
// Regulatory: EU AI Act Art. 12 (automatic logging), Art. 14 (human oversight)
//             CFM 2.454/2026 Art. 6 (rastreabilidade)
// ============================================================================

Profile: AuditEventAIInteraction
Parent: AuditEvent
Id: audit-event-ai-interaction
Title: "Audit Event AI Interaction Profile"
Description: """
Profile for AuditEvent resources that log AI/CDSS interactions in the
lifestyle medicine workflow. Captures the complete audit trail from
AI inference execution through physician review and override decisions.
Supports EU AI Act Art. 12 (automatic logging of high-risk AI systems)
and CFM Resolution 2.454/2026 Art. 6 (traceability requirements).
"""

* ^experimental = false

// Type - always a security audit
* type 1..1 MS
* type = http://dicom.nema.org/resources/ontology/DCM#110112 "Query"

// Subtype - AI-specific event classification
* subtype 1..* MS
* subtype from AIAuditEventSubtypeVS (extensible)
  * ^short = "AI event type (inference, recommendation, review, override)"

// Action - C(reate), R(ead), U(pdate), E(xecute)
* action 1..1 MS
  * ^short = "E for inference execution, C for recommendation creation, U for override"

// Period and recorded
* period 0..1 MS
  * ^short = "Duration of the AI interaction (inference start to completion)"
* recorded 1..1 MS
  * ^short = "When this audit event was recorded"

// Outcome
* outcome 1..1 MS
  * ^short = "0=success, 4=minor failure, 8=serious failure, 12=major failure"
* outcomeDesc 0..1 MS
  * ^short = "Human-readable outcome description"

// Agent slicing - AI system + human reviewer
* agent ^slicing.discriminator.type = #pattern
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #open
* agent ^slicing.ordered = false
* agent ^slicing.description = "Slice by agent type: AI system vs human reviewer"
* agent contains
    aiSystem 1..1 MS and
    reviewer 0..1 MS

// AI System agent
* agent[aiSystem].type 1..1 MS
* agent[aiSystem].type = http://dicom.nema.org/resources/ontology/DCM#110153 "Source Role ID"
* agent[aiSystem].who 1..1 MS
* agent[aiSystem].who only Reference(Device)
  * ^short = "The AI/SLM system that performed the inference"
* agent[aiSystem].name 0..1 MS
  * ^short = "AI model name (e.g., BioMistral-7B)"
* agent[aiSystem].requestor = false

// Human reviewer agent
* agent[reviewer].type 1..1 MS
* agent[reviewer].type = http://dicom.nema.org/resources/ontology/DCM#110152 "Destination Role ID"
* agent[reviewer].who 1..1 MS
* agent[reviewer].who only Reference(Practitioner or PractitionerRole)
  * ^short = "Physician who reviewed the AI recommendation"
* agent[reviewer].requestor = true

// Source - the application/system
* source 1..1 MS
* source.observer 1..1 MS
* source.observer only Reference(Device or Organization)
  * ^short = "HEADS/Bot Saude system generating audit events"
* source.type 0..* MS

// Entity - what was audited
* entity 1..* MS
* entity.what 1..1 MS
* entity.what only Reference(Observation or ClinicalImpression or CarePlan or Task or ServiceRequest)
  * ^short = "Clinical resource involved in the AI interaction"
* entity.type 0..1 MS
* entity.role 0..1 MS
* entity.description 0..1 MS
  * ^short = "Description of the entity's role in the AI interaction"

// AI Inference Metadata extension
* extension contains
    AIInferenceMetadata named inferenceMetadata 0..1 MS

// ============================================================================
// AI Audit Event Subtype ValueSet
// ============================================================================

ValueSet: AIAuditEventSubtypeVS
Id: ai-audit-event-subtype-vs
Title: "AI Audit Event Subtype Value Set"
Description: "Subtypes of AI-related audit events for CDSS interaction logging"
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-03-05"
* AgentDecisionSupportCS#ai-inference-executed "AI Inference Executed"
* AgentDecisionSupportCS#ai-recommendation-generated "AI Recommendation Generated"
* AgentDecisionSupportCS#ai-recommendation-reviewed "AI Recommendation Reviewed"
* AgentDecisionSupportCS#ai-override-recorded "AI Override Recorded"
* AgentDecisionSupportCS#ai-consent-verified "AI Consent Verified"
