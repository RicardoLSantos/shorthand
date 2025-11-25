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
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* group[0].target = "http://snomed.info/sct"

// WATER INTAKE - NEEDS VERIFICATION ⚠️
* group[0].element[0].code = #water-intake
* group[0].element[0].display = "Water intake volume"
* group[0].element[0].target[0].code = #226364002
* group[0].element[0].target[0].display = "Fluid intake (observable entity)"
* group[0].element[0].target[0].equivalence = #narrower
* group[0].element[0].target[0].comment = "Water intake maps to broader SNOMED concept 'Fluid intake'. Target includes all fluids (water, juice, etc.), source is specific to water only. Code 226364002 should be verified via SNOMED CT Browser."

// CALORIC INTAKE - NEEDS VERIFICATION ⚠️
* group[0].element[1].code = #caloric-intake
* group[0].element[1].display = "Total caloric intake"
* group[0].element[1].target[0].code = #226355004
* group[0].element[1].target[0].display = "Dietary energy intake (observable entity)"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[1].target[0].comment = "Caloric intake maps to SNOMED 'Dietary energy intake'. Code 226355004 should be verified via SNOMED CT Browser before clinical use."

// MACRONUTRIENTS PANEL - NO EXACT MATCH ⚠️
* group[0].element[2].code = #macronutrients-panel
* group[0].element[2].display = "Macronutrients intake panel"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "No exact SNOMED CT code for macronutrients panel as of November 2025. SNOMED has individual codes for protein, carbohydrate, and fat intake but not a panel concept. Individual component mappings below."

// PROTEIN INTAKE - NEEDS VERIFICATION ⚠️
* group[0].element[3].code = #protein-intake
* group[0].element[3].display = "Protein intake"
* group[0].element[3].target[0].code = #226357007
* group[0].element[3].target[0].display = "Dietary protein intake (observable entity)"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[3].target[0].comment = "Protein intake maps to SNOMED 'Dietary protein intake'. Code 226357007 should be verified via SNOMED CT Browser."

// FAT INTAKE - NEEDS VERIFICATION ⚠️
* group[0].element[4].code = #fat-intake
* group[0].element[4].display = "Fat intake"
* group[0].element[4].target[0].code = #226358002
* group[0].element[4].target[0].display = "Dietary fat intake (observable entity)"
* group[0].element[4].target[0].equivalence = #equivalent
* group[0].element[4].target[0].comment = "Fat intake maps to SNOMED 'Dietary fat intake'. Code 226358002 should be verified via SNOMED CT Browser."

// CARBOHYDRATE INTAKE - NEEDS VERIFICATION ⚠️
* group[0].element[5].code = #carbohydrate-intake
* group[0].element[5].display = "Carbohydrate intake"
* group[0].element[5].target[0].code = #226359005
* group[0].element[5].target[0].display = "Dietary carbohydrate intake (observable entity)"
* group[0].element[5].target[0].equivalence = #equivalent
* group[0].element[5].target[0].comment = "Carbohydrate intake maps to SNOMED 'Dietary carbohydrate intake'. Code 226359005 should be verified via SNOMED CT Browser."
