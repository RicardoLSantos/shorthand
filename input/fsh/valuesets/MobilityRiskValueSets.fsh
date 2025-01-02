ValueSet: FallRiskOutcomesValueSet
Id: fall-risk-outcomes-valueset
Title: "Fall Risk Outcomes Value Set"
Description: "Value set for fall risk assessment outcomes"
* ^url = "http://example.org/ValueSet/fall-risk-outcomes-valueset"
* ^status = #active
* include codes from system http://example.org/CodeSystem/fall-risk-outcomes-codesystem

CodeSystem: FallRiskOutcomesCodeSystem
Id: fall-risk-outcomes-codesystem
Title: "Fall Risk Outcomes Code System"
* ^url = "http://example.org/CodeSystem/fall-risk-outcomes-codesystem"
* ^status = #active
* ^caseSensitive = true
* #noRisk "No Risk of Falls"
* #lowRisk "Low Risk of Falls"
* #moderateRisk "Moderate Risk of Falls"
* #highRisk "High Risk of Falls"

ValueSet: RiskLevelValueSet
Id: risk-level-valueset
Title: "Risk Level Value Set"
Description: "Value set for general risk levels"
* ^url = "http://example.org/ValueSet/risk-level-valueset"
* ^status = #active
* include codes from system http://example.org/CodeSystem/risk-level-codesystem

CodeSystem: RiskLevelCodeSystem
Id: risk-level-codesystem
Title: "Risk Level Code System"
* ^url = "http://example.org/CodeSystem/risk-level-codesystem"
* ^status = #active
* ^caseSensitive = true
* #none "No Risk"
* #low "Low Risk"
* #moderate "Moderate Risk"
* #high "High Risk"
* #critical "Critical Risk"

ValueSet: MobilityDeclineOutcomesValueSet
Id: mobility-decline-outcomes-valueset
Title: "Mobility Decline Outcomes Value Set"
Description: "Value set for mobility decline assessment outcomes"
* ^url = "http://example.org/ValueSet/mobility-decline-outcomes-valueset"
* ^status = #active
* include codes from system http://example.org/CodeSystem/mobility-decline-outcomes-codesystem

CodeSystem: MobilityDeclineOutcomesCodeSystem
Id: mobility-decline-outcomes-codesystem
Title: "Mobility Decline Outcomes Code System"
* ^url = "http://example.org/CodeSystem/mobility-decline-outcomes-codesystem"
* ^status = #active
* ^caseSensitive = true
* #stable "Stable Mobility"
* #minorDecline "Minor Decline"
* #moderateDecline "Moderate Decline"
* #severeDecline "Severe Decline"

ValueSet: AssistanceLevelOutcomesValueSet
Id: assistance-level-outcomes-valueset
Title: "Assistance Level Outcomes Value Set"
Description: "Value set for assistance level assessment outcomes"
* ^url = "http://example.org/ValueSet/assistance-level-outcomes-valueset"
* ^status = #active
* include codes from system http://example.org/CodeSystem/assistance-level-outcomes-codesystem

CodeSystem: AssistanceLevelOutcomesCodeSystem
Id: assistance-level-outcomes-codesystem
Title: "Assistance Level Outcomes Code System"
* ^url = "http://example.org/CodeSystem/assistance-level-outcomes-codesystem"
* ^status = #active
* ^caseSensitive = true
* #independent "Independent"
* #minimalAssistance "Minimal Assistance Needed"
* #moderateAssistance "Moderate Assistance Needed"
* #maximumAssistance "Maximum Assistance Needed"
