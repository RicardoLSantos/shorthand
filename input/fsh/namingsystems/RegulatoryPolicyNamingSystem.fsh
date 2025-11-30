// ============================================================================
// Regulatory Policy NamingSystem
// ============================================================================
// Purpose: Formally register URN namespaces for regulatory policy references
// Created: 2025-11-30
// HL7 FHIR Conformance: Provides formal registration for Consent.policy.uri values
//
// References:
// - HL7 FHIR NamingSystem: https://hl7.org/fhir/R4/namingsystem.html
// - GDPR: https://eur-lex.europa.eu/eli/reg/2016/679/oj
// - HIPAA: https://www.hhs.gov/hipaa/index.html
// - LGPD: http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm

Instance: RegulatoryPolicyNamingSystem
InstanceOf: NamingSystem
Usage: #definition
Title: "Regulatory Policy URI Naming System"
Description: "NamingSystem defining URN patterns for healthcare regulatory policy references used in Consent resources"

* name = "RegulatoryPolicyURN"
* status = #active
* kind = #identifier
* date = "2025-11-30"
* publisher = "iOS Lifestyle Medicine HEADS FHIR IG"
* contact.name = "Ricardo L. Santos"
* responsible = "iOS Lifestyle Medicine HEADS FHIR IG"
* type = http://terminology.hl7.org/CodeSystem/v2-0203#FILL "Filler Identifier"
* description = "URN namespace for healthcare regulatory framework policy references. These URNs provide stable identifiers for regulatory policies that may have changing URLs."
* jurisdiction = urn:iso:std:iso:3166#PT "Portugal"

* usage = "Use these URNs in Consent.policy.uri to reference specific regulatory frameworks. The URN format is: urn:{region}:{regulation}:{year}[:{section}]"

// GDPR URN
* uniqueId[0].type = #uri
* uniqueId[=].value = "urn:eu:gdpr:2016:679"
* uniqueId[=].preferred = true
* uniqueId[=].comment = "EU General Data Protection Regulation (GDPR) - Regulation 2016/679"

// HIPAA Privacy URN
* uniqueId[+].type = #uri
* uniqueId[=].value = "urn:us:hipaa:privacy"
* uniqueId[=].preferred = false
* uniqueId[=].comment = "US Health Insurance Portability and Accountability Act - Privacy Rule"

// HIPAA Security URN
* uniqueId[+].type = #uri
* uniqueId[=].value = "urn:us:hipaa:security"
* uniqueId[=].preferred = false
* uniqueId[=].comment = "US Health Insurance Portability and Accountability Act - Security Rule"

// LGPD URN
* uniqueId[+].type = #uri
* uniqueId[=].value = "urn:br:lgpd:2018"
* uniqueId[=].preferred = false
* uniqueId[=].comment = "Brazilian General Data Protection Law (LGPD) - Lei 13.709/2018"

// PIPEDA URN
* uniqueId[+].type = #uri
* uniqueId[=].value = "urn:ca:pipeda:2000"
* uniqueId[=].preferred = false
* uniqueId[=].comment = "Canadian Personal Information Protection and Electronic Documents Act"

// EHDS URN
* uniqueId[+].type = #uri
* uniqueId[=].value = "urn:eu:ehds:2022"
* uniqueId[=].preferred = false
* uniqueId[=].comment = "European Health Data Space Regulation"


// ============================================================================
// Regulatory Authority NamingSystem
// ============================================================================

Instance: RegulatoryAuthorityNamingSystem
InstanceOf: NamingSystem
Usage: #definition
Title: "Regulatory Authority OID Naming System"
Description: "NamingSystem defining OIDs for healthcare regulatory authorities used in Consent.policy.authority"

* name = "RegulatoryAuthorityOID"
* status = #active
* kind = #identifier
* date = "2025-11-30"
* publisher = "iOS Lifestyle Medicine HEADS FHIR IG"
* contact.name = "Ricardo L. Santos"
* responsible = "iOS Lifestyle Medicine HEADS FHIR IG"
* type = http://terminology.hl7.org/CodeSystem/v2-0203#FILL "Filler Identifier"
* description = "OID namespace for healthcare regulatory authority identifiers"
* jurisdiction = urn:iso:std:iso:3166#PT "Portugal"

* usage = "Use these OIDs in Consent.policy.authority to identify the regulatory authority"

// EU Data Protection Authority (placeholder OID)
* uniqueId[0].type = #oid
* uniqueId[=].value = "2.16.840.1.113883.3.4.5.1"
* uniqueId[=].preferred = true
* uniqueId[=].comment = "European Data Protection Board (EDPB)"

// US HHS Authority
* uniqueId[+].type = #oid
* uniqueId[=].value = "2.16.840.1.113883.3.4.5.2"
* uniqueId[=].preferred = false
* uniqueId[=].comment = "US Department of Health and Human Services (HHS)"

// Brazil ANPD Authority
* uniqueId[+].type = #oid
* uniqueId[=].value = "2.16.840.1.113883.3.4.5.3"
* uniqueId[=].preferred = false
* uniqueId[=].comment = "Brazil National Data Protection Authority (ANPD)"
