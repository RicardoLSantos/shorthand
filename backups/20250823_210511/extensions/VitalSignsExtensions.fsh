Extension: MeasurementContext
Id: measurement-context
Title: "Measurement Context Extension"
* ^experimental = falseDescription: "Additional context about the vital sign measurement"
* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementContextVS (required)

ValueSet: MeasurementContextVitalSigns
Id: measurement-context-vital-signs
Description: "Value set for measurement context in vital signs observations"Title: "Measurement Context Value Set"
* $SCT#255214003 "At rest"
* $SCT#309604004 "During exercise"
* $SCT#309605003 "Post exercise"
* $SCT#248626006 "During sleep"
