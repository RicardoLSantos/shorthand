Instance: MindfulnessQuestionnaireResponseExample
InstanceOf: QuestionnaireResponse
Usage: #example
Title: "Daily Mindfulness Questionnaire Response Example"

* questionnaire = "http://example.org/Questionnaire/daily-mindfulness"
* status = #completed
* subject = Reference(Patient/example)
* authored = "2024-03-19T20:00:00Z"

// ITEM 0: Mindful Session
* item[0]
  * linkId = "mindful_session"

  * item[0]
    * linkId = "session_duration"
    * answer.valueInteger = 20

  * item[1]
    * linkId = "session_type"
    * answer.valueString = "Meditation"

// ITEM 1: Mood Assessment
* item[1]
  * linkId = "mood_assessment"

  * item[0]
    * linkId = "current_mood"
    * answer.valueCoding = SCT#130991005 "Neutral mood"

  * item[1]
    * linkId = "mood_intensity"
    * answer.valueInteger = 3

// ITEM 2: Stress Assessment
* item[2]
  * linkId = "stress_assessment"

  * item[0]
    * linkId = "stress_level"
    * answer.valueInteger = 4

  * item[1]
    * linkId = "stress_symptoms"
    * answer[0].valueString = "Muscle tension"
    * answer[1].valueString = "Anxiety"

// ITEM 3: Relaxation
* item[3]
  * linkId = "relaxation"

  * item[0]
    * linkId = "relaxation_duration"
    * answer.valueInteger = 15

  * item[1]
    * linkId = "relaxation_technique"
    * answer.valueString = "Deep breathing"

Instance: MindfulnessQuestionnaireResponseExample
InstanceOf: QuestionnaireResponse
Usage: #example
Title: "Daily Mindfulness Questionnaire Response Example"

* questionnaire = "http://example.org/Questionnaire/daily-mindfulness"
* status = #completed
* subject = Reference(Patient/PatientExample)
* authored = "2024-03-19T20:00:00Z"

* item[0]
  * linkId = "mindful_session"

  * item[0]
    * linkId = "session_duration" 
    * answer.valueInteger = 20

  * item[1]
    * linkId = "session_type"
    * answer.valueString = "Meditation"

* item[1]
  * linkId = "mood_assessment"

  * item[0]
    * linkId = "current_mood"
    * answer.valueCoding = http://snomed.info/sct#130991005 "Neutral mood"

  * item[1]
    * linkId = "mood_intensity"
    * answer.valueInteger = 3

* item[2]
  * linkId = "stress_assessment"

  * item[0]
    * linkId = "stress_level"
    * answer.valueInteger = 4

  * item[1]
    * linkId = "stress_symptoms"
    * answer[0].valueString = "Muscle tension"
    * answer[1].valueString = "Anxiety"

* item[3]
  * linkId = "relaxation"

  * item[0]
    * linkId = "relaxation_duration"
    * answer.valueInteger = 15

  * item[1]
    * linkId = "relaxation_technique"
    * answer.valueString = "Deep breathing"
