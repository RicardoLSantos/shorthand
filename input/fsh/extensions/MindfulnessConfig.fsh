Extension: MindfulnessSessionDuration
Id: mindfulness-session-duration
Title: "Mindfulness Session Duration"
Description: "Default duration for mindfulness sessions in minutes"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only integer

Extension: MindfulnessReminderTime
Id: mindfulness-reminder-time
Title: "Mindfulness Reminder Time"
Description: "Default time for daily reminders"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only time

Extension: MindfulnessPreferredGuide
Id: mindfulness-preferred-guide
Title: "Mindfulness Preferred Guide"
Description: "Preferred guide for mindfulness sessions"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only string

Extension: MindfulnessNotificationEnabled
Id: mindfulness-notification-enabled
Title: "Mindfulness Notification Enabled"
Description: "Whether notifications are enabled for mindfulness sessions"
* ^context[0].type = #element
* ^context[0].expression = "Basic"
* value[x] only boolean

Profile: MindfulnessConfiguration
Parent: Basic
Id: mindfulness-configuration
Title: "Mindfulness Configuration"
Description: "Configuration settings for mindfulness sessions"

* code 1..1 MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mindfulness-config-settings "Mindfulness Settings"

* extension contains
    MindfulnessSessionDuration named sessionDuration 1..1 MS and
    MindfulnessReminderTime named reminderTime 1..1 MS and
    MindfulnessPreferredGuide named preferredGuide 0..1 MS and
    MindfulnessNotificationEnabled named notificationEnabled 1..1 MS

Instance: DefaultMindfulnessConfig
InstanceOf: MindfulnessConfiguration
Title: "Default Mindfulness Configuration"
Description: "Default configuration settings for mindfulness sessions"

* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#mindfulness-config-settings "Mindfulness Settings"
* extension[sessionDuration].valueInteger = 15
* extension[reminderTime].valueTime = "08:00:00"
* extension[preferredGuide].valueString = "Jane Smith"
* extension[notificationEnabled].valueBoolean = true
