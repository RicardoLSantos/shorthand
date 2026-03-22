// ICD-11 Lifestyle Medicine CodeSystem (Fragment/Supplement)
// Created: 2026-01-26
// Removed Phase 6a (2026-03-02): Referenced WHO URL directly in ValueSets
// Restored 2026-03-22 T1 S12: IG Publisher v2.2.1 now validates ICD-11 codes as errors
//   (not warnings). Stub fragment required to declare codes exist in WHO system.
//
// DESIGN DECISION:
// This CodeSystem is a #fragment supplement for WHO ICD-11 MMS because:
// 1. ICD-11 is not available on tx.fhir.org for FHIR validation
// 2. IG Publisher v2.2.1+ treats unknown CodeSystem codes as errors
// 3. All codes are exact copies from WHO ICD-11 MMS 2024-01
// 4. URL matches the WHO official system URL used in ValueSets
// Future: Remove when tx.fhir.org adds ICD-11 support

CodeSystem: ICD11LifestyleMedicineFragment
Id: icd-11-lifestyle-fragment
Title: "ICD-11 Lifestyle Medicine Codes (Fragment)"
Description: """
FRAGMENT of ICD-11 codes relevant to lifestyle medicine from WHO ICD-11 MMS 2024-01.
This supplement declares 34 codes used in the IG's ValueSets so the IG Publisher can
validate them. The authoritative source is WHO ICD-11 at https://icd.who.int.
"""

* ^url = "http://id.who.int/icd/release/11/mms"
* ^version = "2024-01"
* ^status = #active
* ^experimental = false
* ^date = "2026-03-22"
* ^publisher = "World Health Organization (WHO)"
* ^contact.name = "WHO"
* ^caseSensitive = true
* ^content = #fragment
* ^copyright = "ICD-11 © World Health Organization (WHO). CC BY-NC-ND 3.0 IGO. Republished fragment for IG validation."

// =============================================================================
// CHAPTER 24: Problems associated with health behaviours (QE10-QE2Z)
// =============================================================================

* #QE10 "Hazardous alcohol use"
* #QE11 "Hazardous drug use"
* #QE12 "Hazardous nicotine use"
* #QE1Y "Other specified problems associated with health behaviours"
* #QE1Z "Problems associated with health behaviours, unspecified"

// =============================================================================
// CHAPTER 24: Problems associated with drinking water or nutrition (QD60-QD6Z)
// =============================================================================

* #QD60 "Problems associated with insufficient drinking-water supply"
* #QD61 "Problems associated with dietary inadequacy"
* #QD62 "Problems associated with food supply"
* #QD6Y "Other specified problems associated with drinking water or nutrition"
* #QD6Z "Problems associated with drinking water or nutrition, unspecified"

// =============================================================================
// CHAPTER 24: Occupational and Lifestyle (QD80-QD8Z)
// =============================================================================

* #QD80 "Problems associated with lifestyle"
* #QD85 "Burnout"
* #QD8Y "Other specified problems associated with employment or unemployment"
* #QD8Z "Problems associated with employment or unemployment, unspecified"

// =============================================================================
// CHAPTER 7: Sleep-Wake Disorders
// =============================================================================

* #7A00 "Insomnia disorders"
* #7A01 "Hypersomnolence disorders"
* #7A20 "Sleep-related breathing disorders"
* #7A40 "Circadian rhythm sleep-wake disorders"
* #7A4Y "Other specified sleep-wake disorders"
* #7A4Z "Sleep-wake disorders, unspecified"

// =============================================================================
// CHAPTER 5: Nutritional Disorders
// =============================================================================

* #5B70 "Undernutrition in infants, children or adolescents"
* #5B71 "Underweight in adults"
* #5B72 "Undernutrition in adults"
* #5B80 "Overweight or obesity"
* #5B81 "Overweight"
* #5B82 "Obesity"

// =============================================================================
// Physical Activity Extension Codes
// =============================================================================

* #XE5A1 "Walking as physical activity"
* #XE5A2 "Running or jogging"
* #XE5A3 "Cycling"
* #XE5A4 "Swimming"
* #XE5A5 "Sports activities"
* #XE5A6 "Exercise or fitness activities"
* #XE5AY "Other specified physical activities"
* #XE5AZ "Physical activity, unspecified"
