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
* code = $SCT#285854004 "Emotion"
* subject only Reference(Patient)
* effectiveDateTime 1..1
* performer only Reference(Practitioner or PractitionerRole)

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    sessionDuration 0..1 and
    stressLevel 0..1 and
    moodState 0..1 and
    relaxationResponse 0..1 and
    mindfulnessType 0..1

* component[sessionDuration]
  * code = $SCT#704323007 "Process duration"
  * value[x] only Quantity
  * valueQuantity
    * value 1..1
    * unit = "min"
    * system = "http://unitsofmeasure.org"
    * code = #min

* component[stressLevel]
  * code = $SCT#725854004 "Assessment of stress level"
  * value[x] only integer
  * valueInteger
    * ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-minValueInteger"
    * ^extension[0].valueInteger = 0
    * ^extension[1].url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-maxValueInteger"
    * ^extension[1].valueInteger = 10

* component[moodState]
  * code = $SCT#106131003 "Mood finding"
  * value[x] only CodeableConcept
  * valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mood (required)

* component[relaxationResponse]
  * code = $SCT#276241001 "Relaxation technique"
  * value[x] only string

* component[mindfulnessType]
  * code = $SCT#285854004 "Emotion"
  * value[x] only CodeableConcept
  * valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-type (required)
