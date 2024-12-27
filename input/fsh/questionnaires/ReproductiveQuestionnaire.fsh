Instance: ReproductiveHealthQuestionnaire
InstanceOf: Questionnaire
Usage: #definition
Title: "Reproductive Health Tracking Questionnaire"
Description: "Daily questionnaire for reproductive health tracking"
 
* status = #active
* url = "http://example.org/Questionnaire/reproductive-health"
* name = "ReproductiveHealthQuestionnaire"
* title = "Monitoramento de Saúde Reprodutiva"
* date = "2024-03-19"
 
* item[0]
  * linkId = "menstrual_cycle"
  * text = "Ciclo Menstrual"
  * type = #group
 
  * item[0]
    * linkId = "cycle_start"
    * text = "Início do ciclo hoje?"
    * type = #boolean
 
  * item[1]
    * linkId = "flow_intensity"
    * text = "Intensidade do fluxo"
    * type = #choice
    * enableWhen
      * question = "cycle_start"
      * operator = #=
      * answerBoolean = true
    * answerOption[0].valueString = "Leve"
    * answerOption[1].valueString = "Moderado"
    * answerOption[2].valueString = "Intenso"
 
* item[1]
  * linkId = "symptoms"
  * text = "Sintomas"
  * type = #group
  * repeats = true
 
  * item[0]
    * linkId = "symptom_type"
    * text = "Tipo de sintoma"
    * type = #choice
    * answerValueSet = "http://example.org/ValueSet/reproductive-symptoms"
 
  * item[1]
    * linkId = "symptom_severity"
    * text = "Intensidade (0-10)"
    * type = #integer
    * extension[0]
      * url = "http://hl7.org/fhir/StructureDefinition/minValue"
      * valueInteger = 0
    * extension[1]
      * url = "http://hl7.org/fhir/StructureDefinition/maxValue"
      * valueInteger = 10
 
* item[7]
  * linkId = "mood_changes"
  * text = "Mudanças de Humor"
  * type = #group

  * item[0]
    * linkId = "mood_type"
    * text = "Humor atual"
    * type = #choice
    * answerValueSet = "http://example.org/ValueSet/mood-types"

  * item[1]
    * linkId = "mood_severity"
    * text = "Intensidade (0-10)"
    * type = #integer
    * extension[0]
      * url = "http://hl7.org/fhir/StructureDefinition/minValue"
      * valueInteger = 0
    * extension[1]
      * url = "http://hl7.org/fhir/StructureDefinition/maxValue"
      * valueInteger = 10
