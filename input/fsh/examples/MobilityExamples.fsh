// Mobility Examples for iOS Lifestyle Medicine FHIR IG
// Updated: 2026-01-20 - Aligned with iOS 14+ gait metrics
// Reference: Apple HealthKit HKQuantityTypeIdentifier mobility metrics

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $LIFESTYLEOBS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs

// Example 1: Comprehensive Mobility Profile with iOS 14+ metrics
Instance: MobilityProfileExample
InstanceOf: MobilityProfile
Usage: #example
Description: "Comprehensive iOS 14+ mobility assessment example with all gait metrics"
Title: "Mobility Profile Assessment Example"

* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T09:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/iphone-example)
* code = $LIFESTYLEOBS#gait-assessment "Gait assessment"
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity

// iOS 14+ Gait Metrics
* component[walkingSpeed].code = $LIFESTYLEOBS#walking-speed "Walking speed measurement"
* component[walkingSpeed].valueQuantity = 1.25 'm/s' "meters per second"

* component[walkingStepLength].code = $LIFESTYLEOBS#walking-step-length "Walking step length"
* component[walkingStepLength].valueQuantity = 0.72 'm' "meters"

* component[walkingAsymmetry].code = $LIFESTYLEOBS#walking-asymmetry "Walking asymmetry percentage"
* component[walkingAsymmetry].valueQuantity = 7.5 '%' "percent"

* component[walkingDoubleSupport].code = $LIFESTYLEOBS#walking-double-support "Walking double support percentage"
* component[walkingDoubleSupport].valueQuantity = 28.3 '%' "percent"

* component[stairAscentSpeed].code = $LIFESTYLEOBS#stair-ascent-speed "Stair ascent speed"
* component[stairAscentSpeed].valueQuantity = 0.65 'm/s' "meters per second"

* component[stairDescentSpeed].code = $LIFESTYLEOBS#stair-descent-speed "Stair descent speed"
* component[stairDescentSpeed].valueQuantity = 0.58 'm/s' "meters per second"

// iOS 15+ Walking Steadiness
* component[walkingSteadiness].code = $LIFESTYLEOBS#walking-steadiness "Walking steadiness measurement"
* component[walkingSteadiness].valueQuantity = 72 '%' "percent"


// Example 2: Six-Minute Walk Test
Instance: SixMinuteWalkTestExample
InstanceOf: MobilityMeasurement
Usage: #example
Description: "Six-minute walk test distance measurement from Apple Health"
Title: "Six-Minute Walk Test Example"

* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T10:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LOINC#64098-7 "Six minute walk test"
* valueQuantity = 485 'm' "meters"
* note.text = "Patient completed 6MWT with normal functional capacity (400-700m reference range)"


// Example 3: Walking Steadiness Alert (Low)
Instance: WalkingSteadinessAlertExample
InstanceOf: MobilityMeasurement
Usage: #example
Description: "Walking steadiness measurement indicating low stability (fall risk)"
Title: "Walking Steadiness Alert Example"

* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T08:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/iphone-example)
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LIFESTYLEOBS#walking-steadiness "Walking steadiness measurement"
* valueQuantity = 45 '%' "percent"
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#L "Low"
* note.text = "Walking steadiness in Low range (40-60%). Consider fall risk assessment. Categories: OK (>60%), Low (40-60%), Very Low (<40%)"


// Example 4: Walking Asymmetry (Elevated)
Instance: WalkingAsymmetryExample
InstanceOf: MobilityMeasurement
Usage: #example
Description: "Walking asymmetry measurement showing elevated asymmetry"
Title: "Walking Asymmetry Elevated Example"

* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T14:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/iphone-example)
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LIFESTYLEOBS#walking-asymmetry "Walking asymmetry percentage"
* valueQuantity = 18.5 '%' "percent"
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"
* note.text = "Walking asymmetry >15% may indicate gait pathology. Normal range: <10%. Recommend clinical gait assessment."


// Example 5: Stair Speed Assessment
Instance: StairSpeedExample
InstanceOf: MobilityProfile
Usage: #example
Description: "Stair ascent and descent speed assessment"
Title: "Stair Speed Assessment Example"

* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T11:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/iphone-example)
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LIFESTYLEOBS#gait-assessment "Gait assessment"

* component[stairAscentSpeed].code = $LIFESTYLEOBS#stair-ascent-speed "Stair ascent speed"
* component[stairAscentSpeed].valueQuantity = 0.52 'm/s' "meters per second"

* component[stairDescentSpeed].code = $LIFESTYLEOBS#stair-descent-speed "Stair descent speed"
* component[stairDescentSpeed].valueQuantity = 0.48 'm/s' "meters per second"

* note.text = "Stair speeds within normal range. Indicates adequate lower limb strength and balance."


// Mobility Risk Assessment (unchanged from original)
Instance: MobilityRiskAssessmentExample
InstanceOf: MobilityRiskAssessment
Usage: #example
Description: "Mobility risk assessment based on iOS 14+ gait metrics"
Title: "Mobility Risk Assessment Example"

* status = #final
* subject = Reference(Patient/PatientExample)
* occurrenceDateTime = "2026-01-20T09:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* basis = Reference(MobilityProfileExample)
* prediction[fallRisk].outcome = $SCT#217082002 "Accidental fall"
* prediction[fallRisk].probabilityDecimal = 0.12
* prediction[fallRisk].qualitativeRisk = http://terminology.hl7.org/CodeSystem/risk-probability#low "Low likelihood"
* note.text = "Low fall risk based on iOS 14+ gait metrics: Walking steadiness OK (72%), asymmetry normal (7.5%), adequate stair speeds"


// Example 6: Observation with Mobility Alert Level Extension
Instance: MobilityAlertLevelExample
InstanceOf: MobilityMeasurement
Usage: #example
Description: "Walking steadiness observation with mobility-alert-level extension showing significant decline"
Title: "Mobility Alert Level Extension Example"

* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-27T07:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/iphone-example)
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LIFESTYLEOBS#walking-steadiness "Walking steadiness measurement"
* valueQuantity = 35 '%' "percent"
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#L "Low"

// Mobility Alert Level extension - Red alert for significant change
* extension[0].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mobility-alert-level"
* extension[0].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#red "Alert - Significant change"

* note.text = "Walking steadiness in Very Low range (<40%). RED alert triggered. Immediate fall risk assessment recommended. Previous reading was 52% (2 weeks ago)."
