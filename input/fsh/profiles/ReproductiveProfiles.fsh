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

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    cervicalMucus 0..1 MS and
    ovulationTest 0..1 MS and
    fertilityStatus 0..1 MS

* component[cervicalMucus].valueCodeableConcept from http://example.org/fhir/ValueSet/cervical-mucus
* component[ovulationTest].valueCodeableConcept from http://example.org/fhir/ValueSet/ovulation-test
* component[fertilityStatus].valueCodeableConcept from http://example.org/fhir/ValueSet/fertility-status
