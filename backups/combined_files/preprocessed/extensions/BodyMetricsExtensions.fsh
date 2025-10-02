Alias: $SCT = http://snomed.info/sct

// Originally defined on lines 3 - 15
Extension: MeasurementConditions
Parent: Extension
Id: measurement-conditions
Title: "Measurement Conditions Extension"
Description: "Records the conditions under which body measurements were taken"
* ^experimental = false
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementConditionsVS (required)
* extension 0..0

// Originally defined on lines 17 - 29
Extension: MeasurementDevice
Parent: Extension
Id: measurement-device-type
Title: "Measurement Device Type Extension"
Description: "Specifies the type of device used for body measurements"
* ^experimental = false
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementDeviceTypeVS (required)
* extension 0..0

// Originally defined on lines 31 - 45
ValueSet: MeasurementConditionsVS
Id: measurement-conditions-vs
Title: "Measurement Conditions Value Set"
Description: "Standard conditions under which measurements are taken"
* ^experimental = false
* ^version = "0.1.0"
* ^status = #draft
* http://snomed.info/sct#307818003 "Pre-breakfast"
* http://snomed.info/sct#307819006 "Post-exercise"
* http://snomed.info/sct#307820000 "Wearing light clothing"
* http://snomed.info/sct#255203001 "First thing in morning"
* http://snomed.info/sct#410594000 "After exercise"
* http://snomed.info/sct#309604004 "During rest"

// Originally defined on lines 47 - 61
ValueSet: MeasurementDeviceTypeVS
Id: measurement-device-type-vs
Title: "Measurement Device Type Value Set"
Description: "Types of devices used for health and body measurements"
* ^experimental = false
* ^version = "0.1.0"
* ^status = #draft
* http://snomed.info/sct#5159002 "Physiologic monitoring system"
* http://snomed.info/sct#706767009 "Patient data recorder"
* http://snomed.info/sct#49062001 "Device"
* http://snomed.info/sct#13288007 "Monitor"
* http://snomed.info/sct#444699000 "Tape measure"
* http://snomed.info/sct#44056008 "Digital scale"

// Originally defined on lines 63 - 80
Instance: WeightWithConditions
InstanceOf: WeightObservation
Title: "Weight Measurement with Conditions Example"
Description: "Weight with conditions observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = http://loinc.org#29463-7 "Body weight"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 70.5 'kg'
* extension[measurement-conditions].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/measurement-conditions"
* extension[measurement-conditions].valueCodeableConcept = http://snomed.info/sct#307818003 "Pre-breakfast"
* extension[measurement-device-type].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/measurement-device-type"
* extension[measurement-device-type].valueCodeableConcept = http://snomed.info/sct#5159002 "Physiologic monitoring system"

