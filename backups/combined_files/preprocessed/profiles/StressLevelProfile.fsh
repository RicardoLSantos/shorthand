// Originally defined on lines 1 - 55
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
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code 1..1
* code MS
* code = http://loinc.org#89592-0 "Stress level score"
* subject 1..1
* subject MS
* effectiveDateTime 1..1
* effectiveDateTime MS
* value[x] only Quantity
* valueQuantity MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    physiologicalStress 0.. and
    psychologicalStress 0.. and
    chronicity 0.. and
    impact 0..
* component[physiologicalStress] 0..1
* component[physiologicalStress] MS
* component[psychologicalStress] 0..1
* component[psychologicalStress] MS
* component[chronicity] 0..1
* component[chronicity] MS
* component[impact] 0..1
* component[impact] MS
* component[physiologicalStress].code = http://loinc.org#89593-8 "Physiological stress"
* component[physiologicalStress].valueQuantity only Quantity
* component[physiologicalStress].valueQuantity.system = "http://unitsofmeasure.org"
* component[physiologicalStress].valueQuantity.code = #{score}
* component[psychologicalStress].code = http://loinc.org#89594-6 "Psychological stress"
* component[psychologicalStress].valueQuantity only Quantity
* component[psychologicalStress].valueQuantity.system = "http://unitsofmeasure.org"
* component[psychologicalStress].valueQuantity.code = #{score}
* component[chronicity].code = http://loinc.org#89595-3 "Stress chronicity"
* component[chronicity].valueCodeableConcept from StressChronicityVS (required)
* component[impact].code = http://loinc.org#89596-1 "Stress impact"
* component[impact].valueCodeableConcept from StressImpactVS (required)
* extension contains
    MeasurementContext named context 0.. and
    StressTriggers named triggers 0.. and
    StressCoping named coping 0..
* extension[context] 0..1
* extension[context] MS
* extension[triggers] 0..*
* extension[triggers] MS
* extension[coping] 0..*
* extension[coping] MS

