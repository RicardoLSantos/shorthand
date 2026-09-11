// ICD-11 Lifestyle Medicine ValueSets
// Codes are drawn from the IG's republished ICD-11 CodeSystem (ICD11LifestyleMedicineCS), whose
// concepts are verified against WHO ICD-11 MMS and tx.fhir.org on the dates recorded in the
// terminology verification ledger. Rebuilt on 2026-09-11 together with the CodeSystem
// (titles are the WHO MMS titles; codes absent from ICD-11 MMS were removed).

Alias: $ICD11 = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs

// =============================================================================
// PRIMARY VALUESET: ALL LIFESTYLE CODES
// =============================================================================

ValueSet: ICD11LifestyleMedicineValueSet
Id: icd-11-lifestyle-medicine-vs
Title: "ICD-11 Lifestyle Medicine ValueSet"
Description: """
All ICD-11 codes republished in this IG for lifestyle medicine: health behaviours, nutrition and body weight,
sleep-wake disorders, stress, burnout and employment-related problems. Codes verified 2026-09-11 against WHO ICD-11
MMS 2026-01 (icd.who.int linearization export) and tx.fhir.org.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-lifestyle-medicine-vs"
* ^version = "0.3.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-09-11"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

// Include all sub-ValueSets rather than bulk include
* include codes from valueset ICD11HealthBehavioursValueSet
* include codes from valueset ICD11NutritionValueSet
* include codes from valueset ICD11SleepDisordersValueSet
* include codes from valueset ICD11PhysicalActivityValueSet
// Employment and participation problems not in the sub-ValueSets
* $ICD11#QD8Y "Other specified problems associated with employment or unemployment"
* $ICD11#QD8Z "Problems associated with employment or unemployment, unspecified"
* $ICD11#QF2A "Difficulty or need for assistance with community participation"

// =============================================================================
// HEALTH BEHAVIOURS VALUESET
// =============================================================================

ValueSet: ICD11HealthBehavioursValueSet
Id: icd-11-health-behaviours-vs
Title: "ICD-11 Health Behaviours ValueSet"
Description: """
ICD-11 chapter 24 codes for problems associated with health behaviours: hazardous substance use (alcohol, drugs,
nicotine, tobacco), lack of physical exercise, hazardous gambling or gaming, inappropriate diet or eating habits,
stress and burnout.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-health-behaviours-vs"
* ^version = "0.3.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-09-11"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* $ICD11#QE10 "Hazardous alcohol use"
* $ICD11#QE11 "Hazardous drug use"
* $ICD11#QE11.Z "Hazardous drug use, unspecified"
* $ICD11#QE12 "Hazardous nicotine use"
* $ICD11#QE13 "Tobacco use"
* $ICD11#QE1Y "Other specified hazardous substance use"
* $ICD11#QE1Z "Hazardous substance use, unspecified"
* $ICD11#QE20 "Lack of physical exercise"
* $ICD11#QE21 "Hazardous gambling or betting"
* $ICD11#QE22 "Hazardous gaming"
* $ICD11#QE23 "Problems with inappropriate diet or eating habits"
* $ICD11#QE2Z "Problem with health-related behaviours, unspecified"
* $ICD11#QE01 "Stress, not elsewhere classified"
* $ICD11#QD85 "Burnout"

// =============================================================================
// NUTRITION VALUESET
// =============================================================================

ValueSet: ICD11NutritionValueSet
Id: icd-11-nutrition-vs
Title: "ICD-11 Nutrition Disorders ValueSet"
Description: """
ICD-11 codes for nutrition-related problems and body-weight disorders relevant to lifestyle medicine:
underweight and undernutrition (chapter 05, block 5B5), overweight and obesity (block 5B8), and problems
associated with drinking water or nutrition (chapter 24, block QD6).
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-nutrition-vs"
* ^version = "0.3.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-09-11"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* $ICD11#QD60 "Problems associated with inadequate drinking-water"
* $ICD11#QD61 "Inadequate food"
* $ICD11#QD6Z "Problems associated with drinking water or nutrition, unspecified"
* $ICD11#5B50 "Underweight in infants, children or adolescents"
* $ICD11#5B54 "Underweight in adults"
* $ICD11#5B71 "Protein deficiency"
* $ICD11#5B7Z "Unspecified undernutrition"
* $ICD11#5B80 "Overweight or localised adiposity"
* $ICD11#5B80.0 "Overweight"
* $ICD11#5B80.0Z "Overweight, unspecified"
* $ICD11#5B81 "Obesity"
* $ICD11#5B81.0 "Obesity due to energy imbalance"
* $ICD11#5B81.Z "Obesity, unspecified"

// =============================================================================
// SLEEP DISORDERS VALUESET
// =============================================================================

ValueSet: ICD11SleepDisordersValueSet
Id: icd-11-sleep-disorders-vs
Title: "ICD-11 Sleep-Wake Disorders ValueSet"
Description: """
ICD-11 chapter 07 codes for sleep-wake disorders relevant to lifestyle medicine and wearable sleep data:
insomnia disorders, hypersomnolence disorders (including insufficient sleep syndrome), sleep-related breathing
disorders (central and obstructive sleep apnoea) and circadian rhythm sleep-wake disorders (including shift-work
and jet-lag types).
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-sleep-disorders-vs"
* ^version = "0.3.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-09-11"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* $ICD11#7A00 "Chronic insomnia"
* $ICD11#7A01 "Short-term insomnia"
* $ICD11#7A0Z "Insomnia disorders, unspecified"
* $ICD11#7A21 "Idiopathic hypersomnia"
* $ICD11#7A24 "Hypersomnia due to a medication or substance"
* $ICD11#7A26 "Insufficient sleep syndrome"
* $ICD11#7A2Z "Hypersomnolence disorders, unspecified"
* $ICD11#7A40 "Central sleep apnoeas"
* $ICD11#7A41 "Obstructive sleep apnoea"
* $ICD11#7A4Y "Other specified sleep-related breathing disorders"
* $ICD11#7A4Z "Sleep-related breathing disorders, unspecified"
* $ICD11#7A60 "Delayed sleep-wake phase disorder"
* $ICD11#7A64 "Circadian rhythm sleep-wake disorder, shift work type"
* $ICD11#7A65 "Circadian rhythm sleep-wake disorder, jet lag type"
* $ICD11#7A6Z "Circadian rhythm sleep-wake disorders, unspecified"
* $ICD11#7B2Z "Sleep-wake disorders, unspecified"

// =============================================================================
// PHYSICAL ACTIVITY VALUESET
// =============================================================================

ValueSet: ICD11PhysicalActivityValueSet
Id: icd-11-physical-activity-vs
Title: "ICD-11 Physical Activity ValueSet"
Description: """
The ICD-11 code for insufficient physical activity as a health-behaviour problem. ICD-11 MMS has no
categories for physical-activity types (walking, running, cycling, swimming); activity types are coded with
SNOMED CT and LOINC in this IG, and the ICD-11 activity extension codes describe the activity at the time of
an injury, not lifestyle activity.
"""

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/icd-11-physical-activity-vs"
* ^version = "0.3.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-09-11"
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* $ICD11#QE20 "Lack of physical exercise"
