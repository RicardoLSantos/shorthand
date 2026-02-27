// =============================================================================
// Nutrition Examples - F2.11.5 Expansion
// =============================================================================
// Updated: 2026-01-12
// Added: Micronutrients examples with DRI references
//
// References:
// - IoM (2011). DRI for Calcium and Vitamin D. NAP. DOI:10.17226/13050
// - USDA (2020). Dietary Guidelines for Americans 2020-2025
// =============================================================================

Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $SCT = http://snomed.info/sct
Alias: $ObsInt = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0

Instance: NutritionQuestionnaireResponseExample
InstanceOf: QuestionnaireResponse
Usage: #example
Description: "Nutrition questionnaire response example"
Title: "Daily Nutrition Questionnaire Response Example"

* questionnaire = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/daily-nutrition"
* status = #completed
* subject = Reference(Patient/PatientExample)
* authored = "2024-12-14T20:00:00Z"

* item[0]
  * linkId = "water_intake"
  * answer.valueQuantity = 2000 'mL'

* item[1]
  * linkId = "meal_record"

  * item[0]
    * linkId = "meal_time"
    * answer.valueDateTime = "2024-12-14T12:00:00Z"

  * item[1]
    * linkId = "meal_type"
    * answer.valueString = "Lunch"

  * item[2]
    * linkId = "calories"
    * answer.valueInteger = 650

  * item[3]
    * linkId = "macronutrients"
   
    * item[0]
      * linkId = "carbs"
      * answer.valueDecimal = 75
   
    * item[1]
      * linkId = "protein"
      * answer.valueDecimal = 30
   
    * item[2]
      * linkId = "fat"
      * answer.valueDecimal = 25

* item[2]
  * linkId = "caffeine"

  * item[0]
    * linkId = "caffeine_amount"
    * answer.valueInteger = 80

  * item[1]
    * linkId = "caffeine_source"
    * answer.valueString = "Coffee"

Instance: CalorieIntakeExample
InstanceOf: CalorieIntakeObservation
Usage: #example
Description: "Daily calorie intake observation example"
Title: "Daily Calorie Intake Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity = 2100 'kcal' "kilocalorie"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "kilocalorie"
* note.text = "Total calories consumed during the day from all meals"

Instance: MacronutrientsExample
InstanceOf: MacronutrientsObservation
Usage: #example
Description: "Daily macronutrients observation example"
Title: "Daily Macronutrients Distribution Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* component[carbohydrates].valueQuantity = 250 'g' "gram"
* component[carbohydrates].valueQuantity.system = $UCUM

Instance: WaterIntakeExample
InstanceOf: WaterIntakeObservation
Usage: #example
Description: "Daily water intake observation example"
Title: "Daily Water Intake Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity = 2500 'mL' "milliliter"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "milliliter"
* note.text = "Total water and fluid intake during the day"

Instance: NutritionIntakeObservationExample
InstanceOf: NutritionIntakeObservation
Usage: #example
Description: "Generic nutrition intake observation example"
Title: "Nutrition Intake Observation Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T12:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* code = $LOINC#9052-2 "Calorie intake total"
* valueQuantity = 650 'kcal' "kilocalorie"
* valueQuantity.system = $UCUM
* method = $SCT#229059009 "Report"
* note.text = "Lunch meal - Mediterranean diet"
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/nutrition-data-source"
* extension[=].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#manual "Manual Entry"

// -----------------------------------------------------------------------------
// F2.11.5: Micronutrients Examples
// -----------------------------------------------------------------------------

Instance: MicronutrientsAdequateExample
InstanceOf: MicronutrientsObservation
Usage: #example
Description: "Micronutrients observation - adequate intake meeting DRIs"
Title: "Micronutrients - Adequate Intake"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $LOINC#81941-7 "Micronutrient intake panel"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* component[vitaminD].code = $LOINC#81929-2 "Vitamin D intake 24 hour Estimated"
* component[vitaminD].valueQuantity = 800 '[IU]' "international unit"

* component[vitaminC].code = $LOINC#81074-7 "Vitamin C intake 24 hour Estimated"
* component[vitaminC].valueQuantity = 95 'mg' "milligram"

* component[calcium].code = $LOINC#81137-2 "Calcium intake 24 hour Estimated"
* component[calcium].valueQuantity = 1100 'mg' "milligram"

* component[iron].code = $LOINC#81082-0 "Iron intake 24 hour Estimated"
* component[iron].valueQuantity = 12 'mg' "milligram"

* component[magnesium].code = $LOINC#81005-1 "Magnesium intake 24 hour Estimated"
* component[magnesium].valueQuantity = 380 'mg' "milligram"

* component[sodium].code = $LOINC#81011-9 "Sodium intake 24 hour Estimated"
* component[sodium].valueQuantity = 2100 'mg' "milligram"

* interpretation = $ObsInt#N "Normal"
* note.text = "Adequate micronutrient intake from varied diet; no supplementation required"

Instance: MicronutrientsDeficientExample
InstanceOf: MicronutrientsObservation
Usage: #example
Description: "Micronutrients observation - deficient intake below DRIs"
Title: "Micronutrients - Deficient Intake"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $LOINC#81941-7 "Micronutrient intake panel"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* component[vitaminD].code = $LOINC#81929-2 "Vitamin D intake 24 hour Estimated"
* component[vitaminD].valueQuantity = 200 '[IU]' "international unit"

* component[vitaminB12].code = $LOINC#81062-2 "Vitamin B12 intake 24 hour Estimated"
* component[vitaminB12].valueQuantity = 1.2 'ug' "microgram"

* component[calcium].code = $LOINC#81137-2 "Calcium intake 24 hour Estimated"
* component[calcium].valueQuantity = 450 'mg' "milligram"

* component[iron].code = $LOINC#81082-0 "Iron intake 24 hour Estimated"
* component[iron].valueQuantity = 6 'mg' "milligram"

* interpretation = $ObsInt#L "Low"
* note.text = "Multiple micronutrient deficiencies; consider supplementation and dietary counseling"

Instance: MacronutrientsCompleteExample
InstanceOf: MacronutrientsObservation
Usage: #example
Description: "Complete macronutrients with all three components"
Title: "Macronutrients - Complete Daily Assessment"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#macronutrients-panel "Macronutrients intake panel"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* component[carbohydrates].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#lifestyle-carbohydrate-intake "Carbohydrate intake"
* component[carbohydrates].valueQuantity = 275 'g' "gram"

* component[proteins].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#lifestyle-protein-intake "Protein intake"
* component[proteins].valueQuantity = 85 'g' "gram"

* component[fats].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#lifestyle-fat-intake "Fat intake"
* component[fats].valueQuantity = 70 'g' "gram"

* note.text = "Distribution: ~52% carbs, ~16% protein, ~32% fat - within DGA 2020 recommendations"

Instance: HydrationExample
InstanceOf: WaterIntakeObservation
Usage: #example
Description: "Hydration tracking with EFSA reference"
Title: "Water Intake - Adequate Hydration"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity = 2400 'mL' "milliliter"
* interpretation = $ObsInt#N "Normal"
* note.text = "Adequate hydration per EFSA 2010 guidelines (2.5L/day for adult males)"

// =============================================================================
// Semantic Anchoring Example - Dual-Coding with LOINC LP Part Code
// =============================================================================
// Demonstrates LP dual-coding pattern: custom code (primary) + LOINC Part code
// (semantic anchor) in the same CodeableConcept. LP73201-3 "Protein intake" is
// a LOINC Part (Component axis) — it identifies the concept but is NOT an
// observation code (lacks Property, Time, System, Scale, Method axes).
// Including it enables: (1) hierarchical grouping via LOINC Part hierarchy,
// (2) machine-readable gap documentation, (3) migration path when Regenstrief
// assigns a full observation code.
// Reference: Forrey et al. 1996 (DOI: 10.1093/clinchem/42.1.81)
// =============================================================================

Instance: ProteinIntakeDualCodingExample
InstanceOf: Observation
Usage: #example
Description: "Protein intake with semantic anchoring via LOINC LP Part code dual-coding"
Title: "Protein Intake - Semantic Anchoring (LP Dual-Coding)"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-02-25T19:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

// Dual-coding: custom code (primary) + LOINC LP Part code (semantic anchor)
* code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#nutrition-protein-intake "Protein intake"
* code.coding[1] = $LOINC#LP73201-3 "Protein intake"
* code.text = "Protein intake"

* valueQuantity = 85 'g' "gram"
* note.text = "Daily protein intake from wearable nutrition tracking. LOINC LP73201-3 is a Part code (Component axis) providing semantic anchoring — no LOINC observation code exists for wearable-tracked protein intake."

// =============================================================================
// Semantic Anchoring Example - Vitamin D Intake with LOINC LP Part Code
// =============================================================================
// LP207604-2 "Vitamin D intake" is a LOINC Part code. LOINC has observation
// codes for serum Vitamin D levels (e.g., 1989-3) but NOT for dietary intake
// from food tracking apps.
// =============================================================================

Instance: VitaminDIntakeDualCodingExample
InstanceOf: Observation
Usage: #example
Description: "Vitamin D dietary intake with semantic anchoring via LOINC LP Part code"
Title: "Vitamin D Intake - Semantic Anchoring (LP Dual-Coding)"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-02-25T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#vitamin-d-intake "Vitamin D intake"
* code.coding[1] = $LOINC#LP207604-2 "Vitamin D intake"
* code.text = "Vitamin D dietary intake"

* valueQuantity = 600 '[IU]' "international unit"
* note.text = "Daily Vitamin D intake from food tracking. LOINC LP207604-2 is a Part code — LOINC has codes for serum 25-OH-D levels (e.g., 1989-3) but not for dietary intake from consumer apps. IoM recommends 600 IU/day (DOI: 10.17226/13050)."
