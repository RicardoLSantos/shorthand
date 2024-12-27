Instance: ChronicSymptomExample
InstanceOf: SymptomObservation
Usage: #example
Title: "Chronic Symptom Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#267036007 "Fatigue"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T14:00:00Z"

* component[severity].valueInteger = 7
* component[duration].valueQuantity = 30 'day' 
* component[frequency].valueString = "Daily occurrence"
