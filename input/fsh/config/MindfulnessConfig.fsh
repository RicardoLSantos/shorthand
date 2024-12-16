Profile: MindfulnessConfiguration
Parent: Basic
Id: mindfulness-configuration
Title: "Mindfulness Configuration"
Description: "Configuration settings for mindfulness sessions"

* code 1..1 MS
* code = http://example.org/CodeSystem/mindfulness-config-type#settings "Mindfulness Settings"

* extension contains
    sessionDuration 1..1 MS and
    reminderTime 1..1 MS and
    preferredGuide 0..1 MS and
    notificationEnabled 1..1 MS

Extension: SessionDuration
Id: session-duration
Title: "Session Duration"
Description: "Default duration for mindfulness sessions in minutes"
* value[x] only integer

Extension: ReminderTime
Id: reminder-time
Title: "Reminder Time"
Description: "Default time for daily reminders"
* value[x] only time

Instance: DefaultMindfulnessConfig
InstanceOf: MindfulnessConfiguration
Title: "Default Mindfulness Configuration"
Description: "Default configuration settings for mindfulness sessions"

* code = http://example.org/CodeSystem/mindfulness-config-type#settings "Mindfulness Settings"
* extension[sessionDuration].valueInteger = 15
* extension[reminderTime].valueTime = "08:00:00"
* extension[preferredGuide].valueString = "Jane Smith"
* extension[notificationEnabled].valueBoolean = true

