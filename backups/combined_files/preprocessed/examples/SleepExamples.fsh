// Originally defined on lines 1 - 53
Instance: SleepObservationExample1
InstanceOf: SleepObservation
Title: "Example of Sleep Record"
Description: "Sleep observation example"
Usage: #example
* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = http://loinc.org#93832-4 "Sleep pattern panel"
* subject = Reference(PatientExample)
* effectivePeriod.start = "2024-03-19T22:00:00Z"
* effectivePeriod.end = "2024-03-20T06:30:00Z"
* device = Reference(DeviceSleepMonitor)
* component[timeInBed].code = http://loinc.org#93831-6 "Time in bed"
* component[timeInBed].valueQuantity = 510 'min' "minute"
* component[timeInBed].valueQuantity.system = "http://unitsofmeasure.org"
* component[timeInBed].valueQuantity.unit = "minute"
* component[totalSleepTime].code = http://loinc.org#93833-2 "Sleep duration"
* component[totalSleepTime].valueQuantity = 472 'min' "minute"
* component[totalSleepTime].valueQuantity.system = "http://unitsofmeasure.org"
* component[totalSleepTime].valueQuantity.unit = "minute"
* component[deepSleep].code = http://loinc.org#93834-0 "Deep activity duration"
* component[deepSleep].valueQuantity = 95 'min' "minute"
* component[deepSleep].valueQuantity.system = "http://unitsofmeasure.org"
* component[deepSleep].valueQuantity.unit = "minute"
* component[remSleep].code = http://loinc.org#93835-7 "REM activity duration"
* component[remSleep].valueQuantity = 118 'min' "minute"
* component[remSleep].valueQuantity.system = "http://unitsofmeasure.org"
* component[remSleep].valueQuantity.unit = "minute"
* component[lightSleep].code = http://loinc.org#93836-5 "Light activity duration"
* component[lightSleep].valueQuantity = 259 'min' "minute"
* component[lightSleep].valueQuantity.system = "http://unitsofmeasure.org"
* component[lightSleep].valueQuantity.unit = "minute"
* component[respiratoryRate].code = http://loinc.org#9279-1 "Respiratory rate"
* component[respiratoryRate].valueQuantity = 14 '/min' "per minute"
* component[respiratoryRate].valueQuantity.system = "http://unitsofmeasure.org"
* component[respiratoryRate].valueQuantity.unit = "per minute"
* component[heartRateVariability].code = http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity = 45 'ms' "millisecond"
* component[heartRateVariability].valueQuantity.system = "http://unitsofmeasure.org"
* component[heartRateVariability].valueQuantity.unit = "millisecond"
* component[interruptions].code = http://loinc.org#93837-3 "Number of awakenings during activity"
* component[interruptions].valueQuantity = 3 '{count}' "count"
* component[interruptions].valueQuantity.system = "http://unitsofmeasure.org"
* component[interruptions].valueQuantity.unit = "count"

// Originally defined on lines 55 - 64
Instance: DeviceSleepMonitor
InstanceOf: Device
Title: "Sleep Monitoring Device"
Description: "Sleep monitor device example"
Usage: #example
* deviceName.name = "Sleep Quality Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "SQM-2024"
* type = http://snomed.info/sct#706172001 "Sleep monitor"

