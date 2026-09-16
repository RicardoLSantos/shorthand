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
* date = "2026-09-16"
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

Node codes: openEHR targets use the ADL 1.4 node identifiers (atNNNN) of the published draft archetypes and are checked against the archetype term definitions. Five vendor elements that had pointed to ADL2 nodes without an ADL 1.4 counterpart (Apple heart rate; Oura HRV Balance and Readiness; Garmin Stress Level and HRV Status) were removed on 2026-09-11 rather than re-mapped to non-existent nodes; the Fitbit coverage element moved to the wearable-device CLUSTER, where the data-quality node lives.

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
// Removed 2026-09-11: HKQuantityTypeIdentifierHeartRate → mean heart rate — the ADL 1.4 HRV archetype has no heart-rate node (the element pointed to an ADL2 node that no longer exists).
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #other
* group[0].unmapped.display = "Unmapped HealthKit HRV type"

// HKQuantityTypeIdentifierHeartRateVariabilitySDNN → at0004 (SDNN)
* group[0].element[0].code = #HKQuantityTypeIdentifierHeartRateVariabilitySDNN
* group[0].element[0].display = "Apple HealthKit: Heart Rate Variability SDNN"
* group[0].element[0].target[0].code = #at0004
* group[0].element[0].target[0].display = "SDNN"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "HealthKit provides SDNN in milliseconds. Direct mapping. Note: Apple uses proprietary algorithm from PPG."

// ============================================================================
// GROUP 2: Fitbit HRV API → openEHR HRV Archetype
// ============================================================================
* group[1].source = "com.fitbit.hrv"
* group[1].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"

// dailyRmssd → at0005 (RMSSD)
* group[1].element[0].code = #dailyRmssd
* group[1].element[0].display = "Fitbit: Daily RMSSD average"
* group[1].element[0].target[0].code = #at0005
* group[1].element[0].target[0].display = "RMSSD"
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "Fitbit provides daily RMSSD average. CAUTION: This is AVERAGED across deep sleep periods, not a single measurement."

// deepRmssd → at0005 (RMSSD) with sleep context
* group[1].element[1].code = #deepRmssd
* group[1].element[1].display = "Fitbit: Deep sleep RMSSD"
* group[1].element[1].target[0].code = #at0005
* group[1].element[1].target[0].display = "RMSSD"
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = "Fitbit provides RMSSD specifically from deep sleep stages. Set physiological_state (at0040) = 'sleep'"

// ============================================================================
// GROUP 3: Oura Ring HRV → openEHR HRV Archetype
// ============================================================================
* group[2].source = "com.ouraring"
* group[2].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"
// Removed 2026-09-11: hrv_balance and readiness_score (proprietary composite scores) — no node in the ADL 1.4 HRV archetype; not re-mapped to avoid inventing nodes.

// average_hrv (nightly) → at0005 (RMSSD)
* group[2].element[0].code = #average_hrv
* group[2].element[0].display = "Oura: Average nightly HRV (RMSSD)"
* group[2].element[0].target[0].code = #at0005
* group[2].element[0].target[0].display = "RMSSD"
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "Oura provides nightly average RMSSD. Measured during sleep. Unit: ms. Set physiological_state = 'sleep'"

// ============================================================================
// GROUP 4: Garmin HRV → openEHR HRV Archetype
// ============================================================================
* group[3].source = "com.garmin.connect"
* group[3].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"
// Removed 2026-09-11: stressLevel and hrvStatus (proprietary derived scores) — no node in the ADL 1.4 HRV archetype; not re-mapped to avoid inventing nodes.

// hrvSummary.lastNight.avgHrv → at0005 (RMSSD)
* group[3].element[0].code = #avgHrv
* group[3].element[0].display = "Garmin: Average overnight HRV"
* group[3].element[0].target[0].code = #at0005
* group[3].element[0].target[0].display = "RMSSD"
* group[3].element[0].target[0].equivalence = #equivalent
* group[3].element[0].target[0].comment = "Garmin provides average overnight RMSSD. Set physiological_state = 'sleep'. Unit: ms"

// ============================================================================
// GROUP 5: Polar HRV → openEHR HRV Archetype
// ============================================================================
* group[4].source = "com.polar"
* group[4].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"

// rmssd → at0005 (RMSSD) - Direct ECG measurement
* group[4].element[0].code = #hrv_rmssd
* group[4].element[0].display = "Polar: HRV RMSSD"
* group[4].element[0].target[0].code = #at0005
* group[4].element[0].target[0].display = "RMSSD"
* group[4].element[0].target[0].equivalence = #equivalent
* group[4].element[0].target[0].comment = "Polar H10 provides RMSSD from ECG (gold standard). Higher accuracy than PPG-based wearables. Unit: ms"

// sdnn → at0004 (SDNN)
* group[4].element[1].code = #hrv_sdnn
* group[4].element[1].display = "Polar: HRV SDNN"
* group[4].element[1].target[0].code = #at0004
* group[4].element[1].target[0].display = "SDNN"
* group[4].element[1].target[0].equivalence = #equivalent
* group[4].element[1].target[0].comment = "Polar provides SDNN from ECG. High accuracy. Unit: ms"

// pnn50 → at0006 (pNN50)
* group[4].element[2].code = #hrv_pnn50
* group[4].element[2].display = "Polar: HRV pNN50"
* group[4].element[2].target[0].code = #at0006
* group[4].element[2].target[0].display = "pNN50"
* group[4].element[2].target[0].equivalence = #equivalent
* group[4].element[2].target[0].comment = "Polar provides pNN50 from ECG. Unit: percentage (0-100)"

// ============================================================================
// GROUP 6: Apple HealthKit Sleep → openEHR Sleep Archetype
// ============================================================================
* group[5].source = "com.apple.health"
* group[5].target = "openEHR-EHR-OBSERVATION.sleep_architecture.v0"

// HKCategoryValueSleepAnalysisAsleepCore → at0021 (Light sleep duration)
* group[5].element[0].code = #HKCategoryValueSleepAnalysisAsleepCore
* group[5].element[0].display = "Apple HealthKit: Core Sleep"
* group[5].element[0].target[0].code = #at0021
* group[5].element[0].target[0].display = "Light sleep duration"
* group[5].element[0].target[0].equivalence = #equivalent
* group[5].element[0].target[0].comment = "Apple 'Core' sleep maps to light sleep (N1+N2 equivalent). watchOS 9+."

* group[5].element[1].code = #HKCategoryValueSleepAnalysisAsleepDeep
* group[5].element[1].display = "Apple HealthKit: Deep Sleep"
* group[5].element[1].target[0].code = #at0022
* group[5].element[1].target[0].display = "Deep sleep duration"
* group[5].element[1].target[0].equivalence = #equivalent
* group[5].element[1].target[0].comment = "Apple 'Deep' sleep maps to N3/SWS. watchOS 9+."

* group[5].element[2].code = #HKCategoryValueSleepAnalysisAsleepREM
* group[5].element[2].display = "Apple HealthKit: REM Sleep"
* group[5].element[2].target[0].code = #at0023
* group[5].element[2].target[0].display = "REM sleep duration"
* group[5].element[2].target[0].equivalence = #equivalent
* group[5].element[2].target[0].comment = "Apple 'REM' sleep maps directly. watchOS 9+."

* group[5].element[3].code = #HKCategoryValueSleepAnalysisAwake
* group[5].element[3].display = "Apple HealthKit: Awake during sleep"
* group[5].element[3].target[0].code = #at0020
* group[5].element[3].target[0].display = "Awake duration"
* group[5].element[3].target[0].equivalence = #equivalent
* group[5].element[3].target[0].comment = "Contributes to WASO (Wake After Sleep Onset) calculation."

// ============================================================================
// GROUP 7: Apple HealthKit Activity → openEHR Physical Activity Archetype
// ============================================================================
* group[6].source = "com.apple.health"
* group[6].target = "openEHR-EHR-OBSERVATION.physical_activity_detailed.v0"

// HKQuantityTypeIdentifierStepCount → at0009 (Step count)
* group[6].element[0].code = #HKQuantityTypeIdentifierStepCount
* group[6].element[0].display = "Apple HealthKit: Step Count"
* group[6].element[0].target[0].code = #at0009
* group[6].element[0].target[0].display = "Step count"
* group[6].element[0].target[0].equivalence = #equivalent
* group[6].element[0].target[0].comment = "Direct mapping. Unit: count. Aggregate daily total."

// HKQuantityTypeIdentifierDistanceWalkingRunning → at0010 (Distance)
* group[6].element[1].code = #HKQuantityTypeIdentifierDistanceWalkingRunning
* group[6].element[1].display = "Apple HealthKit: Distance Walking/Running"
* group[6].element[1].target[0].code = #at0010
* group[6].element[1].target[0].display = "Distance"
* group[6].element[1].target[0].equivalence = #equivalent
* group[6].element[1].target[0].comment = "Convert from meters to km if needed. Aggregate daily total."

// HKQuantityTypeIdentifierActiveEnergyBurned → at0019 (Active calories)
* group[6].element[2].code = #HKQuantityTypeIdentifierActiveEnergyBurned
* group[6].element[2].display = "Apple HealthKit: Active Energy Burned"
* group[6].element[2].target[0].code = #at0019
* group[6].element[2].target[0].display = "Active calories"
* group[6].element[2].target[0].equivalence = #equivalent
* group[6].element[2].target[0].comment = "HealthKit provides in kilocalories (kcal). Direct mapping."

// HKQuantityTypeIdentifierAppleExerciseTime → at0033 (Exercise minutes)
* group[6].element[3].code = #HKQuantityTypeIdentifierAppleExerciseTime
* group[6].element[3].display = "Apple HealthKit: Exercise Time"
* group[6].element[3].target[0].code = #at0033
* group[6].element[3].target[0].display = "Exercise minutes"
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
//    - Store vendor_source in the device CLUSTER (at0001, Device platform)
//    - Include measurement context (at0040: Physiological state)
//    - Document algorithm version in firmware_version (at0019)
//    - Use caution when comparing cross-vendor data
//
// 4. GOLD STANDARD HIERARCHY:
//    a. Polar H10 (ECG-based) - Research grade
//    b. Apple Watch (PPG + ML) - Consumer grade, good accuracy
//    c. Fitbit/Garmin/Oura (PPG) - Consumer grade, variable accuracy

// ============================================================================
// GROUP 8: Fitbit HRV API → openEHR Wearable Device CLUSTER (data quality)
// The coverage percentage is a data-quality attribute of the device data, not an
// element of the HRV OBSERVATION archetype; it maps to the CLUSTER node.
// ============================================================================
* group[7].source = "com.fitbit.hrv"
* group[7].target = "openEHR-EHR-CLUSTER.wearable_device.v0"

// hrv_coverage → Data quality indicator (at0026)
* group[7].element[0].code = #coverage
* group[7].element[0].display = "Fitbit: HRV data coverage percentage"
* group[7].element[0].target[0].code = #at0026
* group[7].element[0].target[0].display = "Data quality indicator"
* group[7].element[0].target[0].equivalence = #relatedto
* group[7].element[0].target[0].comment = "Percentage of night with valid HRV data. Use as quality indicator. <80% suggests poor data quality."
