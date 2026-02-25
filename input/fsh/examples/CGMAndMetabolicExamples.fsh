// ============================================================================
// CGM and Metabolic Profile Examples
// ============================================================================
// Purpose: Example instances for CGM observations and inflammatory markers
// Created: 2025-11-30
// Profiles: CGMObservation, InflammatoryMarkerObservation

Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $SCT = http://snomed.info/sct
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

// ============================================================================
// CGM Observation Example
// ============================================================================

Instance: CGMObservationExample
InstanceOf: CGMObservation
Usage: #example
Title: "CGM Glucose Reading Example"
Description: "Example of continuous glucose monitoring data from a consumer CGM device (Dexcom G7)"

* status = #final
* category = $ObsCat#exam "Exam"
* code = $LOINC#41653-7 "Glucose [Mass/volume] in Capillary blood by Glucometer"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T14:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/DexcomG7Device)

// Main glucose reading
* valueQuantity = 118 'mg/dL' "milligrams per deciliter"

// Interpretation
* interpretation = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#in-range "In Range"

// Trend arrow
* component[trendArrow].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#cgm-trend "Trend Arrow"
* component[trendArrow].valueCodeableConcept = LifestyleMedicineTemporaryCS#cgm-trend-stable "Stable"

// Time in Range (daily summary) - LOINC 97510-2 (verified 2026-02-24)
* component[timeInRange].code = http://loinc.org#97510-2 "Glucose measurements in range out of Total glucose measurements during reporting period"
* component[timeInRange].valueQuantity = 78 '%' "percent"

// Mean glucose
// NOTE: 97507-8 ("Average glucose in Interstitial fluid") available but kept as custom
// because CGM "mean glucose" may include non-interstitial derived values in some implementations
* component[meanGlucose].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mean "Mean Glucose"
* component[meanGlucose].valueQuantity = 125 'mg/dL' "milligrams per deciliter"

// Coefficient of variation
* component[coefficientOfVariation].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#cv "Coefficient of Variation"
* component[coefficientOfVariation].valueQuantity = 28 '%' "percent"

// GMI (Glucose Management Indicator) - LOINC 97506-0 (verified 2026-02-24)
* component[gmi].code = http://loinc.org#97506-0 "Glucose management indicator"
* component[gmi].valueQuantity = 6.4 '%' "percent"

* note.text = "14-day CGM summary. TIR target >70% achieved. CV <36% indicates stable glucose patterns."


// ============================================================================
// CGM Device Example
// ============================================================================

Instance: DexcomG7Device
InstanceOf: Device
Usage: #example
Title: "Dexcom G7 CGM Device"
Description: "Example of a Dexcom G7 continuous glucose monitoring device"

* deviceName[0].name = "Dexcom G7"
* deviceName[0].type = #user-friendly-name
* manufacturer = "Dexcom, Inc."
* modelNumber = "G7"
* type = $SCT#5159002 "Physiologic monitoring system"


// ============================================================================
// Inflammatory Marker Observation Example
// ============================================================================

Instance: InflammatoryMarkerExample
InstanceOf: InflammatoryMarkerObservation
Usage: #example
Title: "High-Sensitivity CRP Example"
Description: "Example of hs-CRP inflammatory marker measurement"

* status = #final
* category = $ObsCat#laboratory "Laboratory"
* code = $LOINC#30522-7 "C reactive protein [Mass/volume] in Serum or Plasma by High sensitivity method"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T07:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* valueQuantity = 1.8 'mg/L' "milligrams per liter"

* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"

* referenceRange.low = 0 'mg/L'
* referenceRange.high = 3 'mg/L'
* referenceRange.text = "Low cardiovascular risk: <1.0 mg/L; Average risk: 1.0-3.0 mg/L; High risk: >3.0 mg/L"

* note.text = "hs-CRP in average cardiovascular risk range. Consider lifestyle interventions to reduce inflammation."

// =============================================================================
// Semantic Anchoring Example - CGM CV with LOINC LP Part Code
// =============================================================================
// LP431369-0 "Coefficient of variation" is a LOINC Part (Component axis).
// While LOINC 76644-4 covers RR-interval CV%, no observation code exists for
// glucose CV% from continuous glucose monitoring.
// =============================================================================

Instance: CGMCoefficientOfVariationDualCodingExample
InstanceOf: Observation
Usage: #example
Title: "CGM Coefficient of Variation - Semantic Anchoring (LP Dual-Coding)"
Description: "CGM glucose coefficient of variation with semantic anchoring via LOINC LP Part code"

* status = #final
* category = $ObsCat#exam "Exam"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-02-25T08:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#cv "Coefficient of Variation"
* code.coding[1] = $LOINC#LP431369-0 "Coefficient of variation"
* code.text = "Glucose coefficient of variation"

* valueQuantity = 28 '%' "percent"
* note.text = "14-day glucose CV. Target <36% per Battelino 2019 consensus. LOINC LP431369-0 is a Part code — no observation code exists for glucose-specific CV from CGM devices."
