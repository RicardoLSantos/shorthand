// Heart Rate Variability Observation examples — one per metric without a LOINC code
// (RMSSD, pNN50, LF/HF ratio). Values are plausible resting values; units validated against UCUM.

Alias: $UCUM = http://unitsofmeasure.org
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $ObsInterp = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation

Instance: HRVRmssdExample
InstanceOf: HeartRateVariabilityObservation
Usage: #example
Title: "HRV RMSSD Example"
Description: "Nightly RMSSD from a consumer wearable, within the person's baseline range"
* status = #final
* category = $ObsCat#vital-signs
* code = LifestyleMedicineTemporaryCS#hrv-rmssd "HRV RMSSD (Root Mean Square of Successive Differences)"
* subject = Reference(PatientExample)
* effectivePeriod.start = "2026-09-10T23:30:00Z"
* effectivePeriod.end = "2026-09-11T06:45:00Z"
* valueQuantity = 42 'ms' "millisecond"
* method.text = "Time-domain analysis of PPG-derived NN intervals during sleep"
* referenceRange.low = 34 'ms' "millisecond"
* referenceRange.high = 51 'ms' "millisecond"
* referenceRange.text = "Personal 28-day baseline range"
* interpretation = $ObsInterp#N "Normal"
* device.display = "Wearable data source (application)"

Instance: HRVPnn50Example
InstanceOf: HeartRateVariabilityObservation
Usage: #example
Title: "HRV pNN50 Example"
Description: "Resting pNN50 (percentage of successive NN intervals differing by more than 50 ms)"
* status = #final
* category = $ObsCat#vital-signs
* code = LifestyleMedicineTemporaryCS#hrv-pnn50 "HRV pNN50 (Percentage of NN intervals >50ms difference)"
* subject = Reference(PatientExample)
* effectiveDateTime = "2026-09-11T07:05:00Z"
* valueQuantity = 18 '%' "percent"
* method.text = "Time-domain analysis of a 5-minute resting recording"
* device.display = "Wearable data source (application)"

Instance: HRVLfHfRatioExample
InstanceOf: HeartRateVariabilityObservation
Usage: #example
Title: "HRV LF/HF Ratio Example"
Description: "Resting LF/HF ratio (dimensionless) from spectral analysis, above the person's baseline range"
* status = #final
* category = $ObsCat#vital-signs
* code = LifestyleMedicineTemporaryCS#hrv-lf-hf-ratio "HRV LF/HF Ratio (Low Frequency to High Frequency ratio)"
* subject = Reference(PatientExample)
* effectiveDateTime = "2026-09-11T07:05:00Z"
* valueQuantity = 1.8 '1' "ratio"
* method.text = "Frequency-domain (spectral) analysis of a 5-minute resting recording"
* referenceRange.low = 0.8 '1' "ratio"
* referenceRange.high = 1.5 '1' "ratio"
* referenceRange.text = "Personal 28-day baseline range"
* interpretation = $ObsInterp#H "High"
* device.display = "Wearable data source (application)"
