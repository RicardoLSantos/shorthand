ValueSet: SocialInteractionTypeVS
Id: social-interaction-type-vs
Title: "Social Interaction Type Value Set"
Description: "Types of social interactions"
* ^experimental = false
* codes from system SocialInteractionTypeCS

ValueSet: SocialInteractionQualityVS
Id: social-interaction-quality-vs
Title: "Social Interaction Quality Value Set"
Description: "Quality measures for social interactions"
* ^experimental = false
* codes from system SocialInteractionQualityCS

ValueSet: SocialInteractionMediumVS
Id: social-interaction-medium-vs
Title: "Social Interaction Medium Value Set"
Description: "Mediums through which social interaction occurs"
* ^experimental = false
* codes from system SocialInteractionMediumCS

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

CodeSystem: SocialInteractionQualityCS
Id: social-interaction-quality-cs
Title: "Social Interaction Quality Code System"
Description: "Quality measures for social interactions"
* ^experimental = false
* #meaningful "Meaningful" "Deep, meaningful interaction"
* #meaningful "Meaningful" "Deep and significant interaction"
* #supportive "Supportive" "Supportive interaction"
* #meaningful "Meaningful" "Deep and significant interaction"
* #neutral "Neutral" "Neither positive nor negative"
* #meaningful "Meaningful" "Deep and significant interaction"
* #superficial "Superficial" "Surface-level interaction"
* #meaningful "Meaningful" "Deep and significant interaction"
* #stressful "Stressful" "Stressful or difficult interaction"
* #meaningful "Meaningful" "Deep and significant interaction"

CodeSystem: SocialInteractionMediumCS
Id: social-interaction-medium-cs
Title: "Social Interaction Medium Code System"
Description: "Mediums through which social interaction occurs"
* ^experimental = false
* #inPerson "In Person" "Face-to-face interaction"
* #meaningful "Meaningful" "Deep and significant interaction"
* #video "Video Call" "Video-based interaction"
* #meaningful "Meaningful" "Deep and significant interaction"
* #voice "Voice Call" "Voice-only interaction"
* #meaningful "Meaningful" "Deep and significant interaction"
* #text "Text Based" "Text-based communication"
* #meaningful "Meaningful" "Deep and significant interaction"
* #social "Social Media" "Social media interaction"
* #meaningful "Meaningful" "Deep and significant interaction"
* #mixed "Mixed Medium" "Multiple communication methods"
* #meaningful "Meaningful" "Deep and significant interaction"
