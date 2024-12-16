Profile: MindfulnessOperation
Parent: OperationDefinition
Id: mindfulness-operation
Title: "Mindfulness Operation Definition"
Description: "Defines operations available for mindfulness sessions"

* name MS
* status MS
* kind MS
* code MS
* system MS
* type MS
* instance MS
* parameter MS

Instance: StartMindfulnessSession
InstanceOf: MindfulnessOperation
Usage: #definition
Title: "Start Mindfulness Session Operation"
Description: "Operation to start a new mindfulness session"

* status = #active
* kind = #operation
* code = #start-session
* system = false
* type = true
* instance = false
* parameter[+]
  * name = "duration"
  * use = #in
  * min = 1
  * max = "1"
  * type = #integer
  * documentation = "Duration of the session in minutes"

* parameter[+]
  * name = "type"
  * use = #in
  * min = 1
  * max = "1"
  * type = #code
  * documentation = "Type of mindfulness session"

