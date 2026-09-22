// ============================================================================
// Reproductive Health Goal Profile
// ============================================================================
// Date: 2026-09-22
// Purpose: Goal profile for reproductive-health aims stated by the person or
//          agreed with a clinician, with optional measurable targets.
// Context: Replaces the unbound ReproductiveGoalVS of earlier releases with a
//          profile plus two value sets (what the goal is / what is measured).
// ============================================================================

Profile: ReproductiveHealthGoal
Parent: Goal
Id: reproductive-health-goal
Title: "Reproductive Health Goal Profile"
Description: """
A goal of reproductive-health care or self-management — conceiving, avoiding
an unwanted pregnancy, optimising health before conception, regular menstrual
cycles or a normal body weight — with optional measurable targets. The
description states what the goal is (ReproductiveGoalDescriptionVS); each
target names what is measured (ReproductiveGoalMeasureVS) and the value aimed
at, as a coded state (for cycle regularity, MenstrualCycleRegularityVS), a
quantity or a range. A CarePlanLifestyleMedicine may reference the goal
through CarePlan.goal. The profile carries no clinical recommendation: which
goals are appropriate for a person is a clinical decision.
"""
* ^experimental = false
* ^date = "2026-09-22"

// Lifecycle
* lifecycleStatus 1..1 MS
  * ^short = "proposed | planned | accepted | active | on-hold | completed | cancelled | entered-in-error | rejected"

// What the goal is
* description 1..1 MS
* description from ReproductiveGoalDescriptionVS (extensible)
  * ^short = "What the person is aiming for (conception, avoiding an unwanted pregnancy, preconception health, regular cycles, normal weight)"

// Whose goal
* subject only Reference(Patient)
* subject 1..1 MS

// When it starts and who stated it
* start[x] 0..1 MS
* expressedBy 0..1 MS
  * ^short = "The person, or the clinician who agreed the goal with them"

// Measurable targets
* target 0..* MS
* target.measure 0..1 MS
* target.measure from ReproductiveGoalMeasureVS (extensible)
  * ^short = "What is measured to assess the goal"
* target.detail[x] only Quantity or Range or CodeableConcept
* target.detail[x] 0..1 MS
  * ^short = "The value aimed at: a coded state (e.g. regular periods), a quantity or a range"
* target.due[x] 0..1 MS

// What the goal addresses and free-text notes
* addresses 0..* MS
  * ^short = "Conditions or observations the goal addresses"
* note 0..*
