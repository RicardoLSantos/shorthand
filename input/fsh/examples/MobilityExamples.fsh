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
* performer = Reference(Practitioner/PractitionerExample)
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
* performer = Reference(Practitioner/PractitionerExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#gait-assessment "Gait assessment"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 1.2 'm/s' "meters per second"
* device = Reference(Device/iphone-example)

* component[speed].valueQuantity = 1.2 'm/s' "meters per second"
* component[distance].valueQuantity = 10 'm' "meters"

Instance: MobilityProfileExample
InstanceOf: MobilityProfile
Usage: #example
Description: "Comprehensive mobility assessment example"
Title: "Mobility Profile Assessment Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T09:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/iphone-example)
* code = $LIFESTYLEOBS#balance-assessment "Balance assessment"
* component[steadiness].valueQuantity = 82 '%' "percent"
* component[balance].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/balance-status#normal "Normal"
* component[gait].valueQuantity = 1.1 'm/s' "meters per second"
* component[movement].valueString = "Independent ambulation"

Instance: MobilityRiskAssessmentExample
InstanceOf: MobilityRiskAssessment
Usage: #example
Description: "Mobility risk assessment example"
Title: "Mobility Risk Assessment Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* occurrenceDateTime = "2024-03-19T09:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* basis = Reference(MobilityProfileExample)
* prediction[fallRisk].outcome = $SCT#217082002 "Fall risk"
* prediction[fallRisk].probabilityDecimal = 0.15
* prediction[fallRisk].qualitativeRisk = http://terminology.hl7.org/CodeSystem/risk-probability#low "Low risk"
* note.text = "Patient shows good mobility metrics with low fall risk based on walking steadiness assessment"
