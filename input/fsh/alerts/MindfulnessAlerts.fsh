Profile: MindfulnessAlert
Parent: Basic
Id: mindfulness-alert
Title: "Mindfulness Alert"
Description: "Alert configuration for mindfulness sessions"

* extension contains
    alertTiming 0..1 MS and
    alertMessage 1..1 MS

Extension: AlertTiming
Id: alert-timing
Title: "Alert Timing Extension"
Description: "Defines when alerts should be triggered"

* value[x] only Timing
* valueTiming.repeat 1..1
* valueTiming.repeat.frequency 1..1
* valueTiming.repeat.period 1..1
* valueTiming.repeat.periodUnit 1..1
* valueTiming.repeat.timeOfDay 0..*

Instance: DailyMindfulnessAlert
InstanceOf: MindfulnessAlert
Title: "Daily Mindfulness Alert"
Description: "Example of a daily mindfulness alert configuration"

* extension[alertTiming].valueTiming.repeat
  * frequency = 1
  * period = 1
  * periodUnit = #d
  * timeOfDay = "09:00:00"
* extension[alertMessage].valueString = "Time for your daily mindfulness practice"

