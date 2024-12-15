Alias:  = http://snomed.info/sct
Alias:  = http://loinc.org
Alias:  = http://unitsofmeasure.org

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

* ^version = "0.1.0"
* ^status = #draft
* ^experimental = false
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"

* code = #93847-2 "Mindfulness duration"
* valueQuantity only Quantity
* valueQuantity.system = 
* valueQuantity.code = #min
* valueQuantity.unit = "minute"

Profile: MoodObservation
Parent: MindfulnessObservation
Id: mood-observation
Title: "Mood Observation Profile"
Description: "Profile for mood measurements"

* ^version = "0.1.0"
* ^status = #draft
* ^experimental = false
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"

* code = #89204-2 "Mental Health Mood"
// Make sure you have a ValueSet: MoodStateVS / Id: mood-state-vs in your project.
* valueCodeableConcept from MoodStateVS (required)

Profile: StressObservation
Parent: MindfulnessObservation
Id: stress-observation
Title: "Stress Observation Profile"
Description: "Profile for stress level measurements"

* ^version = "0.1.0"
* ^status = #draft
* ^experimental = false
* ^date = "2024-12-14"
* ^publisher = "Ricardo Lourenço dos Santos"

* code = #89203-4 "Stress level"
* valueInteger only integer
// If you want minValue / maxValue for numeric logic, note that normal FHIR rules
// don't directly allow ^minValue / ^maxValue in Observation. This might require
// an extension. The lines below reflect your original snippet.
* valueInteger ^minValue = 0
* valueInteger ^maxValue = 10
