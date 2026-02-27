Instance: StressLevelExample
InstanceOf: StressLevelProfile
Usage: #example
Description: "Stress level observation example"
Title: "Stress Level Measurement Example"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code = $LOINC#64394-0 "PhenX - perceived stress protocol 180801"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-01-03T15:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity = 7 '1' "score"

* component[physiologicalStress].valueQuantity = 6 '1' "score"
* component[psychologicalStress].valueQuantity = 8 '1' "score"
* component[chronicity].valueCodeableConcept = LifestyleMedicineTemporaryCS#subacute
* component[impact].valueCodeableConcept = AppLogicCS#stress-impact-moderate

* extension[triggers].valueCodeableConcept = LifestyleMedicineTemporaryCS#stress-triggers-work
* extension[coping].valueCodeableConcept = LifestyleMedicineTemporaryCS#stress-coping-meditation
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/allostatic-load"
* extension[=].valueQuantity = 0.72 '1' "score"
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/physiological-stress-index"
* extension[=].valueQuantity = 6.5 '1' "score"

// =============================================================================
// Semantic Anchoring Example - Stress Trigger with LOINC LA Answer Code
// =============================================================================
// LA7545-2 "Stress" is a LOINC Answer code (discrete option for trigger
// questions). Demonstrates LA dual-coding for qualitative observations.
// =============================================================================

Instance: StressTriggerDualCodingExample
InstanceOf: Observation
Usage: #example
Title: "Stress Trigger - Semantic Anchoring (LA Dual-Coding)"
Description: "Stress trigger observation with semantic anchoring via LOINC LA Answer code"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-02-25T18:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#financial "Financial"
* code.coding[1] = $LOINC#LA17981-4 "Financial"
* code.text = "Stress trigger: financial"

* valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs#stress-impact-moderate "Moderate impact"
* note.text = "Self-reported financial stress trigger. LOINC LA17981-4 is an Answer code (discrete option for 'what triggers stress?') — not an observation code. Dual-coding anchors this custom concept to the LOINC Answer ecosystem."
