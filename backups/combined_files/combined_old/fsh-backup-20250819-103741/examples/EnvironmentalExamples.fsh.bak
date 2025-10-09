Instance: NoiseExposureExample
InstanceOf: NoiseExposureObservation
Usage: #example
Title: "Noise Exposure Measurement Example"
Description: "Example of noise exposure measurement from iOS Health App"

* meta.security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#environment
* code = $LOINC#28573-7 "Noise exposure time"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(Device/iphone-example)
* method = http://snomed.info/sct#37016008 "Automatic measurement"

* component[level]
  * code.coding[0] = $LOINC#89020-2 "Environmental noise average"
  * valueQuantity = 85 'dB'
  * interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"

* component[duration]
  * code.coding[0] = $LOINC#89021-0 "Environmental noise duration"
  * valueQuantity = 120 'min'

* component[peakLevel]
  * code.coding[0] = $LOINC#89024-4 "Peak sound level"
  * valueQuantity = 95 'dB'

* component[backgroundNoise]
  * code.coding[0] = $LOINC#89025-1 "Background noise level"
  * valueQuantity = 45 'dB'

* note.text = "Measurement taken during urban commute"

Instance: UVExposureExample
InstanceOf: UVExposureObservation
Usage: #example
Title: "UV Exposure Measurement Example"
Description: "Example of UV exposure measurement from iOS Health App"

* meta.security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#environment
* code = $LOINC#28574-5 "UV exposure"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T12:00:00Z"
* device = Reference(Device/iphone-example)
* method = http://snomed.info/sct#37016008 "Automatic measurement"

* component[index]
  * code.coding[0] = $LOINC#89022-8 "UV index"
  * valueQuantity = 8 '{index}'
  * interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"

* component[duration]
  * code.coding[0] = $LOINC#89023-6 "UV exposure duration"
  * valueQuantity = 45 'min'

* component[timeOfDay]
  * code.coding[0] = $LOINC#89026-9 "Time of exposure"
  * valueDateTime = "2024-03-19T12:00:00Z"

* component[intensity]
  * code.coding[0] = $LOINC#89027-7 "UV intensity"
  * valueQuantity = 0.3 'W/m2'

* note.text = "Measurement taken during outdoor activity"

Instance: EnvironmentalDeviceExample
InstanceOf: Device
Usage: #example
Title: "Environmental Monitoring Device"
Description: "Example of iOS device used for environmental monitoring"

* identifier.system = "http://example.org/devices"
* identifier.value = "iPhone-ENV-001"
* manufacturer = "Apple Inc."
* modelNumber = "iPhone 15 Pro"
* type = $SCT#706689003 "Environmental monitoring device"
* status = #active
