// Originally defined on lines 1 - 7
Extension: MeasurementContext
Parent: Extension
Id: measurement-context
Title: "Measurement Context Extension"
Description: "Additional context about the vital sign measurement"
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementContextVS (required)
* extension 0..0

// Originally defined on lines 9 - 15
ValueSet: MeasurementContextVitalSigns
Id: measurement-context-vital-signs
Title: "Measurement Context Value Set"
Description: "Value set for measurement context in vital signs observations"
* http://snomed.info/sct#255214003 "At rest"
* http://snomed.info/sct#309604004 "During exercise"
* http://snomed.info/sct#309605003 "Post exercise"
* http://snomed.info/sct#410534003 "During exercise"

