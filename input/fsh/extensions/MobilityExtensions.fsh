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
* valueCodeableConcept from MobilityAlertLevelVS (extensible)
* valueCodeableConcept ^short = "Alert level code"
* valueCodeableConcept ^definition = "The specific alert level code indicating the severity of mobility changes"

ValueSet: MobilityAlertLevelVS
Id: mobility-alert-level-vs
Title: "Mobility Alert Level Value Set"
Description: "Alert levels for mobility measurements using standard HL7 Observation Interpretation codes. Replaces custom traffic-light codes per Cat B remediation (2026-02-27)."
* ^experimental = false
* ^status = #active
* ^version = "0.2.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^purpose = "To provide standardized alert levels for mobility measurements"
* http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#N "Normal"
* http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#A "Abnormal"
* http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#AA "Critical abnormal"
