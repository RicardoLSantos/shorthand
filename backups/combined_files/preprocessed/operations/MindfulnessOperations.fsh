// Originally defined on lines 1 - 16
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
* parameter.name 1..1

// Originally defined on lines 18 - 37
Instance: StartSessionOperation
InstanceOf: MindfulnessOperation
Title: "Start Session Operation"
Description: "Operation to start a new mindfulness session"
Usage: #example
* status = #active
* kind = #operation
* name = "start-session"
* code = #start
* resource = #Observation
* system = false
* type = true
* instance = false
* parameter[0]
* parameter[0].name = #duration
* parameter[0].use = #in
* parameter[0].min = 1
* parameter[0].max = "1"
* parameter[0].type = #integer
* parameter[0].documentation = "Duration in minutes"

// Originally defined on lines 39 - 58
Instance: EndSessionOperation
InstanceOf: MindfulnessOperation
Title: "End Session Operation"
Description: "Operation to end an ongoing mindfulness session"
Usage: #example
* status = #active
* kind = #operation
* name = "end-session"
* code = #end
* resource = #Observation
* system = false
* type = true
* instance = true
* parameter[0]
* parameter[0].name = #session
* parameter[0].use = #in
* parameter[0].min = 1
* parameter[0].max = "1"
* parameter[0].type = #string
* parameter[0].documentation = "ID of the session to end"

