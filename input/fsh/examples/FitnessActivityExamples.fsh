// ============================================================================
// Fitness and Activity Profile Examples
// ============================================================================
// Purpose: Example instances for fitness assessment and sport-specific profiles
// Created: 2025-11-30
// Profiles: RecoveryReadinessObservation, VO2maxEstimationObservation,
//           RunningDynamicsObservation, CyclingDynamicsObservation,
//           SwimmingMetricsObservation, StrengthTrainingObservation

Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $SCT = http://snomed.info/sct
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

// ============================================================================
// Recovery Readiness Observation Example
// ============================================================================

Instance: RecoveryReadinessExample
InstanceOf: RecoveryReadinessObservation
Usage: #example
Title: "Recovery Readiness Assessment Example"
Description: "Example of daily recovery readiness score from Oura Ring"

* status = #final
* category = $ObsCat#exam "Exam"
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#readiness "Recovery Readiness Assessment"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T06:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/OuraRingDevice)

// Main readiness score (0-100)
* valueQuantity.value = 82
* valueQuantity.system = $UCUM
* valueQuantity.code = #{score}
* valueQuantity.unit = "{score}"

* interpretation = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#readiness-good "Good (70-84)"

// Readiness category
* component[readinessCategory].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#recovery-category "Readiness Category"
* component[readinessCategory].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#readiness-good "Good (70-84)"

// Trend
* component[trendDirection].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#recovery-trend "Trend Direction"
* component[trendDirection].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#trend-stable "Stable"

// Sleep contribution - uses {score} per profile
* component[sleepContribution].valueQuantity.value = 85
* component[sleepContribution].valueQuantity.system = "http://unitsofmeasure.org"
* component[sleepContribution].valueQuantity.code = #{score}
* component[sleepContribution].valueQuantity.unit = "{score}"

// HRV contribution - uses {score} per profile
* component[hrvContribution].valueQuantity.value = 78
* component[hrvContribution].valueQuantity.system = "http://unitsofmeasure.org"
* component[hrvContribution].valueQuantity.code = #{score}
* component[hrvContribution].valueQuantity.unit = "{score}"

// Activity balance - uses CodeableConcept
* component[activityBalance].valueCodeableConcept = LifestyleMedicineTemporaryCS#balanced "Well Balanced"

// Recommended activity
* component[recommendedActivity].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#rec-activity "Recommended Activity"
* component[recommendedActivity].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#recommended-moderate "Moderate Training"

* note.text = "Good recovery. Ready for moderate training. Sleep quality was optimal."


// ============================================================================
// VO2max Estimation Observation Example
// ============================================================================

Instance: VO2maxEstimationExample
InstanceOf: VO2MaxEstimationObservation
Usage: #example
Title: "VO2max Estimation Example"
Description: "Example of VO2max estimation from Apple Watch during outdoor run"

* status = #final
// category and code are fixed by profile (exam, LOINC#60842-2)
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T07:45:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

// Main VO2max value
* valueQuantity = 42.5 'mL/kg/min' "milliliters per kilogram per minute"

// CRF Category - code is fixed by profile (LifestyleMedicineTemporaryCS#crf)
* component[crfCategory].valueCodeableConcept = LifestyleMedicineTemporaryCS#crf-category-good "Good"

// Estimation method - code is fixed by profile (LifestyleMedicineTemporaryCS#method)
* component[methodType].valueCodeableConcept = LifestyleMedicineTemporaryCS#submaximal "Submaximal Test"

// Validation status - code is fixed by profile (LifestyleMedicineTemporaryCS#validation)
* component[validationStatus].valueCodeableConcept = LifestyleMedicineTemporaryCS#validation-clinical "Clinically Validated"

// Trend - code is fixed by profile (LifestyleMedicineTemporaryCS#vo2max-trend)
* component[vo2maxTrend].valueCodeableConcept = LifestyleMedicineTemporaryCS#vo2max-trend-improving "Improving"

// Cardiovascular risk - code is fixed by profile (LifestyleMedicineTemporaryCS#cv-risk)
* component[cvRiskCategory].valueCodeableConcept = LifestyleMedicineTemporaryCS#cv-risk-low "Low Risk"

* note.text = "VO2max estimated during 30-min outdoor run at moderate intensity. Above average for age/sex."


// ============================================================================
// Running Dynamics Observation Example
// ============================================================================

Instance: RunningDynamicsExample
InstanceOf: RunningDynamicsObservation
Usage: #example
Title: "Running Dynamics Assessment Example"
Description: "Example of running dynamics metrics from Garmin watch with running pod"

* status = #final
// category and code are fixed by profile (activity, LOINC#73985-4)
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T07:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/GarminWatchDevice)

// Cadence - uses {spm} per profile
* component[cadence].valueQuantity = 175 '{spm}' "{spm} steps per minute"

// Ground contact time
* component[groundContactTime].valueQuantity = 245 'ms' "milliseconds"

// Vertical oscillation
* component[verticalOscillation].valueQuantity = 8.2 'cm' "centimeters"

// Stride length
* component[strideLength].valueQuantity = 1.15 'm' "meters"

// Pace
* component[pace].valueQuantity = 5.5 'min/km' "minutes per kilometer"

// Distance
* component[distance].valueQuantity = 10 'km' "kilometers"

* note.text = "Good running form with efficient cadence. GCT indicates proper foot strike pattern."


// ============================================================================
// Cycling Dynamics Observation Example
// ============================================================================

Instance: CyclingDynamicsExample
InstanceOf: CyclingDynamicsObservation
Usage: #example
Title: "Cycling Dynamics Assessment Example"
Description: "Example of cycling power and dynamics from Wahoo power meter"

* status = #final
// category and code are fixed by profile (activity, LOINC#73985-4)
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T08:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/WahooPowerMeter)

// Average power
* component[averagePower].valueQuantity = 185 'W' "watts"

// Normalized power
* component[normalizedPower].valueQuantity = 198 'W' "watts"

// Cadence
* component[cadence].valueQuantity = 88 '{rpm}' "{rpm} revolutions per minute"

// TSS (Training Stress Score)
* component[tss].valueQuantity.value = 75
* component[tss].valueQuantity.system = $UCUM
* component[tss].valueQuantity.code = #{score}
* component[tss].valueQuantity.unit = "{score}"

// Duration
* component[duration].valueQuantity = 60 'min' "minutes"

* note.text = "60-minute endurance ride. Steady power output with good pedaling efficiency."


// ============================================================================
// Swimming Metrics Observation Example
// ============================================================================

Instance: SwimmingMetricsExample
InstanceOf: SwimmingMetricsObservation
Usage: #example
Title: "Swimming Metrics Assessment Example"
Description: "Example of swimming metrics from Apple Watch pool swim workout"

* status = #final
// category and code are fixed by profile (activity, SNOMED#20461001 Swimming)
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T06:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

// Total distance
* component[totalDistance].valueQuantity = 2000 'm' "meters"

// Total laps
* component[totalLaps].valueInteger = 80

// Pool length
* component[poolLength].valueQuantity = 25 'm' "meters"

// Average SWOLF (swim efficiency) - integer value per profile
* component[avgSwolf].valueInteger = 42

// Strokes per lap - integer value per profile
* component[strokesPerLap].valueInteger = 18

// Average Pace (120 seconds per 100 meters = 2:00/100m)
* component[avgPace].valueQuantity = 120 's' "seconds"

// Primary stroke type
* component[primaryStrokeType].valueCodeableConcept = LifestyleMedicineTemporaryCS#freestyle "Freestyle"

* note.text = "Pool swim: 80 lengths (25m pool). Good SWOLF score indicates efficient stroke."


// ============================================================================
// Strength Training Observation Example
// ============================================================================

Instance: StrengthTrainingExample
InstanceOf: StrengthTrainingObservation
Usage: #example
Title: "Strength Training Session Example"
Description: "Example of strength training session tracking"

* status = #final
// category and code are fixed by profile (activity, LOINC#73985-4)
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-30T17:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)

// Volume load (total weight lifted) - uses StrengthTrainingCS from profile
* component[volumeLoad].valueQuantity = 8500 'kg' "kilograms"

// Total sets in session - integer value
* component[totalSets].valueInteger = 18

// Total reps - integer value
* component[totalReps].valueInteger = 85

// Session duration - uses LOINC from profile
* component[sessionDuration].valueQuantity = 55 'min' "minutes"

// Session RPE - integer value
* component[sessionRPE].valueInteger = 7

* note.text = "Full body strength session: bench press, squat, deadlift, rows, overhead press, pull-ups."


// ============================================================================
// Device Examples for Fitness
// ============================================================================

Instance: OuraRingDevice
InstanceOf: Device
Usage: #example
Title: "Oura Ring Gen 3"
Description: "Example of Oura Ring sleep and readiness tracker"

* deviceName[0].name = "Oura Ring Generation 3"
* deviceName[0].type = #user-friendly-name
* manufacturer = "Oura Health Oy"
* modelNumber = "Gen 3"


Instance: GarminWatchDevice
InstanceOf: Device
Usage: #example
Title: "Garmin Forerunner 965"
Description: "Example of Garmin multisport watch"

* deviceName[0].name = "Garmin Forerunner 965"
* deviceName[0].type = #user-friendly-name
* manufacturer = "Garmin Ltd."
* modelNumber = "Forerunner 965"


Instance: WahooPowerMeter
InstanceOf: Device
Usage: #example
Title: "Wahoo KICKR Power Meter"
Description: "Example of cycling power meter"

* deviceName[0].name = "Wahoo KICKR POWRLINK"
* deviceName[0].type = #user-friendly-name
* manufacturer = "Wahoo Fitness"
* modelNumber = "POWRLINK ZERO"
