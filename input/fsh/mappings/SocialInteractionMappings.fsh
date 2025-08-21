Mapping: SocialInteractionToHealthKit
Id: social-interaction-to-healthkit
Description: "Definition for social-interaction-to-healthkit resource"Title: "Mapping to Apple HealthKit"
Source: SocialInteractionProfile
Target: "http://developer.apple.com/documentation/healthkit"

* -> "HKCategoryTypeIdentifierSocialInteraction" "Root mapping"
* valueCodeableConcept -> "interactionType" "Type of interaction"
* component[duration] -> "duration" "Duration of interaction"
* component[participants] -> "participantCount" "Number of participants"

Mapping: SocialInteractionToLOINC
Id: social-interaction-to-loinc
Title: "Mapping to LOINC codes"
Source: SocialInteractionProfile
Target: "http://loinc.org"

* -> "96766-1" "Social Interaction Panel"
* component[duration] -> "89597-9" "Interaction duration"
* component[quality] -> "89598-7" "Interaction quality"
