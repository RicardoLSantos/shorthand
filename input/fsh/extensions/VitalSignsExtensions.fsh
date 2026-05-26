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
// T2 S33 VRF-TERM-018: 255214003 was mislabeled "At rest" (it is "After exercise") → 263678003 "At rest"; 309605003 "Post exercise" was "menopause periods" → 255214003 "After exercise"; removed 410534003 (was "Not indicated", duplicate label of 309604004 "During exercise").
* $SCT#263678003 "At rest"
* $SCT#309604004 "During exercise"
* $SCT#255214003 "After exercise"
