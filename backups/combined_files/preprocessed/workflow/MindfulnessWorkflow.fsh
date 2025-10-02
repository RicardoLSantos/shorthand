// Originally defined on lines 1 - 8
Profile: MindfulnessSchedule
Parent: Basic
Id: mindfulness-schedule
Title: "Mindfulness Schedule"
Description: "Schedule configuration for mindfulness sessions"
* code 1..1
* code MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-schedule-type#recurring "Recurring Schedule"

// Originally defined on lines 10 - 14
Extension: MindfulnessScheduleTiming
Parent: Extension
Id: mindfulness-schedule-timing
Title: "Mindfulness Schedule Timing"
Description: "Timing configuration for mindfulness sessions"
* value[x] only Timing
* extension 0..0

// Originally defined on lines 16 - 27
Instance: WeeklyMindfulnessSchedule
InstanceOf: MindfulnessSchedule
Title: "Weekly Mindfulness Schedule"
Description: "Example of a weekly mindfulness schedule"
Usage: #example
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-schedule-type#recurring "Recurring Schedule"
* extension[mindfulness-schedule-timing].valueTiming.repeat.frequency = 1
* extension[mindfulness-schedule-timing].valueTiming.repeat.period = 1
* extension[mindfulness-schedule-timing].valueTiming.repeat.periodUnit = #wk
* extension[mindfulness-schedule-timing].valueTiming.repeat.dayOfWeek = #mon
* extension[mindfulness-schedule-timing].valueTiming.repeat.dayOfWeek[0] = #wed
* extension[mindfulness-schedule-timing].valueTiming.repeat.dayOfWeek[1] = #fri

