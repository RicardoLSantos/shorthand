// ============================================================================
// LGPD Regulatory Example Instances
// ============================================================================
// Date: 2026-03-18
// Purpose: Example instances for LGPD Phase 2+3 regulatory profiles
// Covers: OrganizationDataController, PractitionerRoleDPO,
//         TaskDataSubjectRequest, CommunicationSecurityIncident
// Context: PLAN_REGULATORY_LGPD_20260305.md — Phases 2+3
// ============================================================================

Alias: $AppLogicCS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/app-logic-cs
Alias: $OrgType = http://terminology.hl7.org/CodeSystem/organization-type
Alias: $TaskStatus = http://hl7.org/fhir/task-status

// ============================================================================
// Organization: CHUSJ as LGPD Data Controller
// Scenario: Hospital acts as controller for wearable health data processing
// LGPD Art. 5-VI (controlador), Art. 37 (DPO designation), Art. 46 (security)
// ============================================================================

Instance: ExampleOrganizationDataController
InstanceOf: OrganizationDataController
Usage: #example
Title: "Organization: CHUSJ as LGPD Data Controller"
Description: "Example of a healthcare organization (Centro Hospitalar Universitário de São João) acting as LGPD data controller for wearable health data processing in a lifestyle medicine programme."

* identifier[0].system = "urn:oid:2.16.840.1.113883.2.4.6.1"
* identifier[0].value = "CHUSJ-500299170"
* name = "Centro Hospitalar Universitário de São João"
* type = $OrgType#prov
* telecom[0].system = #email
* telecom[0].value = "dpo@chusj.min-saude.pt"
* telecom[0].use = #work
* contact[0].name.text = "Encarregado de Proteção de Dados"
* contact[0].telecom[0].system = #email
* contact[0].telecom[0].value = "dpo@chusj.min-saude.pt"
* address[0].line = "Alameda Prof. Hernâni Monteiro"
* address[0].city = "Porto"
* address[0].postalCode = "4200-319"
* address[0].country = "PT"
* extension[lgpdRegistration].valueString = "ANPD-2026-00145"
* extension[dpoReference].valueReference = Reference(ExamplePractitionerRoleDPO)

// ============================================================================
// PractitionerRole: DPO at CHUSJ
// Scenario: Designated DPO responsible for LGPD compliance
// LGPD Art. 37-38 (encarregado), Art. 41 (DPO responsibilities)
// ============================================================================

Instance: ExamplePractitionerRoleDPO
InstanceOf: PractitionerRoleDPO
Usage: #example
Title: "PractitionerRole: DPO at CHUSJ"
Description: "Example of an LGPD Data Protection Officer (encarregado) designated at CHUSJ, responsible for data subject communications, ANPD liaison, and employee data protection training."

* practitioner = Reference(PractitionerExample)
* organization = Reference(ExampleOrganizationDataController)
* code = $AppLogicCS#lgpd-dpo "Data Protection Officer (Encarregado)"
* specialty[0].text = "Health Data Protection"
* specialty[1].text = "AI Systems Compliance"
* telecom[0].system = #email
* telecom[0].value = "dpo@chusj.min-saude.pt"
* telecom[0].use = #work
* telecom[1].system = #phone
* telecom[1].value = "+351-225-512-100"
* telecom[1].use = #work
* period.start = "2026-01-15"
* active = true

// ============================================================================
// Task: Data Subject Access Request (Art. 18-II)
// Scenario: Patient requests access to all wearable health data
// LGPD Art. 18 (8 rights), Art. 18 §5 (15-day deadline)
// ============================================================================

Instance: ExampleTaskDataSubjectRequest
InstanceOf: TaskDataSubjectRequest
Usage: #example
Title: "Task: LGPD Data Subject Access Request"
Description: "Example of an LGPD Art. 18-II data access request where a patient requests a complete copy of their wearable health data (HRV, sleep, activity) processed by the lifestyle medicine programme. Controller must respond within 15 days."

* status = $TaskStatus#in-progress "In Progress"
* intent = #order
* code = $AppLogicCS#lgpd-right-access "Right to Access (Art. 18-II)"
* for = Reference(PatientExample)
* requester = Reference(PatientExample)
* owner = Reference(ExampleOrganizationDataController)
* authoredOn = "2026-03-10T09:00:00Z"
* lastModified = "2026-03-12T14:30:00Z"
* restriction.period.end = "2026-03-25T23:59:59Z"
* note[0].text = "Patient requests complete copy of all wearable health data (HRV, sleep, physical activity) collected since enrolment in the HEADS lifestyle medicine programme. Request submitted via institutional portal."
* note[0].time = "2026-03-10T09:00:00Z"
* note[1].text = "Request acknowledged. DPO initiated data extraction from FHIR server. Estimated delivery: 2026-03-20."
* note[1].time = "2026-03-12T14:30:00Z"
* extension[anonymizationStatus].valueCodeableConcept = $AppLogicCS#data-pseudonymized "Pseudonymized"

// ============================================================================
// Communication: Security Incident Notification to ANPD (Art. 48)
// Scenario: Unauthorized access to wearable data detected, ANPD notified
// LGPD Art. 48 (notification), Art. 48 §1 (required content)
// ============================================================================

Instance: ExampleCommunicationSecurityIncident
InstanceOf: CommunicationSecurityIncident
Usage: #example
Title: "Communication: LGPD Security Incident Notification"
Description: "Example of an LGPD Art. 48 security incident notification to ANPD after detecting unauthorized access to wearable health data. Includes all 6 required elements per Art. 48, §1."

* status = #completed
* category = $AppLogicCS#security-incident-unauthorized-access "Unauthorized Access"
* subject = Reference(PatientExample)
* sender = Reference(ExampleOrganizationDataController)
* recipient[0].display = "ANPD - Autoridade Nacional de Proteção de Dados"
* sent = "2026-03-15T16:45:00Z"
* payload[0].contentString = "Incident Description (Art. 48, §1-I): On 2026-03-14 at 23:12 UTC, unauthorized access to wearable health data (HRV, sleep metrics) of 3 patients in the HEADS lifestyle medicine programme was detected. Data categories affected: heart rate variability observations, sleep stage recordings, physical activity summaries."
* payload[1].contentString = "Affected Data Subjects (Art. 48, §1-II): 3 patients enrolled in the wearable health monitoring programme. All affected subjects have been individually notified as of 2026-03-15T14:00Z."
* payload[2].contentString = "Security Measures (Art. 48, §1-III): FHIR server access controlled via OAuth 2.0 with SMART on FHIR scopes. Data encrypted at rest (AES-256) and in transit (TLS 1.3). Audit logging via AuditEvent resources per EU AI Act Art. 12."
* payload[3].contentString = "Risks (Art. 48, §1-IV): Low risk of re-identification — data was pseudonymized. No financial or direct clinical harm expected. Risk of correlation with other datasets assessed as minimal."
* payload[4].contentString = "Delay Justification (Art. 48, §1-V): 17-hour delay between detection (2026-03-14T23:12Z) and notification (2026-03-15T16:45Z) due to forensic analysis required to determine scope of access."
* payload[5].contentString = "Mitigation Measures (Art. 48, §1-VI): Compromised API token revoked immediately. All affected patient sessions invalidated. Additional IP-based access restrictions implemented. Full security audit initiated."
* extension[dataImpactLevel].valueCodeableConcept = $AppLogicCS#data-pseudonymized "Pseudonymized"
