Instance: MindfulnessSessionMessage
InstanceOf: MessageDefinition
Usage: #definition
Title: "Mindfulness Session Message Definition"
Description: "Message structure for transmitting mindfulness session data"

* status = #draft
* date = "2024-03-19"
* eventCoding = #mindfulness-session "Mindfulness Session Completed"
* category = #notification
* focus = #Observation

* response.message = Canonical(MindfulnessSessionResponse)
* allowedResponse = Reference(MindfulnessSessionResponse)

* parent = "http://example.org/MessageDefinition/base-message"
* replaces = "http://example.org/MessageDefinition/mindfulness-session-1.0.0"

* extension[0].url = "http://example.org/StructureDefinition/message-version"
* extension[0].valueString = "2.0.0"

Instance: MindfulnessSessionResponse
InstanceOf: MessageDefinition
Usage: #definition
Title: "Mindfulness Session Response Message"
Description: "Response message for mindfulness session data transmission"

* status = #draft
* date = "2024-03-19"
* eventCoding = #mindfulness-session-response "Mindfulness Session Response"
* category = #consequence
* focus = #OperationOutcome

* response.message = Canonical(MindfulnessSessionMessage)
* allowedResponse = Reference(MindfulnessSessionMessage)

Instance: MindfulnessMessageBundle
InstanceOf: Bundle
Usage: #example
Title: "Example Mindfulness Session Message Bundle"

* type = #message
* timestamp = "2024-03-19T10:00:00Z"
* entry[0].resource = MindfulnessSessionMessage
* entry[1].resource = CompleteMindfulnessSession

Extension: MessageMetadata
Id: message-metadata
Title: "Message Metadata Extension"
Description: "Additional metadata for mindfulness messages"

* ^url = "http://example.org/StructureDefinition/message-metadata"
* ^context.type = #element
* ^context.expression = "MessageHeader"

* extension contains
    version 1..1 and
    source 1..1 and
    priority 0..1

* extension[version].value[x] only string
* extension[source].value[x] only string
* extension[priority].value[x] only code
* extension[priority].valueCode from MessagePriorityVS (required)
