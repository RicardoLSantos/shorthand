Profile: MindfulnessSessionOperation
Parent: OperationDefinition
Id: mindfulness-session-operation
Title: "Mindfulness Session Operations"
Description: "Operations that can be performed on mindfulness sessions"

* name MS
* status MS
* code MS
* resource MS
* system MS
* type MS
* instance MS
* inputProfile MS
* outputProfile MS
* parameter MS

Instance: StartSessionOperation
InstanceOf: MindfulnessSessionOperation
Title: "Start Session Operation"
Description: "Operation to start a new mindfulness session"

* status = #active
* kind = #operation
* code = #start
* resource = #Observation
* system = false
* type = true
* instance = false
* parameter[+]
  * name = "duration"
  * use = #in
  * min = 1
  * max = "1"
  * type = #integer

* parameter[+]
  * name = "sessionType"
  * use = #in
  * min = 1
  * max = "1"
  * type = #code

