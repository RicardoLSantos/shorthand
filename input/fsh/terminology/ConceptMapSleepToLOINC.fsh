// Operational ConceptMap: Sleep Custom Codes → LOINC
// Created: 2025-11-22
// Updated: 2026-03-02 — Phase 6b: 4 GAP→EQUIVALENT corrections (103213-5, 93831-6, 93830-8, 103211-9)
// Purpose: Enable $translate operations for sleep measurement terminology interoperability
// Status: 4 of 5 mappings now have LOINC equivalents (only sleep-panel remains as narrower match)

Instance: ConceptMapSleepToLOINC
InstanceOf: ConceptMap
Title: "Sleep Measurements to LOINC Mapping"
Description: "Maps custom sleep measurement codes to LOINC codes where available, with migration path for future LOINC assignments. Enables interoperability between consumer sleep tracking devices (Apple HealthKit, Fitbit, Oura, etc.) and clinical systems."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapSleepToLOINC"
* version = "0.1.0"
* name = "ConceptMapSleepToLOINC"
* title = "Sleep Measurements to LOINC Mapping"
* status = #active
* experimental = false
* date = "2025-11-22"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* description = "Operational ConceptMap for sleep measurement terminology translation. Enables runtime $translate operations for semantic interoperability between consumer wearable device sleep data and LOINC standard terminology. Critical for integrating iOS Health App and other consumer sleep tracking platforms into EHR systems."
* purpose = "Provides semantic mappings from custom sleep measurement codes to standard LOINC codes. Sleep tracking from consumer devices (Apple Watch, Fitbit, Oura Ring, Garmin, etc.) uses proprietary measurements not fully covered by LOINC. This ConceptMap enables clinical decision support systems to interpret consumer sleep data using standardized terminology where available."

// CORRECTED STRUCTURE per HL7 spec and validated ConceptMap pattern
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/lifestyle-observation-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/loinc-observations-vs"

// Group 1: LifestyleObservationCS → LOINC
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[0].target = "http://loinc.org"

// ============================================================================
// SLEEP PANEL - VERIFIED 2025-12-08 ✅
// ============================================================================
* group[0].element[0].code = #sleep-panel
* group[0].element[0].display = "Sleep measurement panel"
* group[0].element[0].target[0].code = #90568-7
* group[0].element[0].target[0].display = "Polysomnography panel"
* group[0].element[0].target[0].equivalence = #narrower
* group[0].element[0].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 90568-7 = Polysomnography panel. Consumer device panel maps to broader clinical PSG panel. AASM guidelines terminology."

// ALTERNATIVE: Wearable device panel - VERIFIED 2025-12-08 ✅
* group[0].element[0].target[1].code = #82611-5
* group[0].element[0].target[1].display = "Wearable device external physiologic monitoring panel"
* group[0].element[0].target[1].equivalence = #wider
* group[0].element[0].target[1].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 82611-5 = Wearable device external physiologic monitoring panel. Alternative broader mapping."

// ============================================================================
// TIME IN BED - LOINC FOUND 2026-03-02 ✅ (103213-5, published 2023-08)
// Previously marked as GAP (2025-12-08) — code was published Aug 2023
// ============================================================================
* group[0].element[1].code = #sleep-time-bed
* group[0].element[1].display = "Time in bed"
* group[0].element[1].target[0].code = #103213-5
* group[0].element[1].target[0].display = "Duration in bed"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[1].target[0].comment = "CORRECTED 2026-03-02: LOINC 103213-5 'Duration in bed' published 2023-08-15. Profile now uses LOINC directly."

// ============================================================================
// DEEP SLEEP - LOINC 93831-6 ✅ (published 2019-12)
// Note: LOINC 93831-6 does not specify measurement method (PSG vs wearable).
// Method can be specified via Observation.method or Device.type.
// ============================================================================
* group[0].element[2].code = #sleep-deep
* group[0].element[2].display = "Deep sleep duration"
* group[0].element[2].target[0].code = #93831-6
* group[0].element[2].target[0].display = "Deep sleep duration"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[2].target[0].comment = "CORRECTED 2026-03-02: LOINC 93831-6 describes the concept 'Deep sleep duration' without specifying method. Consumer vs PSG distinction captured in Observation.method. Profile now uses LOINC directly."

// ============================================================================
// LIGHT SLEEP - LOINC 93830-8 ✅ (published 2019-12)
// ============================================================================
* group[0].element[3].code = #sleep-light
* group[0].element[3].display = "Light sleep duration"
* group[0].element[3].target[0].code = #93830-8
* group[0].element[3].target[0].display = "Light sleep duration"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[3].target[0].comment = "CORRECTED 2026-03-02: LOINC 93830-8 'Light sleep duration' published 2019-12-13. Consumer wearable N1+N2 combined maps to this code. Profile now uses LOINC directly."

// ============================================================================
// SLEEP AWAKENINGS - LOINC 103211-9 ✅ (published 2023-08)
// Previously mapped to 103215-0 (WASO - duration) which is RELATED but different
// ============================================================================
* group[0].element[4].code = #sleep-awakenings
* group[0].element[4].display = "Number of sleep awakenings"
* group[0].element[4].target[0].code = #103211-9
* group[0].element[4].target[0].display = "Number of awakenings"
* group[0].element[4].target[0].equivalence = #equivalent
* group[0].element[4].target[0].comment = "CORRECTED 2026-03-02: LOINC 103211-9 'Number of awakenings' published 2023-08-15. Exact match for awakening count. Previous mapping to 103215-0 (WASO duration) was related but semantically different."
