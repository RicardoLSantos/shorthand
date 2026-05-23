// ============================================================================
// LifestyleMedicationRequest Profile
// ============================================================================
// Date: 2026-05-23
// Purpose: MedicationRequest profile for the lifestyle-medicine context. Gives
//          the IG's CDS Hooks `drug-lifestyle-interaction` service (medication-
//          prescribe hook) a concrete FHIR resource to reason over, flagging
//          interactions between a prescribed medication and dietary/lifestyle
//          factors (e.g., MAOI + tyramine-rich diet, SSRI + alcohol,
//          anticoagulant + Vitamin K-rich foods).
// Context: Closes the FHIR Intermediate course M4 (CDS Hooks) loop for G1 —
//          CDSHooksServiceDeclaration.fsh declares a medication-prescribe hook;
//          this profile is what that hook's context resource conforms to.
// Regulatory: CFM 2.454/2026 Art. 7 (physician autonomy over prescribing);
//             EU AI Act Art. 14 (human oversight of AI-surfaced interactions).
// Authorship: T1 S44 (Path 4b reopened for the G1 gate). Interaction codes are
//             local (DrugLifestyleInteractionCS) - NO external LOINC/SNOMED
//             codes asserted (Database-First, Pitfall #33). Medication and
//             reason bindings inherit the FHIR R4 base ValueSets.
// ============================================================================

Profile: LifestyleMedicationRequest
Parent: MedicationRequest
Id: lifestyle-medication-request
Title: "Lifestyle Medication Request Profile"
Description: """
Profile for MedicationRequest resources in the lifestyle-medicine context.
Carries an optional drug-lifestyle interaction flag that the IG's CDS Hooks
`drug-lifestyle-interaction` service (medication-prescribe hook) uses to surface
diet/lifestyle interactions to the prescriber. Medication and reason codings
inherit the FHIR R4 base bindings (no IG-specific terminology asserted), keeping
the profile interoperable with any RxNorm/SNOMED-coded medication catalogue.
Aligned with CFM 2.454/2026 Art. 7 (physician autonomy) and EU AI Act Art. 14
(human oversight).
"""

* ^experimental = false

// Core MedicationRequest constraints
* status 1..1 MS
  * ^short = "active | on-hold | cancelled | completed | stopped | draft (prescribing lifecycle)"
* intent 1..1 MS
  * ^short = "proposal (AI-surfaced) | plan | order (physician-signed)"
* medication[x] MS
  * ^short = "Medication prescribed (CodeableConcept or Reference(Medication); base bindings)"
* subject 1..1 MS
* subject only Reference(Patient)
  * ^short = "The patient for whom the medication is requested"
* authoredOn 0..1 MS
  * ^short = "When the request was authored (drives medication-prescribe hook timing)"
* requester 0..1 MS
* requester only Reference(Practitioner or PractitionerRole or Device)
  * ^short = "Prescriber (physician) or AI device that surfaced the request"
* reasonReference 0..* MS
* reasonReference only Reference(Condition or Observation)
  * ^short = "Clinical reason - Condition or lifestyle Observation (e.g., HRV, substance use)"
* supportingInformation 0..* MS
  * ^short = "Lifestyle Observations informing the request (nutrition, alcohol, HRV)"
* note 0..* MS
  * ^short = "Physician or AI reasoning notes"

// Drug-lifestyle interaction flag - feeds the CDS Hooks drug-lifestyle-interaction service
* extension contains
    DrugLifestyleInteraction named drugLifestyleInteraction 0..* MS
* extension[drugLifestyleInteraction] ^short = "Known diet/lifestyle interaction(s) for this medication"

// ============================================================================
// Extension: DrugLifestyleInteraction
// ============================================================================

Extension: DrugLifestyleInteraction
Id: drug-lifestyle-interaction
Title: "Drug-Lifestyle Interaction Extension"
Description: "Flags a known interaction between the prescribed medication and a dietary/lifestyle factor, supporting the IG's CDS Hooks drug-lifestyle-interaction service (medication-prescribe hook)."
* ^experimental = false
* value[x] only CodeableConcept
* valueCodeableConcept 1..1
* valueCodeableConcept from DrugLifestyleInteractionVS (extensible)
  * ^short = "Interaction category (extensible - clinical expansion expected)"

// ============================================================================
// CodeSystem: DrugLifestyleInteractionCS
// ============================================================================

CodeSystem: DrugLifestyleInteractionCS
Id: drug-lifestyle-interaction-cs
Title: "Drug-Lifestyle Interaction Category Code System"
Description: "Local code system enumerating categories of drug-diet/lifestyle interaction relevant to lifestyle-medicine prescribing. Starter set derived from the IG's documented CDS Hooks drug-lifestyle-interaction examples; intended for clinical expansion."
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #maoi-tyramine "MAOI + tyramine-rich diet" "Monoamine oxidase inhibitors with tyramine-rich foods (aged cheese, cured/fermented foods) - hypertensive crisis risk."
* #ssri-alcohol "SSRI + alcohol" "Selective serotonin reuptake inhibitors with alcohol - additive CNS depression and impaired judgment."
* #anticoagulant-vitamink "Anticoagulant + Vitamin K-rich foods" "Vitamin K antagonists (e.g., warfarin) with Vitamin K-rich foods (leafy greens) - reduced anticoagulant effect / INR variability."

// ============================================================================
// ValueSet: DrugLifestyleInteractionVS
// ============================================================================

ValueSet: DrugLifestyleInteractionVS
Id: drug-lifestyle-interaction-vs
Title: "Drug-Lifestyle Interaction Category Value Set"
Description: "Categories of drug-diet/lifestyle interaction surfaced by the CDS Hooks drug-lifestyle-interaction service. Extensible binding - clinical expansion expected."
* ^experimental = false
* ^version = "0.1.0"
* DrugLifestyleInteractionCS#maoi-tyramine "MAOI + tyramine-rich diet"
* DrugLifestyleInteractionCS#ssri-alcohol "SSRI + alcohol"
* DrugLifestyleInteractionCS#anticoagulant-vitamink "Anticoagulant + Vitamin K-rich foods"
