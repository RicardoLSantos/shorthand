ValueSet: BalanceStatusValueSet
Id: balance-status
Title: "Balance Status Value Set"
Description: "Value set for walking steadiness balance status"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/balance-status"
* ^status = #active
* ^version = "0.1.0"
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* LifestyleMedicineTemporaryCS#balance-status-normal "Normal"
* LifestyleMedicineTemporaryCS#veryStable "Very Stable"
* LifestyleMedicineTemporaryCS#balance-status-stable "Stable"
* LifestyleMedicineTemporaryCS#slightlyUnstable "Slightly Unstable"
* LifestyleMedicineTemporaryCS#unstable "Unstable"
* LifestyleMedicineTemporaryCS#veryUnstable "Very Unstable"
