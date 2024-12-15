Profile: MindfulnessConfiguration
Parent: Basic
Id: mindfulness-config
Title: "Mindfulness Module Configuration"
Description: "Configuration settings for the mindfulness module"

* extension contains
    DefaultDuration named defaultDuration 0..1 and
    ReminderSettings named reminderSettings 0..1 and
    DataSync named dataSync 0..1

Extension: DefaultDuration
* value[x] only integer
* valueInteger 0..1

Extension: ReminderSettings
* value[x] only boolean
* valueBoolean 0..1

Extension: DataSync
* value[x] only boolean
* valueBoolean 0..1

Instance: DefaultMindfulnessConfig
InstanceOf: MindfulnessConfiguration
Usage: #example
Title: "Default Mindfulness Configuration"
* extension[defaultDuration].valueInteger = 20
* extension[reminderSettings].valueBoolean = true
* extension[dataSync].valueBoolean = true
EOL