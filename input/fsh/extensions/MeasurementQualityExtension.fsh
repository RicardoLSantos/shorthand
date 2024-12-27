Extension: MeasurementQuality
Id: measurement-quality
Title: "Measurement Quality Extension"
Description: "Indicator of the quality and reliability of measurement data"

* ^version = "0.1.0"
* ^status = #draft
* ^contact.name = "System Administrator"
* ^context[0].type = #element
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementQualityVS (required)
