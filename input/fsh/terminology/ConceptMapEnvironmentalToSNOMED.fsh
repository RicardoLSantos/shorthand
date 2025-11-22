// Operational ConceptMap: Environmental Exposure Custom Codes → SNOMED CT
// Created: 2025-11-22
// Purpose: Enable $translate operations for environmental exposure terminology
// Status: Maps environmental noise and UV exposure codes

Instance: ConceptMapEnvironmentalToSNOMED
InstanceOf: ConceptMap
Title: "Environmental Exposures to SNOMED CT Mapping"
Description: "Maps custom environmental exposure measurement codes to SNOMED CT codes where available. Enables interoperability between environmental monitoring devices (Apple Watch noise monitoring, UV sensors) and clinical systems."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapEnvironmentalToSNOMED"
* version = "0.1.0"
* name = "ConceptMapEnvironmentalToSNOMED"
* title = "Environmental Exposures to SNOMED CT Mapping"
* status = #active
* experimental = false
* date = "2025-11-22"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* description = "Operational ConceptMap for environmental exposure terminology translation. Enables runtime $translate operations for semantic interoperability between environmental monitoring wearables and SNOMED CT standard terminology."
* purpose = "Provides semantic mappings from custom environmental exposure codes to standard SNOMED CT codes. Consumer wearables increasingly monitor environmental factors (noise, UV radiation) but lack standardized clinical terminology."

* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/lifestyle-observation-vs"
* targetCanonical = "http://hl7.org/fhir/ValueSet/all-snomed-ct"

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* group[0].target = "http://snomed.info/sct"

// ENVIRONMENTAL NOISE - NEEDS VERIFICATION ⚠️
* group[0].element[0].code = #noise-avg
* group[0].element[0].display = "Environmental noise average level"
* group[0].element[0].target[0].code = #60156001
* group[0].element[0].target[0].display = "Noise (physical force)"
* group[0].element[0].target[0].equivalence = #narrower
* group[0].element[0].target[0].comment = "Environmental noise average maps to broader SNOMED 'Noise' concept. Source is specific to average noise level over time (dB measurement), target is general noise concept. Code 60156001 should be verified."

// UV INDEX - NEEDS VERIFICATION ⚠️
* group[0].element[1].code = #uv-index
* group[0].element[1].display = "UV index"
* group[0].element[1].target[0].code = #41355003
* group[0].element[1].target[0].display = "Ultraviolet radiation (physical force)"
* group[0].element[1].target[0].equivalence = #narrower
* group[0].element[1].target[0].comment = "UV index measurement maps to broader SNOMED 'Ultraviolet radiation' concept. Source is specific UV index scale (0-11+), target is general UV radiation. Code 41355003 should be verified."

// UV EXPOSURE DURATION - NO EXACT MATCH ⚠️
* group[0].element[2].code = #uv-duration
* group[0].element[2].display = "UV exposure duration"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "No specific SNOMED CT code for UV exposure duration as of November 2025. SNOMED has UV radiation concept but not time-based exposure measurement."

// NOISE EXPOSURE DURATION - NO EXACT MATCH ⚠️
* group[0].element[3].code = #noise-duration
* group[0].element[3].display = "Environmental noise exposure duration"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "No specific SNOMED CT code for noise exposure duration as of November 2025. Occupational health codes may exist but consumer environmental monitoring is not well represented."
