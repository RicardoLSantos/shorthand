// ============================================================================
// AuditEvent Data Access Profile
// ============================================================================
// Date: 2026-05-07 (T2 S20 Caminho C — IG v0.3.0 sprint partial)
// Purpose: General-purpose AuditEvent profile for logging data access,
//          disclosure, and modification events under LGPD/GDPR/HIPAA frameworks.
//          Complements AuditEventAIInteraction (which is AI/CDSS-specific).
// Regulatory: GDPR Art. 30 (records of processing activities), Art. 32 (security)
//             LGPD Art. 37 (registro de operações de tratamento)
//             HIPAA Privacy Rule §164.528 (accounting of disclosures)
//             ISO 27799 (health informatics security management)
// ============================================================================
// NOTE (T2 S20): FSH written without IG build validation due to local disk
//                constraint. Pending validation: build via _genonce.sh when
//                disk recovery (Pitfall #65, ≥5GB free) achieved.
// ============================================================================

Profile: AuditEventDataAccess
Parent: AuditEvent
Id: audit-event-data-access
Title: "Audit Event Data Access Profile"
Description: """
Profile for AuditEvent resources that log general data access, disclosure,
and modification events for lifestyle medicine + wearable health data.
Distinct from AuditEventAIInteraction (AI/CDSS-specific) — this profile
covers human-initiated read/write/disclose operations on patient data,
required by GDPR Art. 30 records of processing activities, LGPD Art. 37
operation logs, and HIPAA Privacy Rule §164.528 accounting of disclosures.
"""

* ^experimental = false

// Type — always a security/access audit
* type 1..1 MS
* type from DataAccessAuditTypeVS (extensible)
  * ^short = "Type of access event (read, write, disclose, export)"

// Subtype — granular event classification
* subtype 0..* MS
  * ^short = "Specific operation (e.g., bulk-export, individual-record-read)"

// Action — C/R/U/D/E
* action 1..1 MS
  * ^short = "C=create, R=read, U=update, D=delete, E=execute"

// Period — start to end of access session
* period 0..1 MS
  * ^short = "Duration of the access session (e.g., for bulk export operations)"

// Recorded — when the event was logged
* recorded 1..1 MS

// Outcome — success/failure status
* outcome 1..1 MS
  * ^short = "0=success, 4=minor failure, 8=serious failure, 12=major failure"
* outcomeDesc 0..1 MS

// Purpose of event — required for LGPD/GDPR/HIPAA compliance
* purposeOfEvent 1..* MS
* purposeOfEvent from http://terminology.hl7.org/ValueSet/v3-PurposeOfUse (extensible)
  * ^short = "Purpose of access (treatment, payment, operations, research)"

// Agent slicing — accessor + recipient (for disclosure events)
* agent ^slicing.discriminator.type = #pattern
* agent ^slicing.discriminator.path = "type"
* agent ^slicing.rules = #open
* agent ^slicing.ordered = false
* agent ^slicing.description = "Slice by agent type: accessor (who accessed) vs recipient (who received the data, for disclosures)"
* agent contains
    accessor 1..1 MS and
    recipient 0..* MS

// Accessor agent — who performed the access
* agent[accessor].type 1..1 MS
  * ^short = "Always identifies the human or system actor performing the access"
* agent[accessor].who 1..1 MS
  * ^short = "Reference to Practitioner, Patient, Device, or RelatedPerson"
* agent[accessor].requestor 1..1 MS
  * ^short = "True if accessor initiated the request"

// Recipient agent (for disclosures) — who received the data
* agent[recipient].type 1..1 MS
* agent[recipient].who 1..1 MS
  * ^short = "Reference to recipient (e.g., another Practitioner, Organization, or external system)"
* agent[recipient].requestor 0..1
  * ^short = "Typically false for recipients"

// Source — where the audit was generated
* source 1..1 MS
* source.observer 1..1 MS
  * ^short = "System or device that generated the audit log"
* source.type 1..* MS
  * ^short = "Type of source (4=Application server, 6=Database server)"

// Entity slicing — what was accessed
* entity ^slicing.discriminator.type = #pattern
* entity ^slicing.discriminator.path = "type"
* entity ^slicing.rules = #open
* entity ^slicing.description = "Slice by entity type: patient, observation, document"
* entity contains
    patient 0..* MS and
    accessedResource 1..* MS and
    queryFilter 0..* MS

// Patient entity (data subject)
* entity[patient].what 1..1 MS
  * ^short = "Reference to the Patient whose data was accessed"
* entity[patient].type 1..1 MS
* entity[patient].type = http://terminology.hl7.org/CodeSystem/audit-entity-type#1 "Person"

// Accessed resource entity
* entity[accessedResource].what 1..1 MS
  * ^short = "Reference to the actual resource accessed (Observation, DocumentReference, etc.)"
* entity[accessedResource].role 0..1 MS
  * ^short = "Role of the entity (e.g., 4=Domain resource)"

// Query filter entity (for searches/exports)
* entity[queryFilter].query 1..1 MS
  * ^short = "Encoded query/filter applied (for bulk exports)"
* entity[queryFilter].name 0..1 MS
  * ^short = "Human-readable description of the filter"

// Optional regulatory basis extension (cross-reference to consent)
* extension contains
    RegulatoryBasis named regulatoryBasis 0..* MS

// ============================================================================
// ValueSet — Data Access Audit Types
// ============================================================================

ValueSet: DataAccessAuditTypeVS
Id: data-access-audit-type-vs
Title: "Data Access Audit Event Types"
Description: """
ValueSet of audit event types for general data access events under
GDPR/LGPD/HIPAA compliance regimes.
"""
* ^status = #active
* ^experimental = false

* http://dicom.nema.org/resources/ontology/DCM#110100 "Application Activity"
* http://dicom.nema.org/resources/ontology/DCM#110101 "Audit Log Used"
* http://dicom.nema.org/resources/ontology/DCM#110102 "Begin Transferring DICOM Instances"
* http://dicom.nema.org/resources/ontology/DCM#110106 "Export"
* http://dicom.nema.org/resources/ontology/DCM#110107 "Import"
* http://dicom.nema.org/resources/ontology/DCM#110112 "Query"
* http://dicom.nema.org/resources/ontology/DCM#110113 "Security Alert"
* http://dicom.nema.org/resources/ontology/DCM#110114 "User Authentication"

// ============================================================================
// Example — Bulk export audit
// ============================================================================

Instance: AuditEventBulkExportExample
InstanceOf: AuditEventDataAccess
Title: "AuditEvent Bulk Export Example"
Description: "Example AuditEvent for a research-purpose Bulk FHIR export of cohort data"
Usage: #example

* type = http://dicom.nema.org/resources/ontology/DCM#110106 "Export"
* subtype[0] = http://terminology.hl7.org/CodeSystem/audit-event-type#rest "RESTful Operation"
* action = #E
* recorded = "2026-05-07T15:30:00Z"
* outcome = #0
* purposeOfEvent[0] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"

* agent[accessor].type = http://terminology.hl7.org/CodeSystem/v3-ParticipationType#AUT "author"
* agent[accessor].who.reference = "Practitioner/researcher-001"
* agent[accessor].requestor = true

* source.observer.reference = "Device/lifestyle-medicine-fhir-server"
* source.type = http://terminology.hl7.org/CodeSystem/security-source-type#4 "Application Server"

* entity[queryFilter].query = "R3JvdXAtSWQ9bGlmZXN0eWxlLW1lZC1jb2hvcnQ="
* entity[queryFilter].name = "Lifestyle medicine cohort export filter"
