Alias: $MsgEvents = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-message-events
Alias: $MsgTypes = http://terminology.hl7.org/CodeSystem/message-type

// Originally defined on lines 4 - 16
Profile: MindfulnessMessageDefinition
Parent: MessageDefinition
Id: mindfulness-message-definition
Title: "Mindfulness Message Definition"
Description: "Definition for mindfulness session messages"
* url 1..1
* url MS
* date 1..1
* date MS
* status 1..1
* status MS
* event[x] 1..1
* event[x] MS
* category 0..1
* category MS
* focus 1..*
* focus MS
* focus.min 1..1

// Originally defined on lines 18 - 30
Instance: StartSessionMessage
InstanceOf: MindfulnessMessageDefinition
Title: "Start Session Message"
Description: "Message definition for starting a mindfulness session"
Usage: #example
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/MessageDefinition/start-session"
* date = "2024-03-19"
* status = #active
* eventCoding = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-message-events#session-start "Session Start"
* category = #notification
* focus.code = #Observation
* focus.min = 1
* focus.profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-session"

// Originally defined on lines 32 - 44
Instance: EndSessionMessage
InstanceOf: MindfulnessMessageDefinition
Title: "End Session Message"
Description: "Message definition for ending a mindfulness session"
Usage: #example
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/MessageDefinition/end-session"
* date = "2024-03-19"
* status = #active
* eventCoding = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-message-events#session-end "Session End"
* category = #notification
* focus.code = #Observation
* focus.min = 1
* focus.profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-session"

