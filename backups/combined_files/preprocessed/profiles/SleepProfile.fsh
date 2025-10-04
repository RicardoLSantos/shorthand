Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

// Originally defined on lines 5 - 75
Profile: SleepObservation
Parent: Observation
Id: activity-observation
Title: "Sleep Observation Profile"
Description: "Profile for recording activity data from iOS Health App"
* status MS
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1
* code MS
* code = http://loinc.org#93832-4 "Sleep pattern panel"
* subject 1..1
* subject MS
* subject only Reference(Patient)
* effectiveDateTime 0..1
* effectiveDateTime MS
* effectivePeriod 0..1
* effectivePeriod MS
* device 0..1
* device MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component contains
    timeInBed 0.. and
    totalSleepTime 0.. and
    deepSleep 0.. and
    remSleep 0.. and
    lightSleep 0.. and
    respiratoryRate 0.. and
    heartRateVariability 0.. and
    interruptions 0..
* component[timeInBed] 1..1
* component[timeInBed] MS
* component[totalSleepTime] 1..1
* component[totalSleepTime] MS
* component[deepSleep] 0..1
* component[deepSleep] MS
* component[remSleep] 0..1
* component[remSleep] MS
* component[lightSleep] 0..1
* component[lightSleep] MS
* component[respiratoryRate] 0..1
* component[respiratoryRate] MS
* component[heartRateVariability] 0..1
* component[heartRateVariability] MS
* component[interruptions] 0..1
* component[interruptions] MS
* component[timeInBed].code = http://loinc.org#93831-6 "Time in bed"
* component[timeInBed].valueQuantity only Quantity
* component[timeInBed].valueQuantity.system = "http://unitsofmeasure.org"
* component[timeInBed].valueQuantity.code = #min
* component[totalSleepTime].code = http://loinc.org#93833-2 "Sleep duration"
* component[totalSleepTime].valueQuantity only Quantity
* component[totalSleepTime].valueQuantity.system = "http://unitsofmeasure.org"
* component[totalSleepTime].valueQuantity.code = #min
* component[deepSleep].code = http://loinc.org#93834-0 "Deep activity duration"
* component[deepSleep].valueQuantity only Quantity
* component[deepSleep].valueQuantity.system = "http://unitsofmeasure.org"
* component[deepSleep].valueQuantity.code = #min
* component[remSleep].code = http://loinc.org#93835-7 "REM activity duration"
* component[remSleep].valueQuantity only Quantity
* component[remSleep].valueQuantity.system = "http://unitsofmeasure.org"
* component[remSleep].valueQuantity.code = #min
* component[lightSleep].code = http://loinc.org#93836-5 "Light activity duration"
* component[lightSleep].valueQuantity only Quantity
* component[lightSleep].valueQuantity.system = "http://unitsofmeasure.org"
* component[lightSleep].valueQuantity.code = #min
* component[respiratoryRate].code = http://loinc.org#9279-1 "Respiratory rate"
* component[respiratoryRate].valueQuantity only Quantity
* component[respiratoryRate].valueQuantity.system = "http://unitsofmeasure.org"
* component[respiratoryRate].valueQuantity.code = #/min
* component[heartRateVariability].code = http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity only Quantity
* component[heartRateVariability].valueQuantity.system = "http://unitsofmeasure.org"
* component[heartRateVariability].valueQuantity.code = #ms
* component[interruptions].code = http://loinc.org#93837-3 "Number of awakenings during activity"
* component[interruptions].valueQuantity only Quantity
* component[interruptions].valueQuantity.system = "http://unitsofmeasure.org"
* component[interruptions].valueQuantity.code = #{count}
* extension contains SleepQuality named quality 0..
* extension[quality] 0..1

