Extension: StressTriggers
Id: stress-triggers
Title: "Stress Triggers Extension"
Description: "Extension for recording identified stress triggers"
* value[x] only CodeableConcept
* valueCodeableConcept from StressTriggersVS (required)

Extension: StressCoping
Id: stress-coping
Title: "Stress Coping Extension"
Description: "Extension for recording stress coping mechanisms"
* value[x] only CodeableConcept
* valueCodeableConcept from StressCopingVS (required)

ValueSet: StressTriggersVS
Id: stress-triggers-vs
Title: "Stress Triggers Value Set"
Description: "Value set for common stress triggers"
* codes from system StressTriggersCS

ValueSet: StressCopingVS
Id: stress-coping-vs
Title: "Stress Coping Value Set"
Description: "Value set for stress coping mechanisms"
* codes from system StressCopingCS

CodeSystem: StressTriggersCS
Id: stress-triggers-cs
Title: "Stress Triggers Code System"
Description: "Code system for common stress triggers"
* #work "Work-related" "Stress from work or professional activities"
* #financial "Financial" "Financial-related stress"
* #relationships "Relationships" "Stress from personal relationships"
* #health "Health" "Health-related concerns"
* #environment "Environmental" "Environmental factors"
* #time "Time Management" "Time pressure and deadlines"
* #change "Life Changes" "Major life changes or transitions"

CodeSystem: StressCopingCS
Id: stress-coping-cs
Title: "Stress Coping Code System"
Description: "Code system for stress coping mechanisms"
* #exercise "Physical Exercise" "Using exercise to manage stress"
* #meditation "Meditation" "Meditation and mindfulness practices"
* #social "Social Support" "Seeking social support"
* #professional "Professional Help" "Seeking professional assistance"
* #relaxation "Relaxation" "Relaxation techniques"
* #creative "Creative Activities" "Engaging in creative activities"
* #nature "Nature" "Spending time in nature"
