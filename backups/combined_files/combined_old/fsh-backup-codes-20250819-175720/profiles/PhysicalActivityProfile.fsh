Alias: $LOINC = http://loinc.org
Alias: $SNOMED = http://snomed.info/sct
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ActivityCodes = https://github.com/RicardoLSantos/shorthand/activity-codes

Profile: PhysicalActivityObservation
Parent: Observation
Id: physical-activity-observation
Title: "Physical Activity Observation Profile"
Description: "Profile for recording physical activity data from iOS Health App"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1 MS
* code from PhysicalActivityTypeVS (required)
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* device 0..1 MS
* value[x] only Quantity
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    steps 0..1 MS and
    distance 0..1 MS and
    duration 0..1 MS and
    energy 0..1 MS

* component[steps].code = $LOINC#55423-8 "Number of steps in 24 hour Measured"
* component[steps].valueQuantity only Quantity
* component[steps].valueQuantity.system = $UCUM
* component[steps].valueQuantity.code = #1 "count"

* component[distance].code = $LOINC#55430-3 "Distance walked"
* component[distance].valueQuantity only Quantity
* component[distance].valueQuantity.system = $UCUM
* component[distance].valueQuantity.code = #km "kilometer"

* component[duration].code = $LOINC#55411-3 "Exercise duration"
* component[duration].valueQuantity only Quantity
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min "minute"

* component[energy].code = $LOINC#55424-6 "Energy expenditure"
* component[energy].valueQuantity only Quantity
* component[energy].valueQuantity.system = $UCUM
* component[energy].valueQuantity.code = #kcal "kilocalorie"
