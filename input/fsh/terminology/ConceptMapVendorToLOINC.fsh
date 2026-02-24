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

// HRV - Apple correctly reports SDNN (CORRECTED 2026-01-07)
* group[0].element[0].code = #HKQuantityTypeIdentifierHeartRateVariabilitySDNN
* group[0].element[0].display = "Heart Rate Variability SDNN"
* group[0].element[0].target[0].code = #80404-7
* group[0].element[0].target[0].display = "R-R interval.standard deviation (Heart rate variability)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "VERIFIED 2026-01-07: Apple Watch correctly reports SDNN via HKQuantityTypeIdentifierHeartRateVariabilitySDNN. Note: RMSSD would be clinically preferable for short-term parasympathetic assessment (Shaffer 2017), but Apple chose to expose SDNN. Third-party apps can compute RMSSD from raw RR intervals. See: Hernando et al. 2018, Sensors 18(8):2619; Marco Altini analysis."

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

// -----------------------------------------------------------------------------
// NEW MAPPINGS FROM GRAY LITERATURE EXTRACTION (2026-01-12)
// Source: APPLE_HEALTH_COMPLETE_DATA_TYPES_20260112.md
// -----------------------------------------------------------------------------

// Blood Glucose
* group[0].element[10].code = #HKQuantityTypeIdentifierBloodGlucose
* group[0].element[10].display = "Blood Glucose"
* group[0].element[10].target[0].code = #2339-0
* group[0].element[10].target[0].display = "Glucose [Mass/volume] in Blood"
* group[0].element[10].target[0].equivalence = #equivalent

// Blood Pressure Systolic
* group[0].element[11].code = #HKQuantityTypeIdentifierBloodPressureSystolic
* group[0].element[11].display = "Systolic Blood Pressure"
* group[0].element[11].target[0].code = #8480-6
* group[0].element[11].target[0].display = "Systolic blood pressure"
* group[0].element[11].target[0].equivalence = #equivalent

// Blood Pressure Diastolic
* group[0].element[12].code = #HKQuantityTypeIdentifierBloodPressureDiastolic
* group[0].element[12].display = "Diastolic Blood Pressure"
* group[0].element[12].target[0].code = #8462-4
* group[0].element[12].target[0].display = "Diastolic blood pressure"
* group[0].element[12].target[0].equivalence = #equivalent

// Body Temperature
* group[0].element[13].code = #HKQuantityTypeIdentifierBodyTemperature
* group[0].element[13].display = "Body Temperature"
* group[0].element[13].target[0].code = #8310-5
* group[0].element[13].target[0].display = "Body temperature"
* group[0].element[13].target[0].equivalence = #equivalent

// Basal Body Temperature
* group[0].element[14].code = #HKQuantityTypeIdentifierBasalBodyTemperature
* group[0].element[14].display = "Basal Body Temperature"
* group[0].element[14].target[0].code = #8331-1
* group[0].element[14].target[0].display = "Oral temperature"
* group[0].element[14].target[0].equivalence = #narrower
* group[0].element[14].target[0].comment = "BBT is typically oral; LOINC 8331-1 is closest match. iOS 9.0+"

// Waist Circumference
* group[0].element[15].code = #HKQuantityTypeIdentifierWaistCircumference
* group[0].element[15].display = "Waist Circumference"
* group[0].element[15].target[0].code = #8280-0
* group[0].element[15].target[0].display = "Waist Circumference at umbilicus by Tape measure"
* group[0].element[15].target[0].equivalence = #equivalent
* group[0].element[15].target[0].comment = "iOS 11.0+"

// Body Fat Percentage
* group[0].element[16].code = #HKQuantityTypeIdentifierBodyFatPercentage
* group[0].element[16].display = "Body Fat Percentage"
* group[0].element[16].target[0].code = #41982-0
* group[0].element[16].target[0].display = "Percentage of body fat Measured"
* group[0].element[16].target[0].equivalence = #equivalent

// Lean Body Mass
* group[0].element[17].code = #HKQuantityTypeIdentifierLeanBodyMass
* group[0].element[17].display = "Lean Body Mass"
* group[0].element[17].target[0].equivalence = #unmatched
* group[0].element[17].target[0].comment = "GAP: No LOINC code for lean body mass. Clinical relevance for body composition assessment."

// Forced Vital Capacity
* group[0].element[18].code = #HKQuantityTypeIdentifierForcedVitalCapacity
* group[0].element[18].display = "Forced Vital Capacity"
* group[0].element[18].target[0].code = #19868-9
* group[0].element[18].target[0].display = "Forced vital capacity [Volume] Respiratory system"
* group[0].element[18].target[0].equivalence = #equivalent

// Forced Expiratory Volume 1 second
* group[0].element[19].code = #HKQuantityTypeIdentifierForcedExpiratoryVolume1
* group[0].element[19].display = "Forced Expiratory Volume (1 sec)"
* group[0].element[19].target[0].code = #20150-9
* group[0].element[19].target[0].display = "FEV1"
* group[0].element[19].target[0].equivalence = #equivalent

// Peak Expiratory Flow Rate
* group[0].element[20].code = #HKQuantityTypeIdentifierPeakExpiratoryFlowRate
* group[0].element[20].display = "Peak Expiratory Flow Rate"
* group[0].element[20].target[0].code = #19935-6
* group[0].element[20].target[0].display = "Maximum expiratory gas flow Respiratory system airway"
* group[0].element[20].target[0].equivalence = #equivalent

// VO2 Max
* group[0].element[21].code = #HKQuantityTypeIdentifierVO2Max
* group[0].element[21].display = "VO2 Max"
* group[0].element[21].target[0].equivalence = #unmatched
* group[0].element[21].target[0].comment = "GAP: No LOINC code for VO2max estimate from wearables. iOS 11.0+. Clinical relevance for cardiorespiratory fitness assessment."

// Walking Heart Rate Average
* group[0].element[22].code = #HKQuantityTypeIdentifierWalkingHeartRateAverage
* group[0].element[22].display = "Walking Heart Rate Average"
* group[0].element[22].target[0].equivalence = #unmatched
* group[0].element[22].target[0].comment = "GAP: No LOINC code for walking heart rate average. iOS 11.0+. Useful for fitness assessment."

// Heart Rate Recovery One Minute (iOS 16+)
* group[0].element[23].code = #HKQuantityTypeIdentifierHeartRateRecoveryOneMinute
* group[0].element[23].display = "Heart Rate Recovery (1 min)"
* group[0].element[23].target[0].equivalence = #unmatched
* group[0].element[23].target[0].comment = "GAP: No LOINC code for heart rate recovery. iOS 16.0+. Clinical marker for autonomic function and cardiovascular fitness."

// Active Energy Burned
* group[0].element[24].code = #HKQuantityTypeIdentifierActiveEnergyBurned
* group[0].element[24].display = "Active Energy Burned"
* group[0].element[24].target[0].equivalence = #unmatched
* group[0].element[24].target[0].comment = "GAP: No LOINC code for active energy expenditure from wearables. Critical for weight management and exercise prescription."

// Basal Energy Burned
* group[0].element[25].code = #HKQuantityTypeIdentifierBasalEnergyBurned
* group[0].element[25].display = "Basal Energy Burned"
* group[0].element[25].target[0].equivalence = #unmatched
* group[0].element[25].target[0].comment = "GAP: No LOINC code for basal metabolic rate from wearables. Resting energy expenditure estimate."

// Flights Climbed
* group[0].element[26].code = #HKQuantityTypeIdentifierFlightsClimbed
* group[0].element[26].display = "Flights Climbed"
* group[0].element[26].target[0].equivalence = #unmatched
* group[0].element[26].target[0].comment = "GAP: No LOINC code. Activity intensity indicator. 1 flight ≈ 10 feet elevation gain."

// Apple Exercise Time
* group[0].element[27].code = #HKQuantityTypeIdentifierAppleExerciseTime
* group[0].element[27].display = "Apple Exercise Time"
* group[0].element[27].target[0].equivalence = #unmatched
* group[0].element[27].target[0].comment = "GAP: No LOINC code for exercise duration from wearables. iOS 9.3+. Minutes of activity at brisk walk intensity or higher."

// -----------------------------------------------------------------------------
// MOBILITY METRICS (iOS 14+) - DOCUMENTED GAPS
// -----------------------------------------------------------------------------

// Walking Speed
* group[0].element[28].code = #HKQuantityTypeIdentifierWalkingSpeed
* group[0].element[28].display = "Walking Speed"
* group[0].element[28].target[0].equivalence = #unmatched
* group[0].element[28].target[0].comment = "GAP: No LOINC code. iOS 14.0+. Critical mobility metric for fall risk and functional assessment. Unit: m/s"

// Walking Step Length
* group[0].element[29].code = #HKQuantityTypeIdentifierWalkingStepLength
* group[0].element[29].display = "Walking Step Length"
* group[0].element[29].target[0].equivalence = #unmatched
* group[0].element[29].target[0].comment = "GAP: No LOINC code. iOS 14.0+. Gait analysis metric. Unit: meters"

// Walking Asymmetry Percentage
* group[0].element[30].code = #HKQuantityTypeIdentifierWalkingAsymmetryPercentage
* group[0].element[30].display = "Walking Asymmetry Percentage"
* group[0].element[30].target[0].equivalence = #unmatched
* group[0].element[30].target[0].comment = "GAP: No LOINC code. iOS 14.0+. Balance and coordination assessment. Normal <10%"

// Walking Double Support Percentage
* group[0].element[31].code = #HKQuantityTypeIdentifierWalkingDoubleSupportPercentage
* group[0].element[31].display = "Walking Double Support Percentage"
* group[0].element[31].target[0].equivalence = #unmatched
* group[0].element[31].target[0].comment = "GAP: No LOINC code. iOS 14.0+. Time with both feet on ground. Higher values may indicate instability."

// Stair Ascent Speed
* group[0].element[32].code = #HKQuantityTypeIdentifierStairAscentSpeed
* group[0].element[32].display = "Stair Ascent Speed"
* group[0].element[32].target[0].equivalence = #unmatched
* group[0].element[32].target[0].comment = "GAP: No LOINC code. iOS 14.0+. Functional capacity indicator. Unit: m/s"

// Stair Descent Speed
* group[0].element[33].code = #HKQuantityTypeIdentifierStairDescentSpeed
* group[0].element[33].display = "Stair Descent Speed"
* group[0].element[33].target[0].equivalence = #unmatched
* group[0].element[33].target[0].comment = "GAP: No LOINC code. iOS 14.0+. Fall risk indicator. Unit: m/s"

// Six Minute Walk Test Distance
* group[0].element[34].code = #HKQuantityTypeIdentifierSixMinuteWalkTestDistance
* group[0].element[34].display = "Six Minute Walk Test Distance"
* group[0].element[34].target[0].equivalence = #unmatched
* group[0].element[34].target[0].comment = "GAP: No LOINC code for wearable-estimated 6MWT. iOS 14.0+. Standard cardiopulmonary functional test. Unit: meters"

// Apple Walking Steadiness
* group[0].element[35].code = #HKQuantityTypeIdentifierAppleWalkingSteadiness
* group[0].element[35].display = "Apple Walking Steadiness"
* group[0].element[35].target[0].equivalence = #unmatched
* group[0].element[35].target[0].comment = "GAP: No LOINC code. iOS 15.0+. FDA-recognized fall risk prediction metric. Score 0-1 (percentage)."

// -----------------------------------------------------------------------------
// HEARING METRICS (iOS 13+)
// -----------------------------------------------------------------------------

// Environmental Audio Exposure
* group[0].element[36].code = #HKQuantityTypeIdentifierEnvironmentalAudioExposure
* group[0].element[36].display = "Environmental Audio Exposure"
* group[0].element[36].target[0].equivalence = #unmatched
* group[0].element[36].target[0].comment = "GAP: No LOINC code. iOS 13.0+. Ambient sound level in dBASPL. Occupational health relevance."

// Headphone Audio Exposure
* group[0].element[37].code = #HKQuantityTypeIdentifierHeadphoneAudioExposure
* group[0].element[37].display = "Headphone Audio Exposure"
* group[0].element[37].target[0].equivalence = #unmatched
* group[0].element[37].target[0].comment = "GAP: No LOINC code. iOS 13.0+. Headphone volume in dBASPL. Hearing protection relevance."

// -----------------------------------------------------------------------------
// CYCLING METRICS (iOS 17+)
// -----------------------------------------------------------------------------

// Cycling Speed
* group[0].element[38].code = #HKQuantityTypeIdentifierCyclingSpeed
* group[0].element[38].display = "Cycling Speed"
* group[0].element[38].target[0].equivalence = #unmatched
* group[0].element[38].target[0].comment = "GAP: No LOINC code. iOS 17.0+. Unit: m/s"

// Cycling Power
* group[0].element[39].code = #HKQuantityTypeIdentifierCyclingPower
* group[0].element[39].display = "Cycling Power"
* group[0].element[39].target[0].equivalence = #unmatched
* group[0].element[39].target[0].comment = "GAP: No LOINC code. iOS 17.0+. Unit: watts"

// Cycling Cadence
* group[0].element[40].code = #HKQuantityTypeIdentifierCyclingCadence
* group[0].element[40].display = "Cycling Cadence"
* group[0].element[40].target[0].equivalence = #unmatched
* group[0].element[40].target[0].comment = "GAP: No LOINC code. iOS 17.0+. Unit: rpm (revolutions per minute)"

// Cycling Functional Threshold Power
* group[0].element[41].code = #HKQuantityTypeIdentifierCyclingFunctionalThresholdPower
* group[0].element[41].display = "Cycling FTP"
* group[0].element[41].target[0].equivalence = #unmatched
* group[0].element[41].target[0].comment = "GAP: No LOINC code. iOS 17.0+. Functional Threshold Power in watts. Key cycling fitness metric."

// =============================================================================
// GROUP 2: Fitbit API → LOINC
// =============================================================================
* group[1].source = "https://dev.fitbit.com/build/reference/web-api"
* group[1].target = "http://loinc.org"

// Daily RMSSD
* group[1].element[0].code = #activities-heart-hrv-dailyRmssd
* group[1].element[0].display = "Daily RMSSD"
* group[1].element[0].target[0].equivalence = #unmatched
* group[1].element[0].target[0].comment = "GAP CONFIRMED: NO LOINC code exists for RMSSD (verified 2026-01-07). RMSSD is the primary parasympathetic HRV marker used by most wearables (Fitbit, Garmin, Oura). Apple chose SDNN instead. Maps conceptually to vagal activity. Fitbit API: GET /1/user/-/hrv/date/{date}.json"

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

// Sleep Efficiency - CORRECTED 2025-12-08
// WRONG: 93832-4 = "Sleep duration" (NOT "Sleep efficiency"!)
// CORRECT: No LOINC code exists for sleep efficiency
* group[1].element[3].code = #sleep-efficiency
* group[1].element[3].display = "Sleep Efficiency"
* group[1].element[3].target[0].equivalence = #unmatched
* group[1].element[3].target[0].comment = "GAP: No LOINC code exists for sleep efficiency (verified 2025-12-08 via tx.fhir.org). 93832-4 = Sleep duration (NOT efficiency). Sleep efficiency = (Total Sleep Time / Time in Bed) × 100. Normal: >85%."

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

// Max Heart Rate - CORRECTED 2025-12-08
// WRONG: 8889-8 = "Heart rate by Pulse oximetry" (NOT 24h max!)
// CORRECT: 8873-2 = "Heart rate 24 hour maximum"
* group[2].element[2].code = #maxHeartRate
* group[2].element[2].display = "Maximum Heart Rate"
* group[2].element[2].target[0].code = #8873-2
* group[2].element[2].target[0].display = "Heart rate 24 hour maximum"
* group[2].element[2].target[0].equivalence = #equivalent
* group[2].element[2].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 8873-2 = Heart rate 24 hour maximum. Note: LOINC 101692-2 = generic 'Maximum heart rate' (Athena 3966129, verified 2026-02-24) used as primary in SwimmingWorkoutObservation profile."

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

// RR Intervals (raw) - CORRECTED 2025-12-08
// WRONG: 8636-3 = "Q-T interval corrected" (NOT R-R interval!)
// CORRECT: 8637-1 = "R-R interval by EKG"
* group[3].element[1].code = #rr-intervals
* group[3].element[1].display = "RR Intervals"
* group[3].element[1].target[0].code = #8637-1
* group[3].element[1].target[0].display = "R-R interval by EKG"
* group[3].element[1].target[0].equivalence = #equivalent
* group[3].element[1].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 8637-1 = R-R interval by EKG. Polar H10 provides ECG-quality RR intervals."

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

// Lowest Heart Rate - CORRECTED 2025-12-08
// WRONG: 8891-4 = "Heart rate Cardiac apex by palpation" (NOT 24h min!)
// CORRECT: 8883-1 = "Heart rate 24 hour minimum"
* group[4].element[1].code = #hr_lowest
* group[4].element[1].display = "Lowest Heart Rate (overnight)"
* group[4].element[1].target[0].code = #8883-1
* group[4].element[1].target[0].display = "Heart rate 24 hour minimum"
* group[4].element[1].target[0].equivalence = #narrower
* group[4].element[1].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 8883-1 = Heart rate 24 hour minimum. Oura measures overnight only (narrower than 24h)."

// Average Heart Rate - CORRECTED 2025-12-08
// WRONG: 8890-6 = "Heart rate Cardiac apex by Auscultation" (NOT 24h mean!)
// CORRECT: 41924-2 = "Heart rate 24 hour mean"
* group[4].element[2].code = #hr_average
* group[4].element[2].display = "Average Heart Rate (overnight)"
* group[4].element[2].target[0].code = #41924-2
* group[4].element[2].target[0].display = "Heart rate 24 hour mean"
* group[4].element[2].target[0].equivalence = #narrower
* group[4].element[2].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 41924-2 = Heart rate 24 hour mean. Oura measures overnight only (narrower than 24h)."

// Respiratory Rate
* group[4].element[3].code = #breathing_rate
* group[4].element[3].display = "Breathing Rate (overnight)"
* group[4].element[3].target[0].code = #9279-1
* group[4].element[3].target[0].display = "Respiratory rate"
* group[4].element[3].target[0].equivalence = #equivalent
