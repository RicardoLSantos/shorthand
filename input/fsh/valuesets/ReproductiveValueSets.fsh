
ValueSet: FlowIntensityVS
Id: flow-intensity-vs
Title: "Menstrual Flow Intensity Value Set"
Description: "Intensity levels for menstrual flow"
* codes from system FlowIntensityCS

CodeSystem: FlowIntensityCS
Id: flow-intensity-cs
Title: "Flow Intensity Code System"
* #light "Light"
* #moderate "Moderate"
* #heavy "Heavy"
* #spotting "Spotting"

ValueSet: OvulationTestVS
Id: ovulation-test-vs
Title: "Ovulation Test Value Set"
Description: "Results for ovulation tests"
* codes from system OvulationTestCS

CodeSystem: OvulationTestCS
Id: ovulation-test-cs
Title: "Ovulation Test Code System"
* #positive "Positive"
* #negative "Negative"
* #invalid "Invalid"
* #notTested "Not tested"

ValueSet: FertilityStatusVS
Id: fertility-status-vs
Title: "Fertility Status Value Set"
Description: "Fertility status indicators"
* codes from system FertilityStatusCS

CodeSystem: FertilityStatusCS
Id: fertility-status-cs
Title: "Fertility Status Code System"
* #fertile "Fertile"
* #nonFertile "Non-fertile"
* #unknown "Unknown"
* #likelyFertile "Likely fertile"
* #likelyNonFertile "Likely non-fertile"

ValueSet: CyclePhaseVS
Id: cycle-phase-vs
Title: "Menstrual Cycle Phase Value Set"
Description: "Phases of the menstrual cycle"
* codes from system CyclePhaseCS

CodeSystem: CyclePhaseCS
Id: cycle-phase-cs
Title: "Cycle Phase Code System"
* #menstrual "Menstrual phase"
* #follicular "Follicular phase"
* #ovulatory "Ovulatory phase"
* #luteal "Luteal phase"

ValueSet: ReproductiveMedicationsVS
Id: reproductive-medications-vs
Title: "Reproductive Medications Value Set"
Description: "Common medications related to reproductive health"
* $SCT#77468003 "Combined oral contraceptive"
* $SCT#169442009 "Progestogen-only contraceptive"
* $SCT#412776001 "Fertility medication"
* $SCT#256697009 "Menstrual cycle regulator"

Instance: ExampleFlowIntensity
InstanceOf: Observation
Usage: #example
Title: "Flow Intensity Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = FlowIntensityCS#moderate
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T10:00:00Z"
* valueCodeableConcept = FlowIntensityCS#moderate

Instance: ExampleFertilityStatus
InstanceOf: Observation
Usage: #example
Title: "Fertility Status Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = FertilityStatusCS#fertile
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T10:00:00Z"
* valueCodeableConcept = FertilityStatusCS#fertile

