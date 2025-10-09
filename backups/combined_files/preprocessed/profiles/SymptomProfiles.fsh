// Originally defined on lines 1 - 36
Profile: SymptomQuestionnaire
Parent: Questionnaire
Id: symptom-questionnaire
Title: "Symptom Assessment Questionnaire"
Description: "Questionnaire template for symptom assessments"
* status MS
* title MS
* item MS
* item ^slicing.discriminator.type = #value
* item ^slicing.discriminator.path = "linkId"
* item ^slicing.rules = #open
* item contains
    symptomType 0.. and
    location 0.. and
    onset 0.. and
    description 0..
* item[symptomType] 1..1
* item[symptomType] MS
* item[location] 0..1
* item[location] MS
* item[onset] 0..1
* item[onset] MS
* item[description] 0..1
* item[description] MS
* item[symptomType].linkId = "symptom-type"
* item[symptomType].text = "Type of Symptom"
* item[symptomType].type = #choice
* item[symptomType].required = true
* item[location].linkId = "location"
* item[location].text = "Location"
* item[location].type = #string
* item[onset].linkId = "onset"
* item[onset].text = "When did it start?"
* item[onset].type = #dateTime
* item[description].linkId = "description"
* item[description].text = "Description"
* item[description].type = #text

