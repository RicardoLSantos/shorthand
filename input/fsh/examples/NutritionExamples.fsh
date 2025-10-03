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
* method = $SCT#229059009 "Food diary"
* note.text = "Lunch meal - Mediterranean diet"
