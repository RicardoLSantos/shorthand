// ============================================================================
// Concept Property Definitions — MERGED into AppLogicCS (Phase 4, 2026-02-27)
// ============================================================================
// The 4 concept property codes (loinc-equivalent, assignment-status,
// snomed-equivalent, openehr-path) were merged into AppLogicCS Category E.
// This file retains only the AssignmentStatusVS.

ValueSet: AssignmentStatusVS
Id: assignment-status-vs
Title: "Assignment Status ValueSet"
Description: "Valid values for the assignment-status concept property"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/assignment-status-vs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* AppLogicCS#mapped "Mapped"
* AppLogicCS#pending-loinc "Pending LOINC Assignment"
* AppLogicCS#pending-snomed "Pending SNOMED CT Assignment"
* AppLogicCS#local-only "Local Only"
* AppLogicCS#deprecated "Deprecated"
