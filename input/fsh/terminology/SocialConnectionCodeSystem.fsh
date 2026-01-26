// =============================================================================
// CodeSystem: Social Connection Assessment
// =============================================================================
// Created: 2026-01-15
// Purpose: Umbrella CodeSystem for social health assessment scope
// Used by: ConceptMapSocialToLOINC (sourceUri)
// =============================================================================

CodeSystem: SocialConnectionCS
Id: social-connection-cs
Title: "Social Connection Assessment CodeSystem"
Description: """
Umbrella CodeSystem defining the scope of social connection assessment concepts.

**Scope**: Social health assessments including:
- Loneliness assessment (UCLA Loneliness Scale)
- Social support (MSPSS, MOS-SSS)
- Family structure and living situation
- Social isolation risk factors

**Note**: Individual assessment components are defined in specialized CodeSystems:
- loneliness-component-cs: UCLA Loneliness Scale items
- social-support-component-cs: MSPSS/MOS-SSS components
- family-structure-cs: Household and family structure

**References**:
- Russell DW (1996). UCLA Loneliness Scale. J Personality Assessment 66(1):20-40
- Zimet GD et al. (1988). MSPSS. J Personality Assessment 52(1):30-41
- Lubben J et al. (2006). LSNS-6. J Gerontol B Psychol Sci Soc Sci 61(1):S75-84
"""
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/social-connection-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

// Domain concepts (umbrella level)
* #loneliness-assessment "Loneliness assessment" "UCLA Loneliness Scale or similar instrument"
* #social-support-assessment "Social support assessment" "MSPSS, MOS-SSS, or similar instrument"
* #family-structure-assessment "Family structure assessment" "Household composition and family relationships"
* #social-isolation-risk "Social isolation risk" "Overall social isolation risk assessment"
