// Originally defined on lines 1 - 30
Instance: CompleteMindfulnessSession
InstanceOf: MindfulnessObservation
Title: "Complete Mindfulness Session Example"
Description: "Complete mindfulness session observation example"
Usage: #example
* status = #final
* code = http://snomed.info/sct#285854004 "Emotion"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* component[sessionDuration].code = http://snomed.info/sct#118682006 "Duration"
* component[sessionDuration].valueQuantity = 20 'min'
* component[stressLevel].code = http://snomed.info/sct#725854004 "Assessment of stress level"
* component[stressLevel].valueInteger = 3
* component[moodState].code = http://snomed.info/sct#373931001 "Mood finding"
* component[moodState].valueCodeableConcept = http://snomed.info/sct#130991005 "Neutral mood"
* component[relaxationResponse].code = http://snomed.info/sct#276241001 "Relaxation technique"
* component[relaxationResponse].valueString = "Deep breathing exercises with progressive relaxation"
* component[mindfulnessType].code = http://snomed.info/sct#285854004 "Emotion"
* component[mindfulnessType].valueCodeableConcept = http://snomed.info/sct#285854004 "Emotion"
* extension[mindfulness-context].extension[location].valueString = "Home meditation room"
* extension[mindfulness-context].extension[environment].valueCodeableConcept = #quiet "Quiet Space"
* extension[mindfulness-context].extension[guidance].valueBoolean = true

// Originally defined on lines 32 - 77
Instance: CompleteMindfulnessResponse
InstanceOf: QuestionnaireResponse
Title: "Complete Mindfulness Session Response"
Description: "Complete mindfulness questionnaire response example"
Usage: #example
* questionnaire = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/daily-mindfulness"
* status = #completed
* subject = Reference(Patient/PatientExample)
* authored = "2024-03-19T08:30:00Z"
* item[0]
* item[0].linkId = "mindful_session"
* item[0].item[0]
* item[0].item[0].linkId = "session_duration"
* item[0].item[0].answer.valueInteger = 20
* item[0].item[1]
* item[0].item[1].linkId = "practice_type"
* item[0].item[1].answer.valueString = "Meditation"
* item[1]
* item[1].linkId = "mood_assessment"
* item[1].item[0]
* item[1].item[0].linkId = "current_mood"
* item[1].item[0].answer.valueCoding = http://snomed.info/sct#130991005 "Neutral mood"
* item[1].item[1]
* item[1].item[1].linkId = "mood_intensity"
* item[1].item[1].answer.valueInteger = 3
* item[2]
* item[2].linkId = "stress_assessment"
* item[2].item[0]
* item[2].item[0].linkId = "stress_level"
* item[2].item[0].answer.valueInteger = 3
* item[2].item[1]
* item[2].item[1].linkId = "stress_symptoms"
* item[2].item[1].answer[0].valueString = "Slight tension"
* item[3]
* item[3].linkId = "relaxation"
* item[3].item[0]
* item[3].item[0].linkId = "relaxation_duration"
* item[3].item[0].answer.valueInteger = 15
* item[3].item[1]
* item[3].item[1].linkId = "relaxation_technique"
* item[3].item[1].answer.valueString = "Deep breathing"

