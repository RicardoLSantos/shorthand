ValueSet: ReproductiveGoalVS
Id: social-history-goal-vs
Title: "Reproductive Health Goals Value Set"
Description: "Goals related to social-history health tracking and planning"
* ^experimental = false

* ^status = #active
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^date = "2024-03-19"

// LOINC codes verified at loinc.org (2026-01-12)
* $LOINC#8665-2 "Last menstrual period start date"
* $LOINC#49033-4 "Menstrual History - Reported"
// Removed: 55284-4 "Blood pressure" - status DISCOURAGED, not relevant to reproductive goals
* $LOINC#8310-5 "Body temperature"
* $LOINC#8302-2 "Body height"
* $LOINC#29463-7 "Body weight"
// SNOMED code verified (2026-01-12)
// Note: 289530006 actual = "Bleeding from vagina" - using broader concept instead
* $SCT#118185001 "Finding related to pregnancy (finding)"
* $SCT#364320009 "Menstrual cycle observable (observable entity)"

ValueSet: ReproductiveActivityVS
Id: social-history-activity-vs
Title: "Reproductive Health Activities Value Set"
Description: "Activities related to social-history health monitoring"
* ^experimental = false

* ^status = #active
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^date = "2024-03-19"

* LifestyleMedicineTemporaryCS#cycle-tracking "Cycle Tracking"
* LifestyleMedicineTemporaryCS#temp-monitoring "Temperature Monitoring"
* LifestyleMedicineTemporaryCS#symptom-tracking "Symptom Tracking"
* LifestyleMedicineTemporaryCS#vitals-monitoring "Vitals Monitoring"
* LifestyleMedicineTemporaryCS#fertility-signs "Fertility Signs"
* LifestyleMedicineTemporaryCS#mood-tracking "Mood Tracking"
* LifestyleMedicineTemporaryCS#medication-log "Medication Log"
* LifestyleMedicineTemporaryCS#exercise-tracking "Exercise Tracking"
