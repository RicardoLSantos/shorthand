Instance: CompleteMindfulnessSession
InstanceOf: MindfulnessObservation
Usage: #example
Description: "Complete mindfulness session observation example"
Title: "Complete Mindfulness Session Example"

* status = #final
// Code inherited from profile
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* component[sessionDuration].code = $SCT#704323007 "Process duration"
* component[sessionDuration].valueQuantity = 20 'min'

// Code inherited from profile
* component[stressLevel].valueInteger = 3

* component[moodState].code = $SCT#106131003 "Mood finding"
* component[moodState].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#calm "Calm"

// Code inherited from profile
* component[relaxationResponse].valueString = "Deep breathing exercises with progressive relaxation"

// Code inherited from profile
* component[mindfulnessType].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mindfulness-type-meditation "Meditation"

* extension[mindfulness-context].extension[location].valueString = "Home meditation room"
* extension[mindfulness-context].extension[environment].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#quiet "Quiet Space"
* extension[mindfulness-context].extension[guidance].valueBoolean = true

Instance: CompleteMindfulnessResponse
InstanceOf: QuestionnaireResponse
Usage: #example
Description: "Complete mindfulness questionnaire response example"
Title: "Complete Mindfulness Session Response"

* questionnaire = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/daily-mindfulness"
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
    * answer.valueCoding = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mood-elevated "Elevated"
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
    * answer[0].valueString = "Muscle tension"

* item[3]
  * linkId = "relaxation"
  * item[0]
    * linkId = "relaxation_duration"
    * answer.valueInteger = 15
  * item[1]
    * linkId = "relaxation_technique"
    * answer.valueString = "Deep breathing"
