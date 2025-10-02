// Originally defined on lines 1 - 15
Instance: WeightExample
InstanceOf: WeightObservation
Title: "Weight Measurement Example"
Description: "Weight observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = http://loinc.org#29463-7 "Body weight"
* subject = Reference(PatientExample)
* performer = Reference(PractitionerExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 70.5 'kg' "kilogram"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.unit = "kilogram"
* device = Reference(SmartScale)

// Originally defined on lines 17 - 30
Instance: HeightExample
InstanceOf: HeightObservation
Title: "Height Measurement Example"
Description: "Height observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = http://loinc.org#8302-2 "Body height"
* subject = Reference(PatientExample)
* performer = Reference(PractitionerExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 175 'cm' "centimeter"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.unit = "centimeter"

// Originally defined on lines 32 - 47
Instance: BMIExample
InstanceOf: BMIObservation
Title: "BMI Calculation Example"
Description: "Body Mass Index observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = http://loinc.org#39156-5 "Body mass index (BMI) [Ratio]"
* subject = Reference(PatientExample)
* performer = Reference(PractitionerExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 23 'kg/m2' "kilogram per square meter"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.unit = "kilogram per square meter"
* derivedFrom[0] = Reference(Observation/WeightExample)
* derivedFrom[1] = Reference(Observation/HeightExample)

// Originally defined on lines 49 - 85
Instance: BodyCompositionExample
InstanceOf: BodyCompositionObservation
Title: "Body Composition Measurement Example"
Description: "Body composition observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = http://loinc.org#88365-2 "Body composition panel"
* subject = Reference(PatientExample)
* performer = Reference(PractitionerExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* device = Reference(BioimpedanceAnalyzer)
* component[bodyFat].code = http://loinc.org#41982-0 "Percentage body fat"
* component[bodyFat].valueQuantity = 22.5 '%' "percent"
* component[bodyFat].valueQuantity.system = "http://unitsofmeasure.org"
* component[bodyFat].valueQuantity.unit = "percent"
* component[leanMass].code = http://loinc.org#291-7 "Lean body mass"
* component[leanMass].valueQuantity = 54.6 'kg' "kilogram"
* component[leanMass].valueQuantity.system = "http://unitsofmeasure.org"
* component[leanMass].valueQuantity.unit = "kilogram"
* component[bodyWater].code = http://loinc.org#73708-0 "Total body water"
* component[bodyWater].valueQuantity = 39.2 'L' "liter"
* component[bodyWater].valueQuantity.system = "http://unitsofmeasure.org"
* component[bodyWater].valueQuantity.unit = "liter"
* component[muscleMass].code = http://loinc.org#73713-0 "Muscle mass"
* component[muscleMass].valueQuantity = 51.8 'kg' "kilogram"
* component[muscleMass].valueQuantity.system = "http://unitsofmeasure.org"
* component[muscleMass].valueQuantity.unit = "kilogram"
* component[boneMass].code = http://loinc.org#73711-4 "Bone mass"
* component[boneMass].valueQuantity = 2.8 'kg' "kilogram"
* component[boneMass].valueQuantity.system = "http://unitsofmeasure.org"
* component[boneMass].valueQuantity.unit = "kilogram"

// Originally defined on lines 87 - 96
Instance: SmartScale
InstanceOf: Device
Title: "Smart Scale Device"
Description: "Smart scale device example"
Usage: #example
* deviceName.name = "Smart Body Analyzer"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "SBA-2024"
* type = http://snomed.info/sct#5159002 "Physiologic monitoring system"

// Originally defined on lines 98 - 107
Instance: BioimpedanceAnalyzer
InstanceOf: Device
Title: "Bioimpedance Analyzer Device"
Description: "Bioimpedance analyzer device example"
Usage: #example
* deviceName.name = "Professional Body Composition Analyzer"
* deviceName.type = #user-friendly-name
* manufacturer = "MedTech Solutions"
* modelNumber = "BCA-Pro"
* type = http://snomed.info/sct#706767009 "Patient data recorder"

