// Operational ConceptMap: Mindfulness Custom Codes → SNOMED CT
// Created: 2025-11-22
// Purpose: Enable $translate operations for mindfulness terminology interoperability
// Status: Addresses terminology gap for mindfulness and meditation tracking

Instance: ConceptMapMindfulnessToSNOMED
InstanceOf: ConceptMap
Title: "Mindfulness Observations to SNOMED CT Mapping"
Description: "Maps custom mindfulness observation codes to SNOMED CT codes where available. Enables interoperability between mindfulness apps (Headspace, Calm, Apple Mindfulness Minutes) and clinical systems."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapMindfulnessToSNOMED"
* version = "0.1.0"
* name = "ConceptMapMindfulnessToSNOMED"
* title = "Mindfulness Observations to SNOMED CT Mapping"
* status = #active
* experimental = false
* date = "2025-11-22"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* description = "Operational ConceptMap for mindfulness observation terminology translation. Enables runtime $translate operations for semantic interoperability between mindfulness/meditation tracking applications and SNOMED CT standard terminology."
* purpose = "Provides semantic mappings from custom mindfulness observation codes to standard SNOMED CT codes. Mindfulness and meditation tracking is increasingly common in consumer health apps but lacks standardized clinical terminology."

* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/lifestyle-observation-vs"
* targetCanonical = "http://hl7.org/fhir/ValueSet/all-snomed-ct"

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* group[0].target = "http://snomed.info/sct"

// MINDFULNESS SESSION - NEEDS VERIFICATION ⚠️
* group[0].element[0].code = #mindfulness-session
* group[0].element[0].display = "Mindfulness practice session"
* group[0].element[0].target[0].code = #228432001
* group[0].element[0].target[0].display = "Meditation (regime/therapy)"
* group[0].element[0].target[0].equivalence = #wider
* group[0].element[0].target[0].comment = "Mindfulness session maps to broader SNOMED 'Meditation' concept. Mindfulness is a specific type of meditation practice. Code 228432001 should be verified via SNOMED CT Browser."

// RELAXATION RESPONSE - NEEDS VERIFICATION ⚠️
* group[0].element[1].code = #relaxation-response
* group[0].element[1].display = "Relaxation response observation"
* group[0].element[1].target[0].code = #398144009
* group[0].element[1].target[0].display = "Relaxation (observable entity)"
* group[0].element[1].target[0].equivalence = #related-to
* group[0].element[1].target[0].comment = "Relaxation response observation relates to SNOMED 'Relaxation' concept but measures subjective experience vs objective state. Code 398144009 should be verified."

// MINDFULNESS TYPE - NO EXACT MATCH ⚠️
* group[0].element[2].code = #mindfulness-type
* group[0].element[2].display = "Type of mindfulness practice"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "No specific SNOMED CT code for categorizing mindfulness practice types (breathing, body scan, loving-kindness, etc.) as of November 2025. SNOMED has general meditation/relaxation concepts but lacks granularity for mindfulness subtypes."
