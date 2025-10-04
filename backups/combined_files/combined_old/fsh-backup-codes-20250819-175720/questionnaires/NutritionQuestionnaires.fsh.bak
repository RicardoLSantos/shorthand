Instance: DailyNutritionQuestionnaire
InstanceOf: Questionnaire
Usage: #definition
Title: "Daily Nutrition Intake Questionnaire"
Description: "Questionnaire for daily nutrition intake tracking"

* url = "https://github.com/RicardoLSantos/shorthand/Questionnaire/daily-nutrition"
* version = "0.1.0"
* name = "DailyNutritionQuestionnaire"
* title = "Daily Nutrition Intake"
* status = #active
* experimental = false
* date = "2024-12-14"
* publisher = "Ricardo Lourenço dos Santos"

* item[0]
  * linkId = "water_intake"
  * text = "How much water did you drink today?"
  * type = #quantity
  * required = true
  * repeats = false
  * initial.valueQuantity = 0 'mL'

* item[1]
  * linkId = "meal_record"
  * text = "Meal Records"
  * type = #group
  * repeats = true

  * item[0]
    * linkId = "meal_time"
    * text = "Meal Time"
    * type = #dateTime
    * required = true

  * item[1]
    * linkId = "meal_type"
    * text = "Meal Type"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Breakfast"
    * answerOption[1].valueString = "Lunch"
    * answerOption[2].valueString = "Dinner"
    * answerOption[3].valueString = "Snack"

  * item[2]
    * linkId = "calories"
    * text = "Estimated Calories"
    * type = #integer
    * required = true

  * item[3]
    * linkId = "macronutrients"
    * text = "Macronutrients"
    * type = #group

    * item[0]
      * linkId = "carbs"
      * text = "Carbohydrates (g)"
      * type = #decimal
      * required = true

    * item[1]
      * linkId = "protein"
      * text = "Proteins (g)"
      * type = #decimal
      * required = true

    * item[2]
      * linkId = "fat"
      * text = "Fats (g)"
      * type = #decimal
      * required = true

* item[2]
  * linkId = "caffeine"
  * text = "Caffeine Intake"
  * type = #group

  * item[0]
    * linkId = "caffeine_amount"
    * text = "Caffeine amount (mg)"
    * type = #integer
    * required = false

  * item[1]
    * linkId = "caffeine_source"
    * text = "Caffeine source"
    * type = #choice
    * repeats = true
    * answerOption[0].valueString = "Coffee"
    * answerOption[1].valueString = "Tea"
    * answerOption[2].valueString = "Soft Drink"
    * answerOption[3].valueString = "Energy Drink"
