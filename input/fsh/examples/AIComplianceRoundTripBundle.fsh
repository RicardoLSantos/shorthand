// ============================================================================
// AI Compliance Round-Trip Validation Bundle
// ============================================================================
// Date: 2026-03-05
// Purpose: Full AI compliance workflow from consent to audit trail
// Flow: Consent -> Observation -> ClinicalImpression -> CarePlan -> AuditEvent
// Regulatory: Demonstrates CFM 2.454 + EU AI Act end-to-end compliance
// ============================================================================

Alias: $DCM = http://dicom.nema.org/resources/ontology/DCM
Alias: $AgentCS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs
Alias: $AppCS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs
Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct

Instance: AIComplianceRoundTripBundle
InstanceOf: Bundle
Usage: #example
Title: "AI Compliance Round-Trip Bundle"
Description: "Complete AI compliance workflow demonstrating consent verification, wearable observation capture, AI risk assessment, lifestyle care plan generation, and audit trail logging. Validates CFM 2.454/2026 + EU AI Act end-to-end compliance."

* type = #collection
* timestamp = "2026-03-05T10:00:00Z"

// --- Entry 1: Patient ---
* entry[0].fullUrl = "urn:uuid:patient-rt-01"
* entry[0].resource = PatientComplianceRT

// --- Entry 2: Consent for AI-assisted care ---
* entry[1].fullUrl = "urn:uuid:consent-rt-01"
* entry[1].resource = ConsentAIAssistedCareRT

// --- Entry 3: HRV Observation (SDNN) ---
* entry[2].fullUrl = "urn:uuid:obs-sdnn-rt-01"
* entry[2].resource = ObservationSDNNComplianceRT

// --- Entry 4: CRP Observation ---
* entry[3].fullUrl = "urn:uuid:obs-crp-rt-01"
* entry[3].resource = ObservationCRPComplianceRT

// --- Entry 5: ClinicalImpression (AI Assessment) ---
* entry[4].fullUrl = "urn:uuid:ci-rt-01"
* entry[4].resource = ClinicalImpressionComplianceRT

// --- Entry 6: CarePlan (Lifestyle Medicine) ---
* entry[5].fullUrl = "urn:uuid:cp-rt-01"
* entry[5].resource = CarePlanComplianceRT

// --- Entry 7: AuditEvent (AI Inference) ---
* entry[6].fullUrl = "urn:uuid:audit-rt-01"
* entry[6].resource = AuditEventComplianceRT

// --- Entry 8: Provenance ---
* entry[7].fullUrl = "urn:uuid:prov-rt-01"
* entry[7].resource = ProvenanceComplianceRT

// ============================================================================
// Contained Resources
// ============================================================================

Instance: PatientComplianceRT
InstanceOf: Patient
Usage: #inline
* identifier.system = "urn:oid:2.16.840.1.113883.2.4.6.3"
* identifier.value = "RT-2026-001"
* name.family = "Silva"
* name.given = "Maria"
* gender = #female
* birthDate = "1985-06-15"

Instance: ConsentAIAssistedCareRT
InstanceOf: Consent
Usage: #inline
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#treatment "Treatment"
* category = http://loinc.org#59284-0 "Consent Document"
* patient = Reference(urn:uuid:patient-rt-01)
* dateTime = "2026-03-01T09:00:00Z"
* policy[0].authority = "https://www.anpd.gov.br"
* policy[0].uri = "urn:br:lgpd:2018"
* policy[1].authority = "https://portal.cfm.org.br"
* policy[1].uri = "urn:br:cfm:2454:2026"

Instance: ObservationSDNNComplianceRT
InstanceOf: Observation
Usage: #inline
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* code = $LOINC#80404-7 "R-R interval.standard deviation"
* subject = Reference(urn:uuid:patient-rt-01)
* effectiveDateTime = "2026-03-05T08:00:00Z"
* valueQuantity.value = 28
* valueQuantity.unit = "ms"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #ms
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#L "Low"

Instance: ObservationCRPComplianceRT
InstanceOf: Observation
Usage: #inline
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#laboratory "Laboratory"
* code = $LOINC#71426-1 "C reactive protein [Mass/volume] in Blood by High sensitivity method"
* subject = Reference(urn:uuid:patient-rt-01)
* effectiveDateTime = "2026-03-05T07:30:00Z"
* valueQuantity.value = 4.8
* valueQuantity.unit = "mg/L"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mg/L
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"

Instance: ClinicalImpressionComplianceRT
InstanceOf: ClinicalImpressionAIAssessment
Usage: #inline
* status = #completed
* description = "AI risk assessment: declining HRV with inflammatory elevation"
* subject = Reference(urn:uuid:patient-rt-01)
* date = "2026-03-05T10:00:05Z"
* assessor = Reference(Practitioner/PractitionerExample)
* investigation[0].code.text = "Cardiovascular Risk Inputs"
* investigation[0].item[0] = Reference(urn:uuid:obs-sdnn-rt-01)
* investigation[0].item[1] = Reference(urn:uuid:obs-crp-rt-01)
* summary = "SDNN 28ms (<40ms threshold) + CRP 4.8mg/L (>3.0 threshold). CQL rule CVR-003 triggered. Moderate cardiovascular risk. Lifestyle intervention recommended."
* finding[0].itemCodeableConcept = $SCT#251880007 "Decreased heart rate variability"
* finding[0].basis = "SDNN 28ms below 40ms threshold"
* prognosisCodeableConcept = $AgentCS#agent-interpretation-moderate-risk "Moderate Risk"
* protocol[0] = "urn:cql:library:CVR-003:v1.2"
* extension[agentRecommendation].extension[confidence].valueDecimal = 0.78
* extension[agentRecommendation].extension[interpretation].valueCodeableConcept = $AgentCS#agent-interpretation-lifestyle-intervention "Lifestyle Intervention"
* extension[agentRecommendation].extension[reasoning].valueMarkdown = "Combined HRV+CRP pattern indicates stress-inflammatory response."
* extension[agentRecommendation].extension[agentModel].valueString = "BioMistral-7B-v0.2"
* extension[agentRecommendation].extension[timestamp].valueDateTime = "2026-03-05T10:00:05Z"
* extension[inferenceMetadata].extension[latencyMs].valueDecimal = 1850.0
* extension[inferenceMetadata].extension[modelId].valueCodeableConcept = $AgentCS#model-biomistral-7b "BioMistral 7B"
* extension[inferenceMetadata].extension[riskClassification].valueCodeableConcept = $AgentCS#ai-risk-alto "Alto Risco (High Risk)"

Instance: CarePlanComplianceRT
InstanceOf: CarePlanLifestyleMedicine
Usage: #inline
* status = #active
* intent = #plan
* title = "Lifestyle Intervention: Stress-Inflammatory Management"
* description = "12-week structured lifestyle programme targeting stress reduction and anti-inflammatory dietary pattern"
* category = $AgentCS#lifestyle-stress "Stress Management"
* subject = Reference(urn:uuid:patient-rt-01)
* period.start = "2026-03-05"
* period.end = "2026-05-28"
* author = Reference(Practitioner/PractitionerExample)
* supportingInfo = Reference(urn:uuid:ci-rt-01)
* activity[0].detail.kind = #ServiceRequest
* activity[0].detail.code.text = "Daily mindfulness meditation (15 min)"
* activity[0].detail.status = #scheduled
* activity[0].detail.description = "Structured mindfulness programme: 15 min/day guided meditation, progressive muscle relaxation, breathing exercises"
* activity[1].detail.kind = #ServiceRequest
* activity[1].detail.code.text = "Mediterranean dietary pattern adoption"
* activity[1].detail.status = #scheduled
* activity[1].detail.description = "Anti-inflammatory diet: increase omega-3, reduce processed foods, increase fruit/vegetable intake to 5+/day"
* note[0].text = "AI-generated plan approved by physician. Patient consented to AI-assisted care (urn:br:cfm:2454:2026)."

Instance: AuditEventComplianceRT
InstanceOf: AuditEventAIInteraction
Usage: #inline
* type = $DCM#110112 "Query"
* subtype = $AgentCS#ai-recommendation-generated "AI Recommendation Generated"
* action = #C
* recorded = "2026-03-05T10:00:06Z"
* outcome = #0
* agent[aiSystem].type = $DCM#110153 "Source Role ID"
* agent[aiSystem].who = Reference(Device/AppleWatchDevice)
* agent[aiSystem].name = "BioMistral-7B-v0.2"
* agent[aiSystem].requestor = false
* agent[reviewer].type = $DCM#110152 "Destination Role ID"
* agent[reviewer].who = Reference(Practitioner/PractitionerExample)
* agent[reviewer].requestor = true
* source.observer = Reference(Device/AppleWatchDevice)
* entity[0].what = Reference(urn:uuid:ci-rt-01)
* entity[0].description = "ClinicalImpression generated by AI inference"
* extension[inferenceMetadata].extension[latencyMs].valueDecimal = 1850.0
* extension[inferenceMetadata].extension[modelId].valueCodeableConcept = $AgentCS#model-biomistral-7b "BioMistral 7B"
* extension[inferenceMetadata].extension[riskClassification].valueCodeableConcept = $AgentCS#ai-risk-alto "Alto Risco (High Risk)"

Instance: ProvenanceComplianceRT
InstanceOf: Provenance
Usage: #inline
* target = Reference(urn:uuid:cp-rt-01)
* recorded = "2026-03-05T10:00:10Z"
* activity = http://terminology.hl7.org/CodeSystem/v3-DataOperation#CREATE "create"
* agent[0].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author "Author"
* agent[0].who = Reference(Device/AppleWatchDevice)
* agent[1].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#verifier "Verifier"
* agent[1].who = Reference(Practitioner/PractitionerExample)
* reason = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREAT "treatment"
