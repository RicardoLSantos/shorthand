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

// ============================================================================
// Agent Interpretation CodeSystem
// ============================================================================

CodeSystem: AgentInterpretationCS
Id: agent-interpretation-cs
Title: "Agent Interpretation CodeSystem"
Description: "Codes for LLM agent clinical interpretations and recommended actions. Aligned with MedAgentBench evaluation framework and TRIPOD-LLM quality dimensions."
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
// Risk stratification codes
* #high-risk "High Risk" "Agent identifies high clinical risk requiring immediate attention"
* #moderate-risk "Moderate Risk" "Agent identifies moderate risk requiring monitoring"
* #low-risk "Low Risk" "Agent identifies low risk with routine follow-up"
* #minimal-risk "Minimal Risk" "Agent identifies minimal/no clinical concern"
// Action recommendation codes
* #escalate-clinician "Escalate to Clinician" "Agent recommends immediate clinician review"
* #schedule-followup "Schedule Follow-up" "Agent recommends scheduling follow-up assessment"
* #continue-monitoring "Continue Monitoring" "Agent recommends continued monitoring without intervention"
* #lifestyle-intervention "Lifestyle Intervention" "Agent recommends lifestyle modification intervention"
* #medication-review "Medication Review" "Agent recommends medication review"
// Confidence/uncertainty codes
* #uncertain "Uncertain" "Agent indicates uncertainty requiring human judgment"
* #insufficient-data "Insufficient Data" "Agent identifies insufficient data for recommendation"
* #conflicting-evidence "Conflicting Evidence" "Agent identifies conflicting evidence in available data"
// Workflow codes
* #alert-generated "Alert Generated" "Agent has generated a clinical alert"
* #documentation-needed "Documentation Needed" "Agent recommends additional documentation"
* #patient-education "Patient Education" "Agent recommends patient education materials"

// ============================================================================
// Agent Interpretation ValueSet
// ============================================================================

ValueSet: AgentInterpretationVS
Id: agent-interpretation-vs
Title: "Agent Interpretation ValueSet"
Description: "ValueSet for LLM agent clinical interpretations"
* ^experimental = false
* include codes from system AgentInterpretationCS

// ============================================================================
// Agent Confidence Level CodeSystem (Categorical)
// ============================================================================

CodeSystem: AgentConfidenceLevelCS
Id: agent-confidence-level-cs
Title: "Agent Confidence Level CodeSystem"
Description: "Categorical confidence levels for agent recommendations. Maps numeric confidence (0-1) to clinical workflow categories."
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #very-high "Very High Confidence" "Confidence >= 0.9: Agent highly confident, minimal human oversight needed"
* #high "High Confidence" "Confidence 0.75-0.89: Agent confident, routine review recommended"
* #moderate "Moderate Confidence" "Confidence 0.5-0.74: Moderate confidence, clinician review required"
* #low "Low Confidence" "Confidence 0.25-0.49: Low confidence, clinician decision required"
* #very-low "Very Low Confidence" "Confidence < 0.25: Very low confidence, treat as informational only"

ValueSet: AgentConfidenceLevelVS
Id: agent-confidence-level-vs
Title: "Agent Confidence Level ValueSet"
Description: "ValueSet for categorical agent confidence levels"
* ^experimental = false
* include codes from system AgentConfidenceLevelCS

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

CodeSystem: AgentDataCompletenessCS
Id: agent-data-completeness-cs
Title: "Agent Data Completeness CodeSystem"
Description: "Codes for agent assessment of available data completeness"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #complete "Complete" "All expected data elements available"
* #mostly-complete "Mostly Complete" "Most data elements available (>75%)"
* #partial "Partial" "Some data elements available (25-75%)"
* #sparse "Sparse" "Limited data elements available (<25%)"
* #insufficient "Insufficient" "Insufficient data for reliable analysis"

ValueSet: AgentDataCompletenessVS
Id: agent-data-completeness-vs
Title: "Agent Data Completeness ValueSet"
* ^experimental = false
* include codes from system AgentDataCompletenessCS

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

CodeSystem: AgentActionStatusCS
Id: agent-action-status-cs
Title: "Agent Action Status CodeSystem"
Description: "Status codes for agent-recommended actions"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #pending "Pending" "Recommendation pending review"
* #accepted "Accepted" "Recommendation accepted by clinician"
* #rejected "Rejected" "Recommendation rejected by clinician"
* #modified "Modified" "Recommendation modified by clinician"
* #completed "Completed" "Recommended action completed"
* #expired "Expired" "Recommendation expired without action"

ValueSet: AgentActionStatusVS
Id: agent-action-status-vs
Title: "Agent Action Status ValueSet"
* ^experimental = false
* include codes from system AgentActionStatusCS
