Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

// Originally defined on lines 5 - 21
Profile: NutritionIntakeObservation
Parent: Observation
Id: nutrition-intake-observation
Title: "Nutrition Intake Observation Profile"
Description: "Profile for nutrition intake data from iOS Health App and user input"
* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Ricardo Lourenço dos Santos"
* status MS
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#nutrition
* subject 1..1
* subject MS
* effectiveDateTime 1..1
* effectiveDateTime MS
* code 1..1
* code MS
* method 0..1
* method MS

// Originally defined on lines 23 - 37
Profile: WaterIntakeObservation
Parent: NutritionIntakeObservation
Id: water-intake-observation
Title: "Water Intake Observation Profile"
Description: "Profile for water intake measurements"
* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Ricardo Lourenço dos Santos"
* code = http://loinc.org#77111-4 "Water intake"
* valueQuantity only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mL
* valueQuantity.unit = "milliliter"

// Originally defined on lines 39 - 53
Profile: CalorieIntakeObservation
Parent: NutritionIntakeObservation
Id: calorie-intake-observation
Title: "Calorie Intake Observation Profile"
Description: "Profile for caloric intake measurements"
* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Ricardo Lourenço dos Santos"
* code = http://loinc.org#9051-4 "Caloric intake total"
* valueQuantity only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #kcal
* valueQuantity.unit = "kilocalorie"

// Originally defined on lines 55 - 88
Profile: MacronutrientsObservation
Parent: NutritionIntakeObservation
Id: macronutrients-observation
Title: "Macronutrients Observation Profile"
Description: "Profile for macronutrient intake measurements"
* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Ricardo Lourenço dos Santos"
* code = http://loinc.org#LP199119-9 "Macronutrients panel"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    carbohydrates 0.. and
    proteins 0.. and
    fats 0..
* component[carbohydrates] 0..1
* component[carbohydrates] MS
* component[proteins] 0..1
* component[proteins] MS
* component[fats] 0..1
* component[fats] MS
* component[carbohydrates].code = http://loinc.org#LP35925-4 "Carbohydrates"
* component[carbohydrates].valueQuantity.system = "http://unitsofmeasure.org"
* component[carbohydrates].valueQuantity.code = #g
* component[carbohydrates].valueQuantity.unit = "gram"
* component[proteins].code = http://loinc.org#LP35921-3 "Proteins"
* component[proteins].valueQuantity.system = "http://unitsofmeasure.org"
* component[proteins].valueQuantity.code = #g
* component[proteins].valueQuantity.unit = "gram"
* component[fats].code = http://loinc.org#LP35922-1 "Fats"
* component[fats].valueQuantity.system = "http://unitsofmeasure.org"
* component[fats].valueQuantity.code = #g
* component[fats].valueQuantity.unit = "gram"

