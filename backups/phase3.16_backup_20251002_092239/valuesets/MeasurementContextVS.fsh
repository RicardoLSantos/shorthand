ValueSet: MeasurementContextVS
Id: measurement-context-vs
Title: "Measurement Context Value Set"
Description: "Contexts in which measurements can be taken, including temporal and location-based contexts"
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
* $SCT#272125009 "Assessment context value (qualifier value)"
* $SCT#307818003 "Before food"
* $SCT#307819006 "After food"
* $SCT#255214003 "After exercise"
* $SCT#264362003 "Time of day"
