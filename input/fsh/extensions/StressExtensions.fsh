Extension: StressTriggers
Id: stress-triggers
Title: "Stress Triggers Extension"
Description: "Extension for recording identified stress triggers"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from StressTriggersVS (required)

Extension: StressCoping
Id: stress-coping
Title: "Stress Coping Extension"
Description: "Extension for recording stress coping mechanisms"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from StressCopingVS (required)

ValueSet: StressTriggersVS
Id: stress-triggers-vs
Title: "Stress Triggers Value Set"
Description: "Value set for common stress triggers"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS

ValueSet: StressCopingVS
Id: stress-coping-vs
Title: "Stress Coping Value Set"
Description: "Value set for stress coping mechanisms"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS
