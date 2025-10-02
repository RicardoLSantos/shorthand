ValueSet: AuditLevelsValueSet
Id: audit-levels
Title: "Audit Levels Value Set"
Description: "Value set for audit level types"
* ^url = "https://2rdoc.pt/fhir/ValueSet/audit-levels"
* ^status = #active
* ^experimental = false
* ^date = "2024-12-27"
* include codes from system https://2rdoc.pt/fhir/CodeSystem/audit-levels

CodeSystem: AuditLevelsCodeSystem
Id: audit-levels
Title: "Audit Levels Code System"
Description: "Code system for audit level types"
* ^url = "https://2rdoc.pt/fhir/CodeSystem/audit-levels"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #low "Low Level"
* #medium "Medium Level"
* #high "High Level"
