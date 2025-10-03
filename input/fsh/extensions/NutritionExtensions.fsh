Extension: NutritionDataSource
Id: nutrition-data-source
Title: "Nutrition Data Source Extension"
Description: "Indicates the source of nutrition data"
* ^experimental = false

* ^version = "0.1.0"
* ^status = #draft
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
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"
* ^context[0].type = #fhirpath
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from NutritionDataSourceVS (required)

ValueSet: NutritionDataSourceVS
Id: nutrition-data-source-vs
Title: "Nutrition Data Source Value Set"
Description: "Value set for nutrition data sources"
* ^experimental = false

* ^version = "0.1.0"
* ^status = #draft
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
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"

* codes from system NutritionDataSourceCS

CodeSystem: NutritionDataSourceCS
Id: nutrition-data-source-cs
Title: "Nutrition Data Source Code System"
Description: "Code system for nutrition data sources"
* ^experimental = false

* ^version = "0.1.0"
* ^status = #draft
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
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"
* ^caseSensitive = true

* #manual "Manual Entry" "Data entered manually by user"
* #app "App Integration" "Data from integrated third-party apps"
* #device "Connected Device" "Data from connected nutrition tracking devices"
* #questionnaire "Questionnaire Response" "Data collected through questionnaires"
