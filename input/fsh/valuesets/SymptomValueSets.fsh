CodeSystem: SymptomSeverityCS
Id: symptom-severity-cs
Title: "Symptom Severity Code System"
Description: "Severity levels for symptoms"

* #1-3 "Light" "Symptom barely noticeable"
* #4-6 "Mild" "Symptom noticeable but not interfering with daily activities"
* #7-8 "Intense" "Symptom interfering with daily activities"
* #9-10 "Severe" "Symptom preventing daily activities"

ValueSet: BodyLocationsVS
Id: body-locations-vs
Title: "Body Locations Value Set"
Description: "Anatomical locations for symptom recording"
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
* $UCUM#min "Minutes"
* $UCUM#h "Hours"
* $UCUM#d "Days"
* $UCUM#wk "Weeks"
* $UCUM#mo "Months"

CodeSystem: SymptomFrequencyCS
Id: symptom-frequency-cs
Title: "Symptom Frequency Code System"
Description: "Frequency patterns for symptoms"
* #rare "Rare" "Less than once per month"
* #occasional "Occasional" "Several times per month"
* #frequent "Frequent" "Several times per week"
* #daily "Daily" "Once or more per day"
* #constant "Constant" "Present most of the time"

ValueSet: SymptomFrequencyVS
Id: symptom-frequency-vs
Title: "Symptom Frequency Value Set"
Description: "Frequency patterns for symptoms"
* codes from system SymptomFrequencyCS

CodeSystem: SymptomImpactCS
Id: symptom-impact-cs
Title: "Symptom Impact Code System"
Description: "Impact levels of symptoms on daily activities"
* #none "No impact"
* #mild "Mild impact"
* #moderate "Moderate impact"
* #severe "Severe impact"
* #complete "Complete impact"

ValueSet: SymptomImpactVS
Id: symptom-impact-vs
Title: "Symptom Impact Value Set"
Description: "Impact levels for symptoms"
* codes from system SymptomImpactCS

ValueSet: SymptomProgressionVS
Id: symptom-progression-vs
Title: "Symptom Progression Value Set"
Description: "Progression patterns for symptoms"
* $SCT#385633008 "Improving"
* $SCT#58158008 "Stable"
* $SCT#230993007 "Worsening"
* $SCT#255314001 "Fluctuating"

ValueSet: TimeOfDayVS
Id: time-of-day-vs
Title: "Time of Day Value Set"
Description: "Times of day for symptom occurrence"
* $SCT#73775008 "Morning"
* $SCT#255253008 "Afternoon"
* $SCT#2546009 "Evening"
* $SCT#73768005 "Night"

Instance: ExampleSymptomSeverity
InstanceOf: Observation
Usage: #example
Title: "Example Symptom Severity"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#246604007 "Symptom severity"
* effectiveDateTime = "2024-03-19T10:30:00Z"
* valueCodeableConcept = http://example.org/fhir/CodeSystem/symptom-severity-cs#4-6 "Moderado"
