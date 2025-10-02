// Originally defined on lines 1 - 94
Instance: DailyNutritionQuestionnaire
InstanceOf: Questionnaire
Title: "Daily Nutrition Intake Questionnaire"
Description: "Questionnaire for daily nutrition intake tracking"
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/daily-nutrition"
* version = "0.1.0"
* name = "DailyNutritionQuestionnaire"
* title = "Daily Nutrition Intake"
* status = #active
* experimental = false
* date = "2024-12-14"
* publisher = "Ricardo Lourenço dos Santos"
* item[0]
* item[0].linkId = "water_intake"
* item[0].text = "How much water did you drink today?"
* item[0].type = #quantity
* item[0].required = true
* item[0].repeats = false
* item[0].initial.valueQuantity = 0 'mL'
* item[1]
* item[1].linkId = "meal_record"
* item[1].text = "Meal Records"
* item[1].type = #group
* item[1].repeats = true
* item[1].item[0]
* item[1].item[0].linkId = "meal_time"
* item[1].item[0].text = "Meal Time"
* item[1].item[0].type = #dateTime
* item[1].item[0].required = true
* item[1].item[1]
* item[1].item[1].linkId = "meal_type"
* item[1].item[1].text = "Meal Type"
* item[1].item[1].type = #choice
* item[1].item[1].required = true
* item[1].item[1].answerOption[0].valueString = "Breakfast"
* item[1].item[1].answerOption[1].valueString = "Lunch"
* item[1].item[1].answerOption[2].valueString = "Dinner"
* item[1].item[1].answerOption[3].valueString = "Snack"
* item[1].item[2]
* item[1].item[2].linkId = "calories"
* item[1].item[2].text = "Estimated Calories"
* item[1].item[2].type = #integer
* item[1].item[2].required = true
* item[1].item[3]
* item[1].item[3].linkId = "macronutrients"
* item[1].item[3].text = "Macronutrients"
* item[1].item[3].type = #group
* item[1].item[3].item[0]
* item[1].item[3].item[0].linkId = "carbs"
* item[1].item[3].item[0].text = "Carbohydrates (g)"
* item[1].item[3].item[0].type = #decimal
* item[1].item[3].item[0].required = true
* item[1].item[3].item[1]
* item[1].item[3].item[1].linkId = "protein"
* item[1].item[3].item[1].text = "Proteins (g)"
* item[1].item[3].item[1].type = #decimal
* item[1].item[3].item[1].required = true
* item[1].item[3].item[2]
* item[1].item[3].item[2].linkId = "fat"
* item[1].item[3].item[2].text = "Fats (g)"
* item[1].item[3].item[2].type = #decimal
* item[1].item[3].item[2].required = true
* item[2]
* item[2].linkId = "caffeine"
* item[2].text = "Caffeine Intake"
* item[2].type = #group
* item[2].item[0]
* item[2].item[0].linkId = "caffeine_amount"
* item[2].item[0].text = "Caffeine amount (mg)"
* item[2].item[0].type = #integer
* item[2].item[0].required = false
* item[2].item[1]
* item[2].item[1].linkId = "caffeine_source"
* item[2].item[1].text = "Caffeine source"
* item[2].item[1].type = #choice
* item[2].item[1].repeats = true
* item[2].item[1].answerOption[0].valueString = "Coffee"
* item[2].item[1].answerOption[1].valueString = "Tea"
* item[2].item[1].answerOption[2].valueString = "Soft Drink"
* item[2].item[1].answerOption[3].valueString = "Energy Drink"

