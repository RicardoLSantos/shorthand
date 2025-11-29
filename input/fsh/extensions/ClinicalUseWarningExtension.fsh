// ClinicalUseWarningExtension.fsh
// Created: 2025-11-29
// Purpose: Extension for clinical use warnings on consumer wearable-derived observations
// Based on: RS6 SciSpace systematic review (214 papers, 2015-2025)
//
// Bibliographic References:
// - Bayoumy2021Wearables: Smart wearable devices in cardiovascular care (Nature Reviews Cardiology)
//   DOI: 10.1038/s41569-021-00522-7
// - Perez2019AppleHeartStudy: Large-scale assessment of a smartwatch (NEJM 381:1909-1917)
//   DOI: 10.1056/NEJMoa1901183
// - FDA2018AppleWatch: DEN180044 De Novo Classification, ECG App
//   https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN180044.pdf
// - Giudicessi2021KardiaMobileQT: AI-Enabled Smartphone ECG for QT Prolongation (Circulation 143:1274-1286)
//   DOI: 10.1161/CIRCULATIONAHA.120.050569
//
// SNOMED CT References (browser.ihtsdotools.org, verified 2025-11-29):
// - Device provenance concepts per SNOMED International Editorial Guide

Extension: ClinicalUseWarning
Id: clinical-use-warning
Title: "Clinical Use Warning Extension"
Description: "Provides explicit warnings about the appropriate clinical use of consumer wearable-derived observations. Addresses Gap 3 (Algorithm Transparency, 5% coverage, 95 severity) from RS6 gap analysis."
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* ^context[1].type = #element
* ^context[1].expression = "DiagnosticReport"
* extension contains
    warningText 0..1 MS and
    warningCode 1..1 MS and
    severity 1..1 MS
* extension[warningText].value[x] only string
* extension[warningText] ^short = "Human-readable warning text"
* extension[warningText] ^definition = "Free text description of the clinical use limitation or warning"
* extension[warningCode].value[x] only CodeableConcept
* extension[warningCode].valueCodeableConcept from ClinicalUseWarningTypeVS (required)
* extension[warningCode] ^short = "Coded warning type"
* extension[warningCode] ^definition = "Standardized code indicating the type of clinical use warning"
* extension[severity].value[x] only code
* extension[severity].valueCode from http://hl7.org/fhir/ValueSet/issue-severity (required)
* extension[severity] ^short = "Warning severity level"
* extension[severity] ^definition = "Severity of the warning: error (do not use clinically), warning (use with caution), information (note for context)"

// Clinical Use Warning Type CodeSystem
CodeSystem: ClinicalUseWarningTypeCS
Id: clinical-use-warning-type-cs
Title: "Clinical Use Warning Type CodeSystem"
Description: "Codes for types of clinical use warnings on consumer wearable observations. Addresses vendor algorithm opacity (95% severity) identified in RS6."
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #consumer-grade-sensor "Consumer-Grade Sensor" "Data derived from consumer-grade sensor (not FDA-cleared for diagnostic use)"
* #algorithm-not-validated "Algorithm Not Validated" "Proprietary algorithm used without published clinical validation"
* #vendor-proprietary "Vendor Proprietary Calculation" "Metric calculated using undisclosed vendor-specific algorithm"
* #insufficient-data-quality "Insufficient Data Quality" "Data quality below threshold for clinical decision-making"
* #single-lead-ecg "Single-Lead ECG Limitation" "ECG data from single-lead device; cannot replace 12-lead clinical ECG"
* #not-fda-cleared-indication "Not FDA-Cleared Indication" "Device not cleared for this specific measurement indication"
* #requires-clinical-correlation "Requires Clinical Correlation" "Value should be correlated with clinical assessment before action"
* #research-use-only "Research Use Only" "Data suitable for research purposes only; not for clinical decisions"

// Clinical Use Warning Type ValueSet
ValueSet: ClinicalUseWarningTypeVS
Id: clinical-use-warning-type-vs
Title: "Clinical Use Warning Type ValueSet"
Description: "ValueSet for clinical use warning codes on consumer wearable observations"
* ^experimental = false
* include codes from system ClinicalUseWarningTypeCS

// Data Quality Confidence CodeSystem (complementary to warning)
CodeSystem: DataQualityConfidenceCS
Id: data-quality-confidence-cs
Title: "Data Quality Confidence CodeSystem"
Description: "Codes indicating confidence level in consumer wearable data quality. Addresses Gap 2 (Data Quality Metadata, 30% coverage, 85 severity)."
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #high "High Confidence" "Data quality 80-100%; suitable for clinical correlation"
* #medium "Medium Confidence" "Data quality 60-79%; use with caution, recommend verification"
* #low "Low Confidence" "Data quality 40-59%; significant uncertainty, clinical use not recommended"
* #unreliable "Unreliable" "Data quality 0-39%; do not use for clinical purposes"

// Data Quality Confidence ValueSet
ValueSet: DataQualityConfidenceVS
Id: data-quality-confidence-vs
Title: "Data Quality Confidence ValueSet"
Description: "ValueSet for data quality confidence levels in consumer wearable data"
* ^experimental = false
* include codes from system DataQualityConfidenceCS

// Data Quality Extension
Extension: DataQualityIndicator
Id: data-quality-indicator
Title: "Data Quality Indicator Extension"
Description: "Indicates the quality/confidence level of consumer wearable-derived data. Addresses RS6 Gap 2 (Data Quality Metadata)."
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* extension contains
    confidenceLevel 1..1 MS and
    confidenceScore 0..1 and
    qualityNote 0..1
* extension[confidenceLevel].value[x] only CodeableConcept
* extension[confidenceLevel].valueCodeableConcept from DataQualityConfidenceVS (required)
* extension[confidenceScore].value[x] only decimal
* extension[confidenceScore] ^short = "Numeric confidence score (0-100)"
* extension[qualityNote].value[x] only string
* extension[qualityNote] ^short = "Additional quality notes"

// Wearable Device Type CodeSystem
CodeSystem: WearableDeviceTypeCS
Id: wearable-device-type-cs
Title: "Wearable Device Type CodeSystem"
Description: "Codes for types of consumer wearable devices. Supports device provenance capture (RS6 Gap 4)."
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #smartwatch "Smartwatch" "Wrist-worn smartwatch device (e.g., Apple Watch, Samsung Galaxy Watch)"
* #fitness-tracker "Fitness Tracker" "Dedicated fitness tracking device (e.g., Fitbit, Garmin)"
* #smart-ring "Smart Ring" "Ring-form factor wearable (e.g., Oura Ring)"
* #chest-strap "Chest Strap" "Chest-mounted heart rate monitor with ECG electrodes"
* #smart-patch "Smart Patch" "Adhesive skin-mounted continuous monitoring patch"
* #smart-clothing "Smart Clothing" "Garments with integrated sensors"
* #mobile-app-sensor "Mobile App Sensor" "Smartphone-based sensor using device hardware"
* #ecg-accessory "ECG Accessory" "Dedicated ECG recording accessory (e.g., AliveCor KardiaMobile)"
* #cgm-device "CGM Device" "Continuous Glucose Monitor (e.g., Dexcom, FreeStyle Libre)"
* #pulse-oximeter "Pulse Oximeter" "Dedicated pulse oximetry device"

// Wearable Device Type ValueSet
ValueSet: WearableDeviceTypeVS
Id: wearable-device-type-vs
Title: "Wearable Device Type ValueSet"
Description: "ValueSet for types of consumer wearable devices"
* ^experimental = false
* include codes from system WearableDeviceTypeCS
