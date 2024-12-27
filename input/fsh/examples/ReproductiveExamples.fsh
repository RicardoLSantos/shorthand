Instance: FertilitySignsExample
InstanceOf: FertilityObservation
Usage: #example
Title: "Fertility Signs Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = $LOINC#8669-4 "Ovulation status"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T08:00:00Z"

* component[cervicalMucus]
  * code = $LOINC#89020-2 "Cervical mucus observation"
  * valueCodeableConcept = http://example.org/fhir/CodeSystem/cervical-mucus-cs#eggwhite

* component[ovulationTest]
  * code = $LOINC#89021-0 "Ovulation test"
  * valueCodeableConcept = http://example.org/fhir/CodeSystem/ovulation-test-cs#positive

* component[fertilityStatus]
  * code = $LOINC#89022-8 "Fertility status"
  * valueCodeableConcept = http://example.org/fhir/CodeSystem/fertility-status-cs#fertile
