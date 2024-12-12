Instance: HeartRateExample
InstanceOf: HeartRateObservation
Usage: #example
Title: "Heart Rate Measurement Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#8867-4 "Heart rate"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 72 '/min'

* component[heartRateVariability].code = $LOINC#80404-7
* component[heartRateVariability].valueQuantity = 45 'ms'

Instance: BloodPressureExample
InstanceOf: BloodPressureObservation
Usage: #example
Title: "Blood Pressure Measurement Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#85354-9 "Blood pressure panel"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T15:30:00Z"

* component[systolic].code = $LOINC#8480-6
* component[systolic].valueQuantity = 120 'mm[Hg]'

* component[diastolic].code = $LOINC#8462-4
* component[diastolic].valueQuantity = 80 'mm[Hg]'
