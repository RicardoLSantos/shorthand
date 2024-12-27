Profile: ReproductiveObservation
Parent: Observation
Id: reproductive-observation
Title: "Reproductive Health Base Profile"
Description: "Base profile for reproductive health observations"

* ^version = "1.0.0"
* ^status = #active
* ^date = "2024-03-19"
* ^publisher = "Health Level Seven International"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#reproductive
* code 1..1 MS
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* value[x] MS

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    severity 0..1 MS and
    duration 0..1 MS and
    frequency 0..1 MS and
    pattern 0..1 MS

* component[severity]
  * code = $LOINC#72514-3 "Pain severity score"
  * value[x] only integer
  * valueInteger ^minValue = 0
  * valueInteger ^maxValue = 10

* component[duration]
  * code = $LOINC#103332-8 "Duration"
  * value[x] only Quantity
  * valueQuantity from DurationUnitsVS (required)

* component[frequency]
  * code = $LOINC#103334-4 "Frequency"
  * value[x] only CodeableConcept
  * valueCodeableConcept from SymptomFrequencyVS (required)

* component[pattern]
  * code = $LOINC#103335-1 "Pattern"
  * value[x] only CodeableConcept
  * valueCodeableConcept from SymptomProgressionVS (required)

* note MS
