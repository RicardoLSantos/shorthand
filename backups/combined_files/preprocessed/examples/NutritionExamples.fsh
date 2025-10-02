// Originally defined on lines 1 - 55
Instance: NutritionQuestionnaireResponseExample
InstanceOf: QuestionnaireResponse
Title: "Daily Nutrition Questionnaire Response Example"
Description: "Nutrition questionnaire response example"
Usage: #example
* questionnaire = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/daily-nutrition"
* status = #completed
* subject = Reference(Patient/PatientExample)
* authored = "2024-12-14T20:00:00Z"
* item[0]
* item[0].linkId = "water_intake"
* item[0].answer.valueQuantity = 2000 'mL'
* item[1]
* item[1].linkId = "meal_record"
* item[1].item[0]
* item[1].item[0].linkId = "meal_time"
* item[1].item[0].answer.valueDateTime = "2024-12-14T12:00:00Z"
* item[1].item[1]
* item[1].item[1].linkId = "meal_type"
* item[1].item[1].answer.valueString = "Lunch"
* item[1].item[2]
* item[1].item[2].linkId = "calories"
* item[1].item[2].answer.valueInteger = 650
* item[1].item[3]
* item[1].item[3].linkId = "macronutrients"
* item[1].item[3].item[0]
* item[1].item[3].item[0].linkId = "carbs"
* item[1].item[3].item[0].answer.valueDecimal = 75
* item[1].item[3].item[1]
* item[1].item[3].item[1].linkId = "protein"
* item[1].item[3].item[1].answer.valueDecimal = 30
* item[1].item[3].item[2]
* item[1].item[3].item[2].linkId = "fat"
* item[1].item[3].item[2].answer.valueDecimal = 25
* item[2]
* item[2].linkId = "caffeine"
* item[2].item[0]
* item[2].item[0].linkId = "caffeine_amount"
* item[2].item[0].answer.valueInteger = 80
* item[2].item[1]
* item[2].item[1].linkId = "caffeine_source"
* item[2].item[1].answer.valueString = "Coffee"

