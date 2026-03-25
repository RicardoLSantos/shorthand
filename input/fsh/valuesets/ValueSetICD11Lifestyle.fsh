// ICD-11 Lifestyle Medicine ValueSets
// Created: 2026-01-26
// Updated: 2026-03-02 — Phase 6a: Reference WHO official ICD-11 URL
// Updated: 2026-03-25T18:01:14 — T1 S13 Option B: Reference IG-namespace CS
//   Reason: WHO URL not on tx.fhir.org → IG Publisher cannot validate codes.
//   Future: Migrate to http://id.who.int/icd/release/11/mms when available on tx.fhir.org.
// Purpose: ValueSets for ICD-11 lifestyle medicine codes
// Reference: WHO ICD-11 MMS 2024-01

Alias: $ICD11 = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs

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
* ^date = "2026-03-25"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

// Include all sub-ValueSets rather than bulk include
* include codes from valueset ICD11HealthBehavioursValueSet
* include codes from valueset ICD11NutritionValueSet
* include codes from valueset ICD11SleepDisordersValueSet
* include codes from valueset ICD11PhysicalActivityValueSet
// Additional codes not in sub-ValueSets
* $ICD11#QD8Y "Other specified problems associated with employment or unemployment"
* $ICD11#QD8Z "Problems associated with employment or unemployment, unspecified"

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
* ^date = "2026-03-25"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* $ICD11#QE10 "Hazardous alcohol use"
* $ICD11#QE11 "Hazardous drug use"
* $ICD11#QE12 "Hazardous nicotine use"
* $ICD11#QE1Y "Other specified problems associated with health behaviours"
* $ICD11#QE1Z "Problems associated with health behaviours, unspecified"
* $ICD11#QD80 "Problems associated with lifestyle"
* $ICD11#QD85 "Burnout"

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
* ^date = "2026-03-25"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* $ICD11#QD60 "Problems associated with insufficient drinking-water supply"
* $ICD11#QD61 "Problems associated with dietary inadequacy"
* $ICD11#QD62 "Problems associated with food supply"
* $ICD11#QD6Y "Other specified problems associated with drinking water or nutrition"
* $ICD11#QD6Z "Problems associated with drinking water or nutrition, unspecified"
* $ICD11#5B70 "Undernutrition in infants, children or adolescents"
* $ICD11#5B71 "Underweight in adults"
* $ICD11#5B72 "Undernutrition in adults"
* $ICD11#5B80 "Overweight or obesity"
* $ICD11#5B81 "Overweight"
* $ICD11#5B82 "Obesity"

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
* ^date = "2026-03-25"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* $ICD11#7A00 "Insomnia disorders"
* $ICD11#7A01 "Hypersomnolence disorders"
* $ICD11#7A20 "Sleep-related breathing disorders"
* $ICD11#7A40 "Circadian rhythm sleep-wake disorders"
* $ICD11#7A4Y "Other specified sleep-wake disorders"
* $ICD11#7A4Z "Sleep-wake disorders, unspecified"

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
* ^date = "2026-03-25"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* $ICD11#XE5A1 "Walking as physical activity"
* $ICD11#XE5A2 "Running or jogging"
* $ICD11#XE5A3 "Cycling"
* $ICD11#XE5A4 "Swimming"
* $ICD11#XE5A5 "Sports activities"
* $ICD11#XE5A6 "Exercise or fitness activities"
* $ICD11#XE5AY "Other specified physical activities"
* $ICD11#XE5AZ "Physical activity, unspecified"
