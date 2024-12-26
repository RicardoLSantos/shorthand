
Instance: BasalTemperatureExample
InstanceOf: BasalTemperatureObservation
Usage: #example
Title: "Basal Temperature Record Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = $LOINC#8310-5 "Body temperature"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T06:30:00Z"
* valueQuantity = 36.7 'Cel'

Instance: FertilitySignsExample
InstanceOf: FertilityObservation
Usage: #example
Title: "Fertility Signs Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = $LOINC#8669-4 "Ovulation status"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T08:00:00Z"

* component[cervicalMucus].code = $LOINC#8669-4
* component[cervicalMucus].valueCodeableConcept = CervicalMucusCS#eggwhite

* component[ovulationTest].code = $LOINC#8670-2
* component[ovulationTest].valueCodeableConcept = OvulationTestCS#positive

Instance: ReproductiveSymptomsExample
InstanceOf: ReproductiveSymptomObservation
Usage: #example
Title: "Reproductive Symptoms Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = $SCT#55300003 "Menstrual cramp"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T10:00:00Z"

* component[severity].code = $LOINC#72514-3
* component[severity].valueInteger = 6

* component[duration].code = $LOINC#103332-8
* component[duration].valueQuantity = 4 'h'

Instance: ReproductiveCyclePlanExample
InstanceOf: ReproductiveCyclePlan
Usage: #example
Title: "Reproductive Cycle Plan Example"

* status = #active
* intent = #plan
* subject = Reference(Patient/example)
* period.start = "2024-03-19"
* period.end = "2024-04-19"

* activity[0].detail.kind = #observation
* activity[0].detail.code = $SCT#364311006 "Menstrual cycle monitoring"
* activity[0].detail.status = #scheduled
* activity[0].detail.scheduledTiming.repeat.frequency = 1
* activity[0].detail.scheduledTiming.repeat.period = 1
* activity[0].detail.scheduledTiming.repeat.periodUnit = #d

Instance: ReproductiveGoalExample
InstanceOf: ReproductiveGoal
Usage: #example
Title: "Reproductive Goal Example"

* lifecycleStatus = #active
* description = "Track regular menstrual cycles"
* subject = Reference(Patient/example)
* startDate = "2024-03-19"

* target.measure = $LOINC#8708-0 "Menstrual cycle duration"
* target.detailRange.low = 26
* target.detailRange.high = 30
* target.detailRange.unit = "days"
* target.dueDate = "2024-06-19"

Instance: CompleteCycleExample
InstanceOf: MenstrualCycleObservation
Usage: #example
Title: "Complete Menstrual Cycle Example with All Components"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = $LOINC#49033-4
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T06:00:00Z"

* component[cycleLength].code = $LOINC#8708-0
* component[cycleLength].valueQuantity = 28 'd'

* component[flowDuration].code = $LOINC#49030-0
* component[flowDuration].valueQuantity = 5 'd'

* component[flowIntensity].code = FlowIntensityCS#moderate
* component[flowIntensity].valueCodeableConcept = FlowIntensityCS#moderate

* note.text = "Regular cycle with normal characteristics"

