// ConceptMap: ICD-10-CM to ICD-11 Lifestyle Medicine Codes
// Targets are the ICD-11 MMS categories given by the WHO ICD-10 to ICD-11 mapping tables (release
// 2024-01, 10To11MapToOneCategory / 10To11MapToMultipleCategories), restricted to the codes republished
// in ICD11LifestyleMedicineCS. ICD-10-CM-specific codes that the WHO tables (ICD-10, not CM) do not
// list are mapped by title with the equivalence stated per target. Rebuilt on 2026-09-11.

Instance: icd10-to-icd11-lifestyle
InstanceOf: ConceptMap
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/icd10-to-icd11-lifestyle"
* version = "0.2.0"
* name = "ICD10ToICD11LifestyleConceptMap"
* title = "ICD-10-CM to ICD-11 Lifestyle Medicine ConceptMap"
* status = #active
* experimental = false
* date = "2026-09-11"
* publisher = "Ricardo Lourenco dos Santos, FMUP"
* description = """
Maps ICD-10-CM lifestyle-related codes to ICD-11 MMS categories, following the WHO ICD-10 to ICD-11
mapping tables (2024-01) wherever the ICD-10 code exists in the WHO tables; ICD-10-CM-specific codes
(Z72.820, Z72.821, E66.3, E66.01) are mapped by title with the equivalence stated per target. Physical-activity
context codes (Y93.*) have no ICD-11 MMS category and are recorded as unmatched. Targets are the codes
republished in the IG's ICD-11 CodeSystem, verified 2026-09-11 against WHO ICD-11 MMS and tx.fhir.org.
"""

// Group-level source/target (the target is the IG's republished ICD-11 CodeSystem)
* group[+].source = "http://hl7.org/fhir/sid/icd-10-cm"
* group[=].target = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs"

// Tobacco use
* group[=].element[+].code = #Z72.0
* group[=].element[=].display = "Tobacco use"
* group[=].element[=].target[+].code = #QE13
* group[=].element[=].target[=].display = "Tobacco use"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO ICD-10 to ICD-11 map (2024-01): Z72.0 → QE13."

// Alcohol use
* group[=].element[+].code = #Z72.1
* group[=].element[=].display = "Alcohol use"
* group[=].element[=].target[+].code = #QE10
* group[=].element[=].target[=].display = "Hazardous alcohol use"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO map: Z72.1 → QE10. ICD-11 qualifies the use as hazardous."

// Drug use
* group[=].element[+].code = #Z72.2
* group[=].element[=].display = "Drug use"
* group[=].element[=].target[+].code = #QE11.Z
* group[=].element[=].target[=].display = "Hazardous drug use, unspecified"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO map: Z72.2 → QE11.Z (hazardous drug use, unspecified)."

// Lack of physical exercise
* group[=].element[+].code = #Z72.3
* group[=].element[=].display = "Lack of physical exercise"
* group[=].element[=].target[+].code = #QE20
* group[=].element[=].target[=].display = "Lack of physical exercise"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO map: Z72.3 → QE20."

// Inappropriate diet and eating habits
* group[=].element[+].code = #Z72.4
* group[=].element[=].display = "Inappropriate diet and eating habits"
* group[=].element[=].target[+].code = #QE23
* group[=].element[=].target[=].display = "Problems with inappropriate diet or eating habits"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO map: Z72.4 → QE23."

// High risk sexual behavior
* group[=].element[+].code = #Z72.5
* group[=].element[=].display = "High risk sexual behavior"
* group[=].element[=].target[+].code = #QE2Z
* group[=].element[=].target[=].display = "Problem with health-related behaviours, unspecified"
* group[=].element[=].target[=].equivalence = #wider
* group[=].element[=].target[=].comment = "WHO map: Z72.5 → QE2Z (no specific ICD-11 category)."

// Gambling and betting
* group[=].element[+].code = #Z72.6
* group[=].element[=].display = "Gambling and betting"
* group[=].element[=].target[+].code = #QE21
* group[=].element[=].target[=].display = "Hazardous gambling or betting"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO map: Z72.6 → QE21."

// Sleep deprivation
* group[=].element[+].code = #Z72.820
* group[=].element[=].display = "Sleep deprivation"
* group[=].element[=].target[+].code = #7A26
* group[=].element[=].target[=].display = "Insufficient sleep syndrome"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "ICD-10-CM-specific code (no WHO map entry); closest ICD-11 category is insufficient sleep syndrome. WHO maps the ICD-10 parent Z72.8 to QE2Z."

// Inadequate sleep hygiene
* group[=].element[+].code = #Z72.821
* group[=].element[=].display = "Inadequate sleep hygiene"
* group[=].element[=].target[+].code = #QE2Z
* group[=].element[=].target[=].display = "Problem with health-related behaviours, unspecified"
* group[=].element[=].target[=].equivalence = #wider
* group[=].element[=].target[=].comment = "ICD-10-CM-specific code; WHO maps the ICD-10 parent Z72.8 to QE2Z."

// Overweight
* group[=].element[+].code = #E66.3
* group[=].element[=].display = "Overweight"
* group[=].element[=].target[+].code = #5B80.0
* group[=].element[=].target[=].display = "Overweight"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "ICD-10-CM-specific code; ICD-11 5B80.0 Overweight (same title)."

// Obesity, unspecified
* group[=].element[+].code = #E66.9
* group[=].element[=].display = "Obesity, unspecified"
* group[=].element[=].target[+].code = #5B81.Z
* group[=].element[=].target[=].display = "Obesity, unspecified"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO map: E66.9 → 5B81.Z."

// Morbid (severe) obesity due to excess calories
* group[=].element[+].code = #E66.01
* group[=].element[=].display = "Morbid (severe) obesity due to excess calories"
* group[=].element[=].target[+].code = #5B81.0
* group[=].element[=].target[=].display = "Obesity due to energy imbalance"
* group[=].element[=].target[=].equivalence = #wider
* group[=].element[=].target[=].comment = "ICD-10-CM-specific code; WHO maps the ICD-10 parent E66.0 → 5B81.0. Severity is carried by BMI extension codes in ICD-11."

// Unspecified protein-calorie malnutrition
* group[=].element[+].code = #E46
* group[=].element[=].display = "Unspecified protein-calorie malnutrition"
* group[=].element[=].target[+].code = #5B71
* group[=].element[=].target[=].display = "Protein deficiency"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "WHO one-category map: E46 → 5B71."
* group[=].element[=].target[+].code = #5B54
* group[=].element[=].target[=].display = "Underweight in adults"
* group[=].element[=].target[=].equivalence = #narrower
* group[=].element[=].target[=].comment = "WHO multi-category map also lists 5B54 (underweight in adults), 5B50, 5B51, 5B52, 5B53."

// Burn-out
* group[=].element[+].code = #Z73.0
* group[=].element[=].display = "Burn-out"
* group[=].element[=].target[+].code = #QD85
* group[=].element[=].target[=].display = "Burnout"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO map: Z73.0 → QD85."

// Lack of relaxation and leisure
* group[=].element[+].code = #Z73.2
* group[=].element[=].display = "Lack of relaxation and leisure"
* group[=].element[=].target[+].code = #QF2A
* group[=].element[=].target[=].display = "Difficulty or need for assistance with community participation"
* group[=].element[=].target[=].equivalence = #inexact
* group[=].element[=].target[=].comment = "WHO map: Z73.2 → QF2A."

// Stress, not elsewhere classified
* group[=].element[+].code = #Z73.3
* group[=].element[=].display = "Stress, not elsewhere classified"
* group[=].element[=].target[+].code = #QE01
* group[=].element[=].target[=].display = "Stress, not elsewhere classified"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "WHO map: Z73.3 → QE01."

// Activity, walking, marching and hiking
* group[=].element[+].code = #Y93.01
* group[=].element[=].display = "Activity, walking, marching and hiking"
* group[=].element[=].target[+].equivalence = #unmatched
* group[=].element[=].target[=].comment = "ICD-11 MMS has no category for physical-activity types; ICD-11 activity codes are extension codes for the external-cause context only."

// Activity, running
* group[=].element[+].code = #Y93.02
* group[=].element[=].display = "Activity, running"
* group[=].element[=].target[+].equivalence = #unmatched
* group[=].element[=].target[=].comment = "See Y93.01."

// Activity, swimming
* group[=].element[+].code = #Y93.11
* group[=].element[=].display = "Activity, swimming"
* group[=].element[=].target[+].equivalence = #unmatched
* group[=].element[=].target[=].comment = "See Y93.01."

// Activity, bike riding
* group[=].element[+].code = #Y93.55
* group[=].element[=].display = "Activity, bike riding"
* group[=].element[=].target[+].equivalence = #unmatched
* group[=].element[=].target[=].comment = "See Y93.01."

// Activity, exercise machines primarily for cardiorespiratory conditioning
* group[=].element[+].code = #Y93.A1
* group[=].element[=].display = "Activity, exercise machines primarily for cardiorespiratory conditioning"
* group[=].element[=].target[+].equivalence = #unmatched
* group[=].element[=].target[=].comment = "See Y93.01."
