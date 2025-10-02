// Originally defined on lines 1 - 9
Extension: AlertTiming
Parent: Extension
Id: alert-timing
Title: "Alert Timing Extension"
Description: "Defines when alerts should be triggered"
* value[x] only Timing
* valueTiming.repeat 1..1
* valueTiming.repeat MS
* valueTiming.repeat.frequency MS
* valueTiming.repeat.period MS
* valueTiming.repeat.periodUnit MS
* extension 0..0

// Originally defined on lines 11 - 15
Extension: AlertMessage
Parent: Extension
Id: alert-message
Title: "Alert Message Extension"
Description: "Defines the alert message content"
* value[x] only string
* extension 0..0

// Originally defined on lines 17 - 28
Profile: MindfulnessAlert
Parent: Basic
Id: mindfulness-alert
Title: "Mindfulness Alert"
Description: "Alert configuration for mindfulness sessions"
* code 1..1
* code MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-alert-type#reminder "Mindfulness Reminder"
* extension contains
    alert-timing named alertTiming 0.. and
    alert-message named alertMessage 0..
* extension[alertTiming] 0..1
* extension[alertTiming] MS
* extension[alertMessage] 1..1
* extension[alertMessage] MS

// Originally defined on lines 30 - 40
Instance: DailyMindfulnessAlert
InstanceOf: MindfulnessAlert
Title: "Daily Mindfulness Alert"
Description: "Example of a daily mindfulness alert configuration"
Usage: #example
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-alert-type#reminder "Mindfulness Reminder"
* extension[alertTiming].valueTiming.repeat
* extension[alertTiming].valueTiming.repeat.frequency = 1
* extension[alertTiming].valueTiming.repeat.period = 1
* extension[alertTiming].valueTiming.repeat.periodUnit = #d
* extension[alertMessage].valueString = "Time for your daily mindfulness practice"

