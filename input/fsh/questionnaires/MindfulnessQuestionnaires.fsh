Instance: DailyMindfulnessQuestionnaire
InstanceOf: Questionnaire
Usage: #definition
Title: "Daily Mindfulness and Mental Health Questionnaire"
Description: "Questionnaire for daily mindfulness and mental health tracking"

* url = "https://github.com/RicardoLSantos/shorthand/Questionnaire/daily-mindfulness"
* version = "0.1.0"
* name = "DailyMindfulnessQuestionnaire"
* title = "Daily Mindfulness and Mental Health"
* status = #active
* experimental = false
* date = "2024-12-14"
* publisher = "Ricardo Lourenço dos Santos"

* item[0]
 * linkId = "mindful_session"
 * text = "Mindfulness Session"
 * type = #group
 * repeats = true

 * item[0]
   * linkId = "session_duration"
   * text = "Session duration (minutes)"
   * type = #integer
   * required = true

 * item[1]
   * linkId = "session_type"
   * text = "Practice type"
   * type = #choice
   * required = true
   * answerOption[0].valueString = "Meditation"
   * answerOption[1].valueString = "Mindful breathing"
   * answerOption[2].valueString = "Body scan"
   * answerOption[3].valueString = "Mindful yoga"

* item[1]
 * linkId = "mood_assessment"
 * text = "Mood Assessment"
 * type = #group

 * item[0]
   * linkId = "current_mood"
   * text = "How is your mood now?"
   * type = #choice
   * required = true
   * answerValueSet = "https://github.com/RicardoLSantos/shorthand/ValueSet/mood-state"

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
   * answerOption[2].valueString = "Irritability" 
   * answerOption[3].valueString = "Insomnia"

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
   * answerOption[1].valueString = "Progressive muscle relaxation"
   * answerOption[2].valueString = "Visualization"
   * answerOption[3].valueString = "Relaxing music"
