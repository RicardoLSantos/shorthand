// Heart Rate Variability CodeSystem with LOINC mapping
// Created: 2024-11-20
// Purpose: Define custom codes for HRV metrics not in LOINC, map existing ones

CodeSystem: HeartRateVariabilityCS
Id: heart-rate-variability-cs
Title: "Heart Rate Variability CodeSystem"
Description: "Custom codes for HRV metrics with LOINC mappings where available. SDNN maps to LOINC 80404-7, other metrics await LOINC assignment."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^version = "1.0.0"
* ^date = "2024-11-20"
* ^publisher = "iOS Lifestyle Medicine HEADS FHIR IG"
* ^contact.name = "Ricardo L. Santos"

// Define properties used in concepts
* ^property[0].code = #loinc-equivalent
* ^property[=].uri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/loinc-equivalent"
* ^property[=].description = "Equivalent LOINC code if available"
* ^property[=].type = #code

* ^property[+].code = #status
* ^property[=].uri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/assignment-status"
* ^property[=].description = "Status of LOINC code assignment"
* ^property[=].type = #string

// SDNN - HAS LOINC CODE
* #hrv-sdnn "HRV SDNN (Standard Deviation of NN intervals)"
  * ^designation[0].language = #en
  * ^designation[0].value = "Maps to LOINC 80404-7"
  * ^property[0].code = #loinc-equivalent
  * ^property[0].valueCode = #80404-7

// RMSSD - NO LOINC CODE YET
* #hrv-rmssd "HRV RMSSD (Root Mean Square of Successive Differences)"
  * ^designation[0].language = #en
  * ^designation[0].value = "Awaiting LOINC code assignment"
  * ^property[0].code = #status
  * ^property[0].valueString = "pending-loinc"

// pNN50 - NO LOINC CODE YET
* #hrv-pnn50 "HRV pNN50 (Percentage of NN intervals >50ms difference)"
  * ^designation[0].language = #en
  * ^designation[0].value = "Awaiting LOINC code assignment"
  * ^property[0].code = #status
  * ^property[0].valueString = "pending-loinc"

// LF/HF Ratio - NO LOINC CODE YET
* #hrv-lf-hf-ratio "HRV LF/HF Ratio (Low Frequency to High Frequency ratio)"
  * ^designation[0].language = #en
  * ^designation[0].value = "Awaiting LOINC code assignment"
  * ^property[0].code = #status
  * ^property[0].valueString = "pending-loinc"

// LF Power - NO LOINC CODE YET
* #hrv-lf-power "HRV LF Power (Low Frequency power 0.04-0.15 Hz)"
  * ^designation[0].language = #en
  * ^designation[0].value = "Awaiting LOINC code assignment"
  * ^property[0].code = #status
  * ^property[0].valueString = "pending-loinc"

// HF Power - NO LOINC CODE YET
* #hrv-hf-power "HRV HF Power (High Frequency power 0.15-0.4 Hz)"
  * ^designation[0].language = #en
  * ^designation[0].value = "Awaiting LOINC code assignment"
  * ^property[0].code = #status
  * ^property[0].valueString = "pending-loinc"

// ValueSet using both LOINC and custom codes
ValueSet: HeartRateVariabilityVS
Id: heart-rate-variability-vs
Title: "Heart Rate Variability ValueSet"
Description: "Complete set of HRV metrics combining LOINC codes where available and custom codes for gaps"
* ^status = #active
* ^experimental = false
* ^version = "1.0.0"

// Include LOINC codes
* http://loinc.org#8867-4 "Heart rate"
* http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"

// Include custom codes for gaps
* HeartRateVariabilityCS#hrv-rmssd "HRV RMSSD"
* HeartRateVariabilityCS#hrv-pnn50 "HRV pNN50"
* HeartRateVariabilityCS#hrv-lf-hf-ratio "HRV LF/HF Ratio"
* HeartRateVariabilityCS#hrv-lf-power "HRV LF Power"
* HeartRateVariabilityCS#hrv-hf-power "HRV HF Power"