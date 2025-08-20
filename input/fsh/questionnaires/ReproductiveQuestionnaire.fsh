Instance: ReproductiveHealthQuestionnaire
InstanceOf: Questionnaire
Usage: #definition
Title: "Reproductive Health Tracking Questionnaire"
Description: "Daily questionnaire for reproductive health tracking"
 
* status = #active
* url = "https://2rdoc.pt/fhir/Questionnaire/reproductive-health"
* name = "ReproductiveHealthQuestionnaire"
* title = "Reproductive Health Monitoring"
* date = "2024-03-19"
 
* item[0]
  * linkId = "menstrual_cycle"
  * text = "Menstrual Cycle"
  * type = #group
 
  * item[0]
    * linkId = "cycle_start"
    * text = "Cycle started today?"
    * type = #boolean
 
  * item[1]
    * linkId = "flow_intensity"
    * text = "Flow intensity"
    * type = #choice
    * enableWhen
      * question = "cycle_start"
      * operator = #=
      * answerBoolean = true
    * answerOption[0].valueString = "Light"
    * answerOption[1].valueString = "Moderate"
    * answerOption[2].valueString = "Heavy"
 
* item[1]
  * linkId = "symptoms"
  * text = "Symptoms"
  * type = #group
  * repeats = true
 
  * item[0]
    * linkId = "symptom_type"
    * text = "Symptom type"
    * type = #choice
    * answerValueSet = "https://2rdoc.pt/fhir/ValueSet/reproductive-symptoms"
 
  * item[1]
    * linkId = "symptom_severity"
    * text = "Intensity (0-10)"
    * type = #integer
    * extension[0]
      * url = "http://hl7.org/fhir/StructureDefinition/minValue"
      * valueInteger = 0
    * extension[1]
      * url = "http://hl7.org/fhir/StructureDefinition/maxValue"
      * valueInteger = 10
 
* item[2]
  * linkId = "mood_changes"
  * text = "Mood Changes"
  * type = #group

  * item[0]
    * linkId = "mood_type"
    * text = "Current mood"
    * type = #choice
    * answerValueSet = "https://2rdoc.pt/fhir/ValueSet/mood-types"

  * item[1]
    * linkId = "mood_severity"
    * text = "Intensity (0-10)"
    * type = #integer
    * extension[0]
      * url = "http://hl7.org/fhir/StructureDefinition/minValue"
      * valueInteger = 0
    * extension[1]
      * url = "http://hl7.org/fhir/StructureDefinition/maxValue"
      * valueInteger = 10
