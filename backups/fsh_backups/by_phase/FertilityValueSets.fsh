ValueSet: CervicalMucusValueSet
Id: cervical-mucus-valueset
Title: "Cervical Mucus Value Set"
Description: "Value set for cervical mucus observations"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cervical-mucus-vs"
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
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cervical-mucus-cs

CodeSystem: CervicalMucusCodeSystem
Id: cervical-mucus-cs
Description: "Code system for cervical mucus classification"Title: "Cervical Mucus Code System"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cervical-mucus-cs"
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
* #dry "Dry"
* #sticky "Sticky"
* #creamy "Creamy"
* #watery "Watery"
* #eggWhite "Egg White"

ValueSet: OvulationTestValueSet
Id: ovulation-test-valueset
Title: "Ovulation Test Value Set"
Description: "Value set for ovulation test results"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/ovulation-test-vs"
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
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/ovulation-test-cs

CodeSystem: OvulationTestCodeSystem
Id: ovulation-test-cs
Description: "Code system for ovulation test results"Title: "Ovulation Test Code System"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/ovulation-test-cs"
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
* #negative "Negative"
* #positive "Positive"
* #invalid "Invalid Test"

ValueSet: FertilityStatusValueSet
Id: fertility-status-valueset
Title: "Fertility Status Value Set"
Description: "Value set for fertility status"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fertility-status-vs"
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
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fertility-status-cs

CodeSystem: FertilityStatusCodeSystem
Id: fertility-status-cs
Description: "Code system for fertility status indicators"Title: "Fertility Status Code System"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fertility-status-cs"
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
* #fertile "Fertile"
* #notFertile "Not Fertile"
* #uncertain "Uncertain"
