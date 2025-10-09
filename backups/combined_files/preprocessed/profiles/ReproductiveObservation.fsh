// Originally defined on lines 1 - 49
Profile: ReproductiveObservation
Parent: Observation
Id: social-history-observation
Title: "Reproductive Health Base Profile"
Description: "Base profile for social-history health observations"
* ^version = "1.0.0"
* ^status = #active
* ^date = "2024-03-19"
* status MS
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1
* code MS
* subject 1..1
* subject MS
* subject only Reference(Patient)
* effectiveDateTime 1..1
* effectiveDateTime MS
* value[x] MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    severity 0.. and
    duration 0.. and
    frequency 0.. and
    pattern 0..
* component[severity] 0..1
* component[severity] MS
* component[duration] 0..1
* component[duration] MS
* component[frequency] 0..1
* component[frequency] MS
* component[pattern] 0..1
* component[pattern] MS
* component[severity].code = http://loinc.org#72514-3
* component[severity].value[x] only integer
* component[severity].valueInteger 1..1
* component[severity].valueInteger obeys rep-1
* component[duration].code = http://loinc.org#3144-3
* component[duration].value[x] only Quantity
* component[duration].valueQuantity from DurationUnitsVS (required)
* component[frequency].code = http://loinc.org#92656-8
* component[frequency].value[x] only CodeableConcept
* component[frequency].valueCodeableConcept from SymptomFrequencyVS (required)
* component[pattern].code = http://loinc.org#64699-2
* component[pattern].value[x] only CodeableConcept
* component[pattern].valueCodeableConcept from SymptomProgressionVS (required)

// Originally defined on lines 51 - 54
Invariant: rep-1
Description: "Severity must be between 0 and 10"
* severity = #error
* expression = "$this >= 0 and $this <= 10"

