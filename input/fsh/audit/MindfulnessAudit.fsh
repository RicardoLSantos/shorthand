Profile: MindfulnessAudit
Parent: Basic
Id: mindfulness-audit 
Title: "Mindfulness Audit"
Description: "Audit record for mindfulness sessions"

* code 1..1 MS
* code = http://example.org/CodeSystem/mindfulness-audit-type#session "Session Audit"
* created 1..1 MS

Instance: MindfulnessAuditExample
InstanceOf: MindfulnessAudit
Title: "Example Mindfulness Audit"
Description: "Example of a mindfulness session audit record"

* code = http://example.org/CodeSystem/mindfulness-audit-type#session "Session Audit"
* created = "2024-03-15"  // Corrigido formato da data
* extension[auditLevel].valueCode = #detailed
* extension[auditRetention].valueDuration = 90 'days'
* extension[auditFormat].valueCode = #fhir
