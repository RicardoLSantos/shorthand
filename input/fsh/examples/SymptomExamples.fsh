Instance: ChronicSymptomExample
InstanceOf: Observation
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#267036007 "Fatigue"
* subject = Reference(Patient/example)
* performer = Reference(Practitioner/example)
* effectiveDateTime = "2024-03-19T14:00:00Z"
// ... resto do exemplo ...

Instance: ExampleSymptomSeverity
InstanceOf: Observation
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#246604007 "Symptom severity"
* subject = Reference(Patient/example)
* performer = Reference(Practitioner/example)
* effectiveDateTime = "2024-03-19T10:30:00Z"
// ... resto do exemplo ...
