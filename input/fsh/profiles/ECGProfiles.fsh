// ECGProfiles.fsh
// Created: 2025-11-29
// Purpose: FHIR profiles for ECG-derived observations from consumer wearable devices
// Based on: Chapter 2 ECG Wearables section, RS6 SciSpace analysis
//
// Bibliographic References:
// - Rautaharju2009AHAECG: AHA/ACCF/HRS Recommendations for ECG Standardization Part IV (Circulation 119:e241-e250)
//   DOI: 10.1161/circulationaha.108.191096
// - Giudicessi2021KardiaMobileQT: AI-Enabled Smartphone ECG for QT Prolongation (Circulation 143:1274-1286)
//   DOI: 10.1161/CIRCULATIONAHA.120.050569
// - Perez2019AppleHeartStudy: Large-scale assessment of a smartwatch (NEJM 381:1909-1917)
//   DOI: 10.1056/NEJMoa1901183
// - Schwartz2012LQTS: Long QT Syndrome Genotype-Phenotype Correlations (Eur Heart J 33:1134-1140)
//   DOI: 10.1093/eurheartj/ehr479
// - Roden2004DrugInducedQT: Drug-Induced Prolongation of the QT Interval (NEJM 350:1013-1022)
//   DOI: 10.1056/NEJMra032426
//
// LOINC Codes (loinc.org, verified 2025-11-29):
// - 8634-8: Q-T interval
// - 8636-3: Q-T interval corrected
// - 76635-2: Q-T interval corrected by Bazett formula
// - 76634-5: Q-T interval corrected by Fridericia formula
// - 8637-1: R-R interval by EKG

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $vitalsigns = http://hl7.org/fhir/StructureDefinition/vitalsigns
ValueSet: QTCorrectionFormulaVS
Id: qt-correction-formula-vs
Title: "QT Correction Formula ValueSet"
Description: "ValueSet for QT interval correction formulas"
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

// ECG-Derived Vital Signs Base Profile
Profile: ConsumerECGObservation
Parent: $vitalsigns
Id: consumer-ecg-observation
Title: "Consumer ECG Observation Profile"
Description: "Base profile for ECG-derived observations from consumer wearable devices (Apple Watch, Withings, Samsung, AliveCor)"
* ^abstract = true
* status MS
* category 1..* MS
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* code 1..1 MS
* value[x] 0..1 MS
* device 0..1 MS
* note 0..* MS
* extension contains
    ClinicalUseWarning named clinicalWarning 1..1 MS and
    DataQualityIndicator named dataQuality 0..1 MS

// QT Interval Observation Profile
Profile: QTIntervalObservation
Parent: ConsumerECGObservation
Id: qt-interval-observation
Title: "QT Interval Observation Profile"
Description: "Profile for QT interval measurements from consumer ECG-capable wearable devices. LOINC codes: 8634-8 (Q-T interval), 8636-3 (Q-T corrected). Consumer devices are NOT FDA-cleared for QT measurement. References: Giudicessi2021 (Circulation), Zaballos2023 (Sci Rep)."
* code = $LOINC#8634-8 "Q-T interval"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #ms
* valueQuantity ^short = "Uncorrected QT interval in milliseconds"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    qtCorrected 1..1 MS and
    correctionFormula 0..1 MS and
    heartRateAtMeasurement 0..1 MS and
    rrInterval 0..1 MS
* component[qtCorrected].code = $LOINC#8636-3 "Q-T interval corrected"
* component[qtCorrected].valueQuantity only Quantity
* component[qtCorrected].valueQuantity.system = $UCUM
* component[qtCorrected].valueQuantity.code = #ms
* component[qtCorrected] ^short = "Heart rate-corrected QT interval"
* component[correctionFormula].code = LifestyleMedicineTemporaryCS#qt-correction-formula "QT Correction Formula"
* component[correctionFormula].valueCodeableConcept from QTCorrectionFormulaVS (required)
* component[correctionFormula] ^short = "Formula used for QT correction (Bazett, Fridericia, Framingham)"
* component[heartRateAtMeasurement].code = $LOINC#76282-3 "Heart rate.beat-to-beat by EKG"
* component[heartRateAtMeasurement].valueQuantity.system = $UCUM
* component[heartRateAtMeasurement].valueQuantity.code = #/min
* component[heartRateAtMeasurement] ^short = "Heart rate during QT measurement"
* component[rrInterval].code = $LOINC#8637-1 "R-R interval by EKG"
* component[rrInterval].valueQuantity.system = $UCUM
* component[rrInterval].valueQuantity.code = #ms
* component[rrInterval] ^short = "RR interval for rate correction calculation"
* interpretation 0..1 MS
* interpretation from QTInterpretationVS (extensible)

// QRS Duration Observation Profile
Profile: QRSDurationObservation
Parent: ConsumerECGObservation
Id: qrs-duration-observation
Title: "QRS Duration Observation Profile"
Description: "Profile for QRS complex duration from consumer ECG-capable wearables"
* code = $LOINC#44973-6 "QRS duration {Electrocardiograph lead}"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #ms

// PR Interval Observation Profile
Profile: PRIntervalObservation
Parent: ConsumerECGObservation
Id: pr-interval-observation
Title: "PR Interval Observation Profile"
Description: "Profile for PR interval measurements from consumer ECG-capable wearables"
* code = $LOINC#8625-6 "P-R Interval"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #ms

// Heart Rate by ECG Observation Profile
Profile: HeartRateByECGObservation
Parent: ConsumerECGObservation
Id: heart-rate-ecg-observation
Title: "Heart Rate by ECG Observation Profile"
Description: "Profile for heart rate derived from ECG signal (more accurate than PPG during motion)"
* code = $LOINC#76282-3 "Heart rate.beat-to-beat by EKG"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #/min

// QT Interpretation ValueSet
ValueSet: QTInterpretationVS
Id: qt-interpretation-vs
Title: "QT Interpretation ValueSet"
Description: "Interpretation codes for QT interval findings"
* ^experimental = false
// Note: SNOMED 78976005 and 251161004 removed - not found in SNOMED CT International 2025-02
// FIX 2026-01-12: Replaced 17338001 (inactive) with 9651007 (active equivalent)
* $SCT#9651007 "Long QT syndrome (disorder)"
* http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"
* http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#H "High"
* http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#HH "Critical High"

// Clinical Alert Extension for QT Prolongation
Extension: QTClinicalAlert
Id: qt-clinical-alert
Title: "QT Clinical Alert Extension"
Description: "Extension for clinical alerts triggered by QT prolongation thresholds"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* extension contains
    alertType 1..1 MS and
    threshold 1..1 MS and
    recommendedAction 0..1 MS
* extension[alertType].value[x] only CodeableConcept
* extension[alertType].valueCodeableConcept from QTAlertTypeVS (required)
* extension[threshold].value[x] only Quantity
* extension[threshold].valueQuantity.system = $UCUM
* extension[threshold].valueQuantity.code = #ms
* extension[recommendedAction].value[x] only string
ValueSet: QTAlertTypeVS
Id: qt-alert-type-vs
Title: "QT Alert Type ValueSet"
Description: "ValueSet for QT clinical alert types"
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS
