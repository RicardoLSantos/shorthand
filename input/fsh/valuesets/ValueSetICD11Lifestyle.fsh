// ICD-11 Lifestyle Medicine ValueSets
// Created: 2026-01-26
// Updated: 2026-03-02 — Phase 6a: Reference WHO official ICD-11 URL instead of local CS
// Purpose: ValueSets for ICD-11 lifestyle medicine codes
// Reference: WHO ICD-11 MMS 2024-01
// System URL: http://id.who.int/icd/release/11/mms (WHO official FHIR CodeSystem URL)
// Note: ICD-11 is not yet on tx.fhir.org — validation warnings suppressed in ignoreWarnings.txt

// =============================================================================
// PRIMARY VALUESET: ALL LIFESTYLE CODES
// =============================================================================

ValueSet: ICD11LifestyleMedicineValueSet
Id: icd-11-lifestyle-medicine-vs
Title: "ICD-11 Lifestyle Medicine ValueSet"
Description: """
All ICD-11 codes relevant to lifestyle medicine, including health behaviours,
nutrition, sleep disorders, and physical activity codes from WHO ICD-11 MMS.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-lifestyle-medicine-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-26"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

// Include all sub-ValueSets rather than bulk include
* include codes from valueset ICD11HealthBehavioursValueSet
* include codes from valueset ICD11NutritionValueSet
* include codes from valueset ICD11SleepDisordersValueSet
* include codes from valueset ICD11PhysicalActivityValueSet
// Additional codes not in sub-ValueSets
* http://id.who.int/icd/release/11/mms#QD8Y "Other specified problems associated with employment or unemployment"
* http://id.who.int/icd/release/11/mms#QD8Z "Problems associated with employment or unemployment, unspecified"

// =============================================================================
// HEALTH BEHAVIOURS VALUESET
// =============================================================================

ValueSet: ICD11HealthBehavioursValueSet
Id: icd-11-health-behaviours-vs
Title: "ICD-11 Health Behaviours ValueSet"
Description: """
ICD-11 codes for problems associated with health behaviours including
hazardous substance use and lifestyle-related health factors.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-health-behaviours-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-26"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* http://id.who.int/icd/release/11/mms#QE10 "Hazardous alcohol use"
* http://id.who.int/icd/release/11/mms#QE11 "Hazardous drug use"
* http://id.who.int/icd/release/11/mms#QE12 "Hazardous nicotine use"
* http://id.who.int/icd/release/11/mms#QE1Y "Other specified problems associated with health behaviours"
* http://id.who.int/icd/release/11/mms#QE1Z "Problems associated with health behaviours, unspecified"
* http://id.who.int/icd/release/11/mms#QD80 "Problems associated with lifestyle"
* http://id.who.int/icd/release/11/mms#QD85 "Burnout"

// =============================================================================
// NUTRITION VALUESET
// =============================================================================

ValueSet: ICD11NutritionValueSet
Id: icd-11-nutrition-vs
Title: "ICD-11 Nutrition Disorders ValueSet"
Description: """
ICD-11 codes for nutritional disorders and nutrition-related health factors
including undernutrition, overweight, and obesity.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-nutrition-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-26"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* http://id.who.int/icd/release/11/mms#QD60 "Problems associated with insufficient drinking-water supply"
* http://id.who.int/icd/release/11/mms#QD61 "Problems associated with dietary inadequacy"
* http://id.who.int/icd/release/11/mms#QD62 "Problems associated with food supply"
* http://id.who.int/icd/release/11/mms#QD6Y "Other specified problems associated with drinking water or nutrition"
* http://id.who.int/icd/release/11/mms#QD6Z "Problems associated with drinking water or nutrition, unspecified"
* http://id.who.int/icd/release/11/mms#5B70 "Undernutrition in infants, children or adolescents"
* http://id.who.int/icd/release/11/mms#5B71 "Underweight in adults"
* http://id.who.int/icd/release/11/mms#5B72 "Undernutrition in adults"
* http://id.who.int/icd/release/11/mms#5B80 "Overweight or obesity"
* http://id.who.int/icd/release/11/mms#5B81 "Overweight"
* http://id.who.int/icd/release/11/mms#5B82 "Obesity"

// =============================================================================
// SLEEP DISORDERS VALUESET
// =============================================================================

ValueSet: ICD11SleepDisordersValueSet
Id: icd-11-sleep-disorders-vs
Title: "ICD-11 Sleep-Wake Disorders ValueSet"
Description: """
ICD-11 codes for sleep-wake disorders relevant to lifestyle medicine
including insomnia, hypersomnolence, and circadian rhythm disorders.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-sleep-disorders-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-26"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* http://id.who.int/icd/release/11/mms#7A00 "Insomnia disorders"
* http://id.who.int/icd/release/11/mms#7A01 "Hypersomnolence disorders"
* http://id.who.int/icd/release/11/mms#7A20 "Sleep-related breathing disorders"
* http://id.who.int/icd/release/11/mms#7A40 "Circadian rhythm sleep-wake disorders"
* http://id.who.int/icd/release/11/mms#7A4Y "Other specified sleep-wake disorders"
* http://id.who.int/icd/release/11/mms#7A4Z "Sleep-wake disorders, unspecified"

// =============================================================================
// PHYSICAL ACTIVITY VALUESET
// =============================================================================

ValueSet: ICD11PhysicalActivityValueSet
Id: icd-11-physical-activity-vs
Title: "ICD-11 Physical Activity ValueSet"
Description: """
ICD-11 extension codes for physical activity types.
These codes can be used as additional context for health observations.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-physical-activity-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-01-26"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* http://id.who.int/icd/release/11/mms#XE5A1 "Walking as physical activity"
* http://id.who.int/icd/release/11/mms#XE5A2 "Running or jogging"
* http://id.who.int/icd/release/11/mms#XE5A3 "Cycling"
* http://id.who.int/icd/release/11/mms#XE5A4 "Swimming"
* http://id.who.int/icd/release/11/mms#XE5A5 "Sports activities"
* http://id.who.int/icd/release/11/mms#XE5A6 "Exercise or fitness activities"
* http://id.who.int/icd/release/11/mms#XE5AY "Other specified physical activities"
* http://id.who.int/icd/release/11/mms#XE5AZ "Physical activity, unspecified"
