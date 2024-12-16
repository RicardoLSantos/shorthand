Profile: MindfulnessAudit
Parent: Basic
Id: mindfulness-audit
Title: "Mindfulness Audit"
Description: "Records mindfulness session audit events"

* code 1..1 MS
* code = http://example.org/CodeSystem/mindfulness-audit-type#session "Mindfulness Session"
* subject 1..1 MS
* created 1..1 MS

* extension contains
    sessionStart 0..1 MS and
    sessionEnd 0..1 MS and 
    sessionDuration 1..1 MS

Instance: MindfulnessAuditExample
InstanceOf: MindfulnessAudit
Title: "Mindfulness Audit Example"
Description: "Example of a mindfulness session audit record"

* code = http://example.org/CodeSystem/mindfulness-audit-type#session "Mindfulness Session"
* subject = Reference(Patient/example)
* created = "2024-03-15T09:49:00Z"
* extension[sessionDuration].valueInteger = 20
* extension[sessionStart].valueDateTime = "2024-03-15T09:30:00Z"
* extension[sessionEnd].valueDateTime = "2024-03-15T09:50:00Z"

