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

* code = $LOINC#77111-4 "Water intake"
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

* code = $LOINC#9051-4 "Caloric intake total"
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

* code = $LOINC#LP199119-9 "Macronutrients panel"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    carbohydrates 0..1 MS and
    proteins 0..1 MS and
    fats 0..1 MS

* component[carbohydrates].code = $LOINC#LP35925-4 "Carbohydrates"
* component[carbohydrates].valueQuantity.system = $UCUM
* component[carbohydrates].valueQuantity.code = #g
* component[carbohydrates].valueQuantity.unit = "gram"

* component[proteins].code = $LOINC#LP35921-3 "Proteins" 
* component[proteins].valueQuantity.system = $UCUM
* component[proteins].valueQuantity.code = #g
* component[proteins].valueQuantity.unit = "gram"

* component[fats].code = $LOINC#LP35922-1 "Fats"
* component[fats].valueQuantity.system = $UCUM
* component[fats].valueQuantity.code = #g
* component[fats].valueQuantity.unit = "gram"
