Instance: StressLevelExample
InstanceOf: StressLevelProfile
Usage: #example
Title: "Stress Level Measurement Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#89592-0 "Stress level score"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-01-03T15:30:00Z"
* valueQuantity = 7 '{score}' "score"

* component[physiologicalStress].valueQuantity = 6 '{score}' "score"
* component[psychologicalStress].valueQuantity = 8 '{score}' "score"
* component[chronicity].valueCodeableConcept = StressChronicityCS#subacute
* component[impact].valueCodeableConcept = StressImpactCS#moderate

* extension[triggers].valueCodeableConcept = StressTriggersCS#work
* extension[coping].valueCodeableConcept = StressCopingCS#meditation
