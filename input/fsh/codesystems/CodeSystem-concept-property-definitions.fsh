// ============================================================================
// Concept Property Definitions CodeSystem
// ============================================================================
// Purpose: Formally define custom concept properties used across this IG
// Created: 2025-11-30
// HL7 FHIR Conformance: Provides formal URIs for CodeSystem.property references
//
// References:
// - HL7 FHIR CodeSystem Property: https://hl7.org/fhir/R4/codesystem-definitions.html#CodeSystem.property
// - FHIR Concept Properties: http://hl7.org/fhir/concept-properties

CodeSystem: ConceptPropertyDefinitionsCS
Id: concept-property-definitions-cs
Title: "Concept Property Definitions CodeSystem"
Description: "Formal definitions for custom concept properties used in this Implementation Guide. These properties extend standard FHIR concept properties to support terminology mapping and lifecycle tracking for wearable health data concepts."
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/concept-property-definitions-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-30"
* ^publisher = "iOS Lifestyle Medicine HEADS FHIR IG"
* ^contact.name = "Ricardo L. Santos"
* ^caseSensitive = true
* ^content = #complete
* ^count = 4

// Property for LOINC code equivalence
* #loinc-equivalent "LOINC Equivalent Code"
    "Reference to an equivalent LOINC code for this concept. Used to map custom codes to LOINC when available, supporting semantic interoperability with systems that use LOINC as primary terminology."

// Property for terminology assignment status
* #assignment-status "Terminology Assignment Status"
    "Status of the terminology code assignment process. Values include: 'mapped' (has equivalent in standard terminology), 'pending-loinc' (awaiting LOINC code assignment), 'pending-snomed' (awaiting SNOMED CT assignment), 'local-only' (intentionally local, no standard equivalent expected)."

// Property for SNOMED CT equivalence
* #snomed-equivalent "SNOMED CT Equivalent Code"
    "Reference to an equivalent SNOMED CT concept for this code. Used to map custom codes to SNOMED CT when available."

// Property for openEHR archetype mapping
* #openehr-path "openEHR Archetype Path"
    "Path to the equivalent element in an openEHR archetype. Supports mapping between FHIR and openEHR representations of the same clinical concept."


// ============================================================================
// ValueSet for Assignment Status values
// ============================================================================

ValueSet: AssignmentStatusVS
Id: assignment-status-vs
Title: "Assignment Status ValueSet"
Description: "Valid values for the assignment-status concept property"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/assignment-status-vs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* include codes from system AssignmentStatusCS


CodeSystem: AssignmentStatusCS
Id: assignment-status-cs
Title: "Assignment Status CodeSystem"
Description: "Status values for terminology code assignment tracking"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/assignment-status-cs"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #mapped "Mapped"
    "This concept has been mapped to an equivalent code in a standard terminology (LOINC, SNOMED CT, etc.)"

* #pending-loinc "Pending LOINC Assignment"
    "This concept is awaiting assignment of a LOINC code. A submission may be in progress or planned."

* #pending-snomed "Pending SNOMED CT Assignment"
    "This concept is awaiting assignment of a SNOMED CT concept identifier."

* #local-only "Local Only"
    "This concept is intentionally local and no standard terminology equivalent is expected or needed."

* #deprecated "Deprecated"
    "This concept has been deprecated. A replacement concept may be available in the standard terminology."
