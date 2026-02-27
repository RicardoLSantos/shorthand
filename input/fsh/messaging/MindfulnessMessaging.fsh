Alias: $MsgEvents = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs
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

Instance: start-session
InstanceOf: MindfulnessMessageDefinition
Title: "Start Session Message"
Description: "Message definition for starting a mindfulness session"

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/MessageDefinition/start-session"
* date = "2024-03-19"
* status = #active
* eventCoding = $MsgEvents#mindfulness-msg-session-start "Session Start"
* category = #notification
* focus.code = #Observation
* focus.min = 1
* focus.max = "*"
* focus.profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-observation"

Instance: end-session
InstanceOf: MindfulnessMessageDefinition
Title: "End Session Message"
Description: "Message definition for ending a mindfulness session"

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/MessageDefinition/end-session"
* date = "2024-03-19"
* status = #active
* eventCoding = $MsgEvents#mindfulness-msg-session-end "Session End"
* category = #notification
* focus.code = #Observation
* focus.min = 1
* focus.max = "*"
* focus.profile = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-observation"
