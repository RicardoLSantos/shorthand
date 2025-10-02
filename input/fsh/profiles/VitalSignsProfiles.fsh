Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $vitalsigns = http://hl7.org/fhir/StructureDefinition/vitalsigns

Profile: LifestyleVitalSigns
Parent: $vitalsigns
Id: lifestyle-vital-signs
Title: "Lifestyle Medicine Vital Signs Profile"
Description: "Profile for vital signs data from iOS Health App"

* status MS
* category 1..* MS
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* code 1..1 MS
* value[x] 0..1 MS
* device 0..1 MS

Profile: HeartRateObservation
Parent: LifestyleVitalSigns
Id: heart-rate-observation
Title: "Heart Rate Observation Profile"
Description: "Profile for heart rate measurements from iOS Health App"

* code = $LOINC#8867-4 "Heart rate"
* valueQuantity only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #/min
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    restingHeartRate 0..1 MS and
    exerciseHeartRate 0..1 MS and
    recoveryHeartRate 0..1 MS and
    heartRateVariability 0..1 MS

* component[restingHeartRate].code = $LOINC#40443-4 "Heart rate --resting"
* component[restingHeartRate].valueQuantity.system = $UCUM
* component[restingHeartRate].valueQuantity.code = #/min

* component[exerciseHeartRate].code = $LOINC#55425-3 "Heart rate unspecified time mean by Pedometer"
* component[exerciseHeartRate].valueQuantity.system = $UCUM
* component[exerciseHeartRate].valueQuantity.code = #/min

* component[recoveryHeartRate].code = $LOINC#8867-4 "Heart rate"
* component[recoveryHeartRate].valueQuantity.system = $UCUM
* component[recoveryHeartRate].valueQuantity.code = #/min

* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.code = #ms

Profile: BloodPressureObservation
Parent: LifestyleVitalSigns
Id: blood-pressure-observation
Title: "Blood Pressure Observation Profile"
Description: "Profile for blood pressure measurements from iOS Health App"

* code = $LOINC#85354-9 "Blood pressure panel with all children optional"
* component 2..2 MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #closed

* component contains
    systolic 1..1 MS and
    diastolic 1..1 MS

* component[systolic].code = $LOINC#8480-6 "Systolic blood pressure"
* component[systolic].valueQuantity only Quantity
* component[systolic].valueQuantity.system = $UCUM
* component[systolic].valueQuantity.code = #mm[Hg]

* component[diastolic].code = $LOINC#8462-4 "Diastolic blood pressure"
* component[diastolic].valueQuantity only Quantity
* component[diastolic].valueQuantity.system = $UCUM
* component[diastolic].valueQuantity.code = #mm[Hg]

Profile: OxygenSaturationObservation
Parent: LifestyleVitalSigns
Id: oxygen-saturation-observation
Title: "Oxygen Saturation Observation Profile"
Description: "Profile for SpO2 measurements from iOS Health App"

* code = $LOINC#2708-6 "Oxygen saturation in Arterial blood"
* valueQuantity.system = $UCUM
* valueQuantity.code = #%
