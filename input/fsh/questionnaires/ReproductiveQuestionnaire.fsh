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
    * minValue = 0
    * maxValue = 10
 
* item[2]
  * linkId = "basal_temperature"
  * text = "Temperatura Basal"
  * type = #group
 
  * item[0]
    * linkId = "temperature_value"
    * text = "Temperatura (°C)"
    * type = #decimal
    * required = true
 
  * item[1]
    * linkId = "measurement_time"
    * text = "Horário da medição"
    * type = #time
    * required = true
 
* item[3]
  * linkId = "fertility"
  * text = "Dados de Fertilidade"
  * type = #group
 
  * item[0]
    * linkId = "cervical_mucus"
    * text = "Características do muco cervical"
    * type = #choice
    * answerValueSet = "http://example.org/ValueSet/cervical-mucus"
 
  * item[1]
    * linkId = "ovulation_test"
    * text = "Resultado do teste de ovulação"
    * type = #choice
    * answerOption[0].valueString = "Positivo"
    * answerOption[1].valueString = "Negativo"
    * answerOption[2].valueString = "Não realizado"

* item[4]
  * linkId = "related_factors"
  * text = "Fatores Relacionados"
  * type = #group

  * item[0]
    * linkId = "sleep_quality"
    * text = "Qualidade do Sono"
    * type = #choice
    * answerOption[0].valueString = "Boa"
    * answerOption[1].valueString = "Regular"
    * answerOption[2].valueString = "Ruim"

  * item[1]
    * linkId = "stress_level"
    * text = "Nível de Estresse"
    * type = #choice
    * answerOption[0].valueString = "Baixo"
    * answerOption[1].valueString = "Moderado"
    * answerOption[2].valueString = "Alto"

* item[5]
  * linkId = "medications"
  * text = "Medicações"
  * type = #group

  * item[0]
    * linkId = "medication_taken"
    * text = "Tomando alguma medicação?"
    * type = #boolean

  * item[1]
    * linkId = "medication_type"
    * text = "Tipo de medicação"
    * type = #choice
    * enableWhen
      * question = "medication_taken"
      * operator = #=
      * answerBoolean = true
    * answerValueSet = "http://example.org/ValueSet/reproductive-medications"

* item[6]
  * linkId = "physical_activity"
  * text = "Atividade Física"
  * type = #group

  * item[0]
    * linkId = "activity_type"
    * text = "Tipo de atividade"
    * type = #choice
    * answerValueSet = "http://example.org/ValueSet/activity-types"

  * item[1]
    * linkId = "activity_duration"
    * text = "Duração (minutos)"
    * type = #integer

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
    * minValue = 0
    * maxValue = 10

* item[8]
  * linkId = "notes"
  * text = "Observações Adicionais"
  * type = #text

Instance: ExampleReproductiveResponse
InstanceOf: QuestionnaireResponse
Usage: #example
Title: "Example Reproductive Health Questionnaire Response"

* questionnaire = "http://example.org/Questionnaire/reproductive-health"
* status = #completed
* authored = "2024-03-19T08:30:00Z"

* item[0]
  * linkId = "menstrual_cycle"
  * item[0]
    * linkId = "cycle_start"
    * answer.valueBoolean = true

  * item[1]
    * linkId = "flow_intensity"
    * answer.valueString = "Moderado"

* item[1]
  * linkId = "symptoms"
  * item[0]
    * linkId = "symptom_type"
    * answer.valueCoding = $SCT#55300003 "Cólica"

  * item[1]
    * linkId = "symptom_severity"
    * answer.valueInteger = 5

* item[2]
  * linkId = "basal_temperature"
  * item[0]
    * linkId = "temperature_value"
    * answer.valueDecimal = 36.7

  * item[1]
    * linkId = "measurement_time"
    * answer.valueTime = "06:30:00"
