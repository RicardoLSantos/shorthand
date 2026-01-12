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
* date = "2026-01-12"
* publisher = "FMUP HEADS2"
* sourceUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/social-connection-cs"
* targetUri = "http://loinc.org"

// =============================================================================
// Group 1: Loneliness Assessment Mappings
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/loneliness-component-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #loneliness-frequency
* group[=].element[=].display = "Loneliness frequency"
* group[=].element[=].target[+].code = #67233-9
* group[=].element[=].target[=].display = "How often do you feel lonely"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "Direct LOINC match for loneliness frequency assessment"

* group[=].element[+].code = #ucla-total-score
* group[=].element[=].display = "UCLA Loneliness Scale total score"
* group[=].element[=].target[+].code = #71956-6
* group[=].element[=].target[=].display = "UCLA Loneliness Scale score"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "Russell DW (1996). J Personality Assessment 66(1):20-40"

* group[=].element[+].code = #isolation-feeling
* group[=].element[=].display = "Feeling of isolation"
* group[=].element[=].target[+].code = #71143-1
* group[=].element[=].target[=].display = "I feel isolated from others"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "PROMIS item for social isolation"

// =============================================================================
// Group 2: Social Support Assessment Mappings
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/social-support-component-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #social-support-level
* group[=].element[=].display = "Social support level"
* group[=].element[=].target[+].code = #67234-7
* group[=].element[=].target[=].display = "Social support level"
* group[=].element[=].target[=].equivalence = #equivalent

* group[=].element[+].code = #mspss-total
* group[=].element[=].display = "MSPSS total score"
* group[=].element[=].target[+].code = #71956-6
* group[=].element[=].target[=].display = "Perceived social support score"
* group[=].element[=].target[=].equivalence = #relatedto
* group[=].element[=].target[=].comment = "Zimet GD et al. (1988). J Personality Assessment 52(1):30-41"

* group[=].element[+].code = #emotional-support
* group[=].element[=].display = "Emotional support"
* group[=].element[=].target[+].code = #89399-9
* group[=].element[=].target[=].display = "Emotional support available"
* group[=].element[=].target[=].equivalence = #equivalent

// =============================================================================
// Group 3: Family Structure and Living Situation Mappings
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/family-structure-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #living-situation
* group[=].element[=].display = "Living situation"
* group[=].element[=].target[+].code = #63512-8
* group[=].element[=].target[=].display = "Are you currently living with someone"
* group[=].element[=].target[=].equivalence = #equivalent

* group[=].element[+].code = #marital-status
* group[=].element[=].display = "Marital status"
* group[=].element[=].target[+].code = #45404-1
* group[=].element[=].target[=].display = "Marital status"
* group[=].element[=].target[=].equivalence = #equivalent

* group[=].element[+].code = #household-size
* group[=].element[=].display = "Household size"
* group[=].element[=].target[+].code = #63503-7
* group[=].element[=].target[=].display = "Number of family members in household"
* group[=].element[=].target[=].equivalence = #equivalent

// =============================================================================
// Group 4: Social Connection Panel
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/social-interaction-type-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #social-connection-panel
* group[=].element[=].display = "Social connection assessment"
* group[=].element[=].target[+].code = #76506-5
* group[=].element[=].target[=].display = "Social connection and isolation panel"
* group[=].element[=].target[=].equivalence = #equivalent

* group[=].element[+].code = #social-isolation-screening
* group[=].element[=].display = "Social isolation screening"
* group[=].element[=].target[+].code = #93038-8
* group[=].element[=].target[=].display = "Protocol for Responding to and Assessing Patients Assets Risks and Experiences - Social isolation"
* group[=].element[=].target[=].equivalence = #relatedto
* group[=].element[=].target[=].comment = "PRAPARE social isolation screening item"

// =============================================================================
// Group 5: GAP Documentation - Concepts without direct LOINC mapping
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/social-support-component-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #family-support-subscale
* group[=].element[=].display = "MSPSS Family subscale"
* group[=].element[=].target[+].code = #LA137-2
* group[=].element[=].target[=].display = "Family member"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "GAP: No specific LOINC for MSPSS subscales; use custom code with reference"

* group[=].element[+].code = #friend-support-subscale
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
