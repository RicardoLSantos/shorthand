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
Description: "Profile for SpO2 measurements from iOS Health App. Maps to HKQuantityTypeIdentifier.oxygenSaturation. Normal range: 95-100%."

* code = $LOINC#2708-6 "Oxygen saturation in Arterial blood"
* valueQuantity 1..1 MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #%
* valueQuantity ^short = "SpO2 percentage"
* valueQuantity ^definition = "Peripheral oxygen saturation. Normal: 95-100%. <90% indicates hypoxemia requiring medical attention."
* note 0..* MS


// Body Temperature Profile (LOINC 8310-5) - Added 2026-01-20
Profile: BodyTemperatureObservation
Parent: LifestyleVitalSigns
Id: body-temperature-observation
Title: "Body Temperature Observation Profile"
Description: "Profile for body temperature measurements from iOS Health App. Maps to HKQuantityTypeIdentifier.bodyTemperature. Normal range: 36.1-37.2°C (97-99°F)."

* code = $LOINC#8310-5 "Body temperature"
* valueQuantity 1..1 MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #Cel
* valueQuantity ^short = "Body temperature in Celsius"
* valueQuantity ^definition = "Core or peripheral body temperature. Normal adult: 36.1-37.2°C (97-99°F). Fever: >38°C (100.4°F)."
* note 0..* MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    basalBodyTemperature 0..1 MS and
    measurementSite 0..1 MS

* component[basalBodyTemperature].code = $LOINC#8328-7 "Axillary temperature"
* component[basalBodyTemperature].valueQuantity.system = $UCUM
* component[basalBodyTemperature].valueQuantity.code = #Cel
* component[basalBodyTemperature] ^short = "Basal body temperature"
* component[basalBodyTemperature] ^definition = "Temperature measured at rest, typically upon waking. Used for fertility tracking."

* component[measurementSite].code = $SCT#386725007 "Body temperature"
* component[measurementSite].valueCodeableConcept only CodeableConcept
* component[measurementSite] ^short = "Measurement site (oral, axillary, tympanic, etc.)"
* component[measurementSite] ^comment = "Recommended values from BodyTemperatureSiteVS: oral cavity (74262004), ear (117590005), forehead (52795006), axillary (91470000), rectum (34402009)"


// Respiratory Rate Profile (LOINC 9279-1) - Added 2026-01-20
Profile: RespiratoryRateObservation
Parent: LifestyleVitalSigns
Id: respiratory-rate-observation
Title: "Respiratory Rate Observation Profile"
Description: "Profile for respiratory rate measurements from iOS Health App. Maps to HKQuantityTypeIdentifier.respiratoryRate. Normal adult range: 12-20 breaths/min."

* code = $LOINC#9279-1 "Respiratory rate"
* valueQuantity 1..1 MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #/min
* valueQuantity ^short = "Breaths per minute"
* valueQuantity ^definition = "Respiratory rate in breaths per minute. Normal adult resting: 12-20/min. Tachypnea: >20/min. Bradypnea: <12/min."
* note 0..* MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    sleepRespiratoryRate 0..1 MS

* component[sleepRespiratoryRate].code = $LOINC#9279-1 "Respiratory rate"
* component[sleepRespiratoryRate].valueQuantity.system = $UCUM
* component[sleepRespiratoryRate].valueQuantity.code = #/min
* component[sleepRespiratoryRate] ^short = "Respiratory rate during sleep"
* component[sleepRespiratoryRate] ^definition = "Average respiratory rate during sleep. Often lower than awake rate (10-16/min normal during sleep)."


// ValueSet for Body Temperature measurement sites
ValueSet: BodyTemperatureSiteVS
Id: body-temperature-site-vs
Title: "Body Temperature Measurement Site Value Set"
Description: "Sites where body temperature can be measured"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/body-temperature-site-vs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false

// Body structure codes for temperature measurement sites
// Note: Using anatomical body structure codes (valid in SNOMED CT International 2025+)
* $SCT#74262004 "Oral cavity structure"
* $SCT#117590005 "Ear structure"
* $SCT#52795006 "Forehead structure"
* $SCT#91470000 "Axillary region structure"
* $SCT#34402009 "Rectum structure"
