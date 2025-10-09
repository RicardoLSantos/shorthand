ValueSet: ReproductiveGoalVS
Id: social-history-goal-vs
Title: "Reproductive Health Goals Value Set"
Description: "Goals related to social-history health tracking and planning"
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
* ^date = "2024-03-19"

* $LOINC#8708-0 "Menstrual cycle length"
* $LOINC#55284-4 "Blood pressure"
* $LOINC#8310-5 "Body temperature"
* $LOINC#8302-2 "Body height"
* $LOINC#29463-7 "Body weight"
* $SCT#364311006 "Menstrual cycle monitoring"
* $SCT#289530006 "Reproductive health finding"

ValueSet: ReproductiveActivityVS
Id: social-history-activity-vs
Title: "Reproductive Health Activities Value Set"
Description: "Activities related to social-history health monitoring"
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
* ^date = "2024-03-19"

* codes from system ReproductiveActivityCS

CodeSystem: ReproductiveActivityCS
Id: social-history-activity-cs
Title: "Reproductive Health Activities Code System"
Description: "Code system for social-history health monitoring activities"
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

* #cycle-tracking "Cycle Tracking" "Track menstrual cycle dates and characteristics"
* #temp-monitoring "Temperature Monitoring" "Monitor basal body temperature"
* #symptom-tracking "Symptom Tracking" "Track social-history health symptoms"
* #vitals-monitoring "Vitals Monitoring" "Monitor vital signs related to social-history health"
* #fertility-signs "Fertility Signs" "Monitor fertility signs and indicators"
* #mood-tracking "Mood Tracking" "Track mood changes related to social-history cycle"
* #medication-log "Medication Log" "Log social-history health medications"
* #exercise-tracking "Exercise Tracking" "Track physical activity during cycle"
