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

// Core quality levels (custom codes - SNOMED gap documented)
* LifestyleMedicineTemporaryCS#sleep-quality-excellent "Excellent sleep quality"
* LifestyleMedicineTemporaryCS#sleep-quality-good "Good sleep quality"
* LifestyleMedicineTemporaryCS#sleep-quality-fair "Fair sleep quality"
* LifestyleMedicineTemporaryCS#sleep-quality-poor "Poor sleep quality"

// -----------------------------------------------------------------------------
// SNOMED CT Gap Documentation (2026-01-12)
// -----------------------------------------------------------------------------
// Previous codes were INCORRECT:
// - 301346001: Actual = "Finding of appearance of lip" NOT "Good sleep pattern"
// - 301345002: Actual = "Poor sleep" (close but different semantic)
//
// SNOMED CT International Edition does NOT have specific codes for subjective
// sleep quality levels (excellent/good/fair/poor). The custom SleepQualityCS
// provides these codes with explicit gap documentation.
//
// Related SNOMED concepts that DO exist:
// - 248254009 "Quality of sleep" (observable entity)
// - 248220008 "Difficulty sleeping" (finding)
// - 193462001 "Insomnia" (disorder)
// -----------------------------------------------------------------------------

