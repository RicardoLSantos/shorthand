Instance: PhysicalActivityExample1
InstanceOf: PhysicalActivityObservation
Usage: #example
Title: "Example of Walking Activity"
Description: "Example of walking activity data from iOS Health App"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $SNOMED#228557008 "Walking (observable entity)"
* subject = Reference(PatientExample)
* performer = Reference(DeviceActivityTracker)
* effectiveDateTime = "2024-03-19T15:30:00Z"

* component[steps].code = $LOINC#55423-8 "Number of steps in unspecified time Pedometer"
* component[steps].valueQuantity = 8546 '1' "count"
* component[steps].valueQuantity.system = $UCUM
* component[steps].valueQuantity.unit = "count"

* component[distance].code = $LOINC#55430-3 "Walking distance unspecified time Pedometer"
* component[distance].valueQuantity = 6.2 'km' "kilometer"
* component[distance].valueQuantity.system = $UCUM
* component[distance].valueQuantity.unit = "kilometer"

* component[duration].code = $LOINC#55411-3 "Exercise duration"
* component[duration].valueQuantity = 72 'min' "minute"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.unit = "minute"

* component[energy].code = $LOINC#55424-6 "Calories burned in unspecified time Pedometer"
* component[energy].valueQuantity = 320 'kcal' "kilocalorie"
* component[energy].valueQuantity.system = $UCUM
* component[energy].valueQuantity.unit = "kilocalorie"

Instance: DeviceActivityTracker
InstanceOf: Device
Usage: #example
Title: "Activity Tracking Device"
* deviceName.name = "Health Activity Tracker"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "HAT-2024"
* type = $SCT#258158006 "Electronic activity monitor (physical object)"
