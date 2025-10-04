// Originally defined on lines 1 - 6
ValueSet: SocialInteractionTypeVS
Id: social-interaction-type-vs
Title: "Social Interaction Type Value Set"
Description: "Types of social interactions"
* ^experimental = false
* include codes from system SocialInteractionTypeCS

// Originally defined on lines 8 - 13
ValueSet: SocialInteractionQualityVS
Id: social-interaction-quality-vs
Title: "Social Interaction Quality Value Set"
Description: "Quality measures for social interactions"
* ^experimental = false
* include codes from system SocialInteractionQualityCS

// Originally defined on lines 15 - 20
ValueSet: SocialInteractionMediumVS
Id: social-interaction-medium-vs
Title: "Social Interaction Medium Value Set"
Description: "Mediums through which social interaction occurs"
* ^experimental = false
* include codes from system SocialInteractionMediumCS

// Originally defined on lines 22 - 32
CodeSystem: SocialInteractionTypeCS
Id: social-interaction-type-cs
Title: "Social Interaction Type Code System"
Description: "Types of social interactions"
* ^experimental = false
* #family "Family Interaction" "Interaction with family members"
* #friends "Friend Interaction" "Interaction with friends"
* #professional "Professional Interaction" "Work-related interactions"
* #community "Community Interaction" "Community-based interactions"
* #group "Group Activity" "Organized group activities"
* #casual "Casual Interaction" "Casual social encounters"

// Originally defined on lines 34 - 43
CodeSystem: SocialInteractionQualityCS
Id: social-interaction-quality-cs
Title: "Social Interaction Quality Code System"
Description: "Quality measures for social interactions"
* ^experimental = false
* #meaningful "Meaningful" "Deep, meaningful interaction"
* #supportive "Supportive" "Supportive interaction"
* #neutral "Neutral" "Neither positive nor negative"
* #superficial "Superficial" "Surface-level interaction"
* #stressful "Stressful" "Stressful or difficult interaction"

// Originally defined on lines 44 - 55
CodeSystem: SocialInteractionMediumCS
Id: social-interaction-medium-cs
Title: "Social Interaction Medium Code System"
Description: "Mediums through which social interaction occurs"
* ^experimental = false
* #inPerson "In Person" "Face-to-face interaction"
* #meaningful "Meaningful" "Deep and significant interaction"
* #video "Video Call" "Video-based interaction"
* #voice "Voice Call" "Voice-only interaction"
* #text "Text Based" "Text-based communication"
* #social "Social Media" "Social media interaction"
* #mixed "Mixed Medium" "Multiple communication methods"

