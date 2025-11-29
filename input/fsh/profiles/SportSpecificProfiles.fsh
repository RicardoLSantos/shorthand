// Sport-Specific FHIR Profiles for iOS Lifestyle Medicine IG
// Based on openEHR archetypes: cycling_dynamics.v0, running_dynamics.v0, swimming_metrics.v0, strength_training.v0
// Created: 2025-11-28 as part of FHIR IG expansion aligned with thesis requirements
// Author: Ricardo Lourenco dos Santos, FMUP

Alias: $LOINC = http://loinc.org
Alias: $SNOMED = http://snomed.info/sct
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

// ============================================================================
// CYCLING DYNAMICS PROFILE
// ============================================================================

Profile: CyclingDynamicsObservation
Parent: Observation
Id: cycling-dynamics-observation
Title: "Cycling Dynamics Observation Profile"
Description: "Profile for recording cycling dynamics and power metrics from wearable devices, cycling computers, and smart trainers. Supports FTP, TSS, power zones, and pedaling dynamics aligned with openEHR archetype cycling_dynamics.v0."

* status MS
* category 1..1 MS
* category = $ObsCat#activity "Activity"
* code 1..1 MS
* code = $LOINC#73985-4 "Exercise activity"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] only dateTime
* effectiveDateTime 1..1 MS
* device 0..1 MS
* device only Reference(Device)
* note 0..*

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^slicing.description = "Slice based on the component code"

* component contains
    instantaneousPower 0..1 MS and
    averagePower 0..1 MS and
    normalizedPower 0..1 MS and
    maxPower 0..1 MS and
    ftp 0..1 MS and
    tss 0..1 MS and
    intensityFactor 0..1 MS and
    cadence 0..1 MS and
    avgCadence 0..1 MS and
    leftRightBalance 0..1 MS and
    kilojoules 0..1 MS and
    duration 0..1 MS and
    distance 0..1 MS and
    avgSpeed 0..1 MS and
    elevationGain 0..1 MS and
    trainingZone 0..1 and
    activityType 0..1

// Power metrics
* component[instantaneousPower].code = CyclingMetricsCS#instant-power "Instantaneous Power"
* component[instantaneousPower].value[x] only Quantity
* component[instantaneousPower].valueQuantity.system = $UCUM
* component[instantaneousPower].valueQuantity.code = #W

* component[averagePower].code = CyclingMetricsCS#avg-power "Average Power"
* component[averagePower].value[x] only Quantity
* component[averagePower].valueQuantity.system = $UCUM
* component[averagePower].valueQuantity.code = #W

* component[normalizedPower].code = CyclingMetricsCS#np "Normalized Power"
* component[normalizedPower].value[x] only Quantity
* component[normalizedPower].valueQuantity.system = $UCUM
* component[normalizedPower].valueQuantity.code = #W

* component[maxPower].code = CyclingMetricsCS#max-power "Maximum Power"
* component[maxPower].value[x] only Quantity
* component[maxPower].valueQuantity.system = $UCUM
* component[maxPower].valueQuantity.code = #W

// FTP and training load
* component[ftp].code = CyclingMetricsCS#ftp "Functional Threshold Power"
* component[ftp].value[x] only Quantity
* component[ftp].valueQuantity.system = $UCUM
* component[ftp].valueQuantity.code = #W

* component[tss].code = CyclingMetricsCS#tss "Training Stress Score"
* component[tss].value[x] only Quantity
* component[tss].valueQuantity.system = $UCUM
* component[tss].valueQuantity.code = #{score}

* component[intensityFactor].code = CyclingMetricsCS#if "Intensity Factor"
* component[intensityFactor].value[x] only Quantity
* component[intensityFactor].valueQuantity.system = $UCUM
* component[intensityFactor].valueQuantity.code = #1

// Cadence
* component[cadence].code = CyclingMetricsCS#cadence "Cadence"
* component[cadence].value[x] only Quantity
* component[cadence].valueQuantity.system = $UCUM
* component[cadence].valueQuantity.code = #{rpm}

* component[avgCadence].code = CyclingMetricsCS#avg-cadence "Average Cadence"
* component[avgCadence].value[x] only Quantity
* component[avgCadence].valueQuantity.system = $UCUM
* component[avgCadence].valueQuantity.code = #{rpm}

// Balance
* component[leftRightBalance].code = CyclingMetricsCS#lr-balance "Left/Right Power Balance"
* component[leftRightBalance].value[x] only Quantity
* component[leftRightBalance].valueQuantity.system = $UCUM
* component[leftRightBalance].valueQuantity.code = #%

// Energy and session metrics
* component[kilojoules].code = CyclingMetricsCS#kj "Kilojoules"
* component[kilojoules].value[x] only Quantity
* component[kilojoules].valueQuantity.system = $UCUM
* component[kilojoules].valueQuantity.code = #kJ

* component[duration].code = $LOINC#55411-3 "Exercise duration"
* component[duration].value[x] only Quantity
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min

* component[distance].code = $LOINC#55430-3 "Walking distance unspecified time Pedometer"
* component[distance].value[x] only Quantity
* component[distance].valueQuantity.system = $UCUM
* component[distance].valueQuantity.code = #km

* component[avgSpeed].code = CyclingMetricsCS#avg-speed "Average Speed"
* component[avgSpeed].value[x] only Quantity
* component[avgSpeed].valueQuantity.system = $UCUM
* component[avgSpeed].valueQuantity.code = #km/h

* component[elevationGain].code = CyclingMetricsCS#elevation "Elevation Gain"
* component[elevationGain].value[x] only Quantity
* component[elevationGain].valueQuantity.system = $UCUM
* component[elevationGain].valueQuantity.code = #m

* component[trainingZone].code = CyclingMetricsCS#zone "Training Zone"
* component[trainingZone].value[x] only CodeableConcept
* component[trainingZone].valueCodeableConcept from CyclingTrainingZoneVS (required)

* component[activityType].code = CyclingMetricsCS#type "Activity Type"
* component[activityType].value[x] only CodeableConcept
* component[activityType].valueCodeableConcept from CyclingActivityTypeVS (required)


// ============================================================================
// RUNNING DYNAMICS PROFILE
// ============================================================================

Profile: RunningDynamicsObservation
Parent: Observation
Id: running-dynamics-observation
Title: "Running Dynamics Observation Profile"
Description: "Profile for recording running form and biomechanical metrics from wearable devices and running pods. Supports ground contact time, vertical oscillation, cadence, stride length, and running power aligned with openEHR archetype running_dynamics.v0."

* status MS
* category 1..1 MS
* category = $ObsCat#activity "Activity"
* code 1..1 MS
* code = $LOINC#73985-4 "Exercise activity"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] only dateTime
* effectiveDateTime 1..1 MS
* device 0..1 MS
* device only Reference(Device)
* note 0..*

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    groundContactTime 0..1 MS and
    groundContactBalance 0..1 and
    verticalOscillation 0..1 MS and
    verticalRatio 0..1 and
    cadence 0..1 MS and
    strideLength 0..1 MS and
    runningPower 0..1 MS and
    formPower 0..1 and
    formPowerRatio 0..1 and
    legStiffness 0..1 and
    impactGs 0..1 and
    footstrikeType 0..1 and
    pace 0..1 MS and
    avgSpeed 0..1 and
    distance 0..1 MS and
    duration 0..1 MS and
    elevationGain 0..1 and
    symmetryScore 0..1 and
    formScore 0..1 and
    injuryRisk 0..1

// Ground contact metrics
* component[groundContactTime].code = RunningMetricsCS#gct "Ground Contact Time"
* component[groundContactTime].value[x] only Quantity
* component[groundContactTime].valueQuantity.system = $UCUM
* component[groundContactTime].valueQuantity.code = #ms

* component[groundContactBalance].code = RunningMetricsCS#gcb "Ground Contact Balance"
* component[groundContactBalance].value[x] only Quantity
* component[groundContactBalance].valueQuantity.system = $UCUM
* component[groundContactBalance].valueQuantity.code = #%

// Vertical motion
* component[verticalOscillation].code = RunningMetricsCS#vo "Vertical Oscillation"
* component[verticalOscillation].value[x] only Quantity
* component[verticalOscillation].valueQuantity.system = $UCUM
* component[verticalOscillation].valueQuantity.code = #cm

* component[verticalRatio].code = RunningMetricsCS#vr "Vertical Ratio"
* component[verticalRatio].value[x] only Quantity
* component[verticalRatio].valueQuantity.system = $UCUM
* component[verticalRatio].valueQuantity.code = #%

// Cadence and stride
* component[cadence].code = RunningMetricsCS#cadence "Running Cadence"
* component[cadence].value[x] only Quantity
* component[cadence].valueQuantity.system = $UCUM
* component[cadence].valueQuantity.code = #{spm}

* component[strideLength].code = RunningMetricsCS#stride "Stride Length"
* component[strideLength].value[x] only Quantity
* component[strideLength].valueQuantity.system = $UCUM
* component[strideLength].valueQuantity.code = #m

// Running power (Stryd, Garmin, etc.)
* component[runningPower].code = RunningMetricsCS#power "Running Power"
* component[runningPower].value[x] only Quantity
* component[runningPower].valueQuantity.system = $UCUM
* component[runningPower].valueQuantity.code = #W

* component[formPower].code = RunningMetricsCS#form-power "Form Power"
* component[formPower].value[x] only Quantity
* component[formPower].valueQuantity.system = $UCUM
* component[formPower].valueQuantity.code = #W

* component[formPowerRatio].code = RunningMetricsCS#fpr "Form Power Ratio"
* component[formPowerRatio].value[x] only Quantity
* component[formPowerRatio].valueQuantity.system = $UCUM
* component[formPowerRatio].valueQuantity.code = #%

// Leg stiffness and impact
* component[legStiffness].code = RunningMetricsCS#stiffness "Leg Stiffness"
* component[legStiffness].value[x] only Quantity
* component[legStiffness].valueQuantity.system = $UCUM
* component[legStiffness].valueQuantity.code = #kN/m

* component[impactGs].code = RunningMetricsCS#impact "Impact G-forces"
* component[impactGs].value[x] only Quantity
* component[impactGs].valueQuantity.system = $UCUM
* component[impactGs].valueQuantity.code = #g

* component[footstrikeType].code = RunningMetricsCS#footstrike "Footstrike Type"
* component[footstrikeType].value[x] only CodeableConcept
* component[footstrikeType].valueCodeableConcept from FootstrikeTypeVS (required)

// Session metrics
* component[pace].code = RunningMetricsCS#pace "Pace"
* component[pace].value[x] only Quantity
* component[pace].valueQuantity.system = $UCUM
* component[pace].valueQuantity.code = #min/km

* component[avgSpeed].code = RunningMetricsCS#speed "Average Speed"
* component[avgSpeed].value[x] only Quantity
* component[avgSpeed].valueQuantity.system = $UCUM
* component[avgSpeed].valueQuantity.code = #km/h

* component[distance].code = $LOINC#55430-3 "Walking distance unspecified time Pedometer"
* component[distance].value[x] only Quantity
* component[distance].valueQuantity.system = $UCUM
* component[distance].valueQuantity.code = #km

* component[duration].code = $LOINC#55411-3 "Exercise duration"
* component[duration].value[x] only Quantity
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min

* component[elevationGain].code = RunningMetricsCS#elevation "Elevation Gain"
* component[elevationGain].value[x] only Quantity
* component[elevationGain].valueQuantity.system = $UCUM
* component[elevationGain].valueQuantity.code = #m

// Scores
* component[symmetryScore].code = RunningMetricsCS#symmetry "Symmetry Score"
* component[symmetryScore].value[x] only Quantity
* component[symmetryScore].valueQuantity.system = $UCUM
* component[symmetryScore].valueQuantity.code = #%

* component[formScore].code = RunningMetricsCS#form-score "Form Score"
* component[formScore].value[x] only integer

* component[injuryRisk].code = RunningMetricsCS#injury-risk "Injury Risk"
* component[injuryRisk].value[x] only CodeableConcept
* component[injuryRisk].valueCodeableConcept from InjuryRiskLevelVS (required)


// ============================================================================
// SWIMMING METRICS PROFILE
// ============================================================================

Profile: SwimmingMetricsObservation
Parent: Observation
Id: swimming-metrics-observation
Title: "Swimming Metrics Observation Profile"
Description: "Profile for recording swimming performance metrics from wearable devices. Supports SWOLF score, stroke metrics, lap analysis, and pace aligned with openEHR archetype swimming_metrics.v0."

* status MS
* category 1..1 MS
* category = $ObsCat#activity "Activity"
* code 1..1 MS
* code = $SNOMED#20461001 "Swimming (qualifier value)"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] only dateTime
* effectiveDateTime 1..1 MS
* device 0..1 MS
* device only Reference(Device)
* note 0..*

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    totalDistance 0..1 MS and
    totalDuration 0..1 MS and
    totalLaps 0..1 MS and
    totalStrokes 0..1 and
    activeSwimTime 0..1 and
    restTime 0..1 and
    primaryStrokeType 0..1 MS and
    strokesPerLap 0..1 and
    strokeRate 0..1 and
    distancePerStroke 0..1 MS and
    avgSwolf 0..1 MS and
    bestSwolf 0..1 and
    avgPace 0..1 MS and
    bestPace 0..1 and
    avgSpeed 0..1 and
    poolLength 0..1 and
    swimmingEnvironment 0..1 and
    avgHeartRate 0..1 and
    maxHeartRate 0..1 and
    aerobicTE 0..1 and
    anaerobicTE 0..1 and
    caloriesBurned 0..1

// Session summary
* component[totalDistance].code = SwimmingMetricsCS#distance "Total Distance"
* component[totalDistance].value[x] only Quantity
* component[totalDistance].valueQuantity.system = $UCUM
* component[totalDistance].valueQuantity.code = #m

* component[totalDuration].code = $LOINC#55411-3 "Exercise duration"
* component[totalDuration].value[x] only Quantity
* component[totalDuration].valueQuantity.system = $UCUM
* component[totalDuration].valueQuantity.code = #min

* component[totalLaps].code = SwimmingMetricsCS#laps "Total Laps"
* component[totalLaps].value[x] only integer

* component[totalStrokes].code = SwimmingMetricsCS#strokes "Total Strokes"
* component[totalStrokes].value[x] only integer

* component[activeSwimTime].code = SwimmingMetricsCS#active-time "Active Swim Time"
* component[activeSwimTime].value[x] only Quantity
* component[activeSwimTime].valueQuantity.system = $UCUM
* component[activeSwimTime].valueQuantity.code = #min

* component[restTime].code = SwimmingMetricsCS#rest-time "Rest Time"
* component[restTime].value[x] only Quantity
* component[restTime].valueQuantity.system = $UCUM
* component[restTime].valueQuantity.code = #min

// Stroke metrics
* component[primaryStrokeType].code = SwimmingMetricsCS#stroke-type "Primary Stroke Type"
* component[primaryStrokeType].value[x] only CodeableConcept
* component[primaryStrokeType].valueCodeableConcept from SwimmingStrokeTypeVS (required)

* component[strokesPerLap].code = SwimmingMetricsCS#strokes-per-lap "Strokes Per Lap"
* component[strokesPerLap].value[x] only integer

* component[strokeRate].code = SwimmingMetricsCS#stroke-rate "Stroke Rate"
* component[strokeRate].value[x] only Quantity
* component[strokeRate].valueQuantity.system = $UCUM
* component[strokeRate].valueQuantity.code = #{spm}

* component[distancePerStroke].code = SwimmingMetricsCS#dps "Distance Per Stroke"
* component[distancePerStroke].value[x] only Quantity
* component[distancePerStroke].valueQuantity.system = $UCUM
* component[distancePerStroke].valueQuantity.code = #m

// SWOLF (Swimming Golf Score = time + strokes)
* component[avgSwolf].code = SwimmingMetricsCS#avg-swolf "Average SWOLF"
* component[avgSwolf].value[x] only integer

* component[bestSwolf].code = SwimmingMetricsCS#best-swolf "Best SWOLF"
* component[bestSwolf].value[x] only integer

// Pace metrics
* component[avgPace].code = SwimmingMetricsCS#avg-pace "Average Pace"
* component[avgPace].value[x] only Quantity
* component[avgPace].valueQuantity.system = $UCUM
* component[avgPace].valueQuantity.code = #s/100m

* component[bestPace].code = SwimmingMetricsCS#best-pace "Best Pace"
* component[bestPace].value[x] only Quantity
* component[bestPace].valueQuantity.system = $UCUM
* component[bestPace].valueQuantity.code = #s/100m

* component[avgSpeed].code = SwimmingMetricsCS#speed "Average Speed"
* component[avgSpeed].value[x] only Quantity
* component[avgSpeed].valueQuantity.system = $UCUM
* component[avgSpeed].valueQuantity.code = #m/s

// Environment
* component[poolLength].code = SwimmingMetricsCS#pool-length "Pool Length"
* component[poolLength].value[x] only Quantity
* component[poolLength].valueQuantity.system = $UCUM
* component[poolLength].valueQuantity.code = #m

* component[swimmingEnvironment].code = SwimmingMetricsCS#environment "Swimming Environment"
* component[swimmingEnvironment].value[x] only CodeableConcept
* component[swimmingEnvironment].valueCodeableConcept from SwimmingEnvironmentVS (required)

// Heart rate
* component[avgHeartRate].code = $LOINC#8867-4 "Heart rate"
* component[avgHeartRate].value[x] only Quantity
* component[avgHeartRate].valueQuantity.system = $UCUM
* component[avgHeartRate].valueQuantity.code = #{beats}/min

* component[maxHeartRate].code = SwimmingMetricsCS#max-hr "Maximum Heart Rate"
* component[maxHeartRate].value[x] only Quantity
* component[maxHeartRate].valueQuantity.system = $UCUM
* component[maxHeartRate].valueQuantity.code = #{beats}/min

// Training effect
* component[aerobicTE].code = SwimmingMetricsCS#aerobic-te "Aerobic Training Effect"
* component[aerobicTE].value[x] only Quantity
* component[aerobicTE].valueQuantity.system = $UCUM
* component[aerobicTE].valueQuantity.code = #1

* component[anaerobicTE].code = SwimmingMetricsCS#anaerobic-te "Anaerobic Training Effect"
* component[anaerobicTE].value[x] only Quantity
* component[anaerobicTE].valueQuantity.system = $UCUM
* component[anaerobicTE].valueQuantity.code = #1

* component[caloriesBurned].code = $LOINC#55424-6 "Calories burned in unspecified time Pedometer"
* component[caloriesBurned].value[x] only Quantity
* component[caloriesBurned].valueQuantity.system = $UCUM
* component[caloriesBurned].valueQuantity.code = #kcal


// ============================================================================
// STRENGTH TRAINING PROFILE
// ============================================================================

Profile: StrengthTrainingObservation
Parent: Observation
Id: strength-training-observation
Title: "Strength Training Observation Profile"
Description: "Profile for recording strength training metrics from wearable devices, velocity-based training systems, and gym equipment. Supports sets, reps, load, velocity-based metrics, and training load aligned with openEHR archetype strength_training.v0."

* status MS
* category 1..1 MS
* category = $ObsCat#activity "Activity"
* code 1..1 MS
* code = $LOINC#73985-4 "Exercise activity"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] only dateTime
* effectiveDateTime 1..1 MS
* device 0..1 MS
* device only Reference(Device)
* note 0..*

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    exerciseName 0..1 MS and
    exerciseCategory 0..1 and
    muscleGroup 0..* and
    equipmentType 0..1 and
    setNumber 0..1 and
    setType 0..1 and
    repsPerformed 0..1 MS and
    targetReps 0..1 and
    load 0..1 MS and
    percentOf1RM 0..1 and
    repsInReserve 0..1 and
    setRPE 0..1 and
    restPeriod 0..1 and
    meanVelocity 0..1 and
    peakVelocity 0..1 and
    velocityLoss 0..1 and
    meanPower 0..1 and
    peakPower 0..1 and
    rangeOfMotion 0..1 and
    timeUnderTension 0..1 and
    totalSets 0..1 MS and
    totalReps 0..1 MS and
    volumeLoad 0..1 MS and
    tested1RM 0..1 and
    estimated1RM 0..1 and
    sessionDuration 0..1 and
    sessionRPE 0..1 MS and
    sessionTrainingLoad 0..1 and
    trainingType 0..1

// Exercise identification
* component[exerciseName].code = StrengthTrainingCS#exercise-name "Exercise Name"
* component[exerciseName].value[x] only string

* component[exerciseCategory].code = StrengthTrainingCS#category "Exercise Category"
* component[exerciseCategory].value[x] only CodeableConcept
* component[exerciseCategory].valueCodeableConcept from ExerciseCategoryVS (required)

* component[muscleGroup].code = StrengthTrainingCS#muscle "Primary Muscle Group"
* component[muscleGroup].value[x] only CodeableConcept
* component[muscleGroup].valueCodeableConcept from MuscleGroupVS (required)

* component[equipmentType].code = StrengthTrainingCS#equipment "Equipment Type"
* component[equipmentType].value[x] only CodeableConcept
* component[equipmentType].valueCodeableConcept from StrengthEquipmentVS (required)

// Set details
* component[setNumber].code = StrengthTrainingCS#set-num "Set Number"
* component[setNumber].value[x] only integer

* component[setType].code = StrengthTrainingCS#set-type "Set Type"
* component[setType].value[x] only CodeableConcept
* component[setType].valueCodeableConcept from SetTypeVS (required)

* component[repsPerformed].code = StrengthTrainingCS#reps "Repetitions Performed"
* component[repsPerformed].value[x] only integer

* component[targetReps].code = StrengthTrainingCS#target-reps "Target Repetitions"
* component[targetReps].value[x] only integer

* component[load].code = StrengthTrainingCS#load "Load"
* component[load].value[x] only Quantity
* component[load].valueQuantity.system = $UCUM
* component[load].valueQuantity.code = #kg

* component[percentOf1RM].code = StrengthTrainingCS#pct-1rm "Percentage of 1RM"
* component[percentOf1RM].value[x] only Quantity
* component[percentOf1RM].valueQuantity.system = $UCUM
* component[percentOf1RM].valueQuantity.code = #%

* component[repsInReserve].code = StrengthTrainingCS#rir "Repetitions in Reserve"
* component[repsInReserve].value[x] only integer

* component[setRPE].code = StrengthTrainingCS#set-rpe "Set RPE"
* component[setRPE].value[x] only integer

* component[restPeriod].code = StrengthTrainingCS#rest "Rest Period"
* component[restPeriod].value[x] only Quantity
* component[restPeriod].valueQuantity.system = $UCUM
* component[restPeriod].valueQuantity.code = #s

// Velocity-based training (VBT)
* component[meanVelocity].code = StrengthTrainingCS#mean-vel "Mean Concentric Velocity"
* component[meanVelocity].value[x] only Quantity
* component[meanVelocity].valueQuantity.system = $UCUM
* component[meanVelocity].valueQuantity.code = #m/s

* component[peakVelocity].code = StrengthTrainingCS#peak-vel "Peak Concentric Velocity"
* component[peakVelocity].value[x] only Quantity
* component[peakVelocity].valueQuantity.system = $UCUM
* component[peakVelocity].valueQuantity.code = #m/s

* component[velocityLoss].code = StrengthTrainingCS#vel-loss "Velocity Loss"
* component[velocityLoss].value[x] only Quantity
* component[velocityLoss].valueQuantity.system = $UCUM
* component[velocityLoss].valueQuantity.code = #%

* component[meanPower].code = StrengthTrainingCS#mean-power "Mean Power Output"
* component[meanPower].value[x] only Quantity
* component[meanPower].valueQuantity.system = $UCUM
* component[meanPower].valueQuantity.code = #W

* component[peakPower].code = StrengthTrainingCS#peak-power "Peak Power Output"
* component[peakPower].value[x] only Quantity
* component[peakPower].valueQuantity.system = $UCUM
* component[peakPower].valueQuantity.code = #W

* component[rangeOfMotion].code = StrengthTrainingCS#rom "Range of Motion"
* component[rangeOfMotion].value[x] only Quantity
* component[rangeOfMotion].valueQuantity.system = $UCUM
* component[rangeOfMotion].valueQuantity.code = #cm

* component[timeUnderTension].code = StrengthTrainingCS#tut "Time Under Tension"
* component[timeUnderTension].value[x] only Quantity
* component[timeUnderTension].valueQuantity.system = $UCUM
* component[timeUnderTension].valueQuantity.code = #s

// Session volume
* component[totalSets].code = StrengthTrainingCS#total-sets "Total Sets"
* component[totalSets].value[x] only integer

* component[totalReps].code = StrengthTrainingCS#total-reps "Total Repetitions"
* component[totalReps].value[x] only integer

* component[volumeLoad].code = StrengthTrainingCS#volume-load "Volume Load"
* component[volumeLoad].value[x] only Quantity
* component[volumeLoad].valueQuantity.system = $UCUM
* component[volumeLoad].valueQuantity.code = #kg

// 1RM
* component[tested1RM].code = StrengthTrainingCS#tested-1rm "Tested 1RM"
* component[tested1RM].value[x] only Quantity
* component[tested1RM].valueQuantity.system = $UCUM
* component[tested1RM].valueQuantity.code = #kg

* component[estimated1RM].code = StrengthTrainingCS#est-1rm "Estimated 1RM"
* component[estimated1RM].value[x] only Quantity
* component[estimated1RM].valueQuantity.system = $UCUM
* component[estimated1RM].valueQuantity.code = #kg

// Session summary
* component[sessionDuration].code = $LOINC#55411-3 "Exercise duration"
* component[sessionDuration].value[x] only Quantity
* component[sessionDuration].valueQuantity.system = $UCUM
* component[sessionDuration].valueQuantity.code = #min

* component[sessionRPE].code = StrengthTrainingCS#session-rpe "Session RPE"
* component[sessionRPE].value[x] only integer

* component[sessionTrainingLoad].code = StrengthTrainingCS#session-load "Session Training Load"
* component[sessionTrainingLoad].value[x] only integer

* component[trainingType].code = StrengthTrainingCS#training-type "Training Type"
* component[trainingType].value[x] only CodeableConcept
* component[trainingType].valueCodeableConcept from StrengthTrainingTypeVS (required)
