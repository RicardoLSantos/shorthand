// Originally defined on lines 1 - 6
Extension: AuditLevelExtension
Parent: Extension
Id: audit-level
Title: "Audit Level Extension"
Description: "Level of detail for audit records"
* value[x] only code
* valueCode from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-levels (required)
* extension 0..0

// Originally defined on lines 8 - 12
Extension: AuditRetentionExtension
Parent: Extension
Id: audit-retention
Title: "Audit Retention Extension"
Description: "Period to retain audit records"
* value[x] only Duration
* extension 0..0

// Originally defined on lines 14 - 19
Extension: AuditFormatExtension
Parent: Extension
Id: audit-format
Title: "Audit Format Extension"
Description: "Format for audit records"
* value[x] only code
* valueCode from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-formats (required)
* extension 0..0

// Originally defined on lines 21 - 34
Profile: MindfulnessAudit
Parent: Basic
Id: mindfulness-audit
Title: "Mindfulness Audit"
Description: "Audit record for mindfulness sessions"
* code 1..1
* code MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-audit-type#session "Session Audit"
* created 1..1
* created MS
* extension contains
    audit-level named auditLevel 0.. and
    audit-retention named auditRetention 0.. and
    audit-format named auditFormat 0..
* extension[auditLevel] 1..1
* extension[auditLevel] MS
* extension[auditRetention] 1..1
* extension[auditRetention] MS
* extension[auditFormat] 1..1
* extension[auditFormat] MS

// Originally defined on lines 36 - 45
Instance: MindfulnessAuditExample
InstanceOf: MindfulnessAudit
Title: "Example Mindfulness Audit"
Description: "Example of a mindfulness session audit record"
Usage: #example
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-audit-type#session "Session Audit"
* created = "2024-03-15"
* extension[auditLevel].valueCode = #detailed
* extension[auditRetention].valueDuration = 90 'days'
* extension[auditFormat].valueCode = #fhir

