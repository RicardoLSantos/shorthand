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
* code = $LOINC#76506-5 "Social connection and isolation panel"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] only CodeableConcept
* valueCodeableConcept from SocialInteractionTypeVS (required)

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    duration 0..1 MS and
    quality 0..1 MS and
    medium 0..1 MS and
    participants 0..1 MS

* component[duration]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#social-duration "Social interaction duration"
  * valueQuantity only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #min

* component[quality]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#social-quality "Social interaction quality score"
  * valueCodeableConcept from SocialInteractionQualityVS (required)

* component[medium]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#social-medium "Social interaction medium"
  * valueCodeableConcept from SocialInteractionMediumVS (required)

* component[participants]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#social-count "Number of social interactions"
  * valueInteger only integer

* extension contains
    SocialContext named context 0..1 MS and
    SocialSupport named support 0..1 MS and
    SocialActivity named activity 0..* MS
