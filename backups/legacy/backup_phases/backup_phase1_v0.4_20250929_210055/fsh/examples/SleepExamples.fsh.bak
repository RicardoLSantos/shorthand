Instance: SleepObservationExample1
InstanceOf: SleepObservation
Usage: #example
Description: "Sleep observation example"
Title: "Example of Sleep Record"
 
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $LOINC#93832-4 "Sleep pattern panel"
* subject = Reference(PatientExample)
* effectivePeriod.start = "2024-03-19T22:00:00Z"
* effectivePeriod.end = "2024-03-20T06:30:00Z"
* device = Reference(DeviceSleepMonitor)
 
* component[timeInBed].code = $LOINC#93831-6 "Time in bed"
* component[timeInBed].valueQuantity = 510 'min' "minute"
* component[timeInBed].valueQuantity.system = $UCUM
* component[timeInBed].valueQuantity.unit = "minute"
 
* component[totalSleepTime].code = $LOINC#93833-2 "Sleep duration"
* component[totalSleepTime].valueQuantity = 472 'min' "minute"
* component[totalSleepTime].valueQuantity.system = $UCUM
* component[totalSleepTime].valueQuantity.unit = "minute"
 
* component[deepSleep].code = $LOINC#93834-0 "Deep activity duration"
* component[deepSleep].valueQuantity = 95 'min' "minute"
* component[deepSleep].valueQuantity.system = $UCUM
* component[deepSleep].valueQuantity.unit = "minute"
 
* component[remSleep].code = $LOINC#93835-7 "REM activity duration"
* component[remSleep].valueQuantity = 118 'min' "minute"
* component[remSleep].valueQuantity.system = $UCUM
* component[remSleep].valueQuantity.unit = "minute"
 
* component[lightSleep].code = $LOINC#93836-5 "Light activity duration"
* component[lightSleep].valueQuantity = 259 'min' "minute"
* component[lightSleep].valueQuantity.system = $UCUM
* component[lightSleep].valueQuantity.unit = "minute"
 
* component[respiratoryRate].code = $LOINC#9279-1 "Respiratory rate"
* component[respiratoryRate].valueQuantity = 14 '/min' "per minute"
* component[respiratoryRate].valueQuantity.system = $UCUM
* component[respiratoryRate].valueQuantity.unit = "per minute"
 
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity = 45 'ms' "millisecond"
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.unit = "millisecond"
 
* component[interruptions].code = $LOINC#93837-3 "Number of awakenings during activity"
* component[interruptions].valueQuantity = 3 '{count}' "count"
* component[interruptions].valueQuantity.system = $UCUM
* component[interruptions].valueQuantity.unit = "count"

Instance: DeviceSleepMonitor
InstanceOf: Device
Usage: #example
Description: "Sleep monitor device example"
Title: "Sleep Monitoring Device"
* deviceName.name = "Sleep Quality Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "SQM-2024"
* type = $SCT#706172001 "Sleep monitor"
