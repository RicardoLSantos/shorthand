Extension: SocialContext
Id: social-context
Title: "Social Context Extension"
Description: "Extension for recording the context of social interaction"
* ^experimental = true
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from SocialContextVS (extensible)

Extension: SocialSupport
Id: social-support
Title: "Social Support Extension"
Description: "Extension for recording perceived social support"
* ^experimental = true
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from SocialSupportVS (extensible)

Extension: SocialActivity
Id: social-activity
Title: "Social Activity Extension"
Description: "Extension for recording specific social activities"
* ^experimental = true
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from SocialActivityVS (extensible)

ValueSet: SocialContextVS
Id: social-context-vs
Title: "Social Context Value Set"
Description: "Value set for social interaction contexts"
* ^experimental = true
* LifestyleMedicineTemporaryCS#social-context-home "Home"
* LifestyleMedicineTemporaryCS#social-context-work "Work"
* LifestyleMedicineTemporaryCS#education "Educational"
* LifestyleMedicineTemporaryCS#social-context-community "Community"
* LifestyleMedicineTemporaryCS#social-context-recreational "Recreational"
* LifestyleMedicineTemporaryCS#healthcare "Healthcare"

ValueSet: SocialSupportVS
Id: social-support-vs
Title: "Social Support Value Set"
Description: "Value set for levels of social support"
* ^experimental = true
* AppLogicCS#strong "Strong Support"
* AppLogicCS#adequate "Adequate Support"
* AppLogicCS#limited "Limited Support"
* AppLogicCS#social-support-minimal "Minimal Support"
* AppLogicCS#social-support-none "No Support"

ValueSet: SocialActivityVS
Id: social-activity-vs
Title: "Social Activity Value Set"
Description: "Value set for types of social activities"
* ^experimental = true
* LifestyleMedicineTemporaryCS#meal "Shared Meal"
* LifestyleMedicineTemporaryCS#social-activity-exercise "Group Exercise"
* LifestyleMedicineTemporaryCS#entertainment "Entertainment"
* LifestyleMedicineTemporaryCS#learning "Learning"
* LifestyleMedicineTemporaryCS#volunteering "Volunteering"
* LifestyleMedicineTemporaryCS#social-activity-celebration "Celebration"
