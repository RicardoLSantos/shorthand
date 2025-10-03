Extension: ExposureLocation
Id: exposure-location
Title: "Exposure Location Extension"
Description: "Extension for recording location of environmental exposure measurement"

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
* ^context[+].type = #fhirpath
* ^context[=].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from ExposureLocationVS (required)
* valueCodeableConcept ^short = "Location type of exposure"
* valueCodeableConcept ^definition = "Categorizes the type of location where environmental exposure occurred"

Extension: ExposureConditions
Id: exposure-conditions
Title: "Exposure Conditions Extension"
Description: "Additional conditions during environmental exposure measurement"

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
* ^context[+].type = #fhirpath
* ^context[=].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from ExposureConditionsVS (required)
* valueCodeableConcept ^short = "Conditions during exposure"

ValueSet: ExposureLocationVS
Id: exposure-location-vs
Title: "Exposure Location Value Set"
Description: "Value set for environmental exposure locations"

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
* ^experimental = true
* codes from system ExposureLocationCS

ValueSet: ExposureConditionsVS
Id: exposure-conditions-vs
Title: "Exposure Conditions Value Set"
Description: "Value set for environmental exposure conditions"

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
* ^experimental = true
* codes from system ExposureConditionsCS

CodeSystem: ExposureLocationCS
Id: exposure-location-cs
Title: "Exposure Location Code System"
Description: "Code system for environmental exposure locations"

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
* ^caseSensitive = true
* ^experimental = true

* #indoor "Indoor environment" "Environment within buildings or enclosed spaces"
* #outdoor "Outdoor environment" "Open-air environment"
* #workplace "Workplace" "Professional or occupational environment"
* #transit "In transit" "While in transportation or commuting"
* #recreational "Recreational area" "Leisure or sports facilities"
* #urban "Urban area" "City or densely populated area"
* #rural "Rural area" "Countryside or sparsely populated area"

CodeSystem: ExposureConditionsCS
Id: exposure-conditions-cs
Title: "Exposure Conditions Code System"
Description: "Code system for conditions during environmental exposure"

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
* ^caseSensitive = true
* ^experimental = true

* #normal "Normal conditions" "Standard environmental conditions"
* #extreme "Extreme conditions" "Unusual or severe environmental conditions"
* #controlled "Controlled environment" "Environment with controlled conditions"
* #variable "Variable conditions" "Changing environmental conditions"
