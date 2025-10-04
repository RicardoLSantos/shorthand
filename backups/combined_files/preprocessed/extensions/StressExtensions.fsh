// Originally defined on lines 1 - 7
Extension: StressTriggers
Parent: Extension
Id: stress-triggers
Title: "Stress Triggers Extension"
Description: "Extension for recording identified stress triggers"
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept from StressTriggersVS (required)
* extension 0..0

// Originally defined on lines 9 - 15
Extension: StressCoping
Parent: Extension
Id: stress-coping
Title: "Stress Coping Extension"
Description: "Extension for recording stress coping mechanisms"
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept from StressCopingVS (required)
* extension 0..0

// Originally defined on lines 17 - 22
ValueSet: StressTriggersVS
Id: stress-triggers-vs
Title: "Stress Triggers Value Set"
Description: "Value set for common stress triggers"
* ^experimental = false
* include codes from system StressTriggersCS

// Originally defined on lines 24 - 29
ValueSet: StressCopingVS
Id: stress-coping-vs
Title: "Stress Coping Value Set"
Description: "Value set for stress coping mechanisms"
* ^experimental = false
* include codes from system StressCopingCS

// Originally defined on lines 31 - 42
CodeSystem: StressTriggersCS
Id: stress-triggers-cs
Title: "Stress Triggers Code System"
Description: "Code system for common stress triggers"
* ^experimental = false
* #work "Work-related" "Stress from work or professional activities"
* #financial "Financial" "Financial-related stress"
* #relationships "Relationships" "Stress from personal relationships"
* #health "Health" "Health-related concerns"
* #environment "Environmental" "Environmental factors"
* #time "Time Management" "Time pressure and deadlines"
* #change "Life Changes" "Major life changes or transitions"

// Originally defined on lines 44 - 55
CodeSystem: StressCopingCS
Id: stress-coping-cs
Title: "Stress Coping Code System"
Description: "Code system for stress coping mechanisms"
* ^experimental = false
* #exercise "Physical Exercise" "Using exercise to manage stress"
* #meditation "Meditation" "Meditation and mindfulness practices"
* #social "Social Support" "Seeking social support"
* #professional "Professional Help" "Seeking professional assistance"
* #relaxation "Relaxation" "Relaxation techniques"
* #creative "Creative Activities" "Engaging in creative activities"
* #nature "Nature" "Spending time in nature"

