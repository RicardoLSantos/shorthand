
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

* target.measure from ReproductiveGoalVS (required)
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
* activity.detail.code from ReproductiveActivityVS (required)
* activity.detail.status MS
* activity.detail.scheduledTiming MS

Invariant: temp-range
Description: "Basal temperature must be between 35.0 and 38.0 Celsius"
Severity: #error
Expression: "valueQuantity.value >= 35.0 and valueQuantity.value <= 38.0"

Invariant: cycle-length-range
Description: "Cycle length must be between 20 and 45 days"
Severity: #error
Expression: "component.where(code = %cycleLength).valueQuantity.value >= 20 and component.where(code = %cycleLength).valueQuantity.value <= 45"

Instance: ExampleMenstrualCycle
InstanceOf: MenstrualCycleObservation
Title: "Example Menstrual Cycle Record"
Usage: #example

* status = #final
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19"
* component[cycleLength].valueQuantity = 28 'd'
* component[flowDuration].valueQuantity = 5 'd'

