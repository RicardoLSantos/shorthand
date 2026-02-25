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
* LifestyleMedicineTemporaryCS#hrv-sdnn "HRV SDNN"
* LifestyleMedicineTemporaryCS#hrv-rmssd "HRV RMSSD"
* LifestyleMedicineTemporaryCS#hrv-pnn50 "HRV pNN50"
* LifestyleMedicineTemporaryCS#hrv-lf-hf-ratio "HRV LF/HF Ratio"
* LifestyleMedicineTemporaryCS#hrv-lf-power "HRV LF Power"
* LifestyleMedicineTemporaryCS#hrv-hf-power "HRV HF Power"