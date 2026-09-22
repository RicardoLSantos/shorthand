// 2026-09-22: ReproductiveGoalVS (social-history-goal-vs, 5 LOINC observables + 2 SNOMED findings, bound by no profile since it was written)
// is replaced by the two value sets below, designed for the ReproductiveHealthGoal profile: one for what a goal is (Goal.description),
// one for what is measured to assess it (Goal.target.measure). Every code verified on 2026-09-22 in the Vocab2 SNOMED snapshot (2025-02-01)
// or the Athena LOINC snapshot (2026-01-21) and on tx.fhir.org (SNOMED CT International 20250201; LOINC 2.82).

ValueSet: ReproductiveGoalDescriptionVS
Id: reproductive-goal-description-vs
Title: "Reproductive Health Goal Description Value Set"
Description: "SNOMED CT International concepts that state what a reproductive-health goal aims at: conceiving, avoiding an unwanted pregnancy, optimising health before conception, regular menstrual cycles, or a normal body weight (the last two are the desired states themselves). Bound (extensible) by Goal.description of the ReproductiveHealthGoal profile; a goal that fits none of these may carry another SNOMED CT concept or text."
* ^experimental = false
* ^status = #active
* ^date = "2026-09-22"
* $SCT#169449001 "Trying to conceive"
* $SCT#710973002 "Prevention of unwanted pregnancy"
* $SCT#429070000 "Preconception care"
* $SCT#302757007 "Regular periods"
* $SCT#43664005 "Normal weight"

ValueSet: ReproductiveGoalMeasureVS
Id: reproductive-goal-measure-vs
Title: "Reproductive Health Goal Measure Value Set"
Description: "Observables against which a reproductive-health goal is assessed (Goal.target.measure of the ReproductiveHealthGoal profile, extensible): cycle regularity and usual cycle length (SNOMED CT), periods per year, body mass index and body weight (LOINC). The regularity target is expressed with MenstrualCycleRegularityVS; the numeric ones with a Quantity or Range."
* ^experimental = false
* ^status = #active
* ^date = "2026-09-22"
* $SCT#364307006 "Regularity of menstrual cycle"
* $SCT#161716008 "Usual length of menstrual cycle"
* $LOINC#92656-8 "Number of menstrual periods per year"
* $LOINC#39156-5 "Body mass index (BMI) [Ratio]"
* $LOINC#29463-7 "Body weight"

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
* ^contact.telecom.value = "ricardolourencosantos@gmail.com"
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

ValueSet: MenstrualCycleRegularityVS
Id: menstrual-cycle-regularity-vs
Title: "Menstrual Cycle Regularity Value Set"
Description: "Coded values for the regularity of the menstrual cycle (SNOMED CT International), bound by the regularity component of the reproductive observation profile"
* ^experimental = false
* ^date = "2026-09-17"
* ^status = #active
// 2026-09-17: both concepts verified in the Vocab2 SNOMED snapshot (standard, active) and on tx.fhir.org (SNOMED CT International 20250201, $validate-code with these displays)
* $SCT#302757007 "Regular periods"
* $SCT#80182007 "Irregular periods"
