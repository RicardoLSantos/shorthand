Extension: MindfulnessContext
Id: mindfulness-context
Title: "Mindfulness Session Context"
Description: "Additional context about the mindfulness practice session"

* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-context"
* ^version = "1.0.0"
* ^status = #draft
* ^date = "2024-03-19"
* ^publisher = "Example Organization"

* extension contains
    location 0..1 and
    environment 0..1 and
    guidance 0..1

* extension[location].value[x] only string
* extension[location].valueString 1..1
* extension[location] ^short = "Physical location of practice"
* extension[location] ^definition = "The physical location where the mindfulness practice took place"

* extension[environment].value[x] only CodeableConcept
* extension[environment].valueCodeableConcept from https://2rdoc.pt/fhir/ValueSet/environment-type (required)
* extension[environment] ^short = "Environmental conditions"
* extension[environment] ^definition = "The environmental conditions during the practice session"

* extension[guidance].value[x] only boolean
* extension[guidance].valueBoolean 1..1
* extension[guidance] ^short = "Whether guidance was used"
* extension[guidance] ^definition = "Indicates if the session was guided or self-directed"
