Instance: PhysicalActivityExample1
InstanceOf: PhysicalActivityObservation
Usage: #example
Title: "Example of Walking Activity"
Description: "Example of walking activity data from iOS Health App"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $SNOMED#228557008 "Walking"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T15:30:00Z"

* component[steps].code = $LOINC#55423-8 "Number of steps in 24 hour Measured"
* component[steps].valueQuantity = 8546 '1' "steps"

* component[distance].code = $LOINC#55430-3 "Distance walked"
* component[distance].valueQuantity = 6.2 'km' "kilometers"

* component[duration].code = $LOINC#55411-3 "Exercise duration"
* component[duration].valueQuantity = 72 'min' "minutes"

* component[energy].code = $LOINC#55424-6 "Energy expenditure"
* component[energy].valueQuantity = 320 'kcal' "kilocalories"
