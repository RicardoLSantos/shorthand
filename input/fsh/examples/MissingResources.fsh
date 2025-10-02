// ====== Recursos Faltantes para Resolver Links Quebrados ======

Instance: example
InstanceOf: Patient
Usage: #example
Description: "Example patient instance for demonstration purposes"
* identifier.system = "http://example.org/patients"
* identifier.value = "example-patient"
* name.family = "Example"
* name.given = "Patient"
* gender = #unknown
* birthDate = "1970-01-01"

Instance: osa-practitioner-kyle-anydoc
InstanceOf: Practitioner
Usage: #example
Description: "Example practitioner for OSA-related care scenarios"
* identifier.system = "http://example.org/practitioners"
* identifier.value = "kyle-anydoc"
* name.family = "Anydoc"
* name.given = "Kyle"
* name.prefix = "Dr."

Instance: PatientMindfulness
InstanceOf: Patient
Usage: #example
Description: "Example patient for mindfulness-related scenarios and consent examples"
* identifier.system = "http://example.org/patients"
* identifier.value = "mindfulness-patient"
* name.family = "Mindfulness"
* name.given = "Test"
* gender = #other
* birthDate = "1980-01-01"

Instance: Org2RDoc
InstanceOf: Organization
Usage: #example
Description: "2RDoc organization instance for consent and data governance examples"
* identifier.system = "http://example.org/organizations"
* identifier.value = "2rdoc"
* name = "2RDoc Healthcare Solutions"
* active = true
