// Aliases for CodeSystems
Alias: $AuditLevels = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs
Alias: $AuditFormats = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs

Extension: AuditLevelExtension
Id: audit-level
Title: "Audit Level Extension"
Description: "Level of detail for audit records"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only code
* valueCode from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-levels (required)

Extension: AuditRetentionExtension
Id: audit-retention
Title: "Audit Retention Extension"
Description: "Period to retain audit records"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only Duration

Extension: AuditFormatExtension
Id: audit-format
Title: "Audit Format Extension"
Description: "Format for audit records"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only code
* valueCode from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-formats (required)

Profile: MindfulnessAudit
Parent: Basic
Id: mindfulness-audit
Title: "Mindfulness Audit"
Description: "Audit record for mindfulness sessions"

* code 1..1 MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mindfulness-audit-session "Session Audit"
* created 1..1 MS

* extension contains
    audit-level named auditLevel 1..1 MS and
    audit-retention named auditRetention 1..1 MS and
    audit-format named auditFormat 1..1 MS

Instance: MindfulnessAuditExample
InstanceOf: MindfulnessAudit
Title: "Example Mindfulness Audit"
Description: "Example of a mindfulness session audit record"

* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mindfulness-audit-session "Session Audit"
* created = "2024-03-15"
* extension[auditLevel].valueCode = $AuditLevels#audit-levels-high
* extension[auditRetention].valueDuration = 90 'days'
* extension[auditFormat].valueCode = $AuditFormats#structured
