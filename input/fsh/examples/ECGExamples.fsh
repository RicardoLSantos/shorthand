// ============================================================================
// ECG Profile Examples
// ============================================================================
// Purpose: Example instances for ECG-derived observations
// Created: 2025-11-30
// Profiles: QTIntervalObservation, QRSDurationObservation, PRIntervalObservation,
//           HeartRateECGObservation

Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $SCT = http://snomed.info/sct

// ============================================================================
// QT Interval Observation Example
// ============================================================================

Instance: QTIntervalExample
InstanceOf: QTIntervalObservation
Usage: #example
Title: "QT Interval Measurement Example"
Description: "Example of QT interval measurement from Apple Watch Series 9 ECG feature"

* status = #final
* category[VSCat] = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* code = $LOINC#8634-8 "Q-T interval"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T08:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

* valueQuantity = 380 'ms' "milliseconds"

// QTc (corrected)
* component[qtCorrected].code = $LOINC#8636-3 "Q-T interval corrected"
* component[qtCorrected].valueQuantity = 410 'ms' "milliseconds"

// Correction formula used (code is fixed by profile)
* component[correctionFormula].valueCodeableConcept = QTCorrectionFormulaCS#bazett "Bazett Formula"

// Heart rate at measurement
* component[heartRateAtMeasurement].code = $LOINC#76282-3 "Heart rate.beat-to-beat by EKG"
* component[heartRateAtMeasurement].valueQuantity = 72 '/min' "per minute"

// RR interval
* component[rrInterval].code = $LOINC#8637-1 "R-R interval by EKG"
* component[rrInterval].valueQuantity = 833 'ms' "milliseconds"

* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"

// Clinical warning extension (complex extension with sub-extensions)
* extension[clinicalWarning].extension[warningCode].valueCodeableConcept = ClinicalUseWarningTypeCS#consumer-grade-sensor "Consumer-Grade Sensor"
* extension[clinicalWarning].extension[severity].valueCode = #warning

* note.text = "QT interval within normal range. Measured during morning rest. Apple Watch ECG is not FDA-cleared for QT measurement."


// ============================================================================
// QRS Duration Observation Example
// ============================================================================

Instance: QRSDurationExample
InstanceOf: QRSDurationObservation
Usage: #example
Title: "QRS Duration Measurement Example"
Description: "Example of QRS duration measurement from consumer ECG device"

* status = #final
* category[VSCat] = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* code = $LOINC#44973-6 "QRS duration {Electrocardiograph lead}"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T08:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

* valueQuantity = 92 'ms' "milliseconds"

* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"

* extension[clinicalWarning].extension[warningCode].valueCodeableConcept = ClinicalUseWarningTypeCS#consumer-grade-sensor "Consumer-Grade Sensor"
* extension[clinicalWarning].extension[severity].valueCode = #warning

* note.text = "QRS duration normal (<100ms). Single-lead consumer ECG measurement."


// ============================================================================
// PR Interval Observation Example
// ============================================================================

Instance: PRIntervalExample
InstanceOf: PRIntervalObservation
Usage: #example
Title: "PR Interval Measurement Example"
Description: "Example of PR interval measurement from consumer ECG device"

* status = #final
* category[VSCat] = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
// code is fixed by profile: LOINC#8625-6 "P-R Interval"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T08:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

* valueQuantity = 160 'ms' "milliseconds"

* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"

* extension[clinicalWarning].extension[warningCode].valueCodeableConcept = ClinicalUseWarningTypeCS#consumer-grade-sensor "Consumer-Grade Sensor"
* extension[clinicalWarning].extension[severity].valueCode = #warning

* note.text = "PR interval within normal range (120-200ms)."


// ============================================================================
// Heart Rate from ECG Example
// ============================================================================

Instance: HeartRateECGExample
InstanceOf: HeartRateByECGObservation
Usage: #example
Title: "Heart Rate from ECG Example"
Description: "Example of heart rate derived from ECG R-R intervals"

* status = #final
* category[VSCat] = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
// code is fixed by profile: LOINC#76282-3 "Heart rate.beat-to-beat by EKG"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T08:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

* valueQuantity = 68 '/min' "per minute"

* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"

* extension[clinicalWarning].extension[warningCode].valueCodeableConcept = ClinicalUseWarningTypeCS#consumer-grade-sensor "Consumer-Grade Sensor"
* extension[clinicalWarning].extension[severity].valueCode = #warning

* note.text = "Resting heart rate from 30-second ECG recording."
