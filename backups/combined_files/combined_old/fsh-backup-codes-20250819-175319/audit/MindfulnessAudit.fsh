Extension: AuditLevelExtension
Id: audit-level
Title: "Audit Level Extension"
Description: "Level of detail for audit records"
* value[x] only code
* valueCode from https://github.com/RicardoLSantos/shorthand/fhir/ValueSet/audit-levels (required)

Extension: AuditRetentionExtension
Id: audit-retention
Title: "Audit Retention Extension" 
Description: "Period to retain audit records"
* value[x] only Duration

Extension: AuditFormatExtension
Id: audit-format
Title: "Audit Format Extension"
Description: "Format for audit records"
* value[x] only code
* valueCode from https://github.com/RicardoLSantos/shorthand/fhir/ValueSet/audit-formats (required)

Profile: MindfulnessAudit
Parent: Basic
Id: mindfulness-audit
Title: "Mindfulness Audit"
Description: "Audit record for mindfulness sessions"

* code 1..1 MS
* code = https://github.com/RicardoLSantos/shorthand/CodeSystem/mindfulness-audit-type#session "Session Audit"
* created 1..1 MS

* extension contains
    audit-level named auditLevel 1..1 MS and
    audit-retention named auditRetention 1..1 MS and
    audit-format named auditFormat 1..1 MS

Instance: MindfulnessAuditExample
InstanceOf: MindfulnessAudit
Title: "Example Mindfulness Audit"
Description: "Example of a mindfulness session audit record"

* code = https://github.com/RicardoLSantos/shorthand/CodeSystem/mindfulness-audit-type#session "Session Audit"
* created = "2024-03-15"
* extension[auditLevel].valueCode = #detailed
* extension[auditRetention].valueDuration = 90 'days'
* extension[auditFormat].valueCode = #fhir
