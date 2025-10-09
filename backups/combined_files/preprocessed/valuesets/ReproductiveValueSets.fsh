// Originally defined on lines 1 - 16
ValueSet: ReproductiveGoalVS
Id: social-history-goal-vs
Title: "Reproductive Health Goals Value Set"
Description: "Goals related to social-history health tracking and planning"
* ^experimental = false
* ^status = #active
* ^date = "2024-03-19"
* http://loinc.org#8708-0 "Menstrual cycle length"
* http://loinc.org#55284-4 "Blood pressure"
* http://loinc.org#8310-5 "Body temperature"
* http://loinc.org#8302-2 "Body height"
* http://loinc.org#29463-7 "Body weight"
* http://snomed.info/sct#364311006 "Menstrual cycle monitoring"
* http://snomed.info/sct#289530006 "Reproductive health finding"

// Originally defined on lines 18 - 27
ValueSet: ReproductiveActivityVS
Id: social-history-activity-vs
Title: "Reproductive Health Activities Value Set"
Description: "Activities related to social-history health monitoring"
* ^experimental = false
* ^status = #active
* ^date = "2024-03-19"
* include codes from system ReproductiveActivityCS

// Originally defined on lines 29 - 45
CodeSystem: ReproductiveActivityCS
Id: social-history-activity-cs
Title: "Reproductive Health Activities Code System"
Description: "Code system for social-history health monitoring activities"
* ^experimental = false
* ^status = #active
* ^caseSensitive = true
* #cycle-tracking "Cycle Tracking" "Track menstrual cycle dates and characteristics"
* #temp-monitoring "Temperature Monitoring" "Monitor basal body temperature"
* #symptom-tracking "Symptom Tracking" "Track social-history health symptoms"
* #vitals-monitoring "Vitals Monitoring" "Monitor vital signs related to social-history health"
* #fertility-signs "Fertility Signs" "Monitor fertility signs and indicators"
* #mood-tracking "Mood Tracking" "Track mood changes related to social-history cycle"
* #medication-log "Medication Log" "Log social-history health medications"
* #exercise-tracking "Exercise Tracking" "Track physical activity during cycle"

