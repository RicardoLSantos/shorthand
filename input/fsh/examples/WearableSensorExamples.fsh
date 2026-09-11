// Sensor devices (hardware) behind two of the wearable data sources, typed with IEEE 11073-10101 (MDC)
// device specialisations from the Personal Health Device IG (codes verified 2026-09-11 on tx.fhir.org, MDC 2024-12-05).

Alias: $MDC = urn:iso:std:iso:11073:10101

Instance: SensorPulseOximeterAppleWatch
InstanceOf: WearableSensorDevice
Usage: #example
Title: "Pulse oximeter sensor (Apple Watch Series 9)"
Description: "The optical pulse-oximetry sensor of an Apple Watch Series 9, the hardware behind the DeviceAppleWatch data source"
* type = $MDC#528388 "MDC_DEV_SPEC_PROFILE_PULS_OXIM"
* manufacturer = "Apple Inc."
* modelNumber = "Apple Watch Series 9"
* deviceName.name = "Apple Watch Series 9 optical sensor"
* deviceName.type = #user-friendly-name
* status = #active

Instance: SensorStepCounterGarminVenu
InstanceOf: WearableSensorDevice
Usage: #example
Title: "Step counter sensor (Garmin Venu 3)"
Description: "The accelerometer-based step counter of a Garmin Venu 3, the hardware behind the DeviceGarminVenu data source"
* type = $MDC#528484 "MDC_DEV_SUB_SPEC_PROFILE_STEP_COUNTER"
* manufacturer = "Garmin Ltd."
* modelNumber = "Garmin Venu 3"
* deviceName.name = "Garmin Venu 3 step counter"
* deviceName.type = #user-friendly-name
* status = #active
