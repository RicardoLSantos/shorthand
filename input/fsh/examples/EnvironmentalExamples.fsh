Instance: NoiseExposureExample
InstanceOf: NoiseExposureObservation
Usage: #example
Description: "Noise exposure observation example"
Title: "Noise Exposure Measurement Example"

* meta.security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N
* status = #final
* performer = Reference(Practitioner/PractitionerExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $LOINC#28573-7 "Noise exposure time"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(Device/iphone-example)
* method = http://snomed.info/sct#37016008 "Automatic measurement"

* component[level]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-avg "Environmental noise average level"
  * valueQuantity = 85 'dB'
  * interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"

* component[duration]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-duration "Environmental noise exposure duration"
  * valueQuantity = 120 'min'

* component[peakLevel]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-peak "Peak environmental sound level"
  * valueQuantity = 95 'dB'

* component[backgroundNoise]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-background "Background environmental noise level"
  * valueQuantity = 45 'dB'

* note.text = "Measurement taken during urban commute"

Instance: UVExposureExample
InstanceOf: UVExposureObservation
Usage: #example
Description: "UV exposure observation example"
Title: "UV Exposure Measurement Example"

* meta.security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $LOINC#28574-5 "UV exposure"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T12:00:00Z"
* device = Reference(Device/iphone-example)
* method = http://snomed.info/sct#37016008 "Automatic measurement"

* component[index]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-index "UV index"
  * valueQuantity = 8 '{index}'
  * interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation#H "High"

* component[duration]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-duration "UV exposure duration"
  * valueQuantity = 45 'min'

* component[timeOfDay]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#exposure-time "Time of environmental exposure"
  * valueDateTime = "2024-03-19T12:00:00Z"

* component[intensity]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-intensity "UV intensity"
  * valueQuantity = 0.3 'W/m2'

* note.text = "Measurement taken during outdoor activity"

Instance: EnvironmentalDeviceExample
InstanceOf: Device
Usage: #example
Description: "Environmental monitoring device example"
Title: "Environmental Monitoring Device"

* identifier.system = "https://2rdoc.pt/ig/ios-lifestyle-medicine/devices"
* identifier.value = "iPhone-ENV-001"
* manufacturer = "Apple Inc."
* modelNumber = "iPhone 15 Pro"
* type = $SCT#462242008 "Monitor"
* status = #active
