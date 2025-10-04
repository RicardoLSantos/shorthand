// Originally defined on lines 1 - 78
Instance: ReproductiveHealthQuestionnaire
InstanceOf: Questionnaire
Title: "Reproductive Health Tracking Questionnaire"
Description: "Daily questionnaire for social-history health tracking"
Usage: #definition
* status = #active
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/social-history-health"
* name = "ReproductiveHealthQuestionnaire"
* title = "Reproductive Health Monitoring"
* date = "2024-03-19"
* item[0]
* item[0].linkId = "menstrual_cycle"
* item[0].text = "Menstrual Cycle"
* item[0].type = #group
* item[0].item[0]
* item[0].item[0].linkId = "cycle_start"
* item[0].item[0].text = "Cycle started today?"
* item[0].item[0].type = #boolean
* item[0].item[1]
* item[0].item[1].linkId = "flow_intensity"
* item[0].item[1].text = "Flow intensity"
* item[0].item[1].type = #choice
* item[0].item[1].enableWhen
* item[0].item[1].enableWhen.question = "cycle_start"
* item[0].item[1].enableWhen.operator = #=
* item[0].item[1].enableWhen.answerBoolean = true
* item[0].item[1].answerOption[0].valueString = "Light"
* item[0].item[1].answerOption[1].valueString = "Moderate"
* item[0].item[1].answerOption[2].valueString = "Heavy"
* item[1]
* item[1].linkId = "symptoms"
* item[1].text = "Symptoms"
* item[1].type = #group
* item[1].repeats = true
* item[1].item[0]
* item[1].item[0].linkId = "symptom_type"
* item[1].item[0].text = "Symptom type"
* item[1].item[0].type = #choice
* item[1].item[0].answerValueSet = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/social-history-symptoms"
* item[1].item[1]
* item[1].item[1].linkId = "symptom_severity"
* item[1].item[1].text = "Intensity (0-10)"
* item[1].item[1].type = #integer
* item[1].item[1].extension[0]
* item[1].item[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
* item[1].item[1].extension[0].valueInteger = 0
* item[1].item[1].extension[1]
* item[1].item[1].extension[1].url = "http://hl7.org/fhir/StructureDefinition/maxValue"
* item[1].item[1].extension[1].valueInteger = 10
* item[2]
* item[2].linkId = "mood_changes"
* item[2].text = "Mood Changes"
* item[2].type = #group
* item[2].item[0]
* item[2].item[0].linkId = "mood_type"
* item[2].item[0].text = "Current mood"
* item[2].item[0].type = #choice
* item[2].item[0].answerValueSet = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mood-types"
* item[2].item[1]
* item[2].item[1].linkId = "mood_severity"
* item[2].item[1].text = "Intensity (0-10)"
* item[2].item[1].type = #integer
* item[2].item[1].extension[0]
* item[2].item[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
* item[2].item[1].extension[0].valueInteger = 0
* item[2].item[1].extension[1]
* item[2].item[1].extension[1].url = "http://hl7.org/fhir/StructureDefinition/maxValue"
* item[2].item[1].extension[1].valueInteger = 10

