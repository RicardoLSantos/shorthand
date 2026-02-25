// =============================================================================
// Nutrition Profiles - F2.11 Enhancement
// =============================================================================
// Updated: 2026-01-12
// Added: MicronutrientsObservation profile with vitamin/mineral tracking
//
// References:
// - IoM (2005). Dietary Reference Intakes for Energy, Carbohydrate, etc. NAP.
// - IoM (2011). Dietary Reference Intakes for Calcium and Vitamin D. NAP.
// - USDA (2020). Dietary Guidelines for Americans 2020-2025
// - Mifflin MD et al. (1990). Am J Clin Nutr 51(2):241-247
// =============================================================================

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

Profile: NutritionIntakeObservation
Parent: Observation
Id: nutrition-intake-observation
Title: "Nutrition Intake Observation Profile"
Description: "Profile for nutrition intake data from iOS Health App and user input"

* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Ricardo Lourenço dos Santos"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* code 1..1 MS
* method 0..1 MS

Profile: WaterIntakeObservation
Parent: NutritionIntakeObservation 
Id: water-intake-observation
Title: "Water Intake Observation Profile"
Description: "Profile for water intake measurements"

* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Ricardo Lourenço dos Santos"

* code = $LIFESTYLEOBS#lifestyle-water-intake "Water intake volume"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #mL
* valueQuantity.unit = "milliliter"

Profile: CalorieIntakeObservation
Parent: NutritionIntakeObservation
Id: calorie-intake-observation
Title: "Calorie Intake Observation Profile"
Description: "Profile for caloric intake measurements"

* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Ricardo Lourenço dos Santos"

* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#lifestyle-caloric-intake "Total caloric intake"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #kcal
* valueQuantity.unit = "kilocalorie"

Profile: MacronutrientsObservation
Parent: NutritionIntakeObservation
Id: macronutrients-observation
Title: "Macronutrients Observation Profile"
Description: "Profile for macronutrient intake measurements"

* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Ricardo Lourenço dos Santos"

* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#macronutrients-panel "Macronutrients intake panel"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    carbohydrates 0..1 MS and
    proteins 0..1 MS and
    fats 0..1 MS

* component[carbohydrates].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#lifestyle-carbohydrate-intake "Carbohydrate intake"
* component[carbohydrates].valueQuantity.system = $UCUM
* component[carbohydrates].valueQuantity.code = #g
* component[carbohydrates].valueQuantity.unit = "gram"

* component[proteins].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#lifestyle-protein-intake "Protein intake"
* component[proteins].valueQuantity.system = $UCUM
* component[proteins].valueQuantity.code = #g
* component[proteins].valueQuantity.unit = "gram"

* component[fats].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#lifestyle-fat-intake "Fat intake"
* component[fats].valueQuantity.system = $UCUM
* component[fats].valueQuantity.code = #g
* component[fats].valueQuantity.unit = "gram"

// =============================================================================
// F2.11.3: Micronutrients Observation Profile
// =============================================================================
// References:
// - IoM (2011). DRI for Calcium and Vitamin D. NAP. DOI:10.17226/13050
// - IoM (2001). DRI for Vitamin A, K, Arsenic... NAP.
// - Bailey RL et al. (2015). Ann Nutr Metab 66(Suppl 2):22-33. DOI:10.1159/000371618
// =============================================================================

Profile: MicronutrientsObservation
Parent: NutritionIntakeObservation
Id: micronutrients-observation
Title: "Micronutrients Observation Profile"
Description: """
Profile for micronutrient (vitamin and mineral) intake measurements.

**Vitamins tracked**:
- Vitamin D: 600-800 IU/day (IoM 2011)
- Vitamin C: 75-90 mg/day
- Vitamin A: 700-900 mcg RAE/day
- Vitamin E: 15 mg/day
- Vitamin B12: 2.4 mcg/day
- Folate: 400 mcg DFE/day

**Minerals tracked**:
- Calcium: 1000-1200 mg/day (IoM 2011)
- Iron: 8-18 mg/day
- Magnesium: 310-420 mg/day
- Zinc: 8-11 mg/day
- Potassium: 2600-3400 mg/day

**LOINC Codes**: Each component mapped to verified LOINC codes.

References:
- IoM (2011). DRI for Calcium and Vitamin D. DOI:10.17226/13050
- IoM (2001). DRI for Vitamins and Minerals
- Bailey RL et al. (2015). Ann Nutr Metab 66(Suppl 2):22-33
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2026-01-12"
* ^publisher = "FMUP HEADS2"

* code = $LOINC#81941-7 "Micronutrient intake panel"
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    vitaminD 0..1 MS and
    vitaminC 0..1 MS and
    vitaminA 0..1 MS and
    vitaminE 0..1 MS and
    vitaminB12 0..1 MS and
    folate 0..1 MS and
    calcium 0..1 MS and
    iron 0..1 MS and
    magnesium 0..1 MS and
    zinc 0..1 MS and
    potassium 0..1 MS and
    sodium 0..1 MS

// Vitamins
* component[vitaminD]
  * ^short = "Vitamin D intake (IoM 2011: 600-800 IU/day)"
  * code = $LOINC#81929-2 "Vitamin D intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #[IU]
  * valueQuantity.unit = "international unit"

* component[vitaminC]
  * ^short = "Vitamin C intake (RDA: 75-90 mg/day)"
  * code = $LOINC#81074-7 "Vitamin C intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #mg
  * valueQuantity.unit = "milligram"

* component[vitaminA]
  * ^short = "Vitamin A intake (RDA: 700-900 mcg RAE/day)"
  * code = $LOINC#81072-1 "Vitamin A intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #ug
  * valueQuantity.unit = "microgram"

* component[vitaminE]
  * ^short = "Vitamin E intake (RDA: 15 mg/day)"
  * code = $LOINC#81076-2 "Vitamin E intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #mg
  * valueQuantity.unit = "milligram"

* component[vitaminB12]
  * ^short = "Vitamin B12 intake (RDA: 2.4 mcg/day)"
  * code = $LOINC#81062-2 "Vitamin B12 intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #ug
  * valueQuantity.unit = "microgram"

* component[folate]
  * ^short = "Folate intake (RDA: 400 mcg DFE/day)"
  * code = $LOINC#81066-3 "Vitamin B9 (Folate) intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #ug
  * valueQuantity.unit = "microgram"

// Minerals
* component[calcium]
  * ^short = "Calcium intake (IoM 2011: 1000-1200 mg/day)"
  * code = $LOINC#81137-2 "Calcium intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #mg
  * valueQuantity.unit = "milligram"

* component[iron]
  * ^short = "Iron intake (RDA: 8-18 mg/day)"
  * code = $LOINC#81082-0 "Iron intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #mg
  * valueQuantity.unit = "milligram"

* component[magnesium]
  * ^short = "Magnesium intake (RDA: 310-420 mg/day)"
  * code = $LOINC#81005-1 "Magnesium intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #mg
  * valueQuantity.unit = "milligram"

* component[zinc]
  * ^short = "Zinc intake (RDA: 8-11 mg/day)"
  * code = $LOINC#81089-5 "Zinc intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #mg
  * valueQuantity.unit = "milligram"

* component[potassium]
  * ^short = "Potassium intake (AI: 2600-3400 mg/day)"
  * code = $LOINC#81010-1 "Potassium intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #mg
  * valueQuantity.unit = "milligram"

* component[sodium]
  * ^short = "Sodium intake (DGA 2020: <2300 mg/day)"
  * code = $LOINC#81011-9 "Sodium intake 24 hour Estimated"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #mg
  * valueQuantity.unit = "milligram"

* interpretation 0..1 MS
* interpretation ^short = "Adequacy assessment (adequate, deficient, excessive)"
* note 0..* MS
* note ^short = "Notes on dietary sources or supplementation"
