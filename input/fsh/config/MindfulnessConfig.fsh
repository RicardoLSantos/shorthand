Profile: MindfulnessConfiguration
Parent: Basic
Id: mindfulness-configuration
Title: "Mindfulness Configuration"
Description: "Configuration settings for mindfulness sessions"

* extension contains
    sessionDuration 0..1 MS and
    reminderTime 0..1 MS and
    preferredGuide 0..1 MS

Instance: MindfulnessConfigExample
InstanceOf: MindfulnessConfiguration 
Usage: #example
Title: "Example Mindfulness Configuration"
Description: "Example configuration settings for mindfulness sessions"

* extension[sessionDuration].valueInteger = 15
* extension[reminderTime].valueTime = "08:00:00"
* extension[preferredGuide].valueString = "Jane Smith"

