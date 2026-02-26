// Operational ConceptMap: Nutrition Custom Codes → SNOMED CT
// Created: 2025-11-22
// Purpose: Enable $translate operations for nutrition terminology interoperability
// Status: Addresses terminology gap for consumer nutrition tracking

Instance: ConceptMapNutritionToSNOMED
InstanceOf: ConceptMap
Title: "Nutrition Measurements to SNOMED CT Mapping"
Description: "Maps custom nutrition measurement codes to SNOMED CT codes where available. Enables interoperability between consumer nutrition tracking apps (iOS Health App, MyFitnessPal, etc.) and clinical systems."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapNutritionToSNOMED"
* version = "0.1.0"
* name = "ConceptMapNutritionToSNOMED"
* title = "Nutrition Measurements to SNOMED CT Mapping"
* status = #active
* experimental = false
* date = "2025-11-22"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* description = "Operational ConceptMap for nutrition measurement terminology translation. Enables runtime $translate operations for semantic interoperability between consumer nutrition tracking applications and SNOMED CT standard terminology."
* purpose = "Provides semantic mappings from custom nutrition measurement codes to standard SNOMED CT codes. Consumer nutrition tracking uses proprietary measurements not fully covered by SNOMED CT. This ConceptMap enables clinical decision support systems to interpret consumer nutrition data using standardized terminology where available."

// ARCHITECTURE NOTE (2025-11-25): Removed sourceCanonical/targetCanonical
// See design-decisions.md for rationale. Source validation via group.source CodeSystem.

// Group 1: LifestyleObservationCS → SNOMED CT
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[0].target = "http://snomed.info/sct"

// ============================================================================
// CORRECTED 2025-12-08: All nutrition SNOMED codes verified as NOT FOUND
// via tx.fhir.org and Australian Ontoserver. Codes 226364002, 226355004,
// 226357007, 226358002, 226359005 DO NOT EXIST in SNOMED CT.
// Marking all as #unmatched with documented gaps.
// ============================================================================

// WATER INTAKE - CODE NOT FOUND ❌
* group[0].element[0].code = #nutrition-water-intake
* group[0].element[0].display = "Water intake volume"
* group[0].element[0].target[0].equivalence = #unmatched
* group[0].element[0].target[0].comment = "GAP: SNOMED CT code 226364002 does NOT exist (verified 2025-12-08 via tx.fhir.org). No standard code for fluid/water intake."

// CALORIC INTAKE - CODE NOT FOUND ❌
* group[0].element[1].code = #nutrition-caloric-intake
* group[0].element[1].display = "Total caloric intake"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = "GAP: SNOMED CT code 226355004 does NOT exist (verified 2025-12-08 via tx.fhir.org). No standard code for dietary energy intake."

// MACRONUTRIENTS PANEL - NO EXACT MATCH
* group[0].element[2].code = #macronutrients-panel
* group[0].element[2].display = "Macronutrients intake panel"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "GAP: No SNOMED CT code for macronutrients panel. Individual nutrient codes also do not exist."

// PROTEIN INTAKE - CODE NOT FOUND ❌
* group[0].element[3].code = #nutrition-protein-intake
* group[0].element[3].display = "Protein intake"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "GAP: SNOMED CT code 226357007 does NOT exist (verified 2025-12-08 via tx.fhir.org). No standard code for dietary protein intake."

// FAT INTAKE - CODE NOT FOUND ❌
* group[0].element[4].code = #nutrition-fat-intake
* group[0].element[4].display = "Fat intake"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "GAP: SNOMED CT code 226358002 does NOT exist (verified 2025-12-08 via tx.fhir.org). No standard code for dietary fat intake."

// CARBOHYDRATE INTAKE - CODE NOT FOUND ❌
* group[0].element[5].code = #nutrition-carbohydrate-intake
* group[0].element[5].display = "Carbohydrate intake"
* group[0].element[5].target[0].equivalence = #unmatched
* group[0].element[5].target[0].comment = "GAP: SNOMED CT code 226359005 does NOT exist (verified 2025-12-08 via tx.fhir.org). No standard code for dietary carbohydrate intake."
