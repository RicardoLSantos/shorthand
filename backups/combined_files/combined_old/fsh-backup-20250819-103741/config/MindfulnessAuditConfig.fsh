Extension: MindfulnessAuditLevel
Id: mindfulness-audit-level
Title: "Mindfulness Audit Level"
Description: "Level of detail for audit records"
* value[x] only code
* valueCode from http://example.org/fhir/ValueSet/audit-levels (required)

Extension: MindfulnessAuditRetention
Id: mindfulness-audit-retention
Title: "Mindfulness Audit Retention"
Description: "Period to retain audit records"
* value[x] only Duration

Extension: MindfulnessAuditFormat
Id: mindfulness-audit-format
Title: "Mindfulness Audit Format"
Description: "Format for audit records"
* value[x] only code
* valueCode from http://example.org/fhir/ValueSet/audit-formats (required)

Profile: MindfulnessAuditConfig
Parent: Basic
Id: mindfulness-audit-config
Title: "Mindfulness Audit Configuration"
Description: "Configuration for mindfulness session auditing"

* code 1..1 MS
* code = http://example.org/CodeSystem/mindfulness-config-type#audit "Audit Configuration"

* extension contains
    MindfulnessAuditLevel named auditLevel 1..1 MS and
    MindfulnessAuditRetention named auditRetention 1..1 MS and
    MindfulnessAuditFormat named auditFormat 1..1 MS

Instance: DefaultAuditConfig
InstanceOf: MindfulnessAuditConfig
Title: "Default Audit Configuration"
Description: "Default configuration for mindfulness session auditing"

* code = http://example.org/CodeSystem/mindfulness-config-type#audit "Audit Configuration"
* extension[auditLevel].valueCode = #detailed
* extension[auditRetention].valueDuration = 90 'days'
* extension[auditFormat].valueCode = #fhir
