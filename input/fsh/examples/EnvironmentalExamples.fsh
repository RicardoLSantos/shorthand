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
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#noise-avg "Environmental noise average level"
  * valueQuantity = 85 'dB'
  * interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#H "High"

* component[duration]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#noise-duration "Environmental noise exposure duration"
  * valueQuantity = 120 'min'

* component[peakLevel]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#noise-peak "Peak environmental sound level"
  * valueQuantity = 95 'dB'

* component[backgroundNoise]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#noise-background "Background environmental noise level"
  * valueQuantity = 45 'dB'

* extension[environmental-context].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#environment-urban "Urban"
* extension[exposure-location].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#transit "In transit"
* extension[exposure-conditions].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#exposure-conditions-normal "Normal conditions"

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
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#uv-index "UV index"
  * valueQuantity = 8 '1' "index"
  * interpretation = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0#H "High"

* component[duration]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#uv-duration "UV exposure duration"
  * valueQuantity = 45 'min'

* component[timeOfDay]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#exposure-time "Time of environmental exposure"
  * valueDateTime = "2024-03-19T12:00:00Z"

* component[intensity]
  * code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#uv-intensity "UV intensity"
  * valueQuantity = 0.3 'W/m2'

* extension[environmental-context].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#environment-outdoor "Outdoor"
* extension[exposure-location].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#exposure-location-recreational "Recreational area"
* extension[exposure-conditions].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#exposure-conditions-normal "Normal conditions"

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
* code = $LOINC#60832-3 "Room temperature"
* valueQuantity = 22 'Cel' "degrees Celsius"
* extension[environmental-context].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#environment-indoor "Indoor"
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


// ============================================================================
// Environmental Audio Exposure Example (iOS 13+)
// ============================================================================

Instance: EnvironmentalAudioExposureExample
InstanceOf: EnvironmentalAudioExposureObservation
Usage: #example
Title: "Environmental Audio Exposure Measurement"
Description: "Example of environmental audio exposure from iPhone microphone (iOS 13+ HKQuantityTypeIdentifier.environmentalAudioExposure)"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-27T12:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/iphone-example)

* valueQuantity = 78 'dB'
* valueQuantity.unit = "dB(A)"

* component[duration].code = $LIFESTYLEOBS#noise-duration "Environmental noise exposure duration"
* component[duration].valueQuantity = 45 'min'

* component[peakLevel].code = $LIFESTYLEOBS#noise-peak "Peak environmental sound level"
* component[peakLevel].valueQuantity = 92 'dB'

* extension[environmental-context].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#environment-urban "Urban"
* note.text = "Environmental audio exposure during lunch break in urban restaurant. WHO recommends <70 dB average over 24h."


// ============================================================================
// Headphone Audio Exposure Example (iOS 14+)
// ============================================================================

Instance: HeadphoneAudioExposureExample
InstanceOf: HeadphoneAudioExposureObservation
Usage: #example
Title: "Headphone Audio Exposure Measurement"
Description: "Example of headphone audio exposure from AirPods (iOS 14+ HKQuantityTypeIdentifier.headphoneAudioExposure)"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-27T16:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* device = Reference(Device/iphone-example)

* valueQuantity = 72 'dB'
* valueQuantity.unit = "dB(A)"

* component[duration].code = $LIFESTYLEOBS#noise-duration "Environmental noise exposure duration"
* component[duration].valueQuantity = 90 'min'

* component[sevenDayAverage].code = $LIFESTYLEOBS#noise-avg "Environmental noise average level"
* component[sevenDayAverage].valueQuantity = 68 'dB'

* extension[environmental-context].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#environment-indoor "Indoor"
* note.text = "Headphone audio exposure during work. 7-day average 68 dB is within WHO safe limits (<80 dB for 40h/week). Apple notifies at 80 dB sustained."
