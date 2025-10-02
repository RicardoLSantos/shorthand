// Originally defined on lines 1 - 10
Instance: ChronicSymptomExample
InstanceOf: Observation
Description: "Chronic symptom observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = http://snomed.info/sct#267036007 "Fatigue"
* subject = Reference(Patient/PatientExample)
* performer = Reference(Practitioner/PractitionerExample)
* effectiveDateTime = "2024-03-19T14:00:00Z"

// Originally defined on lines 13 - 22
Instance: ExampleSymptomSeverity
InstanceOf: Observation
Description: "Symptom severity observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = http://snomed.info/sct#246604007 "Symptom severity"
* subject = Reference(Patient/PatientExample)
* performer = Reference(Practitioner/PractitionerExample)
* effectiveDateTime = "2024-03-19T10:30:00Z"

