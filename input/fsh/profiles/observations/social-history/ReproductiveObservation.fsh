Profile: ReproductiveObservation
Parent: Observation
Id: social-history-observation
Title: "Reproductive Health Base Profile"
Description: "Base profile for social-history health observations"

* ^version = "1.0.0"
* ^status = #active
* ^date = "2026-09-17"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* value[x] MS

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    severity 0..1 MS and
    duration 0..1 MS and
    regularity 0..1 MS

* component[severity]
  * code = $LOINC#72514-3 "Pain severity - 0-10 verbal numeric rating [Score] - Reported"
  * value[x] only integer
  * valueInteger 1..1 
  * valueInteger obeys rep-1

* component[duration]
  * code = $LOINC#3144-3 "Last menstrual period duration"
  * value[x] only Quantity
  * valueQuantity from DurationUnitsVS (required)

* component[regularity]
  // 2026-09-17: replaces the former frequency (LOINC 92656-8, a quantitative concept: scale Qn, property NRat) and pattern (LOINC 64699-2, a PhenX questionnaire item for ages 18-22)
  // components, whose concepts did not fit a coded regularity value; SNOMED CT International, verified in the Vocab2 snapshot and on tx.fhir.org (20250201)
  * code = $SCT#364307006 "Regularity of menstrual cycle"
  * value[x] only CodeableConcept
  * valueCodeableConcept from MenstrualCycleRegularityVS (required)

Invariant: rep-1
Description: "Severity must be between 0 and 10"
Expression: "$this >= 0 and $this <= 10"
Severity: #error
