Profile: FertilityObservation
Parent: Observation
Id: fertility-observation
Title: "Fertility Observation Profile"
Description: "Profile for fertility signs and symptoms"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code = $LOINC#8669-4 "Ovulation status"
* subject 1..1 MS
* effectiveDateTime 1..1 MS

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    cervicalMucus 0..1 MS and
    ovulationTest 0..1 MS and
    fertilityStatus 0..1 MS

* component[cervicalMucus].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/cervical-mucus-vs (required)
* component[ovulationTest].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/ovulation-test-vs (required)
* component[fertilityStatus].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/fertility-status-vs (required)
