Profile: MindfulnessAlert
Parent: Basic
Id: mindfulness-alert
Title: "Mindfulness Alert"
Description: "Alert configuration for mindfulness sessions"

* code 1..1 MS
* code = http://example.org/CodeSystem/mindfulness-alert-type#reminder "Mindfulness Reminder"

Instance: DailyMindfulnessAlert
InstanceOf: MindfulnessAlert
Title: "Daily Mindfulness Alert" 
Description: "Example of a daily mindfulness alert configuration"

* code = http://example.org/CodeSystem/mindfulness-alert-type#reminder "Mindfulness Reminder"
* extension[alertTiming].valueTiming.repeat.frequency = 1
* extension[alertTiming].valueTiming.repeat.period = 1
* extension[alertTiming].valueTiming.repeat.periodUnit = #d
* extension[alertMessage].valueString = "Time for your daily mindfulness practice"
