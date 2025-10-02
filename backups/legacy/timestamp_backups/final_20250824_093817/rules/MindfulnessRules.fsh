RuleSet: MindfulnessValidation
* ^extension[0].url = "http://hl7.org/fhir/StructureDefinition/elementdefinition-bestpractice"
* ^extension[0].valueBoolean = true

* status MS
* code MS
* subject MS
* effective[x] MS
* value[x] MS
* component MS

* status from http://hl7.org/fhir/ValueSet/observation-status
* code from http://snomed.info/sct?fhir_vs=isa/711415009
* subject only Reference(Patient)
* effective[x] only dateTime

* obeys mindfulness-session-duration
* obeys mindfulness-stress-level
* obeys mindfulness-mood-required
* obeys mindfulness-context-complete
* obeys sequential-measurements

RuleSet: MindfulnessQuestionnaireValidation
* status MS
* title MS
* item MS

* status = #active
* subjectType = #Patient
* item ^slicing.discriminator.type = #pattern
* item ^slicing.discriminator.path = "linkId"
* item ^slicing.rules = #open
* item contains 
    session 0..1 MS and
    mood 0..1 MS and
    stress 0..1 MS and
    relaxation 0..1 MS

* item[session]
  * linkId = "mindful_session"
  * text = "Mindfulness Session"
  * type = #group
  * required = true
  * repeats = false

* item[mood]
  * linkId = "mood_assessment"
  * text = "Mood Assessment"
  * type = #group
  * required = true
  * repeats = false

* item[stress]
  * linkId = "stress_assessment"
  * text = "Stress Assessment"
  * type = #group
  * required = true
  * repeats = false

* item[relaxation]
  * linkId = "relaxation"
  * text = "Relaxation"
  * type = #group
  * required = true
  * repeats = false

RuleSet: MindfulnessResponseValidation
* status MS
* subject MS
* authored MS
* item MS

* status = #completed
* subject only Reference(Patient)
* authored 1..1
* item ^slicing.discriminator.type = #pattern
* item ^slicing.discriminator.path = "linkId"
* item ^slicing.rules = #open
