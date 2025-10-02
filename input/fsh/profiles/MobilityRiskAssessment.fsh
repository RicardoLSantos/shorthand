Profile: MobilityRiskAssessment
Parent: RiskAssessment
Id: mobility-risk-assessment
Title: "Mobility Risk Assessment Profile"
Description: "Profile for assessing mobility-related risks"

* status MS
* subject 1..1 MS
* occurrence[x] MS
* prediction MS
  * outcome MS
  * probability[x] MS
  * qualitativeRisk MS

* method MS
  * coding ^slicing.discriminator.type = #value
  * coding ^slicing.discriminator.path = "$this"
  * coding ^slicing.rules = #open
  * coding contains
      mobilityAssessment 1..1 MS

* method.coding[mobilityAssessment] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mobility-assessment-method#standardized "Standardized Test"

* prediction ^slicing.discriminator.type = #value
* prediction ^slicing.discriminator.path = "outcome"
* prediction ^slicing.rules = #open

* prediction contains
    fallRisk 0..1 MS and
    mobilityDecline 0..1 MS and
    assistanceNeeded 0..1 MS

* prediction[fallRisk].outcome from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fall-risk-outcomes
* prediction[fallRisk].probabilityDecimal 0..1 MS
* prediction[fallRisk].qualitativeRisk from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/risk-level

* prediction[mobilityDecline].outcome from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mobility-decline-outcomes
* prediction[mobilityDecline].probabilityDecimal 0..1 MS
* prediction[mobilityDecline].qualitativeRisk from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/risk-level

* prediction[assistanceNeeded].outcome from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/assistance-level-outcomes
* prediction[assistanceNeeded].probabilityDecimal 0..1 MS
* prediction[assistanceNeeded].qualitativeRisk from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/risk-level

* basis only Reference(MobilityProfile or Observation or QuestionnaireResponse)
* basis MS

* note MS
