Alias: $SCT = http://snomed.info/sct

Extension: MeasurementConditions
Id: measurement-conditions
Title: "Measurement Conditions Extension"
Description: "Records the conditions under which body measurements were taken"
* ^experimental = false

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^context[0].type = #element
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementConditionsVS (required)

Extension: MeasurementDevice
Id: measurement-device-type
Title: "Measurement Device Type Extension"
Description: "Specifies the type of device used for body measurements"
* ^experimental = false

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^context[0].type = #element
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementDeviceTypeVS (required)

ValueSet: MeasurementConditionsVS
Id: measurement-conditions-vs
Title: "Measurement Conditions Value Set"
Description: "Standard conditions under which measurements are taken"
* ^experimental = false

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"

* $SCT#307818003 "Pre-breakfast"
* $SCT#307819006 "Post-exercise"
* $SCT#307820000 "Wearing light clothing"
* $SCT#255203001 "First thing in morning"
* $SCT#410594000 "After exercise"
* $SCT#309604004 "During rest"

ValueSet: MeasurementDeviceTypeVS
Id: measurement-device-type-vs
Title: "Measurement Device Type Value Set"
Description: "Types of devices used for health and body measurements"
* ^experimental = false

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"

* $SCT#5159002 "Physiologic monitoring system"
* $SCT#706767009 "Patient data recorder"
* $SCT#49062001 "Device"
* $SCT#13288007 "Monitor"
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
* extension[measurement-device-type].valueCodeableConcept = $SCT#5159002 "Physiologic monitoring system"
