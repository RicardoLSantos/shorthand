// Originally defined on lines 1 - 7
Extension: SocialContext
Parent: Extension
Id: social-context
Title: "Social Context Extension"
Description: "Extension for recording the context of social interaction"
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept from SocialContextVS (required)
* extension 0..0

// Originally defined on lines 9 - 15
Extension: SocialSupport
Parent: Extension
Id: social-support
Title: "Social Support Extension"
Description: "Extension for recording perceived social support"
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept from SocialSupportVS (required)
* extension 0..0

// Originally defined on lines 17 - 23
Extension: SocialActivity
Parent: Extension
Id: social-activity
Title: "Social Activity Extension"
Description: "Extension for recording specific social activities"
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept from SocialActivityVS (required)
* extension 0..0

// Originally defined on lines 25 - 30
ValueSet: SocialContextVS
Id: social-context-vs
Title: "Social Context Value Set"
Description: "Value set for social interaction contexts"
* ^experimental = false
* include codes from system SocialContextCS

// Originally defined on lines 32 - 37
ValueSet: SocialSupportVS
Id: social-support-vs
Title: "Social Support Value Set"
Description: "Value set for levels of social support"
* ^experimental = false
* include codes from system SocialSupportCS

// Originally defined on lines 39 - 44
ValueSet: SocialActivityVS
Id: social-activity-vs
Title: "Social Activity Value Set"
Description: "Value set for types of social activities"
* ^experimental = false
* include codes from system SocialActivityCS

// Originally defined on lines 46 - 56
CodeSystem: SocialContextCS
Id: social-context-cs
Title: "Social Context Code System"
Description: "Code system for social interaction contexts"
* ^experimental = false
* #home "Home" "Home environment"
* #work "Work" "Work environment"
* #education "Educational" "Educational setting"
* #community "Community" "Community setting"
* #recreational "Recreational" "Recreational setting"
* #healthcare "Healthcare" "Healthcare setting"

// Originally defined on lines 58 - 67
CodeSystem: SocialSupportCS
Id: social-support-cs
Title: "Social Support Code System"
Description: "Code system for levels of social support"
* ^experimental = false
* #strong "Strong Support" "Strong social support network"
* #adequate "Adequate Support" "Sufficient social support"
* #limited "Limited Support" "Limited social support"
* #minimal "Minimal Support" "Minimal social support"
* #none "No Support" "Absence of social support"

// Originally defined on lines 69 - 79
CodeSystem: SocialActivityCS
Id: social-activity-cs
Title: "Social Activity Code System"
Description: "Code system for types of social activities"
* ^experimental = false
* #meal "Shared Meal" "Sharing a meal together"
* #exercise "Group Exercise" "Group physical activity"
* #entertainment "Entertainment" "Shared entertainment activity"
* #learning "Learning" "Group learning activity"
* #volunteering "Volunteering" "Community service activity"
* #celebration "Celebration" "Social celebration or event"

