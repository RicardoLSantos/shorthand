Instance: NutritionQuestionnaireResponseExample
InstanceOf: QuestionnaireResponse
Usage: #example
Description: "Nutrition questionnaire response example"
Title: "Daily Nutrition Questionnaire Response Example"

* questionnaire = "https://2rdoc.pt/fhir/Questionnaire/daily-nutrition"
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
