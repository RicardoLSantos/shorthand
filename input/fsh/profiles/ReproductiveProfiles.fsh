Profile: FertilityObservation
Parent: Observation
Id: fertility-observation
Title: "Fertility Observation Profile"
Description: "Profile for fertility signs and symptoms"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#ovulation-status "Ovulation status"
* subject 1..1 MS
* effectiveDateTime 1..1 MS

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    cervicalMucus 0..1 MS and
    ovulationTest 0..1 MS and
    fertilityStatus 0..1 MS

* component[cervicalMucus].code = $SCT#289567002 "Cervical mucus"
* component[cervicalMucus].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cervical-mucus-vs (required)

* component[ovulationTest].code = $SCT#252366009 "Ovulation test"
* component[ovulationTest].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/ovulation-test-vs (required)

* component[fertilityStatus].code = $SCT#87527008 "Fertility status"
* component[fertilityStatus].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fertility-status-vs (required)
