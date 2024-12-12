Instance: SleepObservationExample1
InstanceOf: SleepObservation
Usage: #example
Title: "Example of Sleep Record"
Description: "Example of nightly sleep data from iOS Health App"
 
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#sleep
* code = $LOINC#93832-4 "Sleep pattern panel"
* subject = Reference(Patient/example)
* effectiveDateTime = "2024-03-19T22:00:00Z"
* effectivePeriod.start = "2024-03-19T22:00:00Z"
* effectivePeriod.end = "2024-03-20T06:30:00Z"
 
* component[timeInBed].code = $LOINC#93831-6 "Time in bed"
* component[timeInBed].valueQuantity = 510 'min' "minutes"
 
* component[totalSleepTime].code = $LOINC#93833-2 "Sleep duration"
* component[totalSleepTime].valueQuantity = 472 'min' "minutes"
 
* component[deepSleep].code = $LOINC#93834-0 "Deep sleep duration"
* component[deepSleep].valueQuantity = 95 'min' "minutes"
 
* component[remSleep].code = $LOINC#93835-7 "REM sleep duration"
* component[remSleep].valueQuantity = 118 'min' "minutes"
 
* component[lightSleep].code = $LOINC#93836-5 "Light sleep duration"
* component[lightSleep].valueQuantity = 259 'min' "minutes"
 
* component[respiratoryRate].code = $LOINC#9279-1 "Respiratory rate"
* component[respiratoryRate].valueQuantity = 14 '/min' "per minute"
 
* component[heartRateVariability].code = $LOINC#80404-7 "Heart rate variability"
* component[heartRateVariability].valueQuantity = 45 'ms' "milliseconds"
 
* component[interruptions].code = $LOINC#93837-3 "Number of awakenings"
* component[interruptions].valueQuantity = 3 '{count}' "count"
