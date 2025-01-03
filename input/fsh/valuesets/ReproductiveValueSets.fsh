ValueSet: ReproductiveGoalVS
Id: reproductive-goal-vs
Title: "Reproductive Health Goals Value Set"
Description: "Goals related to reproductive health tracking and planning"

* ^status = #active
* ^experimental = false
* ^date = "2024-03-19"

* $LOINC#8708-0 "Menstrual cycle length"
* $LOINC#55284-4 "Blood pressure"
* $LOINC#8310-5 "Body temperature"
* $LOINC#8302-2 "Body height"
* $LOINC#29463-7 "Body weight"
* $SCT#364311006 "Menstrual cycle monitoring"
* $SCT#289530006 "Reproductive health finding"

ValueSet: ReproductiveActivityVS
Id: reproductive-activity-vs
Title: "Reproductive Health Activities Value Set"
Description: "Activities related to reproductive health monitoring"

* ^status = #active
* ^experimental = false
* ^date = "2024-03-19"

* codes from system ReproductiveActivityCS

CodeSystem: ReproductiveActivityCS
Id: reproductive-activity-cs
Title: "Reproductive Health Activities Code System"
Description: "Code system for reproductive health monitoring activities"

* ^status = #active
* ^experimental = false
* ^caseSensitive = true

* #cycle-tracking "Cycle Tracking" "Track menstrual cycle dates and characteristics"
* #temp-monitoring "Temperature Monitoring" "Monitor basal body temperature"
* #symptom-tracking "Symptom Tracking" "Track reproductive health symptoms"
* #vitals-monitoring "Vitals Monitoring" "Monitor vital signs related to reproductive health"
* #fertility-signs "Fertility Signs" "Monitor fertility signs and indicators"
* #mood-tracking "Mood Tracking" "Track mood changes related to reproductive cycle"
* #medication-log "Medication Log" "Log reproductive health medications"
* #exercise-tracking "Exercise Tracking" "Track physical activity during cycle"
