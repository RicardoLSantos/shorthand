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
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* group[0].target = "http://loinc.org"

// SLEEP PANEL - LOINC POLYSOMNOGRAPHY PANEL (broader mapping) ✅
* group[0].element[0].code = #sleep-panel
* group[0].element[0].display = "Sleep measurement panel"
* group[0].element[0].target[0].code = #90568-7
* group[0].element[0].target[0].display = "Polysomnography panel"
* group[0].element[0].target[0].equivalence = #narrower
* group[0].element[0].target[0].comment = "Sleep measurement panel from consumer devices maps to broader LOINC Polysomnography panel. Source is more specific (consumer device panel) than target (clinical polysomnography). LOINC 90568-7 contains terms from American Academy of Sleep Medicine (AASM) guidelines. Consumer devices measure subset of clinical polysomnography parameters."

// ALTERNATIVE: Wearable device panel
* group[0].element[0].target[1].code = #82611-5
* group[0].element[0].target[1].display = "Wearable device external physiologic monitoring panel"
* group[0].element[0].target[1].equivalence = #wider
* group[0].element[0].target[1].comment = "Alternative mapping to general wearable device panel. Target is less specific (covers all wearable physiologic monitoring) than source (sleep-specific panel)."

// TIME IN BED - NO DIRECT LOINC CODE ⚠️
* group[0].element[1].code = #sleep-time-bed
* group[0].element[1].display = "Time in bed"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = "No LOINC code available for 'Time in bed' as of November 2025. Time in bed is a distinct concept from 'Sleep duration' (LOINC 93832-4) - it includes time awake before falling asleep and after waking. Common consumer device metric (Apple HealthKit, Fitbit, Oura, etc.). Recommend submission to LOINC for standardization."

// DEEP SLEEP - NO LOINC CODE ⚠️
* group[0].element[2].code = #sleep-deep
* group[0].element[2].display = "Deep sleep duration"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "No LOINC code available for 'Deep sleep duration' (slow-wave sleep, N3 stage) as of November 2025. Consumer devices measure deep sleep using accelerometer + heart rate algorithms, not EEG. Clinical polysomnography uses EEG-defined N3 sleep stage. Terminology gap: consumer 'deep sleep' vs clinical 'N3/slow-wave sleep'. LOINC has codes for clinical polysomnography sleep stages but not consumer device equivalents."

// LIGHT SLEEP - NO LOINC CODE ⚠️
* group[0].element[3].code = #sleep-light
* group[0].element[3].display = "Light sleep duration"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "No LOINC code available for 'Light sleep duration' (N1+N2 stages) as of November 2025. Consumer devices combine N1 and N2 sleep stages into 'light sleep' category. Clinical polysomnography separates N1 and N2. Terminology gap between consumer device simplification and clinical EEG-based staging. Widely used metric in Apple HealthKit, Fitbit, Oura Ring, Garmin wearables."

// SLEEP AWAKENINGS - POTENTIAL RELATION TO WAKE AFTER SLEEP ONSET ⚠️
* group[0].element[4].code = #sleep-awakenings
* group[0].element[4].display = "Number of sleep awakenings"
* group[0].element[4].target[0].code = #103215-0
* group[0].element[4].target[0].display = "Wake time after sleep onset"
* group[0].element[4].target[0].equivalence = #relatedto
* group[0].element[4].target[0].comment = "Sleep awakenings count is related to but distinct from 'Wake time after sleep onset' (LOINC 103215-0). Source measures NUMBER of awakenings (discrete count), target measures DURATION of wakefulness after initial sleep onset (time in minutes). Both concepts assess sleep fragmentation but from different perspectives. No exact LOINC match for awakening count exists as of November 2025."
