// =============================================================================
// F2.11.1: ConceptMap Nutrition to LOINC
// =============================================================================
// Maps nutrition and dietary intake concepts to LOINC codes
// Verified at: https://loinc.org (January 2026)
//
// References:
// - IoM (2005). Dietary Reference Intakes for Energy, Carbohydrate, Fiber, Fat...
// - USDA (2020). Dietary Guidelines for Americans, 2020-2025
// - LOINC Nutrition Panel: https://loinc.org/document/loinc-users-guide
// =============================================================================

Instance: ConceptMapNutritionToLOINC
InstanceOf: ConceptMap
Title: "Nutrition Metrics to LOINC Concept Map"
Description: """
Maps lifestyle medicine nutrition and dietary intake metrics to LOINC codes.

**Scope**: Dietary assessment including:
- Macronutrient intake (calories, protein, carbohydrates, fat)
- Micronutrient intake (vitamins, minerals)
- Hydration and fluid intake
- Dietary patterns and meal composition

**Evidence Base**:
- Mifflin MD et al. (1990). Am J Clin Nutr 51(2):241-247 (energy expenditure)
- Institute of Medicine (2005). Dietary Reference Intakes. NAP.
- USDA (2020). Dietary Guidelines for Americans 2020-2025

**LOINC Verification**: All codes verified at loinc.org as of January 2026.
"""
Usage: #definition

* status = #active
* experimental = false
* date = "2026-01-15"
* publisher = "FMUP HEADS2"
* name = "ConceptMapNutritionToLOINC"
// ConceptMap.source MUST be a ValueSet per FHIR R4 (IG Publisher 2.0.28+)
// The ValueSet uses explicit code enumeration to avoid tx.fhir.org expansion issues
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/nutrition-complete-mapping-source-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/loinc-observations-vs"

// =============================================================================
// Group 1: Macronutrient Intake Mappings
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #nutrition-caloric-intake
* group[=].element[=].display = "Caloric intake"
* group[=].element[=].target[+].code = #9052-2
* group[=].element[=].target[=].display = "Caloric intake total"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "Total daily energy intake in kcal"

* group[=].element[+].code = #nutrition-protein-intake
* group[=].element[=].display = "Protein intake"
* group[=].element[=].target[+].code = #9059-7
* group[=].element[=].target[=].display = "Protein intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "IoM DRI: 0.8g/kg/day (adults)"

* group[=].element[+].code = #nutrition-carbohydrate-intake
* group[=].element[=].display = "Carbohydrate intake"
* group[=].element[=].target[+].code = #9057-1
* group[=].element[=].target[=].display = "Carbohydrate intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "IoM DRI: 45-65% of total calories"

* group[=].element[+].code = #nutrition-fat-intake
* group[=].element[=].display = "Fat intake"
* group[=].element[=].target[+].code = #9060-5
* group[=].element[=].target[=].display = "Fat intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "IoM DRI: 20-35% of total calories"

* group[=].element[+].code = #fiber-intake
* group[=].element[=].display = "Fiber intake"
* group[=].element[=].target[+].code = #9055-5
* group[=].element[=].target[=].display = "Fiber intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "IoM AI: 25g/day (women), 38g/day (men)"

* group[=].element[+].code = #saturated-fat
* group[=].element[=].display = "Saturated fat intake"
* group[=].element[=].target[+].code = #9061-3
* group[=].element[=].target[=].display = "Saturated fat intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "DGA 2020: <10% of total calories"

// =============================================================================
// Group 2: Hydration and Fluid Intake
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #fluid-intake
* group[=].element[=].display = "Fluid intake"
* group[=].element[=].target[+].code = #9053-0
* group[=].element[=].target[=].display = "Fluid intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "EFSA (2010): 2.0L/day women, 2.5L/day men"

* group[=].element[+].code = #nutrition-water-intake
* group[=].element[=].display = "Water intake"
* group[=].element[=].target[+].code = #9053-0
* group[=].element[=].target[=].display = "Fluid intake 24 hour"
* group[=].element[=].target[=].equivalence = #relatedto
* group[=].element[=].target[=].comment = "Water subset of total fluid; report in mL"

// =============================================================================
// Group 3: Micronutrient Intake - Vitamins
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #vitamin-d-intake
* group[=].element[=].display = "Vitamin D intake"
* group[=].element[=].target[+].code = #81929-2
* group[=].element[=].target[=].display = "Vitamin D intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "IoM (2011): 600-800 IU/day"

* group[=].element[+].code = #vitamin-c-intake
* group[=].element[=].display = "Vitamin C intake"
* group[=].element[=].target[+].code = #81074-7
* group[=].element[=].target[=].display = "Vitamin C intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "RDA: 75mg women, 90mg men"

* group[=].element[+].code = #vitamin-a-intake
* group[=].element[=].display = "Vitamin A intake"
* group[=].element[=].target[+].code = #81072-1
* group[=].element[=].target[=].display = "Vitamin A intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "RDA: 700mcg RAE women, 900mcg RAE men"

* group[=].element[+].code = #vitamin-e-intake
* group[=].element[=].display = "Vitamin E intake"
* group[=].element[=].target[+].code = #81076-2
* group[=].element[=].target[=].display = "Vitamin E intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "RDA: 15mg/day"

* group[=].element[+].code = #vitamin-b12-intake
* group[=].element[=].display = "Vitamin B12 intake"
* group[=].element[=].target[+].code = #81062-2
* group[=].element[=].target[=].display = "Vitamin B12 intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "RDA: 2.4mcg/day"

* group[=].element[+].code = #folate-intake
* group[=].element[=].display = "Folate intake"
* group[=].element[=].target[+].code = #81066-3
* group[=].element[=].target[=].display = "Vitamin B9 (Folate) intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "RDA: 400mcg DFE/day"

// =============================================================================
// Group 4: Micronutrient Intake - Minerals
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #calcium-intake
* group[=].element[=].display = "Calcium intake"
* group[=].element[=].target[+].code = #81137-2
* group[=].element[=].target[=].display = "Calcium intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "IoM (2011): 1000-1200mg/day"

* group[=].element[+].code = #iron-intake
* group[=].element[=].display = "Iron intake"
* group[=].element[=].target[+].code = #81082-0
* group[=].element[=].target[=].display = "Iron intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "RDA: 8mg men, 18mg premenopausal women"

* group[=].element[+].code = #nutrition-sodium-intake
* group[=].element[=].display = "Sodium intake"
* group[=].element[=].target[+].code = #81011-9
* group[=].element[=].target[=].display = "Sodium intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "DGA 2020: <2300mg/day"

* group[=].element[+].code = #potassium-intake
* group[=].element[=].display = "Potassium intake"
* group[=].element[=].target[+].code = #81010-1
* group[=].element[=].target[=].display = "Potassium intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "AI: 2600mg women, 3400mg men"

* group[=].element[+].code = #magnesium-intake
* group[=].element[=].display = "Magnesium intake"
* group[=].element[=].target[+].code = #81005-1
* group[=].element[=].target[=].display = "Magnesium intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "RDA: 310-320mg women, 400-420mg men"

* group[=].element[+].code = #zinc-intake
* group[=].element[=].display = "Zinc intake"
* group[=].element[=].target[+].code = #81089-5
* group[=].element[=].target[=].display = "Zinc intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "RDA: 8mg women, 11mg men"

// =============================================================================
// Group 5: Dietary Pattern Assessment
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "http://loinc.org"
* group[=].element[+].code = #diet-quality-score
* group[=].element[=].display = "Diet quality score"
* group[=].element[=].target[+].code = #75282-4
* group[=].element[=].target[=].display = "Diet"
* group[=].element[=].target[=].equivalence = #relatedto
* group[=].element[=].target[=].comment = "General dietary assessment; use HEI-2020 for US populations"

* group[=].element[+].code = #meal-frequency
* group[=].element[=].display = "Meal frequency"
* group[=].element[=].target[+].code = #65968-0
* group[=].element[=].target[=].display = "Eating habits"
* group[=].element[=].target[=].equivalence = #relatedto
* group[=].element[=].target[=].comment = "Includes meal patterns, snacking behavior"

* group[=].element[+].code = #caffeine-intake
* group[=].element[=].display = "Caffeine intake"
* group[=].element[=].target[+].code = #9056-3
* group[=].element[=].target[=].display = "Caffeine intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "Moderate intake: <400mg/day (FDA)"
