Instance: HeartRateExample
InstanceOf: HeartRateObservation
Usage: #example
Title: "Heart Rate Measurement Example"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#8867-4 "Heart rate [Beats/minute]"
* subject = Reference(PatientExample)
* performer = Reference(DeviceHeartRateMonitor)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 72 '/min' "per minute"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "per minute"
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity = 45 'ms' "millisecond"
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.unit = "millisecond"

Instance: BloodPressureExample
InstanceOf: BloodPressureObservation
Usage: #example
Title: "Blood Pressure Measurement Example"
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#85354-9 "Blood pressure panel with all children optional"
* subject = Reference(PatientExample)
* performer = Reference(DeviceBloodPressureMonitor)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* component[systolic].code = $LOINC#8480-6 "Systolic blood pressure [mm[Hg]]"
* component[systolic].valueQuantity = 120 'mm[Hg]' "millimeter of mercury"
* component[systolic].valueQuantity.system = $UCUM
* component[systolic].valueQuantity.unit = "millimeter of mercury"
* component[diastolic].code = $LOINC#8462-4 "Diastolic blood pressure [mm[Hg]]"
* component[diastolic].valueQuantity = 80 'mm[Hg]' "millimeter of mercury"
* component[diastolic].valueQuantity.system = $UCUM
* component[diastolic].valueQuantity.unit = "millimeter of mercury"

Instance: DeviceHeartRateMonitor
InstanceOf: Device
Usage: #example
Title: "Heart Rate Monitor Device"
* deviceName.name = "Continuous Heart Rate Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "HRM-2024"
* type = $SCT#720737000 "Pulse rate monitoring device (physical object)"

Instance: DeviceBloodPressureMonitor
InstanceOf: Device
Usage: #example
Title: "Blood Pressure Monitor Device"
* deviceName.name = "Digital Blood Pressure Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "BPM-2024"
* type = $SCT#43770009 "Blood pressure recording monitoring device (physical object)"
