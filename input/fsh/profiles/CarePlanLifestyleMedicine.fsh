// ============================================================================
// CarePlan Lifestyle Medicine Profile
// ============================================================================
// Date: 2026-03-05
// Purpose: CarePlan profile for AI-assisted lifestyle medicine recommendations
// Context: Captures the 6 pillars of lifestyle medicine as care plan categories
//          with AI-generated activities and physician-approved goals
// Regulatory: CFM 2.454/2026 Art. 7 (physician autonomy over AI plans)
//             EU AI Act Art. 14 (human oversight of AI-generated plans)
// ============================================================================

Profile: CarePlanLifestyleMedicine
Parent: CarePlan
Id: care-plan-lifestyle-medicine
Title: "Care Plan Lifestyle Medicine Profile"
Description: """
Profile for CarePlan resources representing lifestyle medicine intervention
plans. Supports AI-generated recommendations across the 6 pillars of
lifestyle medicine (nutrition, physical activity, sleep, stress management,
social connections, substance avoidance) with mandatory physician review.
Aligned with CFM 2.454/2026 Art. 7 (physician autonomy) and EU AI Act
Art. 14 (human oversight).
"""

* ^experimental = false

// Status
* status 1..1 MS
  * ^short = "draft (AI proposed) | active (physician approved) | revoked (overridden)"

// Intent
* intent 1..1 MS
  * ^short = "proposal (AI) | plan (physician approved) | order (prescribed)"

// Category - lifestyle medicine pillar(s)
* category 1..* MS
* category from LifestyleMedicineCarePlanCategoryVS (extensible)
  * ^short = "Lifestyle medicine pillar(s) addressed by this plan"

// Title
* title 0..1 MS
  * ^short = "Human-readable plan title"

// Description
* description 0..1 MS
  * ^short = "AI-generated or physician-edited plan description"

// Subject
* subject 1..1 MS
* subject only Reference(Patient)

// Period
* period 0..1 MS
  * ^short = "Plan duration (e.g., 12-week intervention)"

// Created
* created 0..1 MS
  * ^short = "When the plan was first generated"

// Author - AI system or physician
* author 0..1 MS
* author only Reference(Device or Practitioner or PractitionerRole)
  * ^short = "AI system (initial) or physician (after review)"

// Contributor
* contributor 0..* MS
  * ^short = "AI system and/or care team members"

// Care team
* careTeam 0..* MS

// Addresses - conditions being addressed
* addresses 0..* MS
* addresses only Reference(Condition)
  * ^short = "Conditions addressed (e.g., obesity, hypertension, insomnia)"

// Supporting info - input data
* supportingInfo 0..* MS
  * ^short = "AI input data (ClinicalImpression, Observations)"

// Goal
* goal 0..* MS
  * ^short = "Lifestyle medicine goals (e.g., SDNN >40ms, BMI <25)"

// Activity
* activity 0..* MS
* activity.detail 0..1 MS
* activity.detail.kind 0..1 MS
  * ^short = "ServiceRequest | Task | MedicationRequest"
* activity.detail.code 0..1 MS
  * ^short = "Specific intervention code"
* activity.detail.status 1..1 MS
  * ^short = "not-started | scheduled | in-progress | completed | cancelled"
* activity.detail.description 0..1 MS
  * ^short = "AI-generated activity description"
* activity.detail.scheduled[x] 0..1 MS
  * ^short = "When the activity should occur"
* activity.reference 0..1 MS
  * ^short = "Reference to detailed activity resource"

// Note
* note 0..* MS
  * ^short = "AI reasoning or physician override notes"

// Extensions
* extension contains
    AgentRecommendation named agentRecommendation 0..1 MS

// ============================================================================
// Lifestyle Medicine Care Plan Category ValueSet
// ============================================================================

ValueSet: LifestyleMedicineCarePlanCategoryVS
Id: lifestyle-medicine-care-plan-category-vs
Title: "Lifestyle Medicine Care Plan Category Value Set"
Description: "Categories based on the 6 pillars of lifestyle medicine plus AI-specific workflow categories"
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-03-05"
* AgentDecisionSupportCS#lifestyle-exercise "Exercise Intervention"
* AgentDecisionSupportCS#lifestyle-nutrition "Nutrition Intervention"
* AgentDecisionSupportCS#lifestyle-sleep "Sleep Intervention"
* AgentDecisionSupportCS#lifestyle-stress "Stress Management"
* AgentDecisionSupportCS#agent-topic-lifestyle-intervention "Lifestyle Intervention"
* AgentDecisionSupportCS#agent-topic-preventive-care "Preventive Care"
* AgentDecisionSupportCS#cardiovascular-risk "Cardiovascular Risk"
* AgentDecisionSupportCS#metabolic-risk "Metabolic Risk"
