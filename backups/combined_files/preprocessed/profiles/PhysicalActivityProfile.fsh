Alias: $LOINC = http://loinc.org
Alias: $SNOMED = http://snomed.info/sct
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ActivityCodes = https://2rdoc.pt/ig/ios-lifestyle-medicine/activity-codes

// Originally defined on lines 6 - 50
Profile: PhysicalActivityObservation
Parent: Observation
Id: physical-activity-observation
Title: "Physical Activity Observation Profile"
Description: "Profile for recording physical activity data from iOS Health App"
* status MS
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1
* code MS
* code from PhysicalActivityTypeVS (required)
* subject 1..1
* subject MS
* subject only Reference(Patient)
* effectiveDateTime 1..1
* effectiveDateTime MS
* device 0..1
* device MS
* value[x] only Quantity
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    steps 0.. and
    distance 0.. and
    duration 0.. and
    energy 0..
* component[steps] 0..1
* component[steps] MS
* component[distance] 0..1
* component[distance] MS
* component[duration] 0..1
* component[duration] MS
* component[energy] 0..1
* component[energy] MS
* component[steps].code = http://loinc.org#55423-8 "Number of steps in 24 hour Measured"
* component[steps].valueQuantity only Quantity
* component[steps].valueQuantity.system = "http://unitsofmeasure.org"
* component[steps].valueQuantity.code = #1 "count"
* component[distance].code = http://loinc.org#55430-3 "Distance walked"
* component[distance].valueQuantity only Quantity
* component[distance].valueQuantity.system = "http://unitsofmeasure.org"
* component[distance].valueQuantity.code = #km "kilometer"
* component[duration].code = http://loinc.org#55411-3 "Exercise duration"
* component[duration].valueQuantity only Quantity
* component[duration].valueQuantity.system = "http://unitsofmeasure.org"
* component[duration].valueQuantity.code = #min "minute"
* component[energy].code = http://loinc.org#55424-6 "Energy expenditure"
* component[energy].valueQuantity only Quantity
* component[energy].valueQuantity.system = "http://unitsofmeasure.org"
* component[energy].valueQuantity.code = #kcal "kilocalorie"

