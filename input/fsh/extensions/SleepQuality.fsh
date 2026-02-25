// Sleep Quality Extension and ValueSet
// Updated: 2026-01-09
// Fix: Replaced incorrect SNOMED codes with custom SleepQualityCS
// Previous codes (248220008-248223005) were consciousness-related, not sleep quality

Extension: SleepQuality
Id: sleep-quality
Title: "Sleep Quality Extension"
Description: "Extension for recording subjective sleep quality assessment. Uses custom SleepQualityCS codes as SNOMED CT lacks specific sleep quality level codes."
* ^experimental = false
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from SleepQualityExtendedVS (required)

ValueSet: SleepQualityExtendedVS
Id: sleep-quality-extended-vs
Title: "Sleep Quality Extended Value Set"
Description: "Extended value set for subjective sleep quality assessment. Uses custom codes due to SNOMED CT gap - no standard codes exist for sleep quality levels (verified 2026-01-09)."
* ^name = "SleepQualityExtendedVS"
* ^experimental = false
* ^status = #active
* include codes from system LifestyleMedicineTemporaryCS
