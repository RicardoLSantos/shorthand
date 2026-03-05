// ============================================================================
// AI Override Workflow Bundle
// ============================================================================
// Date: 2026-03-05
// Purpose: Demonstrates CFM 2.454 Art. 7 physician override workflow
// Flow: AI recommends -> Physician rejects -> Override documented -> Modified plan
// ============================================================================

Alias: $DCM = http://dicom.nema.org/resources/ontology/DCM
Alias: $AgentCS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs
Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct

Instance: AIOverrideWorkflowBundle
InstanceOf: Bundle
Usage: #example
Title: "AI Override Workflow Bundle"
Description: "Demonstrates physician override of AI recommendation per CFM 2.454/2026 Art. 7. AI recommends high-intensity exercise but physician overrides due to patient comorbidity (recent knee surgery), modifying plan to low-impact alternatives."

* type = #collection
* timestamp = "2026-03-05T14:00:00Z"

// --- Entry 1: Patient ---
* entry[0].fullUrl = "urn:uuid:patient-ov-01"
* entry[0].resource = PatientOverrideWF

// --- Entry 2: Original AI ClinicalImpression ---
* entry[1].fullUrl = "urn:uuid:ci-ov-original"
* entry[1].resource = ClinicalImpressionOriginalWF

// --- Entry 3: Original AI CarePlan (rejected) ---
* entry[2].fullUrl = "urn:uuid:cp-ov-rejected"
* entry[2].resource = CarePlanRejectedWF

// --- Entry 4: Modified CarePlan (physician approved) ---
* entry[3].fullUrl = "urn:uuid:cp-ov-modified"
* entry[3].resource = CarePlanModifiedWF

// --- Entry 5: Override AuditEvent ---
* entry[4].fullUrl = "urn:uuid:audit-ov-01"
* entry[4].resource = AuditEventOverrideWF

// ============================================================================
// Contained Resources
// ============================================================================

Instance: PatientOverrideWF
InstanceOf: Patient
Usage: #inline
* identifier.system = "urn:oid:2.16.840.1.113883.2.4.6.3"
* identifier.value = "OV-2026-001"
* name.family = "Santos"
* name.given = "Joao"
* gender = #male
* birthDate = "1972-03-22"

Instance: ClinicalImpressionOriginalWF
InstanceOf: ClinicalImpressionAIAssessment
Usage: #inline
* status = #completed
* description = "AI assessment: sedentary lifestyle with metabolic risk indicators"
* subject = Reference(urn:uuid:patient-ov-01)
* date = "2026-03-05T14:00:05Z"
* assessor = Reference(Practitioner/PractitionerExample)
* investigation[0].code.text = "Activity and Metabolic Inputs"
* investigation[0].item[0] = Reference(Observation/HeartRateExample)
* summary = "Low daily step count (avg 2,100/day), elevated fasting glucose (112 mg/dL), BMI 31.2. AI recommends structured exercise programme with high-intensity intervals."
* finding[0].itemCodeableConcept = $SCT#40979000 "Sedentary behaviour"
* finding[0].basis = "Average 2,100 steps/day over 14 days (target: 7,500)"
* prognosisCodeableConcept = $AgentCS#agent-interpretation-moderate-risk "Moderate Risk"
* protocol[0] = "urn:cql:library:MET-002:v1.0"
* extension[agentRecommendation].extension[confidence].valueDecimal = 0.82
* extension[agentRecommendation].extension[interpretation].valueCodeableConcept = $AgentCS#agent-interpretation-lifestyle-intervention "Lifestyle Intervention"
* extension[agentRecommendation].extension[reasoning].valueMarkdown = "Sedentary + metabolic risk: HIIT programme shown to improve insulin sensitivity (meta-analysis: -0.8% HbA1c in 12 weeks)."
* extension[agentRecommendation].extension[agentModel].valueString = "BioMistral-7B-v0.2"
* extension[agentRecommendation].extension[timestamp].valueDateTime = "2026-03-05T14:00:05Z"
* extension[inferenceMetadata].extension[modelId].valueCodeableConcept = $AgentCS#model-biomistral-7b "BioMistral 7B"
* extension[inferenceMetadata].extension[riskClassification].valueCodeableConcept = $AgentCS#ai-risk-alto "Alto Risco (High Risk)"

Instance: CarePlanRejectedWF
InstanceOf: CarePlanLifestyleMedicine
Usage: #inline
* status = #revoked
* intent = #proposal
* title = "AI Proposed: HIIT Exercise Programme (REJECTED)"
* description = "High-intensity interval training programme - REJECTED by physician due to comorbidity"
* category = $AgentCS#lifestyle-exercise "Exercise Intervention"
* subject = Reference(urn:uuid:patient-ov-01)
* period.start = "2026-03-05"
* period.end = "2026-05-28"
* author = Reference(Device/AppleWatchDevice)
* activity[0].detail.kind = #ServiceRequest
* activity[0].detail.code.text = "HIIT sessions 3x/week"
* activity[0].detail.status = #cancelled
* activity[0].detail.description = "30-min HIIT sessions including sprints, burpees, box jumps"
* note[0].text = "REJECTED: Patient had right knee arthroscopy 6 weeks ago. High-impact exercise contraindicated for 12 weeks post-op. AI did not have access to surgical history."

Instance: CarePlanModifiedWF
InstanceOf: CarePlanLifestyleMedicine
Usage: #inline
* status = #active
* intent = #plan
* title = "Modified: Low-Impact Exercise Programme"
* description = "Physician-modified plan replacing HIIT with low-impact alternatives appropriate for post-arthroscopy recovery"
* category = $AgentCS#lifestyle-exercise "Exercise Intervention"
* subject = Reference(urn:uuid:patient-ov-01)
* period.start = "2026-03-05"
* period.end = "2026-05-28"
* author = Reference(Practitioner/PractitionerExample)
* replaces = Reference(urn:uuid:cp-ov-rejected)
* supportingInfo = Reference(urn:uuid:ci-ov-original)
* activity[0].detail.kind = #ServiceRequest
* activity[0].detail.code.text = "Swimming 3x/week (30 min)"
* activity[0].detail.status = #scheduled
* activity[0].detail.description = "Low-impact aquatic exercise: freestyle and backstroke, no breaststroke kick. Pool-based to reduce knee joint load."
* activity[1].detail.kind = #ServiceRequest
* activity[1].detail.code.text = "Stationary cycling 2x/week (20 min)"
* activity[1].detail.status = #scheduled
* activity[1].detail.description = "Low-resistance stationary cycling, seat adjusted to minimize knee flexion beyond 90 degrees"
* activity[2].detail.kind = #ServiceRequest
* activity[2].detail.code.text = "Walking programme (daily, progressive)"
* activity[2].detail.status = #scheduled
* activity[2].detail.description = "Progressive walking: week 1-2: 15 min, week 3-4: 20 min, week 5+: 30 min. Flat terrain only."
* note[0].text = "Physician override (CFM 2.454 Art. 7): AI HIIT recommendation replaced with low-impact alternatives. Reason: comorbidity (6-week post right knee arthroscopy). AI lacked surgical history context. Modified plan maintains metabolic benefit while protecting joint recovery."

Instance: AuditEventOverrideWF
InstanceOf: AuditEventAIInteraction
Usage: #inline
* type = $DCM#110112 "Query"
* subtype = $AgentCS#ai-override-recorded "AI Override Recorded"
* action = #U
* recorded = "2026-03-05T14:15:00Z"
* outcome = #0
* outcomeDesc = "Physician override: HIIT replaced with low-impact exercise due to post-arthroscopy comorbidity. CFM 2.454 Art. 7 physician autonomy exercised."
* agent[aiSystem].type = $DCM#110153 "Source Role ID"
* agent[aiSystem].who = Reference(Device/AppleWatchDevice)
* agent[aiSystem].name = "BioMistral-7B-v0.2"
* agent[aiSystem].requestor = false
* agent[reviewer].type = $DCM#110152 "Destination Role ID"
* agent[reviewer].who = Reference(Practitioner/PractitionerExample)
* agent[reviewer].requestor = true
* source.observer = Reference(Device/AppleWatchDevice)
* entity[0].what = Reference(urn:uuid:cp-ov-rejected)
* entity[0].description = "Original AI CarePlan (rejected)"
* entity[1].what = Reference(urn:uuid:cp-ov-modified)
* entity[1].description = "Modified CarePlan (physician approved)"
* extension[inferenceMetadata].extension[modelId].valueCodeableConcept = $AgentCS#model-biomistral-7b "BioMistral 7B"
* extension[inferenceMetadata].extension[riskClassification].valueCodeableConcept = $AgentCS#ai-risk-alto "Alto Risco (High Risk)"
