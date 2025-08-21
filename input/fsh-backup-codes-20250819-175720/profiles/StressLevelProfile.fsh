Profile: StressLevelProfile
Parent: Observation
Id: stress-level
Title: "Stress Level Profile"
Description: "Profile for recording stress level measurements from iOS Health App"

* ^version = "0.1.0"
* ^status = #active
* ^date = "2024-01-03"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code 1..1 MS
* code = $LOINC#89592-0 "Stress level score"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] only Quantity
* valueQuantity MS

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    physiologicalStress 0..1 MS and
    psychologicalStress 0..1 MS and
    chronicity 0..1 MS and 
    impact 0..1 MS

* component[physiologicalStress]
  * code = $LOINC#89593-8 "Physiological stress"
  * valueQuantity only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{score}

* component[psychologicalStress]
  * code = $LOINC#89594-6 "Psychological stress"
  * valueQuantity only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{score}

* component[chronicity]
  * code = $LOINC#89595-3 "Stress chronicity"
  * valueCodeableConcept from StressChronicityVS (required)

* component[impact]
  * code = $LOINC#89596-1 "Stress impact"
  * valueCodeableConcept from StressImpactVS (required)

* extension contains
    MeasurementContext named context 0..1 MS and
    StressTriggers named triggers 0..* MS and 
    StressCoping named coping 0..* MS
