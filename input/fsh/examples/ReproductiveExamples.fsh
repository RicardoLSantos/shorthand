Profile: BasalTemperatureObservation
Parent: ReproductiveObservation
Id: basal-temperature-observation
Title: "Basal Temperature Observation Profile"
Description: "Profile for basal body temperature measurements"

* code = $LOINC#8310-5 "Body temperature"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #Cel

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

* component[cervicalMucus].valueCodeableConcept = http://example.org/fhir/CodeSystem/cervical-mucus-cs#eggwhite
* component[ovulationTest].valueCodeableConcept = http://example.org/fhir/CodeSystem/ovulation-test-cs#positive

Instance: ReproductiveSymptomsExample
InstanceOf: ReproductiveSymptomObservation
Usage: #example
Title: "Reproductive Symptoms Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = $SCT#55300003 "Menstrual cramp"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T10:00:00Z"

* component[severity].valueInteger = 6
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
* category = http://terminology.hl7.org/CodeSystem/goal-category#reproductive
* description.text = "Track regular menstrual cycles"
* subject = Reference(Patient/example)
* startDate = "2024-03-19"

* target.measure = $LOINC#8708-0 "Menstrual cycle duration"
* target.detailRange
  * low = 26
  * high = 30
  * unit = "days"
* target.dueDate = "2024-06-19"

Instance: CompleteCycleExample
InstanceOf: MenstrualCycleObservation
Usage: #example
Title: "Complete Menstrual Cycle Example with All Components"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = $LOINC#49033-4 "Menstrual cycle finding"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T06:00:00Z"

* component[cycleLength].valueQuantity = 28 'd'
* component[flowDuration].valueQuantity = 5 'd'
* component[flowIntensity].valueCodeableConcept = http://example.org/fhir/CodeSystem/flow-intensity-cs#moderate

* note.text = "Regular cycle with normal characteristics"
