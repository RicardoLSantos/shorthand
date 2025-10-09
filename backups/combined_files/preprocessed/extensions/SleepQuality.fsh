// Originally defined on lines 1 - 7
Extension: SleepQuality
Parent: Extension
Id: activity-quality
Title: "Sleep Quality Extension"
Description: "Extension for recording subjective activity quality"
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept from SleepQualityExtendedVS (required)
* extension 0..0

// Originally defined on lines 9 - 15
ValueSet: SleepQualityExtendedVS
Id: activity-quality-extended-vs
Title: "Sleep Quality Value Set"
Description: "Extended value set for activity quality assessment"
* http://snomed.info/sct#248220008 "Very good quality activity"
* http://snomed.info/sct#248221007 "Good quality activity"
* http://snomed.info/sct#248222000 "Poor quality activity"
* http://snomed.info/sct#248223005 "Very poor quality activity"

