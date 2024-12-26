Instance: WalkingSteadinessExample
InstanceOf: WalkingSteadinessObservation
Usage: #example
Title: "Walking Steadiness Measurement Example"
Description: "Example of walking steadiness measurement from iPhone Motion Sensors"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LOINC#LA32-8 "Balance"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 85 '1' "score"
* device = Reference(Device/iphone-example)
* component[+].code = $LOINC#LA32-8 "Balance score"
* component[=].valueQuantity = 85 '%' "percent"
* component[+].code = $LOINC#LA32-9 "Balance status"
* component[=].valueCodeableConcept = $LOINC#LA32-10 "OK"

Instance: WalkingSpeedExample
InstanceOf: WalkingSpeedObservation
Usage: #example
Title: "Walking Speed Measurement Example"
Description: "Example of walking speed measurement from iPhone Motion Sensors"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LOINC#LA29042-4 "Walking speed"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 1.2 'm/s' "meters per second"
* device = Reference(Device/iphone-example)
* component[+].code = $LOINC#LA29042-4 "Walking speed measurement"
* component[=].valueQuantity = 1.2 'm/s' "meters per second"
* component[+].code = $LOINC#LA29043-2 "Walking distance"
* component[=].valueQuantity = 10 'm' "meters"
