Instance: PractitionerExample
InstanceOf: Practitioner
Usage: #example
Title: "Example Healthcare Provider"
Description: "Example healthcare provider for testing"

* identifier.system = "urn:ietf:rfc:3986"
* identifier.value = "urn:uuid:practitioner-example"
* name.family = "Provider"
* name.given = "Test"
* telecom[0].system = #phone
* telecom[0].value = "+1-555-555-0123"
* telecom[0].use = #work
* gender = #unspecified
* active = true
