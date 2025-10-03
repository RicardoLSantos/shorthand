Instance: NoiseExposureExample
InstanceOf: NoiseExposureObservation
Usage: #example
Description: "Noise exposure observation example"
Title: "Noise Exposure Measurement Example"

* meta.security = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N
* status = #final
* performer = Reference(Practitioner/PractitionerExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $LIFESTYLEOBS#noise-duration "Environmental noise exposure duration"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(Device/iphone-example)
* method = http://snomed.info/sct#258104002 "Measured"

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
* performer = Reference(Practitioner/PractitionerExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* code = $LIFESTYLEOBS#uv-duration "UV exposure duration"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T12:00:00Z"
* device = Reference(Device/iphone-example)
* method = http://snomed.info/sct#258104002 "Measured"

* component[index]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-index "UV index"
  * valueQuantity = 8 '1' "index"
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

Instance: EnvironmentalObservationExample
InstanceOf: EnvironmentalObservation
Usage: #example
Description: "Generic environmental observation example"
Title: "Environmental Observation Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T14:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/EnvironmentalDeviceExample)
* code = $SCT#31032004 "Body position finding"
* valueCodeableConcept = $SCT#33586001 "Sitting position"
* note.text = "Environmental context observation"

Instance: EnvironmentalDeviceExample
InstanceOf: Device
Usage: #example
Description: "Environmental monitoring device example"
Title: "Environmental Monitoring Device"

* identifier.system = "urn:oid:2.16.840.1.113883.3.4.5.4"
* identifier.value = "iPhone-ENV-001"
* manufacturer = "Apple Inc."
* modelNumber = "iPhone 15 Pro"
* type = $LIFESTYLEOBS#environmental-sensor "Environmental sensor device"
* status = #active
