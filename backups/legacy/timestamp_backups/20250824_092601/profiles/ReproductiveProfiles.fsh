Profile: FertilityObservation
Parent: Observation
Id: fertility-observation
Title: "Fertility Observation Profile"
Description: "Profile for fertility signs and symptoms"

* status MS
* category 1..1 MS
<<<<<<< HEAD
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
=======
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
>>>>>>> 3873710f90bfe03355f425d99c1c517f95832978
* code = $LOINC#8669-4 "Ovulation status"
* subject 1..1 MS
* effectiveDateTime 1..1 MS

<<<<<<< HEAD
* component ^slicing.discriminator.type = #value
=======
* component ^slicing.discriminator.type = #pattern
>>>>>>> 3873710f90bfe03355f425d99c1c517f95832978
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    cervicalMucus 0..1 MS and
    ovulationTest 0..1 MS and
    fertilityStatus 0..1 MS

<<<<<<< HEAD
<<<<<<<< HEAD:backups/legacy/timestamp_backups/20250824_092601/profiles/ReproductiveProfiles.fsh
* component[cervicalMucus].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/cervical-mucus-vs (required)
* component[ovulationTest].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/ovulation-test-vs (required)
* component[fertilityStatus].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/fertility-status-vs (required)
========
* component[cervicalMucus].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cervical-mucus-vs (required)
* component[ovulationTest].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/ovulation-test-vs (required)
* component[fertilityStatus].valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fertility-status-vs (required)
>>>>>>>> 3873710f90bfe03355f425d99c1c517f95832978:backups/fsh_backups/by_phase/ReproductiveProfiles.fsh
=======
* component[cervicalMucus].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/cervical-mucus-vs (required)
* component[ovulationTest].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/ovulation-test-vs (required)
* component[fertilityStatus].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/fertility-status-vs (required)
>>>>>>> 3873710f90bfe03355f425d99c1c517f95832978
