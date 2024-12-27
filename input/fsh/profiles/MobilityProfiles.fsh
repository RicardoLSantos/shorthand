Profile: MobilityProfile
Parent: Observation
Id: mobility-profile
Title: "Mobility Profile"
Description: "Profile for mobility data from iOS Health App"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1 MS
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* device 0..1 MS

* component MS
  * code MS
  * value[x] MS

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
  * coding 1..* MS
  * coding ^slicing.discriminator.type = #pattern
  * coding ^slicing.discriminator.path = "$this"
  * coding ^slicing.rules = #open
  * coding contains
      mobilityAssessment 1..1 MS
