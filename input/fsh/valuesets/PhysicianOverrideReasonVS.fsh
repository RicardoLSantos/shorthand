// ============================================================================
// Physician Override Reason ValueSet
// ============================================================================
// Date: 2026-03-05
// Purpose: Reasons for physician override of AI recommendations
// Context: CFM Resolution 2.454/2026 Art. 7 mandates physician autonomy
//          documentation when overriding AI-generated recommendations
// ============================================================================

ValueSet: PhysicianOverrideReasonVS
Id: physician-override-reason-vs
Title: "Physician Override Reason Value Set"
Description: "Reasons for physician override of AI-generated clinical recommendations. Required by CFM Resolution 2.454/2026 Art. 7 (physician autonomy) and EU AI Act Art. 14 (human oversight)."
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-03-05"
* AgentDecisionSupportCS#override-clinical-judgment "Clinical Judgment Override"
* AgentDecisionSupportCS#override-patient-context "Patient Context Override"
* AgentDecisionSupportCS#override-comorbidity "Comorbidity Override"
* AgentDecisionSupportCS#override-patient-preference "Patient Preference Override"
* AgentDecisionSupportCS#override-ai-error "AI Error Override"
