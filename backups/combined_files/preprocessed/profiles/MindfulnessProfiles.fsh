// Originally defined on lines 1 - 62
Profile: MindfulnessObservation
Parent: Observation
Id: mindfulness-observation
Title: "Mindfulness Session Observation"
Description: "Profile for recording mindfulness practice sessions and outcomes"
* status MS
* code MS
* subject MS
* effectiveDateTime MS
* performer MS
* value[x] MS
* component MS
* status = #final
* code = http://snomed.info/sct#285854004 "Emotion"
* subject only Reference(Patient)
* effectiveDateTime 1..1
* performer only Reference(Practitioner or PractitionerRole)
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    sessionDuration 0.. and
    stressLevel 0.. and
    moodState 0.. and
    relaxationResponse 0.. and
    mindfulnessType 0..
* component[sessionDuration] 0..1
* component[stressLevel] 0..1
* component[moodState] 0..1
* component[relaxationResponse] 0..1
* component[mindfulnessType] 0..1
* component[sessionDuration].code = http://snomed.info/sct#118682006 "Duration"
* component[sessionDuration].value[x] only Quantity
* component[sessionDuration].valueQuantity.value 1..1
* component[sessionDuration].valueQuantity.unit = "min"
* component[sessionDuration].valueQuantity.system = "http://unitsofmeasure.org"
* component[sessionDuration].valueQuantity.code = #min
* component[stressLevel].code = http://snomed.info/sct#725854004 "Assessment of stress level"
* component[stressLevel].value[x] only integer
* component[stressLevel].valueInteger ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-minValueInteger"
* component[stressLevel].valueInteger ^extension[0].valueInteger = 0
* component[stressLevel].valueInteger ^extension[1].url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-maxValueInteger"
* component[stressLevel].valueInteger ^extension[1].valueInteger = 10
* component[moodState].code = http://snomed.info/sct#373931001 "Mood finding"
* component[moodState].value[x] only CodeableConcept
* component[moodState].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mood (required)
* component[relaxationResponse].code = http://snomed.info/sct#276241001 "Relaxation technique"
* component[relaxationResponse].value[x] only string
* component[mindfulnessType].code = http://snomed.info/sct#285854004 "Emotion"
* component[mindfulnessType].value[x] only CodeableConcept
* component[mindfulnessType].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-type (required)

