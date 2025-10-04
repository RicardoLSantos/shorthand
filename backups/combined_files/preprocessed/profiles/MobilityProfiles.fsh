// Originally defined on lines 1 - 28
Profile: MobilityProfile
Parent: Observation
Id: mobility-profile
Title: "Mobility Profile"
Description: "Profile for mobility data from iOS Health App"
* status MS
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1
* code MS
* subject 1..1
* subject MS
* effectiveDateTime 1..1
* effectiveDateTime MS
* device 0..1
* device MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    steadiness 0.. and
    balance 0.. and
    gait 0.. and
    movement 0..
* component[steadiness] 0..1
* component[steadiness] MS
* component[balance] 0..1
* component[balance] MS
* component[gait] 0..1
* component[gait] MS
* component[movement] 0..1
* component[movement] MS
* component[steadiness].code = http://loinc.org#LA32-8
* component[balance].code = http://loinc.org#LA32-9
* component[gait].code = http://loinc.org#LA29042-4
* component[movement].code = http://loinc.org#LA29043-2

