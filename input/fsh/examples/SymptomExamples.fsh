Instance: ChronicSymptomExample
InstanceOf: Observation
Usage: #example
Description: "Chronic symptom observation example"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#84229001 "Fatigue"
* subject = Reference(Patient/PatientExample)
* performer = Reference(Practitioner/PractitionerExample)
* effectiveDateTime = "2024-03-19T14:00:00Z"
// ... resto do exemplo ...

Instance: ExampleSymptomSeverity
InstanceOf: Observation
Usage: #example
Description: "Symptom severity observation example"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#162465004 "Symptom severity"
* subject = Reference(Patient/PatientExample)
* performer = Reference(Practitioner/PractitionerExample)
* effectiveDateTime = "2024-03-19T10:30:00Z"
// ... resto do exemplo ...

Instance: SymptomQuestionnaireExample
InstanceOf: SymptomQuestionnaire
Usage: #example
Description: "Symptom assessment questionnaire example"
Title: "Symptom Assessment Questionnaire Example"
* status = #active
* title = "Daily Symptom Assessment"
* item[symptomType].linkId = "symptom-type"
* item[symptomType].text = "Type of Symptom"
* item[symptomType].type = #choice
* item[symptomType].required = true
* item[location].linkId = "location"
* item[location].text = "Location"
* item[location].type = #string
* item[onset].linkId = "onset"
* item[onset].text = "When did it start?"
* item[onset].type = #dateTime
* item[description].linkId = "description"
* item[description].text = "Description"
* item[description].type = #text
