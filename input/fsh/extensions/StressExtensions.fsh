Extension: StressTriggers
Id: stress-triggers
Title: "Stress Triggers Extension"
Description: "Extension for recording identified stress triggers"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from StressTriggersVS (extensible)

Extension: StressCoping
Id: stress-coping
Title: "Stress Coping Extension"
Description: "Extension for recording stress coping mechanisms"
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from StressCopingVS (extensible)

ValueSet: StressTriggersVS
Id: stress-triggers-vs
Title: "Stress Triggers Value Set"
Description: "Value set for common stress triggers"
* ^experimental = false
* LifestyleMedicineTemporaryCS#stress-triggers-work "Work-related"
* LifestyleMedicineTemporaryCS#financial "Financial"
* LifestyleMedicineTemporaryCS#relationships "Relationships"
* LifestyleMedicineTemporaryCS#health "Health"
* LifestyleMedicineTemporaryCS#stress-triggers-environment "Environmental"
* LifestyleMedicineTemporaryCS#time "Time Management"
* LifestyleMedicineTemporaryCS#stress-triggers-change "Life Changes"

ValueSet: StressCopingVS
Id: stress-coping-vs
Title: "Stress Coping Value Set"
Description: "Value set for stress coping mechanisms"
* ^experimental = false
* LifestyleMedicineTemporaryCS#stress-coping-exercise "Physical Exercise"
* LifestyleMedicineTemporaryCS#stress-coping-meditation "Meditation"
* LifestyleMedicineTemporaryCS#stress-coping-social "Social Support"
* LifestyleMedicineTemporaryCS#stress-coping-professional "Professional Help"
* LifestyleMedicineTemporaryCS#relaxation "Relaxation"
* LifestyleMedicineTemporaryCS#creative "Creative Activities"
* LifestyleMedicineTemporaryCS#nature "Nature"
