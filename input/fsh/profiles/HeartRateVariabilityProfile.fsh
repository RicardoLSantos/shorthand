// Heart Rate Variability Observation Profile
// One HRV metric per Observation. The code is drawn from HeartRateVariabilityVS, which combines the
// LOINC code that exists for HRV (80404-7, SDNN) with the IG's custom codes for the metrics that have
// no LOINC code (RMSSD, pNN50, LF power, HF power, LF/HF ratio), documented in ConceptMapHRVToLOINC.
// SdnnObservation (fixed to LOINC 80404-7) remains the standalone SDNN profile; this profile is the
// generic HRV profile that the ValueSet and the ConceptMaps had lacked.

Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

Profile: HeartRateVariabilityObservation
Parent: Observation
Id: heart-rate-variability-observation
Title: "Heart Rate Variability Observation Profile"
Description: "One heart rate variability (HRV) metric from a consumer wearable or an ECG recording: SDNN (LOINC 80404-7) or, for the metrics without a LOINC code, RMSSD, pNN50, LF power, HF power or the LF/HF ratio (LifestyleMedicineTemporaryCS, bridged to LOINC where a code exists by ConceptMapHRVToLOINC). The value is a Quantity in UCUM units (ms for time-domain metrics, % for pNN50, ms2 for spectral power, 1 for the LF/HF ratio). Reference ranges and interpretation carry the person's own baseline; the measurement context (rest, sleep, post-exercise) is recorded with the MeasurementContext extension and the recording device with Observation.device."

* status MS
* category 1..* MS
* category = $ObsCat#vital-signs
* code 1..1 MS
* code from HeartRateVariabilityVS (extensible)
* code ^short = "HRV metric (LOINC 80404-7 for SDNN; custom codes for RMSSD, pNN50, LF, HF, LF/HF)"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] 1..1 MS
* effective[x] only dateTime or Period
* value[x] only Quantity
* valueQuantity 1..1 MS
* valueQuantity.value 1..1 MS
* valueQuantity.system 1..1 MS
* valueQuantity.system = $UCUM
* valueQuantity.code 1..1 MS
* valueQuantity.code ^short = "UCUM unit: ms (SDNN, RMSSD), % (pNN50), ms2 (LF/HF power), 1 (LF/HF ratio)"
* method 0..1 MS
* method ^short = "Analysis method (time-domain or frequency-domain), when known"
* method ^comment = "Declare the acquisition method as well: the LOINC R-R interval codes of HeartRateVariabilityVS (18505-8, 76638-6, 76639-4, 76643-6, 76644-4) are defined by EKG, whereas inter-beat intervals from wrist-worn wearables are PPG-derived (pulse rate variability). 80404-7 (SDNN, no method) remains the primary code for wearable SDNN; the 'by EKG' codes apply when the source is a real ECG (ECG app, chest strap)."
* device 0..1 MS
* device ^short = "The application or sensor that produced the metric"
* referenceRange 0..* MS
* referenceRange ^short = "Personal baseline range for this metric (for example, a rolling 7-day or 28-day range)"
* interpretation 0..* MS
* interpretation ^short = "Deviation from the personal baseline (for example, L for below the baseline range)"
* note 0..* MS
* extension contains MeasurementContext named measurementContext 0..1 MS
* extension[measurementContext] ^short = "Measurement context: rest, sleep, post-exercise"
