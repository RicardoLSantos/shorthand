// ConceptMap: ICD-10-CM to ICD-11 Lifestyle Medicine Codes
// Created: 2026-01-26
// Purpose: Translation between ICD-10-CM and ICD-11 lifestyle medicine codes
// Reference: WHO ICD-11 MMS 2024-01, ICD-10-CM 2024

Instance: icd10-to-icd11-lifestyle
InstanceOf: ConceptMap
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/icd10-to-icd11-lifestyle"
* version = "0.1.0"
* name = "ICD10ToICD11LifestyleConceptMap"
* title = "ICD-10-CM to ICD-11 Lifestyle Medicine ConceptMap"
* status = #active
* experimental = false
* date = "2026-01-26"
* publisher = "Ricardo Lourenco dos Santos, FMUP"
* description = """
Maps ICD-10-CM lifestyle-related codes to their ICD-11 equivalents.
This ConceptMap supports transition from ICD-10-CM to ICD-11 for
lifestyle medicine documentation in clinical systems.

Note: ICD-11 provides more specific lifestyle categorization compared to ICD-10-CM.
Some ICD-10-CM codes map to multiple ICD-11 concepts (narrow-to-broad).
"""

// Note: Using group-level source/target instead of top-level sourceUri/targetUri
// to avoid FHIR validator strictness about CodeSystem vs ValueSet references

// =============================================================================
// HEALTH BEHAVIOURS MAPPINGS
// =============================================================================

* group[+].source = "http://hl7.org/fhir/sid/icd-10-cm"
* group[=].target = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs"

// Tobacco/Nicotine Use
* group[=].element[+].code = #Z72.0
* group[=].element[=].display = "Tobacco use"
* group[=].element[=].target[+].code = #QE12
* group[=].element[=].target[=].display = "Hazardous nicotine use"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "ICD-11 broadens to all nicotine products including vaping"

// Alcohol Use
* group[=].element[+].code = #Z72.1
* group[=].element[=].display = "Alcohol use"
* group[=].element[=].target[+].code = #QE10
* group[=].element[=].target[=].display = "Hazardous alcohol use"
* group[=].element[=].target[=].equivalence = #equivalent

// Drug Use
* group[=].element[+].code = #Z72.2
* group[=].element[=].display = "Drug use"
* group[=].element[=].target[+].code = #QE11
* group[=].element[=].target[=].display = "Hazardous drug use"
* group[=].element[=].target[=].equivalence = #equivalent

// Lack of Physical Exercise
* group[=].element[+].code = #Z72.3
* group[=].element[=].display = "Lack of physical exercise"
* group[=].element[=].target[+].code = #QD80
* group[=].element[=].target[=].display = "Problems associated with lifestyle"
* group[=].element[=].target[=].equivalence = #wider
* group[=].element[=].target[=].comment = "ICD-11 QD80 is broader, covering multiple lifestyle factors"

// Inappropriate Diet
* group[=].element[+].code = #Z72.4
* group[=].element[=].display = "Inappropriate diet and eating habits"
* group[=].element[=].target[+].code = #QD61
* group[=].element[=].target[=].display = "Problems associated with dietary inadequacy"
* group[=].element[=].target[=].equivalence = #equivalent

// High Risk Sexual Behavior - maps to other health behaviours
* group[=].element[+].code = #Z72.5
* group[=].element[=].display = "High risk sexual behavior"
* group[=].element[=].target[+].code = #QE1Y
* group[=].element[=].target[=].display = "Other specified problems associated with health behaviours"
* group[=].element[=].target[=].equivalence = #wider

// Gambling and Betting
* group[=].element[+].code = #Z72.6
* group[=].element[=].display = "Gambling and betting"
* group[=].element[=].target[+].code = #QE1Y
* group[=].element[=].target[=].display = "Other specified problems associated with health behaviours"
* group[=].element[=].target[=].equivalence = #wider
* group[=].element[=].target[=].comment = "ICD-11 has dedicated gambling disorder codes in Chapter 6"

// =============================================================================
// SLEEP DISORDER MAPPINGS
// =============================================================================

// Sleep Deprivation
* group[=].element[+].code = #Z72.820
* group[=].element[=].display = "Sleep deprivation"
* group[=].element[=].target[+].code = #7A00
* group[=].element[=].target[=].display = "Insomnia disorders"
* group[=].element[=].target[=].equivalence = #wider
* group[=].element[=].target[=].comment = "Sleep deprivation may be voluntary; insomnia is pathological"

// Inadequate Sleep Hygiene
* group[=].element[+].code = #Z72.821
* group[=].element[=].display = "Inadequate sleep hygiene"
* group[=].element[=].target[+].code = #7A00
* group[=].element[=].target[=].display = "Insomnia disorders"
* group[=].element[=].target[=].equivalence = #wider

// =============================================================================
// OBESITY AND NUTRITION MAPPINGS
// =============================================================================

// Overweight
* group[=].element[+].code = #E66.3
* group[=].element[=].display = "Overweight"
* group[=].element[=].target[+].code = #5B81
* group[=].element[=].target[=].display = "Overweight"
* group[=].element[=].target[=].equivalence = #equivalent

// Obesity, unspecified
* group[=].element[+].code = #E66.9
* group[=].element[=].display = "Obesity, unspecified"
* group[=].element[=].target[+].code = #5B82
* group[=].element[=].target[=].display = "Obesity"
* group[=].element[=].target[=].equivalence = #equivalent

// Morbid obesity (severe)
* group[=].element[+].code = #E66.01
* group[=].element[=].display = "Morbid (severe) obesity due to excess calories"
* group[=].element[=].target[+].code = #5B82
* group[=].element[=].target[=].display = "Obesity"
* group[=].element[=].target[=].equivalence = #wider
* group[=].element[=].target[=].comment = "ICD-11 5B82 includes severity subtypes"

// Adult malnutrition
* group[=].element[+].code = #E46
* group[=].element[=].display = "Unspecified protein-calorie malnutrition"
* group[=].element[=].target[+].code = #5B72
* group[=].element[=].target[=].display = "Undernutrition in adults"
* group[=].element[=].target[=].equivalence = #equivalent

// =============================================================================
// OCCUPATIONAL/LIFESTYLE FACTOR MAPPINGS
// =============================================================================

// Burnout
* group[=].element[+].code = #Z73.0
* group[=].element[=].display = "Burn-out"
* group[=].element[=].target[+].code = #QD85
* group[=].element[=].target[=].display = "Burnout"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "ICD-11 provides WHO-endorsed definition of burnout syndrome"

// Lack of relaxation and leisure
* group[=].element[+].code = #Z73.2
* group[=].element[=].display = "Lack of relaxation and leisure"
* group[=].element[=].target[+].code = #QD80
* group[=].element[=].target[=].display = "Problems associated with lifestyle"
* group[=].element[=].target[=].equivalence = #wider

// Stress, not elsewhere classified
* group[=].element[+].code = #Z73.3
* group[=].element[=].display = "Stress, not elsewhere classified"
* group[=].element[=].target[+].code = #QD80
* group[=].element[=].target[=].display = "Problems associated with lifestyle"
* group[=].element[=].target[=].equivalence = #wider

// =============================================================================
// PHYSICAL ACTIVITY CONTEXT MAPPINGS (Y93.* External Cause Codes)
// =============================================================================

// Walking activity
* group[=].element[+].code = #Y93.01
* group[=].element[=].display = "Activity, walking, marching and hiking"
* group[=].element[=].target[+].code = #XE5A1
* group[=].element[=].target[=].display = "Walking as physical activity"
* group[=].element[=].target[=].equivalence = #equivalent

// Running activity
* group[=].element[+].code = #Y93.02
* group[=].element[=].display = "Activity, running"
* group[=].element[=].target[+].code = #XE5A2
* group[=].element[=].target[=].display = "Running or jogging"
* group[=].element[=].target[=].equivalence = #equivalent

// Swimming activity
* group[=].element[+].code = #Y93.11
* group[=].element[=].display = "Activity, swimming"
* group[=].element[=].target[+].code = #XE5A4
* group[=].element[=].target[=].display = "Swimming"
* group[=].element[=].target[=].equivalence = #equivalent

// Bike riding
* group[=].element[+].code = #Y93.55
* group[=].element[=].display = "Activity, bike riding"
* group[=].element[=].target[+].code = #XE5A3
* group[=].element[=].target[=].display = "Cycling"
* group[=].element[=].target[=].equivalence = #equivalent

// Exercise machines
* group[=].element[+].code = #Y93.A1
* group[=].element[=].display = "Activity, exercise machines primarily for cardiorespiratory conditioning"
* group[=].element[=].target[+].code = #XE5A6
* group[=].element[=].target[=].display = "Exercise or fitness activities"
* group[=].element[=].target[=].equivalence = #equivalent

