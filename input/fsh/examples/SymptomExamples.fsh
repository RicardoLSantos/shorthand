Instance: ChronicSymptomExample
InstanceOf: Observation
Usage: #example
Title: "Chronic Symptom Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#267036007 "Fatigue"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T14:00:00Z"

* component[0]
  * code = $LOINC#72514-3 "Severity score"
  * valueInteger = 7
* component[1]
  * code = $LOINC#103332-8 "Duration"
  * valueQuantity = 30 'd'
* component[2]
  * code = $LOINC#103334-4 "Frequency"
  * valueString = "Daily occurrence"
