Instance: iphone-example
InstanceOf: Device
Usage: #example
Title: "iPhone Device Example"
Description: "Example iPhone device for iOS Health App data collection"

* deviceName.name = "iPhone"
* deviceName.type = #user-friendly-name
* type = http://snomed.info/sct#706689003 "Mobile telephone (physical object)"
* manufacturer = "Apple Inc."
* version.value = "iOS 17.0"
* status = #active

* property[0].type = http://terminology.hl7.org/CodeSystem/device-property-type#model
* property[=].valueCode = http://terminology.hl7.org/CodeSystem/device-property-type#model

* property[+].type = http://terminology.hl7.org/CodeSystem/device-property-type#os-version
* property[=].valueCode = http://terminology.hl7.org/CodeSystem/device-property-type#os-version

* note.text = "iPhone 15 Pro running iOS 17.0 - Apple Inc."
