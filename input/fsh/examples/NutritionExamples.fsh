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
* extension[=].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/nutrition-data-source-cs#manual "Manual Entry"

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
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#macronutrients-panel "Macronutrients intake panel"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T20:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* component[carbohydrates].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#carbohydrate-intake "Carbohydrate intake"
* component[carbohydrates].valueQuantity = 275 'g' "gram"

* component[proteins].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#protein-intake "Protein intake"
* component[proteins].valueQuantity = 85 'g' "gram"

* component[fats].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#fat-intake "Fat intake"
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
