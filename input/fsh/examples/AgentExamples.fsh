// ============================================================================
// Agent Profile and Extension Examples
// ============================================================================
// Purpose: Example instances for Agent-based clinical decision support profiles
// Created: 2026-01-27
// Covers: AgentTask, AgentServiceRequest profiles
//         AgentRecommendation, AgentEvidenceQuality, AgentActionStatus extensions
// ============================================================================

Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

// ============================================================================
// Agent Task Example (exercises: agent-task, agent-recommendation,
//   agent-evidence-quality, agent-action-status extensions)
// ============================================================================

Instance: AgentTaskReviewHRVExample
InstanceOf: AgentTask
Usage: #example
Title: "Agent Task: Review Abnormal HRV Trend"
Description: "Example of an AI agent task for reviewing an abnormal HRV trend, demonstrating agent-recommendation, agent-evidence-quality, and agent-action-status extensions"

* status = #completed
* intent = #proposal
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#review-trend "Review Trend"
* for = Reference(Patient/PatientExample)
* authoredOn = "2026-01-27T08:00:00Z"
* lastModified = "2026-01-27T09:15:00Z"
* description = "Automated review triggered by 3-day declining HRV trend (SDNN dropped from 45ms to 28ms)"
* priority = #urgent

* businessStatus = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#approved "Approved"
* statusReason = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#clinician-approved "Clinician Approved"

* requester = Reference(Device/AppleWatchDevice)
* owner = Reference(Practitioner/PractitionerExample)

* focus = Reference(Observation/HeartRateExample)

* reasonCode = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#concerning-trend "Concerning Trend"

* output[0].type.text = "Result"
* output[0].valueString = "HRV declining trend confirmed: 45ms → 35ms → 28ms over 72h. Recommend stress management assessment."

* note[0].text = "AI agent identified a significant downward trend in SDNN values. Pattern consistent with increased sympathetic tone, possibly stress-related."

// Agent Recommendation extension
* extension[agentRecommendation].extension[confidence].valueDecimal = 0.87
* extension[agentRecommendation].extension[interpretation].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#agent-interpretation-schedule-followup "Schedule Follow-up"
* extension[agentRecommendation].extension[reasoning].valueMarkdown = "SDNN decline of 38% over 72 hours exceeds the 25% threshold. Pattern analysis suggests acute stress response rather than chronic deconditioning. Recommend lifestyle assessment focusing on sleep and stress management."
* extension[agentRecommendation].extension[agentModel].valueString = "BioMistral-7B-v0.2"
* extension[agentRecommendation].extension[timestamp].valueDateTime = "2026-01-27T08:05:00Z"

// Agent Evidence Quality extension
* extension[evidenceQuality].extension[dataCompleteness].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mostly-complete "Mostly Complete"
* extension[evidenceQuality].extension[temporalCoverage].valuePeriod.start = "2026-01-24T00:00:00Z"
* extension[evidenceQuality].extension[temporalCoverage].valuePeriod.end = "2026-01-27T08:00:00Z"
* extension[evidenceQuality].extension[dataGaps][0].valueString = "Missing 4-hour window on Jan 25 (device not worn during swimming)"
* extension[evidenceQuality].extension[dataQualityScore].valueDecimal = 0.82

// Agent Action Status extension
* extension[actionStatus].extension[actionCode].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#agent-interpretation-schedule-followup "Schedule Follow-up"
* extension[actionStatus].extension[actionStatus].valueCode = #agent-action-status-completed
* extension[actionStatus].extension[reviewedBy].valueReference = Reference(Practitioner/PractitionerExample)
* extension[actionStatus].extension[reviewedAt].valueDateTime = "2026-01-27T09:10:00Z"
* extension[actionStatus].extension[outcomeNote].valueString = "Follow-up scheduled for stress management assessment. Patient notified via app."


// ============================================================================
// Agent Service Request Example (exercises: agent-service-request,
//   agent-recommendation, agent-evidence-quality extensions)
// ============================================================================

Instance: AgentServiceRequestLabExample
InstanceOf: AgentServiceRequest
Usage: #example
Title: "Agent Service Request: HbA1c Lab Order Proposal"
Description: "Example of an AI agent proposing a lab order based on wearable glucose trends, demonstrating agent-service-request profile with recommendation and evidence quality extensions"

* status = #active
* intent = #proposal
* category = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#laboratory "Laboratory"
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#hba1c "HbA1c"
* subject = Reference(Patient/PatientExample)
* authoredOn = "2026-01-27T07:30:00Z"
* priority = #routine

* requester = Reference(Device/AppleWatchDevice)
* performer = Reference(Practitioner/PractitionerExample)

* reasonCode = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#concerning-trend "Concerning Trend"
* reasonReference = Reference(Observation/HeartRateExample)

* patientInstruction = "Fasting for 8 hours recommended before blood draw. Schedule at your convenience within the next 2 weeks."

* note[0].text = "CGM data shows increasing time-above-range (>180 mg/dL) from 12% to 22% over 30 days. HbA1c recheck recommended per ADA guidelines."

// Agent Recommendation extension
* extension[agentRecommendation].extension[confidence].valueDecimal = 0.91
* extension[agentRecommendation].extension[interpretation].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#escalate-clinician "Escalate to Clinician"
* extension[agentRecommendation].extension[reasoning].valueMarkdown = "CGM time-above-range increased from 12% to 22% over 30 days. Last HbA1c was 6.2% (3 months ago). Per ADA Standards of Care, recheck warranted when glucose patterns change significantly."
* extension[agentRecommendation].extension[agentModel].valueString = "GPT-4-Med"
* extension[agentRecommendation].extension[timestamp].valueDateTime = "2026-01-27T07:35:00Z"

// Agent Evidence Quality extension
* extension[evidenceQuality].extension[dataCompleteness].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#agent-completeness-complete "Complete"
* extension[evidenceQuality].extension[temporalCoverage].valuePeriod.start = "2025-12-28T00:00:00Z"
* extension[evidenceQuality].extension[temporalCoverage].valuePeriod.end = "2026-01-27T07:30:00Z"
* extension[evidenceQuality].extension[dataQualityScore].valueDecimal = 0.95
