// ====== CodeSystem para Identificadores de Practitioners ======

// PractitionerIdentifierCS — MERGED into AppLogicCS Category E (Phase 4, 2026-02-27)
// 4 codes (npi, crm, ssin, rpps) now in AppLogicCS

ValueSet: PractitionerIdentifierVS
Id: practitioner-identifier-vs
Title: "Practitioner Identifier Value Set"
Description: "Value set para identificadores de practitioners"
* ^status = #active
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^experimental = false
* AppLogicCS#npi "National Provider Identifier"
* AppLogicCS#crm "Conselho Regional de Medicina"
* AppLogicCS#ssin "Social Security Identification Number"
* AppLogicCS#rpps "Répertoire Partagé des Professionnels de Santé"
