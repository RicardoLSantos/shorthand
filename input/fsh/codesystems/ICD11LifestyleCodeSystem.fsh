// ICD-11 Lifestyle Medicine CodeSystem (Fragment/Supplement)
// Created: 2026-01-26
// Removed Phase 6a (2026-03-02): Referenced WHO URL directly in ValueSets
// Restored 2026-03-22 T1 S12: IG Publisher v2.2.1 now validates ICD-11 codes as errors
//   (not warnings). Stub fragment required to declare codes exist in WHO system.
// Updated 2026-03-25 T2 S9: Added WHO-sourced descriptions to all 34 codes.
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
* ^date = "2026-03-25"
* ^publisher = "World Health Organization (WHO)"
* ^contact.name = "WHO"
* ^caseSensitive = true
* ^content = #fragment
* ^copyright = "ICD-11 © World Health Organization (WHO). CC BY-NC-ND 3.0 IGO. Republished fragment for IG validation."

// =============================================================================
// CHAPTER 24: Problems associated with health behaviours (QE10-QE2Z)
// =============================================================================

* #QE10 "Hazardous alcohol use"
    "A pattern of alcohol use that increases the risk of harmful consequences for the user."

* #QE11 "Hazardous drug use"
    "A pattern of drug use that increases the risk of harmful consequences for the user."

* #QE12 "Hazardous nicotine use"
    "A pattern of nicotine use that increases the risk of harmful consequences for the user."

* #QE1Y "Other specified problems associated with health behaviours"
    "Problems associated with health behaviours that are specified but not classifiable elsewhere."

* #QE1Z "Problems associated with health behaviours, unspecified"
    "Problems associated with health behaviours that are not otherwise specified."

// =============================================================================
// CHAPTER 24: Problems associated with drinking water or nutrition (QD60-QD6Z)
// =============================================================================

* #QD60 "Problems associated with insufficient drinking-water supply"
    "Health issues related to inadequate access to safe drinking water."

* #QD61 "Problems associated with dietary inadequacy"
    "Health issues related to insufficient or inappropriate dietary intake."

* #QD62 "Problems associated with food supply"
    "Health issues related to inadequate access to appropriate food."

* #QD6Y "Other specified problems associated with drinking water or nutrition"
    "Problems related to drinking water or nutrition that are specified but not classifiable elsewhere."

* #QD6Z "Problems associated with drinking water or nutrition, unspecified"
    "Problems related to drinking water or nutrition that are not otherwise specified."

// =============================================================================
// CHAPTER 24: Occupational and Lifestyle (QD80-QD8Z)
// =============================================================================

* #QD80 "Problems associated with lifestyle"
    "Health problems related to modifiable lifestyle behaviours."

* #QD85 "Burnout"
    "A syndrome resulting from chronic workplace stress that has not been successfully managed."

* #QD8Y "Other specified problems associated with employment or unemployment"
    "Employment-related problems that are specified but not classifiable elsewhere."

* #QD8Z "Problems associated with employment or unemployment, unspecified"
    "Employment-related problems that are not otherwise specified."

// =============================================================================
// CHAPTER 7: Sleep-Wake Disorders
// =============================================================================

* #7A00 "Insomnia disorders"
    "Disorders characterized by persistent difficulty with sleep initiation, duration, consolidation, or quality."

* #7A01 "Hypersomnolence disorders"
    "Disorders characterized by excessive sleepiness despite adequate or prolonged sleep."

* #7A20 "Sleep-related breathing disorders"
    "Disorders characterized by abnormal respiration during sleep."

* #7A40 "Circadian rhythm sleep-wake disorders"
    "Disorders characterized by persistent sleep disturbance due to alteration of the circadian system."

* #7A4Y "Other specified sleep-wake disorders"
    "Sleep-wake disorders that are specified but not classifiable elsewhere."

* #7A4Z "Sleep-wake disorders, unspecified"
    "Sleep-wake disorders that are not otherwise specified."

// =============================================================================
// CHAPTER 5: Nutritional Disorders
// =============================================================================

* #5B70 "Undernutrition in infants, children or adolescents"
    "Nutritional deficiency state in infants, children or adolescents."

* #5B71 "Underweight in adults"
    "Body mass index (BMI) below the normal range in adults."

* #5B72 "Undernutrition in adults"
    "A state of malnutrition in adults characterized by loss of body mass."

* #5B80 "Overweight or obesity"
    "Abnormal or excessive fat accumulation that may impair health."

* #5B81 "Overweight"
    "Body mass index (BMI) above the normal range but below the threshold for obesity."

* #5B82 "Obesity"
    "Body mass index (BMI) at or above the threshold defining obesity."

// =============================================================================
// Physical Activity Extension Codes
// =============================================================================

* #XE5A1 "Walking as physical activity"
    "Walking performed as deliberate physical activity for health or recreation."

* #XE5A2 "Running or jogging"
    "Running or jogging performed as physical activity."

* #XE5A3 "Cycling"
    "Cycling performed as physical activity."

* #XE5A4 "Swimming"
    "Swimming performed as physical activity."

* #XE5A5 "Sports activities"
    "Participation in organized or recreational sports."

* #XE5A6 "Exercise or fitness activities"
    "Deliberate exercise performed for physical fitness."

* #XE5AY "Other specified physical activities"
    "Physical activities that are specified but not classifiable elsewhere."

* #XE5AZ "Physical activity, unspecified"
    "Physical activity that is not otherwise specified."
