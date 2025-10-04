// Originally defined on lines 1 - 9
ValueSet: AuditFormatsValueSet
Id: audit-formats
Title: "Audit Formats Value Set"
Description: "Value set for audit format types"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audit-formats"
* ^status = #active
* ^date = "2024-12-27"
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/audit-formats

// Originally defined on lines 11 - 21
CodeSystem: AuditFormatsCodeSystem
Id: audit-formats
Title: "Audit Formats Code System"
Description: "Code system for audit format types"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/audit-formats"
* ^status = #active
* ^caseSensitive = true
* #text "Text Format"
* #structured "Structured Format"
* #mixed "Mixed Format"

