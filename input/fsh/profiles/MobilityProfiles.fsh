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

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    balanceScore 0..1 MS and
    balanceStatus 0..1 MS and
    speed 0..1 MS and
    distance 0..1 MS

* component[balanceScore].code = $LOINC#LA32-8
* component[balanceStatus].code = $LOINC#LA32-9
* component[speed].code = $LOINC#LA29042-4
* component[distance].code = $LOINC#LA29043-2
