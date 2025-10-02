Alias: $SCT = http://snomed.info/sct

Extension: MeasurementConditions
Id: measurement-conditions
Title: "Measurement Conditions Extension"
Description: "Records the conditions under which body measurements were taken"

* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementConditionsVS (required)

Extension: MeasurementDevice
Id: measurement-device-type
Title: "Measurement Device Type Extension"
Description: "Specifies the type of device used for body measurements"

* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementDeviceTypeVS (required)

ValueSet: MeasurementConditionsVS
Id: measurement-conditions-vs
Title: "Measurement Conditions Value Set"
Description: "Standard conditions under which measurements are taken"

* ^version = "0.1.0"
* ^status = #draft

* $SCT#307818003 "Pre-breakfast"
* $SCT#307819006 "Post-exercise"
* $SCT#307820000 "Wearing light clothing"
* $SCT#255203001 "First thing in morning"
* $SCT#255214005 "After void"
* $SCT#309604004 "During rest"

ValueSet: MeasurementDeviceTypeVS
Id: measurement-device-type-vs
Title: "Measurement Device Type Value Set"
Description: "Types of devices used for health and body measurements"

* ^version = "0.1.0"
* ^status = #draft

* $SCT#469576000 "Smart watch"
* $SCT#706767009 | display = "Patient data recorder"
* $SCT#131009002 "Height measuring device"
* $SCT#706889009 "Blood pressure monitor"
* $SCT#444699000 "Tape measure"
* $SCT#44056008  "Digital scale"

Instance: WeightWithConditions
InstanceOf: WeightObservation
Usage: #example
Description: "Weight with conditions observation example"
Title: "Weight Measurement with Conditions Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#29463-7 "Body weight"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* valueQuantity = 70.5 'kg'

* extension[measurement-conditions].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/measurement-conditions"
* extension[measurement-conditions].valueCodeableConcept = $SCT#307818003 "Pre-breakfast"

* extension[measurement-device-type].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/measurement-device-type"
* extension[measurement-device-type].valueCodeableConcept = $SCT#469576000 "Smart scale device"
