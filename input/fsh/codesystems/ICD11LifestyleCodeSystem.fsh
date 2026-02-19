// ICD-11 Lifestyle Medicine CodeSystem (Fragment)
// Created: 2026-01-26
// Updated: 2026-02-19 - Changed content to #fragment per VRF-TECH-027
// Purpose: ICD-11 codes for lifestyle medicine and health behaviours
// Reference: WHO ICD-11 MMS 2024-01 (https://icd.who.int)
// Official URL: http://id.who.int/icd/11
//
// DESIGN DECISION (VRF-TECH-027):
// This CodeSystem republishes a FRAGMENT of ICD-11 codes because:
// 1. ICD-11 is not yet available on tx.fhir.org for FHIR validation
// 2. Ensures IG builds without external terminology server dependency
// 3. All codes are exact copies from WHO ICD-11 MMS 2024-01
// Future work: Convert to ValueSet referencing http://id.who.int/icd/11 when available

CodeSystem: ICD11LifestyleCodeSystem
Id: icd-11-lifestyle-cs
Title: "ICD-11 Lifestyle Medicine Codes (Fragment)"
Description: """
FRAGMENT of ICD-11 codes relevant to lifestyle medicine and health behaviours
from WHO's International Classification of Diseases, 11th Revision (ICD-11 MMS 2024-01).

NOTE: This is a republished subset (34 codes) for IG validation purposes.
The authoritative source is WHO ICD-11 at http://id.who.int/icd/11.

This CodeSystem includes codes from:
- Chapter 24: Factors influencing health status or contact with health services
- Chapter 7: Sleep-wake disorders
- Chapter 5: Nutritional disorders

These codes enable standardized documentation of lifestyle-related health factors
in alignment with WHO's global health classification system.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-02-19"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"
* ^contact.name = "Ricardo L. Santos"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^caseSensitive = true
* ^content = #fragment
* ^copyright = "ICD-11 is copyright © World Health Organization (WHO). Used under CC BY-NC-ND 3.0 IGO license. This is a republished fragment for IG validation purposes."

// =============================================================================
// CHAPTER 24: FACTORS INFLUENCING HEALTH STATUS
// Block: Problems associated with health behaviours (QE10-QE2Z)
// =============================================================================

* #QE10 "Hazardous alcohol use"
    "A pattern of alcohol use that increases the risk of harmful consequences for the user.
     The pattern of use often persists despite awareness of increased risk of harm."

* #QE11 "Hazardous drug use"
    "A pattern of drug use that increases the risk of harmful consequences for the user.
     The pattern of use often persists despite awareness of increased risk of harm."

* #QE12 "Hazardous nicotine use"
    "A pattern of nicotine use that increases the risk of harmful consequences for the user.
     Includes cigarette smoking, vaping, and other tobacco/nicotine product use."

* #QE1Y "Other specified problems associated with health behaviours"
    "Problems associated with health behaviours that are specified but not classifiable elsewhere."

* #QE1Z "Problems associated with health behaviours, unspecified"
    "Problems associated with health behaviours that are not otherwise specified."

// =============================================================================
// CHAPTER 24: FACTORS INFLUENCING HEALTH STATUS
// Block: Problems associated with drinking water or nutrition (QD60-QD6Z)
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
// CHAPTER 24: OCCUPATIONAL AND LIFESTYLE FACTORS
// Block: QD80-QD8Z
// =============================================================================

* #QD80 "Problems associated with lifestyle"
    "Health problems related to modifiable lifestyle behaviours including physical activity,
     diet, sleep, stress management, and substance use patterns."

* #QD85 "Burnout"
    "A syndrome conceptualized as resulting from chronic workplace stress that has not been
     successfully managed. Characterized by feelings of energy depletion or exhaustion,
     increased mental distance from one's job, and reduced professional efficacy."

* #QD8Y "Other specified problems associated with employment or unemployment"
    "Employment-related problems that are specified but not classifiable elsewhere."

* #QD8Z "Problems associated with employment or unemployment, unspecified"
    "Employment-related problems that are not otherwise specified."

// =============================================================================
// CHAPTER 7: SLEEP-WAKE DISORDERS (Selected codes)
// =============================================================================

* #7A00 "Insomnia disorders"
    "Disorders characterized by a persistent difficulty with sleep initiation, duration,
     consolidation, or quality that occurs despite adequate opportunity for sleep."

* #7A01 "Hypersomnolence disorders"
    "Disorders characterized by excessive sleepiness despite adequate or prolonged sleep."

* #7A20 "Sleep-related breathing disorders"
    "Disorders characterized by abnormal respiration during sleep, including obstructive
     sleep apnoea and central sleep apnoea syndromes."

* #7A40 "Circadian rhythm sleep-wake disorders"
    "Disorders characterized by a persistent or recurrent pattern of sleep disturbance
     due to alteration of the circadian time-keeping system."

* #7A4Y "Other specified sleep-wake disorders"
    "Sleep-wake disorders that are specified but not classifiable elsewhere."

* #7A4Z "Sleep-wake disorders, unspecified"
    "Sleep-wake disorders that are not otherwise specified."

// =============================================================================
// CHAPTER 5: NUTRITIONAL DISORDERS (Selected codes)
// =============================================================================

* #5B70 "Undernutrition in infants, children or adolescents"
    "Nutritional deficiency state in infants, children or adolescents characterized by
     inadequate intake or absorption of nutrients."

* #5B71 "Underweight in adults"
    "Body mass index (BMI) below the normal range in adults, indicating insufficient
     body mass relative to height."

* #5B72 "Undernutrition in adults"
    "A state of malnutrition in adults characterized by loss of body mass due to disease,
     inflammation, or inadequate nutritional intake. Aligned with GLIM criteria."

* #5B80 "Overweight or obesity"
    "Abnormal or excessive fat accumulation that may impair health."

* #5B81 "Overweight"
    "Body mass index (BMI) above the normal range but below the threshold for obesity."

* #5B82 "Obesity"
    "Body mass index (BMI) at or above the threshold defining obesity (≥30 kg/m² for adults)."

// =============================================================================
// PHYSICAL ACTIVITY EXTENSION CODES (Y93 equivalent in ICD-11)
// Note: ICD-11 uses extension codes for activity at time of injury/illness
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
