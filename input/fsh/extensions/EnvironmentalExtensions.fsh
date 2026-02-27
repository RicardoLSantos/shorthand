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
* ^context[+].type = #element
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
* ^context[+].type = #element
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
* ^experimental = false
* codes from system AppLogicCS

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
* ^experimental = false
* codes from system AppLogicCS
