Profile: MindfulnessQuestionnaire
Parent: Questionnaire
Id: MindfulnessQuestionnaire
Title: "Mindfulness Questionnaire"
Description: "Captures mindfulness session, mood, and stress data."

* name = "MindfulnessQuestionnaire"
* status = #draft

// ITEM 0
* item[0].linkId = "sessionDuration"
* item[0].text = "Mindfulness session duration (minutes)"
* item[0].type = #integer
* item[0].required = true

// ITEM 1
* item[1].linkId = "practiceType"
* item[1].text = "Practice type"
* item[1].type = #choice
* item[1].required = true
* item[1].answerOption[0].valueString = "Body scan"
* item[1].answerOption[1].valueString = "Breathing exercise"
* item[1].answerOption[2].valueString = "Walking meditation"
* item[1].answerOption[3].valueString = "Other"

// ITEM 2
* item[2].linkId = "moodAssessment"
* item[2].text = "How is your mood now?"
* item[2].type = #choice
* item[2].required = true
* item[2].answerValueSet = Canonical(MoodStateVS)

// ITEM 3
* item[3].linkId = "moodIntensity"
* item[3].text = "Mood intensity (1-5)"
* item[3].type = #integer
* item[3].required = true
* item[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-minValue"
* item[3].extension[0].valueInteger = 1
* item[3].extension[1].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-maxValue"
* item[3].extension[1].valueInteger = 5

// ITEM 4
* item[4].linkId = "stressAssessment"
* item[4].text = "Current stress level (0-10)"
* item[4].type = #integer
* item[4].required = true
* item[4].extension[0].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-minValue"
* item[4].extension[0].valueInteger = 0
* item[4].extension[1].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-maxValue"
* item[4].extension[1].valueInteger = 10

// ITEM 5
* item[5].linkId = "stressSymptoms"
* item[5].text = "Stress symptoms"
* item[5].type = #choice
* item[5].repeats = true
* item[5].answerOption[0].valueString = "Difficulty sleeping"
* item[5].answerOption[1].valueString = "Headaches"
* item[5].answerOption[2].valueString = "Muscle tension"
* item[5].answerOption[3].valueString = "Irritability"

// ITEM 6
* item[6].linkId = "relaxationTechnique"
* item[6].text = "Relaxation technique"
* item[6].type = #choice
* item[6].answerOption[0].valueString = "Progressive muscle relaxation"
* item[6].answerOption[1].valueString = "Guided imagery"
* item[6].answerOption[2].valueString = "Deep breathing"
* item[6].answerOption[3].valueString = "Other"
