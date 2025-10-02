// Originally defined on lines 1 - 6
Extension: MindfulnessAuditLevel
Parent: Extension
Id: mindfulness-audit-level
Title: "Mindfulness Audit Level"
Description: "Level of detail for audit records"
* value[x] only code
* valueCode from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-levels (required)
* extension 0..0

// Originally defined on lines 8 - 12
Extension: MindfulnessAuditRetention
Parent: Extension
Id: mindfulness-audit-retention
Title: "Mindfulness Audit Retention"
Description: "Period to retain audit records"
* value[x] only Duration
* extension 0..0

// Originally defined on lines 14 - 19
Extension: MindfulnessAuditFormat
Parent: Extension
Id: mindfulness-audit-format
Title: "Mindfulness Audit Format"
Description: "Format for audit records"
* value[x] only code
* valueCode from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-formats (required)
* extension 0..0

// Originally defined on lines 21 - 33
Profile: MindfulnessAuditConfig
Parent: Basic
Id: mindfulness-audit-config
Title: "Mindfulness Audit Configuration"
Description: "Configuration for mindfulness session auditing"
* code 1..1
* code MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-config-type#audit "Audit Configuration"
* extension contains
    MindfulnessAuditLevel named auditLevel 0.. and
    MindfulnessAuditRetention named auditRetention 0.. and
    MindfulnessAuditFormat named auditFormat 0..
* extension[auditLevel] 1..1
* extension[auditLevel] MS
* extension[auditRetention] 1..1
* extension[auditRetention] MS
* extension[auditFormat] 1..1
* extension[auditFormat] MS

// Originally defined on lines 35 - 43
Instance: DefaultAuditConfig
InstanceOf: MindfulnessAuditConfig
Title: "Default Audit Configuration"
Description: "Default configuration for mindfulness session auditing"
Usage: #example
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-config-type#audit "Audit Configuration"
* extension[auditLevel].valueCode = #detailed
* extension[auditRetention].valueDuration = 90 'days'
* extension[auditFormat].valueCode = #fhir

