Profile: ReproductiveObservation
Parent: Observation
Id: reproductive-observation
Title: "Reproductive Health Base Profile"
Description: "Base profile for reproductive health observations"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] MS

Profile: FertilityObservation
Parent: ReproductiveObservation
Id: fertility-observation
Title: "Fertility Observation Profile"
Description: "Profile for fertility signs and symptoms"

* code = $LOINC#8669-4 "Ovulation status"
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    cervicalMucus 0..1 MS and
    ovulationTest 0..1 MS and
    fertilityStatus 0..1 MS

* component[cervicalMucus].code = $LOINC#8669-4 "Cervical mucus observation"
* component[cervicalMucus].valueCodeableConcept from CervicalMucusVS (required)

* component[ovulationTest].code = $LOINC#8670-2 "Ovulation test"
* component[ovulationTest].valueCodeableConcept from OvulationTestVS (required)

* component[fertilityStatus].code = $LOINC#8671-0 "Fertility status"
* component[fertilityStatus].valueCodeableConcept from FertilityStatusVS (required)

Profile: ReproductiveSymptomObservation
Parent: ReproductiveObservation
Id: reproductive-symptom-observation
Title: "Reproductive Symptom Observation Profile"
Description: "Profile for reproductive health symptoms"

* code from ReproductiveSymptomVS (required)
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    severity 0..1 MS and
    duration 0..1 MS and
    impact 0..1 MS

* component[severity].code = $LOINC#72514-3 "Pain severity score"
* component[severity].valueInteger only integer
* component[severity].valueInteger ^minValue = 0
* component[severity].valueInteger ^maxValue = 10

* component[duration].code = $LOINC#103332-8 "Duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #h

Profile: MenstrualCycleObservation
Parent: ReproductiveObservation
Id: menstrual-cycle-observation
Title: "Menstrual Cycle Observation Profile"
Description: "Profile for menstrual cycle tracking"

* code = $LOINC#49033-4 "Menstrual cycle finding"
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    cycleLength 0..1 MS and
    flowDuration 0..1 MS and
    flowIntensity 0..1 MS

* component[cycleLength].code = $LOINC#8708-0 "Menstrual cycle length"
* component[cycleLength].valueQuantity.system = $UCUM
* component[cycleLength].valueQuantity.code = #d

* component[flowDuration].code = $LOINC#49030-0 "Menstruation duration"
* component[flowDuration].valueQuantity.system = $UCUM
* component[flowDuration].valueQuantity.code = #d

* component[flowIntensity].code = FlowIntensityCS#moderate "Flow intensity"
* component[flowIntensity].valueCodeableConcept from FlowIntensityVS (required)

Profile: ReproductiveGoal
Parent: Goal
Id: reproductive-goal
Title: "Reproductive Health Goal Profile"
Description: "Profile for reproductive health goals and planning"

* lifecycleStatus MS
* category = http://terminology.hl7.org/CodeSystem/goal-category#reproductive
* description MS
* subject 1..1 MS
* target MS

* target.measure from http://example.org/fhir/ValueSet/reproductive-goal-measures (required)
* target.detail[x] only Quantity or CodeableConcept
* target.due[x] only date or Duration

Profile: ReproductiveCyclePlan
Parent: CarePlan
Id: reproductive-cycle-plan
Title: "Reproductive Cycle Plan Profile"
Description: "Profile for reproductive cycle planning and tracking"

* status MS
* intent MS
* subject 1..1 MS
* period MS
* activity MS

* activity.detail.kind = #observation
* activity.detail.code from http://example.org/fhir/ValueSet/reproductive-activity (required)
* activity.detail.status MS
* activity.detail.scheduledTiming MS
