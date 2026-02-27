// Aliases for CodeSystems
Alias: $AuditLevels = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs
Alias: $AuditFormats = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs

Extension: MindfulnessAuditLevel
Id: mindfulness-audit-level
Title: "Mindfulness Audit Level"
Description: "Level of detail for audit records"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only code
* valueCode from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-levels (extensible)

Extension: MindfulnessAuditRetention
Id: mindfulness-audit-retention
Title: "Mindfulness Audit Retention"
Description: "Period to retain audit records"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only Duration

Extension: MindfulnessAuditFormat
Id: mindfulness-audit-format
Title: "Mindfulness Audit Format"
Description: "Format for audit records"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only code
* valueCode from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-formats (extensible)

Profile: MindfulnessAuditConfig
Parent: Basic
Id: mindfulness-audit-config
Title: "Mindfulness Audit Configuration"
Description: "Configuration for mindfulness session auditing"

* code 1..1 MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mindfulness-config-audit "Audit Configuration"

* extension contains
    MindfulnessAuditLevel named auditLevel 1..1 MS and
    MindfulnessAuditRetention named auditRetention 1..1 MS and
    MindfulnessAuditFormat named auditFormat 1..1 MS

Instance: DefaultAuditConfig
InstanceOf: MindfulnessAuditConfig
Title: "Default Audit Configuration"
Description: "Default configuration for mindfulness session auditing"

* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mindfulness-config-audit "Audit Configuration"
* extension[auditLevel].valueCode = $AuditLevels#audit-levels-high
* extension[auditRetention].valueDuration = 90 'days'
* extension[auditFormat].valueCode = $AuditFormats#structured
