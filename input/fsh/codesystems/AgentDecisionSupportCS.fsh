// =============================================================================
// AGENT DECISION SUPPORT CODE SYSTEM
// =============================================================================
// Date: 2026-02-27
// Purpose: Operational codes for the CDSS (Clinical Decision Support System)
//          agent's internal state, interpretation categories, task workflow,
//          and metacognition metadata.
// Context: Relocated from LifestyleMedicineTemporaryCS orphan analysis.
//          These codes describe HOW the agent thinks and acts, not clinical
//          concepts. They are permanent app-level operational codes.
// Reference: ORPHAN_CODES_659_ANALYSIS.md
// Note: Where FHIR equivalents exist (e.g., task-status), annotations are
//       provided. ConceptMaps should link these to FHIR core where applicable.
// =============================================================================

CodeSystem: AgentDecisionSupportCS
Id: agent-decision-support-cs
Title: "Agent Decision Support Codes"
Description: """
Operational codes for the iOS Lifestyle Medicine CDSS agent covering:
- Action status (pending, accepted, rejected, modified)
- Data completeness assessment
- Confidence levels (quantified thresholds)
- Clinical interpretation categories
- Reason codes for agent decisions
- Task business status (workflow states)
- Task status reasons
- Task types (review, order, document, lifestyle)
- Decision topics (risk domains, monitoring categories)

These are CDSS operational metadata, not clinical terminology.
FHIR equivalents are noted in comments where they exist
(e.g., FHIR task-status for workflow codes).
"""
* ^status = #active
* ^experimental = false
* ^content = #complete
* ^version = "1.0.0"
* ^date = "2026-02-27"
* ^caseSensitive = true

// ============================================================================
// ACTION STATUS (6 codes)
// FHIR coverage: Partial overlap with http://hl7.org/fhir/task-status
// ============================================================================
* #pending "Pending" "Recommendation pending review"
  // FHIR task-status: #requested (broader)
* #accepted "Accepted" "Recommendation accepted by clinician"
  // FHIR task-status: #accepted
* #rejected "Rejected" "Recommendation rejected by clinician"
  // FHIR task-status: #rejected
* #modified "Modified" "Recommendation modified by clinician"
  // No FHIR exact: closest = #accepted + modification note
* #agent-action-status-completed "Completed" "Recommended action completed"
  // Renamed from AgentActionStatusCS#completed (collision resolution)
  // FHIR task-status: #completed
* #expired "Expired" "Recommendation expired without action"
  // FHIR task-status: #cancelled (broader)

// ============================================================================
// DATA COMPLETENESS (5 codes)
// FHIR coverage: No standard equivalent — CDSS-specific quality assessment
// ============================================================================
* #agent-completeness-complete "Complete" "All expected data elements available"
  // Renamed from AgentDataCompletenessCS#complete (collision resolution)
* #mostly-complete "Mostly Complete" "Most data elements available (>75%)"
* #partial "Partial" "Some data elements available (25-75%)"
* #sparse "Sparse" "Limited data elements available (<25%)"
* #agent-completeness-insufficient "Insufficient" "Insufficient data for reliable analysis"
  // Renamed from AgentDataCompletenessCS#insufficient (collision resolution)

// ============================================================================
// CONFIDENCE LEVELS (5 codes)
// FHIR coverage: No standard — agent-specific quantified confidence
// ============================================================================
* #agent-confidence-very-high "Very High Confidence" "Confidence >= 0.9: Agent highly confident, minimal human oversight needed"
  // Renamed from AgentConfidenceLevelCS#very-high (collision resolution)
* #agent-confidence-high "High Confidence" "Confidence 0.75-0.89: Agent confident, routine review recommended"
  // Renamed from AgentConfidenceLevelCS#high (collision resolution)
* #agent-confidence-moderate "Moderate Confidence" "Confidence 0.5-0.74: Moderate confidence, clinician review required"
  // Renamed from AgentConfidenceLevelCS#moderate (collision resolution)
* #agent-confidence-low "Low Confidence" "Confidence 0.25-0.49: Low confidence, clinician decision required"
  // Renamed from AgentConfidenceLevelCS#low (collision resolution)
* #agent-confidence-very-low "Very Low Confidence" "Confidence < 0.25: Very low confidence, treat as informational only"
  // Renamed from AgentConfidenceLevelCS#very-low (collision resolution)

// ============================================================================
// INTERPRETATION CATEGORIES (15 codes)
// FHIR coverage: Partial overlap with ObservationInterpretation (risk levels)
// ============================================================================
* #agent-interpretation-high-risk "High Risk" "Agent identifies high clinical risk requiring immediate attention"
  // Renamed from AgentInterpretationCS#high-risk (collision resolution)
  // FHIR ObservationInterpretation: HH (critical high) — broader
* #agent-interpretation-moderate-risk "Moderate Risk" "Agent identifies moderate risk requiring monitoring"
  // Renamed from AgentInterpretationCS#moderate-risk (collision resolution)
  // FHIR ObservationInterpretation: H (high) — broader
* #agent-interpretation-low-risk "Low Risk" "Agent identifies low risk with routine follow-up"
  // Renamed from AgentInterpretationCS#low-risk (collision resolution)
  // FHIR ObservationInterpretation: N (normal) — broader
* #minimal-risk "Minimal Risk" "Agent identifies minimal/no clinical concern"
* #escalate-clinician "Escalate to Clinician" "Agent recommends immediate clinician review"
* #agent-interpretation-schedule-followup "Schedule Follow-up" "Agent recommends scheduling follow-up assessment"
  // Renamed from AgentInterpretationCS#schedule-followup (collision resolution)
* #continue-monitoring "Continue Monitoring" "Agent recommends continued monitoring without intervention"
* #agent-interpretation-lifestyle-intervention "Lifestyle Intervention" "Agent recommends lifestyle modification intervention"
  // Renamed from AgentInterpretationCS#lifestyle-intervention (collision resolution)
* #medication-review "Medication Review" "Agent recommends medication review"
  // Note: Different from SNOMED 1099461000000101 — this is the agent's INTERPRETATION, not the clinical procedure
* #agent-interpretation-uncertain "Uncertain" "Agent indicates uncertainty requiring human judgment"
  // Renamed from AgentInterpretationCS#uncertain (collision resolution)
* #insufficient-data "Insufficient Data" "Agent identifies insufficient data for recommendation"
* #conflicting-evidence "Conflicting Evidence" "Agent identifies conflicting evidence in available data"
* #alert-generated "Alert Generated" "Agent has generated a clinical alert"
* #documentation-needed "Documentation Needed" "Agent recommends additional documentation"
* #agent-interpretation-patient-education "Patient Education" "Agent recommends patient education materials"
  // Renamed from AgentInterpretationCS#patient-education (collision resolution)

// ============================================================================
// REASON CODES (9 codes)
// FHIR coverage: No standard — agent-specific decision reasoning
// ============================================================================
* #abnormal-value "Abnormal Value" "Observation value outside normal range"
* #concerning-trend "Concerning Trend" "Concerning trend in longitudinal data"
* #risk-threshold "Risk Threshold Exceeded" "Risk score exceeded threshold"
* #missing-data "Missing Data" "Required data missing for assessment"
* #routine-followup "Routine Follow-up" "Scheduled routine follow-up"
* #agent-reason-preventive-care "Preventive Care" "Preventive care recommendation"
  // Renamed from AgentReasonCodeCS#preventive-care (collision resolution)
* #lifestyle-opportunity "Lifestyle Opportunity" "Opportunity for lifestyle improvement"
* #medication-interaction "Medication Interaction" "Potential medication interaction"
* #compliance-concern "Compliance Concern" "Treatment compliance concern"

// ============================================================================
// TASK BUSINESS STATUS (7 codes)
// FHIR coverage: Maps to http://hl7.org/fhir/task-status (partial)
// ============================================================================
* #awaiting-review "Awaiting Review" "Task pending clinician review"
  // FHIR task-status: #requested
* #under-review "Under Review" "Clinician actively reviewing"
  // FHIR task-status: #in-progress
* #approved "Approved" "Clinician approved agent recommendation"
  // FHIR task-status: #accepted
* #modified-approved "Modified and Approved" "Clinician modified and approved"
  // No FHIR exact: #accepted + modification note
* #declined "Declined" "Clinician declined recommendation"
  // FHIR task-status: #rejected
* #deferred "Deferred" "Review deferred to later"
  // FHIR task-status: #on-hold
* #escalated "Escalated" "Escalated to senior clinician"
  // No FHIR exact: workflow-specific

// ============================================================================
// TASK STATUS REASONS (8 codes)
// FHIR coverage: No standard — agent-specific status change reasons
// ============================================================================
* #clinician-approved "Clinician Approved" "Clinician reviewed and approved"
* #clinician-rejected "Clinician Rejected" "Clinician reviewed and rejected"
* #insufficient-evidence "Insufficient Evidence" "Rejected due to insufficient evidence"
* #clinical-override "Clinical Override" "Clinician exercised clinical judgment override"
* #patient-declined "Patient Declined" "Patient declined recommended intervention"
* #resources-unavailable "Resources Unavailable" "Required resources not available"
* #superseded "Superseded" "Replaced by newer recommendation"
* #completed-automatically "Completed Automatically" "Task auto-completed by system"

// ============================================================================
// TASK TYPES (15 codes)
// FHIR coverage: No standard — agent-specific task categorisation
// ============================================================================
* #review-observation "Review Observation" "Agent requests clinician review of an observation"
* #review-trend "Review Trend" "Agent requests clinician review of a data trend"
* #review-alert "Review Alert" "Agent requests clinician review of an alert condition"
* #order-lab "Order Laboratory Test" "Agent recommends laboratory testing"
* #order-imaging "Order Imaging" "Agent recommends imaging study"
* #order-referral "Order Referral" "Agent recommends specialist referral"
* #document-assessment "Document Assessment" "Agent requests clinical documentation"
* #document-care-plan "Update Care Plan" "Agent recommends care plan update"
* #agent-task-type-schedule-followup "Schedule Follow-up" "Agent recommends scheduling patient follow-up"
  // Renamed from AgentTaskTypeCS#schedule-followup (collision resolution)
* #agent-task-type-patient-education "Patient Education" "Agent recommends patient education intervention"
  // Renamed from AgentTaskTypeCS#patient-education (collision resolution)
* #patient-contact "Patient Contact" "Agent recommends contacting patient"
* #lifestyle-exercise "Exercise Intervention" "Agent recommends exercise modification"
* #lifestyle-nutrition "Nutrition Intervention" "Agent recommends dietary modification"
* #lifestyle-sleep "Sleep Intervention" "Agent recommends sleep hygiene intervention"
* #lifestyle-stress "Stress Management" "Agent recommends stress management intervention"

// ============================================================================
// DECISION TOPICS (14 codes)
// FHIR coverage: No standard — agent-specific monitoring domains
// ============================================================================
* #cardiovascular-risk "Cardiovascular Risk" "Cardiovascular risk assessment logic"
* #metabolic-risk "Metabolic Risk" "Metabolic/diabetes risk assessment"
* #mental-health-risk "Mental Health Risk" "Mental health risk assessment"
* #fall-risk "Fall Risk" "Fall risk assessment"
* #vital-signs-monitoring "Vital Signs Monitoring" "Vital signs monitoring logic"
* #activity-monitoring "Activity Monitoring" "Physical activity monitoring"
* #sleep-monitoring "Sleep Monitoring" "Sleep pattern monitoring"
* #hrv-monitoring "HRV Monitoring" "Heart rate variability monitoring"
* #agent-topic-lifestyle-intervention "Lifestyle Intervention" "Lifestyle modification recommendations"
  // Renamed from AgentDecisionTopicCS#lifestyle-intervention (collision resolution)
* #medication-optimization "Medication Optimization" "Medication optimization logic"
* #agent-topic-preventive-care "Preventive Care" "Preventive care recommendations"
  // Renamed from AgentDecisionTopicCS#preventive-care (collision resolution)
* #abnormal-value-alert "Abnormal Value Alert" "Alerting on abnormal values"
* #trend-alert "Trend Alert" "Alerting on concerning trends"
* #threshold-alert "Threshold Alert" "Threshold-based alerting"
