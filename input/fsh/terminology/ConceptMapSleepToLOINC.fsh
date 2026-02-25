// Operational ConceptMap: Sleep Custom Codes → LOINC
// Created: 2025-11-22
// Purpose: Enable $translate operations for sleep measurement terminology interoperability
// Status: Addresses terminology gap for consumer sleep tracking data

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
// TIME IN BED - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[0].element[1].code = #sleep-time-bed
* group[0].element[1].display = "Time in bed"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = "GAP CONFIRMED 2025-12-08: No LOINC code for 'Time in bed'. Distinct from 'Sleep duration' (93832-4) - includes awake time before/after sleep. Common in Apple HealthKit, Fitbit, Oura."

// ============================================================================
// DEEP SLEEP - GAP CONFIRMED 2025-12-08 ❌
// Note: 93831-6 = "Deep sleep duration" exists but is for clinical PSG (EEG-based)
// Consumer wearables use accelerometer + HR algorithms, not EEG
// ============================================================================
* group[0].element[2].code = #sleep-deep
* group[0].element[2].display = "Deep sleep duration"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "GAP CONFIRMED 2025-12-08: No LOINC for consumer wearable deep sleep. Note: 93831-6 exists but is clinical PSG (EEG-based N3). Consumer devices use accelerometer + HR algorithms, not EEG - semantic gap."

// ============================================================================
// LIGHT SLEEP - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[0].element[3].code = #sleep-light
* group[0].element[3].display = "Light sleep duration"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "GAP CONFIRMED 2025-12-08: No LOINC for consumer light sleep (N1+N2 combined). Clinical PSG separates N1/N2. Semantic gap between consumer simplification and EEG-based staging."

// ============================================================================
// SLEEP AWAKENINGS - RELATED CODE VERIFIED 2025-12-08 ✅
// ============================================================================
* group[0].element[4].code = #sleep-awakenings
* group[0].element[4].display = "Number of sleep awakenings"
* group[0].element[4].target[0].code = #103215-0
* group[0].element[4].target[0].display = "Wake time after sleep onset"
* group[0].element[4].target[0].equivalence = #relatedto
* group[0].element[4].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 103215-0 = Wake time after sleep onset. Related but distinct: source = COUNT of awakenings, target = DURATION of wakefulness. No exact LOINC for awakening count."
