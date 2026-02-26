// AgentDecisionSupportExtensions.fsh
// Created: 2026-01-25
// Purpose: Extensions for LLM agent decision support integration
// Based on: MedAgentBench framework (Saha et al. 2026)
//
// Bibliographic References:
// - Saha2026MedLLM: Transforming Healthcare with State-of-the-Art Medical-LLMs
//   DOI: 10.32604/cmc.2025.070507 (Computers, Materials & Continua)
// - MedAgentBench: FHIR-compliant EMR simulation for LLM agent evaluation
//   Environment: FHIR R4 compliant, Tasks: retrieve patient data, order labs, write notes
//
// Gap Analysis Context:
// - Current IG lacks explicit decision support resources (PlanDefinition, Library, Task)
// - These extensions provide proof-of-concept for agent reasoning capture
// - Full implementation planned post-thesis (ServiceRequest, Task profiles)

// ============================================================================
// Agent Recommendation Extension (Complex)
// ============================================================================

Extension: AgentRecommendation
Id: agent-recommendation
Title: "Agent Recommendation Extension"
Description: "Captures LLM agent recommendation metadata including confidence score, reasoning narrative, and evidence references. Supports MedAgentBench-style evaluation where agents must explain clinical reasoning."
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* ^context[1].type = #element
* ^context[1].expression = "DiagnosticReport"
* ^context[2].type = #element
* ^context[2].expression = "RiskAssessment"
* ^context[3].type = #element
* ^context[3].expression = "Task"
* ^context[4].type = #element
* ^context[4].expression = "ServiceRequest"
* extension contains
    confidence 1..1 MS and
    interpretation 1..1 MS and
    reasoning 0..1 MS and
    evidenceReference 0..* and
    agentModel 0..1 and
    timestamp 1..1 MS
* extension[confidence].value[x] only decimal
* extension[confidence] ^short = "Agent confidence score (0.0-1.0)"
* extension[confidence] ^definition = "Numeric confidence score from the LLM agent, where 0.0 indicates no confidence and 1.0 indicates full confidence. Per Saha et al. 2026 composite formula: S = alpha*Q_text + beta*Q_expert"
* extension[interpretation].value[x] only CodeableConcept
* extension[interpretation].valueCodeableConcept from AgentInterpretationVS (required)
* extension[interpretation] ^short = "Agent interpretation category"
* extension[interpretation] ^definition = "Standardized code indicating the agent's clinical interpretation or recommended action"
* extension[reasoning].value[x] only markdown
* extension[reasoning] ^short = "Agent reasoning narrative"
* extension[reasoning] ^definition = "Human-readable explanation of the agent's reasoning process, supporting explainability requirements (EU AI Act, FDA guidance)"
* extension[evidenceReference].value[x] only Reference
* extension[evidenceReference] ^short = "Evidence supporting recommendation"
* extension[evidenceReference] ^definition = "References to Observations, Documents, or other resources that support this recommendation"
* extension[agentModel].value[x] only string
* extension[agentModel] ^short = "LLM model identifier"
* extension[agentModel] ^definition = "Identifier of the LLM model used (e.g., 'BioMistral-7B', 'GPT-4-Med', 'Mistral-7B-Instruct-v0.2')"
* extension[timestamp].value[x] only dateTime
* extension[timestamp] ^short = "Recommendation timestamp"
* extension[timestamp] ^definition = "When the agent generated this recommendation"
ValueSet: AgentInterpretationVS
Id: agent-interpretation-vs
Title: "Agent Interpretation ValueSet"
Description: "ValueSet for LLM agent clinical interpretations"
* ^experimental = false
* LifestyleMedicineTemporaryCS#agent-interpretation-high-risk "High Risk"
* LifestyleMedicineTemporaryCS#agent-interpretation-moderate-risk "Moderate Risk"
* LifestyleMedicineTemporaryCS#agent-interpretation-low-risk "Low Risk"
* LifestyleMedicineTemporaryCS#minimal-risk "Minimal Risk"
* LifestyleMedicineTemporaryCS#escalate-clinician "Escalate to Clinician"
* LifestyleMedicineTemporaryCS#agent-interpretation-schedule-followup "Schedule Follow-up"
* LifestyleMedicineTemporaryCS#continue-monitoring "Continue Monitoring"
* LifestyleMedicineTemporaryCS#agent-interpretation-lifestyle-intervention "Lifestyle Intervention"
ValueSet: AgentConfidenceLevelVS
Id: agent-confidence-level-vs
Title: "Agent Confidence Level ValueSet"
Description: "ValueSet for categorical agent confidence levels"
* ^experimental = false
* LifestyleMedicineTemporaryCS#agent-confidence-very-high "Very High Confidence"
* LifestyleMedicineTemporaryCS#agent-confidence-high "High Confidence"
* LifestyleMedicineTemporaryCS#agent-confidence-moderate "Moderate Confidence"
* LifestyleMedicineTemporaryCS#agent-confidence-low "Low Confidence"
* LifestyleMedicineTemporaryCS#agent-confidence-very-low "Very Low Confidence"

// ============================================================================
// Agent Evidence Quality Extension
// ============================================================================

Extension: AgentEvidenceQuality
Id: agent-evidence-quality
Title: "Agent Evidence Quality Extension"
Description: "Indicates the quality and completeness of evidence available to the agent when making a recommendation."
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* ^context[1].type = #element
* ^context[1].expression = "Task"
* ^context[2].type = #element
* ^context[2].expression = "ServiceRequest"
* extension contains
    dataCompleteness 1..1 MS and
    temporalCoverage 0..1 and
    dataGaps 0..* and
    dataQualityScore 0..1
* extension[dataCompleteness].value[x] only CodeableConcept
* extension[dataCompleteness].valueCodeableConcept from AgentDataCompletenessVS (required)
* extension[dataCompleteness] ^short = "Data completeness assessment"
* extension[temporalCoverage].value[x] only Period
* extension[temporalCoverage] ^short = "Time period of available data"
* extension[dataGaps].value[x] only string
* extension[dataGaps] ^short = "Identified data gaps"
* extension[dataQualityScore].value[x] only decimal
* extension[dataQualityScore] ^short = "Overall data quality score (0-1)"
ValueSet: AgentDataCompletenessVS
Id: agent-data-completeness-vs
Title: "Agent Data Completeness ValueSet"
Description: "Data completeness assessment values for agent analysis ranging from complete to insufficient"
* ^experimental = false
* LifestyleMedicineTemporaryCS#agent-completeness-complete "Complete"
* LifestyleMedicineTemporaryCS#mostly-complete "Mostly Complete"
* LifestyleMedicineTemporaryCS#partial "Partial"
* LifestyleMedicineTemporaryCS#sparse "Sparse"
* LifestyleMedicineTemporaryCS#agent-completeness-insufficient "Insufficient"

// ============================================================================
// Agent Action Tracking Extension
// ============================================================================

Extension: AgentActionStatus
Id: agent-action-status
Title: "Agent Action Status Extension"
Description: "Tracks the status of agent-recommended actions in clinical workflow. Supports MedAgentBench task completion evaluation."
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* ^context[1].type = #element
* ^context[1].expression = "Task"
* extension contains
    actionCode 1..1 MS and
    actionStatus 1..1 MS and
    reviewedBy 0..1 and
    reviewedAt 0..1 and
    outcomeNote 0..1
* extension[actionCode].value[x] only CodeableConcept
* extension[actionCode].valueCodeableConcept from AgentInterpretationVS (required)
* extension[actionCode] ^short = "The recommended action"
* extension[actionStatus].value[x] only code
* extension[actionStatus].valueCode from AgentActionStatusVS (required)
* extension[actionStatus] ^short = "Current status of the action"
* extension[reviewedBy].value[x] only Reference(Practitioner or PractitionerRole)
* extension[reviewedBy] ^short = "Clinician who reviewed the recommendation"
* extension[reviewedAt].value[x] only dateTime
* extension[reviewedAt] ^short = "When the recommendation was reviewed"
* extension[outcomeNote].value[x] only string
* extension[outcomeNote] ^short = "Outcome or decision note"
ValueSet: AgentActionStatusVS
Id: agent-action-status-vs
Title: "Agent Action Status ValueSet"
Description: "Status codes for agent-recommended actions including pending, accepted, rejected, and completed"
* ^experimental = false
* LifestyleMedicineTemporaryCS#pending "Pending"
* LifestyleMedicineTemporaryCS#accepted "Accepted"
* LifestyleMedicineTemporaryCS#rejected "Rejected"
* LifestyleMedicineTemporaryCS#modified "Modified"
* LifestyleMedicineTemporaryCS#agent-action-status-completed "Completed"
* LifestyleMedicineTemporaryCS#expired "Expired"
