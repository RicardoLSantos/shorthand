// Operational ConceptMap: Vendor Proprietary Codes → LOINC
// Created: 2024-11-21
// Purpose: Map wearable device vendor codes to standard LOINC terminology
// Vendors: Apple HealthKit, Fitbit, Garmin, Polar, Oura Ring
// Critical Finding: 0% vendor LOINC adoption - all use proprietary codes

Instance: ConceptMapVendorToLOINC
InstanceOf: ConceptMap
Title: "Vendor Proprietary Codes to LOINC Mapping"
Description: "Maps wearable device vendor codes to equivalent LOINC codes for semantic interoperability. Addresses critical gap: none of the 11 major vendors use LOINC codes natively. Enables $translate operations for vendor data normalization."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapVendorToLOINC"
* version = "0.1.0"
* name = "ConceptMapVendorToLOINC"
* title = "Vendor Proprietary Codes to LOINC Mapping"
* status = #active
* experimental = false
* date = "2024-11-21"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* description = "Operational ConceptMap for translating proprietary wearable device codes to LOINC standard terminology. Based on gray literature analysis of 75 sources documenting 11 major vendors with 0% LOINC adoption rate."
* purpose = "Enables semantic interoperability between vendor-specific wearable device data and EHR systems using LOINC. Critical for multi-vendor data aggregation in Learning Health Systems and lifestyle medicine research."

// ARCHITECTURAL NOTE (2025-11-27):
// sourceCanonical/targetCanonical REMOVED per thesis semantic hierarchy decision (Opção B)
//
// Rationale: Vendor codes are NOT clinical terminology - they are proprietary identifiers.
// Per thesis Chapter 5: "ConceptMaps são para tradução entre sistemas, NÃO para substituir
// terminologia padrão."
//
// - Profiles bind directly to LOINC (Semantic Layer - Level 1)
// - ConceptMaps handle vendor→LOINC translation (Infrastructure Layer)
// - ValueSets should NOT contain vendor codes (archived: ValueSetVendorCodes.fsh)
//
// See: /input/fsh/archive/README.md for full decision rationale
// NOTE: targetCanonical removed - LOINC is a CodeSystem, not a ValueSet
// Group-level target references are used instead (group[x].target = "http://loinc.org")

// =============================================================================
// GROUP 1: Apple HealthKit → LOINC
// =============================================================================
* group[0].source = "https://developer.apple.com/documentation/healthkit"
* group[0].target = "http://loinc.org"

// HRV - CRITICAL VENDOR ERROR DOCUMENTED
* group[0].element[0].code = #HKQuantityTypeIdentifierHeartRateVariabilitySDNN
* group[0].element[0].display = "Heart Rate Variability SDNN"
* group[0].element[0].target[0].code = #80404-7
* group[0].element[0].target[0].display = "R-R interval.standard deviation (Heart rate variability)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "CRITICAL VENDOR ERROR: Apple mislabels this metric. Despite the identifier name containing 'SDNN', Apple Watch actually measures and returns RMSSD (Root Mean Square of Successive Differences), NOT SDNN. This is a well-documented naming error in Apple's HealthKit API. Implementers must map to LOINC 80404-7 but understand the actual metric is RMSSD. See: Hernando et al. 2018, Sensors 18(8):2619."

// Heart Rate
* group[0].element[1].code = #HKQuantityTypeIdentifierHeartRate
* group[0].element[1].display = "Heart Rate"
* group[0].element[1].target[0].code = #8867-4
* group[0].element[1].target[0].display = "Heart rate"
* group[0].element[1].target[0].equivalence = #equivalent

// Resting Heart Rate
* group[0].element[2].code = #HKQuantityTypeIdentifierRestingHeartRate
* group[0].element[2].display = "Resting Heart Rate"
* group[0].element[2].target[0].code = #40443-4
* group[0].element[2].target[0].display = "Heart rate --resting"
* group[0].element[2].target[0].equivalence = #equivalent

// Step Count
* group[0].element[3].code = #HKQuantityTypeIdentifierStepCount
* group[0].element[3].display = "Step Count"
* group[0].element[3].target[0].code = #55423-8
* group[0].element[3].target[0].display = "Number of steps in 24 hour Measured"
* group[0].element[3].target[0].equivalence = #equivalent

// Walking + Running Distance
* group[0].element[4].code = #HKQuantityTypeIdentifierDistanceWalkingRunning
* group[0].element[4].display = "Walking + Running Distance"
* group[0].element[4].target[0].code = #41950-7
* group[0].element[4].target[0].display = "Number of steps"
* group[0].element[4].target[0].equivalence = #wider
* group[0].element[4].target[0].comment = "Distance is wider concept than step count; approximate mapping"

// Oxygen Saturation
* group[0].element[5].code = #HKQuantityTypeIdentifierOxygenSaturation
* group[0].element[5].display = "Oxygen Saturation"
* group[0].element[5].target[0].code = #2708-6
* group[0].element[5].target[0].display = "Oxygen saturation in Arterial blood"
* group[0].element[5].target[0].equivalence = #equivalent

// Respiratory Rate
* group[0].element[6].code = #HKQuantityTypeIdentifierRespiratoryRate
* group[0].element[6].display = "Respiratory Rate"
* group[0].element[6].target[0].code = #9279-1
* group[0].element[6].target[0].display = "Respiratory rate"
* group[0].element[6].target[0].equivalence = #equivalent

// Body Mass
* group[0].element[7].code = #HKQuantityTypeIdentifierBodyMass
* group[0].element[7].display = "Body Mass"
* group[0].element[7].target[0].code = #29463-7
* group[0].element[7].target[0].display = "Body weight"
* group[0].element[7].target[0].equivalence = #equivalent

// Height
* group[0].element[8].code = #HKQuantityTypeIdentifierHeight
* group[0].element[8].display = "Height"
* group[0].element[8].target[0].code = #8302-2
* group[0].element[8].target[0].display = "Body height"
* group[0].element[8].target[0].equivalence = #equivalent

// Body Mass Index
* group[0].element[9].code = #HKQuantityTypeIdentifierBodyMassIndex
* group[0].element[9].display = "Body Mass Index"
* group[0].element[9].target[0].code = #39156-5
* group[0].element[9].target[0].display = "Body mass index (BMI) [Ratio]"
* group[0].element[9].target[0].equivalence = #equivalent

// =============================================================================
// GROUP 2: Fitbit API → LOINC
// =============================================================================
* group[1].source = "https://dev.fitbit.com/build/reference/web-api"
* group[1].target = "http://loinc.org"

// Daily RMSSD
* group[1].element[0].code = #activities-heart-hrv-dailyRmssd
* group[1].element[0].display = "Daily RMSSD"
* group[1].element[0].target[0].equivalence = #unmatched
* group[1].element[0].target[0].comment = "Fitbit correctly labels RMSSD (unlike Apple). However, NO LOINC code exists for RMSSD as of November 2024. Maps conceptually to parasympathetic activity. Fitbit API: GET /1/user/-/hrv/date/{date}.json"

// Daily Steps
* group[1].element[1].code = #activities-steps
* group[1].element[1].display = "Daily Steps"
* group[1].element[1].target[0].code = #55423-8
* group[1].element[1].target[0].display = "Number of steps in 24 hour Measured"
* group[1].element[1].target[0].equivalence = #equivalent

// Resting Heart Rate
* group[1].element[2].code = #activities-heart-restingHeartRate
* group[1].element[2].display = "Resting Heart Rate"
* group[1].element[2].target[0].code = #40443-4
* group[1].element[2].target[0].display = "Heart rate --resting"
* group[1].element[2].target[0].equivalence = #equivalent

// Sleep Efficiency
* group[1].element[3].code = #sleep-efficiency
* group[1].element[3].display = "Sleep Efficiency"
* group[1].element[3].target[0].code = #93832-4
* group[1].element[3].target[0].display = "Sleep efficiency"
* group[1].element[3].target[0].equivalence = #equivalent

// =============================================================================
// GROUP 3: Garmin Health API → LOINC
// =============================================================================
* group[2].source = "https://developer.garmin.com/health-api"
* group[2].target = "http://loinc.org"

// Daily Steps
* group[2].element[0].code = #dailySteps
* group[2].element[0].display = "Daily Steps"
* group[2].element[0].target[0].code = #55423-8
* group[2].element[0].target[0].display = "Number of steps in 24 hour Measured"
* group[2].element[0].target[0].equivalence = #equivalent

// Resting Heart Rate
* group[2].element[1].code = #restingHeartRate
* group[2].element[1].display = "Resting Heart Rate"
* group[2].element[1].target[0].code = #40443-4
* group[2].element[1].target[0].display = "Heart rate --resting"
* group[2].element[1].target[0].equivalence = #equivalent

// Max Heart Rate
* group[2].element[2].code = #maxHeartRate
* group[2].element[2].display = "Maximum Heart Rate"
* group[2].element[2].target[0].code = #8889-8
* group[2].element[2].target[0].display = "Heart rate 24 hour maximum"
* group[2].element[2].target[0].equivalence = #equivalent

// SpO2
* group[2].element[3].code = #avgSpo2
* group[2].element[3].display = "Average SpO2"
* group[2].element[3].target[0].code = #2708-6
* group[2].element[3].target[0].display = "Oxygen saturation in Arterial blood"
* group[2].element[3].target[0].equivalence = #equivalent

// =============================================================================
// GROUP 4: Polar AccessLink API → LOINC
// =============================================================================
* group[3].source = "https://www.polaraccesslink.com/v3"
* group[3].target = "http://loinc.org"

// Heart Rate (from exercise transactions)
* group[3].element[0].code = #heart-rate
* group[3].element[0].display = "Heart Rate"
* group[3].element[0].target[0].code = #8867-4
* group[3].element[0].target[0].display = "Heart rate"
* group[3].element[0].target[0].equivalence = #equivalent
* group[3].element[0].target[0].comment = "Polar H10 chest strap provides ECG-quality heart rate. Gold standard for wearable HRV measurement."

// RR Intervals (raw)
* group[3].element[1].code = #rr-intervals
* group[3].element[1].display = "RR Intervals"
* group[3].element[1].target[0].code = #8636-3
* group[3].element[1].target[0].display = "R-R interval in EKG"
* group[3].element[1].target[0].equivalence = #equivalent

// =============================================================================
// GROUP 5: Oura Ring API → LOINC
// =============================================================================
* group[4].source = "https://cloud.ouraring.com/v2/usercollection"
* group[4].target = "http://loinc.org"

// HRV Balance (Proprietary Score)
* group[4].element[0].code = #hrv_balance
* group[4].element[0].display = "HRV Balance Score"
* group[4].element[0].target[0].equivalence = #unmatched
* group[4].element[0].target[0].comment = "Oura's proprietary HRV score (0-100). NOT raw RMSSD or SDNN. Derived from nocturnal RMSSD but normalized to individual baseline. No direct LOINC equivalent - this is a processed/scored metric, not a physiological measurement."

// Resting Heart Rate
* group[4].element[1].code = #hr_lowest
* group[4].element[1].display = "Lowest Heart Rate (overnight)"
* group[4].element[1].target[0].code = #8891-4
* group[4].element[1].target[0].display = "Heart rate 24 hour minimum"
* group[4].element[1].target[0].equivalence = #equivalent

// Average Heart Rate
* group[4].element[2].code = #hr_average
* group[4].element[2].display = "Average Heart Rate (overnight)"
* group[4].element[2].target[0].code = #8890-6
* group[4].element[2].target[0].display = "Heart rate 24 hour mean"
* group[4].element[2].target[0].equivalence = #narrower
* group[4].element[2].target[0].comment = "Oura measures overnight only, not full 24 hours"

// Respiratory Rate
* group[4].element[3].code = #breathing_rate
* group[4].element[3].display = "Breathing Rate (overnight)"
* group[4].element[3].target[0].code = #9279-1
* group[4].element[3].target[0].display = "Respiratory rate"
* group[4].element[3].target[0].equivalence = #equivalent
