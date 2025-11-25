// ConceptMap: Vendor APIs → openEHR Archetypes
// Created: 2025-11-25
// Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
// Links: https://linktr.ee/ricardolsantos
// Purpose: Enable direct wearable vendor to openEHR transformation
// Context: PhD Thesis - Integrating Wearable Biomarkers into Learning Health Systems

Instance: ConceptMapVendorToOpenEHR
InstanceOf: ConceptMap
Title: "Wearable Vendor API to openEHR Archetype Mapping"
Description: "Maps proprietary wearable vendor API data types (Apple HealthKit, Fitbit, Oura, Garmin, Polar) to openEHR archetypes for standardized clinical data capture."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapVendorToOpenEHR"
* version = "0.1.0"
* name = "ConceptMapVendorToOpenEHR"
* title = "Wearable Vendor API to openEHR Archetype Mapping"
* status = #active
* experimental = false
* date = "2025-11-25"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "ricardolourencosantos@gmail.com"
* description = """
Direct mapping from proprietary wearable vendor API data types to openEHR archetypes.

Supported Vendors:
- Apple HealthKit (HKQuantityType, HKCategoryType)
- Fitbit Web API (activities, sleep, hrv endpoints)
- Oura Ring API (readiness, sleep, activity)
- Garmin Connect API (activities, wellness, sleep)
- Polar Flow API (training, recovery)

Architecture:
- Enables direct ETL from vendor export to EHRbase CDR
- Normalizes proprietary units to UCUM
- Handles vendor-specific scoring algorithms
- Documents transformation caveats and data quality considerations

Use Cases:
- Patient-generated health data (PGHD) capture
- Multi-vendor data aggregation
- Longitudinal wearable data repositories
"""
* purpose = "Enable standardized capture of wearable data from multiple vendors into openEHR Clinical Data Repositories via direct ETL pipelines."

// Source: Proprietary vendor API namespace (conceptual)
// Target: openEHR archetype namespace
* sourceUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/vendor-apis"
* targetUri = "https://ckm.openehr.org/ckm"

// ============================================================================
// GROUP 1: Apple HealthKit HRV → openEHR HRV Archetype
// ============================================================================
* group[0].source = "com.apple.health"
* group[0].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #other
* group[0].unmapped.display = "Unmapped HealthKit HRV type"

// HKQuantityTypeIdentifierHeartRateVariabilitySDNN → id5 (SDNN)
* group[0].element[0].code = #HKQuantityTypeIdentifierHeartRateVariabilitySDNN
* group[0].element[0].display = "Apple HealthKit: Heart Rate Variability SDNN"
* group[0].element[0].target[0].code = #id5
* group[0].element[0].target[0].display = "SDNN - Standard deviation of NN intervals"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "HealthKit provides SDNN in milliseconds. Direct mapping. Note: Apple uses proprietary algorithm from PPG."

// HKQuantityTypeIdentifierHeartRate → Related for context
* group[0].element[1].code = #HKQuantityTypeIdentifierHeartRate
* group[0].element[1].display = "Apple HealthKit: Heart Rate"
* group[0].element[1].target[0].code = #id50
* group[0].element[1].target[0].display = "Mean heart rate during recording"
* group[0].element[1].target[0].equivalence = #relatedto
* group[0].element[1].target[0].comment = "Use mean HR from same recording period for HRV context. Unit: bpm"

// ============================================================================
// GROUP 2: Fitbit HRV API → openEHR HRV Archetype
// ============================================================================
* group[1].source = "com.fitbit.hrv"
* group[1].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"

// dailyRmssd → id6 (RMSSD)
* group[1].element[0].code = #dailyRmssd
* group[1].element[0].display = "Fitbit: Daily RMSSD average"
* group[1].element[0].target[0].code = #id6
* group[1].element[0].target[0].display = "RMSSD - Root mean square of successive differences"
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "Fitbit provides daily RMSSD average. CAUTION: This is AVERAGED across deep sleep periods, not a single measurement."

// deepRmssd → id6 (RMSSD) with sleep context
* group[1].element[1].code = #deepRmssd
* group[1].element[1].display = "Fitbit: Deep sleep RMSSD"
* group[1].element[1].target[0].code = #id6
* group[1].element[1].target[0].display = "RMSSD during deep sleep"
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = "Fitbit provides RMSSD specifically from deep sleep stages. Set physiological_state (id41) = 'sleep'"

// hrv_coverage → Related metadata
* group[1].element[2].code = #coverage
* group[1].element[2].display = "Fitbit: HRV data coverage percentage"
* group[1].element[2].target[0].code = #id60
* group[1].element[2].target[0].display = "Data quality indicator"
* group[1].element[2].target[0].equivalence = #relatedto
* group[1].element[2].target[0].comment = "Percentage of night with valid HRV data. Use as quality indicator. <80% suggests poor data quality."

// ============================================================================
// GROUP 3: Oura Ring HRV → openEHR HRV Archetype
// ============================================================================
* group[2].source = "com.ouraring"
* group[2].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"

// average_hrv (nightly) → id6 (RMSSD)
* group[2].element[0].code = #average_hrv
* group[2].element[0].display = "Oura: Average nightly HRV (RMSSD)"
* group[2].element[0].target[0].code = #id6
* group[2].element[0].target[0].display = "RMSSD - Root mean square of successive differences"
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "Oura provides nightly average RMSSD. Measured during sleep. Unit: ms. Set physiological_state = 'sleep'"

// hrv_balance → Related score (proprietary)
* group[2].element[1].code = #hrv_balance
* group[2].element[1].display = "Oura: HRV Balance score"
* group[2].element[1].target[0].code = #id70
* group[2].element[1].target[0].display = "Vendor-specific recovery score"
* group[2].element[1].target[0].equivalence = #relatedto
* group[2].element[1].target[0].comment = "PROPRIETARY: Oura HRV Balance is a 7-day trend normalized score. NOT comparable to raw RMSSD."

// readiness_score → Related score
* group[2].element[2].code = #readiness_score
* group[2].element[2].display = "Oura: Readiness Score"
* group[2].element[2].target[0].code = #id71
* group[2].element[2].target[0].display = "Vendor-specific readiness score"
* group[2].element[2].target[0].equivalence = #relatedto
* group[2].element[2].target[0].comment = "PROPRIETARY: Composite score including HRV, sleep, activity, temperature. Scale 0-100. NOT suitable for cross-vendor comparison."

// ============================================================================
// GROUP 4: Garmin HRV → openEHR HRV Archetype
// ============================================================================
* group[3].source = "com.garmin.connect"
* group[3].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"

// hrvSummary.lastNight.avgHrv → id6 (RMSSD)
* group[3].element[0].code = #avgHrv
* group[3].element[0].display = "Garmin: Average overnight HRV"
* group[3].element[0].target[0].code = #id6
* group[3].element[0].target[0].display = "RMSSD - Root mean square of successive differences"
* group[3].element[0].target[0].equivalence = #equivalent
* group[3].element[0].target[0].comment = "Garmin provides average overnight RMSSD. Set physiological_state = 'sleep'. Unit: ms"

// stress_level → Related (proprietary transformation)
* group[3].element[1].code = #stressLevel
* group[3].element[1].display = "Garmin: Stress Level"
* group[3].element[1].target[0].code = #id72
* group[3].element[1].target[0].display = "Vendor-specific stress score"
* group[3].element[1].target[0].equivalence = #relatedto
* group[3].element[1].target[0].comment = "PROPRIETARY: Garmin stress level is DERIVED from HRV. Scale 0-100 (inverted: low = relaxed). Formula not disclosed."

// hrvStatus → Related
* group[3].element[2].code = #hrvStatus
* group[3].element[2].display = "Garmin: HRV Status"
* group[3].element[2].target[0].code = #id73
* group[3].element[2].target[0].display = "Vendor-specific HRV status"
* group[3].element[2].target[0].equivalence = #relatedto
* group[3].element[2].target[0].comment = "Categorical status: Low, Balanced, High. Relative to personal baseline. PROPRIETARY algorithm."

// ============================================================================
// GROUP 5: Polar HRV → openEHR HRV Archetype
// ============================================================================
* group[4].source = "com.polar"
* group[4].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"

// rmssd → id6 (RMSSD) - Direct ECG measurement
* group[4].element[0].code = #hrv_rmssd
* group[4].element[0].display = "Polar: HRV RMSSD"
* group[4].element[0].target[0].code = #id6
* group[4].element[0].target[0].display = "RMSSD - Root mean square of successive differences"
* group[4].element[0].target[0].equivalence = #equivalent
* group[4].element[0].target[0].comment = "Polar H10 provides RMSSD from ECG (gold standard). Higher accuracy than PPG-based wearables. Unit: ms"

// sdnn → id5 (SDNN)
* group[4].element[1].code = #hrv_sdnn
* group[4].element[1].display = "Polar: HRV SDNN"
* group[4].element[1].target[0].code = #id5
* group[4].element[0].target[0].display = "SDNN - Standard deviation of NN intervals"
* group[4].element[1].target[0].equivalence = #equivalent
* group[4].element[1].target[0].comment = "Polar provides SDNN from ECG. High accuracy. Unit: ms"

// pnn50 → id7 (pNN50)
* group[4].element[2].code = #hrv_pnn50
* group[4].element[2].display = "Polar: HRV pNN50"
* group[4].element[2].target[0].code = #id7
* group[4].element[2].target[0].display = "pNN50 - Percentage of NN intervals >50ms"
* group[4].element[2].target[0].equivalence = #equivalent
* group[4].element[2].target[0].comment = "Polar provides pNN50 from ECG. Unit: percentage (0-100)"

// ============================================================================
// GROUP 6: Apple HealthKit Sleep → openEHR Sleep Archetype
// ============================================================================
* group[5].source = "com.apple.health"
* group[5].target = "openEHR-EHR-OBSERVATION.sleep_architecture.v0"

// HKCategoryValueSleepAnalysis → id13 (Total sleep time)
* group[5].element[0].code = #HKCategoryValueSleepAnalysisAsleepCore
* group[5].element[0].display = "Apple HealthKit: Core Sleep"
* group[5].element[0].target[0].code = #id21
* group[5].element[0].target[0].display = "Light sleep duration (N1+N2)"
* group[5].element[0].target[0].equivalence = #equivalent
* group[5].element[0].target[0].comment = "Apple 'Core' sleep maps to light sleep (N1+N2 equivalent). watchOS 9+."

* group[5].element[1].code = #HKCategoryValueSleepAnalysisAsleepDeep
* group[5].element[1].display = "Apple HealthKit: Deep Sleep"
* group[5].element[1].target[0].code = #id23
* group[5].element[1].target[0].display = "Deep sleep duration (N3/SWS)"
* group[5].element[1].target[0].equivalence = #equivalent
* group[5].element[1].target[0].comment = "Apple 'Deep' sleep maps to N3/SWS. watchOS 9+."

* group[5].element[2].code = #HKCategoryValueSleepAnalysisAsleepREM
* group[5].element[2].display = "Apple HealthKit: REM Sleep"
* group[5].element[2].target[0].code = #id24
* group[5].element[2].target[0].display = "REM sleep duration"
* group[5].element[2].target[0].equivalence = #equivalent
* group[5].element[2].target[0].comment = "Apple 'REM' sleep maps directly. watchOS 9+."

* group[5].element[3].code = #HKCategoryValueSleepAnalysisAwake
* group[5].element[3].display = "Apple HealthKit: Awake during sleep"
* group[5].element[3].target[0].code = #id20
* group[5].element[3].target[0].display = "Awake time during sleep period"
* group[5].element[3].target[0].equivalence = #equivalent
* group[5].element[3].target[0].comment = "Contributes to WASO (Wake After Sleep Onset) calculation."

// ============================================================================
// GROUP 7: Apple HealthKit Activity → openEHR Physical Activity Archetype
// ============================================================================
* group[6].source = "com.apple.health"
* group[6].target = "openEHR-EHR-OBSERVATION.physical_activity_detailed.v0"

// HKQuantityTypeIdentifierStepCount → id10 (Step count)
* group[6].element[0].code = #HKQuantityTypeIdentifierStepCount
* group[6].element[0].display = "Apple HealthKit: Step Count"
* group[6].element[0].target[0].code = #id10
* group[6].element[0].target[0].display = "Step count"
* group[6].element[0].target[0].equivalence = #equivalent
* group[6].element[0].target[0].comment = "Direct mapping. Unit: count. Aggregate daily total."

// HKQuantityTypeIdentifierDistanceWalkingRunning → id11 (Distance)
* group[6].element[1].code = #HKQuantityTypeIdentifierDistanceWalkingRunning
* group[6].element[1].display = "Apple HealthKit: Distance Walking/Running"
* group[6].element[1].target[0].code = #id11
* group[6].element[1].target[0].display = "Distance"
* group[6].element[1].target[0].equivalence = #equivalent
* group[6].element[1].target[0].comment = "Convert from meters to km if needed. Aggregate daily total."

// HKQuantityTypeIdentifierActiveEnergyBurned → id20 (Active calories)
* group[6].element[2].code = #HKQuantityTypeIdentifierActiveEnergyBurned
* group[6].element[2].display = "Apple HealthKit: Active Energy Burned"
* group[6].element[2].target[0].code = #id20
* group[6].element[2].target[0].display = "Active calories"
* group[6].element[2].target[0].equivalence = #equivalent
* group[6].element[2].target[0].comment = "HealthKit provides in kilocalories (kcal). Direct mapping."

// HKQuantityTypeIdentifierAppleExerciseTime → id32/id33 (Activity minutes)
* group[6].element[3].code = #HKQuantityTypeIdentifierAppleExerciseTime
* group[6].element[3].display = "Apple HealthKit: Exercise Time"
* group[6].element[3].target[0].code = #id35
* group[6].element[3].target[0].display = "Exercise session duration"
* group[6].element[3].target[0].equivalence = #wider
* group[6].element[3].target[0].comment = "Apple Exercise Time threshold: HR > ~60-70% of estimated max. Maps to moderate+vigorous combined."

// ============================================================================
// TRANSFORMATION CAVEATS
// ============================================================================
// 1. ALGORITHM DIFFERENCES: Each vendor uses proprietary algorithms for:
//    - PPG-to-HRV conversion (Apple, Fitbit, Oura, Garmin)
//    - Sleep stage classification
//    - Activity intensity thresholds
//    Values are NOT directly comparable across vendors.
//
// 2. MEASUREMENT TIMING:
//    - Apple: On-demand or overnight (depending on setting)
//    - Fitbit: During deep sleep periods only
//    - Oura: Throughout night, averaged
//    - Garmin: During sleep or morning orthostatic test
//    - Polar: Any time with chest strap (gold standard)
//
// 3. RECOMMENDED APPROACH:
//    - Store vendor_source in device archetype (id2)
//    - Include measurement context (id41: physiological_state)
//    - Document algorithm version in firmware_version (id20)
//    - Use caution when comparing cross-vendor data
//
// 4. GOLD STANDARD HIERARCHY:
//    a. Polar H10 (ECG-based) - Research grade
//    b. Apple Watch (PPG + ML) - Consumer grade, good accuracy
//    c. Fitbit/Garmin/Oura (PPG) - Consumer grade, variable accuracy
