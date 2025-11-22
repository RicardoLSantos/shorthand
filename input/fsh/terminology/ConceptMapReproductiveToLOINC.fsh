// Operational ConceptMap: Reproductive Health Custom Codes → LOINC
// Created: 2025-11-22
// Purpose: Enable $translate operations for reproductive health terminology
// Status: Maps ovulation status to LOINC codes

Instance: ConceptMapReproductiveToLOINC
InstanceOf: ConceptMap
Title: "Reproductive Health to LOINC Mapping"
Description: "Maps custom reproductive health observation codes to LOINC codes where available. Enables interoperability between fertility tracking apps (Apple Health, Clue, Flo) and clinical systems."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapReproductiveToLOINC"
* version = "0.1.0"
* name = "ConceptMapReproductiveToLOINC"
* title = "Reproductive Health to LOINC Mapping"
* status = #active
* experimental = false
* date = "2025-11-22"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* description = "Operational ConceptMap for reproductive health terminology translation. Enables runtime $translate operations for semantic interoperability between consumer fertility tracking applications and LOINC standard terminology."
* purpose = "Provides semantic mappings from custom reproductive health codes to standard LOINC codes. Consumer fertility tracking apps capture ovulation status, menstrual cycle data, but use proprietary coding systems."

* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/lifestyle-observation-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/loinc-observations-vs"

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* group[0].target = "http://loinc.org"

// OVULATION STATUS - NO EXACT LOINC CODE ⚠️
* group[0].element[0].code = #ovulation-status
* group[0].element[0].display = "Ovulation status"
* group[0].element[0].target[0].equivalence = #unmatched
* group[0].element[0].target[0].comment = "No direct LOINC code for consumer fertility device ovulation status as of November 2025. LOINC has laboratory ovulation predictor tests (e.g., LH surge tests) but not consumer device algorithmic ovulation predictions. Consumer apps use basal body temperature + symptom tracking algorithms. Terminology gap between laboratory ovulation testing and consumer fertility tracking."
