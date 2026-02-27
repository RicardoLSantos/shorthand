// ====== Extensões de Compliance Multi-Jurisdicional ======

Extension: RegulatoryBasis
Id: regulatory-basis
Title: "Regulatory Basis for Consent"
Description: "Identifies the regulatory framework(s) that govern this consent"
* ^context[0].type = #element
* ^context[0].expression = "Consent"
* value[x] only CodeableConcept
* valueCodeableConcept from RegulatoryFrameworkVS (extensible)

Extension: JurisdictionApplicability
Id: jurisdiction-applicability
Title: "Jurisdiction Applicability"
Description: "Specifies which jurisdictions this consent applies to"
* ^context[0].type = #element
* ^context[0].expression = "Consent"
* value[x] only CodeableConcept
* valueCodeableConcept from http://hl7.org/fhir/ValueSet/jurisdiction (extensible)

Extension: DataLocalization
Id: data-localization
Title: "Data Localization Requirements"
Description: "Specifies data localization requirements per jurisdiction"
* ^context[0].type = #element
* ^context[0].expression = "Consent"
* extension contains
    jurisdiction 1..1 MS and
    storageLocation 1..1 MS and
    residencyRequired 1..1 MS
* extension[jurisdiction].value[x] only CodeableConcept
* extension[storageLocation].value[x] only string
* extension[residencyRequired].value[x] only boolean

// ====== ValueSets de Compliance ======

ValueSet: RegulatoryFrameworkVS
Id: regulatory-framework-vs
Title: "Regulatory Framework Value Set"
Description: "Regulatory frameworks for healthcare data protection"
* ^experimental = false
* AppLogicCS#gdpr "GDPR - General Data Protection Regulation"
* AppLogicCS#hipaa "HIPAA - Health Insurance Portability and Accountability Act"
* AppLogicCS#lgpd "LGPD - Lei Geral de Proteção de Dados"
* AppLogicCS#pipeda "PIPEDA - Personal Information Protection and Electronic Documents Act"
* AppLogicCS#ehds "EHDS - European Health Data Space"

// RegulatoryFrameworkCS — MERGED into AppLogicCS Category E (Phase 4, 2026-02-27)
// 5 codes (gdpr, hipaa, lgpd, pipeda, ehds) now in AppLogicCS
