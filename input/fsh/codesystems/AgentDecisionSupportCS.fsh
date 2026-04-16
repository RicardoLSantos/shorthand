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

// ============================================================================
// AI RISK CLASSIFICATION (4 codes) — CFM 2.454/2026 + EU AI Act 2024/1689
// FHIR coverage: No standard — regulatory AI risk tiering
// ============================================================================
* #ai-risk-baixo "Baixo Risco (Low Risk)" "AI system poses low risk to patient safety — minimal regulatory requirements"
  // EU AI Act Art. 6: Not in Annex III = low risk
  // CFM 2.454 Art. 3: Sistemas de apoio sem autonomia decisória
* #ai-risk-medio "Medio Risco (Medium Risk)" "AI system poses medium risk — standard transparency and logging required"
  // EU AI Act: Annex III applications with limited risk
  // CFM 2.454 Art. 4: Sistemas com sugestões clínicas
* #ai-risk-alto "Alto Risco (High Risk)" "AI system poses high risk to patient safety — full compliance required"
  // EU AI Act Art. 6 + Annex III: Health/safety AI systems
  // CFM 2.454 Art. 5: Sistemas com impacto em decisão clínica
* #ai-risk-inaceitavel "Risco Inaceitavel (Unacceptable Risk)" "AI system poses unacceptable risk — prohibited or requires special authorization"
  // EU AI Act Art. 5: Prohibited practices
  // CFM 2.454: Not explicitly addressed (autonomous AI in Brazil = alto risco)

// ============================================================================
// AI MODEL IDENTIFIERS (6 codes) — SLM models for edge inference
// FHIR coverage: No standard — device/software identification
// ============================================================================
* #model-qwen35-4b "Qwen 3.5 4B" "Alibaba Qwen 3.5 4-billion parameter model"
* #model-biomistral-7b "BioMistral 7B" "BioMistral 7-billion parameter biomedical model"
* #model-llama3-8b "LLaMA 3 8B" "Meta LLaMA 3 8-billion parameter model"
* #model-phi3-mini "Phi-3 Mini 3.8B" "Microsoft Phi-3 Mini 3.8-billion parameter model"
* #model-gemma2-2b "Gemma 2 2B" "Google Gemma 2 2-billion parameter model"
* #model-custom-slm "Custom Fine-tuned SLM" "Custom fine-tuned small language model for domain-specific tasks"

// ============================================================================
// PHYSICIAN OVERRIDE REASONS (5 codes) — CFM 2.454 Art. 7
// FHIR coverage: No standard — clinical governance of AI override
// ============================================================================
* #override-clinical-judgment "Clinical Judgment Override" "Physician overrides AI based on clinical judgment and experience"
  // CFM 2.454 Art. 7: Autonomia médica prevalece sobre recomendação de IA
* #override-patient-context "Patient Context Override" "Physician overrides AI due to patient-specific context not captured in data"
* #override-comorbidity "Comorbidity Override" "Physician overrides AI due to comorbidities affecting recommendation applicability"
* #override-patient-preference "Patient Preference Override" "Physician overrides AI based on patient preference or shared decision-making"
* #override-ai-error "AI Error Override" "Physician identifies error in AI reasoning or output"

// ============================================================================
// REGULATORY EVENT TYPES (5 codes) — AI audit trail events
// FHIR coverage: Maps to AuditEvent.subtype (custom)
// ============================================================================
* #ai-inference-executed "AI Inference Executed" "An AI model inference was executed on clinical data"
* #ai-recommendation-generated "AI Recommendation Generated" "The AI system generated a clinical recommendation"
* #ai-recommendation-reviewed "AI Recommendation Reviewed" "A clinician reviewed an AI-generated recommendation"
* #ai-override-recorded "AI Override Recorded" "A clinician override of an AI recommendation was recorded"
* #ai-consent-verified "AI Consent Verified" "Patient consent for AI-assisted care was verified"

// ============================================================================
// AI CONSENT CATEGORIES (3 codes) — LGPD Art. 8 + Art. 11 + Art. 20
// FHIR coverage: Consent.category extension for AI-specific consent granularity
// ============================================================================
* #ai-consent-general "AI General Consent" "Consent for AI processing of non-sensitive personal data (LGPD Art. 7-I)"
* #ai-consent-health "AI Health Data Consent" "Explicit consent for AI processing of sensitive health data (LGPD Art. 11-I)"
* #ai-consent-automated-decision "AI Automated Decision Consent" "Consent for automated decision-making with right to review (LGPD Art. 20)"

// ============================================================================
// CFM 2.454/2026 — DEFINITIONS (Art. 2) + PATIENT RIGHTS (Art. 9) (5 codes)
// Reference: CFM Resolution 2.454/2026, effective August 2026
// ============================================================================
* #ia-medica "IA Médica" "Artificial intelligence system used in medical practice (CFM 2.454 Art. 2)"
* #sistema-apoio-decisao "Sistema de Apoio à Decisão" "Clinical decision support system (CFM 2.454 Art. 2)"
* #patient-second-opinion-requested "Patient Requested Second Opinion" "Patient exercised right to second opinion regarding AI recommendation (CFM 2.454 Art. 9)"
* #patient-refused-ai "Patient Refused AI" "Patient exercised right to refuse AI-assisted analysis (CFM 2.454 Art. 9)"
* #ai-disclosure-completed "AI Disclosure Completed" "Patient was notified of AI use per transparency requirements (CFM 2.454 Art. 4)"

// ============================================================================
// CFM 2.454/2026 — AI AUTONOMY LEVELS (Art. 3) (4 codes)
// Reference: CFM Resolution 2.454/2026 risk classification criteria
// ============================================================================
* #autonomy-fully-autonomous "Fully Autonomous" "AI system operates without physician input (CFM 2.454 Art. 3 — risco inaceitável)"
* #autonomy-semi-autonomous "Semi-Autonomous" "AI system operates with periodic physician oversight (CFM 2.454 Art. 3 — alto risco)"
* #autonomy-assistive "Assistive" "AI system provides recommendations requiring physician approval (CFM 2.454 Art. 3 — médio risco)"
* #autonomy-informational "Informational" "AI system provides information only, no clinical recommendations (CFM 2.454 Art. 3 — baixo risco)"

// ============================================================================
// CFM 2.454/2026 — DATA RETENTION (Art. 6) (3 codes)
// Reference: CFM Resolution 2.454/2026 traceability requirements
// ============================================================================
* #retention-automatic "Automatic Deletion" "Audit records automatically deleted after retention period (CFM 2.454 Art. 6)"
* #retention-manual-review "Manual Review Before Deletion" "Audit records require manual review before deletion (CFM 2.454 Art. 6)"
* #retention-permanent "Permanent Retention" "Audit records retained permanently (CFM 2.454 Art. 6)"

// ============================================================================
// EU AI ACT 2024/1689 — RISK MANAGEMENT (Art. 9) (2 codes)
// Reference: Regulation (EU) 2024/1689, Chapter III Section 2
// Cross-ref: CFM 2.454 Art. 3 (risk classification), LGPD Art. 6-IV (non-discrimination)
// ============================================================================
* #ai-risk-assessment-complete "AI Risk Assessment Complete" "Risk management assessment for AI system completed per EU AI Act Art. 9"
* #ai-risk-assessment-pending "AI Risk Assessment Pending" "Risk management assessment for AI system pending — system not yet validated"

// ============================================================================
// EU AI ACT 2024/1689 — TECHNICAL DOCUMENTATION (Art. 11 + Annex IV) (2 codes)
// Reference: Regulation (EU) 2024/1689, Chapter III Section 2, Annex IV
// ============================================================================
* #ai-technical-doc-model-card "AI Model Card" "Technical documentation describing model architecture, training data, and performance (EU AI Act Art. 11, Annex IV §2)"
* #ai-technical-doc-impact-assessment "AI Impact Assessment" "Fundamental rights impact assessment (EU AI Act Art. 27, FRIA)"

// ============================================================================
// EU AI ACT 2024/1689 — PERFORMANCE & DATA GOVERNANCE (Art. 10, 15) (4 codes)
// Reference: Regulation (EU) 2024/1689, Chapter III Section 2
// Cross-ref: LGPD Art. 6-IV (non-discrimination), CFM 2.454 Art. 5 (safety)
// ============================================================================
* #ai-performance-validated "AI Performance Validated" "AI system performance metrics validated against benchmarks per EU AI Act Art. 15"
* #ai-performance-monitoring "AI Performance Monitoring" "AI system under continuous performance monitoring per EU AI Act Art. 15"
* #ai-training-data-certified "AI Training Data Certified" "Training dataset meets EU AI Act Art. 10 data governance requirements (quality, representativeness, bias assessment)"
* #ai-training-data-uncertified "AI Training Data Uncertified" "Training dataset has NOT been certified for EU AI Act Art. 10 compliance"
