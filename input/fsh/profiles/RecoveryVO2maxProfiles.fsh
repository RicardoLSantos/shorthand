// Recovery Readiness and VO2max Estimation FHIR Profiles
// Based on openEHR archetypes recovery_readiness.v0 and vo2max_estimation.v0
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos, FMUP

Alias: $LOINC = http://loinc.org
Alias: $SNOMED = http://snomed.info/sct
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

// ============================================================================
// RECOVERY READINESS OBSERVATION PROFILE
// ============================================================================

Profile: RecoveryReadinessObservation
Parent: Observation
Id: recovery-readiness-observation
Title: "Recovery Readiness Observation Profile"
Description: "Profile for recording composite recovery and readiness scores from wearable devices including Oura Readiness, WHOOP Recovery, Garmin Body Battery, and similar metrics. Supports strain-recovery balance, training readiness, and contributing factors aligned with openEHR archetype recovery_readiness.v0."

* status MS
* category 1..1 MS
* category = $ObsCat#exam "Exam"
* code 1..1 MS
* code = LifestyleMedicineTemporaryCS#readiness "Recovery Readiness Assessment"
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* device 0..1 MS
* device only Reference(Device)
* note 0..*

// Main readiness score (0-100)
* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #{score}
* valueQuantity 0..1 MS

* interpretation 0..1
* interpretation from ReadinessCategoryVS (required)

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    readinessCategory 0..1 and
    comparedToBaseline 0..1 and
    trendDirection 0..1 and
    ouraReadiness 0..1 and
    whoopRecovery 0..1 and
    garminBodyBattery 0..1 and
    fitbitReadiness 0..1 and
    sleepContribution 0..1 and
    hrvContribution 0..1 and
    restingHRContribution 0..1 and
    activityBalance 0..1 and
    previousDayStrain 0..1 and
    cumulativeStrain7d 0..1 and
    recoveryDebt 0..1 and
    trainingStatus 0..1 and
    recommendedActivity 0..1 and
    optimalStrainToday 0..1 and
    avg7dayReadiness 0..1 and
    avg30dayReadiness 0..1 and
    personalBaseline 0..1 and
    primaryVendor 0..1

// Overall readiness
* component[readinessCategory].code = LifestyleMedicineTemporaryCS#recovery-category "Readiness Category"
* component[readinessCategory].value[x] only CodeableConcept
* component[readinessCategory].valueCodeableConcept from ReadinessCategoryVS (required)

* component[comparedToBaseline].code = LifestyleMedicineTemporaryCS#vs-baseline "Compared to Baseline"
* component[comparedToBaseline].value[x] only CodeableConcept
* component[comparedToBaseline].valueCodeableConcept from BaselineComparisonVS (required)

* component[trendDirection].code = LifestyleMedicineTemporaryCS#recovery-trend "Trend Direction"
* component[trendDirection].value[x] only CodeableConcept
* component[trendDirection].valueCodeableConcept from TrendDirectionVS (required)

// Vendor-specific scores
* component[ouraReadiness].code = LifestyleMedicineTemporaryCS#recovery-oura "Oura Readiness"
* component[ouraReadiness].value[x] only integer

* component[whoopRecovery].code = LifestyleMedicineTemporaryCS#recovery-whoop "WHOOP Recovery"
* component[whoopRecovery].value[x] only Quantity
* component[whoopRecovery].valueQuantity.system = $UCUM
* component[whoopRecovery].valueQuantity.code = #%

* component[garminBodyBattery].code = LifestyleMedicineTemporaryCS#garmin-bb "Garmin Body Battery"
* component[garminBodyBattery].value[x] only integer

* component[fitbitReadiness].code = LifestyleMedicineTemporaryCS#recovery-fitbit "Fitbit Readiness"
* component[fitbitReadiness].value[x] only integer

// Contributing factors
* component[sleepContribution].code = LifestyleMedicineTemporaryCS#sleep-contrib "Sleep Contribution"
* component[sleepContribution].value[x] only Quantity
* component[sleepContribution].valueQuantity.system = $UCUM
* component[sleepContribution].valueQuantity.code = #{score}

* component[hrvContribution].code = LifestyleMedicineTemporaryCS#hrv-contrib "HRV Contribution"
* component[hrvContribution].value[x] only Quantity
* component[hrvContribution].valueQuantity.system = $UCUM
* component[hrvContribution].valueQuantity.code = #{score}

* component[restingHRContribution].code = LifestyleMedicineTemporaryCS#rhr-contrib "Resting HR Contribution"
* component[restingHRContribution].value[x] only Quantity
* component[restingHRContribution].valueQuantity.system = $UCUM
* component[restingHRContribution].valueQuantity.code = #{score}

* component[activityBalance].code = LifestyleMedicineTemporaryCS#activity-bal "Activity Balance"
* component[activityBalance].value[x] only CodeableConcept
* component[activityBalance].valueCodeableConcept from ActivityBalanceVS (required)

// Strain-recovery balance
* component[previousDayStrain].code = LifestyleMedicineTemporaryCS#prev-strain "Previous Day Strain"
* component[previousDayStrain].value[x] only Quantity
* component[previousDayStrain].valueQuantity.system = $UCUM
* component[previousDayStrain].valueQuantity.code = #{score}
* component[previousDayStrain] ^short = "WHOOP scale 0-21"

* component[cumulativeStrain7d].code = LifestyleMedicineTemporaryCS#strain-7d "Cumulative Strain 7d"
* component[cumulativeStrain7d].value[x] only Quantity
* component[cumulativeStrain7d].valueQuantity.system = $UCUM
* component[cumulativeStrain7d].valueQuantity.code = #{score}

* component[recoveryDebt].code = LifestyleMedicineTemporaryCS#debt "Recovery Debt"
* component[recoveryDebt].value[x] only CodeableConcept
* component[recoveryDebt].valueCodeableConcept from RecoveryDebtVS (required)

// Training readiness
* component[trainingStatus].code = LifestyleMedicineTemporaryCS#training-status "Training Status"
* component[trainingStatus].value[x] only CodeableConcept
* component[trainingStatus].valueCodeableConcept from TrainingStatusVS (required)

* component[recommendedActivity].code = LifestyleMedicineTemporaryCS#rec-activity "Recommended Activity"
* component[recommendedActivity].value[x] only CodeableConcept
* component[recommendedActivity].valueCodeableConcept from RecommendedActivityVS (required)

* component[optimalStrainToday].code = LifestyleMedicineTemporaryCS#optimal-strain "Optimal Strain"
* component[optimalStrainToday].value[x] only Quantity
* component[optimalStrainToday].valueQuantity.system = $UCUM
* component[optimalStrainToday].valueQuantity.code = #{score}

// Historical comparison
* component[avg7dayReadiness].code = LifestyleMedicineTemporaryCS#avg-7d "7-Day Average"
* component[avg7dayReadiness].value[x] only Quantity
* component[avg7dayReadiness].valueQuantity.system = $UCUM
* component[avg7dayReadiness].valueQuantity.code = #{score}

* component[avg30dayReadiness].code = LifestyleMedicineTemporaryCS#avg-30d "30-Day Average"
* component[avg30dayReadiness].value[x] only Quantity
* component[avg30dayReadiness].valueQuantity.system = $UCUM
* component[avg30dayReadiness].valueQuantity.code = #{score}

* component[personalBaseline].code = LifestyleMedicineTemporaryCS#recovery-baseline "Personal Baseline"
* component[personalBaseline].value[x] only Quantity
* component[personalBaseline].valueQuantity.system = $UCUM
* component[personalBaseline].valueQuantity.code = #{score}

// Protocol
* component[primaryVendor].code = LifestyleMedicineTemporaryCS#vendor "Primary Vendor"
* component[primaryVendor].value[x] only CodeableConcept
* component[primaryVendor].valueCodeableConcept from WearableVendorVS (required)


// ============================================================================
// VO2MAX ESTIMATION OBSERVATION PROFILE
// ============================================================================

Profile: VO2MaxEstimationObservation
Parent: Observation
Id: vo2max-estimation-observation
Title: "VO2max Estimation Observation Profile"
Description: "Profile for recording estimated maximal oxygen uptake (VO2max) from wearable devices, fitness tests, and predictive algorithms. Supports cardiorespiratory fitness (CRF) classification, fitness age, and trend analysis aligned with openEHR archetype vo2max_estimation.v0."

* status MS
* category 1..1 MS
* category = $ObsCat#exam "Exam"
* code 1..1 MS
* code = $LOINC#60842-2 "Oxygen consumption (VO2)"
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* device 0..1 MS
* device only Reference(Device)
* note 0..*

// Main VO2max value
* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code from VO2maxUnitVS (required)
* valueQuantity 0..1 MS

* interpretation 0..1
* interpretation from CRFCategoryVS (required)

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    confidenceLower 0..1 and
    confidenceUpper 0..1 and
    estimationAccuracy 0..1 and
    crfCategory 0..1 MS and
    percentileRank 0..1 and
    fitnessAge 0..1 MS and
    classificationStandard 0..1 and
    methodType 0..1 MS and
    specificProtocol 0..1 and
    validationStatus 0..1 and
    restingHRUsed 0..1 and
    maxHRUsed 0..1 and
    hrMaxDetermination 0..1 and
    vo2maxTrend 0..1 MS and
    changeFromBaseline 0..1 and
    percentChange 0..1 and
    baselineValue 0..1 and
    cvRiskCategory 0..1 and
    metCapacity 0..1 and
    dataSource 0..1

// Confidence interval
* component[confidenceLower].code = LifestyleMedicineTemporaryCS#ci-lower "CI Lower"
* component[confidenceLower].value[x] only Quantity
* component[confidenceLower].valueQuantity.system = $UCUM
* component[confidenceLower].valueQuantity.code = #mL/kg/min

* component[confidenceUpper].code = LifestyleMedicineTemporaryCS#ci-upper "CI Upper"
* component[confidenceUpper].value[x] only Quantity
* component[confidenceUpper].valueQuantity.system = $UCUM
* component[confidenceUpper].valueQuantity.code = #mL/kg/min

* component[estimationAccuracy].code = LifestyleMedicineTemporaryCS#accuracy "Accuracy"
* component[estimationAccuracy].value[x] only Quantity
* component[estimationAccuracy].valueQuantity.system = $UCUM
* component[estimationAccuracy].valueQuantity.code = #%

// Fitness classification
* component[crfCategory].code = LifestyleMedicineTemporaryCS#crf "CRF Category"
* component[crfCategory].value[x] only CodeableConcept
* component[crfCategory].valueCodeableConcept from CRFCategoryVS (required)

* component[percentileRank].code = LifestyleMedicineTemporaryCS#percentile "Percentile"
* component[percentileRank].value[x] only Quantity
* component[percentileRank].valueQuantity.system = $UCUM
* component[percentileRank].valueQuantity.code = #%

* component[fitnessAge].code = LifestyleMedicineTemporaryCS#fitness-age "Fitness Age"
* component[fitnessAge].value[x] only Quantity
* component[fitnessAge].valueQuantity.system = $UCUM
* component[fitnessAge].valueQuantity.code = #a
* component[fitnessAge] ^short = "Biological age based on CRF"

* component[classificationStandard].code = LifestyleMedicineTemporaryCS#standard "Standard"
* component[classificationStandard].value[x] only CodeableConcept
* component[classificationStandard].valueCodeableConcept from CRFStandardVS (required)

// Estimation method
* component[methodType].code = LifestyleMedicineTemporaryCS#method "Method Type"
* component[methodType].value[x] only CodeableConcept
* component[methodType].valueCodeableConcept from VO2maxMethodVS (required)

* component[specificProtocol].code = LifestyleMedicineTemporaryCS#protocol "Protocol"
* component[specificProtocol].value[x] only CodeableConcept
* component[specificProtocol].valueCodeableConcept from VO2maxProtocolVS (required)

* component[validationStatus].code = LifestyleMedicineTemporaryCS#validation "Validation"
* component[validationStatus].value[x] only CodeableConcept
* component[validationStatus].valueCodeableConcept from ValidationStatusVS (required)

// Input parameters
* component[restingHRUsed].code = LifestyleMedicineTemporaryCS#rhr-used "RHR Used"
* component[restingHRUsed].value[x] only Quantity
* component[restingHRUsed].valueQuantity.system = $UCUM
* component[restingHRUsed].valueQuantity.code = #{beats}/min

* component[maxHRUsed].code = LifestyleMedicineTemporaryCS#hrmax-used "HRmax Used"
* component[maxHRUsed].value[x] only Quantity
* component[maxHRUsed].valueQuantity.system = $UCUM
* component[maxHRUsed].valueQuantity.code = #{beats}/min

* component[hrMaxDetermination].code = LifestyleMedicineTemporaryCS#hrmax-method "HRmax Method"
* component[hrMaxDetermination].value[x] only CodeableConcept
* component[hrMaxDetermination].valueCodeableConcept from HRmaxMethodVS (required)

// Trend analysis
* component[vo2maxTrend].code = LifestyleMedicineTemporaryCS#vo2max-trend "VO2max Trend"
* component[vo2maxTrend].value[x] only CodeableConcept
* component[vo2maxTrend].valueCodeableConcept from VO2maxTrendVS (required)

* component[changeFromBaseline].code = LifestyleMedicineTemporaryCS#vo2max-change "Change"
* component[changeFromBaseline].value[x] only Quantity
* component[changeFromBaseline].valueQuantity.system = $UCUM
* component[changeFromBaseline].valueQuantity.code = #mL/kg/min

* component[percentChange].code = LifestyleMedicineTemporaryCS#pct-change "Percent Change"
* component[percentChange].value[x] only Quantity
* component[percentChange].valueQuantity.system = $UCUM
* component[percentChange].valueQuantity.code = #%

* component[baselineValue].code = LifestyleMedicineTemporaryCS#vo2max-baseline "Baseline"
* component[baselineValue].value[x] only Quantity
* component[baselineValue].valueQuantity.system = $UCUM
* component[baselineValue].valueQuantity.code = #mL/kg/min

// Health implications
* component[cvRiskCategory].code = LifestyleMedicineTemporaryCS#cv-risk "CV Risk"
* component[cvRiskCategory].value[x] only CodeableConcept
* component[cvRiskCategory].valueCodeableConcept from CVRiskCategoryVS (required)

* component[metCapacity].code = LifestyleMedicineTemporaryCS#mets "METs"
* component[metCapacity].value[x] only Quantity
* component[metCapacity].valueQuantity.system = $UCUM
* component[metCapacity].valueQuantity.code = #MET

// Data source
* component[dataSource].code = LifestyleMedicineTemporaryCS#source "Data Source"
* component[dataSource].value[x] only CodeableConcept
* component[dataSource].valueCodeableConcept from WearableVendorVS (required)


// ============================================================================
// VALUE SETS
// ============================================================================

ValueSet: ReadinessCategoryVS
Id: readiness-category-vs
Title: "Readiness Category ValueSet"
Description: "Categories for interpreting recovery readiness scores from wearable devices"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/readiness-category-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: BaselineComparisonVS
Id: baseline-comparison-vs
Title: "Baseline Comparison ValueSet"
Description: "Methods for comparing current values to established baselines"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/baseline-comparison-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: TrendDirectionVS
Id: trend-direction-vs
Title: "Trend Direction ValueSet"
Description: "Directions of trends in health metrics over time"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/trend-direction-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: ActivityBalanceVS
Id: activity-balance-vs
Title: "Activity Balance ValueSet"
Description: "Categories for activity and recovery balance status"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/activity-balance-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: RecoveryDebtVS
Id: recovery-debt-vs
Title: "Recovery Debt ValueSet"
Description: "Levels of accumulated recovery debt from training or stress"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/recovery-debt-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: TrainingStatusVS
Id: training-status-vs
Title: "Training Status ValueSet"
Description: "Current training status categories based on fitness trends"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/training-status-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: RecommendedActivityVS
Id: recommended-activity-vs
Title: "Recommended Activity ValueSet"
Description: "Recommended activity types based on recovery status"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/recommended-activity-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: WearableVendorVS
Id: wearable-vendor-vs
Title: "Wearable Vendor ValueSet"
Description: "Supported wearable device vendors for data integration"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/wearable-vendor-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: VO2maxUnitVS
Id: vo2max-unit-vs
Title: "VO2max Unit ValueSet"
Description: "Units of measurement for VO2max values"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/vo2max-unit-vs"
* ^status = #active
* ^experimental = false
* include $UCUM#mL/kg/min "milliliters per kilogram per minute"
* include $UCUM#L/min "liters per minute"

ValueSet: CRFCategoryVS
Id: crf-category-vs
Title: "CRF Category ValueSet"
Description: "Cardiorespiratory fitness categories based on VO2max percentiles"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/crf-category-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: CRFStandardVS
Id: crf-standard-vs
Title: "CRF Standard ValueSet"
Description: "Reference standards for cardiorespiratory fitness classification"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/crf-standard-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: VO2maxMethodVS
Id: vo2max-method-vs
Title: "VO2max Method ValueSet"
Description: "Methods for estimating or measuring VO2max"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/vo2max-method-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: VO2maxProtocolVS
Id: vo2max-protocol-vs
Title: "VO2max Protocol ValueSet"
Description: "Exercise protocols used for VO2max testing"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/vo2max-protocol-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: ValidationStatusVS
Id: validation-status-vs
Title: "Validation Status ValueSet"
Description: "Validation status of health measurements"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/validation-status-vs"
* ^status = #active
* ^experimental = false
* include codes from system AppLogicCS

ValueSet: HRmaxMethodVS
Id: hrmax-method-vs
Title: "HRmax Method ValueSet"
Description: "Methods for determining maximum heart rate"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/hrmax-method-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: VO2maxTrendVS
Id: vo2max-trend-vs
Title: "VO2max Trend ValueSet"
Description: "Trends in VO2max values over time"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/vo2max-trend-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: CVRiskCategoryVS
Id: cv-risk-category-vs
Title: "CV Risk Category ValueSet"
Description: "Cardiovascular risk categories based on fitness assessment"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cv-risk-category-vs"
* ^status = #active
* ^experimental = false
* include codes from system AppLogicCS
