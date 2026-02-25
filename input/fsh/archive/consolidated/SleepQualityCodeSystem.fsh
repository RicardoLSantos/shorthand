// Sleep Quality CodeSystem
// Created: 2026-01-09
// Purpose: Provide standardized codes for subjective sleep quality assessment
// Note: SNOMED CT does not have specific codes for sleep quality levels (verified 2026-01-09)
// This custom CodeSystem fills the gap for wearable/consumer health applications

CodeSystem: SleepQualityCS
Id: sleep-quality-cs
Title: "Sleep Quality Code System"
Description: "Qualitative assessments of sleep quality for lifestyle medicine and wearable data. Created to fill SNOMED CT gap - no standard codes exist for subjective sleep quality levels. Based on Pittsburgh Sleep Quality Index (PSQI) and consumer wearable scoring patterns."
* ^experimental = false
* ^caseSensitive = true
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "Ricardo Lourenco dos Santos"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"

// Quality levels (aligned with 4-point Likert scale common in sleep research)
* #excellent "Excellent sleep quality" "Subjective rating of excellent sleep quality. Typically: fell asleep quickly (<15 min), minimal awakenings, felt refreshed upon waking. PSQI equivalent: component score 0."
* #good "Good sleep quality" "Subjective rating of good sleep quality. Minor issues but overall restorative. PSQI equivalent: component score 1."
* #fair "Fair sleep quality" "Subjective rating of fair/moderate sleep quality. Some sleep disturbances but functional. PSQI equivalent: component score 2."
* #poor "Poor sleep quality" "Subjective rating of poor sleep quality. Significant disturbances, not restorative. PSQI equivalent: component score 3."

// Additional qualitative codes for wearable integrations
* #restful "Restful sleep" "Sleep characterized by adequate deep sleep and REM stages, low movement, stable heart rate."
* #restless "Restless sleep" "Sleep characterized by frequent movement, elevated heart rate, fragmented stages."
* #interrupted "Interrupted sleep" "Sleep with one or more significant awakenings during the night."
* #uninterrupted "Uninterrupted sleep" "Continuous sleep without significant awakenings."

// SNOMED CT reference concepts (for mapping, not direct use)
// 248254009 = Quality of sleep (observable entity) - parent concept
// 301345002 = Poor sleep pattern (finding)
// 301346001 = Good sleep pattern (finding)
