ValueSet: HeartRateVariabilityVS
Id: heart-rate-variability-vs
Title: "Heart Rate Variability ValueSet"
Description: "Complete set of HRV metrics combining LOINC codes where available and custom codes for gaps"
* ^status = #active
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-09-17"

// Include LOINC codes. 8867-4 "Heart rate" left this set on 2026-09-17 (a heart rate is not an HRV metric; it stays in
// ValueSetLOINCObservations and in the vital-signs profiles). The five R-R interval codes below were verified on 2026-09-17
// in the Athena LOINC snapshot and on tx.fhir.org (LOINC 2.82). LOINC R-R codes are defined by EKG; wearable inter-beat
// intervals are PPG-derived (pulse rate variability) — declare the method in Observation.method. 80404-7 (no method)
// remains the primary SDNN code for wearable data; the "by EKG" codes apply when the source is a real ECG (ECG app, chest strap).
* http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* http://loinc.org#18505-8 "R-R interval (Mean value during study) by EKG"
* http://loinc.org#76638-6 "R-R interval (Maximum value during study) by EKG"
* http://loinc.org#76639-4 "R-R interval (Minimum value during study) by EKG"
* http://loinc.org#76643-6 "R-R interval.standard deviation (Heart rate variability) by EKG"
* http://loinc.org#76644-4 "R-R interval.coefficient of variation by EKG"

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