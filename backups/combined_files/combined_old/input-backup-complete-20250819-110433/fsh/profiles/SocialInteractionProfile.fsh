Profile: SocialInteractionProfile
Parent: Observation
Id: social-interaction
Title: "Social Interaction Profile"
Description: "Profile for recording social interaction data from iOS Health App"

* ^version = "0.1.0"
* ^status = #active
* ^date = "2024-01-03"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = $LOINC#96766-1 "Social interaction pattern"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] only CodeableConcept
* valueCodeableConcept from SocialInteractionTypeVS (required)

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    duration 0..1 MS and
    quality 0..1 MS and
    medium 0..1 MS and
    participants 0..1 MS

* component[duration]
  * code = $LOINC#89597-9 "Social interaction duration"
  * valueQuantity only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #min

* component[quality]
  * code = $LOINC#89598-7 "Social interaction quality"
  * valueCodeableConcept from SocialInteractionQualityVS (required)

* component[medium]
  * code = $LOINC#89599-5 "Social interaction medium"
  * valueCodeableConcept from SocialInteractionMediumVS (required)

* component[participants]
  * code = $LOINC#89600-1 "Social interaction participants"
  * valueInteger only integer

* extension contains
    SocialContext named context 0..1 MS and
    SocialSupport named support 0..1 MS and
    SocialActivity named activity 0..* MS
