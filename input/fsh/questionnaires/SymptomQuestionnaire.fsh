
* item[6]
  * linkId = "impact"
  * text = "Impact on Daily Activities"
  * type = #group

  * item[0]
    * linkId = "impact_level"
    * text = "How much does this affect your daily activities?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not at all"
    * answerOption[1].valueString = "Slightly"
    * answerOption[2].valueString = "Moderately"
    * answerOption[3].valueString = "Severely"
    * answerOption[4].valueString = "Completely"

  * item[1]
    * linkId = "impact_activities"
    * text = "Which activities are affected?"
    * type = #choice
    * repeats = true
    * answerValueSet = "http://example.org/ValueSet/daily-activities"

* item[7]
  * linkId = "relief"
  * text = "Relief Measures"
  * type = #group

  * item[0]
    * linkId = "relief_tried"
    * text = "What measures have you tried?"
    * type = #choice
    * repeats = true
    * answerValueSet = "http://example.org/ValueSet/relief-measures"

  * item[1]
    * linkId = "relief_effective"
    * text = "How effective were these measures?"
    * type = #choice
    * answerOption[0].valueString = "Not effective"
    * answerOption[1].valueString = "Slightly effective"
    * answerOption[2].valueString = "Moderately effective"
    * answerOption[3].valueString = "Very effective"

* item[8]
  * linkId = "pattern"
  * text = "Symptom Pattern"
  * type = #group

  * item[0]
    * linkId = "pattern_timing"
    * text = "When do symptoms typically occur?"
    * type = #choice
    * repeats = true
    * answerOption[0].valueString = "Morning"
    * answerOption[1].valueString = "Afternoon"
    * answerOption[2].valueString = "Evening"
    * answerOption[3].valueString = "Night"
    * answerOption[4].valueString = "No specific pattern"

  * item[1]
    * linkId = "pattern_progression"
    * text = "How has it changed over time?"
    * type = #choice
    * answerOption[0].valueString = "Getting better"
    * answerOption[1].valueString = "Staying the same"
    * answerOption[2].valueString = "Getting worse"
    * answerOption[3].valueString = "Fluctuating"

* item[9]
  * linkId = "additional"
  * text = "Additional Information"
  * type = #group

  * item[0]
    * linkId = "notes"
    * text = "Any additional notes or observations?"
    * type = #text

  * item[1]
    * linkId = "related_symptoms"
    * text = "Are there any related symptoms?"
    * type = #choice
    * repeats = true
    * answerValueSet = "http://example.org/ValueSet/common-symptoms"

* extension[0]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl"
  * valueCodeableConcept = http://hl7.org/fhir/questionnaire-item-control#auto-complete

* extension[1]
  * url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * valueCodeableConcept = http://unitsofmeasure.org#min "minutes"

Instance: ExampleSymptomResponse
InstanceOf: QuestionnaireResponse
Usage: #example
Title: "Example Symptom Questionnaire Response"

* questionnaire = "http://example.org/Questionnaire/symptom-tracking"
* status = #completed
* authored = "2024-03-19T10:30:00Z"
* item[0].linkId = "symptom"
* item[0].answer.valueString = "Headache"

* item[1].linkId = "severity"
* item[1].answer.valueInteger = 7

* item[2].linkId = "duration"
* item[2].item[0].linkId = "duration_value"
* item[2].item[0].answer.valueDecimal = 2
* item[2].item[1].linkId = "duration_unit"
* item[2].item[1].answer.valueString = "hours"

