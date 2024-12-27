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

* component[balanceScore].code = $LOINC#LA32-8 "Balance score"
* component[balanceStatus].code = $LOINC#LA32-9 "Balance status"
* component[speed].code = $LOINC#LA29042-4 "Walking speed"
* component[distance].code = $LOINC#LA29043-2 "Walking distance"

Profile: WalkingSteadinessObservation
Parent: MobilityProfile
Id: walking-steadiness-observation
Title: "Walking Steadiness Observation Profile"
Description: "Profile for walking steadiness measurements from iPhone Motion Sensors"

* code = $LOINC#LA32-8 "Balance"

Profile: WalkingSpeedObservation 
Parent: MobilityProfile
Id: walking-speed-observation
Title: "Walking Speed Observation Profile"
Description: "Profile for walking speed measurements from iPhone Motion Sensors"

* code = $LOINC#LA29042-4 "Walking speed"
