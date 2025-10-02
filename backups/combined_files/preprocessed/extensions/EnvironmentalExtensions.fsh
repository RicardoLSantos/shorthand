// Originally defined on lines 1 - 14
Extension: ExposureLocation
Parent: Extension
Id: exposure-location
Title: "Exposure Location Extension"
Description: "Extension for recording location of environmental exposure measurement"
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from ExposureLocationVS (required)
* valueCodeableConcept ^short = "Location type of exposure"
* valueCodeableConcept ^definition = "Categorizes the type of location where environmental exposure occurred"
* extension 0..0

// Originally defined on lines 16 - 28
Extension: ExposureConditions
Parent: Extension
Id: exposure-conditions
Title: "Exposure Conditions Extension"
Description: "Additional conditions during environmental exposure measurement"
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from ExposureConditionsVS (required)
* valueCodeableConcept ^short = "Conditions during exposure"
* extension 0..0

// Originally defined on lines 30 - 38
ValueSet: ExposureLocationVS
Id: exposure-location-vs
Title: "Exposure Location Value Set"
Description: "Value set for environmental exposure locations"
* ^version = "0.1.0"
* ^status = #draft
* ^experimental = true
* include codes from system ExposureLocationCS

// Originally defined on lines 40 - 48
ValueSet: ExposureConditionsVS
Id: exposure-conditions-vs
Title: "Exposure Conditions Value Set"
Description: "Value set for environmental exposure conditions"
* ^version = "0.1.0"
* ^status = #draft
* ^experimental = true
* include codes from system ExposureConditionsCS

// Originally defined on lines 50 - 66
CodeSystem: ExposureLocationCS
Id: exposure-location-cs
Title: "Exposure Location Code System"
Description: "Code system for environmental exposure locations"
* ^version = "0.1.0"
* ^status = #draft
* ^caseSensitive = true
* ^experimental = true
* #indoor "Indoor environment" "Environment within buildings or enclosed spaces"
* #outdoor "Outdoor environment" "Open-air environment"
* #workplace "Workplace" "Professional or occupational environment"
* #transit "In transit" "While in transportation or commuting"
* #recreational "Recreational area" "Leisure or sports facilities"
* #urban "Urban area" "City or densely populated area"
* #rural "Rural area" "Countryside or sparsely populated area"

// Originally defined on lines 68 - 81
CodeSystem: ExposureConditionsCS
Id: exposure-conditions-cs
Title: "Exposure Conditions Code System"
Description: "Code system for conditions during environmental exposure"
* ^version = "0.1.0"
* ^status = #draft
* ^caseSensitive = true
* ^experimental = true
* #normal "Normal conditions" "Standard environmental conditions"
* #extreme "Extreme conditions" "Unusual or severe environmental conditions"
* #controlled "Controlled environment" "Environment with controlled conditions"
* #variable "Variable conditions" "Changing environmental conditions"

