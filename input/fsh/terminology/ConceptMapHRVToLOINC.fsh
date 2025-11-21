// Operational ConceptMap: HRV Custom Codes → LOINC
// Created: 2024-11-21
// Purpose: Enable $translate operations for HRV terminology interoperability
// Status: Addresses Critical Gap - First operational ConceptMap in IG

Instance: ConceptMapHRVToLOINC
InstanceOf: ConceptMap
Title: "Heart Rate Variability to LOINC Mapping"
Description: "Maps custom HRV codes to LOINC codes where available, with migration path for future LOINC assignments. This is an operational ConceptMap that enables $translate operations, unlike FSH Mapping which is documentation-only."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapHRVToLOINC"
* version = "0.1.0"
* name = "ConceptMapHRVToLOINC"
* title = "Heart Rate Variability to LOINC Mapping"
* status = #active
* experimental = false
* date = "2024-11-21"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* description = "Operational ConceptMap for HRV terminology translation. Enables runtime $translate operations for semantic interoperability between custom HRV codes and LOINC standard terminology."
* purpose = "Provides semantic mappings from custom HRV metrics to standard LOINC codes where available, with migration path for future LOINC assignments. Critical for wearable device data integration into EHR systems."

// CORRECTED STRUCTURE per HL7 spec and existing MindfulnessDiagnosticMap pattern:
// - sourceCanonical/targetCanonical → ValueSets (business context, implementation scope)
// - group.source/group.target → CodeSystems (actual concept definitions)
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/heart-rate-variability-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/loinc-observations-vs"

// Group 1: Custom HRV CodeSystem → LOINC CodeSystem
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/heart-rate-variability-cs"
* group[0].target = "http://loinc.org"

// SDNN - HAS LOINC CODE ✅
* group[0].element[0].code = #hrv-sdnn
* group[0].element[0].display = "HRV SDNN (Standard Deviation of NN intervals)"
* group[0].element[0].target[0].code = #80404-7
* group[0].element[0].target[0].display = "R-R interval.standard deviation (Heart rate variability)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "Confirmed LOINC code for SDNN, created in LOINC v2.72 (June 2022). Time-domain HRV measure representing total variability."

// RMSSD - NO LOINC CODE YET ⚠️
* group[0].element[1].code = #hrv-rmssd
* group[0].element[1].display = "HRV RMSSD (Root Mean Square of Successive Differences)"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = "No LOINC code available as of November 2024. RMSSD is the primary parasympathetic marker recommended by HRV Task Force 1996. Submission recommended to LOINC committee. NOTE: Apple HealthKit mislabels this as 'SDNN' (HKQuantityTypeIdentifierHeartRateVariabilitySDNN) - implementers should be aware of this vendor-specific naming error."

// pNN50 - NO LOINC CODE YET ⚠️
* group[0].element[2].code = #hrv-pnn50
* group[0].element[2].display = "HRV pNN50 (Percentage of NN intervals >50ms difference)"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "No LOINC code available as of November 2024. High correlation with RMSSD (r>0.90), parasympathetic marker. Percentage of successive NN intervals differing by more than 50ms."

// LF/HF Ratio - NO LOINC CODE YET ⚠️
* group[0].element[3].code = #hrv-lf-hf-ratio
* group[0].element[3].display = "HRV LF/HF Ratio (Low Frequency to High Frequency ratio)"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "No LOINC code available as of November 2024. Autonomic balance indicator, though clinical interpretation is debated. Ratio of LF power (0.04-0.15 Hz) to HF power (0.15-0.4 Hz)."

// LF Power - NO LOINC CODE YET ⚠️
* group[0].element[4].code = #hrv-lf-power
* group[0].element[4].display = "HRV LF Power (Low Frequency power 0.04-0.15 Hz)"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "No LOINC code available as of November 2024. Low frequency spectral power (0.04-0.15 Hz). Reflects both sympathetic and parasympathetic modulation, with some baroreflex contribution."

// HF Power - NO LOINC CODE YET ⚠️
* group[0].element[5].code = #hrv-hf-power
* group[0].element[5].display = "HRV HF Power (High Frequency power 0.15-0.4 Hz)"
* group[0].element[5].target[0].equivalence = #unmatched
* group[0].element[5].target[0].comment = "No LOINC code available as of November 2024. High frequency spectral power (0.15-0.4 Hz). Reflects parasympathetic (vagal) modulation, synchronized with respiratory rhythm."
