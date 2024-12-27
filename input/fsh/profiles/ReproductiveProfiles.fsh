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
* value[x] MS

* component contains
    cervicalMucus 0..1 MS and
    ovulationTest 0..1 MS and 
    fertilityStatus 0..1 MS

* component[cervicalMucus].valueCodeableConcept from http://hl7.org/fhir/ValueSet/cervical-mucus-observation (required)
* component[ovulationTest].valueCodeableConcept from http://hl7.org/fhir/ValueSet/ovulation-test-observation (required) 
* component[fertilityStatus].valueCodeableConcept from http://hl7.org/fhir/ValueSet/fertility-status-observation (required)
