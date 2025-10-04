Instance: SocialInteractionExample
InstanceOf: SocialInteractionProfile
Usage: #example
Description: "Social interaction observation example"
Title: "Social Interaction Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#76506-5 "Social connection and isolation panel"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-01-03T14:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = SocialInteractionTypeCS#family

* component[duration].valueQuantity = 120 'min' "minutes"
* component[quality].valueCodeableConcept = SocialInteractionQualityCS#meaningful
* component[medium].valueCodeableConcept = SocialInteractionMediumCS#inPerson
* component[participants].valueInteger = 4

* extension[context].valueCodeableConcept = SocialContextCS#home
* extension[support].valueCodeableConcept = SocialSupportCS#strong
* extension[activity].valueCodeableConcept = SocialActivityCS#meal
