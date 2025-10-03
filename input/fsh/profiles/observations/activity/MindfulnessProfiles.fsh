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
* code = $LIFESTYLEOBS#mindfulness-session "Mindfulness practice session"
* subject only Reference(Patient)
* effectiveDateTime 1..1
* performer only Reference(Practitioner or PractitionerRole)

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    sessionDuration 0..1 MS and
    stressLevel 0..1 MS and
    moodState 0..1 MS and
    relaxationResponse 0..1 MS and
    mindfulnessType 0..1 MS

* component[sessionDuration]
  * code = $SCT#704323007 "Process duration"
  * value[x] only Quantity
  * valueQuantity
    * value 1..1
    * unit = "min"
    * system = "http://unitsofmeasure.org"
    * code = #min

* component[stressLevel]
  * code = $SCT#365949003 "Health-related behavior finding"
  * value[x] only integer

* component[moodState]
  * code = $SCT#106131003 "Mood finding"
  * value[x] only CodeableConcept
  * valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mood (required)

* component[relaxationResponse]
  * code = $LIFESTYLEOBS#relaxation-response "Relaxation response observation"
  * value[x] only string

* component[mindfulnessType]
  * code = $LIFESTYLEOBS#mindfulness-type "Type of mindfulness practice"
  * value[x] only CodeableConcept
  * valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-type (required)
