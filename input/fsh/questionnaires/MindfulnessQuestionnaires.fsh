Profile: MindfulnessQuestionnaire
Parent: Questionnaire
Id: MindfulnessQuestionnaire
Title: "Mindfulness Questionnaire"
Description: "Questionnaire capturing mindfulness session information, mood, and stress."

* name = "MindfulnessQuestionnaire"
* status = #draft

// ITEM 0: Mindfulness Session Duration
* item[0].linkId = "sessionDuration"
* item[0].text = "Mindfulness session duration (minutes)"
* item[0].type = #integer
* item[0].required = true
// If you want min/max range, use official extensions:
// * item[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-minValue"
// * item[0].extension[0].valueInteger = 1
// * item[0].extension[1].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-maxValue"
// * item[0].extension[1].valueInteger = 180

// ITEM 1: Practice Type
* item[1].linkId = "practiceType"
* item[1].text = "Practice type"
* item[1].type = #choice
* item[1].required = true
* item[1].answerOption[0].valueString = "Body scan"
* item[1].answerOption[1].valueString = "Breathing exercise"
* item[1].answerOption[2].valueString = "Walking meditation"
* item[1].answerOption[3].valueString = "Other"

// ITEM 2: Mood Assessment
* item[2].linkId = "moodAssessment"
* item[2].text = "How is your mood now?"
* item[2].type = #choice
* item[2].required = true
// Use a canonical if MoodStateVS exists with Id: mood-state-vs
* item[2].answerValueSet = Canonical(MoodStateVS)
// If it fails, replace with a direct URI, e.g.:
// * item[2].answerValueSet = http://example.org/fhir/ValueSet/mood-state-vs

// ITEM 3: Mood Intensity
* item[3].linkId = "moodIntensity"
* item[3].text = "Mood intensity (1-5)"
* item[3].type = #integer
* item[3].required = true
* item[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-minValue"
* item[3].extension[0].valueInteger = 1
* item[3].extension[1].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-maxValue"
* item[3].extension[1].valueInteger = 5

// ITEM 4: Stress Assessment
* item[4].linkId = "stressAssessment"
* item[4].text = "Current stress level (0-10)"
* item[4].type = #integer
* item[4].required = true
* item[4].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-minValue"
* item[4].extension[0].valueInteger = 0
* item[4].extension[1].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-maxValue"
* item[4].extension[1].valueInteger = 10

// ITEM 5: Stress Symptoms
* item[5].linkId = "stressSymptoms"
* item[5].text = "Stress symptoms"
* item[5].type = #choice
* item[5].repeats = true
* item[5].answerOption[0].valueString = "Difficulty sleeping"
* item[5].answerOption[1].valueString = "Headaches"
* item[5].answerOption[2].valueString = "Muscle tension"
* item[5].answerOption[3].valueString = "Irritability"

// ITEM 6: Relaxation Technique
* item[6].linkId = "relaxationTechnique"
* item[6].text = "Technique used"
* item[6].type = #choice
* item[6].answerOption[0].valueString = "Progressive muscle relaxation"
* item[6].answerOption[1].valueString = "Guided imagery"
* item[6].answerOption[2].valueString = "Deep breathing"
* item[6].answerOption[3].valueString = "Other"

