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
ValueSet: SymptomFrequencyVS
Id: symptom-frequency-vs
Title: "Symptom Frequency Value Set"
Description: "Frequency patterns for symptoms"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS
ValueSet: SymptomImpactVS
Id: symptom-impact-vs
Title: "Symptom Impact Value Set"
Description: "Impact levels for symptoms"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS

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
* LifestyleMedicineTemporaryCS#fluctuating "Fluctuating"
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
* LifestyleMedicineTemporaryCS#time-of-day-evening "Evening"
