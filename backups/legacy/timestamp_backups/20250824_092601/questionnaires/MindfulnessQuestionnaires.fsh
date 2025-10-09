Instance: DailyMindfulnessQuestionnaire
InstanceOf: Questionnaire
Usage: #definition
Title: "Daily Mindfulness Questionnaire"
Description: "Questionnaire for capturing daily mindfulness practice and associated effects"

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/daily-mindfulness"
* status = #active
* title = "Daily Mindfulness Practice"
* subjectType = #Patient
* version = "1.0.0"
* name = "DailyMindfulnessQuestionnaire"
* date = "2024-03-19"

* item[0]
  * linkId = "mindful_session"
  * text = "Mindfulness Session"
  * type = #group
  * repeats = false

  * item[0]
    * linkId = "session_duration"
    * text = "Session duration (minutes)"
    * type = #integer
    * required = true
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueInteger = 1

  * item[1]
    * linkId = "practice_type"
    * text = "Practice type"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Meditation"
    * answerOption[1].valueString = "Breathing exercise"
    * answerOption[2].valueString = "Body scan"
    * answerOption[3].valueString = "Mindful walking"

* item[1]
  * linkId = "mood_assessment"
  * text = "Mood Assessment"
  * type = #group

  * item[0]
    * linkId = "current_mood"
    * text = "How is your mood now?"
    * type = #choice
    * required = true
    * answerValueSet = "https://2rdoc.pt/fhir/ValueSet/mood-vs"

  * item[1]
    * linkId = "mood_intensity"
    * text = "Mood intensity (1-5)"
    * type = #integer
    * required = true

* item[2]
  * linkId = "stress_assessment"
  * text = "Stress Assessment"
  * type = #group

  * item[0]
    * linkId = "stress_level"
    * text = "Stress level (0-10)"
    * type = #integer
    * required = true

  * item[1]
    * linkId = "stress_symptoms"
    * text = "Stress symptoms"
    * type = #choice
    * repeats = true
    * answerOption[0].valueString = "Muscle tension"
    * answerOption[1].valueString = "Anxiety"
    * answerOption[2].valueString = "Headache"
    * answerOption[3].valueString = "Fatigue"

* item[3]
  * linkId = "relaxation"
  * text = "Relaxation"
  * type = #group

  * item[0]
    * linkId = "relaxation_duration"
    * text = "Relaxation time (minutes)"
    * type = #integer
    * required = true

  * item[1]
    * linkId = "relaxation_technique"
    * text = "Technique used"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Deep breathing"
    * answerOption[1].valueString = "Progressive relaxation"
    * answerOption[2].valueString = "Visualization"
    * answerOption[3].valueString = "Mindful awareness"
