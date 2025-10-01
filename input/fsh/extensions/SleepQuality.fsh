Extension: SleepQuality
Id: activity-quality
Title: "Sleep Quality Extension"
Description: "Extension for recording subjective activity quality"
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept from SleepQualityExtendedVS (required)
 
ValueSet: SleepQualityExtendedVS
Id: activity-quality-extended-vs
Description: "Extended value set for activity quality assessment"Title: "Sleep Quality Value Set"
* $SCT#248220008 "Very good quality activity"
* $SCT#248221007 "Good quality activity"
* $SCT#248222000 "Poor quality activity"
* $SCT#248223005 "Very poor quality activity"
