// =============================================================================
// F2.11.2: ConceptMap Nutrition to OMOP CDM
// =============================================================================
// Maps nutrition concepts to OMOP Common Data Model concept IDs
// ⚠️ RE-VERIFIED 2026-05-21 (CN1 remediation after the audit)
// Previous version (committed 2026-01-12) had 11/11 (100%) fabricated OMOP concept_ids
// All non-zero target.code mappings RE-VERIFIED via Athena CONCEPT.csv direct lookup
// 2026-05-21 (Database-First Protocol)
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

**Verification**: All 11 non-zero concept_ids RE-VERIFIED 2026-05-21 via Athena CONCEPT.csv direct lookup (Database-First Protocol, with a column-role check of concept_id vs concept_code). The previous version (committed 2026-01-12) had a 100% fabrication rate, detected in a systematic ConceptMap audit. All replacement OMOP concept_ids confirmed Standard concepts (S) in Measurement domain with matching LOINC source codes (verified concept_code field). For unmapped concepts (`meal-frequency`, `diet-quality-score`, `intermittent-fasting`), target.code = #0 per OMOP convention for unmapped concepts.

**Note**: Some nutrition-specific concepts may have concept_id = 0 (unmapped) in OMOP.
These should use custom concepts in local OMOP implementations.
"""
Usage: #definition

* status = #draft
* experimental = true
* date = "2026-01-12"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
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
* group[=].element[+].code = #nutrition-caloric-intake
* group[=].element[=].display = "Caloric intake"
* group[=].element[=].target[+].code = #46234687
* group[=].element[=].target[=].display = "Calorie intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 46234687 = LOINC 75302-0 'Calorie intake 24 hour' (Measurement, Standard); RE-VERIFIED via Athena CONCEPT.csv direct lookup 2026-05-21 (remediation after the audit; previous mapping #3004249='Systolic blood pressure' was 100% fabricated)"

* group[=].element[+].code = #nutrition-protein-intake
* group[=].element[=].display = "Protein intake"
* group[=].element[=].target[+].code = #21494592
* group[=].element[=].target[=].display = "Protein intake panel"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 21494592 = LOINC 81904-5 'Protein intake panel' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3011253='Avian encephalomyelitis virus Ab' was fabricated)"

* group[=].element[+].code = #nutrition-carbohydrate-intake
* group[=].element[=].display = "Carbohydrate intake"
* group[=].element[=].target[+].code = #21494749
* group[=].element[=].target[=].display = "Carbohydrate intake 24 hour Measured"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 21494749 = LOINC 81953-2 'Carbohydrate intake 24 hour Measured' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3008587='Tree Allergen Mix 2 IgE Ab' was fabricated)"

* group[=].element[+].code = #nutrition-fat-intake
* group[=].element[=].display = "Fat intake"
* group[=].element[=].target[+].code = #21494748
* group[=].element[=].target[=].display = "Fat intake 24 hour Measured"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 21494748 = LOINC 81952-4 'Fat intake 24 hour Measured' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3015779='Brucella canis IgG Ab' was fabricated)"

* group[=].element[+].code = #fiber-intake
* group[=].element[=].display = "Fiber intake"
* group[=].element[=].target[+].code = #21494403
* group[=].element[=].target[=].display = "Fiber intake 24 hour Measured"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 21494403 = LOINC 81057-2 'Fiber intake 24 hour Measured' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3006471='Insulin-like growth factor binding protein 2' was fabricated)"

* group[=].element[+].code = #nutrition-sodium-intake
* group[=].element[=].display = "Sodium intake"
* group[=].element[=].target[+].code = #21494366
* group[=].element[=].target[=].display = "Sodium intake 24 hour Measured"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 21494366 = LOINC 81012-7 'Sodium intake 24 hour Measured' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3022192='Triglyceride' was fabricated)"

// =============================================================================
// Group 2: Fluid Intake
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "https://athena.ohdsi.org/search-terms/concepts"
* group[=].element[+].code = #fluid-intake
* group[=].element[=].display = "Fluid intake"
* group[=].element[=].target[+].code = #46234686
* group[=].element[=].target[=].display = "Fluid intake 24 hour Estimated"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 46234686 = LOINC 75301-2 'Fluid intake 24 hour Estimated' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3004501='Glucose in Serum' was fabricated)"

// =============================================================================
// Group 3: Vitamin Intake
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "https://athena.ohdsi.org/search-terms/concepts"
* group[=].element[+].code = #vitamin-d-intake
* group[=].element[=].display = "Vitamin D intake"
* group[=].element[=].target[+].code = #21494618
* group[=].element[=].target[=].display = "Vitamin D intake 24 hour Measured"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 21494618 = LOINC 81930-0 'Vitamin D intake 24 hour Measured' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3032702='CD33 Ag in Tissue by Immune stain' was fabricated)"

* group[=].element[+].code = #vitamin-c-intake
* group[=].element[=].display = "Vitamin C intake"
* group[=].element[=].target[+].code = #21494524
* group[=].element[=].target[=].display = "Vitamin C intake 24 hour Measured"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 21494524 = LOINC 81075-4 'Vitamin C intake 24 hour Measured' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3032700='Glomerular basement membrane Ab' was fabricated)"

// =============================================================================
// Group 4: Mineral Intake
// =============================================================================
* group[+].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[=].target = "https://athena.ohdsi.org/search-terms/concepts"
* group[=].element[+].code = #calcium-intake
* group[=].element[=].display = "Calcium intake"
* group[=].element[=].target[+].code = #3032345
* group[=].element[=].target[=].display = "Calcium intake 24 hour"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 3032345 = LOINC 35264-1 'Calcium intake 24 hour' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3032690='Platelet aggregation ristocetin' was fabricated)"

* group[=].element[+].code = #iron-intake
* group[=].element[=].display = "Iron intake"
* group[=].element[=].target[+].code = #21494532
* group[=].element[=].target[=].display = "Iron intake 24 hour Measured"
* group[=].element[=].target[=].equivalence = #equivalent
* group[=].element[=].target[=].comment = "OMOP concept_id 21494532 = LOINC 81083-8 'Iron intake 24 hour Measured' (Measurement, Standard); RE-VERIFIED via Athena 2026-05-21 (previous mapping #3032696='Somatostatin' was fabricated)"

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
