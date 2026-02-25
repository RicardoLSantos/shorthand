// Mobility Profiles for iOS Lifestyle Medicine FHIR IG
// Updated: 2026-01-20 - Added iOS 14+ gait metrics
// Reference: Apple HealthKit HKQuantityTypeIdentifier mobility metrics

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $LIFESTYLEOBS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs

Profile: MobilityProfile
Parent: Observation
Id: mobility-profile
Title: "Mobility Profile"
Description: "Profile for mobility data from iOS Health App including iOS 14+ gait metrics (walking speed, step length, asymmetry, double support, stair speeds, 6MWT, and walking steadiness)"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1 MS
* code = $LIFESTYLEOBS#gait-assessment "Gait assessment"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* device 0..1 MS

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "Mobility measurement components"
* component ^definition = "Individual mobility metrics from iOS 14+ HealthKit"

* component contains
    walkingSpeed 0..1 MS and
    walkingStepLength 0..1 MS and
    walkingAsymmetry 0..1 MS and
    walkingDoubleSupport 0..1 MS and
    stairAscentSpeed 0..1 MS and
    stairDescentSpeed 0..1 MS and
    sixMinuteWalkDistance 0..1 MS and
    walkingSteadiness 0..1 MS

// Walking Speed (iOS 14+)
* component[walkingSpeed].code = $LIFESTYLEOBS#walking-speed "Walking speed measurement"
* component[walkingSpeed].valueQuantity 1..1
* component[walkingSpeed].valueQuantity.system = $UCUM
* component[walkingSpeed].valueQuantity.code = #m/s
* component[walkingSpeed].valueQuantity ^short = "Walking speed in meters per second"
* component[walkingSpeed] ^short = "Walking speed"
* component[walkingSpeed] ^definition = "Average walking speed. HKQuantityTypeIdentifier.walkingSpeed (iOS 14+). Normal adult: 1.2-1.4 m/s"

// Walking Step Length (iOS 14+)
* component[walkingStepLength].code = $LIFESTYLEOBS#walking-step-length "Walking step length"
* component[walkingStepLength].valueQuantity 1..1
* component[walkingStepLength].valueQuantity.system = $UCUM
* component[walkingStepLength].valueQuantity.code = #m
* component[walkingStepLength].valueQuantity ^short = "Step length in meters"
* component[walkingStepLength] ^short = "Walking step length"
* component[walkingStepLength] ^definition = "Average step length during walking. HKQuantityTypeIdentifier.walkingStepLength (iOS 14+)"

// Walking Asymmetry Percentage (iOS 14+)
* component[walkingAsymmetry].code = $LIFESTYLEOBS#walking-asymmetry "Walking asymmetry percentage"
* component[walkingAsymmetry].valueQuantity 1..1
* component[walkingAsymmetry].valueQuantity.system = $UCUM
* component[walkingAsymmetry].valueQuantity.code = #%
* component[walkingAsymmetry].valueQuantity ^short = "Asymmetry percentage"
* component[walkingAsymmetry] ^short = "Walking asymmetry"
* component[walkingAsymmetry] ^definition = "Percentage difference in step time between left and right legs. HKQuantityTypeIdentifier.walkingAsymmetryPercentage (iOS 14+). Normal: <10%"

// Walking Double Support Percentage (iOS 14+)
* component[walkingDoubleSupport].code = $LIFESTYLEOBS#walking-double-support "Walking double support percentage"
* component[walkingDoubleSupport].valueQuantity 1..1
* component[walkingDoubleSupport].valueQuantity.system = $UCUM
* component[walkingDoubleSupport].valueQuantity.code = #%
* component[walkingDoubleSupport].valueQuantity ^short = "Double support time percentage"
* component[walkingDoubleSupport] ^short = "Double support time"
* component[walkingDoubleSupport] ^definition = "Percentage of gait cycle with both feet on ground. HKQuantityTypeIdentifier.walkingDoubleSupportPercentage (iOS 14+). Increases with age and fall risk"

// Stair Ascent Speed (iOS 14+)
* component[stairAscentSpeed].code = $LIFESTYLEOBS#stair-ascent-speed "Stair ascent speed"
* component[stairAscentSpeed].valueQuantity 1..1
* component[stairAscentSpeed].valueQuantity.system = $UCUM
* component[stairAscentSpeed].valueQuantity.code = #m/s
* component[stairAscentSpeed].valueQuantity ^short = "Stair climbing speed in m/s"
* component[stairAscentSpeed] ^short = "Stair ascent speed"
* component[stairAscentSpeed] ^definition = "Speed of ascending stairs. HKQuantityTypeIdentifier.stairAscentSpeed (iOS 14+). Indicator of lower limb strength"

// Stair Descent Speed (iOS 14+)
* component[stairDescentSpeed].code = $LIFESTYLEOBS#stair-descent-speed "Stair descent speed"
* component[stairDescentSpeed].valueQuantity 1..1
* component[stairDescentSpeed].valueQuantity.system = $UCUM
* component[stairDescentSpeed].valueQuantity.code = #m/s
* component[stairDescentSpeed].valueQuantity ^short = "Stair descending speed in m/s"
* component[stairDescentSpeed] ^short = "Stair descent speed"
* component[stairDescentSpeed] ^definition = "Speed of descending stairs. HKQuantityTypeIdentifier.stairDescentSpeed (iOS 14+). Relevant for fall risk assessment"

// Six-Minute Walk Test Distance (iOS 14+) - LOINC 64098-7 available!
* component[sixMinuteWalkDistance].code = $LOINC#64098-7 "Six minute walk test"
* component[sixMinuteWalkDistance].valueQuantity 1..1
* component[sixMinuteWalkDistance].valueQuantity.system = $UCUM
* component[sixMinuteWalkDistance].valueQuantity.code = #m
* component[sixMinuteWalkDistance].valueQuantity ^short = "6MWT distance in meters"
* component[sixMinuteWalkDistance] ^short = "Six-minute walk distance"
* component[sixMinuteWalkDistance] ^definition = "Distance walked in six minutes. HKQuantityTypeIdentifier.sixMinuteWalkTestDistance (iOS 14+). Clinical measure of functional exercise capacity. Normal adult: 400-700m"

// Walking Steadiness (iOS 15+)
* component[walkingSteadiness].code = $LIFESTYLEOBS#walking-steadiness "Walking steadiness measurement"
* component[walkingSteadiness].valueQuantity 1..1
* component[walkingSteadiness].valueQuantity.system = $UCUM
* component[walkingSteadiness].valueQuantity.code = #%
* component[walkingSteadiness].valueQuantity ^short = "Walking steadiness percentage"
* component[walkingSteadiness] ^short = "Walking steadiness"
* component[walkingSteadiness] ^definition = "Walking steadiness score. HKQuantityTypeIdentifier.appleWalkingSteadiness (iOS 15+). FDA-cleared for fall risk prediction. Categories: OK (>60%), Low (40-60%), Very Low (<40%)"


// Simplified profile for individual mobility measurements
Profile: MobilityMeasurement
Parent: Observation
Id: mobility-measurement
Title: "Mobility Measurement"
Description: "Profile for individual mobility metric observations from iOS Health App"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1 MS
* code from MobilityMetricsVS (required)
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* valueQuantity 1..1 MS
* device 0..1 MS
* note 0..* MS


// ValueSet for mobility metrics
ValueSet: MobilityMetricsVS
Id: mobility-metrics-vs
Title: "Mobility Metrics Value Set"
Description: "Value set for iOS 14+ mobility metrics from Apple HealthKit"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mobility-metrics-vs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false

* $LIFESTYLEOBS#walking-speed "Walking speed measurement"
* $LIFESTYLEOBS#walking-step-length "Walking step length"
* $LIFESTYLEOBS#walking-asymmetry "Walking asymmetry percentage"
* $LIFESTYLEOBS#walking-double-support "Walking double support percentage"
* $LIFESTYLEOBS#stair-ascent-speed "Stair ascent speed"
* $LIFESTYLEOBS#stair-descent-speed "Stair descent speed"
* $LOINC#64098-7 "Six minute walk test"
* $LIFESTYLEOBS#walking-steadiness "Walking steadiness measurement"
* $LIFESTYLEOBS#gait-assessment "Gait assessment"
* $LIFESTYLEOBS#balance-assessment "Balance assessment"
* $LIFESTYLEOBS#movement-assessment "Movement assessment"
