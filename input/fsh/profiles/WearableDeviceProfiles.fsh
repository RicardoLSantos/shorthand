// Wearable device profiles: the software is the first-class device, the sensor is optional context.
//
// What produces the observations in this IG is an application (a health platform or the ETL app);
// different watches, rings and oximeters feed the same application, so the Device that Observation.device
// points to is the software, typed SNOMED CT 706689003 "Application programme software". When the physical
// sensor is known, it is a second Device typed with the IEEE 11073-10101 (MDC) device specialisations
// carried by the Personal Health Device IG, and linked from the software Device through Device.parent.

Alias: $SCT = http://snomed.info/sct
Alias: $MDCTypes = http://hl7.org/fhir/uv/phd/ValueSet/DeviceTypes11073MDC

Profile: WearableDataSource
Parent: Device
Id: wearable-data-source
Title: "Wearable Data Source (application)"
Description: "The application that produced wearable observations (a health platform such as HealthKit, a vendor app, or the ETL application), which is the Device that Observation.device references. The type is fixed to SNOMED CT 706689003 Application programme software; deviceName, version (application version) and manufacturer identify the software; the physical sensor, when known, is a WearableSensorDevice referenced through parent."

* type 1..1 MS
* type = $SCT#706689003 "Application programme software"
* type ^short = "Fixed: the data source is software"
* deviceName 1..* MS
* deviceName ^short = "Name of the application or platform"
* version 0..* MS
* version ^short = "Application or platform version"
* manufacturer 0..1 MS
* manufacturer ^short = "Publisher of the application"
* status 0..1 MS
* parent 0..1 MS
* parent only Reference(WearableSensorDevice)
* parent ^short = "The physical sensor device the application read from, when known"
* note 0..* MS

Profile: WearableSensorDevice
Parent: Device
Id: wearable-sensor-device
Title: "Wearable Sensor Device (hardware)"
Description: "The physical sensor device behind a wearable data source: watch, ring, chest strap, oximeter, scale. The type is drawn from the IEEE 11073-10101 (MDC) device specialisations of the Personal Health Device IG (extensible), for example 528388 pulse oximeter or 528484 step counter; manufacturer, model and serial number identify the hardware."

* type 1..1 MS
* type from $MDCTypes (extensible)
* type ^short = "IEEE 11073-10101 (MDC) device specialisation, when one applies"
* manufacturer 0..1 MS
* modelNumber 0..1 MS
* serialNumber 0..1 MS
* version 0..* MS
* version ^short = "Firmware version"
* status 0..1 MS
