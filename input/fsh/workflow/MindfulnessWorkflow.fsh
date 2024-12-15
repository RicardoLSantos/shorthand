Instance: MindfulnessWorkflowDefinition
InstanceOf: ActivityDefinition
Usage: #definition
Title: "Mindfulness Session Workflow Definition"

* status = #draft
* experimental = false
* date = "2024-03-19"
* name = "MindfulnessWorkflow"
* publisher = "Example Organization"

* kind = #Task
* profile = Canonical(MindfulnessObservation)
* code = $SCT#711020003 "Meditation"

* timing.repeat
  * frequency = 1
  * period = 1
  * periodUnit = #d
  * dayOfWeek[0] = #mon
  * dayOfWeek[+] = #wed
  * dayOfWeek[+] = #fri

* dynamicValue[0]
  * path = "status"
  * expression
    * language = #text/fhirpath
    * expression = "'final'"

* participant[0]
  * type = #patient
  * role = http://terminology.hl7.org/CodeSystem/participant-role#pat

Instance: MindfulnessTaskTemplate
InstanceOf: PlanDefinition
Usage: #definition
Title: "Mindfulness Practice Task Template"

* status = #draft
* action[0]
  * title = "Daily Mindfulness Practice"
  * description = "Complete a mindfulness session"
  * code = $SCT#711020003 "Meditation"
  * timingTiming.repeat
    * frequency = 1
    * period = 1
    * periodUnit = #d
  * definitionCanonical = Canonical(MindfulnessWorkflowDefinition)

* action[1]
  * title = "Complete Practice Assessment"
  * description = "Fill out post-session questionnaire"
  * code = $SCT#273249006 "Assessment"
  * timingTiming.repeat
    * frequency = 1
    * period = 1
    * periodUnit = #d
  * relatedAction[0]
    * actionId = "mindfulness-session"
    * relationship = #after-end
    * offsetDuration.value = 5
    * offsetDuration.unit = #min

RuleSet: WorkflowRules
* status MS
* subject MS
* encounter MS
* authoredOn MS
* lastModified MS
* requester MS
* owner MS
* reasonCode MS

* status from http://hl7.org/fhir/ValueSet/task-status
* intent = #order
* priority = #routine
