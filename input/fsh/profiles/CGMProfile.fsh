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

* component[trendArrow].code = CGMMetricsCS#trend "Trend Arrow"
* component[trendArrow].value[x] only CodeableConcept
* component[trendArrow].valueCodeableConcept from CGMTrendArrowVS (required)

* component[rateOfChange].code = CGMMetricsCS#roc "Rate of Change"
* component[rateOfChange].value[x] only Quantity
* component[rateOfChange].valueQuantity.system = $UCUM
* component[rateOfChange].valueQuantity.code = #mg/dL/min

// ============================================================================
// TIME IN RANGE METRICS (International Consensus 2019)
// ============================================================================

* component[timeInRange].code = CGMMetricsCS#tir "Time in Range"
* component[timeInRange].value[x] only Quantity
* component[timeInRange].valueQuantity.system = $UCUM
* component[timeInRange].valueQuantity.code = #%
* component[timeInRange] ^short = "Target: >70% for most adults with diabetes"

* component[timeBelowRange].code = CGMMetricsCS#tbr "Time Below Range"
* component[timeBelowRange].value[x] only Quantity
* component[timeBelowRange].valueQuantity.system = $UCUM
* component[timeBelowRange].valueQuantity.code = #%
* component[timeBelowRange] ^short = "Target: <4% (<70 mg/dL)"

* component[timeBelowRangeL2].code = CGMMetricsCS#tbr-l2 "Time Below Range Level 2"
* component[timeBelowRangeL2].value[x] only Quantity
* component[timeBelowRangeL2].valueQuantity.system = $UCUM
* component[timeBelowRangeL2].valueQuantity.code = #%
* component[timeBelowRangeL2] ^short = "Target: <1% (<54 mg/dL severe hypo)"

* component[timeAboveRange].code = CGMMetricsCS#tar "Time Above Range"
* component[timeAboveRange].value[x] only Quantity
* component[timeAboveRange].valueQuantity.system = $UCUM
* component[timeAboveRange].valueQuantity.code = #%
* component[timeAboveRange] ^short = "Target: <25% (>180 mg/dL)"

* component[timeAboveRangeL2].code = CGMMetricsCS#tar-l2 "Time Above Range Level 2"
* component[timeAboveRangeL2].value[x] only Quantity
* component[timeAboveRangeL2].valueQuantity.system = $UCUM
* component[timeAboveRangeL2].valueQuantity.code = #%
* component[timeAboveRangeL2] ^short = "Target: <5% (>250 mg/dL severe hyper)"

// ============================================================================
// GLYCEMIC VARIABILITY
// ============================================================================

* component[meanGlucose].code = CGMMetricsCS#mean "Mean Glucose"
* component[meanGlucose].value[x] only Quantity
* component[meanGlucose].valueQuantity.system = $UCUM
* component[meanGlucose].valueQuantity.code = #mg/dL

* component[glucoseSD].code = CGMMetricsCS#sd "Standard Deviation"
* component[glucoseSD].value[x] only Quantity
* component[glucoseSD].valueQuantity.system = $UCUM
* component[glucoseSD].valueQuantity.code = #mg/dL

* component[coefficientOfVariation].code = CGMMetricsCS#cv "Coefficient of Variation"
* component[coefficientOfVariation].value[x] only Quantity
* component[coefficientOfVariation].valueQuantity.system = $UCUM
* component[coefficientOfVariation].valueQuantity.code = #%
* component[coefficientOfVariation] ^short = "Target: <36% indicates stable glycemia"

* component[gmi].code = CGMMetricsCS#gmi "Glucose Management Indicator"
* component[gmi].value[x] only Quantity
* component[gmi].valueQuantity.system = $UCUM
* component[gmi].valueQuantity.code = #%
* component[gmi] ^short = "Estimated HbA1c from CGM data"

// ============================================================================
// GLYCEMIC EVENTS
// ============================================================================

* component[hypoEvents].code = CGMMetricsCS#hypo-events "Hypoglycemia Events"
* component[hypoEvents].value[x] only integer
* component[hypoEvents] ^short = "Number of hypoglycemia episodes"

* component[hyperEvents].code = CGMMetricsCS#hyper-events "Hyperglycemia Events"
* component[hyperEvents].value[x] only integer
* component[hyperEvents] ^short = "Number of hyperglycemia episodes"

// ============================================================================
// SENSOR AND DATA QUALITY
// ============================================================================

* component[sensorActiveTime].code = CGMMetricsCS#active-time "Sensor Active Time"
* component[sensorActiveTime].value[x] only Quantity
* component[sensorActiveTime].valueQuantity.system = $UCUM
* component[sensorActiveTime].valueQuantity.code = #%
* component[sensorActiveTime] ^short = "Target: >70% for reliable metrics"

* component[targetRangeLower].code = CGMMetricsCS#range-low "Target Range Lower"
* component[targetRangeLower].value[x] only Quantity
* component[targetRangeLower].valueQuantity.system = $UCUM
* component[targetRangeLower].valueQuantity.code = #mg/dL
* component[targetRangeLower] ^short = "Default: 70 mg/dL"

* component[targetRangeUpper].code = CGMMetricsCS#range-high "Target Range Upper"
* component[targetRangeUpper].value[x] only Quantity
* component[targetRangeUpper].valueQuantity.system = $UCUM
* component[targetRangeUpper].valueQuantity.code = #mg/dL
* component[targetRangeUpper] ^short = "Default: 180 mg/dL"

// ============================================================================
// DEVICE INFORMATION
// ============================================================================

* component[cgmSystem].code = CGMMetricsCS#system "CGM System"
* component[cgmSystem].value[x] only CodeableConcept
* component[cgmSystem].valueCodeableConcept from CGMSystemVS (required)

* component[sensorInsertionSite].code = CGMMetricsCS#site "Insertion Site"
* component[sensorInsertionSite].value[x] only CodeableConcept
* component[sensorInsertionSite].valueCodeableConcept from CGMInsertionSiteVS (required)

* component[daysSinceSensorInsertion].code = CGMMetricsCS#sensor-days "Sensor Days"
* component[daysSinceSensorInsertion].value[x] only integer


// ============================================================================
// CGM METRICS CODE SYSTEM
// ============================================================================

CodeSystem: CGMMetricsCS
Id: cgm-metrics-cs
Title: "CGM Metrics CodeSystem"
Description: "CodeSystem for continuous glucose monitoring metrics"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-metrics-cs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-28"
* ^publisher = "Ricardo Lourenco dos Santos, FMUP"
* ^caseSensitive = true
* ^content = #complete

// Trend and rate
* #trend "Trend Arrow" "Direction and rate of glucose change"
* #roc "Rate of Change" "Numeric rate of glucose change per minute"

// Time in Range
* #tir "Time in Range" "Percentage of time glucose is within target range (70-180 mg/dL)"
* #tbr "Time Below Range" "Percentage of time glucose is below target (<70 mg/dL)"
* #tbr-l1 "Time Below Range Level 1" "Percentage of time in Level 1 hypoglycemia (54-69 mg/dL)"
* #tbr-l2 "Time Below Range Level 2" "Percentage of time in Level 2 hypoglycemia (<54 mg/dL)"
* #tar "Time Above Range" "Percentage of time glucose is above target (>180 mg/dL)"
* #tar-l1 "Time Above Range Level 1" "Percentage of time in Level 1 hyperglycemia (181-250 mg/dL)"
* #tar-l2 "Time Above Range Level 2" "Percentage of time in Level 2 hyperglycemia (>250 mg/dL)"

// Variability
* #mean "Mean Glucose" "Average glucose over reporting period"
* #sd "Standard Deviation" "Standard deviation of glucose values"
* #cv "Coefficient of Variation" "CV = SD/Mean x 100, target <36%"
* #gmi "Glucose Management Indicator" "Estimated HbA1c from CGM glucose"

// Events
* #hypo-events "Hypoglycemia Events" "Number of hypoglycemia episodes"
* #hyper-events "Hyperglycemia Events" "Number of hyperglycemia episodes"

// Data quality
* #active-time "Sensor Active Time" "Percentage of time sensor was recording"
* #range-low "Target Range Lower" "Lower bound of target glucose range"
* #range-high "Target Range Upper" "Upper bound of target glucose range"

// Device
* #system "CGM System" "Specific CGM device or system"
* #site "Insertion Site" "Body site where sensor is inserted"
* #sensor-days "Sensor Days" "Days since sensor insertion"


// ============================================================================
// CGM VALUE SETS
// ============================================================================

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
* include codes from system CGMGlucoseInterpretationCS


ValueSet: CGMTrendArrowVS
Id: cgm-trend-arrow-vs
Title: "CGM Trend Arrow ValueSet"
Description: "Direction and rate of glucose change"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cgm-trend-arrow-vs"
* ^status = #active
* ^experimental = false
* include codes from system CGMTrendArrowCS


ValueSet: CGMSystemVS
Id: cgm-system-vs
Title: "CGM System ValueSet"
Description: "CGM devices and systems"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cgm-system-vs"
* ^status = #active
* ^experimental = false
* include codes from system CGMSystemCS


ValueSet: CGMInsertionSiteVS
Id: cgm-insertion-site-vs
Title: "CGM Insertion Site ValueSet"
Description: "Body sites for CGM sensor insertion"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cgm-insertion-site-vs"
* ^status = #active
* ^experimental = false
* include codes from system CGMInsertionSiteCS


// ============================================================================
// SUPPORTING CODE SYSTEMS
// ============================================================================

CodeSystem: CGMGlucoseInterpretationCS
Id: cgm-glucose-interpretation-cs
Title: "CGM Glucose Interpretation CodeSystem"
Description: "Categorical interpretation of glucose values"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-glucose-interpretation-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #severe-hypo "Severe Hypoglycemia" "<54 mg/dL (<3.0 mmol/L)"
* #hypo "Hypoglycemia" "54-69 mg/dL (3.0-3.8 mmol/L)"
* #in-range "In Range" "70-180 mg/dL (3.9-10.0 mmol/L)"
* #hyper "Hyperglycemia" "181-250 mg/dL (10.1-13.9 mmol/L)"
* #severe-hyper "Severe Hyperglycemia" ">250 mg/dL (>13.9 mmol/L)"


CodeSystem: CGMTrendArrowCS
Id: cgm-trend-arrow-cs
Title: "CGM Trend Arrow CodeSystem"
Description: "Direction and rate of glucose change"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-trend-arrow-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #falling-rapidly "Falling Rapidly" ">3 mg/dL/min downward"
* #falling "Falling" "2-3 mg/dL/min downward"
* #falling-slowly "Falling Slowly" "1-2 mg/dL/min downward"
* #stable "Stable" "<1 mg/dL/min change"
* #rising-slowly "Rising Slowly" "1-2 mg/dL/min upward"
* #rising "Rising" "2-3 mg/dL/min upward"
* #rising-rapidly "Rising Rapidly" ">3 mg/dL/min upward"
* #unknown "Unknown" "Trend direction not determined"


CodeSystem: CGMSystemCS
Id: cgm-system-cs
Title: "CGM System CodeSystem"
Description: "CGM devices and systems"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-system-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
// Medical-grade
* #dexcom-g6 "Dexcom G6" "Dexcom G6 CGM system"
* #dexcom-g7 "Dexcom G7" "Dexcom G7 CGM system"
* #dexcom-one "Dexcom ONE" "Dexcom ONE CGM system"
* #libre-2 "FreeStyle Libre 2" "Abbott FreeStyle Libre 2"
* #libre-3 "FreeStyle Libre 3" "Abbott FreeStyle Libre 3"
* #guardian-4 "Medtronic Guardian 4" "Medtronic Guardian 4 CGM"
* #eversense "Eversense" "Senseonics Eversense implantable CGM"
// Consumer/Wellness
* #levels "Levels" "Levels consumer CGM program"
* #nutrisense "Nutrisense" "Nutrisense consumer CGM"
* #supersapiens "Supersapiens" "Supersapiens athletic CGM"
* #veri "Veri" "Veri consumer CGM"
* #stelo "Stelo" "Dexcom Stelo consumer CGM"
* #lingo "Lingo" "Abbott Lingo consumer CGM"
* #other "Other" "Other CGM system"


CodeSystem: CGMInsertionSiteCS
Id: cgm-insertion-site-cs
Title: "CGM Insertion Site CodeSystem"
Description: "Body sites for CGM sensor insertion"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-insertion-site-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #upper-arm "Upper Arm" "Back of upper arm"
* #abdomen "Abdomen" "Abdominal area"
* #buttock "Buttock" "Buttock area"
* #thigh "Thigh" "Upper thigh"
* #other "Other" "Other insertion site"
