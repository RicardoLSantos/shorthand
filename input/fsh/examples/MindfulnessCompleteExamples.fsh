Instance: CompleteMindfulnessSession
InstanceOf: MindfulnessObservation
Usage: #example
Title: "Complete Mindfulness Session Example"

* status = #final
* code = $SCT#711020003 "Meditation"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* performer = Reference(Practitioner/example)

* component[sessionDuration].code = $SCT#118682006 "Duration"
* component[sessionDuration].valueQuantity = 20 'min' "minutes"

* component[stressLevel].code = $SCT#725854004 "Assessment of stress level"
* component[stressLevel].valueInteger = 3

* component[moodState].code = $SCT#373931001 "Mood finding"
* component[moodState].valueCodeableConcept = $SCT#130991005 "Neutral mood"

* component[relaxationResponse].code = $SCT#276241001 "Relaxation technique"
* component[relaxationResponse].valueString = "Deep breathing exercises with progressive relaxation"

* component[mindfulnessType].code = $SCT#711020003 "Meditation"
* component[mindfulnessType].valueCodeableConcept = $SCT#711020003 "Meditation"

* extension[mindfulness-context].extension[location].valueString = "Home meditation room"
* extension[mindfulness-context].extension[environment].valueCodeableConcept = #quiet "Quiet Space"
* extension[mindfulness-context].extension[guidance].valueBoolean = true

Instance: CompleteMindfulnessResponse
InstanceOf: QuestionnaireResponse
Usage: #example
Title: "Complete Mindfulness Session Response"

* questionnaire = "http://example.org/Questionnaire/daily-mindfulness"
* status = #completed
* subject = Reference(Patient/PatientExample)
* authored = "2024-03-19T08:30:00Z"

* item[0]
  * linkId = "mindful_session"
  * item[0]
    * linkId = "session_duration"
    * answer.valueInteger = 20
  * item[1]
    * linkId = "practice_type"
    * answer.valueString = "Meditation"

* item[1]
  * linkId = "mood_assessment"
  * item[0]
    * linkId = "current_mood"
    * answer.valueCoding = $SCT#130991005 "Neutral mood"
  * item[1]
    * linkId = "mood_intensity"
    * answer.valueInteger = 3

* item[2]
  * linkId = "stress_assessment"
  * item[0]
    * linkId = "stress_level"
    * answer.valueInteger = 3
  * item[1]
    * linkId = "stress_symptoms"
    * answer[0].valueString = "Slight tension"

* item[3]
  * linkId = "relaxation"
  * item[0]
    * linkId = "relaxation_duration"
    * answer.valueInteger = 15
  * item[1]
    * linkId = "relaxation_technique"
    * answer.valueString = "Deep breathing"
