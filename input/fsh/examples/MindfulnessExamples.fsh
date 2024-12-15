Instance: MindfulnessObservationExample
InstanceOf: MindfulnessObservation
Usage: #example
Title: "Example of Mindfulness Session Observation"

* status = #final
* code = $SCT#711020003 "Meditation"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T09:30:00Z"
* performer = Reference(Practitioner/example)

* component[sessionDuration].code = $SCT#118682006 "Duration"
* component[sessionDuration].valueQuantity = 20 'min' "minutes"

* component[stressLevel].code = $SCT#725854004 "Assessment of stress level"
* component[stressLevel].valueInteger = 4

* component[moodState].code = $SCT#373931001 "Mood finding"
* component[moodState].valueCodeableConcept = $SCT#130991005 "Neutral mood"

* component[relaxationResponse].code = $SCT#276241001 "Relaxation technique"
* component[relaxationResponse].valueString = "Deep breathing exercises helped reduce tension"

* component[mindfulnessType].code = $SCT#711020003 "Meditation"
* component[mindfulnessType].valueCodeableConcept = $SCT#711020003 "Meditation"

// New example for MindfulnessQuestionnaire
Instance: MindfulnessQuestionnaireExample
InstanceOf: Questionnaire
Usage: #example
Title: "Example of Mindfulness Questionnaire"

* url = "http://example.org/Questionnaire/mindfulness-example"
* status = #active
* title = "Daily Mindfulness Assessment"
* version = "1.0"
* name = "MindfulnessQuestionnaireExample"
* date = "2024-03-19"
* publisher = "Example Organization"
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
