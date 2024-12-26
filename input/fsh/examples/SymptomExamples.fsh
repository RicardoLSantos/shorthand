
Instance: ChronicSymptomExample
InstanceOf: SymptomObservation
Usage: #example
Title: "Chronic Symptom Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#267036007 "Fatigue"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T14:00:00Z"

* component[severity].code = $LOINC#72514-3
* component[severity].valueInteger = 7

* component[duration].code = $LOINC#103332-8
* component[duration].valueQuantity = 30 'd'

* component[frequency].code = $LOINC#103334-4
* component[frequency].valueString = "Daily occurrence"

Instance: SymptomQuestionnaireResponseExample
InstanceOf: QuestionnaireResponse
Usage: #example
Title: "Symptom Questionnaire Response Example"

* questionnaire = "http://example.org/Questionnaire/symptom-tracking"
* status = #completed
* subject = Reference(Patient/example)
* authored = "2024-03-19T15:30:00Z"

* item[0]
  * linkId = "symptom"
  * answer.valueCoding = $SCT#25064002 "Headache"

* item[1]
  * linkId = "location"
  * answer.valueCoding = $SCT#69536005 "Head"

* item[2]
  * linkId = "severity"
  * answer.valueInteger = 6

* item[3]
  * linkId = "duration"
  * item[0]
    * linkId = "duration_value"
    * answer.valueDecimal = 2
  * item[1]
    * linkId = "duration_unit"
    * answer.valueString = "hours"

Instance: SymptomAssessmentExample
InstanceOf: ClinicalImpression
Usage: #example
Title: "Clinical Assessment of Symptoms Example"

* status = #completed
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T16:00:00Z"
* code = $SCT#410515003 "Clinical assessment"

* finding[0]
  * itemCodeableConcept = $SCT#272141005 "Severity"
  * itemReference = Reference(Observation/SymptomExample)

Instance: SymptomFollowUpExample
InstanceOf: SymptomObservation
Usage: #example
Title: "Symptom Follow-up Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#25064002 "Headache"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-26T10:00:00Z"
* basedOn = Reference(CarePlan/example)

* component[severity].code = $LOINC#72514-3
* component[severity].valueInteger = 4

* component[duration].code = $LOINC#103332-8
* component[duration].valueQuantity = 45 'min'

* component[frequency].code = $LOINC#103334-4
* component[frequency].valueString = "Once per week"

Instance: SymptomWithContextExample
InstanceOf: SymptomObservation
Usage: #example
Title: "Symptom with Context Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $SCT#25064002 "Headache"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T15:30:00Z"

* component[severity].code = $LOINC#72514-3
* component[severity].valueInteger = 8

* component[duration].code = $LOINC#103332-8
* component[duration].valueQuantity = 180 'min'

* component[frequency].code = $LOINC#103334-4
* component[frequency].valueString = "3 times per week"

* note.text = "Symptoms worsen with physical activity and bright lights"

