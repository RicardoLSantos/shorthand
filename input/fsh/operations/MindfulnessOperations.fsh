Profile: MindfulnessOperation
Parent: OperationDefinition
Id: mindfulness-operation
Title: "Mindfulness Operation"
Description: "Base definition for mindfulness operations"

* status 1..1
* kind 1..1
* name 1..1
* code 1..1
* resource 1..1
* system 1..1
* type 1..1
* instance 1..1
* parameter 0..*

Instance: StartSession
InstanceOf: MindfulnessOperation
Title: "Start Session Operation"
Description: "Operation to start a new mindfulness session"

* status = #active
* kind = #operation
* name = "start-session"
* code = #start
* resource = #Observation
* system = false
* type = true
* instance = false
* parameter[+]
  * name = "duration"
  * use = #in
  * documentation = "Duration in minutes"
  * min = 1
  * max = "1"
  * type = #integer

Instance: EndSession
InstanceOf: MindfulnessOperation
Title: "End Session Operation"
Description: "Operation to end an ongoing mindfulness session"

* status = #active
* kind = #operation
* name = "end-session"
* code = #end
* resource = #Observation
* system = false
* type = true
* instance = true
* parameter[+]
  * name = "sessionId"
  * use = #in
  * documentation = "ID of the session to end"
  * min = 1
  * max = "1"
  * type = #string

