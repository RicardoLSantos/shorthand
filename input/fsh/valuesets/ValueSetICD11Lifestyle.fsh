// ICD-11 Lifestyle Medicine ValueSets
// Created: 2026-01-26
// Purpose: ValueSets for ICD-11 lifestyle medicine codes
// Reference: WHO ICD-11 MMS 2024-01

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

* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs

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

* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QE10 "Hazardous alcohol use"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QE11 "Hazardous drug use"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QE12 "Hazardous nicotine use"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QE1Y "Other specified problems associated with health behaviours"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QE1Z "Problems associated with health behaviours, unspecified"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QD80 "Problems associated with lifestyle"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QD85 "Burnout"

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

* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QD60 "Problems associated with insufficient drinking-water supply"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QD61 "Problems associated with dietary inadequacy"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QD62 "Problems associated with food supply"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QD6Y "Other specified problems associated with drinking water or nutrition"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#QD6Z "Problems associated with drinking water or nutrition, unspecified"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#5B70 "Undernutrition in infants, children or adolescents"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#5B71 "Underweight in adults"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#5B72 "Undernutrition in adults"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#5B80 "Overweight or obesity"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#5B81 "Overweight"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#5B82 "Obesity"

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

* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#7A00 "Insomnia disorders"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#7A01 "Hypersomnolence disorders"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#7A20 "Sleep-related breathing disorders"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#7A40 "Circadian rhythm sleep-wake disorders"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#7A4Y "Other specified sleep-wake disorders"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#7A4Z "Sleep-wake disorders, unspecified"

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

* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#XE5A1 "Walking as physical activity"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#XE5A2 "Running or jogging"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#XE5A3 "Cycling"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#XE5A4 "Swimming"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#XE5A5 "Sports activities"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#XE5A6 "Exercise or fitness activities"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#XE5AY "Other specified physical activities"
* https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs#XE5AZ "Physical activity, unspecified"
