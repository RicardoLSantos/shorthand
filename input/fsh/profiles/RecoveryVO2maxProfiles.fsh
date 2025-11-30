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
* code = RecoveryMetricsCS#readiness "Recovery Readiness Assessment"
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
* component[readinessCategory].code = RecoveryMetricsCS#category "Readiness Category"
* component[readinessCategory].value[x] only CodeableConcept
* component[readinessCategory].valueCodeableConcept from ReadinessCategoryVS (required)

* component[comparedToBaseline].code = RecoveryMetricsCS#vs-baseline "Compared to Baseline"
* component[comparedToBaseline].value[x] only CodeableConcept
* component[comparedToBaseline].valueCodeableConcept from BaselineComparisonVS (required)

* component[trendDirection].code = RecoveryMetricsCS#trend "Trend Direction"
* component[trendDirection].value[x] only CodeableConcept
* component[trendDirection].valueCodeableConcept from TrendDirectionVS (required)

// Vendor-specific scores
* component[ouraReadiness].code = RecoveryMetricsCS#oura "Oura Readiness"
* component[ouraReadiness].value[x] only integer

* component[whoopRecovery].code = RecoveryMetricsCS#whoop "WHOOP Recovery"
* component[whoopRecovery].value[x] only Quantity
* component[whoopRecovery].valueQuantity.system = $UCUM
* component[whoopRecovery].valueQuantity.code = #%

* component[garminBodyBattery].code = RecoveryMetricsCS#garmin-bb "Garmin Body Battery"
* component[garminBodyBattery].value[x] only integer

* component[fitbitReadiness].code = RecoveryMetricsCS#fitbit "Fitbit Readiness"
* component[fitbitReadiness].value[x] only integer

// Contributing factors
* component[sleepContribution].code = RecoveryMetricsCS#sleep-contrib "Sleep Contribution"
* component[sleepContribution].value[x] only Quantity
* component[sleepContribution].valueQuantity.system = $UCUM
* component[sleepContribution].valueQuantity.code = #{score}

* component[hrvContribution].code = RecoveryMetricsCS#hrv-contrib "HRV Contribution"
* component[hrvContribution].value[x] only Quantity
* component[hrvContribution].valueQuantity.system = $UCUM
* component[hrvContribution].valueQuantity.code = #{score}

* component[restingHRContribution].code = RecoveryMetricsCS#rhr-contrib "Resting HR Contribution"
* component[restingHRContribution].value[x] only Quantity
* component[restingHRContribution].valueQuantity.system = $UCUM
* component[restingHRContribution].valueQuantity.code = #{score}

* component[activityBalance].code = RecoveryMetricsCS#activity-bal "Activity Balance"
* component[activityBalance].value[x] only CodeableConcept
* component[activityBalance].valueCodeableConcept from ActivityBalanceVS (required)

// Strain-recovery balance
* component[previousDayStrain].code = RecoveryMetricsCS#prev-strain "Previous Day Strain"
* component[previousDayStrain].value[x] only Quantity
* component[previousDayStrain].valueQuantity.system = $UCUM
* component[previousDayStrain].valueQuantity.code = #{score}
* component[previousDayStrain] ^short = "WHOOP scale 0-21"

* component[cumulativeStrain7d].code = RecoveryMetricsCS#strain-7d "Cumulative Strain 7d"
* component[cumulativeStrain7d].value[x] only Quantity
* component[cumulativeStrain7d].valueQuantity.system = $UCUM
* component[cumulativeStrain7d].valueQuantity.code = #{score}

* component[recoveryDebt].code = RecoveryMetricsCS#debt "Recovery Debt"
* component[recoveryDebt].value[x] only CodeableConcept
* component[recoveryDebt].valueCodeableConcept from RecoveryDebtVS (required)

// Training readiness
* component[trainingStatus].code = RecoveryMetricsCS#training-status "Training Status"
* component[trainingStatus].value[x] only CodeableConcept
* component[trainingStatus].valueCodeableConcept from TrainingStatusVS (required)

* component[recommendedActivity].code = RecoveryMetricsCS#rec-activity "Recommended Activity"
* component[recommendedActivity].value[x] only CodeableConcept
* component[recommendedActivity].valueCodeableConcept from RecommendedActivityVS (required)

* component[optimalStrainToday].code = RecoveryMetricsCS#optimal-strain "Optimal Strain"
* component[optimalStrainToday].value[x] only Quantity
* component[optimalStrainToday].valueQuantity.system = $UCUM
* component[optimalStrainToday].valueQuantity.code = #{score}

// Historical comparison
* component[avg7dayReadiness].code = RecoveryMetricsCS#avg-7d "7-Day Average"
* component[avg7dayReadiness].value[x] only Quantity
* component[avg7dayReadiness].valueQuantity.system = $UCUM
* component[avg7dayReadiness].valueQuantity.code = #{score}

* component[avg30dayReadiness].code = RecoveryMetricsCS#avg-30d "30-Day Average"
* component[avg30dayReadiness].value[x] only Quantity
* component[avg30dayReadiness].valueQuantity.system = $UCUM
* component[avg30dayReadiness].valueQuantity.code = #{score}

* component[personalBaseline].code = RecoveryMetricsCS#baseline "Personal Baseline"
* component[personalBaseline].value[x] only Quantity
* component[personalBaseline].valueQuantity.system = $UCUM
* component[personalBaseline].valueQuantity.code = #{score}

// Protocol
* component[primaryVendor].code = RecoveryMetricsCS#vendor "Primary Vendor"
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
* component[confidenceLower].code = VO2maxMetricsCS#ci-lower "CI Lower"
* component[confidenceLower].value[x] only Quantity
* component[confidenceLower].valueQuantity.system = $UCUM
* component[confidenceLower].valueQuantity.code = #mL/kg/min

* component[confidenceUpper].code = VO2maxMetricsCS#ci-upper "CI Upper"
* component[confidenceUpper].value[x] only Quantity
* component[confidenceUpper].valueQuantity.system = $UCUM
* component[confidenceUpper].valueQuantity.code = #mL/kg/min

* component[estimationAccuracy].code = VO2maxMetricsCS#accuracy "Accuracy"
* component[estimationAccuracy].value[x] only Quantity
* component[estimationAccuracy].valueQuantity.system = $UCUM
* component[estimationAccuracy].valueQuantity.code = #%

// Fitness classification
* component[crfCategory].code = VO2maxMetricsCS#crf "CRF Category"
* component[crfCategory].value[x] only CodeableConcept
* component[crfCategory].valueCodeableConcept from CRFCategoryVS (required)

* component[percentileRank].code = VO2maxMetricsCS#percentile "Percentile"
* component[percentileRank].value[x] only Quantity
* component[percentileRank].valueQuantity.system = $UCUM
* component[percentileRank].valueQuantity.code = #%

* component[fitnessAge].code = VO2maxMetricsCS#fitness-age "Fitness Age"
* component[fitnessAge].value[x] only Quantity
* component[fitnessAge].valueQuantity.system = $UCUM
* component[fitnessAge].valueQuantity.code = #a
* component[fitnessAge] ^short = "Biological age based on CRF"

* component[classificationStandard].code = VO2maxMetricsCS#standard "Standard"
* component[classificationStandard].value[x] only CodeableConcept
* component[classificationStandard].valueCodeableConcept from CRFStandardVS (required)

// Estimation method
* component[methodType].code = VO2maxMetricsCS#method "Method Type"
* component[methodType].value[x] only CodeableConcept
* component[methodType].valueCodeableConcept from VO2maxMethodVS (required)

* component[specificProtocol].code = VO2maxMetricsCS#protocol "Protocol"
* component[specificProtocol].value[x] only CodeableConcept
* component[specificProtocol].valueCodeableConcept from VO2maxProtocolVS (required)

* component[validationStatus].code = VO2maxMetricsCS#validation "Validation"
* component[validationStatus].value[x] only CodeableConcept
* component[validationStatus].valueCodeableConcept from ValidationStatusVS (required)

// Input parameters
* component[restingHRUsed].code = VO2maxMetricsCS#rhr-used "RHR Used"
* component[restingHRUsed].value[x] only Quantity
* component[restingHRUsed].valueQuantity.system = $UCUM
* component[restingHRUsed].valueQuantity.code = #{beats}/min

* component[maxHRUsed].code = VO2maxMetricsCS#hrmax-used "HRmax Used"
* component[maxHRUsed].value[x] only Quantity
* component[maxHRUsed].valueQuantity.system = $UCUM
* component[maxHRUsed].valueQuantity.code = #{beats}/min

* component[hrMaxDetermination].code = VO2maxMetricsCS#hrmax-method "HRmax Method"
* component[hrMaxDetermination].value[x] only CodeableConcept
* component[hrMaxDetermination].valueCodeableConcept from HRmaxMethodVS (required)

// Trend analysis
* component[vo2maxTrend].code = VO2maxMetricsCS#trend "VO2max Trend"
* component[vo2maxTrend].value[x] only CodeableConcept
* component[vo2maxTrend].valueCodeableConcept from VO2maxTrendVS (required)

* component[changeFromBaseline].code = VO2maxMetricsCS#change "Change"
* component[changeFromBaseline].value[x] only Quantity
* component[changeFromBaseline].valueQuantity.system = $UCUM
* component[changeFromBaseline].valueQuantity.code = #mL/kg/min

* component[percentChange].code = VO2maxMetricsCS#pct-change "Percent Change"
* component[percentChange].value[x] only Quantity
* component[percentChange].valueQuantity.system = $UCUM
* component[percentChange].valueQuantity.code = #%

* component[baselineValue].code = VO2maxMetricsCS#baseline "Baseline"
* component[baselineValue].value[x] only Quantity
* component[baselineValue].valueQuantity.system = $UCUM
* component[baselineValue].valueQuantity.code = #mL/kg/min

// Health implications
* component[cvRiskCategory].code = VO2maxMetricsCS#cv-risk "CV Risk"
* component[cvRiskCategory].value[x] only CodeableConcept
* component[cvRiskCategory].valueCodeableConcept from CVRiskCategoryVS (required)

* component[metCapacity].code = VO2maxMetricsCS#mets "METs"
* component[metCapacity].value[x] only Quantity
* component[metCapacity].valueQuantity.system = $UCUM
* component[metCapacity].valueQuantity.code = #MET

// Data source
* component[dataSource].code = VO2maxMetricsCS#source "Data Source"
* component[dataSource].value[x] only CodeableConcept
* component[dataSource].valueCodeableConcept from WearableVendorVS (required)


// ============================================================================
// RECOVERY METRICS CODE SYSTEM
// ============================================================================

CodeSystem: RecoveryMetricsCS
Id: recovery-metrics-cs
Title: "Recovery Metrics CodeSystem"
Description: "CodeSystem for recovery readiness and training load metrics"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/recovery-metrics-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

* #readiness "Recovery Readiness Assessment" "Composite recovery and readiness score"
* #category "Readiness Category" "Categorical interpretation of readiness"
* #vs-baseline "Compared to Baseline" "How current readiness compares to personal baseline"
* #trend "Trend Direction" "Direction of readiness trend"

// Vendor scores
* #oura "Oura Readiness" "Oura Ring readiness score (0-100)"
* #whoop "WHOOP Recovery" "WHOOP recovery percentage (0-100%)"
* #garmin-bb "Garmin Body Battery" "Garmin Body Battery (0-100)"
* #fitbit "Fitbit Readiness" "Fitbit Daily Readiness Score"

// Contributing factors
* #sleep-contrib "Sleep Contribution" "Sleep quality contribution to readiness"
* #hrv-contrib "HRV Contribution" "HRV contribution to readiness"
* #rhr-contrib "Resting HR Contribution" "Resting heart rate contribution"
* #activity-bal "Activity Balance" "Activity balance status"

// Strain
* #prev-strain "Previous Day Strain" "Strain from previous day"
* #strain-7d "Cumulative Strain 7d" "7-day cumulative strain"
* #debt "Recovery Debt" "Accumulated recovery debt"

// Training
* #training-status "Training Status" "Current training status"
* #rec-activity "Recommended Activity" "Recommended activity type"
* #optimal-strain "Optimal Strain" "Optimal strain for today"

// Historical
* #avg-7d "7-Day Average" "7-day average readiness"
* #avg-30d "30-Day Average" "30-day average readiness"
* #baseline "Personal Baseline" "Personal baseline readiness"

// Protocol
* #vendor "Primary Vendor" "Primary wearable vendor"


// ============================================================================
// VO2MAX METRICS CODE SYSTEM
// ============================================================================

CodeSystem: VO2maxMetricsCS
Id: vo2max-metrics-cs
Title: "VO2max Metrics CodeSystem"
Description: "CodeSystem for VO2max estimation metrics"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/vo2max-metrics-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete

// Value and confidence
* #ci-lower "CI Lower" "Confidence interval lower bound"
* #ci-upper "CI Upper" "Confidence interval upper bound"
* #accuracy "Accuracy" "Estimation accuracy percentage"

// Classification
* #crf "CRF Category" "Cardiorespiratory fitness category"
* #percentile "Percentile" "Percentile rank"
* #fitness-age "Fitness Age" "Estimated biological age based on CRF"
* #standard "Standard" "Classification standard used"

// Method
* #method "Method Type" "Type of estimation method"
* #protocol "Protocol" "Specific test protocol"
* #validation "Validation" "Validation status"

// Input parameters
* #rhr-used "RHR Used" "Resting heart rate used"
* #hrmax-used "HRmax Used" "Maximum heart rate used"
* #hrmax-method "HRmax Method" "How HRmax was determined"

// Trend
* #trend "VO2max Trend" "Trend direction over time"
* #change "Change" "Change from baseline"
* #pct-change "Percent Change" "Percentage change"
* #baseline "Baseline" "Baseline value"

// Health
* #cv-risk "CV Risk" "Cardiovascular risk category"
* #mets "METs" "Functional capacity in METs"
* #source "Data Source" "Source of estimation data"


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
* include codes from system ReadinessCategoryCS

ValueSet: BaselineComparisonVS
Id: baseline-comparison-vs
Title: "Baseline Comparison ValueSet"
Description: "Methods for comparing current values to established baselines"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/baseline-comparison-vs"
* ^status = #active
* ^experimental = false
* include codes from system BaselineComparisonCS

ValueSet: TrendDirectionVS
Id: trend-direction-vs
Title: "Trend Direction ValueSet"
Description: "Directions of trends in health metrics over time"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/trend-direction-vs"
* ^status = #active
* ^experimental = false
* include codes from system TrendDirectionCS

ValueSet: ActivityBalanceVS
Id: activity-balance-vs
Title: "Activity Balance ValueSet"
Description: "Categories for activity and recovery balance status"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/activity-balance-vs"
* ^status = #active
* ^experimental = false
* include codes from system ActivityBalanceCS

ValueSet: RecoveryDebtVS
Id: recovery-debt-vs
Title: "Recovery Debt ValueSet"
Description: "Levels of accumulated recovery debt from training or stress"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/recovery-debt-vs"
* ^status = #active
* ^experimental = false
* include codes from system RecoveryDebtCS

ValueSet: TrainingStatusVS
Id: training-status-vs
Title: "Training Status ValueSet"
Description: "Current training status categories based on fitness trends"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/training-status-vs"
* ^status = #active
* ^experimental = false
* include codes from system TrainingStatusCS

ValueSet: RecommendedActivityVS
Id: recommended-activity-vs
Title: "Recommended Activity ValueSet"
Description: "Recommended activity types based on recovery status"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/recommended-activity-vs"
* ^status = #active
* ^experimental = false
* include codes from system RecommendedActivityCS

ValueSet: WearableVendorVS
Id: wearable-vendor-vs
Title: "Wearable Vendor ValueSet"
Description: "Supported wearable device vendors for data integration"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/wearable-vendor-vs"
* ^status = #active
* ^experimental = false
* include codes from system WearableVendorCS

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
* include codes from system CRFCategoryCS

ValueSet: CRFStandardVS
Id: crf-standard-vs
Title: "CRF Standard ValueSet"
Description: "Reference standards for cardiorespiratory fitness classification"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/crf-standard-vs"
* ^status = #active
* ^experimental = false
* include codes from system CRFStandardCS

ValueSet: VO2maxMethodVS
Id: vo2max-method-vs
Title: "VO2max Method ValueSet"
Description: "Methods for estimating or measuring VO2max"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/vo2max-method-vs"
* ^status = #active
* ^experimental = false
* include codes from system VO2maxMethodCS

ValueSet: VO2maxProtocolVS
Id: vo2max-protocol-vs
Title: "VO2max Protocol ValueSet"
Description: "Exercise protocols used for VO2max testing"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/vo2max-protocol-vs"
* ^status = #active
* ^experimental = false
* include codes from system VO2maxProtocolCS

ValueSet: ValidationStatusVS
Id: validation-status-vs
Title: "Validation Status ValueSet"
Description: "Validation status of health measurements"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/validation-status-vs"
* ^status = #active
* ^experimental = false
* include codes from system ValidationStatusCS

ValueSet: HRmaxMethodVS
Id: hrmax-method-vs
Title: "HRmax Method ValueSet"
Description: "Methods for determining maximum heart rate"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/hrmax-method-vs"
* ^status = #active
* ^experimental = false
* include codes from system HRmaxMethodCS

ValueSet: VO2maxTrendVS
Id: vo2max-trend-vs
Title: "VO2max Trend ValueSet"
Description: "Trends in VO2max values over time"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/vo2max-trend-vs"
* ^status = #active
* ^experimental = false
* include codes from system VO2maxTrendCS

ValueSet: CVRiskCategoryVS
Id: cv-risk-category-vs
Title: "CV Risk Category ValueSet"
Description: "Cardiovascular risk categories based on fitness assessment"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cv-risk-category-vs"
* ^status = #active
* ^experimental = false
* include codes from system CVRiskCategoryCS


// ============================================================================
// SUPPORTING CODE SYSTEMS
// ============================================================================

CodeSystem: ReadinessCategoryCS
Id: readiness-category-cs
Title: "Readiness Category CodeSystem"
Description: "Categories for interpreting recovery readiness scores from wearable devices"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/readiness-category-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #optimal "Optimal (85-100)" "Excellent recovery, ready for peak performance"
* #good "Good (70-84)" "Good recovery, ready for training"
* #fair "Fair (50-69)" "Moderate recovery, light activity recommended"
* #low "Low (30-49)" "Low recovery, rest or active recovery"
* #pay-attention "Pay Attention (<30)" "Very low recovery, focus on rest"

CodeSystem: BaselineComparisonCS
Id: baseline-comparison-cs
Title: "Baseline Comparison CodeSystem"
Description: "Codes for comparing current values to personal baseline"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/baseline-comparison-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #above "Above Baseline" "Currently above personal baseline"
* #at "At Baseline" "Currently at personal baseline"
* #below "Below Baseline" "Currently below personal baseline"

CodeSystem: TrendDirectionCS
Id: trend-direction-cs
Title: "Trend Direction CodeSystem"
Description: "Codes for trend direction indicators"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/trend-direction-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #improving "Improving" "Readiness is improving"
* #stable "Stable" "Readiness is stable"
* #declining "Declining" "Readiness is declining"

CodeSystem: ActivityBalanceCS
Id: activity-balance-cs
Title: "Activity Balance CodeSystem"
Description: "Codes for activity and recovery balance status"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/activity-balance-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #balanced "Well Balanced" "Activity and recovery well balanced"
* #slight-over "Slightly Overtrained" "Slightly more activity than recovery"
* #undertrained "Undertrained" "Less activity than optimal"
* #overtrained "Significantly Overtrained" "Significantly more activity than recovery"

CodeSystem: RecoveryDebtCS
Id: recovery-debt-cs
Title: "Recovery Debt CodeSystem"
Description: "Codes for accumulated recovery debt levels"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/recovery-debt-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #none "No Debt" "No accumulated recovery debt"
* #mild "Mild Debt" "Mild accumulated recovery debt"
* #moderate "Moderate Debt" "Moderate accumulated recovery debt"
* #significant "Significant Debt" "Significant accumulated recovery debt"

CodeSystem: TrainingStatusCS
Id: training-status-cs
Title: "Training Status CodeSystem"
Description: "Codes for training status and fitness progression"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/training-status-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #peaking "Peaking" "In peak form, ideal for competition"
* #productive "Productive" "Training is producing improvements"
* #maintaining "Maintaining" "Maintaining current fitness level"
* #recovery "Recovery" "In recovery phase"
* #unproductive "Unproductive" "Training not producing improvements"
* #detraining "Detraining" "Fitness declining due to inactivity"
* #overreaching "Overreaching" "Training load exceeds recovery capacity"

CodeSystem: RecommendedActivityCS
Id: recommended-activity-cs
Title: "Recommended Activity CodeSystem"
Description: "Codes for recommended activity intensity based on recovery status"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/recommended-activity-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #high-intensity "High Intensity" "Ready for high intensity training"
* #moderate "Moderate Training" "Ready for moderate intensity"
* #light "Light Activity" "Light activity recommended"
* #active-recovery "Active Recovery" "Active recovery activities"
* #rest "Rest Day" "Complete rest recommended"
* #recovery-focus "Recovery Focus" "Focus on recovery activities"

CodeSystem: WearableVendorCS
Id: wearable-vendor-cs
Title: "Wearable Vendor CodeSystem"
Description: "Codes for wearable device manufacturers and vendors"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/wearable-vendor-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #oura "Oura" "Oura Ring"
* #whoop "WHOOP" "WHOOP band"
* #garmin "Garmin" "Garmin device"
* #polar "Polar" "Polar device"
* #fitbit "Fitbit" "Fitbit device"
* #apple "Apple" "Apple Watch"
* #samsung "Samsung" "Samsung Galaxy Watch"
* #withings "Withings" "Withings device"
* #coros "COROS" "COROS watch"
* #suunto "Suunto" "Suunto watch"
* #other "Other" "Other vendor"

CodeSystem: CRFCategoryCS
Id: crf-category-cs
Title: "CRF Category CodeSystem"
Description: "Cardiorespiratory fitness classification categories"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/crf-category-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #very-poor "Very Poor" "Very poor CRF for age/sex"
* #poor "Poor" "Poor CRF for age/sex"
* #below-average "Below Average" "Below average CRF"
* #average "Average" "Average CRF"
* #above-average "Above Average" "Above average CRF"
* #good "Good" "Good CRF"
* #excellent "Excellent" "Excellent CRF"
* #superior "Superior" "Superior CRF"

CodeSystem: CRFStandardCS
Id: crf-standard-cs
Title: "CRF Standard CodeSystem"
Description: "Standards and norms used for CRF classification"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/crf-standard-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #acsm "ACSM" "American College of Sports Medicine"
* #cooper "Cooper Institute" "Cooper Institute norms"
* #hunt "HUNT Fitness Study" "Norwegian HUNT study norms"
* #garmin "Garmin Proprietary" "Garmin proprietary system"
* #apple "Apple Proprietary" "Apple proprietary system"
* #polar "Polar Proprietary" "Polar proprietary system"
* #other "Other" "Other standard"

CodeSystem: VO2maxMethodCS
Id: vo2max-method-cs
Title: "VO2max Method CodeSystem"
Description: "Methods for VO2max estimation and measurement"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/vo2max-method-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #wearable "Wearable Algorithm" "Algorithm-based from wearable data"
* #submaximal "Submaximal Test" "Submaximal exercise test"
* #non-exercise "Non-Exercise Prediction" "Non-exercise prediction equation"
* #maximal "Maximal Test" "Maximal exercise test"
* #field "Field Test" "Field-based fitness test"
* #combined "Combined Method" "Multiple combined methods"

CodeSystem: VO2maxProtocolCS
Id: vo2max-protocol-cs
Title: "VO2max Protocol CodeSystem"
Description: "Specific protocols and tests for VO2max estimation"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/vo2max-protocol-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #garmin-firstbeat "Garmin FirstBeat" "Garmin FirstBeat analytics"
* #apple-cardio "Apple Cardio Fitness" "Apple Watch algorithm"
* #polar-fitness "Polar Fitness Test" "Polar OwnIndex test"
* #fitbit-cardio "Fitbit Cardio Score" "Fitbit algorithm"
* #coros "COROS" "COROS proprietary"
* #suunto "Suunto" "Suunto proprietary"
* #astrand "Astrand-Rhyming" "Astrand-Rhyming cycle test"
* #ymca "YMCA Cycle Test" "YMCA submaximal cycle"
* #rockport "Rockport Walk" "Rockport 1-mile walk test"
* #cooper "Cooper 12-min" "Cooper 12-minute run"
* #6mwt "6-Minute Walk" "Six-minute walk test"
* #uth "Uth Formula" "HRmax/HRrest ratio"
* #bruce "Bruce Treadmill" "Bruce protocol"
* #other "Other" "Other protocol"

CodeSystem: ValidationStatusCS
Id: validation-status-cs
Title: "Validation Status CodeSystem"
Description: "Codes for scientific validation status of metrics"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/validation-status-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #clinical "Clinically Validated" "Validated in clinical studies"
* #research "Research Validated" "Validated in research"
* #manufacturer "Manufacturer Validated" "Validated by manufacturer"
* #not-validated "Not Validated" "Not independently validated"
* #unknown "Unknown" "Validation status unknown"

CodeSystem: HRmaxMethodCS
Id: hrmax-method-cs
Title: "HRmax Method CodeSystem"
Description: "Methods for determining maximum heart rate"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/hrmax-method-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #measured "Measured" "Directly measured in maximal test"
* #age-220 "220-Age Formula" "Predicted using 220-age"
* #tanaka "Tanaka Formula" "Predicted using 208-0.7*age"
* #field "Field Observed" "Observed during field activities"
* #device "Device Learned" "Learned by wearable over time"
* #unknown "Unknown" "Method unknown"

CodeSystem: VO2maxTrendCS
Id: vo2max-trend-cs
Title: "VO2max Trend CodeSystem"
Description: "Codes for VO2max trend direction over time"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/vo2max-trend-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #sig-improving "Significantly Improving" "Significantly improving"
* #improving "Improving" "Improving over time"
* #stable "Stable" "Stable over time"
* #declining "Declining" "Declining over time"
* #sig-declining "Significantly Declining" "Significantly declining"
* #insufficient "Insufficient Data" "Insufficient data for trend"

CodeSystem: CVRiskCategoryCS
Id: cv-risk-category-cs
Title: "CV Risk Category CodeSystem"
Description: "Cardiovascular risk categories based on CRF levels"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cv-risk-category-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #low "Low Risk" "Low cardiovascular risk based on CRF"
* #moderate "Moderate Risk" "Moderate cardiovascular risk"
* #high "High Risk" "High cardiovascular risk"
* #very-high "Very High Risk" "Very high cardiovascular risk"
