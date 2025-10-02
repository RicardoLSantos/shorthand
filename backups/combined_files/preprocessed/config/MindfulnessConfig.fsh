// Originally defined on lines 1 - 5
Extension: MindfulnessSessionDuration
Parent: Extension
Id: mindfulness-session-duration
Title: "Mindfulness Session Duration"
Description: "Default duration for mindfulness sessions in minutes"
* value[x] only integer
* extension 0..0

// Originally defined on lines 7 - 11
Extension: MindfulnessReminderTime
Parent: Extension
Id: mindfulness-reminder-time
Title: "Mindfulness Reminder Time"
Description: "Default time for daily reminders"
* value[x] only time
* extension 0..0

// Originally defined on lines 13 - 17
Extension: MindfulnessPreferredGuide
Parent: Extension
Id: mindfulness-preferred-guide
Title: "Mindfulness Preferred Guide"
Description: "Preferred guide for mindfulness sessions"
* value[x] only string
* extension 0..0

// Originally defined on lines 19 - 23
Extension: MindfulnessNotificationEnabled
Parent: Extension
Id: mindfulness-notification-enabled
Title: "Mindfulness Notification Enabled"
Description: "Whether notifications are enabled for mindfulness sessions"
* value[x] only boolean
* extension 0..0

// Originally defined on lines 25 - 38
Profile: MindfulnessConfiguration
Parent: Basic
Id: mindfulness-configuration
Title: "Mindfulness Configuration"
Description: "Configuration settings for mindfulness sessions"
* code 1..1
* code MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-config-type#settings "Mindfulness Settings"
* extension contains
    MindfulnessSessionDuration named sessionDuration 0.. and
    MindfulnessReminderTime named reminderTime 0.. and
    MindfulnessPreferredGuide named preferredGuide 0.. and
    MindfulnessNotificationEnabled named notificationEnabled 0..
* extension[sessionDuration] 1..1
* extension[sessionDuration] MS
* extension[reminderTime] 1..1
* extension[reminderTime] MS
* extension[preferredGuide] 0..1
* extension[preferredGuide] MS
* extension[notificationEnabled] 1..1
* extension[notificationEnabled] MS

// Originally defined on lines 40 - 49
Instance: DefaultMindfulnessConfig
InstanceOf: MindfulnessConfiguration
Title: "Default Mindfulness Configuration"
Description: "Default configuration settings for mindfulness sessions"
Usage: #example
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-config-type#settings "Mindfulness Settings"
* extension[sessionDuration].valueInteger = 15
* extension[reminderTime].valueTime = "08:00:00"
* extension[preferredGuide].valueString = "Jane Smith"
* extension[notificationEnabled].valueBoolean = true

