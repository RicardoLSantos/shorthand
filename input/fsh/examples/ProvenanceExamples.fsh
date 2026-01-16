// ====== Provenance Examples for PGHD ======
// Created: 2025-11-27
// Task 7.2: Create Provenance examples (device, transformation)
// MIE 2026 Promise: Section 4.3 Privacy and Security

// ====== Supporting HRV Observation Instance ======
// Referenced by Provenance examples

Instance: HRVObservationExample
InstanceOf: Observation
Usage: #example
Title: "HRV Observation - RMSSD"
Description: "Example HRV observation with RMSSD metric captured by Apple Watch"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs "Vital Signs"
* code = http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* code.text = "Heart Rate Variability - SDNN"
* subject = Reference(PatientExample)
* effectiveDateTime = "2025-01-15T08:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 42.5
* valueQuantity.unit = "ms"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #ms
* device = Reference(AppleWatchDevice)
* component[0].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/heart-rate-variability-cs#hrv-rmssd "HRV RMSSD (Root Mean Square of Successive Differences)"
* component[=].code.text = "Root Mean Square of Successive Differences"
* component[=].valueQuantity.value = 38.2
* component[=].valueQuantity.unit = "ms"
* component[=].valueQuantity.system = "http://unitsofmeasure.org"
* component[=].valueQuantity.code = #ms
* interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#N "Normal"
* note.text = "HRV measurement captured during morning rest period"


// ====== Example 1: Device Capture Provenance ======
// Scenario: Apple Watch captures HRV data automatically

Instance: ProvenanceDeviceCaptureExample
InstanceOf: PGHDProvenance
Usage: #example
Title: "Device Capture Provenance - Apple Watch HRV"
Description: "Example of provenance tracking for HRV data captured by Apple Watch"

* target = Reference(HRVObservationExample)
* recorded = "2025-01-15T08:30:00Z"
* activity = http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle|1.0.0#originate "Originate/Retain Record Lifecycle Event"

// Device agent - Apple Watch that captured the data
* agent[device].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#performer
* agent[device].who = Reference(AppleWatchDevice)
* agent[device].who.display = "Apple Watch Series 9"

// Author agent - Patient who generated the data
* agent[author].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
* agent[author].who = Reference(PatientExample)
* agent[author].who.display = "John Smith"

// Location where data was captured (optional)
* location.display = "Home - Bedroom"

// Entity - the original HRV measurement
* entity.role = #source
* entity.what.display = "Raw PPG signal from Apple Watch optical sensor"


// ====== Example 2: Data Transformation Provenance ======
// Scenario: HealthKit transforms and aggregates HRV data into FHIR format

Instance: ProvenanceTransformationExample
InstanceOf: PGHDProvenance
Usage: #example
Title: "Data Transformation Provenance - HealthKit to FHIR"
Description: "Example of provenance tracking for HRV data transformation from HealthKit to FHIR"

* target = Reference(HRVObservationExample)
* recorded = "2025-01-15T08:35:00Z"
* activity = http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle|1.0.0#transform "Transform/Translate Record Lifecycle Event"

// Assembler agent - HealthKit that transformed the data
* agent[assembler].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#assembler
* agent[assembler].who = Reference(HealthKitDevice)
* agent[assembler].who.display = "Apple HealthKit"

// Device agent - Original capturing device
* agent[device].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#performer
* agent[device].who = Reference(AppleWatchDevice)
* agent[device].who.display = "Apple Watch Series 9"

// Entity - source data that was transformed
* entity.role = #source
* entity.what = Reference(ProvenanceDeviceCaptureExample)
* entity.what.display = "Original device capture provenance"


// ====== Example 3: Data Transmission Provenance ======
// Scenario: FHIR data transmitted from mobile app to healthcare server

Instance: ProvenanceTransmissionExample
InstanceOf: PGHDProvenance
Usage: #example
Title: "Data Transmission Provenance - App to Server"
Description: "Example of provenance tracking for PGHD transmission from mobile app to healthcare system"

* target = Reference(HRVObservationExample)
* recorded = "2025-01-15T09:00:00Z"
* activity = http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle|1.0.0#transmit "Transmit Record Lifecycle Event"

// Assembler agent - Mobile app that transmitted
* agent[assembler].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#assembler
* agent[assembler].who.display = "iOS Lifestyle Medicine App v2.1"

// Author agent - Patient authorizing transmission
* agent[author].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
* agent[author].who = Reference(PatientExample)
* agent[author].who.display = "John Smith"

// Entity - FHIR resource that was transmitted
* entity.role = #source
* entity.what = Reference(HRVObservationExample)

// Signature for data integrity (optional but recommended)
* signature.type = urn:iso-astm:E1762-95:2013#1.2.840.10065.1.12.1.1 "Author's Signature"
* signature.when = "2025-01-15T09:00:00Z"
* signature.who = Reference(PatientExample)


// ====== Supporting Device Instances ======

Instance: AppleWatchDevice
InstanceOf: Device
Usage: #example
Title: "Apple Watch Series 9"
Description: "Consumer wearable device - Apple Watch"

* status = #active
* manufacturer = "Apple Inc."
* deviceName.name = "Apple Watch Series 9"
* deviceName.type = #user-friendly-name
* modelNumber = "A2978"
* serialNumber = "DNPXYZ123456"
* type.text = "Consumer wearable smartwatch with PPG sensor"
* version.value = "watchOS 10.2"
* property[0].type.text = "Sensor Type"
* property[=].valueCode = WearableSensorTypeCS#ppg "Photoplethysmography (PPG)"


Instance: HealthKitDevice
InstanceOf: Device
Usage: #example
Title: "Apple HealthKit"
Description: "Health data aggregation and transformation system"

* status = #active
* manufacturer = "Apple Inc."
* deviceName.name = "Apple HealthKit"
* deviceName.type = #user-friendly-name
* type.text = "Health Data Platform"
* version.value = "iOS 17.2"


// ====== Example 4: Provenance with Device Capture Metadata Extension ======
// Scenario: Detailed capture information for research-grade HRV

Instance: ProvenanceDetailedCaptureExample
InstanceOf: PGHDProvenance
Usage: #example
Title: "Detailed Capture Provenance with Metadata"
Description: "Example showing device capture metadata extension for research-grade PGHD"

* target = Reference(HRVObservationExample)
* recorded = "2025-01-15T08:30:00Z"
* activity = http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle|1.0.0#originate "Originate/Retain Record Lifecycle Event"

// Device agent with metadata extension
* agent[device].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#performer
* agent[device].who = Reference(AppleWatchDevice)
* agent[device].extension[DeviceCaptureMetadata].extension[samplingRate].valueQuantity.value = 50
* agent[device].extension[DeviceCaptureMetadata].extension[samplingRate].valueQuantity.unit = "Hz"
* agent[device].extension[DeviceCaptureMetadata].extension[samplingRate].valueQuantity.system = "http://unitsofmeasure.org"
* agent[device].extension[DeviceCaptureMetadata].extension[samplingRate].valueQuantity.code = #Hz
* agent[device].extension[DeviceCaptureMetadata].extension[sensorType].valueCodeableConcept = WearableSensorTypeCS#ppg "Photoplethysmography (PPG)"
* agent[device].extension[DeviceCaptureMetadata].extension[captureMethod].valueCodeableConcept = DataCaptureMethodCS#automatic "Automatic"

// Author agent
* agent[author].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
* agent[author].who = Reference(PatientExample)

// Entity tracking
* entity.role = #source
* entity.what.display = "Raw PPG signal - 5 minute recording at 50Hz"
