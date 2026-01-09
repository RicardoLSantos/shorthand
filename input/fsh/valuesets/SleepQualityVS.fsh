// Sleep Quality Value Set
// Updated: 2026-01-09
// Fix: Replaced incorrect SNOMED codes with custom SleepQualityCS
// Previous codes had wrong displays (e.g., 248255005 = "Cannot sleep at all" was labeled "Sleeping well")

ValueSet: SleepQualityVS
Id: sleep-quality-vs
Title: "Sleep Quality Value Set"
Description: "Qualitative assessments of sleep quality for lifestyle medicine. Uses custom SleepQualityCS codes as SNOMED CT lacks specific sleep quality level codes (verified 2026-01-09). Reference: SNOMED 248254009 'Quality of sleep' is the parent observable entity."
* ^experimental = false
* ^status = #active
* ^version = "0.1.0"
* ^publisher = "2RDoc FMUP"
* ^contact.name = "Ricardo Lourenco dos Santos"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"

// Core quality levels
* SleepQualityCS#excellent "Excellent sleep quality"
* SleepQualityCS#good "Good sleep quality"
* SleepQualityCS#fair "Fair sleep quality"
* SleepQualityCS#poor "Poor sleep quality"

// Optional: Include SNOMED pattern codes where they exist
* $SCT#301346001 "Good sleep pattern"
* $SCT#301345002 "Poor sleep pattern"

