Profile: WalkingSteadinessObservation
Parent: MobilityProfile
Id: walking-steadiness-observation
Title: "Walking Steadiness Observation Profile"
Description: "Profile for walking steadiness measurements from iPhone Motion Sensors"

* code = $LOINC#LA32-8 "Balance"
* component contains
    balanceScore 0..1 MS and
    balanceStatus 0..1 MS

* component[balanceScore]
  * code = $LOINC#LA32-8 "Balance score"
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #%

* component[balanceStatus]
  * code = $LOINC#LA32-9 "Balance status"
  * valueCodeableConcept from https://github.com/RicardoLSantos/shorthand/fhir/ValueSet/balance-status (required)

Profile: WalkingSpeedObservation
Parent: MobilityProfile
Id: walking-speed-observation
Title: "Walking Speed Observation Profile"
Description: "Profile for walking speed measurements from iPhone Motion Sensors"

* code = $LOINC#LA29042-4 "Walking speed"
* component contains
    speed 0..1 MS and
    distance 0..1 MS

* component[speed]
  * code = $LOINC#LA29042-4 "Walking speed measurement"
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #m/s

* component[distance]
  * code = $LOINC#LA29043-2 "Walking distance"
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #m

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

* component[balanceScore].valueQuantity = 85 '%' "percent"
* component[balanceStatus].valueCodeableConcept = $LOINC#LA32-10 "OK"

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

* component[speed].valueQuantity = 1.2 'm/s' "meters per second"
* component[distance].valueQuantity = 10 'm' "meters"
