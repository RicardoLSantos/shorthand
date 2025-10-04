Instance: MindfulnessObservationExample
InstanceOf: MindfulnessObservation
Usage: #example
Description: "Mindfulness observation example"
Title: "Example of Mindfulness Session Observation"

* status = #final
// Code inherited from profile
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T09:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* component[sessionDuration].code = $SCT#704323007 "Process duration"
* component[sessionDuration].valueQuantity = 20 'min'

// Code inherited from profile
* component[stressLevel].valueInteger = 4

* component[moodState].code = $SCT#106131003 "Mood finding"
* component[moodState].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mood#calm "Calm"

// Code inherited from profile
* component[relaxationResponse].valueString = "Deep breathing exercises helped reduce tension"

// Code inherited from profile
* component[mindfulnessType].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-type-cs#meditation "Meditation"

// New example for MindfulnessQuestionnaire
Instance: MindfulnessQuestionnaireExample
InstanceOf: Questionnaire
Usage: #example
Title: "Example of Mindfulness Questionnaire"

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/MindfulnessQuestionnaireExample"
* status = #active
* title = "Daily Mindfulness Assessment"
* version = "1.0"
* name = "MindfulnessQuestionnaireExample"
* date = "2024-03-19"
* description = "Example questionnaire for daily mindfulness practice assessment"

* item[0]
  * linkId = "session_details"
  * text = "Session Details"
  * type = #group
  
  * item[0]
    * linkId = "duration"
    * text = "Duration (minutes)"
    * type = #integer
    * required = true
    
  * item[1]
    * linkId = "technique"
    * text = "Technique Used"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Mindful Breathing"
    * answerOption[1].valueString = "Body Scan"
    * answerOption[2].valueString = "Walking Meditation"
