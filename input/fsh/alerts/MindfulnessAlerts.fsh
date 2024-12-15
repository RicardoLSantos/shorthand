Instance: MindfulnessAlertDefinition
InstanceOf: ActivityDefinition
Usage: #definition
Title: "Mindfulness Practice Reminder Alert"

* status = #active
* experimental = false
* name = "MindfulnessPracticeReminder"
* title = "Mindfulness Practice Reminder"
* description = "Definition for mindfulness practice reminder alerts"
* purpose = "To encourage regular mindfulness practice"
* usage = "Generate reminder notifications for scheduled practice sessions"
* topic[0] = $SCT#711020003 "Meditation"

* timing.repeat
  * frequency = 1
  * period = 1
  * periodUnit = #d
  * timeOfDay = "08:00:00"

Instance: MindfulnessStressAlert
InstanceOf: ActivityDefinition
Usage: #definition
Title: "High Stress Level Alert"

* status = #active
* experimental = false
* name = "StressLevelAlert"
* title = "High Stress Level Alert"
* description = "Alert for elevated stress levels detected during mindfulness sessions"
* purpose = "To identify potentially concerning stress levels"
* usage = "Generate alerts when stress levels exceed threshold"
* topic[0] = $SCT#73595000 "Stress"

* dynamicValue[0]
  * path = "threshold"
  * expression
    * language = #text/fhirpath
    * expression = "component.where(code.coding.code='725854004').value.ofType(integer) > 7"

RuleSet: AlertConfiguration
* extension contains
    alertPriority 1..1 MS and
    alertThreshold 0..1 MS and
    alertFrequency 1..1 MS

* extension[alertPriority].value[x] only code
* extension[alertPriority].valueCode from AlertPriorityVS (required)
* extension[alertThreshold].value[x] only integer
* extension[alertFrequency].value[x] only Timing

RuleSet: NotificationTemplate
* extension contains
    notificationChannel 1..* MS and
    notificationContent 1..1 MS and
    notificationRecipient 1..* MS

* extension[notificationChannel].value[x] only code
* extension[notificationChannel].valueCode from NotificationChannelVS (required)
* extension[notificationContent].value[x] only string
* extension[notificationRecipient].value[x] only Reference(Patient or Practitioner)
