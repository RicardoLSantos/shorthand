// ====== Perfil de Provenance para PGHD ======
// Criado: 2025-11-25
// MIE 2026 Promise: Section 4.3 Privacy and Security
//
// Bibliographic References:
// - HL7 FHIR Provenance Resource: https://hl7.org/fhir/R4/provenance.html
// - ISO 21089:2018 Health informatics - Trusted end-to-end information flows
//   https://www.iso.org/standard/69898.html
// - W3C PROV-DM: The PROV Data Model (https://www.w3.org/TR/prov-dm/)
// - Bayoumy2021Wearables: Smart wearable devices in cardiovascular care (Nature Reviews Cardiology)
//   DOI: 10.1038/s41569-021-00522-7
//
// FHIR Terminology References:
// - http://terminology.hl7.org/CodeSystem/provenance-participant-type
// - http://terminology.hl7.org/CodeSystem/v3-DataOperation
// - http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle

Profile: PGHDProvenance
Parent: Provenance
Id: pghd-provenance
Title: "Patient-Generated Health Data Provenance"
Description: "Provenance profile for tracking the origin and transformation history of PGHD from wearable devices"

// Required elements for audit trail
* target 1..* MS
* recorded 1..1 MS
* activity 1..1 MS

// Agent tracking - who/what was involved
* agent 1..* MS
* agent ^slicing.discriminator.type = #pattern
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #open

* agent contains
    device 0..1 MS and
    assembler 0..1 MS and
    author 0..1 MS

// Device that captured the data (e.g., Apple Watch, Fitbit)
* agent[device].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#performer
* agent[device].who only Reference(Device)
* agent[device].who 1..1 MS

// Software/system that assembled/transformed the data (e.g., HealthKit, FHIR server)
* agent[assembler].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#assembler
* agent[assembler].who only Reference(Device or Organization)
* agent[assembler].who 1..1 MS

// Patient/author who generated the data
* agent[author].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
* agent[author].who only Reference(Patient or Practitioner or RelatedPerson)
* agent[author].who 1..1 MS

// Entity tracking - what was transformed/derived
* entity MS
* entity.role MS
* entity.what MS

// Location where data was captured (optional, for environmental context)
* location MS

// Signature for data integrity verification
* signature MS
* signature.type MS
* signature.when MS
* signature.who MS
* signature.data MS

// Activity codes for PGHD workflow
* activity from PGHDProvenanceActivityVS (extensible)


// ====== ValueSet para Activity ======

ValueSet: PGHDProvenanceActivityVS
Id: pghd-provenance-activity-vs
Title: "PGHD Provenance Activity ValueSet"
Description: "Activities related to PGHD data capture and transformation"
* ^experimental = false
* http://terminology.hl7.org/CodeSystem/v3-DataOperation#CREATE "Create"
* http://terminology.hl7.org/CodeSystem/v3-DataOperation#UPDATE "Update"
* http://terminology.hl7.org/CodeSystem/v3-DataOperation#APPEND "Append"
* http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle#originate "Originate/Retain Record Lifecycle Event"
* http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle#transform "Transform/Translate Record Lifecycle Event"
* http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle#transmit "Transmit Record Lifecycle Event"
* http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle#receive "Receive/Retain Record Lifecycle Event"


// ====== Extension para Device Metadata ======

Extension: DeviceCaptureMetadata
Id: device-capture-metadata
Title: "Device Capture Metadata"
Description: "Additional metadata about how data was captured by the device"
Context: Provenance.agent

* extension contains
    samplingRate 0..1 MS and
    sensorType 0..1 MS and
    captureMethod 0..1 MS

* extension[samplingRate].value[x] only Quantity
* extension[samplingRate].valueQuantity.system = "http://unitsofmeasure.org"
* extension[samplingRate].valueQuantity.code = #Hz

* extension[sensorType].value[x] only CodeableConcept
* extension[sensorType].valueCodeableConcept from WearableSensorTypeVS (extensible)

* extension[captureMethod].value[x] only CodeableConcept
* extension[captureMethod].valueCodeableConcept from DataCaptureMethodVS (extensible)


// ====== ValueSets para Extensions ======

ValueSet: WearableSensorTypeVS
Id: wearable-sensor-type-vs
Title: "Wearable Sensor Type ValueSet"
Description: "Types of sensors in consumer wearable devices"
* ^experimental = false
* include codes from system WearableSensorTypeCS

CodeSystem: WearableSensorTypeCS
Id: wearable-sensor-type-cs
Title: "Wearable Sensor Type CodeSystem"
Description: "Sensor types found in consumer wearable devices"
* ^experimental = false
* ^caseSensitive = true
* #ppg "Photoplethysmography (PPG)" "Optical heart rate sensor"
* #ecg "Electrocardiogram (ECG)" "Electrical heart activity sensor"
* #accelerometer "Accelerometer" "Motion and activity sensor"
* #gyroscope "Gyroscope" "Orientation sensor"
* #barometer "Barometer" "Altitude/pressure sensor"
* #spo2 "Pulse Oximeter" "Blood oxygen saturation sensor"
* #temperature "Temperature" "Skin/body temperature sensor"
* #bioimpedance "Bioimpedance" "Body composition sensor"
* #gps "GPS" "Location sensor"


ValueSet: DataCaptureMethodVS
Id: data-capture-method-vs
Title: "Data Capture Method ValueSet"
Description: "Methods by which PGHD data was captured"
* ^experimental = false
* include codes from system DataCaptureMethodCS

CodeSystem: DataCaptureMethodCS
Id: data-capture-method-cs
Title: "Data Capture Method CodeSystem"
Description: "Methods for capturing patient-generated health data"
* ^experimental = false
* ^caseSensitive = true
* #automatic "Automatic" "Data captured automatically by device"
* #manual-entry "Manual Entry" "Data manually entered by user"
* #derived "Derived" "Data calculated/derived from other measurements"
* #synchronized "Synchronized" "Data synchronized from another system"
* #imported "Imported" "Data imported from external source"
