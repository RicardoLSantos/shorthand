// Continuous Glucose Monitoring (CGM) FHIR Profile for iOS Lifestyle Medicine IG
// Based on openEHR archetype blood_glucose_cgm.v0
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos, FMUP
// Reference: Battelino T, et al. Clinical Targets for CGM Data Interpretation. Diabetes Care 2019

Alias: $LOINC = http://loinc.org
Alias: $SNOMED = http://snomed.info/sct
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

// ============================================================================
// CGM OBSERVATION PROFILE
// ============================================================================

Profile: CGMObservation
Parent: Observation
Id: cgm-observation
Title: "Continuous Glucose Monitoring (CGM) Observation Profile"
Description: "Profile for recording continuous glucose monitoring data from consumer and medical-grade CGM devices. Supports real-time glucose, trend arrows, Time in Range (TIR), and glycemic variability metrics per International Consensus (Battelino 2019). Aligned with openEHR archetype blood_glucose_cgm.v0."

* status MS
* category 1..1 MS
* category = $ObsCat#exam "Exam"
* code 1..1 MS
* code = $LOINC#41653-7 "Glucose [Mass/volume] in Capillary blood by Glucometer"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] only dateTime
* effectiveDateTime 1..1 MS
* device 0..1 MS
* device only Reference(Device)
* note 0..*

// Main glucose value
* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code from CGMGlucoseUnitVS (required)
* valueQuantity 0..1 MS

* interpretation 0..1
* interpretation from CGMGlucoseInterpretationVS (required)

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^slicing.description = "Slice based on the component code"

* component contains
    trendArrow 0..1 MS and
    rateOfChange 0..1 and
    timeInRange 0..1 MS and
    timeBelowRange 0..1 and
    timeBelowRangeL2 0..1 and
    timeAboveRange 0..1 and
    timeAboveRangeL2 0..1 and
    meanGlucose 0..1 MS and
    glucoseSD 0..1 and
    coefficientOfVariation 0..1 MS and
    gmi 0..1 MS and
    hypoEvents 0..1 and
    hyperEvents 0..1 and
    sensorActiveTime 0..1 and
    targetRangeLower 0..1 and
    targetRangeUpper 0..1 and
    cgmSystem 0..1 and
    sensorInsertionSite 0..1 and
    daysSinceSensorInsertion 0..1

// ============================================================================
// TREND AND RATE OF CHANGE
// ============================================================================

* component[trendArrow].code = LifestyleMedicineTemporaryCS#cgm-trend "Trend Arrow"
* component[trendArrow].value[x] only CodeableConcept
* component[trendArrow].valueCodeableConcept from CGMTrendArrowVS (required)

* component[rateOfChange].code = LifestyleMedicineTemporaryCS#roc "Rate of Change"
* component[rateOfChange].value[x] only Quantity
* component[rateOfChange].valueQuantity.system = $UCUM
* component[rateOfChange].valueQuantity.code = #mg/dL/min

// ============================================================================
// TIME IN RANGE METRICS (International Consensus 2019)
// ============================================================================

// LOINC 97510-2 verified via Athena 2026-02-24 (concept_id: see CGM family 9750x)
// Replaces custom LifestyleMedicineTemporaryCS#tir — LOINC covers "Glucose measurements in range"
* component[timeInRange].code = $LOINC#97510-2 "Glucose measurements in range out of Total glucose measurements during reporting period"
* component[timeInRange].value[x] only Quantity
* component[timeInRange].valueQuantity.system = $UCUM
* component[timeInRange].valueQuantity.code = #%
* component[timeInRange] ^short = "Target: >70% for most adults with diabetes"

* component[timeBelowRange].code = LifestyleMedicineTemporaryCS#tbr "Time Below Range"
* component[timeBelowRange].value[x] only Quantity
* component[timeBelowRange].valueQuantity.system = $UCUM
* component[timeBelowRange].valueQuantity.code = #%
* component[timeBelowRange] ^short = "Target: <4% (<70 mg/dL)"

* component[timeBelowRangeL2].code = LifestyleMedicineTemporaryCS#tbr-l2 "Time Below Range Level 2"
* component[timeBelowRangeL2].value[x] only Quantity
* component[timeBelowRangeL2].valueQuantity.system = $UCUM
* component[timeBelowRangeL2].valueQuantity.code = #%
* component[timeBelowRangeL2] ^short = "Target: <1% (<54 mg/dL severe hypo)"

* component[timeAboveRange].code = LifestyleMedicineTemporaryCS#tar "Time Above Range"
* component[timeAboveRange].value[x] only Quantity
* component[timeAboveRange].valueQuantity.system = $UCUM
* component[timeAboveRange].valueQuantity.code = #%
* component[timeAboveRange] ^short = "Target: <25% (>180 mg/dL)"

* component[timeAboveRangeL2].code = LifestyleMedicineTemporaryCS#tar-l2 "Time Above Range Level 2"
* component[timeAboveRangeL2].value[x] only Quantity
* component[timeAboveRangeL2].valueQuantity.system = $UCUM
* component[timeAboveRangeL2].valueQuantity.code = #%
* component[timeAboveRangeL2] ^short = "Target: <5% (>250 mg/dL severe hyper)"

// ============================================================================
// GLYCEMIC VARIABILITY
// ============================================================================

* component[meanGlucose].code = LifestyleMedicineTemporaryCS#mean "Mean Glucose"
* component[meanGlucose].value[x] only Quantity
* component[meanGlucose].valueQuantity.system = $UCUM
* component[meanGlucose].valueQuantity.code = #mg/dL

// LOINC 97505-2 verified via Athena 2026-02-24 (concept_id: CGM family 9750x)
// Replaces custom LifestyleMedicineTemporaryCS#sd — LOINC covers "Glucose standard deviation Calculated"
* component[glucoseSD].code = $LOINC#97505-2 "Glucose standard deviation Calculated"
* component[glucoseSD].value[x] only Quantity
* component[glucoseSD].valueQuantity.system = $UCUM
* component[glucoseSD].valueQuantity.code = #mg/dL

* component[coefficientOfVariation].code = LifestyleMedicineTemporaryCS#cv "Coefficient of Variation"
* component[coefficientOfVariation].value[x] only Quantity
* component[coefficientOfVariation].valueQuantity.system = $UCUM
* component[coefficientOfVariation].valueQuantity.code = #%
* component[coefficientOfVariation] ^short = "Target: <36% indicates stable glycemia"

// LOINC 97506-0 verified via Athena 2026-02-24 (concept_id 1617515)
// Replaces custom LifestyleMedicineTemporaryCS#gmi — audit confirmed direct LOINC mapping exists
* component[gmi].code = $LOINC#97506-0 "Glucose management indicator"
* component[gmi].value[x] only Quantity
* component[gmi].valueQuantity.system = $UCUM
* component[gmi].valueQuantity.code = #%
* component[gmi] ^short = "Estimated HbA1c from CGM data"

// ============================================================================
// GLYCEMIC EVENTS
// ============================================================================

* component[hypoEvents].code = LifestyleMedicineTemporaryCS#hypo-events "Hypoglycemia Events"
* component[hypoEvents].value[x] only integer
* component[hypoEvents] ^short = "Number of hypoglycemia episodes"

* component[hyperEvents].code = LifestyleMedicineTemporaryCS#hyper-events "Hyperglycemia Events"
* component[hyperEvents].value[x] only integer
* component[hyperEvents] ^short = "Number of hyperglycemia episodes"

// ============================================================================
// SENSOR AND DATA QUALITY
// ============================================================================

// LOINC 97504-5 verified via Athena 2026-02-24 (concept_id: CGM family 9750x)
// Replaces custom LifestyleMedicineTemporaryCS#cgm-active-time — LOINC covers "Percent sensor usage"
* component[sensorActiveTime].code = $LOINC#97504-5 "Percent sensor usage"
* component[sensorActiveTime].value[x] only Quantity
* component[sensorActiveTime].valueQuantity.system = $UCUM
* component[sensorActiveTime].valueQuantity.code = #%
* component[sensorActiveTime] ^short = "Target: >70% for reliable metrics"

* component[targetRangeLower].code = LifestyleMedicineTemporaryCS#range-low "Target Range Lower"
* component[targetRangeLower].value[x] only Quantity
* component[targetRangeLower].valueQuantity.system = $UCUM
* component[targetRangeLower].valueQuantity.code = #mg/dL
* component[targetRangeLower] ^short = "Default: 70 mg/dL"

* component[targetRangeUpper].code = LifestyleMedicineTemporaryCS#range-high "Target Range Upper"
* component[targetRangeUpper].value[x] only Quantity
* component[targetRangeUpper].valueQuantity.system = $UCUM
* component[targetRangeUpper].valueQuantity.code = #mg/dL
* component[targetRangeUpper] ^short = "Default: 180 mg/dL"

// ============================================================================
// DEVICE INFORMATION
// ============================================================================

* component[cgmSystem].code = LifestyleMedicineTemporaryCS#system "CGM System"
* component[cgmSystem].value[x] only CodeableConcept
* component[cgmSystem].valueCodeableConcept from CGMSystemVS (required)

* component[sensorInsertionSite].code = LifestyleMedicineTemporaryCS#site "Insertion Site"
* component[sensorInsertionSite].value[x] only CodeableConcept
* component[sensorInsertionSite].valueCodeableConcept from CGMInsertionSiteVS (required)

* component[daysSinceSensorInsertion].code = LifestyleMedicineTemporaryCS#sensor-days "Sensor Days"
* component[daysSinceSensorInsertion].value[x] only integer
ValueSet: CGMGlucoseUnitVS
Id: cgm-glucose-unit-vs
Title: "CGM Glucose Unit ValueSet"
Description: "Units for glucose measurement"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cgm-glucose-unit-vs"
* ^status = #active
* ^experimental = false
* include $UCUM#mg/dL "milligrams per deciliter"
* include $UCUM#mmol/L "millimoles per liter"


ValueSet: CGMGlucoseInterpretationVS
Id: cgm-glucose-interpretation-vs
Title: "CGM Glucose Interpretation ValueSet"
Description: "Categorical interpretation of glucose values per International Consensus"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cgm-glucose-interpretation-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: CGMTrendArrowVS
Id: cgm-trend-arrow-vs
Title: "CGM Trend Arrow ValueSet"
Description: "Direction and rate of glucose change"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cgm-trend-arrow-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: CGMSystemVS
Id: cgm-system-vs
Title: "CGM System ValueSet"
Description: "CGM devices and systems"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cgm-system-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: CGMInsertionSiteVS
Id: cgm-insertion-site-vs
Title: "CGM Insertion Site ValueSet"
Description: "Body sites for CGM sensor insertion"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cgm-insertion-site-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS
