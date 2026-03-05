// ============================================================================
// AI Compliance Example Instances
// ============================================================================
// Date: 2026-03-05
// Purpose: Example instances for AI/CDSS compliance profiles
// Covers: AuditEventAIInteraction, ClinicalImpressionAIAssessment
// ============================================================================

Alias: $DCM = http://dicom.nema.org/resources/ontology/DCM
Alias: $AgentCS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs
Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct

// ============================================================================
// AuditEvent: AI HRV Inference Audit Trail
// Scenario: BioMistral-7B performs HRV risk inference, logged per EU AI Act
// ============================================================================

Instance: AuditEventAIInferenceExample
InstanceOf: AuditEventAIInteraction
Usage: #example
Title: "Audit Event: AI HRV Risk Inference"
Description: "Example of an AI inference audit event where BioMistral-7B analyses HRV data and generates a risk assessment. Demonstrates EU AI Act Art. 12 automatic logging."

* type = $DCM#110112 "Query"
* subtype = $AgentCS#ai-inference-executed "AI Inference Executed"
* action = #E
* recorded = "2026-03-05T10:30:00Z"
* outcome = #0

* agent[aiSystem].type = $DCM#110153 "Source Role ID"
* agent[aiSystem].who = Reference(Device/AppleWatchDevice)
* agent[aiSystem].name = "BioMistral-7B-v0.2"
* agent[aiSystem].requestor = false

* agent[reviewer].type = $DCM#110152 "Destination Role ID"
* agent[reviewer].who = Reference(Practitioner/PractitionerExample)
* agent[reviewer].requestor = true

* source.observer = Reference(Device/AppleWatchDevice)

* entity[0].what = Reference(Observation/HeartRateExample)
* entity[0].type = http://terminology.hl7.org/CodeSystem/audit-entity-type#2 "System Object"
* entity[0].description = "HRV Observation (SDNN=28ms) used as AI inference input"

* extension[inferenceMetadata].extension[latencyMs].valueDecimal = 1250.5
* extension[inferenceMetadata].extension[tokensPerSecond].valueDecimal = 42.3
* extension[inferenceMetadata].extension[peakRamMb].valueDecimal = 3840.0
* extension[inferenceMetadata].extension[modelId].valueCodeableConcept = $AgentCS#model-biomistral-7b "BioMistral 7B"
* extension[inferenceMetadata].extension[riskClassification].valueCodeableConcept = $AgentCS#ai-risk-alto "Alto Risco (High Risk)"
* extension[inferenceMetadata].extension[promptTokenCount].valueInteger = 512
* extension[inferenceMetadata].extension[completionTokenCount].valueInteger = 187

// ============================================================================
// ClinicalImpression: AI HRV Risk Assessment Output
// Scenario: AI analyses declining HRV + elevated CRP, generates risk assessment
// ============================================================================

Instance: ClinicalImpressionHRVRiskExample
InstanceOf: ClinicalImpressionAIAssessment
Usage: #example
Title: "Clinical Impression: AI HRV Risk Assessment"
Description: "Example of an AI-generated clinical impression from HRV analysis showing declining SDNN with elevated inflammatory markers, generating a moderate cardiovascular risk assessment."

* status = #completed
* description = "AI-generated risk assessment: Declining HRV trend with concurrent inflammatory marker elevation suggests increased cardiovascular risk requiring lifestyle intervention."
* subject = Reference(Patient/PatientExample)
* date = "2026-03-05T10:30:15Z"
* assessor = Reference(Practitioner/PractitionerExample)

* investigation[0].code.text = "HRV Analysis Input"
* investigation[0].item[0] = Reference(Observation/HeartRateExample)

* summary = "72-hour SDNN decline (45ms to 28ms, -38%) concurrent with CRP elevation (2.1 to 4.8 mg/L). Pattern consistent with acute stress-inflammatory response. Moderate cardiovascular risk per CQL rule CVR-003. Recommend: stress management programme + follow-up HRV in 7 days."

* finding[0].itemCodeableConcept = $SCT#251880007 "Decreased heart rate variability"
* finding[0].basis = "SDNN 28ms below normal threshold (40ms) with 38% 72h decline"

* finding[1].itemCodeableConcept = $LOINC#71426-1 "C reactive protein [Mass/volume] in Blood by High sensitivity method"
* finding[1].basis = "CRP 4.8 mg/L exceeds cardiovascular risk threshold (3.0 mg/L)"

* prognosisCodeableConcept = $AgentCS#agent-interpretation-moderate-risk "Moderate Risk"

* protocol[0] = "urn:cql:library:CVR-003:v1.2"

* note[0].text = "CQL rule CVR-003 triggered: SDNN <40ms AND CRP >3.0 mg/L within 72h window. SLM reasoning: concurrent HRV depression and inflammatory elevation suggests sympathetic-immune axis activation, commonly seen in chronic stress or early infection. Lifestyle modification recommended as first-line intervention."

* extension[agentRecommendation].extension[confidence].valueDecimal = 0.78
* extension[agentRecommendation].extension[interpretation].valueCodeableConcept = $AgentCS#agent-interpretation-lifestyle-intervention "Lifestyle Intervention"
* extension[agentRecommendation].extension[reasoning].valueMarkdown = "SDNN decline (-38% over 72h) exceeds 25% threshold. Concurrent CRP elevation (4.8 mg/L) indicates inflammatory component. Combined HRV+CRP pattern has 78% positive predictive value for stress-related cardiovascular risk in lifestyle medicine cohorts. Recommend: structured stress management (mindfulness 15min/day) + Mediterranean dietary pattern + sleep hygiene optimization."
* extension[agentRecommendation].extension[agentModel].valueString = "BioMistral-7B-v0.2"
* extension[agentRecommendation].extension[timestamp].valueDateTime = "2026-03-05T10:30:15Z"

* extension[inferenceMetadata].extension[latencyMs].valueDecimal = 2100.0
* extension[inferenceMetadata].extension[tokensPerSecond].valueDecimal = 38.7
* extension[inferenceMetadata].extension[peakRamMb].valueDecimal = 4096.0
* extension[inferenceMetadata].extension[modelId].valueCodeableConcept = $AgentCS#model-biomistral-7b "BioMistral 7B"
* extension[inferenceMetadata].extension[riskClassification].valueCodeableConcept = $AgentCS#ai-risk-alto "Alto Risco (High Risk)"
* extension[inferenceMetadata].extension[promptTokenCount].valueInteger = 1024
* extension[inferenceMetadata].extension[completionTokenCount].valueInteger = 342
