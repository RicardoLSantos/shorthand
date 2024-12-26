
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

Profile: MobilityGoal
Parent: Goal
Id: mobility-goal
Title: "Mobility Goal Profile"
Description: "Profile for mobility improvement goals"

* lifecycleStatus MS
* achievementStatus MS
* category MS
* description MS
* subject 1..1 MS
* target MS
  * measure MS
  * detail[x] MS
  * due[x] MS

* expressedBy MS
* addresses MS
* note MS

Profile: MobilityCarePlan
Parent: CarePlan
Id: mobility-care-plan
Title: "Mobility Care Plan Profile"
Description: "Profile for mobility enhancement plans"

* status MS
* intent MS
* category MS
* title MS
* description MS
* subject 1..1 MS
* period MS
* created MS
* author MS
* careTeam MS
* addresses MS
* goal MS
* activity MS
  * outcomeReference MS
  * progress MS
  * plannedActivityDetail MS
    * kind MS
    * code MS
    * status MS
    * location MS
    * performer MS
    * description MS

EOF
