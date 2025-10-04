// Originally defined on lines 3 - 11
Instance: example
InstanceOf: Patient
Usage: #example
* identifier.system = "http://example.org/patients"
* identifier.value = "example-patient"
* name.family = "Example"
* name.given = "Patient"
* gender = #unknown
* birthDate = "1970-01-01"

// Originally defined on lines 13 - 20
Instance: osa-practitioner-kyle-anydoc
InstanceOf: Practitioner
Usage: #example
* identifier.system = "http://example.org/practitioners"
* identifier.value = "kyle-anydoc"
* name.family = "Anydoc"
* name.given = "Kyle"
* name.prefix = "Dr."

// Originally defined on lines 22 - 30
Instance: PatientMindfulness
InstanceOf: Patient
Usage: #example
* identifier.system = "http://example.org/patients"
* identifier.value = "mindfulness-patient"
* name.family = "Mindfulness"
* name.given = "Test"
* gender = #other
* birthDate = "1980-01-01"

// Originally defined on lines 32 - 38
Instance: Org2RDoc
InstanceOf: Organization
Usage: #example
* identifier.system = "http://example.org/organizations"
* identifier.value = "2rdoc"
* name = "2RDoc Healthcare Solutions"
* active = true

