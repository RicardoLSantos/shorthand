// Originally defined on lines 1 - 48
Profile: MobilityRiskAssessment
Parent: RiskAssessment
Id: mobility-risk-assessment
Title: "Mobility Risk Assessment Profile"
Description: "Profile for assessing mobility-related risks"
* status MS
* subject 1..1
* subject MS
* occurrence[x] MS
* prediction MS
* prediction.outcome MS
* prediction.probability[x] MS
* prediction.qualitativeRisk MS
* method MS
* method.coding ^slicing.discriminator.type = #value
* method.coding ^slicing.discriminator.path = "$this"
* method.coding ^slicing.rules = #open
* method.coding contains mobilityAssessment 0..
* method.coding[mobilityAssessment] 1..1
* method.coding[mobilityAssessment] MS
* method.coding[mobilityAssessment] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mobility-assessment-method#standardized "Standardized Mobility Assessment"
* prediction ^slicing.discriminator.type = #value
* prediction ^slicing.discriminator.path = "outcome"
* prediction ^slicing.rules = #open
* prediction contains
    fallRisk 0.. and
    mobilityDecline 0.. and
    assistanceNeeded 0..
* prediction[fallRisk] 0..1
* prediction[fallRisk] MS
* prediction[mobilityDecline] 0..1
* prediction[mobilityDecline] MS
* prediction[assistanceNeeded] 0..1
* prediction[assistanceNeeded] MS
* prediction[fallRisk].outcome from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fall-risk-outcomes (required)
* prediction[fallRisk].probabilityDecimal 0..1
* prediction[fallRisk].probabilityDecimal MS
* prediction[fallRisk].qualitativeRisk from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/risk-level (required)
* prediction[mobilityDecline].outcome from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mobility-decline-outcomes (required)
* prediction[mobilityDecline].probabilityDecimal 0..1
* prediction[mobilityDecline].probabilityDecimal MS
* prediction[mobilityDecline].qualitativeRisk from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/risk-level (required)
* prediction[assistanceNeeded].outcome from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/assistance-level-outcomes (required)
* prediction[assistanceNeeded].probabilityDecimal 0..1
* prediction[assistanceNeeded].probabilityDecimal MS
* prediction[assistanceNeeded].qualitativeRisk from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/risk-level (required)
* basis only Reference(MobilityProfile or Observation or QuestionnaireResponse)
* basis MS
* note MS

