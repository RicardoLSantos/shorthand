Instance: StressLevelExample
InstanceOf: StressLevelProfile
Usage: #example
Description: "Stress level observation example"
Title: "Stress Level Measurement Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#64394-0 "PhenX - perceived stress protocol 180801"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-01-03T15:30:00Z"
* valueQuantity = 7 '1' "score"

* component[physiologicalStress].valueQuantity = 6 '1' "score"
* component[psychologicalStress].valueQuantity = 8 '1' "score"
* component[chronicity].valueCodeableConcept = StressChronicityCS#subacute
* component[impact].valueCodeableConcept = StressImpactCS#moderate

* extension[triggers].valueCodeableConcept = StressTriggersCS#work
* extension[coping].valueCodeableConcept = StressCopingCS#meditation
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/allostatic-load"
* extension[=].valueQuantity = 0.72 '1' "score"
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/physiological-stress-index"
* extension[=].valueQuantity = 6.5 '1' "score"
