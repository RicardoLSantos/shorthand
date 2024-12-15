Instance: MindfulnessConfiguration
InstanceOf: StructureDefinition
Usage: #definition
Title: "Mindfulness Module Configuration"
Description: "Configuration settings for the mindfulness module"
* url = "https://example.org/StructureDefinition/mindfulness-config"
* version = "1.0.0"
* name = "MindfulnessConfig"
* status = #draft
* experimental = false
* date = "2024-03-19"
* publisher = "Example Organization"
* kind = #resource
* abstract = false
* type = #Basic
* baseDefinition = "http://hl7.org/fhir/StructureDefinition/Basic"
* derivation = #constraint

* snapshot.element[0]
  * id = "Basic"
  * path = "Basic"
  * definition = "Configuration settings for mindfulness module"

* snapshot.element[+]
  * id = "Basic.extension"
  * path = "Basic.extension"
  * slicing.discriminator.type = #value
  * slicing.discriminator.path = "url"
  * slicing.rules = #open

* snapshot.element[+]
  * id = "Basic.extension:defaultDuration"
  * path = "Basic.extension"
  * sliceName = "defaultDuration"
  * min = 0
  * max = "1"
  * type.code = #Extension
  * definition = "Default duration for mindfulness sessions"

* snapshot.element[+]
  * id = "Basic.extension:reminderSettings"
  * path = "Basic.extension"
  * sliceName = "reminderSettings"
  * min = 0
  * max = "1"
  * type.code = #Extension
  * definition = "Settings for practice reminders"

* snapshot.element[+]
  * id = "Basic.extension:dataSync"
  * path = "Basic.extension"
  * sliceName = "dataSync"
  * min = 0
  * max = "1"
  * type.code = #Extension
  * definition = "Data synchronization settings"

* differential.element[0]
  * id = "Basic"
  * path = "Basic"
  * definition = "Configuration settings for mindfulness module"

* differential.element[+]
  * id = "Basic.extension"
  * path = "Basic.extension"
  * slicing.discriminator.type = #value
  * slicing.discriminator.path = "url"
  * slicing.rules = #open

* differential.element[+]
  * id = "Basic.extension:defaultDuration"
  * path = "Basic.extension"
  * sliceName = "defaultDuration"
  * min = 0
  * max = "1"
  * type.code = #Extension
  * definition = "Default duration for mindfulness sessions"

* differential.element[+]
  * id = "Basic.extension:reminderSettings"
  * path = "Basic.extension"
  * sliceName = "reminderSettings"
  * min = 0
  * max = "1"
  * type.code = #Extension
  * definition = "Settings for practice reminders"

* differential.element[+]
  * id = "Basic.extension:dataSync"
  * path = "Basic.extension"
  * sliceName = "dataSync"
  * min = 0
  * max = "1"
  * type.code = #Extension
  * definition = "Data synchronization settings"

Instance: DefaultMindfulnessConfig
InstanceOf: MindfulnessConfiguration
Usage: #example
Title: "Default Mindfulness Configuration"
* extension[defaultDuration].valueInteger = 20
* extension[reminderSettings].valueBoolean = true
* extension[dataSync].valueBoolean = true
EOL