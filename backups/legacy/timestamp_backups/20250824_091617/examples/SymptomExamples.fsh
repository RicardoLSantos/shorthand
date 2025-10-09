Instance: ChronicSymptomExample
InstanceOf: Observation
Usage: #example
Description: "Chronic symptom observation example"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#267036007 "Fatigue"
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
* code = $SCT#246604007 "Symptom severity"
* subject = Reference(Patient/PatientExample)
* performer = Reference(Practitioner/PractitionerExample)
* effectiveDateTime = "2024-03-19T10:30:00Z"
// ... resto do exemplo ...
