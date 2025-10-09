Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

Profile: BodyMetricsObservation
Parent: Observation
Id: body-metrics-observation
Title: "Body Metrics Observation Profile"
Description: "Profile for body measurements from iOS Health App"

* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "Open Health Manager"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* device 0..1 MS

Profile: WeightObservation
Parent: BodyMetricsObservation
Id: weight-observation  
Title: "Weight Measurement Profile"
Description: "Profile for body weight measurements"

* ^version = "0.1.0"
* ^status = #draft

* code = $LOINC#29463-7 "Body weight"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #kg

Profile: HeightObservation
Parent: BodyMetricsObservation
Id: height-observation
Title: "Height Measurement Profile" 
Description: "Profile for body height measurements"

* ^version = "0.1.0"
* ^status = #draft

* code = $LOINC#8302-2 "Body height"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #cm

Profile: BMIObservation
Parent: BodyMetricsObservation
Id: bmi-observation
Title: "BMI Measurement Profile"
Description: "Profile for Body Mass Index calculations"

* ^version = "0.1.0"
* ^status = #draft

* code = $LOINC#39156-5 "Body mass index (BMI) [Ratio]"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #kg/m2

Profile: BodyCompositionObservation
Parent: BodyMetricsObservation
Id: body-composition-observation
Title: "Body Composition Profile"
Description: "Profile for body composition measurements including fat, lean mass, and other metrics"

* ^version = "0.1.0"
* ^status = #draft

* code = $LOINC#88365-2 "Body composition panel"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    bodyFat 0..1 MS and
    leanMass 0..1 MS and
    bodyWater 0..1 MS and
    muscleMass 0..1 MS and
    boneMass 0..1 MS

* component[bodyFat].code = $LOINC#41982-0 "Percentage body fat"
* component[bodyFat].valueQuantity.system = $UCUM
* component[bodyFat].valueQuantity.code = #%

* component[leanMass].code = $LOINC#291-7 "Lean body mass"
* component[leanMass].valueQuantity.system = $UCUM
* component[leanMass].valueQuantity.code = #kg

* component[bodyWater].code = $LOINC#73708-0 "Total body water"
* component[bodyWater].valueQuantity.system = $UCUM  
* component[bodyWater].valueQuantity.code = #L

* component[muscleMass].code = $LOINC#73713-0 "Muscle mass"
* component[muscleMass].valueQuantity.system = $UCUM
* component[muscleMass].valueQuantity.code = #kg

* component[boneMass].code = $LOINC#73711-4 "Bone mass" 
* component[boneMass].valueQuantity.system = $UCUM
* component[boneMass].valueQuantity.code = #kg
