Instance: HeartRateExample
InstanceOf: HeartRateObservation
Usage: #example
Description: "Heart rate observation example"
Title: "Heart Rate Measurement Example"
* status = #final
* code = $LOINC#8867-4 "Heart rate"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 72 '/min' "per minute"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "per minute"
* device = Reference(DeviceHeartRateMonitor)
* performer = Reference(PractitionerExample)
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity = 45 'ms' "millisecond"
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.unit = "millisecond"

Instance: BloodPressureExample
InstanceOf: BloodPressureObservation
Usage: #example
Description: "Blood pressure observation example"
Title: "Blood Pressure Measurement Example"
* status = #final
* code = $LOINC#85354-9 "Blood pressure panel with all children optional"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(DeviceBloodPressureMonitor)
* performer = Reference(PractitionerExample)
* component[systolic].code = $LOINC#8480-6 "Systolic blood pressure"
* component[systolic].valueQuantity = 120 'mm[Hg]' "millimeter of mercury"
* component[systolic].valueQuantity.system = $UCUM
* component[systolic].valueQuantity.unit = "millimeter of mercury"
* component[diastolic].code = $LOINC#8462-4 "Diastolic blood pressure"
* component[diastolic].valueQuantity = 80 'mm[Hg]' "millimeter of mercury"
* component[diastolic].valueQuantity.system = $UCUM
* component[diastolic].valueQuantity.unit = "millimeter of mercury"

Instance: DeviceHeartRateMonitor
InstanceOf: Device
Usage: #example
Description: "Heart rate monitor device example"
Title: "Heart Rate Monitor Device"
* deviceName.name = "Continuous Heart Rate Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "HRM-2024"
* type = $SCT#720737000 "Pulse rate monitoring device"

Instance: DeviceBloodPressureMonitor
InstanceOf: Device
Usage: #example
Description: "Blood pressure monitor device example"
Title: "Blood Pressure Monitor Device"
* deviceName.name = "Digital Blood Pressure Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "BPM-2024"
* type = $SCT#43770009 "Blood pressure monitor"
