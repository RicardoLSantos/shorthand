// =============================================================================
// F2.11.2: ConceptMap Nutrition to OMOP CDM
// =============================================================================
// Maps nutrition concepts to OMOP Common Data Model concept IDs
// Verified at: https://athena.ohdsi.org (January 2026)
//
// References:
// - OMOP CDM v5.4: https://ohdsi.github.io/CommonDataModel/
// - OHDSI Athena: https://athena.ohdsi.org/
// - LOINC to OMOP mapping: https://athena.ohdsi.org/search-terms/terms?vocabulary=LOINC
// =============================================================================

Instance: ConceptMapNutritionToOMOP
InstanceOf: ConceptMap
Title: "Nutrition Metrics to OMOP CDM Concept Map"
Description: """
Maps lifestyle medicine nutrition metrics to OMOP CDM concept IDs for observational research.

**Purpose**: Enable OHDSI network studies on nutrition and lifestyle medicine outcomes.

**Target System**: OMOP Common Data Model (CDM) v5.4
- Measurement domain for quantitative values
- Observation domain for qualitative assessments

**Verification**: Concept IDs verified at athena.ohdsi.org as of January 2026.

**Note**: Some nutrition-specific concepts may have concept_id = 0 (unmapped) in OMOP.
These should use custom concepts in local OMOP implementations.
"""
Usage: #definition

* status = #active
* experimental = false
* date = "2026-01-12"
* publisher = "FMUP HEADS2"
* name = "ConceptMapNutritionToOMOP"
// ConceptMap.source MUST be a ValueSet per FHIR R4 (IG Publisher 2.0.28+)
// The ValueSet uses explicit code enumeration to avoid tx.fhir.org expansion issues
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/nutrition-complete-mapping-source-vs"
* targetUri = "https://athena.ohdsi.org/search-terms/concepts"

// =============================================================================
// Group 1: Macronutrient Measurements (OMOP Measurement domain)
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "https://athena.ohdsi.org/search-terms/concepts"
* group[=].element[+].code = #caloric-intake
* group[=].element[=].display = "Caloric intake"
* group[=].element[=].target[+].code = #3004249
* group[=].element[=].target[=].display = "Caloric intake total"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 9052-2 mapped to OMOP; domain=Measurement"

* group[=].element[+].code = #protein-intake
* group[=].element[=].display = "Protein intake"
* group[=].element[=].target[+].code = #3011253
* group[=].element[=].target[=].display = "Protein intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 9059-7 mapped to OMOP"

* group[=].element[+].code = #carbohydrate-intake
* group[=].element[=].display = "Carbohydrate intake"
* group[=].element[=].target[+].code = #3008587
* group[=].element[=].target[=].display = "Carbohydrate intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 9057-1 mapped to OMOP"

* group[=].element[+].code = #fat-intake
* group[=].element[=].display = "Fat intake"
* group[=].element[=].target[+].code = #3015779
* group[=].element[=].target[=].display = "Fat intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 9060-5 mapped to OMOP"

* group[=].element[+].code = #fiber-intake
* group[=].element[=].display = "Fiber intake"
* group[=].element[=].target[+].code = #3006471
* group[=].element[=].target[=].display = "Fiber intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 9055-5 mapped to OMOP"

* group[=].element[+].code = #sodium-intake
* group[=].element[=].display = "Sodium intake"
* group[=].element[=].target[+].code = #3022192
* group[=].element[=].target[=].display = "Sodium intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 9064-7 mapped to OMOP"

// =============================================================================
// Group 2: Fluid Intake
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "https://athena.ohdsi.org/search-terms/concepts"
* group[=].element[+].code = #fluid-intake
* group[=].element[=].display = "Fluid intake"
* group[=].element[=].target[+].code = #3004501
* group[=].element[=].target[=].display = "Fluid intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 9053-0 mapped to OMOP"

// =============================================================================
// Group 3: Vitamin Intake
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "https://athena.ohdsi.org/search-terms/concepts"
* group[=].element[+].code = #vitamin-d-intake
* group[=].element[=].display = "Vitamin D intake"
* group[=].element[=].target[+].code = #3032702
* group[=].element[=].target[=].display = "Vitamin D intake Dietary"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 35211-2; IoM 2011 DRI reference"

* group[=].element[+].code = #vitamin-c-intake
* group[=].element[=].display = "Vitamin C intake"
* group[=].element[=].target[+].code = #3032700
* group[=].element[=].target[=].display = "Vitamin C intake Dietary"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 35209-6"

// =============================================================================
// Group 4: Mineral Intake
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "https://athena.ohdsi.org/search-terms/concepts"
* group[=].element[+].code = #calcium-intake
* group[=].element[=].display = "Calcium intake"
* group[=].element[=].target[+].code = #3032690
* group[=].element[=].target[=].display = "Calcium intake Dietary"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 35199-9; IoM 2011 DRI reference"

* group[=].element[+].code = #iron-intake
* group[=].element[=].display = "Iron intake"
* group[=].element[=].target[+].code = #3032696
* group[=].element[=].target[=].display = "Iron intake Dietary"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "LOINC 35205-4"

// =============================================================================
// Group 5: GAP Documentation - Concepts requiring custom OMOP codes
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "https://athena.ohdsi.org/search-terms/concepts"
* group[=].element[+].code = #meal-frequency
* group[=].element[=].display = "Meal frequency"
* group[=].element[=].target[+].code = #0
* group[=].element[=].target[=].display = "No OMOP mapping"
* group[=].element[=].target[=].equivalence = #unmatched
* group[=].element[=].target[=].comment = "GAP: Meal patterns not in standard OMOP vocabularies; use local concept"

* group[=].element[+].code = #diet-quality-score
* group[=].element[=].display = "Diet quality score"
* group[=].element[=].target[+].code = #0
* group[=].element[=].target[=].display = "No OMOP mapping"
* group[=].element[=].target[=].equivalence = #unmatched
* group[=].element[=].target[=].comment = "GAP: HEI-2020 not in OMOP; use local concept with reference to USDA"

* group[=].element[+].code = #intermittent-fasting
* group[=].element[=].display = "Intermittent fasting pattern"
* group[=].element[=].target[+].code = #0
* group[=].element[=].target[=].display = "No OMOP mapping"
* group[=].element[=].target[=].equivalence = #unmatched
* group[=].element[=].target[=].comment = "GAP: Time-restricted eating patterns not in OMOP"
