// ValueSet: Vendor Proprietary Codes
// Created: 2024-11-21
// Purpose: Source ValueSet for vendor code to LOINC ConceptMap
// Scope: Major wearable device vendors (Apple, Fitbit, Garmin, Polar, Oura)

ValueSet: VendorCodesVS
Id: vendor-codes-vs
Title: "Vendor Proprietary Wearable Device Codes"
Description: "Comprehensive set of proprietary codes from major wearable device vendors (Apple HealthKit, Fitbit, Garmin, Polar, Oura Ring). Used as source ValueSet in ConceptMap for translating vendor-specific codes to LOINC standard terminology. Addresses critical interoperability gap: 0% vendor LOINC adoption documented across 11 major vendors."
* ^status = #active
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2024-11-21"
* ^copyright = "Vendor codes are proprietary to their respective organizations. This ValueSet documents them for interoperability purposes only."

// ============================================================================
// APPLE HEALTHKIT
// Source: https://developer.apple.com/documentation/healthkit
// ============================================================================
* include codes from system https://developer.apple.com/documentation/healthkit

// Note: FSH ValueSet syntax doesn't support individual vendor code enumeration
// from proprietary systems. The actual mapping is done in ConceptMap where
// we can explicitly list: HKQuantityTypeIdentifierHeartRateVariabilitySDNN,
// HKQuantityTypeIdentifierHeartRate, HKQuantityTypeIdentifierStepCount, etc.

// ============================================================================
// FITBIT API
// Source: https://dev.fitbit.com/build/reference/web-api
// ============================================================================
* include codes from system https://dev.fitbit.com/build/reference/web-api

// Common codes: activities-heart-hrv-dailyRmssd, activities-steps,
// activities-heart-restingHeartRate, sleep-efficiency

// ============================================================================
// GARMIN HEALTH API
// Source: https://developer.garmin.com/health-api
// ============================================================================
* include codes from system https://developer.garmin.com/health-api

// Common codes: dailySteps, restingHeartRate, maxHeartRate, avgSpo2

// ============================================================================
// POLAR ACCESSLINK
// Source: https://www.polaraccesslink.com/v3
// ============================================================================
* include codes from system https://www.polaraccesslink.com/v3

// Common codes: heart-rate, rr-intervals (ECG-quality from H10 chest strap)

// ============================================================================
// OURA RING API
// Source: https://cloud.ouraring.com/v2/usercollection
// ============================================================================
* include codes from system https://cloud.ouraring.com/v2/usercollection

// Common codes: hrv_balance (proprietary score), hr_lowest, hr_average, breathing_rate
