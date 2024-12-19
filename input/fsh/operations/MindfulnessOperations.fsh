Profile: MindfulnessOperation
Parent: OperationDefinition 
Id: mindfulness-operation
Title: "Mindfulness Operation"
Description: "Base definition for mindfulness operations"

* status = #active
* kind = #operation 
* name = "mindfulness-operation"
* code = #mindfulness
* resource = #Observation
* system = false
* type = true
* instance = false
* parameter 0..*

Instance: StartSession
InstanceOf: MindfulnessOperation
Title: "Start Session Operation"
Description: "Operation to start a new mindfulness session"

* name = "start-session"
* code = #start
* parameter[+]
  * name = "duration" 
  * use = #in
  * min = 1
  * max = "1"
  * type = #integer

Instance: EndSession 
InstanceOf: MindfulnessOperation
Title: "End Session Operation"
Description: "Operation to end an ongoing mindfulness session"

* name = "end-session"
* code = #end
* parameter[+]
  * name = "session-id"
  * use = #in
  * min = 1
  * max = "1" 
  * type = #string
