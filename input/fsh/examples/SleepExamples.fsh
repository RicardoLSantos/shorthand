Instance: SleepObservationExample1
InstanceOf: SleepObservation
Usage: #example
Description: "Sleep observation example"
Title: "Example of Sleep Record"

* status = #final
* performer = Reference(Practitioner/PractitionerExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-panel "Sleep measurement panel"
* subject = Reference(PatientExample)
* effectivePeriod.start = "2024-03-19T22:00:00Z"
* effectivePeriod.end = "2024-03-20T06:30:00Z"
* device = Reference(DeviceSleepMonitor)
 
* component[timeInBed].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-time-bed "Time in bed"
* component[timeInBed].valueQuantity = 510 'min' "minute"
* component[timeInBed].valueQuantity.system = $UCUM
* component[timeInBed].valueQuantity.unit = "minute"
 
* component[totalSleepTime].code = $LOINC#93832-4 "Sleep duration"
* component[totalSleepTime].valueQuantity = 472 'min' "minute"
* component[totalSleepTime].valueQuantity.system = $UCUM
* component[totalSleepTime].valueQuantity.unit = "minute"
 
* component[deepSleep].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-deep "Deep sleep duration"
* component[deepSleep].valueQuantity = 95 'min' "minute"
* component[deepSleep].valueQuantity.system = $UCUM
* component[deepSleep].valueQuantity.unit = "minute"
 
* component[remSleep].code = $LOINC#93829-0 "REM sleep duration"
* component[remSleep].valueQuantity = 118 'min' "minute"
* component[remSleep].valueQuantity.system = $UCUM
* component[remSleep].valueQuantity.unit = "minute"
 
* component[lightSleep].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-light "Light sleep duration"
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
 
* component[interruptions].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-awakenings "Number of sleep awakenings"
* component[interruptions].valueQuantity = 3 '1' "count"
* component[interruptions].valueQuantity.system = $UCUM
* component[interruptions].valueQuantity.unit = "count"

// Extensions
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/circadian-phase"
* extension[=].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/circadian-phase-cs#night "Night Phase"
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/recovery-efficiency"
* extension[=].valueQuantity = 85 '%' "percent"
// UPDATED 2026-01-09: Use new SleepQualityCS instead of incorrect SNOMED code
* extension[+].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/sleep-quality"
* extension[=].valueCodeableConcept = SleepQualityCS#good "Good sleep quality"

Instance: DeviceSleepMonitor
InstanceOf: Device
Usage: #example
Description: "Sleep monitor device example"
Title: "Sleep Monitoring Device"
* deviceName.name = "Sleep Quality Monitor"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "SQM-2024"
* type = $LIFESTYLEOBS#sleep-monitoring-device "Sleep monitoring device"
