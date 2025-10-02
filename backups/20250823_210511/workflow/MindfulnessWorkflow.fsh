Profile: MindfulnessSchedule
Parent: Basic
Id: mindfulness-schedule
Title: "Mindfulness Schedule"
Description: "Schedule configuration for mindfulness sessions"

* code 1..1 MS
* code = https://2rdoc.pt/fhir/CodeSystem/mindfulness-schedule-type#recurring "Recurring Schedule"

Extension: MindfulnessScheduleTiming
Id: mindfulness-schedule-timing
Title: "Mindfulness Schedule Timing"
Description: "Timing configuration for mindfulness sessions"
* value[x] only Timing

Instance: WeeklyMindfulnessSchedule
InstanceOf: MindfulnessSchedule
Title: "Weekly Mindfulness Schedule"
Description: "Example of a weekly mindfulness schedule"

* code = https://2rdoc.pt/fhir/CodeSystem/mindfulness-schedule-type#recurring "Recurring Schedule"
* extension[mindfulness-schedule-timing].valueTiming.repeat.frequency = 1
* extension[mindfulness-schedule-timing].valueTiming.repeat.period = 1
* extension[mindfulness-schedule-timing].valueTiming.repeat.periodUnit = #wk
* extension[mindfulness-schedule-timing].valueTiming.repeat.dayOfWeek = #mon
* extension[mindfulness-schedule-timing].valueTiming.repeat.dayOfWeek[+] = #wed
* extension[mindfulness-schedule-timing].valueTiming.repeat.dayOfWeek[+] = #fri
