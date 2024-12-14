Instance: WeightExample
InstanceOf: WeightObservation
Usage: #example
Title: "Weight Measurement Example"
Description: "Example of a weight measurement from a smart scale"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#29463-7 "Body weight [Mass]"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 70.5 'kg' "kilogram"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "kilogram"
* device = Reference(SmartScale)
* performer = Reference(SmartScale)

Instance: HeightExample
InstanceOf: HeightObservation
Usage: #example
Title: "Height Measurement Example"
Description: "Example of a height measurement"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#8302-2 "Body height [Length]"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 175 'cm' "centimeter"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "centimeter"

Instance: BMIExample
InstanceOf: BMIObservation
Usage: #example
Title: "BMI Calculation Example"
Description: "Example of a BMI calculation based on weight and height measurements"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#39156-5 "Body mass index (BMI) [Ratio]"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 23.0 'kg/m2' "kilogram per square meter"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "kilogram per square meter"
* derivedFrom[0] = Reference(Observation/WeightExample)
* derivedFrom[1] = Reference(Observation/HeightExample)

Instance: BodyCompositionExample
InstanceOf: BodyCompositionObservation
Usage: #example
Title: "Body Composition Measurement Example" 
Description: "Example of comprehensive body composition measurements from a bioimpedance device"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#88365-2 "Body composition measurement panel"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* device = Reference(BioimpedanceAnalyzer)
* performer = Reference(BioimpedanceAnalyzer)

* component[bodyFat].code = $LOINC#41982-0 "Percentage of body fat Measured"
* component[bodyFat].valueQuantity = 22.5 '%' "percent"
* component[bodyFat].valueQuantity.system = $UCUM
* component[bodyFat].valueQuantity.unit = "percent"

* component[leanMass].code = $LOINC#291-7 "Lean body mass by Calculated"
* component[leanMass].valueQuantity = 54.6 'kg' "kilogram"
* component[leanMass].valueQuantity.system = $UCUM
* component[leanMass].valueQuantity.unit = "kilogram"

* component[bodyWater].code = $LOINC#73708-0 "Body water [Mass]"
* component[bodyWater].valueQuantity = 39.2 'L' "liter"
* component[bodyWater].valueQuantity.system = $UCUM
* component[bodyWater].valueQuantity.unit = "liter"

* component[muscleMass].code = $LOINC#73713-0 "Muscle mass [Mass]"
* component[muscleMass].valueQuantity = 51.8 'kg' "kilogram"
* component[muscleMass].valueQuantity.system = $UCUM
* component[muscleMass].valueQuantity.unit = "kilogram"

* component[boneMass].code = $LOINC#73711-4 "Bone mass [Mass]"
* component[boneMass].valueQuantity = 2.8 'kg' "kilogram"
* component[boneMass].valueQuantity.system = $UCUM
* component[boneMass].valueQuantity.unit = "kilogram"

Instance: SmartScale
InstanceOf: Device
Usage: #example
Title: "Smart Scale Device"
* deviceName.name = "Smart Body Analyzer"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "SBA-2024"
* type = $SCT#469576000 "Digital weighing scale (physical object)"

Instance: BioimpedanceAnalyzer  
InstanceOf: Device
Usage: #example
Title: "Bioimpedance Analyzer Device"
* deviceName.name = "Professional Body Composition Analyzer"
* deviceName.type = #user-friendly-name
* manufacturer = "MedTech Solutions"
* modelNumber = "BCA-Pro"
* type = $SCT#706767009 "Body composition analyzer (physical object)"
