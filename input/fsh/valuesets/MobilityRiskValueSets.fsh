ValueSet: FallRiskOutcomesValueSet
Id: fall-risk-outcomes
Title: "Fall Risk Outcomes Value Set"
Description: "Value set for fall risk assessment outcomes"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fall-risk-outcomes"
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* LifestyleMedicineTemporaryCS#fall-risk-low-risk "Low Risk"
* LifestyleMedicineTemporaryCS#fall-risk-moderate-risk "Moderate Risk"
* LifestyleMedicineTemporaryCS#fall-risk-high-risk "High Risk"
* LifestyleMedicineTemporaryCS#fall-occurred "Fall Occurred"
* LifestyleMedicineTemporaryCS#near-fall "Near Fall"
* LifestyleMedicineTemporaryCS#recurrent-falls "Recurrent Falls"
* LifestyleMedicineTemporaryCS#fall-with-injury "Fall with Injury"

ValueSet: RiskLevelValueSet
Id: risk-level
Title: "Risk Level Value Set"
Description: "Value set for general risk levels"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/risk-level"
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* AppLogicCS#risk-level-none "None"
* AppLogicCS#risk-level-low "Low"
* AppLogicCS#risk-level-moderate "Moderate"
* AppLogicCS#risk-level-high "High"
* AppLogicCS#risk-level-critical "Critical"
* AppLogicCS#risk-level-unknown "Unknown"

ValueSet: MobilityDeclineOutcomesValueSet
Id: mobility-decline-outcomes
Title: "Mobility Decline Outcomes Value Set"
Description: "Value set for mobility decline assessment outcomes"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mobility-decline-outcomes"
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* LifestyleMedicineTemporaryCS#no-decline "No Decline"
* LifestyleMedicineTemporaryCS#mild-decline "Mild Decline"
* LifestyleMedicineTemporaryCS#moderate-decline "Moderate Decline"
* LifestyleMedicineTemporaryCS#severe-decline "Severe Decline"
* LifestyleMedicineTemporaryCS#improved "Improved"
* LifestyleMedicineTemporaryCS#rapid-decline "Rapid Decline"
* LifestyleMedicineTemporaryCS#plateau "Plateau"

ValueSet: AssistanceLevelOutcomesValueSet
Id: assistance-level-outcomes
Title: "Assistance Level Outcomes Value Set"
Description: "Value set for assistance level assessment outcomes"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/assistance-level-outcomes"
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* AppLogicCS#independent "Independent"
* AppLogicCS#minimal-assist "Minimal Assistance"
* AppLogicCS#moderate-assist "Moderate Assistance"
* AppLogicCS#maximal-assist "Maximal Assistance"
* AppLogicCS#dependent "Dependent"
