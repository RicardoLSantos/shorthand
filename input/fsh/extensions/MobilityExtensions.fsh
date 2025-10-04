Extension: MobilityAlertLevel
Id: mobility-alert-level
Title: "Mobility Alert Level Extension"
Description: "Extension for mobility measurements alert levels to indicate the severity or concern level of mobility changes detected by the device"
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
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* . ^short = "Mobility alert level indicator"
* . ^definition = "Indicates the severity level of mobility changes or concerns based on device measurements"
* value[x] only CodeableConcept
* valueCodeableConcept from MobilityAlertLevelVS (required)
* valueCodeableConcept ^short = "Alert level code"
* valueCodeableConcept ^definition = "The specific alert level code indicating the severity of mobility changes"

ValueSet: MobilityAlertLevelVS
Id: mobility-alert-level-vs
Title: "Mobility Alert Level Value Set"
Description: "Value set for mobility measurement alert levels used to categorize the severity of mobility changes or concerns"
* ^experimental = false
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
* ^purpose = "To provide standardized alert levels for mobility measurements"
* codes from system MobilityAlertLevelCS

CodeSystem: MobilityAlertLevelCS
Id: mobility-alert-level-cs
Title: "Mobility Alert Level Code System"
Description: "Code system defining alert levels for mobility measurements, indicating the severity of changes in mobility patterns"
* ^experimental = false
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
* ^content = #complete
* #green "Normal - No concern" "Mobility measurements are within normal range and show no concerning patterns"
* #yellow "Caution - Monitor closely" "Mobility measurements show slight deviations that warrant closer monitoring"
* #red "Alert - Significant change" "Mobility measurements indicate significant changes that require immediate attention"
* ^property[0].code = #status
* ^property[0].uri = "http://hl7.org/fhir/concept-properties#status"
* ^property[0].type = #code
* ^property[0].description = "The status of the alert level"
* ^property[1].code = #severity
* ^property[1].uri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mobility-alert-level-cs#severity"
* ^property[1].type = #integer
* ^property[1].description = "Numeric value indicating severity (1=low, 3=high)"
