Alias: LOINC = http://loinc.org
Alias: UCUM = http://unitsofmeasure.org

Profile: MindfulnessObservation
Parent: Observation
Id: mindfulness-observation
Title: "Mindfulness Observation Profile"
Description: "Profile for mindfulness and mental health data"

* ^version = "0.1.0"
* ^status = #draft
* ^experimental = false
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#mental-health
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* code 1..1 MS
* method 0..1 MS

Profile: MindfulSessionObservation
Parent: MindfulnessObservation
Id: mindful-session-observation
Title: "Mindful Session Observation Profile"
Description: "Profile for mindfulness session measurements"

// Fix the code assignment (cannot just assign "min" as string to code)
* code = LOINC#93847-2 "Mindfulness duration"
* valueQuantity only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
// Option 1: Use FSH syntax for code
* valueQuantity.code = (code) "min"
* valueQuantity.unit = "minute"

Profile: MoodObservation
Parent: MindfulnessObservation
Id: mood-observation
Title: "Mood Observation Profile"
Description: "Profile for mood measurements"

* code = LOINC#89204-2 "Mental Health Mood"
// If MoodStateVS is defined (ValueSet: MoodStateVS / Id: mood-state-vs), use:
* valueCodeableConcept from MoodStateVS (required)

Profile: StressObservation
Parent: MindfulnessObservation
Id: stress-observation
Title: "Stress Observation Profile"
Description: "Profile for stress level measurements"

* code = LOINC#89203-4 "Stress level"
* valueInteger only integer
// Removing direct ^minValue / ^maxValue (FHIR Observation doesn't support them directly)
