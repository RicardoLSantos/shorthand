Profile: WalkingSteadinessObservation
Parent: MobilityProfile
Id: walking-steadiness-observation
Description: "Profile for assessing walking steadiness and balance"
Title: "Walking Steadiness Observation Profile"

* code = $LIFESTYLEOBS#balance-assessment "Balance assessment"
* component contains
    balanceScore 0..1 MS and
    balanceStatus 0..1 MS

* component[balanceScore]
  * code = $LIFESTYLEOBS#walking-steadiness "Walking steadiness measurement"
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #%

* component[balanceStatus]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#balance-status "Balance status"
  * valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/balance-status (required)

Profile: WalkingSpeedObservation
Parent: MobilityProfile
Id: walking-speed-observation
Description: "Profile for measuring walking speed as part of mobility assessment"Title: "Walking Speed Observation Profile"

* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#gait-assessment "Gait assessment"
* component contains
    speed 0..1 MS and
    distance 0..1 MS

* component[speed]
  * code = $LIFESTYLEOBS#walking-speed "Walking speed measurement"
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #m/s

* component[distance]
  * code = $LIFESTYLEOBS#walking-distance "Walking distance measurement"
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #m

Instance: WalkingSteadinessExample
InstanceOf: WalkingSteadinessObservation
Usage: #example
Description: "Walking steadiness observation example"
Title: "Walking Steadiness Measurement Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LIFESTYLEOBS#balance-assessment "Balance assessment"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(Device/iphone-example)

* component[balanceScore].valueQuantity = 85 '%' "percent"
* component[balanceStatus].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/balance-status#normal "Normal"

Instance: WalkingSpeedExample
InstanceOf: WalkingSpeedObservation
Usage: #example
Description: "Walking speed observation example"
Title: "Walking Speed Measurement Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#gait-assessment "Gait assessment"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 1.2 'm/s' "meters per second"
* device = Reference(Device/iphone-example)

* component[speed].valueQuantity = 1.2 'm/s' "meters per second"
* component[distance].valueQuantity = 10 'm' "meters"
