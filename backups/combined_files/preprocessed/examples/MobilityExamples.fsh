// Originally defined on lines 1 - 18
Profile: WalkingSteadinessObservation
Parent: MobilityProfile
Id: walking-steadiness-observation
Title: "Walking Steadiness Observation Profile"
Description: "Profile for assessing walking steadiness and balance"
* code = http://loinc.org#LA32-8 "Balance"
* component contains
    balanceScore 0.. and
    balanceStatus 0..
* component[balanceScore] 0..1
* component[balanceScore] MS
* component[balanceStatus] 0..1
* component[balanceStatus] MS
* component[balanceScore].code = http://loinc.org#LA32-8 "Balance score"
* component[balanceScore].valueQuantity.system = "http://unitsofmeasure.org"
* component[balanceScore].valueQuantity.code = #%
* component[balanceStatus].code = http://loinc.org#LA32-9 "Balance status"
* component[balanceStatus].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/balance-status (required)

// Originally defined on lines 20 - 38
Profile: WalkingSpeedObservation
Parent: MobilityProfile
Id: walking-speed-observation
Title: "Walking Speed Observation Profile"
Description: "Profile for measuring walking speed as part of mobility assessment"
* code = http://loinc.org#LA29042-4 "Walking speed"
* component contains
    speed 0.. and
    distance 0..
* component[speed] 0..1
* component[speed] MS
* component[distance] 0..1
* component[distance] MS
* component[speed].code = http://loinc.org#LA29042-4 "Walking speed measurement"
* component[speed].valueQuantity.system = "http://unitsofmeasure.org"
* component[speed].valueQuantity.code = #m/s
* component[distance].code = http://loinc.org#LA29043-2 "Walking distance"
* component[distance].valueQuantity.system = "http://unitsofmeasure.org"
* component[distance].valueQuantity.code = #m

// Originally defined on lines 40 - 55
Instance: WalkingSteadinessExample
InstanceOf: WalkingSteadinessObservation
Title: "Walking Steadiness Measurement Example"
Description: "Walking steadiness observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = http://loinc.org#LA32-8 "Balance"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 85 '1' "score"
* device = Reference(Device/iphone-example)
* component[balanceScore].valueQuantity = 85 '%' "percent"
* component[balanceStatus].valueCodeableConcept = http://loinc.org#LA32-10 "OK"

// Originally defined on lines 57 - 72
Instance: WalkingSpeedExample
InstanceOf: WalkingSpeedObservation
Title: "Walking Speed Measurement Example"
Description: "Walking speed observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = http://loinc.org#LA29042-4 "Walking speed"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 1.2 'm/s' "meters per second"
* device = Reference(Device/iphone-example)
* component[speed].valueQuantity = 1.2 'm/s' "meters per second"
* component[distance].valueQuantity = 10 'm' "meters"

