Extension: SocialContext
Id: social-context
Title: "Social Context Extension"
Description: "Extension for recording the context of social interaction"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from SocialContextVS (required)

Extension: SocialSupport
Id: social-support
Title: "Social Support Extension"
Description: "Extension for recording perceived social support"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from SocialSupportVS (required)

Extension: SocialActivity
Id: social-activity
Title: "Social Activity Extension"
Description: "Extension for recording specific social activities"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from SocialActivityVS (required)

ValueSet: SocialContextVS
Id: social-context-vs
Title: "Social Context Value Set"
Description: "Value set for social interaction contexts"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS

ValueSet: SocialSupportVS
Id: social-support-vs
Title: "Social Support Value Set"
Description: "Value set for levels of social support"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS

ValueSet: SocialActivityVS
Id: social-activity-vs
Title: "Social Activity Value Set"
Description: "Value set for types of social activities"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS
