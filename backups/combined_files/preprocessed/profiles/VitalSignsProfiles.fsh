Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $vitalsigns = http://hl7.org/fhir/StructureDefinition/vitalsigns

// Originally defined on lines 6 - 18
Profile: LifestyleVitalSigns
Parent: http://hl7.org/fhir/StructureDefinition/vitalsigns
Id: lifestyle-vital-signs
Title: "Lifestyle Medicine Vital Signs Profile"
Description: "Profile for vital signs data from iOS Health App"
* status MS
* category 1..*
* category MS
* subject 1..1
* subject MS
* effectiveDateTime 1..1
* effectiveDateTime MS
* code 1..1
* code MS
* value[x] 0..1
* value[x] MS
* device 0..1
* device MS

// Originally defined on lines 20 - 42
Profile: HeartRateObservation
Parent: LifestyleVitalSigns
Id: heart-rate-observation
Title: "Heart Rate Observation Profile"
Description: "Profile for heart rate measurements from iOS Health App"
* code = http://loinc.org#8867-4 "Heart rate"
* valueQuantity only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #/min
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    restingHeartRate 0.. and
    exerciseHeartRate 0.. and
    recoveryHeartRate 0.. and
    heartRateVariability 0..
* component[restingHeartRate] 0..1
* component[restingHeartRate] MS
* component[exerciseHeartRate] 0..1
* component[exerciseHeartRate] MS
* component[recoveryHeartRate] 0..1
* component[recoveryHeartRate] MS
* component[heartRateVariability] 0..1
* component[heartRateVariability] MS
* component[heartRateVariability].code = http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity.system = "http://unitsofmeasure.org"
* component[heartRateVariability].valueQuantity.code = #ms

// Originally defined on lines 44 - 68
Profile: BloodPressureObservation
Parent: LifestyleVitalSigns
Id: blood-pressure-observation
Title: "Blood Pressure Observation Profile"
Description: "Profile for blood pressure measurements from iOS Health App"
* code = http://loinc.org#85354-9 "Blood pressure panel with all children optional"
* component 2..2
* component MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #closed
* component contains
    systolic 0.. and
    diastolic 0..
* component[systolic] 1..1
* component[systolic] MS
* component[diastolic] 1..1
* component[diastolic] MS
* component[systolic].code = http://loinc.org#8480-6 "Systolic blood pressure"
* component[systolic].valueQuantity only Quantity
* component[systolic].valueQuantity.system = "http://unitsofmeasure.org"
* component[systolic].valueQuantity.code = #mm[Hg]
* component[diastolic].code = http://loinc.org#8462-4 "Diastolic blood pressure"
* component[diastolic].valueQuantity only Quantity
* component[diastolic].valueQuantity.system = "http://unitsofmeasure.org"
* component[diastolic].valueQuantity.code = #mm[Hg]

// Originally defined on lines 70 - 78
Profile: OxygenSaturationObservation
Parent: LifestyleVitalSigns
Id: oxygen-saturation-observation
Title: "Oxygen Saturation Observation Profile"
Description: "Profile for SpO2 measurements from iOS Health App"
* code = http://loinc.org#2708-6 "Oxygen saturation in Arterial blood"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #%

