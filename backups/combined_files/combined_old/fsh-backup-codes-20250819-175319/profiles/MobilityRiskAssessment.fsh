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
  * coding ^slicing.discriminator.type = #pattern
  * coding ^slicing.discriminator.path = "$this"
  * coding ^slicing.rules = #open
  * coding contains
      mobilityAssessment 1..1 MS

* method.coding[mobilityAssessment] = https://github.com/RicardoLSantos/shorthand/CodeSystem/mobility-assessment-method#standardized "Standardized Mobility Assessment"

* prediction ^slicing.discriminator.type = #pattern
* prediction ^slicing.discriminator.path = "outcome"
* prediction ^slicing.rules = #open

* prediction contains
    fallRisk 0..1 MS and
    mobilityDecline 0..1 MS and
    assistanceNeeded 0..1 MS

* prediction[fallRisk].outcome from https://github.com/RicardoLSantos/shorthand/ValueSet/fall-risk-outcomes
* prediction[fallRisk].probabilityDecimal 0..1 MS
* prediction[fallRisk].qualitativeRisk from https://github.com/RicardoLSantos/shorthand/ValueSet/risk-level

* prediction[mobilityDecline].outcome from https://github.com/RicardoLSantos/shorthand/ValueSet/mobility-decline-outcomes
* prediction[mobilityDecline].probabilityDecimal 0..1 MS
* prediction[mobilityDecline].qualitativeRisk from https://github.com/RicardoLSantos/shorthand/ValueSet/risk-level

* prediction[assistanceNeeded].outcome from https://github.com/RicardoLSantos/shorthand/ValueSet/assistance-level-outcomes
* prediction[assistanceNeeded].probabilityDecimal 0..1 MS
* prediction[assistanceNeeded].qualitativeRisk from https://github.com/RicardoLSantos/shorthand/ValueSet/risk-level

* basis only Reference(MobilityProfile or Observation or QuestionnaireResponse)
* basis MS

* note MS
