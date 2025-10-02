// Originally defined on lines 1 - 53
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
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1
* code MS
* code = http://loinc.org#96766-1 "Social interaction pattern"
* subject 1..1
* subject MS
* effectiveDateTime 1..1
* effectiveDateTime MS
* value[x] only CodeableConcept
* valueCodeableConcept from SocialInteractionTypeVS (required)
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    duration 0.. and
    quality 0.. and
    medium 0.. and
    participants 0..
* component[duration] 0..1
* component[duration] MS
* component[quality] 0..1
* component[quality] MS
* component[medium] 0..1
* component[medium] MS
* component[participants] 0..1
* component[participants] MS
* component[duration].code = http://loinc.org#89597-9 "Social interaction duration"
* component[duration].valueQuantity only Quantity
* component[duration].valueQuantity.system = "http://unitsofmeasure.org"
* component[duration].valueQuantity.code = #min
* component[quality].code = http://loinc.org#89598-7 "Social interaction quality"
* component[quality].valueCodeableConcept from SocialInteractionQualityVS (required)
* component[medium].code = http://loinc.org#89599-5 "Social interaction medium"
* component[medium].valueCodeableConcept from SocialInteractionMediumVS (required)
* component[participants].code = http://loinc.org#89600-1 "Social interaction participants"
* component[participants].valueInteger only integer
* extension contains
    SocialContext named context 0.. and
    SocialSupport named support 0.. and
    SocialActivity named activity 0..
* extension[context] 0..1
* extension[context] MS
* extension[support] 0..1
* extension[support] MS
* extension[activity] 0..*
* extension[activity] MS

