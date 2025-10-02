// Originally defined on lines 3 - 13
CodeSystem: PractitionerIdentifierCS
Id: practitioner-identifier-cs
Title: "Practitioner Identifier Code System"
Description: "Sistema de códigos para identificação de practitioners"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #npi "National Provider Identifier" "US National Provider Identifier"
* #crm "Conselho Regional de Medicina" "Brazilian Medical Council Registration"
* #ssin "Social Security Identification Number" "Belgian SSIN"
* #rpps "Répertoire Partagé des Professionnels de Santé" "French Healthcare Professional Registry"

// Originally defined on lines 15 - 21
ValueSet: PractitionerIdentifierVS
Id: practitioner-identifier-vs
Title: "Practitioner Identifier Value Set"
Description: "Value set para identificadores de practitioners"
* ^status = #active
* ^experimental = false
* include codes from system PractitionerIdentifierCS

