// Originally defined on lines 1 - 21
Instance: SocialInteractionExample
InstanceOf: SocialInteractionProfile
Title: "Social Interaction Example"
Description: "Social interaction observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = http://loinc.org#96766-1 "Social interaction pattern"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-01-03T14:00:00Z"
* valueCodeableConcept = SocialInteractionTypeCS#family
* component[duration].valueQuantity = 120 'min' "minutes"
* component[quality].valueCodeableConcept = SocialInteractionQualityCS#meaningful
* component[medium].valueCodeableConcept = SocialInteractionMediumCS#inPerson
* component[participants].valueInteger = 4
* extension[context].valueCodeableConcept = SocialContextCS#home
* extension[support].valueCodeableConcept = SocialSupportCS#strong
* extension[activity].valueCodeableConcept = SocialActivityCS#meal

