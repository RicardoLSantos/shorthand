Profile: MobilityProfile
Parent: Observation
Id: mobility-profile
Title: "Mobility Profile"
Description: "Profile for mobility data from iOS Health App"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1 MS
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* device 0..1 MS

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    steadiness 0..1 MS and
    balance 0..1 MS and
    gait 0..1 MS and 
    movement 0..1 MS

* component[steadiness].code = $LOINC#LA32-8
* component[balance].code = $LOINC#LA33058-8
* component[gait].code = $LOINC#LA29042-4
* component[movement].code = $LOINC#LA29043-2
