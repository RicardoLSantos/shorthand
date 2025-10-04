// Originally defined on lines 1 - 34
Instance: NoiseExposureExample
InstanceOf: NoiseExposureObservation
Title: "Noise Exposure Measurement Example"
Description: "Noise exposure observation example"
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N
* status = #final
* performer = Reference(Practitioner/PractitionerExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#environment
* code = http://loinc.org#28573-7 "Noise exposure time"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(Device/iphone-example)
* method = http://snomed.info/sct#37016008 "Automatic measurement"
* component[level]
* component[level].code.coding[0] = http://loinc.org#89020-2 "Environmental noise average"
* component[level].valueQuantity = 85 'dB'
* component[level].interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"
* component[duration]
* component[duration].code.coding[0] = http://loinc.org#89021-0 "Environmental noise duration"
* component[duration].valueQuantity = 120 'min'
* component[peakLevel]
* component[peakLevel].code.coding[0] = http://loinc.org#89024-4 "Peak sound level"
* component[peakLevel].valueQuantity = 95 'dB'
* component[backgroundNoise]
* component[backgroundNoise].code.coding[0] = http://loinc.org#89025-1 "Background noise level"
* component[backgroundNoise].valueQuantity = 45 'dB'
* note.text = "Measurement taken during urban commute"

// Originally defined on lines 36 - 68
Instance: UVExposureExample
InstanceOf: UVExposureObservation
Title: "UV Exposure Measurement Example"
Description: "UV exposure observation example"
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#environment
* code = http://loinc.org#28574-5 "UV exposure"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T12:00:00Z"
* device = Reference(Device/iphone-example)
* method = http://snomed.info/sct#37016008 "Automatic measurement"
* component[index]
* component[index].code.coding[0] = http://loinc.org#89022-8 "UV index"
* component[index].valueQuantity = 8 '{index}'
* component[index].interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"
* component[duration]
* component[duration].code.coding[0] = http://loinc.org#89023-6 "UV exposure duration"
* component[duration].valueQuantity = 45 'min'
* component[timeOfDay]
* component[timeOfDay].code.coding[0] = http://loinc.org#89026-9 "Time of exposure"
* component[timeOfDay].valueDateTime = "2024-03-19T12:00:00Z"
* component[intensity]
* component[intensity].code.coding[0] = http://loinc.org#89027-7 "UV intensity"
* component[intensity].valueQuantity = 0.3 'W/m2'
* note.text = "Measurement taken during outdoor activity"

// Originally defined on lines 70 - 81
Instance: EnvironmentalDeviceExample
InstanceOf: Device
Title: "Environmental Monitoring Device"
Description: "Environmental monitoring device example"
Usage: #example
* identifier.system = "https://2rdoc.pt/ig/ios-lifestyle-medicine/devices"
* identifier.value = "iPhone-ENV-001"
* manufacturer = "Apple Inc."
* modelNumber = "iPhone 15 Pro"
* type = http://snomed.info/sct#706689003 "Environmental monitoring device"
* status = #active

