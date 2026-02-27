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
ValueSet: ClinicalUseWarningTypeVS
Id: clinical-use-warning-type-vs
Title: "Clinical Use Warning Type ValueSet"
Description: "ValueSet for clinical use warning codes on consumer wearable observations"
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS
ValueSet: DataQualityConfidenceVS
Id: data-quality-confidence-vs
Title: "Data Quality Confidence ValueSet"
Description: "ValueSet for data quality confidence levels in consumer wearable data"
* ^experimental = false
* include codes from system AppLogicCS

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
ValueSet: WearableDeviceTypeVS
Id: wearable-device-type-vs
Title: "Wearable Device Type ValueSet"
Description: "ValueSet for types of consumer wearable devices"
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS
