
* item[4]
  * linkId = "related_factors"
  * text = "Related Factors"
  * type = #group

  * item[0]
    * linkId = "sleep_quality"
    * text = "Sleep Quality"
    * type = #choice
    * answerOption[0].valueString = "Good"
    * answerOption[1].valueString = "Fair"
    * answerOption[2].valueString = "Poor"

  * item[1]
    * linkId = "stress_level"
    * text = "Stress Level"
    * type = #choice
    * answerOption[0].valueString = "Low"
    * answerOption[1].valueString = "Moderate"
    * answerOption[2].valueString = "High"

* item[5]
  * linkId = "medications"
  * text = "Medications"
  * type = #group

  * item[0]
    * linkId = "medication_taken"
    * text = "Taking any medications?"
    * type = #boolean

  * item[1]
    * linkId = "medication_type"
    * text = "Type of medication"
    * type = #choice
    * enableWhen
      * question = "medication_taken"
      * operator = #=
      * answerBoolean = true
    * answerValueSet = "http://example.org/ValueSet/reproductive-medications"

* item[6]
  * linkId = "physical_activity"
  * text = "Physical Activity"
  * type = #group

  * item[0]
    * linkId = "activity_type"
    * text = "Type of activity"
    * type = #choice
    * answerValueSet = "http://example.org/ValueSet/activity-types"

  * item[1]
    * linkId = "activity_duration"
    * text = "Duration (minutes)"
    * type = #integer

* item[7]
  * linkId = "mood_changes"
  * text = "Mood Changes"
  * type = #group

  * item[0]
    * linkId = "mood_type"
    * text = "Current mood"
    * type = #choice
    * answerValueSet = "http://example.org/ValueSet/mood-types"

  * item[1]
    * linkId = "mood_severity"
    * text = "Intensity (0-10)"
    * type = #integer
    * minValue = 0
    * maxValue = 10

* item[8]
  * linkId = "notes"
  * text = "Additional Notes"
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
    * answer.valueString = "Moderate"

* item[1]
  * linkId = "symptoms"
  * item[0]
    * linkId = "symptom_type"
    * answer.valueCoding = $SCT#55300003 "Cramp"

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

