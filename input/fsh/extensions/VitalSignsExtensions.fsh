Extension: MeasurementContext
Id: measurement-context
Title: "Measurement Context Extension"
Description: "Additional context about the vital sign measurement"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementContextVS (extensible)

ValueSet: MeasurementContextVitalSigns
Id: measurement-context-vital-signs
Title: "Measurement Context Value Set"
Description: "Value set for measurement context in vital signs observations"
* ^name = "MeasurementContextVitalSigns"
* ^experimental = false
* $SCT#255214003 "At rest"
* $SCT#309604004 "During exercise"
* $SCT#309605003 "Post exercise"
* $SCT#410534003 "During exercise"
