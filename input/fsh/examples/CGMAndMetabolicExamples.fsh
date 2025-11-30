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
* device = Reference(Device/DexcomG7Device)

// Main glucose reading
* valueQuantity = 118 'mg/dL' "milligrams per deciliter"

// Interpretation
* interpretation = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-glucose-interpretation-cs#in-range "In Range"

// Trend arrow
* component[trendArrow].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-metrics-cs#trend "Trend Arrow"
* component[trendArrow].valueCodeableConcept = CGMTrendArrowCS#stable "Stable"

// Time in Range (daily summary)
* component[timeInRange].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-metrics-cs#tir "Time in Range"
* component[timeInRange].valueQuantity = 78 '%' "percent"

// Mean glucose
* component[meanGlucose].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-metrics-cs#mean "Mean Glucose"
* component[meanGlucose].valueQuantity = 125 'mg/dL' "milligrams per deciliter"

// Coefficient of variation
* component[coefficientOfVariation].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-metrics-cs#cv "Coefficient of Variation"
* component[coefficientOfVariation].valueQuantity = 28 '%' "percent"

// GMI (Glucose Management Indicator)
* component[gmi].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-metrics-cs#gmi "Glucose Management Indicator"
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
* type = $SCT#5159002 "Physiologic monitoring system (physical object)"


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
