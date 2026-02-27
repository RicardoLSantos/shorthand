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
* valueCodeableConcept from SleepQualityExtendedVS (extensible)

ValueSet: SleepQualityExtendedVS
Id: sleep-quality-extended-vs
Title: "Sleep Quality Extended Value Set"
Description: "Extended value set for subjective sleep quality assessment. Uses custom codes due to SNOMED CT gap - no standard codes exist for sleep quality levels (verified 2026-01-09)."
* ^name = "SleepQualityExtendedVS"
* ^experimental = false
* ^status = #active
// Quality grades — SNOMED CT (per SharedQualifierValueSets, Phase 2 adoption)
* http://snomed.info/sct#425405005 "Excellent (qualifier value)"
* http://snomed.info/sct#20572008 "Good (qualifier value)"
* http://snomed.info/sct#260347006 "Fair (qualifier value)"
* http://snomed.info/sct#255351007 "Poor (qualifier value)"
// Sleep-specific qualifiers — no standard equivalent
* LifestyleMedicineTemporaryCS#restful "Restful sleep"
* LifestyleMedicineTemporaryCS#restless "Restless sleep"
* LifestyleMedicineTemporaryCS#interrupted "Interrupted sleep"
* LifestyleMedicineTemporaryCS#uninterrupted "Uninterrupted sleep"
