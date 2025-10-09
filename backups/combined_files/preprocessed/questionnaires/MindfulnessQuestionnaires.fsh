// Originally defined on lines 1 - 97
Instance: DailyMindfulnessQuestionnaire
InstanceOf: Questionnaire
Title: "Daily Mindfulness Questionnaire"
Description: "Questionnaire for capturing daily mindfulness practice and associated effects"
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/daily-mindfulness"
* status = #active
* title = "Daily Mindfulness Practice"
* subjectType = #Patient
* version = "1.0.0"
* name = "DailyMindfulnessQuestionnaire"
* date = "2024-03-19"
* item[0]
* item[0].linkId = "mindful_session"
* item[0].text = "Mindfulness Session"
* item[0].type = #group
* item[0].repeats = false
* item[0].item[0]
* item[0].item[0].linkId = "session_duration"
* item[0].item[0].text = "Session duration (minutes)"
* item[0].item[0].type = #integer
* item[0].item[0].required = true
* item[0].item[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
* item[0].item[0].extension[0].valueInteger = 1
* item[0].item[1]
* item[0].item[1].linkId = "practice_type"
* item[0].item[1].text = "Practice type"
* item[0].item[1].type = #choice
* item[0].item[1].required = true
* item[0].item[1].answerOption[0].valueString = "Meditation"
* item[0].item[1].answerOption[1].valueString = "Breathing exercise"
* item[0].item[1].answerOption[2].valueString = "Body scan"
* item[0].item[1].answerOption[3].valueString = "Mindful walking"
* item[1]
* item[1].linkId = "mood_assessment"
* item[1].text = "Mood Assessment"
* item[1].type = #group
* item[1].item[0]
* item[1].item[0].linkId = "current_mood"
* item[1].item[0].text = "How is your mood now?"
* item[1].item[0].type = #choice
* item[1].item[0].required = true
* item[1].item[0].answerValueSet = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mood-vs"
* item[1].item[1]
* item[1].item[1].linkId = "mood_intensity"
* item[1].item[1].text = "Mood intensity (1-5)"
* item[1].item[1].type = #integer
* item[1].item[1].required = true
* item[2]
* item[2].linkId = "stress_assessment"
* item[2].text = "Stress Assessment"
* item[2].type = #group
* item[2].item[0]
* item[2].item[0].linkId = "stress_level"
* item[2].item[0].text = "Stress level (0-10)"
* item[2].item[0].type = #integer
* item[2].item[0].required = true
* item[2].item[1]
* item[2].item[1].linkId = "stress_symptoms"
* item[2].item[1].text = "Stress symptoms"
* item[2].item[1].type = #choice
* item[2].item[1].repeats = true
* item[2].item[1].answerOption[0].valueString = "Muscle tension"
* item[2].item[1].answerOption[1].valueString = "Anxiety"
* item[2].item[1].answerOption[2].valueString = "Headache"
* item[2].item[1].answerOption[3].valueString = "Fatigue"
* item[3]
* item[3].linkId = "relaxation"
* item[3].text = "Relaxation"
* item[3].type = #group
* item[3].item[0]
* item[3].item[0].linkId = "relaxation_duration"
* item[3].item[0].text = "Relaxation time (minutes)"
* item[3].item[0].type = #integer
* item[3].item[0].required = true
* item[3].item[1]
* item[3].item[1].linkId = "relaxation_technique"
* item[3].item[1].text = "Technique used"
* item[3].item[1].type = #choice
* item[3].item[1].required = true
* item[3].item[1].answerOption[0].valueString = "Deep breathing"
* item[3].item[1].answerOption[1].valueString = "Progressive relaxation"
* item[3].item[1].answerOption[2].valueString = "Visualization"
* item[3].item[1].answerOption[3].valueString = "Mindful awareness"

