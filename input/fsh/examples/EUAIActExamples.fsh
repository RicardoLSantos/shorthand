// ============================================================================
// EU AI Act Example Instances
// ============================================================================
// Date: 2026-09-15
// Purpose: Example instances for the AI-system governance profiles
// Covers: DeviceDefinitionSLM, DocumentReferenceAITechnicalDoc,
//         RiskAssessmentAISystem
// Scenario: the BioMistral-7B model already used by the AI compliance examples
//           (AuditEventAIInferenceExample, ClinicalImpressionHRVRiskExample)
//           is described as a model class, its public model card is referenced,
//           and its risk-management assessment is recorded. Values that
//           describe a deployment (quantisation, dates, mitigation) are
//           illustrative; the model identity and its public documentation
//           are as published by the model's authors.
// ============================================================================

Alias: $AgentCS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs

// ============================================================================
// DeviceDefinition: the SLM as a model class (EU AI Act Art. 13 / Art. 49)
// ============================================================================
Instance: DeviceDefinitionBioMistral7BExample
InstanceOf: DeviceDefinitionSLM
Usage: #example
Title: "Device Definition: BioMistral-7B small language model"
Description: "Model-class description of the BioMistral-7B biomedical language model used by the lifestyle-medicine decision-support examples: identity, release, parameter count, illustrative deployment quantisation, capability, language and a pointer to the public model card."

* manufacturerString = "BioMistral"
* deviceName[0].name = "BioMistral-7B"
* deviceName[0].type = #model-name
* deviceName[1].name = "BioMistral 7B biomedical language model"
* deviceName[1].type = #user-friendly-name
* modelNumber = "v0.2"
* type = $AgentCS#model-biomistral-7b "BioMistral 7B"
* version[0] = "0.2"
* safety[0].text = "Advisory output only: every recommendation is reviewed by a clinician before it reaches the patient (see ClinicalImpressionAIAssessment)"
* onlineInformation = "https://huggingface.co/BioMistral/BioMistral-7B"
* property[0].type.text = "Parameter count"
* property[0].valueQuantity.value = 7
* property[0].valueQuantity.unit = "billion parameters"
* property[1].type.text = "Deployment quantisation (illustrative)"
* property[1].valueCode[0].text = "4-bit integer weights"
* capability[0].type.text = "Text generation"
* capability[0].description[0].text = "Free-text reasoning over structured lifestyle-medicine observations"
* languageCode[0] = urn:ietf:bcp:47#en "English"
* note[0].text = "The model class is referenced by AuditEventAIInteraction (inference audit trail) and ClinicalImpressionAIAssessment (agentModel); its risk-management assessment is RiskAssessmentBioMistral7BExample and its technical documentation reference is DocumentReferenceBioMistral7BModelCardExample."

// ============================================================================
// DocumentReference: technical documentation pointer (EU AI Act Art. 11, Annex IV)
// ============================================================================
Instance: DocumentReferenceBioMistral7BModelCardExample
InstanceOf: DocumentReferenceAITechnicalDoc
Usage: #example
Title: "Document Reference: BioMistral-7B model card"
Description: "Pointer to the public model card of BioMistral-7B, recorded as the Annex IV technical documentation of the model class described by DeviceDefinitionBioMistral7BExample."

* status = #current
* type = $AgentCS#ai-technical-doc-model-card "AI Model Card"
* category[0].text = "AI system technical documentation"
* date = "2026-09-15T09:00:00Z"
* description = "Public model card: architecture, pre-training corpus, evaluation benchmarks and limitations of BioMistral-7B, as published by its authors."
* content[0].attachment.contentType = #text/html
* content[0].attachment.url = "https://huggingface.co/BioMistral/BioMistral-7B"
* content[0].attachment.title = "BioMistral-7B model card"

// ============================================================================
// RiskAssessment: risk-management assessment of the AI system (EU AI Act Art. 9)
// ============================================================================
Instance: RiskAssessmentBioMistral7BExample
InstanceOf: RiskAssessmentAISystem
Usage: #example
Title: "Risk Assessment: BioMistral-7B lifestyle decision support"
Description: "Illustrative risk-management assessment of the BioMistral-7B decision-support deployment: risk classification, mitigation measures and review status, with the model class and its technical documentation as basis."

* status = #final
* code.text = "Risk-management assessment of an AI decision-support system"
* subject = Reference(Group/lifestyle-med-cohort)
* occurrenceDateTime = "2026-09-15"
* performer = Reference(Practitioner/PractitionerExample)
* basis[0] = Reference(DeviceDefinition/DeviceDefinitionBioMistral7BExample)
* basis[1] = Reference(DocumentReference/DocumentReferenceBioMistral7BModelCardExample)
* prediction[0].outcome.text = "Inappropriate lifestyle recommendation reaching the patient without clinical review"
* prediction[0].qualitativeRisk = $AgentCS#ai-risk-medio "Medio Risco (Medium Risk)"
* prediction[0].rationale = "Recommendations are advisory and reviewed by a clinician before release; the residual risk is a delayed or missed review."
* mitigation = "Human-in-the-loop review of every recommendation (ClinicalImpressionAIAssessment.assessor); inference audit trail (AuditEventAIInteraction); model card on file (DocumentReferenceAITechnicalDoc); periodic re-assessment after each model or prompt change."
* extension[assessmentStatus].valueCodeableConcept = $AgentCS#ai-risk-assessment-complete "AI Risk Assessment Complete"
* note[0].text = "Illustrative example. Performance metrics are recorded with the performanceMetrics extension once a validation run is on file."
