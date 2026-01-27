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
// Extensions
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/measurement-context"
* extension[=].valueCodeableConcept = $SCT#307818003 "Weight monitoring"

Instance: DeviceHeartRateMonitor
InstanceOf: Device
Usage: #example
Description: "Heart rate monitor device example"
Title: "Heart Rate Monitor Device"
* deviceName.name = "Continuous Heart Rate Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "HRM-2024"
* type = $SCT#364075005 "Heart rate"

Instance: OxygenSaturationExample
InstanceOf: OxygenSaturationObservation
Usage: #example
Description: "Oxygen saturation observation example"
Title: "Oxygen Saturation Measurement Example"
* status = #final
* code = $LOINC#2708-6 "Oxygen saturation in Arterial blood"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* valueQuantity = 98 '%' "percent"
* valueQuantity.system = $UCUM
* valueQuantity.unit = "percent"
* device = Reference(DevicePulseOximeter)
* performer = Reference(PractitionerExample)
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"

Instance: DevicePulseOximeter
InstanceOf: Device
Usage: #example
Description: "Pulse oximeter device example"
Title: "Pulse Oximeter Device"
* deviceName.name = "Digital Pulse Oximeter"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "POX-2024"
* type = $SCT#448703006 "Pulse oximeter"

Instance: DeviceBloodPressureMonitor
InstanceOf: Device
Usage: #example
Description: "Blood pressure monitor device example"
Title: "Blood Pressure Monitor Device"
* deviceName.name = "Digital Blood Pressure Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "BPM-2024"
* type = $SCT#258057004 "Non-invasive blood pressure monitor"

Instance: AdvancedVitalSignsExample
InstanceOf: AdvancedVitalSigns
Usage: #example
Description: "Advanced vital signs observation with multiple components"
Title: "Advanced Vital Signs Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/DeviceHeartRateMonitor)
* code = $LOINC#8716-3 "Vital signs note"
* component[hrvSpectral].valueQuantity = 42 'ms' "millisecond"
* component[meanArterialPressure].valueQuantity = 93 'mm[Hg]' "millimeter of mercury"
* component[autonomicBalance].valueQuantity = 1.2 '1' "ratio"
* note.text = "Comprehensive cardiovascular assessment during routine checkup"

// Extensions
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/measurement-quality"
* extension[=].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/measurement-quality-cs#excellent "Excellent Quality"
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/advanced-vital-signs-context"
* extension[=].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/advanced-vital-signs-context-cs#resting "Resting state"

Instance: LifestyleVitalSignsExample
InstanceOf: LifestyleVitalSigns
Usage: #example
Description: "Lifestyle vital signs observation example"
Title: "Lifestyle Vital Signs Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T10:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* code = $LOINC#8867-4 "Heart rate"
* valueQuantity = 72 '/min' "per minute"
* valueQuantity.system = $UCUM
* device = Reference(Device/iphone-example)
* note.text = "Morning vital signs check via Health app"


// Body Temperature Examples - Added 2026-01-20
Instance: BodyTemperatureExample
InstanceOf: BodyTemperatureObservation
Usage: #example
Description: "Body temperature measurement from wearable device"
Title: "Body Temperature Normal Example"
* status = #final
* code = $LOINC#8310-5 "Body temperature"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T07:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)
* valueQuantity = 36.6 'Cel' "degree Celsius"
* valueQuantity.system = $UCUM
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#N "Normal"
* note.text = "Morning body temperature within normal range (36.1-37.2°C)"


Instance: BodyTemperatureFeverExample
InstanceOf: BodyTemperatureObservation
Usage: #example
Description: "Elevated body temperature indicating fever"
Title: "Body Temperature Fever Example"
* status = #final
* code = $LOINC#8310-5 "Body temperature"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T14:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)
* valueQuantity = 38.5 'Cel' "degree Celsius"
* valueQuantity.system = $UCUM
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"
* note.text = "Elevated temperature >38°C (100.4°F) indicates fever. Consider clinical evaluation."


// Respiratory Rate Examples - Added 2026-01-20
Instance: RespiratoryRateExample
InstanceOf: RespiratoryRateObservation
Usage: #example
Description: "Respiratory rate measurement from wearable device"
Title: "Respiratory Rate Normal Example"
* status = #final
* code = $LOINC#9279-1 "Respiratory rate"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T08:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)
* valueQuantity = 14 '/min' "breaths per minute"
* valueQuantity.system = $UCUM
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#N "Normal"
* note.text = "Resting respiratory rate within normal adult range (12-20/min)"


Instance: RespiratoryRateSleepExample
InstanceOf: RespiratoryRateObservation
Usage: #example
Description: "Respiratory rate during sleep from wearable device"
Title: "Respiratory Rate Sleep Example"
* status = #final
* code = $LOINC#9279-1 "Respiratory rate"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-20T03:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)
* valueQuantity = 12 '/min' "breaths per minute"
* valueQuantity.system = $UCUM
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#N "Normal"
// Note: Component removed to comply with FHIR obs-7 constraint (code cannot be same as Observation.code when value is present)
// The sleep context is indicated by effectiveDateTime (03:00 AM) and the note
* note.text = "Average respiratory rate during deep sleep. Lower than awake rate (10-16/min normal during sleep)."


// =============================================================================
// Advanced Vital Signs with Homeostasis Index Extension
// =============================================================================

Instance: AdvancedVitalsWithHomeostasisExample
InstanceOf: AdvancedVitalSigns
Usage: #example
Title: "Advanced Vital Signs with Homeostasis Index"
Description: "Example of advanced vital signs observation using the homeostasis-index extension to capture physiological balance"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* code = $LOINC#8867-4 "Heart rate"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-27T06:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/AppleWatchDevice)
* valueQuantity = 58 '/min' "per minute"
* valueQuantity.system = $UCUM

// Homeostasis Index extension - normalized physiological balance (0-1)
* extension[0].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/homeostasis-index"
* extension[0].valueQuantity = 0.82 '1'
* extension[0].valueQuantity.unit = "index"

* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#N "Normal"
* note.text = "Resting heart rate 58 bpm with high homeostasis index (0.82). Indicates good physiological balance and autonomic regulation."
