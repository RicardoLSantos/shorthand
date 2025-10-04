Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

// Originally defined on lines 5 - 20
Profile: BodyMetricsObservation
Parent: Observation
Id: body-metrics-observation
Title: "Body Metrics Observation Profile"
Description: "Profile for body measurements from iOS Health App"
* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Open Health Manager"
* status MS
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* subject 1..1
* subject MS
* effectiveDateTime 1..1
* effectiveDateTime MS
* device 0..1
* device MS

// Originally defined on lines 22 - 34
Profile: WeightObservation
Parent: BodyMetricsObservation
Id: weight-observation
Title: "Weight Measurement Profile"
Description: "Profile for body weight measurements"
* ^version = "0.1.0"
* ^status = #draft
* code = http://loinc.org#29463-7 "Body weight"
* valueQuantity only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #kg

// Originally defined on lines 36 - 48
Profile: HeightObservation
Parent: BodyMetricsObservation
Id: height-observation
Title: "Height Measurement Profile"
Description: "Profile for body height measurements"
* ^version = "0.1.0"
* ^status = #draft
* code = http://loinc.org#8302-2 "Body height"
* valueQuantity only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #cm

// Originally defined on lines 50 - 62
Profile: BMIObservation
Parent: BodyMetricsObservation
Id: bmi-observation
Title: "BMI Measurement Profile"
Description: "Profile for Body Mass Index calculations"
* ^version = "0.1.0"
* ^status = #draft
* code = http://loinc.org#39156-5 "Body mass index (BMI) [Ratio]"
* valueQuantity only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #kg/m2

// Originally defined on lines 64 - 103
Profile: BodyCompositionObservation
Parent: BodyMetricsObservation
Id: body-composition-observation
Title: "Body Composition Profile"
Description: "Profile for body composition measurements including fat, lean mass, and other metrics"
* ^version = "0.1.0"
* ^status = #draft
* code = http://loinc.org#88365-2 "Body composition panel"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    bodyFat 0.. and
    leanMass 0.. and
    bodyWater 0.. and
    muscleMass 0.. and
    boneMass 0..
* component[bodyFat] 0..1
* component[bodyFat] MS
* component[leanMass] 0..1
* component[leanMass] MS
* component[bodyWater] 0..1
* component[bodyWater] MS
* component[muscleMass] 0..1
* component[muscleMass] MS
* component[boneMass] 0..1
* component[boneMass] MS
* component[bodyFat].code = http://loinc.org#41982-0 "Percentage body fat"
* component[bodyFat].valueQuantity.system = "http://unitsofmeasure.org"
* component[bodyFat].valueQuantity.code = #%
* component[leanMass].code = http://loinc.org#291-7 "Lean body mass"
* component[leanMass].valueQuantity.system = "http://unitsofmeasure.org"
* component[leanMass].valueQuantity.code = #kg
* component[bodyWater].code = http://loinc.org#73708-0 "Total body water"
* component[bodyWater].valueQuantity.system = "http://unitsofmeasure.org"
* component[bodyWater].valueQuantity.code = #L
* component[muscleMass].code = http://loinc.org#73713-0 "Muscle mass"
* component[muscleMass].valueQuantity.system = "http://unitsofmeasure.org"
* component[muscleMass].valueQuantity.code = #kg
* component[boneMass].code = http://loinc.org#73711-4 "Bone mass"
* component[boneMass].valueQuantity.system = "http://unitsofmeasure.org"
* component[boneMass].valueQuantity.code = #kg

