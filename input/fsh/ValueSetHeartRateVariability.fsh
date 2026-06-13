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

// Include custom codes for gaps. SDNN's canonical clinical code is LOINC 80404-7
// (above); hrv-sdnn is RETAINED here — not as a gap-filler, but as the source-scope
// anchor required by ConceptMapHRVToLOINC (sourceCanonical = this VS), which bridges
// the legacy/vendor custom code -> 80404-7. Removing it strands that ConceptMap
// (genonce ERROR: "hrv-sdnn nao e valido no conjunto de valores ...", verified T1 S58).
* LifestyleMedicineTemporaryCS#hrv-sdnn "HRV SDNN"
* LifestyleMedicineTemporaryCS#hrv-rmssd "HRV RMSSD"
* LifestyleMedicineTemporaryCS#hrv-pnn50 "HRV pNN50"
* LifestyleMedicineTemporaryCS#hrv-lf-hf-ratio "HRV LF/HF Ratio"
* LifestyleMedicineTemporaryCS#hrv-lf-power "HRV LF Power"
* LifestyleMedicineTemporaryCS#hrv-hf-power "HRV HF Power"