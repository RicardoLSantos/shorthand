// =============================================================================
// Round-Trip Technical Validation Examples
// Created: 2026-03-05
// Purpose: Demonstrate end-to-end vendor data → FHIR profile conformance
//          via ConceptMap translation across 5 vendors × 5 domains
// =============================================================================

// =============================================================================
// VENDOR-SPECIFIC DEVICES (for round-trip provenance)
// =============================================================================

Instance: DeviceAppleWatch
InstanceOf: Device
Usage: #example
Title: "Apple Watch Series 9"
Description: "Apple Watch device for HRV round-trip validation"
* deviceName.name = "Apple Watch Series 9"
* deviceName.type = #user-friendly-name
* manufacturer = "Apple Inc."
* modelNumber = "Apple Watch Series 9"
* version.value = "watchOS 10.2"
* status = #active
* type = $SCT#706689003 "Application programme software"

Instance: DeviceFitbitSense
InstanceOf: Device
Usage: #example
Title: "Fitbit Sense 2"
Description: "Fitbit Sense 2 device for sleep round-trip validation"
* deviceName.name = "Fitbit Sense 2"
* deviceName.type = #user-friendly-name
* manufacturer = "Fitbit LLC (Google)"
* modelNumber = "Fitbit Sense 2"
* version.value = "Fitbit OS 5.3"
* status = #active
* type = $SCT#706689003 "Application programme software"

Instance: DeviceGarminVenu
InstanceOf: Device
Usage: #example
Title: "Garmin Venu 3"
Description: "Garmin Venu 3 device for activity round-trip validation"
* deviceName.name = "Garmin Venu 3"
* deviceName.type = #user-friendly-name
* manufacturer = "Garmin Ltd."
* modelNumber = "Garmin Venu 3"
* version.value = "Software 9.18"
* status = #active
* type = $SCT#706689003 "Application programme software"

Instance: DeviceOuraRing
InstanceOf: Device
Usage: #example
Title: "Oura Ring Gen 3"
Description: "Oura Ring Gen 3 device for body metrics round-trip validation"
* deviceName.name = "Oura Ring Generation 3"
* deviceName.type = #user-friendly-name
* manufacturer = "Oura Health Oy"
* modelNumber = "Oura Ring Gen 3"
* version.value = "Firmware 2.8"
* status = #active
* type = $SCT#706689003 "Application programme software"

Instance: DeviceWithingsBPM
InstanceOf: Device
Usage: #example
Title: "Withings BPM Connect"
Description: "Withings BPM Connect device for blood pressure round-trip validation"
* deviceName.name = "Withings BPM Connect"
* deviceName.type = #user-friendly-name
* manufacturer = "Withings SA"
* modelNumber = "BPM Connect"
* version.value = "Firmware 1.6.2"
* status = #active
* type = $SCT#258057004 "Non-invasive blood pressure monitor"

// =============================================================================
// BUNDLE 1: Apple Watch HRV Round-Trip
// Vendor: Apple HealthKit
// Domain: Heart Rate Variability
// ConceptMap: ConceptMapVendorToLOINC (group[0])
// Translation: HKQuantityTypeIdentifierHeartRateVariabilitySDNN → LOINC 80404-7
// =============================================================================

Instance: RoundTripAppleHRV
InstanceOf: Bundle
Usage: #example
Title: "Round-Trip Validation: Apple Watch HRV"
Description: "Demonstrates Apple HealthKit HRV data transformation to FHIR. Vendor code HKQuantityTypeIdentifierHeartRateVariabilitySDNN maps to LOINC 80404-7 (SDNN) via ConceptMapVendorToLOINC. Includes heart rate (8867-4) as secondary observation."

* type = #collection
* timestamp = "2026-03-05T08:30:00Z"

* entry[0].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* entry[0].resource = PatientRoundTrip

* entry[1].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440002"
* entry[1].resource = DeviceAppleWatch

* entry[2].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440003"
* entry[2].resource = ObsAppleHRV

* entry[3].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440004"
* entry[3].resource = ObsAppleHeartRate

Instance: PatientRoundTrip
InstanceOf: Patient
Usage: #inline
* name.family = "Silva"
* name.given = "Maria"
* gender = #female
* birthDate = "1985-06-15"

Instance: ObsAppleHRV
InstanceOf: HeartRateObservation
Usage: #inline
Title: "Apple HRV → LOINC 80404-7"
Description: "Apple Watch SDNN measurement mapped from HKQuantityTypeIdentifierHeartRateVariabilitySDNN to LOINC 80404-7 via ConceptMapVendorToLOINC"
* status = #final
* code = $LOINC#8867-4 "Heart rate"
* subject.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* effectiveDateTime = "2026-03-04T23:15:00Z"
* device.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440002"
* valueQuantity = 62 '/min' "per minute"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "per minute"
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity = 42 'ms' "millisecond"
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.unit = "millisecond"
* note.text = "Round-trip validation: Apple HealthKit HKQuantityTypeIdentifierHeartRateVariabilitySDNN → LOINC 80404-7 via ConceptMapVendorToLOINC (group[0], element[0]). Equivalence: equivalent."

Instance: ObsAppleHeartRate
InstanceOf: HeartRateObservation
Usage: #inline
Title: "Apple Heart Rate → LOINC 8867-4"
Description: "Apple Watch heart rate mapped from HKQuantityTypeIdentifierHeartRate to LOINC 8867-4"
* status = #final
* code = $LOINC#8867-4 "Heart rate"
* subject.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* effectiveDateTime = "2026-03-04T23:15:00Z"
* device.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440002"
* valueQuantity = 62 '/min' "per minute"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "per minute"
* note.text = "Round-trip validation: Apple HealthKit HKQuantityTypeIdentifierHeartRate → LOINC 8867-4 via ConceptMapVendorToLOINC (group[0], element[1]). Equivalence: equivalent."

// =============================================================================
// BUNDLE 2: Fitbit Sleep Round-Trip
// Vendor: Fitbit Web API
// Domain: Sleep
// ConceptMap: ConceptMapSleepToLOINC + ConceptMapVendorToLOINC (group[1])
// Translation: Fitbit sleep stages → LOINC sleep duration codes
// =============================================================================

Instance: RoundTripFitbitSleep
InstanceOf: Bundle
Usage: #example
Title: "Round-Trip Validation: Fitbit Sleep"
Description: "Demonstrates Fitbit sleep data transformation to FHIR. Fitbit sleep stages (deep, light, rem, wake) map to LOINC codes via ConceptMapSleepToLOINC. Total sleep time uses LOINC 93832-4. Deep sleep uses LOINC 93831-6."

* type = #collection
* timestamp = "2026-03-05T08:30:00Z"

* entry[0].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* entry[0].resource = PatientRoundTrip

* entry[1].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440005"
* entry[1].resource = DeviceFitbitSense

* entry[2].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440006"
* entry[2].resource = ObsFitbitSleep

Instance: ObsFitbitSleep
InstanceOf: SleepObservation
Usage: #inline
Title: "Fitbit Sleep → LOINC Sleep Codes"
Description: "Fitbit sleep data mapped to LOINC codes. Demonstrates multi-component sleep observation with 6 mapped fields."
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LIFESTYLEOBS#sleep-panel "Sleep measurement panel"
* subject.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* effectivePeriod.start = "2026-03-04T23:00:00Z"
* effectivePeriod.end = "2026-03-05T06:45:00Z"
* device.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440005"
* component[totalSleepTime].code = $LOINC#93832-4 "Sleep duration"
* component[totalSleepTime].valueQuantity = 435 'min' "minute"
* component[totalSleepTime].valueQuantity.system = $UCUM
* component[totalSleepTime].valueQuantity.unit = "minute"
* component[deepSleep].code = $LOINC#93831-6 "Deep sleep duration"
* component[deepSleep].valueQuantity = 82 'min' "minute"
* component[deepSleep].valueQuantity.system = $UCUM
* component[deepSleep].valueQuantity.unit = "minute"
* component[remSleep].code = $LOINC#93829-0 "REM sleep duration"
* component[remSleep].valueQuantity = 105 'min' "minute"
* component[remSleep].valueQuantity.system = $UCUM
* component[remSleep].valueQuantity.unit = "minute"
* component[lightSleep].code = $LOINC#93830-8 "Light sleep duration"
* component[lightSleep].valueQuantity = 248 'min' "minute"
* component[lightSleep].valueQuantity.system = $UCUM
* component[lightSleep].valueQuantity.unit = "minute"
* component[respiratoryRate].code = $LOINC#9279-1 "Respiratory rate"
* component[respiratoryRate].valueQuantity = 15 '/min' "per minute"
* component[respiratoryRate].valueQuantity.system = $UCUM
* component[respiratoryRate].valueQuantity.unit = "per minute"
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity = 38 'ms' "millisecond"
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.unit = "millisecond"
* note.text = "Round-trip validation: Fitbit sleep stages mapped via ConceptMapSleepToLOINC. Note: Fitbit reports RMSSD natively (activities-heart-hrv-dailyRmssd) but NO LOINC code exists for RMSSD — gap documented in ConceptMapVendorToLOINC (group[1], element[0], equivalence: unmatched)."

// =============================================================================
// BUNDLE 3: Garmin Physical Activity Round-Trip
// Vendor: Garmin Health API
// Domain: Physical Activity
// ConceptMap: ConceptMapVendorToLOINC (group[2])
// Translation: dailySteps → LOINC 55423-8, restingHeartRate → 40443-4,
//              maxHeartRate → 8873-2
// =============================================================================

Instance: RoundTripGarminActivity
InstanceOf: Bundle
Usage: #example
Title: "Round-Trip Validation: Garmin Activity"
Description: "Demonstrates Garmin Health API activity data transformation to FHIR. Vendor codes dailySteps, restingHeartRate, and maxHeartRate map to LOINC codes 55423-8, 40443-4, and 8873-2 respectively via ConceptMapVendorToLOINC (group[2])."

* type = #collection
* timestamp = "2026-03-05T08:30:00Z"

* entry[0].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* entry[0].resource = PatientRoundTrip

* entry[1].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440007"
* entry[1].resource = DeviceGarminVenu

* entry[2].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440008"
* entry[2].resource = ObsGarminActivity

* entry[3].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440009"
* entry[3].resource = ObsGarminHeartRate

Instance: ObsGarminActivity
InstanceOf: PhysicalActivityObservation
Usage: #inline
Title: "Garmin Activity → LOINC Activity Codes"
Description: "Garmin daily activity data mapped to LOINC codes for steps, distance, duration, and energy expenditure"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $SCT#129006008 "Walking"
* subject.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* effectiveDateTime = "2026-03-04T00:00:00Z"
* device.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440007"
* component[steps].code = $LOINC#55423-8 "Number of steps in unspecified time Pedometer"
* component[steps].valueQuantity = 11234 '1' "count"
* component[steps].valueQuantity.system = $UCUM
* component[steps].valueQuantity.unit = "count"
* component[distance].code = $LOINC#55430-3 "Walking distance unspecified time Pedometer"
* component[distance].valueQuantity = 8.7 'km' "kilometer"
* component[distance].valueQuantity.system = $UCUM
* component[distance].valueQuantity.unit = "kilometer"
* component[duration].code = $LOINC#55411-3 "Exercise duration"
* component[duration].valueQuantity = 95 'min' "minute"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.unit = "minute"
* component[energy].code = $LOINC#55424-6 "Calories burned in unspecified time Pedometer"
* component[energy].valueQuantity = 487 'kcal' "kilocalorie"
* component[energy].valueQuantity.system = $UCUM
* component[energy].valueQuantity.unit = "kilocalorie"
* note.text = "Round-trip validation: Garmin Health API dailySteps → LOINC 55423-8 via ConceptMapVendorToLOINC (group[2], element[0]). Equivalence: equivalent."

Instance: ObsGarminHeartRate
InstanceOf: HeartRateObservation
Usage: #inline
Title: "Garmin Heart Rate → LOINC 8867-4"
Description: "Garmin resting heart rate with max heart rate component"
* status = #final
* code = $LOINC#8867-4 "Heart rate"
* subject.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* effectiveDateTime = "2026-03-04T08:00:00Z"
* device.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440007"
* valueQuantity = 58 '/min' "per minute"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "per minute"
* note.text = "Round-trip validation: Garmin restingHeartRate → LOINC 40443-4 via ConceptMapVendorToLOINC (group[2], element[1]). Equivalence: equivalent."

// =============================================================================
// BUNDLE 4: Oura Ring Sleep + Body Metrics Round-Trip
// Vendor: Oura Cloud API v2
// Domain: Sleep + Body Metrics (overnight HR, respiratory rate)
// ConceptMap: ConceptMapVendorToLOINC (group[4])
// Translation: hr_lowest → LOINC 8883-1 (narrower), hr_average → 41924-2,
//              breathing_rate → 9279-1
// =============================================================================

Instance: RoundTripOuraSleep
InstanceOf: Bundle
Usage: #example
Title: "Round-Trip Validation: Oura Ring Sleep"
Description: "Demonstrates Oura Ring overnight data transformation to FHIR. Vendor codes hr_lowest, hr_average, and breathing_rate map to LOINC 8883-1 (narrower equivalence — Oura is overnight-only vs 24h), 41924-2, and 9279-1 via ConceptMapVendorToLOINC (group[4])."

* type = #collection
* timestamp = "2026-03-05T08:30:00Z"

* entry[0].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* entry[0].resource = PatientRoundTrip

* entry[1].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440010"
* entry[1].resource = DeviceOuraRing

* entry[2].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440011"
* entry[2].resource = ObsOuraSleep

Instance: ObsOuraSleep
InstanceOf: SleepObservation
Usage: #inline
Title: "Oura Sleep → LOINC Sleep Codes"
Description: "Oura Ring overnight sleep data mapped to LOINC. Demonstrates narrower equivalence for overnight-only metrics mapped to 24h LOINC codes."
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LIFESTYLEOBS#sleep-panel "Sleep measurement panel"
* subject.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* effectivePeriod.start = "2026-03-04T22:30:00Z"
* effectivePeriod.end = "2026-03-05T06:15:00Z"
* device.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440010"
* component[totalSleepTime].code = $LOINC#93832-4 "Sleep duration"
* component[totalSleepTime].valueQuantity = 445 'min' "minute"
* component[totalSleepTime].valueQuantity.system = $UCUM
* component[totalSleepTime].valueQuantity.unit = "minute"
* component[deepSleep].code = $LOINC#93831-6 "Deep sleep duration"
* component[deepSleep].valueQuantity = 91 'min' "minute"
* component[deepSleep].valueQuantity.system = $UCUM
* component[deepSleep].valueQuantity.unit = "minute"
* component[remSleep].code = $LOINC#93829-0 "REM sleep duration"
* component[remSleep].valueQuantity = 112 'min' "minute"
* component[remSleep].valueQuantity.system = $UCUM
* component[remSleep].valueQuantity.unit = "minute"
* component[lightSleep].code = $LOINC#93830-8 "Light sleep duration"
* component[lightSleep].valueQuantity = 242 'min' "minute"
* component[lightSleep].valueQuantity.system = $UCUM
* component[lightSleep].valueQuantity.unit = "minute"
* component[respiratoryRate].code = $LOINC#9279-1 "Respiratory rate"
* component[respiratoryRate].valueQuantity = 13 '/min' "per minute"
* component[respiratoryRate].valueQuantity.system = $UCUM
* component[respiratoryRate].valueQuantity.unit = "per minute"
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity = 52 'ms' "millisecond"
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.unit = "millisecond"
* note.text = "Round-trip validation: Oura Cloud API hr_lowest → LOINC 8883-1 (equivalence: narrower — overnight-only vs 24h). breathing_rate → LOINC 9279-1 (equivalent). hrv_balance is a proprietary score with NO LOINC equivalent (unmatched in ConceptMapVendorToLOINC group[4], element[0])."

// =============================================================================
// BUNDLE 5: Withings Blood Pressure Round-Trip
// Vendor: Withings Health Mate API
// Domain: Cardiovascular (Blood Pressure)
// ConceptMap: Standard LOINC (no vendor ConceptMap needed — BP uses standard codes)
// Translation: Direct LOINC mapping (85354-9 panel, 8480-6 systolic, 8462-4 diastolic)
// =============================================================================

Instance: RoundTripWithingsBP
InstanceOf: Bundle
Usage: #example
Title: "Round-Trip Validation: Withings Blood Pressure"
Description: "Demonstrates Withings BPM Connect blood pressure transformation to FHIR. Blood pressure uses standard LOINC codes directly (85354-9 panel, 8480-6 systolic, 8462-4 diastolic) — no ConceptMap translation needed as Withings BP metrics align directly with LOINC."

* type = #collection
* timestamp = "2026-03-05T08:30:00Z"

* entry[0].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* entry[0].resource = PatientRoundTrip

* entry[1].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440012"
* entry[1].resource = DeviceWithingsBPM

* entry[2].fullUrl = "urn:uuid:550e8400-e29b-41d4-a716-446655440013"
* entry[2].resource = ObsWithingsBP

Instance: ObsWithingsBP
InstanceOf: BloodPressureObservation
Usage: #inline
Title: "Withings BP → LOINC BP Panel"
Description: "Withings BPM Connect blood pressure mapped to standard LOINC BP panel codes"
* status = #final
* code = $LOINC#85354-9 "Blood pressure panel with all children optional"
* subject.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440001"
* effectiveDateTime = "2026-03-05T07:30:00Z"
* device.reference = "urn:uuid:550e8400-e29b-41d4-a716-446655440012"
* component[systolic].code = $LOINC#8480-6 "Systolic blood pressure"
* component[systolic].valueQuantity = 118 'mm[Hg]' "millimeter of mercury"
* component[systolic].valueQuantity.system = $UCUM
* component[systolic].valueQuantity.unit = "millimeter of mercury"
* component[diastolic].code = $LOINC#8462-4 "Diastolic blood pressure"
* component[diastolic].valueQuantity = 76 'mm[Hg]' "millimeter of mercury"
* component[diastolic].valueQuantity.system = $UCUM
* component[diastolic].valueQuantity.unit = "millimeter of mercury"
* note.text = "Round-trip validation: Withings BPM Connect blood pressure. BP is a domain where vendor data maps directly to LOINC without proprietary codes — contrasts with HRV/sleep where vendor-specific ConceptMaps are essential."
