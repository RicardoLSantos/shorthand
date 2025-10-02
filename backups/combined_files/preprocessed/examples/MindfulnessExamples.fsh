// Originally defined on lines 1 - 26
Instance: MindfulnessObservationExample
InstanceOf: MindfulnessObservation
Title: "Example of Mindfulness Session Observation"
Description: "Mindfulness observation example"
Usage: #example
* status = #final
* code = http://snomed.info/sct#285854004 "Emotion"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T09:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* component[sessionDuration].code = http://snomed.info/sct#118682006 "Duration"
* component[sessionDuration].valueQuantity = 20 'min'
* component[stressLevel].code = http://snomed.info/sct#725854004 "Assessment of stress level"
* component[stressLevel].valueInteger = 4
* component[moodState].code = http://snomed.info/sct#373931001 "Mood finding"
* component[moodState].valueCodeableConcept = http://snomed.info/sct#130991005 "Neutral mood"
* component[relaxationResponse].code = http://snomed.info/sct#276241001 "Relaxation technique"
* component[relaxationResponse].valueString = "Deep breathing exercises helped reduce tension"
* component[mindfulnessType].code = http://snomed.info/sct#285854004 "Emotion"
* component[mindfulnessType].valueCodeableConcept = http://snomed.info/sct#285854004 "Emotion"

// Originally defined on lines 29 - 60
Instance: MindfulnessQuestionnaireExample
InstanceOf: Questionnaire
Title: "Example of Mindfulness Questionnaire"
Usage: #example
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/mindfulness-example"
* status = #active
* title = "Daily Mindfulness Assessment"
* version = "1.0"
* name = "MindfulnessQuestionnaireExample"
* date = "2024-03-19"
* description = "Example questionnaire for daily mindfulness practice assessment"
* item[0]
* item[0].linkId = "session_details"
* item[0].text = "Session Details"
* item[0].type = #group
* item[0].item[0]
* item[0].item[0].linkId = "duration"
* item[0].item[0].text = "Duration (minutes)"
* item[0].item[0].type = #integer
* item[0].item[0].required = true
* item[0].item[1]
* item[0].item[1].linkId = "technique"
* item[0].item[1].text = "Technique Used"
* item[0].item[1].type = #choice
* item[0].item[1].required = true
* item[0].item[1].answerOption[0].valueString = "Mindful Breathing"
* item[0].item[1].answerOption[1].valueString = "Body Scan"
* item[0].item[1].answerOption[2].valueString = "Walking Meditation"

