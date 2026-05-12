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

// ============================================================================
// Stubs added 2026-05-12 (T2 S21) — Bulk Export / AuditEvent example references
// ============================================================================
// These stub resources satisfy reference-resolution validation in:
//   - BulkExportConsentHRVResearchExample (BulkExportConsent.fsh)
//   - BulkExportGroupHRVDeclineExample    (BulkExportGroup.fsh)
//   - AuditEventBulkExportExample          (AuditEventDataAccess.fsh)
// Minimal valid FHIR R4 instances; production servers replace with real data.
// ============================================================================

Instance: example-patient-001
InstanceOf: Patient
Usage: #example
Description: "Example patient for bulk export research consent demonstrations"
* identifier.system = "http://example.org/patients"
* identifier.value = "example-patient-001"
* name.family = "Doe"
* name.given = "Jane"
* gender = #female
* birthDate = "1980-03-15"

Instance: researcher-001
InstanceOf: Practitioner
Usage: #example
Description: "Example research practitioner accessing bulk-export cohort data"
* identifier.system = "http://example.org/practitioners"
* identifier.value = "researcher-001"
* name.family = "Researcher"
* name.given = "Anna"
* name.prefix = "Dr."
* active = true

Instance: researcher-pi-001
InstanceOf: Practitioner
Usage: #example
Description: "Example Principal Investigator for HRV-decline research cohort"
* identifier.system = "http://example.org/practitioners"
* identifier.value = "researcher-pi-001"
* name.family = "Investigator"
* name.given = "Carlos"
* name.prefix = "Prof. Dr."
* active = true

Instance: lifestyle-medicine-fhir-server
InstanceOf: Device
Usage: #example
Description: "Example FHIR server device that emitted bulk-export audit events"
* identifier.system = "http://example.org/devices"
* identifier.value = "lifestyle-medicine-fhir-server"
* status = #active
* deviceName.name = "Lifestyle Medicine FHIR Server"
* deviceName.type = #model-name
* manufacturer = "2RDoc"

Instance: lifestyle-med-cohort
InstanceOf: Group
Usage: #example
Description: "Example cohort referenced by an AuditEvent.entity for bulk-export"
* type = #person
* actual = false
* active = true
* name = "Lifestyle Medicine Demonstration Cohort"
* code = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"
* quantity = 100

Instance: research-org-fmup
InstanceOf: Organization
Usage: #example
Description: "Example sponsoring research organization (FMUP) for bulk-export consent"
* identifier.system = "http://example.org/organizations"
* identifier.value = "research-org-fmup"
* name = "Faculdade de Medicina da Universidade do Porto - Research Office"
* active = true
