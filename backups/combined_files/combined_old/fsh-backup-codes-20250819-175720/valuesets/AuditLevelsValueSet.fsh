ValueSet: AuditLevelsValueSet
Id: audit-levels
Title: "Audit Levels Value Set"
Description: "Value set for audit level types"
* ^url = "https://github.com/RicardoLSantos/shorthand/fhir/ValueSet/audit-levels"
* ^status = #active
* ^experimental = false
* ^date = "2024-12-27"
* include codes from system https://github.com/RicardoLSantos/shorthand/fhir/CodeSystem/audit-levels

CodeSystem: AuditLevelsCodeSystem
Id: audit-levels
Title: "Audit Levels Code System"
Description: "Code system for audit level types"
* ^url = "https://github.com/RicardoLSantos/shorthand/fhir/CodeSystem/audit-levels"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #low "Low Level"
* #medium "Medium Level"
* #high "High Level"
