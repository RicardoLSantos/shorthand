// Originally defined on lines 1 - 25
Profile: FertilityObservation
Parent: Observation
Id: fertility-observation
Title: "Fertility Observation Profile"
Description: "Profile for fertility signs and symptoms"
* status MS
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = http://loinc.org#8669-4 "Ovulation status"
* subject 1..1
* subject MS
* effectiveDateTime 1..1
* effectiveDateTime MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    cervicalMucus 0.. and
    ovulationTest 0.. and
    fertilityStatus 0..
* component[cervicalMucus] 0..1
* component[cervicalMucus] MS
* component[ovulationTest] 0..1
* component[ovulationTest] MS
* component[fertilityStatus] 0..1
* component[fertilityStatus] MS
* component[cervicalMucus].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cervical-mucus-vs (required)
* component[ovulationTest].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/ovulation-test-vs (required)
* component[fertilityStatus].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fertility-status-vs (required)

