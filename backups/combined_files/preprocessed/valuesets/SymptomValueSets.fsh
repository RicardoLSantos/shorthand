// Originally defined on lines 1 - 10
CodeSystem: SymptomSeverityCS
Id: symptom-severity-cs
Title: "Symptom Severity Code System"
Description: "Severity levels for symptoms"
* ^experimental = false
* #1-3 "Light" "Symptom barely noticeable"
* #4-6 "Mild" "Symptom noticeable but not interfering with daily activities"
* #7-8 "Intense" "Symptom interfering with daily activities"
* #9-10 "Severe" "Symptom preventing daily activities"

// Originally defined on lines 12 - 24
ValueSet: BodyLocationsVS
Id: body-locations-vs
Title: "Body Locations Value Set"
Description: "Anatomical locations for symptom recording"
* ^experimental = false
* http://snomed.info/sct#12738006 "Brain"
* http://snomed.info/sct#69536005 "Head"
* http://snomed.info/sct#45048000 "Neck"
* http://snomed.info/sct#51185008 "Chest"
* http://snomed.info/sct#62413002 "Abdomen"
* http://snomed.info/sct#32849002 "Back"
* http://snomed.info/sct#53120007 "Upper limb"
* http://snomed.info/sct#61685007 "Lower limb"

// Originally defined on lines 26 - 35
ValueSet: DurationUnitsVS
Id: duration-units-vs
Title: "Duration Units Value Set"
Description: "Time units for symptom duration"
* ^experimental = false
* http://unitsofmeasure.org#min "Minutes"
* http://unitsofmeasure.org#h "Hours"
* http://unitsofmeasure.org#d "Days"
* http://unitsofmeasure.org#wk "Weeks"
* http://unitsofmeasure.org#mo "Months"

// Originally defined on lines 37 - 46
CodeSystem: SymptomFrequencyCS
Id: symptom-frequency-cs
Title: "Symptom Frequency Code System"
Description: "Frequency patterns for symptoms"
* ^experimental = false
* #rare "Rare" "Less than once per month"
* #occasional "Occasional" "Several times per month"
* #frequent "Frequent" "Several times per week"
* #daily "Daily" "Once or more per day"
* #constant "Constant" "Present most of the time"

// Originally defined on lines 48 - 53
ValueSet: SymptomFrequencyVS
Id: symptom-frequency-vs
Title: "Symptom Frequency Value Set"
Description: "Frequency patterns for symptoms"
* ^experimental = false
* include codes from system SymptomFrequencyCS

// Originally defined on lines 55 - 64
CodeSystem: SymptomImpactCS
Id: symptom-impact-cs
Title: "Symptom Impact Code System"
Description: "Impact levels of symptoms on daily activities"
* ^experimental = false
* #none "No impact"
* #mild "Mild impact"
* #moderate "Moderate impact"
* #severe "Severe impact"
* #complete "Complete impact"

// Originally defined on lines 66 - 71
ValueSet: SymptomImpactVS
Id: symptom-impact-vs
Title: "Symptom Impact Value Set"
Description: "Impact levels for symptoms"
* ^experimental = false
* include codes from system SymptomImpactCS

// Originally defined on lines 73 - 81
ValueSet: SymptomProgressionVS
Id: symptom-progression-vs
Title: "Symptom Progression Value Set"
Description: "Progression patterns for symptoms"
* ^experimental = false
* http://snomed.info/sct#385633008 "Improving"
* http://snomed.info/sct#58158008 "Stable"
* http://snomed.info/sct#230993007 "Worsening"
* http://snomed.info/sct#255314001 "Fluctuating"

// Originally defined on lines 83 - 90
ValueSet: TimeOfDayVS
Id: time-of-day-vs
Title: "Time of Day Value Set"
Description: "Times of day for symptom occurrence"
* ^experimental = false
* http://snomed.info/sct#255214003 "After exercise"
* http://snomed.info/sct#2546009 "Evening"
* http://snomed.info/sct#73775008 "Morning"

