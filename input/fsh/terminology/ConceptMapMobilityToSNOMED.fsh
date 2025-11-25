// Operational ConceptMap: Mobility Custom Codes → SNOMED CT
// Created: 2025-11-22
// Purpose: Enable $translate operations for mobility assessment terminology
// Status: Maps mobility and gait assessment codes to SNOMED

Instance: ConceptMapMobilityToSNOMED
InstanceOf: ConceptMap
Title: "Mobility Assessments to SNOMED CT Mapping"
Description: "Maps custom mobility and gait assessment codes to SNOMED CT codes where available. Enables interoperability between mobility monitoring devices (Apple Watch walking steadiness, gait analysis tools) and clinical systems."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapMobilityToSNOMED"
* version = "0.1.0"
* name = "ConceptMapMobilityToSNOMED"
* title = "Mobility Assessments to SNOMED CT Mapping"
* status = #active
* experimental = false
* date = "2025-11-22"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* description = "Operational ConceptMap for mobility assessment terminology translation. Enables runtime $translate operations for semantic interoperability between consumer mobility monitoring wearables and SNOMED CT standard terminology."
* purpose = "Provides semantic mappings from custom mobility assessment codes to standard SNOMED CT codes. Consumer wearables (Apple Watch, Garmin) increasingly provide gait analysis and mobility assessments but use proprietary terminology."

// ARCHITECTURE NOTE (2025-11-25): Removed sourceCanonical/targetCanonical
// See design-decisions.md for rationale. Source validation via group.source CodeSystem.

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* group[0].target = "http://snomed.info/sct"

// GAIT ASSESSMENT - NEEDS VERIFICATION ⚠️
* group[0].element[0].code = #gait-assessment
* group[0].element[0].display = "Gait assessment"
* group[0].element[0].target[0].code = #271706000
* group[0].element[0].target[0].display = "Gait, function (observable entity)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "Gait assessment maps to SNOMED 'Gait, function' observable entity. Code 271706000 should be verified via SNOMED CT Browser."

// BALANCE ASSESSMENT - NEEDS VERIFICATION ⚠️
* group[0].element[1].code = #balance-assessment
* group[0].element[1].display = "Balance assessment"
* group[0].element[1].target[0].code = #271722003
* group[0].element[1].target[0].display = "Balance (observable entity)"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[1].target[0].comment = "Balance assessment maps to SNOMED 'Balance' observable entity. Code 271722003 should be verified."

// WALKING STEADINESS - NO EXACT MATCH ⚠️
* group[0].element[2].code = #walking-steadiness
* group[0].element[2].display = "Walking steadiness measurement"
* group[0].element[2].target[0].code = #271722003
* group[0].element[2].target[0].display = "Balance (observable entity)"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[2].target[0].comment = "Walking steadiness (Apple Watch metric) maps to broader SNOMED 'Balance' concept. Source is specific algorithmic measurement from accelerometer/gyroscope during walking, target is general balance concept. No exact SNOMED match for 'walking steadiness' consumer metric."

// WALKING SPEED - NEEDS VERIFICATION ⚠️
* group[0].element[3].code = #walking-speed
* group[0].element[3].display = "Walking speed measurement"
* group[0].element[3].target[0].code = #249869000
* group[0].element[3].target[0].display = "Walking speed (observable entity)"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[3].target[0].comment = "Walking speed maps directly to SNOMED 'Walking speed' observable entity. Code 249869000 should be verified."

// MOVEMENT ASSESSMENT - NEEDS VERIFICATION ⚠️
* group[0].element[4].code = #movement-assessment
* group[0].element[4].display = "Movement assessment"
* group[0].element[4].target[0].code = #364555000
* group[0].element[4].target[0].display = "Movement quality (observable entity)"
* group[0].element[4].target[0].equivalence = #equivalent
* group[0].element[4].target[0].comment = "Movement assessment maps to SNOMED 'Movement quality' observable entity. Code 364555000 should be verified."
