// ====== CodeSystem para Identificadores de Practitioners ======

CodeSystem: PractitionerIdentifierCS
Id: practitioner-identifier-cs
Title: "Practitioner Identifier Code System"
Description: "Sistema de códigos para identificação de practitioners"
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
* ^caseSensitive = true
* #npi "National Provider Identifier" "US National Provider Identifier"
* #crm "Conselho Regional de Medicina" "Brazilian Medical Council Registration"
* #ssin "Social Security Identification Number" "Belgian SSIN"
* #rpps "Répertoire Partagé des Professionnels de Santé" "French Healthcare Professional Registry"

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
* include codes from system PractitionerIdentifierCS
