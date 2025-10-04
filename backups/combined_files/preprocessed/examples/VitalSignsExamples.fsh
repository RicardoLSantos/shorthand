// Originally defined on lines 1 - 18
Instance: HeartRateExample
InstanceOf: HeartRateObservation
Title: "Heart Rate Measurement Example"
Description: "Heart rate observation example"
Usage: #example
* status = #final
* code = http://loinc.org#8867-4 "Heart rate"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 72 '/min' "per minute"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.unit = "per minute"
* device = Reference(DeviceHeartRateMonitor)
* performer = Reference(PractitionerExample)
* component[heartRateVariability].code = http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity = 45 'ms' "millisecond"
* component[heartRateVariability].valueQuantity.system = "http://unitsofmeasure.org"
* component[heartRateVariability].valueQuantity.unit = "millisecond"

// Originally defined on lines 20 - 38
Instance: BloodPressureExample
InstanceOf: BloodPressureObservation
Title: "Blood Pressure Measurement Example"
Description: "Blood pressure observation example"
Usage: #example
* status = #final
* code = http://loinc.org#85354-9 "Blood pressure panel with all children optional"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(DeviceBloodPressureMonitor)
* performer = Reference(PractitionerExample)
* component[systolic].code = http://loinc.org#8480-6 "Systolic blood pressure"
* component[systolic].valueQuantity = 120 'mm[Hg]' "millimeter of mercury"
* component[systolic].valueQuantity.system = "http://unitsofmeasure.org"
* component[systolic].valueQuantity.unit = "millimeter of mercury"
* component[diastolic].code = http://loinc.org#8462-4 "Diastolic blood pressure"
* component[diastolic].valueQuantity = 80 'mm[Hg]' "millimeter of mercury"
* component[diastolic].valueQuantity.system = "http://unitsofmeasure.org"
* component[diastolic].valueQuantity.unit = "millimeter of mercury"

// Originally defined on lines 40 - 49
Instance: DeviceHeartRateMonitor
InstanceOf: Device
Title: "Heart Rate Monitor Device"
Description: "Heart rate monitor device example"
Usage: #example
* deviceName.name = "Continuous Heart Rate Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "HRM-2024"
* type = http://snomed.info/sct#720737000 "Pulse rate monitoring device"

// Originally defined on lines 51 - 60
Instance: DeviceBloodPressureMonitor
InstanceOf: Device
Title: "Blood Pressure Monitor Device"
Description: "Blood pressure monitor device example"
Usage: #example
* deviceName.name = "Digital Blood Pressure Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "BPM-2024"
* type = http://snomed.info/sct#43770009 "Blood pressure monitor"

