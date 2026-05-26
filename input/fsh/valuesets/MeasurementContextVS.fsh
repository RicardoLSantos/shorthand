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
// T2 S33 VRF-TERM-018: removed 272125009 ("Priorities" — was mislabeled "Assessment context value", a hierarchy parent) + 264362003 ("Dwelling" — was mislabeled "Time of day", no exact SNOMED context code). Swapped 307818003/307819006 (wrong concepts) → correct Before/After food. 255214003 kept (correct here = After exercise).
* $SCT#311500009 "Before food"
* $SCT#225758001 "After food"
* $SCT#255214003 "After exercise"
