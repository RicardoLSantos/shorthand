ValueSet: AuditFormatsValueSet
Id: audit-formats
Title: "Audit Formats Value Set"
Description: "Value set for audit format types"
* ^url = "http://example.org/fhir/ValueSet/audit-formats"
* ^status = #active
* ^experimental = false
* ^date = "2024-12-27"
* include codes from system http://example.org/fhir/CodeSystem/audit-formats

CodeSystem: AuditFormatsCodeSystem
Id: audit-formats
Title: "Audit Formats Code System"
Description: "Code system for audit format types"
* ^url = "http://example.org/fhir/CodeSystem/audit-formats"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #text "Text Format"
* #structured "Structured Format"
* #mixed "Mixed Format"
