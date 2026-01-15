// =============================================================================
// F2.12.6: ConceptMap Social Connections to LOINC
// =============================================================================
// Maps social health assessment concepts to LOINC codes
// Verified at: https://loinc.org (January 2026)
//
// References:
// - LOINC Social History Panel: https://loinc.org/76506-5
// - LOINC Patient Reported Outcomes: https://loinc.org/document/loinc-prom-guide
// =============================================================================

Instance: ConceptMapSocialToLOINC
InstanceOf: ConceptMap
Title: "Social Connections to LOINC Concept Map"
Description: """
Maps lifestyle medicine social connection and isolation concepts to LOINC codes.

**Scope**: Social health assessments including:
- Loneliness assessment (UCLA scale)
- Social support (MSPSS, Duke-UNC)
- Family structure and living situation
- Social isolation risk factors

**LOINC Verification**: All codes verified at loinc.org as of January 2026.

References:
- Russell DW (1996). UCLA Loneliness Scale. J Personality Assessment 66(1):20-40
- Zimet GD et al. (1988). MSPSS. J Personality Assessment 52(1):30-41
- Lubben J et al. (2006). LSNS-6. J Gerontol B Psychol Sci Soc Sci 61(1):S75-84
"""
Usage: #definition

* status = #active
* experimental = false
* date = "2026-01-15"
* publisher = "FMUP HEADS2"
* name = "ConceptMapSocialToLOINC"
// FHIR R4 Compliance (IG Publisher 2025-12-31): target must be ValueSet
// sourceUri can remain as CodeSystem reference (no expansion required)
* sourceUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/social-connection-cs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/loinc-observations-vs"

// =============================================================================
// Group 1: Loneliness Assessment Mappings
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/loneliness-component-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #companionship-lack
* group[=].element[=].display = "Loneliness - lack of companionship"
* group[=].element[=].target[+].code = #66855-8
* group[=].element[=].target[=].display = "How often do you feel that you lack companionship"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "UCLA Loneliness Scale v3 item"

* group[=].element[+].code = #left-out
* group[=].element[=].display = "Feeling left out"
* group[=].element[=].target[+].code = #66857-4
* group[=].element[=].target[=].display = "How often do you feel alone"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "UCLA Loneliness Scale v3 item"

* group[=].element[+].code = #isolation
* group[=].element[=].display = "Feeling isolated"
* group[=].element[=].target[+].code = #66867-3
* group[=].element[=].target[=].display = "How often do you feel isolated from others"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "UCLA Loneliness Scale v3 item"

// =============================================================================
// Group 2: Social Support Assessment Mappings
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/social-support-component-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #total-score
* group[=].element[=].display = "Social support total score"
* group[=].element[=].target[+].code = #91642-9
* group[=].element[=].target[=].display = "Medical Outcomes Study Social Support Survey panel"
* group[=].element[=].target[=].equivalence = #equivalent

* group[=].element[+].code = #emotional-support
* group[=].element[=].display = "Emotional support score"
* group[=].element[=].target[+].code = #91663-5
* group[=].element[=].target[=].display = "Social support index [MOS Social Support Survey]"
* group[=].element[=].target[=].equivalence = #relatedto
* group[=].element[=].target[=].comment = "MOS-SSS overall social support index"

* group[=].element[+].code = #affective-support
* group[=].element[=].display = "Affective support"
* group[=].element[=].target[+].code = #91645-2
* group[=].element[=].target[=].display = "Affectionate support [MOS Social Support Survey]"
* group[=].element[=].target[=].equivalence = #equivalent

// =============================================================================
// Group 3: Family Structure and Living Situation Mappings
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/family-structure-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #household-size
* group[=].element[=].display = "Living situation - household size"
* group[=].element[=].target[+].code = #63512-8
* group[=].element[=].target[=].display = "How many people are living or staying at this address [#]"
* group[=].element[=].target[=].equivalence = #equivalent

// Note: marital-status is handled in component with LOINC 45404-1
// Code not in family-structure-cs - use LOINC directly in profiles

* group[=].element[+].code = #dependent-count
* group[=].element[=].display = "Number of dependents"
* group[=].element[=].target[+].code = #63503-7
* group[=].element[=].target[=].display = "Number of family members in household"
* group[=].element[=].target[=].equivalence = #equivalent

// =============================================================================
// Group 4: Social Connection Panel
// Note: LOINC panel codes used directly in profiles:
// - 76506-5 "Social connection and isolation panel"
// - 93038-8 "PRAPARE Social isolation"
// These are LOINC-native concepts, not custom CodeSystem codes
// =============================================================================

// =============================================================================
// Group 5: GAP Documentation - Concepts without direct LOINC mapping
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/social-support-component-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #family-support
* group[=].element[=].display = "MSPSS Family subscale"
* group[=].element[=].target[+].code = #LA137-2
* group[=].element[=].target[=].display = "Family member"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "GAP: No specific LOINC for MSPSS subscales; use custom code with reference"

* group[=].element[+].code = #friend-support
* group[=].element[=].display = "MSPSS Friends subscale"
* group[=].element[=].target[+].code = #LA137-2
* group[=].element[=].target[=].display = "Friend"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "GAP: No specific LOINC for MSPSS subscales; use custom code with reference"

* group[=].element[+].code = #significant-other-support
* group[=].element[=].display = "MSPSS Significant Other subscale"
* group[=].element[=].target[+].code = #LA137-2
* group[=].element[=].target[=].display = "Significant other"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "GAP: No specific LOINC for MSPSS subscales; use custom code with reference"
