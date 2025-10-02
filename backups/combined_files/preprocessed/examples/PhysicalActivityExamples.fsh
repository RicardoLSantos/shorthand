// Originally defined on lines 1 - 27
Instance: PhysicalActivityExample1
InstanceOf: PhysicalActivityObservation
Title: "Example of Walking Activity"
Description: "Physical activity observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = http://snomed.info/sct#228557008 "Walking"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(DeviceActivityTracker)
* component[steps].code = http://loinc.org#55423-8 "Number of steps in 24 hour Measured"
* component[steps].valueQuantity = 8546 '1' "count"
* component[steps].valueQuantity.system = "http://unitsofmeasure.org"
* component[steps].valueQuantity.unit = "count"
* component[distance].code = http://loinc.org#55430-3 "Distance walked"
* component[distance].valueQuantity = 6.2 'km' "kilometer"
* component[distance].valueQuantity.system = "http://unitsofmeasure.org"
* component[distance].valueQuantity.unit = "kilometer"
* component[duration].code = http://loinc.org#55411-3 "Exercise duration"
* component[duration].valueQuantity = 72 'min' "minute"
* component[duration].valueQuantity.system = "http://unitsofmeasure.org"
* component[duration].valueQuantity.unit = "minute"
* component[energy].code = http://loinc.org#55424-6 "Energy expenditure"
* component[energy].valueQuantity = 320 'kcal' "kilocalorie"
* component[energy].valueQuantity.system = "http://unitsofmeasure.org"
* component[energy].valueQuantity.unit = "kilocalorie"

// Originally defined on lines 29 - 38
Instance: DeviceActivityTracker
InstanceOf: Device
Title: "Activity Tracking Device"
Description: "Activity tracker device example"
Usage: #example
* deviceName.name = "Health Activity Tracker"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "HAT-2024"
* type = http://snomed.info/sct#258158006 "Breathing rate"

