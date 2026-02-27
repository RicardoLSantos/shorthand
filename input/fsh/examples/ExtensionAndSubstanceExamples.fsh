// ============================================================================
// Extension and Substance Use Examples
// ============================================================================
// Purpose: Example instances demonstrating extension usage and substance use profiles
// Created: 2025-11-30
// Extensions: CessationSupport, DataQualityIndicator, QTClinicalAlert
// Profiles: RecreationalSubstanceUseObservation

Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $SCT = http://snomed.info/sct
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

// ============================================================================
// Recreational Substance Use Observation Example
// ============================================================================

Instance: AlcoholUseExample
InstanceOf: AlcoholUseProfile
Usage: #example
Title: "Alcohol Consumption Assessment Example"
Description: "Example of alcohol consumption tracking as part of lifestyle medicine assessment"

* status = #final
// category and code are fixed by profile (social-history, LOINC#11331-6)
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T10:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

// Alcohol use status (profile uses CodeableConcept from SNOMED CT)
* valueCodeableConcept = $SCT#43783005 "Moderate drinker (finding)"

// Weekly drinks as component
* component[drinksPerWeek].valueQuantity = 8 '/wk' "per week"

* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"

* note.text = "Moderate alcohol consumption. Per ACLM guidelines, recommend harm reduction strategies."


// ============================================================================
// Observation with Data Quality Extension Example
// ============================================================================

Instance: ObservationWithDataQualityExample
InstanceOf: Observation
Usage: #example
Title: "Observation with Data Quality Indicator"
Description: "Example showing how DataQualityIndicator extension is used on an observation"

* status = #final
* category = $ObsCat#vital-signs "Vital Signs"
* code = $LOINC#8867-4 "Heart rate"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T08:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

* valueQuantity = 72 '/min' "per minute"

// Data quality indicator extension (complex extension with sub-extensions)
* extension[0].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/data-quality-indicator"
* extension[0].extension[0].url = "confidenceLevel"
* extension[0].extension[0].valueCodeableConcept = AppLogicCS#data-quality-high "High Confidence"
* extension[0].extension[1].url = "confidenceScore"
* extension[0].extension[1].valueDecimal = 95

* note.text = "Heart rate measured during rest with good signal quality."


// ============================================================================
// Observation with Clinical Use Warning Example
// ============================================================================

Instance: ObservationWithClinicalWarningExample
InstanceOf: Observation
Usage: #example
Title: "Observation with Clinical Use Warning"
Description: "Example showing how ClinicalUseWarning extension is used"

* status = #final
* category = $ObsCat#vital-signs "Vital Signs"
* code = $LOINC#8462-4 "Diastolic blood pressure"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T09:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/WithingsScaleDevice)

* valueQuantity = 78 'mm[Hg]' "millimeters of mercury"

// Clinical use warning extension (complex extension with sub-extensions)
* extension[0].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/clinical-use-warning"
* extension[0].extension[0].url = "warningCode"
* extension[0].extension[0].valueCodeableConcept = LifestyleMedicineTemporaryCS#consumer-grade-sensor "Consumer-Grade Sensor"
* extension[0].extension[1].url = "severity"
* extension[0].extension[1].valueCode = #warning

* note.text = "Blood pressure from consumer device. Confirm with validated clinical device for diagnosis."


// ============================================================================
// QT Observation with Clinical Alert Example
// ============================================================================

Instance: QTWithClinicalAlertExample
InstanceOf: QTIntervalObservation
Usage: #example
Title: "QT Interval with Prolongation Alert"
Description: "Example showing QT prolongation clinical alert extension"

* status = #final
* category[VSCat] = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* code = $LOINC#8634-8 "Q-T interval"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T14:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

* valueQuantity = 420 'ms' "milliseconds"

// QTc (corrected) - prolonged
* component[qtCorrected].code = $LOINC#8636-3 "Q-T interval corrected"
* component[qtCorrected].valueQuantity = 485 'ms' "milliseconds"

// Correction formula (code is fixed by profile)
* component[correctionFormula].valueCodeableConcept = LifestyleMedicineTemporaryCS#bazett "Bazett Formula"

// Heart rate at measurement
* component[heartRateAtMeasurement].code = $LOINC#76282-3 "Heart rate.beat-to-beat by EKG"
* component[heartRateAtMeasurement].valueQuantity = 65 '/min' "per minute"

// RR interval
* component[rrInterval].code = $LOINC#8637-1 "R-R interval by EKG"
* component[rrInterval].valueQuantity = 923 'ms' "milliseconds"

* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#H "High"

// Clinical warning - consumer device (uses named slices from ConsumerECGObservation profile)
* extension[clinicalWarning].extension[warningCode].valueCodeableConcept = LifestyleMedicineTemporaryCS#consumer-grade-sensor "Consumer-Grade Sensor"
* extension[clinicalWarning].extension[severity].valueCode = #warning

// QT Clinical Alert extension (added dynamically, use index-based syntax)
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/qt-clinical-alert"
* extension[=].extension[0].url = "alertType"
* extension[=].extension[=].valueCodeableConcept = LifestyleMedicineTemporaryCS#qtc-borderline "QTc Borderline Prolongation"
* extension[=].extension[+].url = "threshold"
* extension[=].extension[=].valueQuantity = 480 'ms' "milliseconds"
* extension[=].extension[+].url = "recommendedAction"
* extension[=].extension[=].valueString = "QTc 480-500ms requires clinical review. Review medications and obtain 12-lead ECG."

* note.text = "QTc borderline prolonged (485ms). Consumer device measurement - confirm with clinical ECG. Review QT-prolonging medications."


// ============================================================================
// Supporting Device Examples
// ============================================================================

Instance: WithingsScaleDevice
InstanceOf: Device
Usage: #example
Title: "Withings Body+ Scale"
Description: "Example of Withings connected scale with blood pressure capability"

* deviceName[0].name = "Withings Body+"
* deviceName[0].type = #user-friendly-name
* manufacturer = "Withings"
* modelNumber = "Body+"
