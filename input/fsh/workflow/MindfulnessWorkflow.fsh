Profile: MindfulnessSchedule
Parent: Schedule
Id: mindfulness-schedule
Title: "Mindfulness Schedule"
Description: "Schedule for recurring mindfulness sessions"

* active 1..1 MS
* serviceType 1..1 MS
* planningHorizon 0..1 MS
* actor 1..* MS

Extension: MindfulnessScheduleTiming
Id: mindfulness-schedule-timing
Title: "Mindfulness Schedule Timing"
Description: "Defines the timing pattern for mindfulness sessions"

* value[x] only Timing
* valueTiming.repeat 1..1
* valueTiming.repeat.frequency 1..1
* valueTiming.repeat.period 1..1
* valueTiming.repeat.periodUnit 1..1
* valueTiming.repeat.dayOfWeek 0..*

Instance: WeeklyMindfulnessSchedule
InstanceOf: MindfulnessSchedule
Title: "Weekly Mindfulness Schedule"
Description: "Example of a weekly mindfulness schedule"

* active = true
* serviceType = http://terminology.hl7.org/CodeSystem/service-type#MH "Mental Health"
* actor[+] = Reference(Patient/example)
* extension[mindfulnessScheduleTiming].valueTiming.repeat
  * frequency = 1
  * period = 1
  * periodUnit = #wk
  * dayOfWeek[0] = #mon
  * dayOfWeek[1] = #wed
  * dayOfWeek[2] = #fri

