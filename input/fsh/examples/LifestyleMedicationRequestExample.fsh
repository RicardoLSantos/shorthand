// ============================================================================
// LifestyleMedicationRequestExample
// ============================================================================
// Purpose: Example instance for the LifestyleMedicationRequest profile. It
//          exercises the drug-lifestyle-interaction extension, so this single
//          example resolves BOTH the profile and the extension "no example"
//          warnings (T1 S45 Fase 3).
// Anti-hallucination: medication is recorded as free text only (no fabricated
//          RxNorm/SNOMED code asserted - Pitfall #33). The interaction code is
//          local (DrugLifestyleInteractionCS). subject references the existing
//          PatientExample instance (no broken reference).
// Authorship: T1 S45 (Path 4b reopened for the G1 gate).
// ============================================================================

Instance: LifestyleMedicationRequestExample
InstanceOf: LifestyleMedicationRequest
Title: "Example: Lifestyle Medication Request (MAOI + tyramine interaction flag)"
Description: "A phenelzine (MAOI) order in the lifestyle-medicine context, carrying a drug-lifestyle interaction flag (tyramine-rich diet) that the IG's CDS Hooks drug-lifestyle-interaction service (medication-prescribe hook) surfaces to the prescriber. Medication is recorded as free text only; no RxNorm/SNOMED code is asserted."
Usage: #example
* status = #active
* intent = #order
* medicationCodeableConcept.text = "Phenelzine (monoamine oxidase inhibitor)"
* subject = Reference(PatientExample)
* authoredOn = "2026-05-26"
* extension[drugLifestyleInteraction].valueCodeableConcept = DrugLifestyleInteractionCS#maoi-tyramine "MAOI + tyramine-rich diet"
* note.text = "Counsel the patient to avoid tyramine-rich foods (aged cheese, cured or fermented foods) while on MAOI therapy - hypertensive crisis risk."
