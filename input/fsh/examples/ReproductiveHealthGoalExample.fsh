// ============================================================================
// Reproductive Health Goal — example
// ============================================================================
// Date: 2026-09-22
// Purpose: Standalone example of the ReproductiveHealthGoal profile (one goal,
//          two targets: a coded regularity state and a periods-per-year range).
// ============================================================================

Instance: ReproductiveHealthGoalExample
InstanceOf: ReproductiveHealthGoal
Usage: #example
Title: "Reproductive health goal — regular menstrual cycle"
Description: "A goal of regular menstrual cycles stated by the person, assessed by the cycle-regularity observable (target: regular periods) and by the number of periods per year (target: 11 to 13 per year), due in six months."
* lifecycleStatus = #active
* description = $SCT#302757007 "Regular periods"
* subject = Reference(Patient/PatientExample)
* startDate = "2026-09-01"
* expressedBy = Reference(Patient/PatientExample)
* target[0].measure = $SCT#364307006 "Regularity of menstrual cycle"
* target[0].detailCodeableConcept = $SCT#302757007 "Regular periods"
* target[0].dueDate = "2027-03-01"
* target[1].measure = $LOINC#92656-8 "Number of menstrual periods per year"
* target[1].detailRange.low = 11 '/a' "per year"
* target[1].detailRange.high = 13 '/a' "per year"
* target[1].dueDate = "2027-03-01"
* note.text = "Example only: the goal, its targets and the dates are illustrative."
