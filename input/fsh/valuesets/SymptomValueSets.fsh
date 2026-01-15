CodeSystem: SymptomSeverityCS
Id: symptom-severity-cs
Title: "Symptom Severity Code System"
Description: "Severity levels for symptoms"
* ^experimental = false
* ^caseSensitive = true

* #1-3 "Light" "Symptom barely noticeable"
* #4-6 "Mild" "Symptom noticeable but not interfering with daily activities"
* #7-8 "Intense" "Symptom interfering with daily activities"
* #9-10 "Severe" "Symptom preventing daily activities"

ValueSet: BodyLocationsVS
Id: body-locations-vs
Title: "Body Locations Value Set"
Description: "Anatomical locations for symptom recording"
* ^experimental = false
* $SCT#12738006 "Brain"
* $SCT#69536005 "Head"
* $SCT#45048000 "Neck"
* $SCT#51185008 "Chest"
* $SCT#62413002 "Abdomen"
* $SCT#32849002 "Back"
* $SCT#53120007 "Upper limb"
* $SCT#61685007 "Lower limb"

ValueSet: DurationUnitsVS
Id: duration-units-vs
Title: "Duration Units Value Set"
Description: "Time units for symptom duration"
* ^experimental = false
* $UCUM#min "Minutes"
* $UCUM#h "Hours"
* $UCUM#d "Days"
* $UCUM#wk "Weeks"
* $UCUM#mo "Months"

CodeSystem: SymptomFrequencyCS
Id: symptom-frequency-cs
Title: "Symptom Frequency Code System"
Description: "Frequency patterns for symptoms"
* ^experimental = false
* ^caseSensitive = true
* #rare "Rare" "Less than once per month"
* #occasional "Occasional" "Several times per month"
* #frequent "Frequent" "Several times per week"
* #daily "Daily" "Once or more per day"
* #constant "Constant" "Present most of the time"

ValueSet: SymptomFrequencyVS
Id: symptom-frequency-vs
Title: "Symptom Frequency Value Set"
Description: "Frequency patterns for symptoms"
* ^experimental = false
* codes from system SymptomFrequencyCS

CodeSystem: SymptomImpactCS
Id: symptom-impact-cs
Title: "Symptom Impact Code System"
Description: "Impact levels of symptoms on daily activities"
* ^experimental = false
* ^caseSensitive = true
* #none "No impact"
* #mild "Mild impact"
* #moderate "Moderate impact"
* #severe "Severe impact"
* #complete "Complete impact"

ValueSet: SymptomImpactVS
Id: symptom-impact-vs
Title: "Symptom Impact Value Set"
Description: "Impact levels for symptoms"
* ^experimental = false
* codes from system SymptomImpactCS

ValueSet: SymptomProgressionVS
Id: symptom-progression-vs
Title: "Symptom Progression Value Set"
Description: """
Progression patterns for symptoms.

**SNOMED CT Verification Notes (2026-01-12)**:
- 255314001: Actual = "Progressive" - display corrected
"""
* ^experimental = false
* $SCT#385633008 "Improving (qualifier value)"
* $SCT#58158008 "Stable (qualifier value)"
* $SCT#230993007 "Worsening (qualifier value)"
* $SCT#255314001 "Progressive (qualifier value)"
// Note: No specific SNOMED code for "Fluctuating" - use custom code if needed
* SymptomProgressionCS#fluctuating "Fluctuating"

CodeSystem: SymptomProgressionCS
Id: symptom-progression-cs
Title: "Symptom Progression CodeSystem"
Description: "Custom codes for symptom progression where SNOMED CT lacks specific concepts"
* ^experimental = false
* ^caseSensitive = true
* #fluctuating "Fluctuating" "Symptom severity varies over time"

ValueSet: TimeOfDayVS
Id: time-of-day-vs
Title: "Time of Day Value Set"
Description: """
Times of day for symptom occurrence.

**SNOMED CT Verification Notes (2026-01-12)**:
- 2546009: Actual = "Night time" - display corrected
"""
* ^experimental = false
* $SCT#255214003 "After exercise (qualifier value)"
* $SCT#2546009 "Night time (qualifier value)"
* $SCT#73775008 "Morning (qualifier value)"
// Add evening as custom code since SNOMED 2546009 is "Night time" not "Evening"
* TimeOfDayCS#evening "Evening"

CodeSystem: TimeOfDayCS
Id: time-of-day-cs
Title: "Time of Day CodeSystem"
Description: "Custom codes for times of day where SNOMED CT lacks specific concepts"
* ^experimental = false
* ^caseSensitive = true
* #evening "Evening" "Late afternoon to early night (approximately 5pm-9pm)"
* #afternoon "Afternoon" "Midday to late afternoon (approximately 12pm-5pm)"
