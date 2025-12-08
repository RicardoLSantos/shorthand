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

// ARCHITECTURE NOTE (2025-11-25): Removed sourceCanonical/targetCanonical
// See design-decisions.md for rationale. Source validation via group.source CodeSystem.

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* group[0].target = "http://snomed.info/sct"

// ============================================================================
// ENVIRONMENTAL NOISE - CODE NOT FOUND ❌
// CORRECTED 2025-12-08: 60156001 does NOT exist in SNOMED CT (verified via Ontoserver AU)
// ============================================================================
* group[0].element[0].code = #noise-avg
* group[0].element[0].display = "Environmental noise average level"
* group[0].element[0].target[0].equivalence = #unmatched
* group[0].element[0].target[0].comment = "GAP: SNOMED CT code 60156001 does NOT exist (verified 2025-12-08 via Ontoserver AU). No standard code for environmental noise measurement. Consumer wearables (Apple Watch, Garmin) track dB levels but no clinical terminology exists."

// ============================================================================
// UV INDEX - VERIFIED ✅
// 41355003 = "Ultraviolet radiation" (verified 2025-12-08 via Ontoserver AU)
// ============================================================================
* group[0].element[1].code = #uv-index
* group[0].element[1].display = "UV index"
* group[0].element[1].target[0].code = #41355003
* group[0].element[1].target[0].display = "Ultraviolet radiation"
* group[0].element[1].target[0].equivalence = #narrower
* group[0].element[1].target[0].comment = "VERIFIED 2025-12-08 via Ontoserver AU: 41355003 = Ultraviolet radiation. UV index scale (0-11+) maps to broader UV radiation concept."

// ============================================================================
// UV EXPOSURE DURATION - GAP DOCUMENTED ❌
// No SNOMED CT code exists (verified 2025-12-08)
// ============================================================================
* group[0].element[2].code = #uv-duration
* group[0].element[2].display = "UV exposure duration"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "GAP: No SNOMED CT code for UV exposure duration (verified 2025-12-08). SNOMED has UV radiation concept (41355003) but not time-based exposure measurement."

// ============================================================================
// NOISE EXPOSURE DURATION - GAP DOCUMENTED ❌
// No SNOMED CT code exists (verified 2025-12-08)
// ============================================================================
* group[0].element[3].code = #noise-duration
* group[0].element[3].display = "Environmental noise exposure duration"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "GAP: No SNOMED CT code for noise exposure duration (verified 2025-12-08). Occupational health codes may exist but consumer environmental monitoring is not represented in SNOMED CT."
