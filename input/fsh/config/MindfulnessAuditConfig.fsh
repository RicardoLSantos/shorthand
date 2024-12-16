Profile: MindfulnessAuditConfig
Parent: Basic
Id: mindfulness-audit-config
Title: "Mindfulness Audit Configuration"
Description: "Configuration for mindfulness session auditing"

* code 1..1 MS
* code = http://example.org/CodeSystem/mindfulness-config-type#audit "Audit Configuration"

* extension contains
    auditLevel 1..1 MS and
    auditRetention 1..1 MS and
    auditFormat 1..1 MS

Extension: AuditLevel
Id: audit-level
Title: "Audit Level"
Description: "Level of detail for audit records"
* value[x] only code
* valueCode from http://example.org/fhir/ValueSet/audit-levels (required)

Extension: AuditRetention
Id: audit-retention
Title: "Audit Retention"
Description: "Period to retain audit records"
* value[x] only Duration

Extension: AuditFormat
Id: audit-format
Title: "Audit Format"
Description: "Format for audit records"
* value[x] only code
* valueCode from http://example.org/fhir/ValueSet/audit-formats (required)

Instance: DefaultAuditConfig
InstanceOf: MindfulnessAuditConfig
Title: "Default Audit Configuration"
Description: "Default configuration for mindfulness session auditing"

* code = http://example.org/CodeSystem/mindfulness-config-type#audit "Audit Configuration"
* extension[auditLevel].valueCode = #detailed
* extension[auditRetention].valueDuration = 90 'days'
* extension[auditFormat].valueCode = #fhir

