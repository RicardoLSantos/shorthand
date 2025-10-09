// Originally defined on lines 1 - 9
ValueSet: AuditLevelsValueSet
Id: audit-levels
Title: "Audit Levels Value Set"
Description: "Value set for audit level types"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-levels"
* ^status = #active
* ^date = "2024-12-27"
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/audit-levels

// Originally defined on lines 11 - 21
CodeSystem: AuditLevelsCodeSystem
Id: audit-levels
Title: "Audit Levels Code System"
Description: "Code system for audit level types"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/audit-levels"
* ^status = #active
* ^caseSensitive = true
* #low "Low Level"
* #medium "Medium Level"
* #high "High Level"

