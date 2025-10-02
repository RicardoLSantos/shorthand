// Originally defined on lines 3 - 8
Extension: RegulatoryBasis
Parent: Extension
Id: regulatory-basis
Title: "Regulatory Basis for Consent"
Description: "Identifies the regulatory framework(s) that govern this consent"
* value[x] only CodeableConcept
* valueCodeableConcept from RegulatoryFrameworkVS (extensible)
* extension 0..0

// Originally defined on lines 10 - 15
Extension: JurisdictionApplicability
Parent: Extension
Id: jurisdiction-applicability
Title: "Jurisdiction Applicability"
Description: "Specifies which jurisdictions this consent applies to"
* value[x] only CodeableConcept
* valueCodeableConcept from http://hl7.org/fhir/ValueSet/jurisdiction (extensible)
* extension 0..0

// Originally defined on lines 17 - 27
Extension: DataLocalization
Parent: Extension
Id: data-localization
Title: "Data Localization Requirements"
Description: "Specifies data localization requirements per jurisdiction"
* extension contains
    jurisdiction 0.. and
    storageLocation 0.. and
    residencyRequired 0..
* extension[jurisdiction] 1..1
* extension[jurisdiction] MS
* extension[storageLocation] 1..1
* extension[storageLocation] MS
* extension[residencyRequired] 1..1
* extension[residencyRequired] MS
* extension[jurisdiction].value[x] only CodeableConcept
* extension[storageLocation].value[x] only string
* extension[residencyRequired].value[x] only boolean
* value[x] 0..0
* extension[jurisdiction].extension 0..0
* extension[storageLocation].extension 0..0
* extension[residencyRequired].extension 0..0

// Originally defined on lines 31 - 36
ValueSet: RegulatoryFrameworkVS
Id: regulatory-framework-vs
Title: "Regulatory Framework Value Set"
Description: "Regulatory frameworks for healthcare data protection"
* ^experimental = false
* include codes from system RegulatoryFrameworkCS

// Originally defined on lines 38 - 48
CodeSystem: RegulatoryFrameworkCS
Id: regulatory-framework-cs
Title: "Regulatory Framework Code System"
Description: "Codes for healthcare regulatory frameworks"
* ^experimental = false
* ^caseSensitive = true
* #gdpr "GDPR - General Data Protection Regulation" "European Union data protection regulation"
* #hipaa "HIPAA - Health Insurance Portability and Accountability Act" "United States healthcare privacy law"
* #lgpd "LGPD - Lei Geral de Proteção de Dados" "Brazilian general data protection law"
* #pipeda "PIPEDA - Personal Information Protection and Electronic Documents Act" "Canadian privacy law"
* #ehds "EHDS - European Health Data Space" "European health data framework"

