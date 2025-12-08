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

// GAIT ASSESSMENT - CORRECTED 2025-12-08 ⚠️
// WRONG CODE FOUND: 271706000 = "Waddling gait" NOT "Gait, function"
// Using #unmatched until correct gait assessment code verified
* group[0].element[0].code = #gait-assessment
* group[0].element[0].display = "Gait assessment"
* group[0].element[0].target[0].equivalence = #unmatched
* group[0].element[0].target[0].comment = "CORRECTED 2025-12-08: Original code 271706000 was WRONG - it means 'Waddling gait' (a pathological finding) NOT 'Gait function'. No verified SNOMED code for general gait assessment available in Australian Ontoserver. Requires manual verification via browser.ihtsdotools.org."

// BALANCE ASSESSMENT - CORRECTED 2025-12-08 ⚠️
// Code 271722003 NOT FOUND in Australian Ontoserver
* group[0].element[1].code = #balance-assessment
* group[0].element[1].display = "Balance assessment"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = "CORRECTED 2025-12-08: Original code 271722003 NOT FOUND in Australian Ontoserver. No verified SNOMED code for balance assessment. Requires manual verification via browser.ihtsdotools.org for International edition."

// WALKING STEADINESS - CORRECTED 2025-12-08 ⚠️
// Code 271722003 NOT FOUND in Australian Ontoserver
* group[0].element[2].code = #walking-steadiness
* group[0].element[2].display = "Walking steadiness measurement"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "CORRECTED 2025-12-08: Walking steadiness (Apple Watch metric) has no verified SNOMED equivalent. Original code 271722003 NOT FOUND. This is a proprietary wearable metric from accelerometer/gyroscope during walking."

// WALKING SPEED - CORRECTED 2025-12-08 ⚠️
// Code 249869000 NOT FOUND in Australian Ontoserver
* group[0].element[3].code = #walking-speed
* group[0].element[3].display = "Walking speed measurement"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "CORRECTED 2025-12-08: Original code 249869000 NOT FOUND in Australian Ontoserver. Walking speed is clinically important for mobility assessment but no verified SNOMED code available. Requires manual verification via browser.ihtsdotools.org."

// MOVEMENT ASSESSMENT - CORRECTED 2025-12-08 ⚠️
// Code 364555000 NOT FOUND in Australian Ontoserver
* group[0].element[4].code = #movement-assessment
* group[0].element[4].display = "Movement assessment"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "CORRECTED 2025-12-08: Original code 364555000 NOT FOUND in Australian Ontoserver. No verified SNOMED code for movement quality. Requires manual verification via browser.ihtsdotools.org."
