Profile: MindfulnessAudit
Parent: AuditEvent
Id: mindfulness-audit
Title: "Mindfulness Audit Event"
Description: "Records mindfulness session audit events"

* type MS
* subtype MS
* action MS
* recorded MS
* outcome MS
* agent MS
* source MS
* entity MS

Instance: MindfulnessAuditExample
InstanceOf: MindfulnessAudit
Usage: #example
Title: "Example of Mindfulness Audit"
Description: "Shows how to record a mindfulness session audit event"

* type = http://terminology.hl7.org/CodeSystem/audit-event-type#rest "RESTful Operation"
* subtype = http://hl7.org/fhir/restful-interaction#create "create"
* action = #C
* recorded = "2024-03-15T09:49:00.000Z"
* outcome = #0
* agent[0].who = Reference(Device/example)
* agent[0].type = http://terminology.hl7.org/CodeSystem/extra-security-role-type#humanuser "human user"
* source.observer = Reference(Device/example)
* entity[0].what = Reference(MindfulnessSession/example)

