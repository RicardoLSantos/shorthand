ValueSet: BalanceStatusValueSet
Id: balance-status
Title: "Balance Status Value Set"
Description: "Value set for walking steadiness balance status"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/balance-status"
* ^status = #active
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/balance-status

CodeSystem: BalanceStatusCodeSystem
Id: balance-status
Title: "Balance Status Code System"
Description: "Code system for balance status types"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/balance-status"
* ^status = #active
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^caseSensitive = true
* #veryStable "Very Stable"
* #stable "Stable"
* #slightlyUnstable "Slightly Unstable"
* #unstable "Unstable"
* #veryUnstable "Very Unstable"
