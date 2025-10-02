Extension: AlertTiming
Id: alert-timing
Title: "Alert Timing Extension"
Description: "Defines when alerts should be triggered"
* value[x] only Timing
* valueTiming.repeat 1..1 MS
* valueTiming.repeat.frequency MS
* valueTiming.repeat.period MS
* valueTiming.repeat.periodUnit MS

Extension: AlertMessage
Id: alert-message
Title: "Alert Message Extension"
Description: "Defines the alert message content"
* value[x] only string

Profile: MindfulnessAlert
Parent: Basic
Id: mindfulness-alert
Title: "Mindfulness Alert"
Description: "Alert configuration for mindfulness sessions"

* code 1..1 MS
* code = https://2rdoc.pt/fhir/CodeSystem/mindfulness-alert-type#reminder "Mindfulness Reminder"

* extension contains
    alert-timing named alertTiming 0..1 MS and
    alert-message named alertMessage 1..1 MS

Instance: DailyMindfulnessAlert
InstanceOf: MindfulnessAlert
Title: "Daily Mindfulness Alert" 
Description: "Example of a daily mindfulness alert configuration"

* code = https://2rdoc.pt/fhir/CodeSystem/mindfulness-alert-type#reminder "Mindfulness Reminder"
* extension[alertTiming].valueTiming.repeat
  * frequency = 1
  * period = 1
  * periodUnit = #d
* extension[alertMessage].valueString = "Time for your daily mindfulness practice"
