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
* valueCodeableConcept from http://example.org/fhir/ValueSet/measurement-quality (required)

ValueSet: MeasurementQualityVS
Id: measurement-quality-vs
Title: "Measurement Quality Value Set"
Description: "Quality indicators for measurements"

* ^experimental = true
* codes from system MeasurementQualityCS

CodeSystem: MeasurementQualityCS
Id: measurement-quality-cs
Title: "Measurement Quality Code System"
Description: "Code system for measurement quality indicators"

* ^experimental = true
* ^caseSensitive = true

* #excellent "Excellent Quality" "High quality measurement with minimal noise"
* #good "Good Quality" "Good quality measurement with acceptable noise"
* #fair "Fair Quality" "Fair quality measurement with some interference"
* #poor "Poor Quality" "Poor quality measurement with significant interference"
* #unreliable "Unreliable" "Unreliable measurement requiring verification"

Instance: ExampleMeasurementQuality
InstanceOf: Observation
Usage: #example
Title: "Example Measurement Quality"
Description: "Example showing use of measurement quality extension"

* status = #final
* code = $LOINC#8310-5 "Body temperature"
* effectiveDateTime = "2024-03-19"
* extension[measurement-quality].url = "http://example.org/fhir/StructureDefinition/measurement-quality"
* extension[measurement-quality].valueCodeableConcept = MeasurementQualityCS#good "Good Quality"
