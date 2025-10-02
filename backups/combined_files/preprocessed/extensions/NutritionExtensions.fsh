// Originally defined on lines 1 - 15
Extension: NutritionDataSource
Parent: Extension
Id: nutrition-data-source
Title: "Nutrition Data Source Extension"
Description: "Indicates the source of nutrition data"
* ^experimental = false
* ^version = "0.1.0"
* ^status = #draft
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from NutritionDataSourceVS (required)
* extension 0..0

// Originally defined on lines 17 - 28
ValueSet: NutritionDataSourceVS
Id: nutrition-data-source-vs
Title: "Nutrition Data Source Value Set"
Description: "Value set for nutrition data sources"
* ^experimental = false
* ^version = "0.1.0"
* ^status = #draft
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"
* include codes from system NutritionDataSourceCS

// Originally defined on lines 30 - 45
CodeSystem: NutritionDataSourceCS
Id: nutrition-data-source-cs
Title: "Nutrition Data Source Code System"
Description: "Code system for nutrition data sources"
* ^experimental = false
* ^version = "0.1.0"
* ^status = #draft
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"
* ^caseSensitive = true
* #manual "Manual Entry" "Data entered manually by user"
* #app "App Integration" "Data from integrated third-party apps"
* #device "Connected Device" "Data from connected nutrition tracking devices"
* #questionnaire "Questionnaire Response" "Data collected through questionnaires"

