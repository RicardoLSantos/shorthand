Extension: SleepQuality
Id: sleep-quality
Title: "Sleep Quality Extension"
Description: "Extension for recording subjective sleep quality"
* value[x] only CodeableConcept
* valueCodeableConcept from SleepQualityVS (required)
 
ValueSet: SleepQualityVS
Id: sleep-quality-vs
Title: "Sleep Quality Value Set"
* $SCT#248220008 "Very good quality sleep"
* $SCT#248221007 "Good quality sleep"
* $SCT#248222000 "Poor quality sleep"
* $SCT#248223005 "Very poor quality sleep"
