Instance: WeightExample
InstanceOf: WeightObservation
Usage: #example
Title: "Weight Measurement Example"
Description: "Example of a weight measurement from a smart scale"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#29463-7 "Body weight"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 70.5 'kg'
* device = Reference(Device/smart-scale)

Instance: HeightExample
InstanceOf: HeightObservation
Usage: #example
Title: "Height Measurement Example"
Description: "Example of a height measurement"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#8302-2 "Body height"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 175 'cm'

Instance: BMIExample
InstanceOf: BMIObservation
Usage: #example
Title: "BMI Calculation Example"
Description: "Example of a BMI calculation based on weight and height measurements"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#39156-5 "Body mass index (BMI)"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 23.0 'kg/m2'
* derivedFrom[0] = Reference(Observation/WeightExample)
* derivedFrom[1] = Reference(Observation/HeightExample)

Instance: BodyCompositionExample
InstanceOf: BodyCompositionObservation
Usage: #example
Title: "Body Composition Measurement Example" 
Description: "Example of comprehensive body composition measurements from a bioimpedance device"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#88365-2 "Body composition panel"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* device = Reference(Device/bioimpedance-analyzer)

* component[bodyFat].code = $LOINC#41982-0 "Percentage body fat"
* component[bodyFat].valueQuantity = 22.5 '%'

* component[leanMass].code = $LOINC#291-7 "Lean body mass"
* component[leanMass].valueQuantity = 54.6 'kg'

* component[bodyWater].code = $LOINC#73708-0 "Total body water"
* component[bodyWater].valueQuantity = 39.2 'L'

* component[muscleMass].code = $LOINC#73713-0 "Muscle mass"
* component[muscleMass].valueQuantity = 51.8 'kg'

* component[boneMass].code = $LOINC#73711-4 "Bone mass"
* component[boneMass].valueQuantity = 2.8 'kg'

Instance: SmartScale
InstanceOf: Device
Usage: #example
Title: "Smart Scale Device"

* deviceName.name = "Smart Body Analyzer"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "SBA-2024"
* type = $SCT#469576000 "Smart scale device"

Instance: BioimpedanceAnalyzer  
InstanceOf: Device
Usage: #example
Title: "Bioimpedance Analyzer Device"

* deviceName.name = "Professional Body Composition Analyzer"
* deviceName.type = #user-friendly-name
* manufacturer = "MedTech Solutions"
* modelNumber = "BCA-Pro"
* type = $SCT#706767009 "Body composition analyzer"
