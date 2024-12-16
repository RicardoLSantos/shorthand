Alias: $MessageEvents = http://example.org/fhir/ValueSet/mindfulness-message-events
Alias: $MessageTypes = http://terminology.hl7.org/CodeSystem/message-type

Profile: MindfulnessMessageDefinition
Parent: MessageDefinition
Id: mindfulness-message-definition
Title: "Mindfulness Message Definition"
Description: "Definition for mindfulness session messages"

* url 1..1 MS
* status 1..1 MS
* event[x] 1..1 MS
* category 0..1 MS
* focus 1..1 MS
* allowedResponse 0..* MS
* allowedResponse.message 1..1 MS

Instance: StartSessionMessage
InstanceOf: MindfulnessMessageDefinition
Title: "Start Session Message"
Description: "Message definition for starting a mindfulness session"

* url = "http://example.org/fhir/MessageDefinition/start-session"
* status = #active
* eventCoding = $MessageEvents#session-start "Session Start"
* category = #notification
* focus = #Observation
* allowedResponse.message = Canonical(EndSessionMessage)

Instance: EndSessionMessage
InstanceOf: MindfulnessMessageDefinition
Title: "End Session Message"
Description: "Message definition for ending a mindfulness session"

* url = "http://example.org/fhir/MessageDefinition/end-session"
* status = #active
* eventCoding = $MessageEvents#session-end "Session End"
* category = #notification
* focus = #Observation
* allowedResponse.message = Canonical(StartSessionMessage)

