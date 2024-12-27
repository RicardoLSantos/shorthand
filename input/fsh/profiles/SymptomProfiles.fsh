Profile: SymptomQuestionnaire
Parent: Questionnaire
Id: symptom-questionnaire
Title: "Symptom Assessment Questionnaire"
Description: "Questionnaire template for symptom assessments"

* status MS
* title MS
* item MS

* item ^slicing.discriminator.type = #pattern
* item ^slicing.discriminator.path = "linkId"
* item ^slicing.rules = #open

* item contains
    symptomType 1..1 MS and
    location 0..1 MS and
    onset 0..1 MS and
    description 0..1 MS

* item[symptomType]
  * linkId = "symptom-type"
  * text = "Type of Symptom"
  * type = #choice
  * required = true

* item[location]
  * linkId = "location"
  * text = "Location of Symptom"
  * type = #string

* item[onset]
  * linkId = "onset"
  * text = "Onset Date"
  * type = #dateTime

* item[description]
  * linkId = "description"
  * text = "Symptom Description"
  * type = #text

Profile: SymptomAssessment
Parent: ClinicalImpression
Id: symptom-assessment
Title: "Symptom Clinical Assessment"
Description: "Clinical assessment of reported symptoms"

* status MS
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* finding MS

* finding ^slicing.discriminator.type = #pattern
* finding ^slicing.discriminator.path = "itemCodeableConcept"
* finding ^slicing.rules = #open

* finding contains
    severity 0..1 MS and
    pattern 0..1 MS and
    impact 0..1 MS

* finding[severity].itemCodeableConcept = $SCT#272141005 "Severity"
* finding[pattern].itemCodeableConcept = $SCT#410515003 "Pattern"
* finding[impact].itemCodeableConcept = $SCT#272127003 "Impact"

Invariant: symptom-severity-range
Description: "Severity score must be between 0 and 10"
Severity: #error
Expression: "component.where(code = %severity).value.as(Integer) >= 0 and component.where(code = %severity).value.as(Integer) <= 10"

Invariant: symptom-duration-valid
Description: "Duration must be a positive value"
Severity: #error
Expression: "component.where(code = %duration).value.as(Quantity) > 0"
