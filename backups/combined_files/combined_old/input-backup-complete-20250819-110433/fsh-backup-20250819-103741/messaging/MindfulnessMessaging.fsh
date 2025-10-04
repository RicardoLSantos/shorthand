Alias: $MsgEvents = http://example.org/fhir/CodeSystem/mindfulness-message-events
Alias: $MsgTypes = http://terminology.hl7.org/CodeSystem/message-type

Profile: MindfulnessMessageDefinition
Parent: MessageDefinition
Id: mindfulness-message-definition
Title: "Mindfulness Message Definition" 
Description: "Definition for mindfulness session messages"

* url 1..1 MS
* date 1..1 MS
* status 1..1 MS
* event[x] 1..1 MS
* category 0..1 MS
* focus 1..* MS
* focus.min 1..1

Instance: StartSessionMessage
InstanceOf: MindfulnessMessageDefinition
Title: "Start Session Message"
Description: "Message definition for starting a mindfulness session"

* url = "http://example.org/fhir/MessageDefinition/start-session"
* date = "2024-03-19"
* status = #active
* eventCoding = $MsgEvents#session-start "Session Start"
* category = #notification
* focus.code = #Observation
* focus.min = 1
* focus.profile = "http://example.org/fhir/StructureDefinition/mindfulness-session"

Instance: EndSessionMessage  
InstanceOf: MindfulnessMessageDefinition
Title: "End Session Message"
Description: "Message definition for ending a mindfulness session"

* url = "http://example.org/fhir/MessageDefinition/end-session"
* date = "2024-03-19"
* status = #active
* eventCoding = $MsgEvents#session-end "Session End"
* category = #notification
* focus.code = #Observation
* focus.min = 1
* focus.profile = "http://example.org/fhir/StructureDefinition/mindfulness-session"
