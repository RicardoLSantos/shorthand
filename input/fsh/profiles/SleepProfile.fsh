Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
 
Profile: SleepObservation
Parent: Observation
Id: sleep-observation
Title: "Sleep Observation Profile"
Description: "Profile for recording sleep data from iOS Health App"
 
* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#sleep
* code 1..1 MS
* code = $LOINC#93832-4 "Sleep pattern panel"
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* effectivePeriod 0..1 MS
* device 0..1 MS
 
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
 
* component contains
    timeInBed 1..1 MS and
    totalSleepTime 1..1 MS and
    deepSleep 0..1 MS and
    remSleep 0..1 MS and
    lightSleep 0..1 MS and
    respiratoryRate 0..1 MS and
    heartRateVariability 0..1 MS and
    interruptions 0..1 MS
 
* component[timeInBed].code = $LOINC#93831-6 "Time in bed"
* component[timeInBed].valueQuantity only Quantity
* component[timeInBed].valueQuantity.system = $UCUM
* component[timeInBed].valueQuantity.code = #min
 
* component[totalSleepTime].code = $LOINC#93833-2 "Sleep duration"
* component[totalSleepTime].valueQuantity only Quantity
* component[totalSleepTime].valueQuantity.system = $UCUM
* component[totalSleepTime].valueQuantity.code = #min
 
* component[deepSleep].code = $LOINC#93834-0 "Deep sleep duration"
* component[deepSleep].valueQuantity only Quantity
* component[deepSleep].valueQuantity.system = $UCUM
* component[deepSleep].valueQuantity.code = #min
 
* component[remSleep].code = $LOINC#93835-7 "REM sleep duration"
* component[remSleep].valueQuantity only Quantity
* component[remSleep].valueQuantity.system = $UCUM
* component[remSleep].valueQuantity.code = #min
 
* component[lightSleep].code = $LOINC#93836-5 "Light sleep duration"
* component[lightSleep].valueQuantity only Quantity
* component[lightSleep].valueQuantity.system = $UCUM
* component[lightSleep].valueQuantity.code = #min
 
* component[respiratoryRate].code = $LOINC#9279-1 "Respiratory rate"
* component[respiratoryRate].valueQuantity only Quantity
* component[respiratoryRate].valueQuantity.system = $UCUM
* component[respiratoryRate].valueQuantity.code = #/min
 
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity only Quantity
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.code = #ms
 
* component[interruptions].code = $LOINC#93837-3 "Number of awakenings during sleep"
* component[interruptions].valueQuantity only Quantity
* component[interruptions].valueQuantity.system = $UCUM
* component[interruptions].valueQuantity.code = #{count}
* extension contains SleepQuality named quality 0..1
