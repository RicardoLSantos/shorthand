// ============================================================================
// Patient Data Pipeline CapabilityStatement
// ============================================================================
// Date: 2026-05-19 (T2 S25 — Tier 1B Profile #3 / G2 antecedent)
// Purpose: Declare server-side capabilities for FHIR-based wearable data
//          ingestion pipelines. Specializes for ETL endpoints accepting
//          Bundle.type=batch payloads conforming to LifestyleMedicineETLBatch
//          (Profile #1, T2 S24) with explicit rate-limiting + retry +
//          error-reporting semantics for vendor API integration.
// Reference:
//   - FHIR R4 CapabilityStatement: https://hl7.org/fhir/R4/capabilitystatement.html
//   - LifestyleMedicineETLBatch Profile #1: T2 S24 (15 May 2026)
//   - WearableMeasurementProvenance Profile #2: T2 S24
//   - RFC 6585 §4 (rate limiting): https://datatracker.ietf.org/doc/html/rfc6585
//   - RFC 7231 §7.1.3 (Retry-After): https://datatracker.ietf.org/doc/html/rfc7231#section-7.1.3
// Companion:
//   - LifestyleMedicineCapabilityStatement.fsh — full server capabilities (12 resources)
//   - SMARTOnFHIRConformance.fsh — SMART STU2.2 OAuth auth declaration
//   - This Instance complements both with pipeline-specific declarations.
// G2 RS antecedent: RS4 (Living SR methodology), RS13 (FHIRconnect implementation).
// Convention: follows existing `capabilities/` folder pattern (Instance pattern,
//             NOT Profile pattern, per LMCapStmt + SMART + Mindfulness precedent).
// ============================================================================

// ============================================================================
// CapabilityStatement: Patient Data Pipeline Server
// ============================================================================

Instance: PatientDataPipelineCapability
InstanceOf: CapabilityStatement
Usage: #definition
Title: "Patient Data Pipeline CapabilityStatement"
Description: """
CapabilityStatement declaring server-side capabilities for FHIR-based wearable
data ingestion pipelines. Servers conforming to this declaration accept
Bundle.type=batch payloads conforming to LifestyleMedicineETLBatch profile,
process entries through validation + de-duplication + persistence pipelines,
and emit AuditEvent + Provenance records per the iOS Lifestyle Medicine IG
conformance requirements.

This declaration complements:
  - LifestyleMedicineCapabilityStatement.fsh (full IG server capabilities)
  - SMARTOnFHIRConformance.fsh (SMART STU2.2 auth conformance)

Pipeline-specific behavior is declared via 3 dedicated Extensions on
rest level: pipeline-rate-limit, pipeline-retry-semantics, pipeline-error-reporting.
"""

* status = #active
* date = "2026-05-19"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[1] = #xml
* implementationGuide = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ImplementationGuide/iOS-Lifestyle-Medicine"

* rest[0]
  * mode = #server
  * documentation = "Patient data pipeline FHIR R4 server accepting Bundle.type=batch payloads from vendor wearable API ETL transformations. Rate-limit + retry semantics declared via dedicated Extensions."

  // ========================================================================
  // Pipeline-specific Extensions on rest level
  // ========================================================================
  * extension[0]
    * url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/pipeline-rate-limit"
    * valueQuantity.value = 10
    * valueQuantity.unit = "requests/s"
    * valueQuantity.system = "http://unitsofmeasure.org"
    * valueQuantity.code = #1/s

  * extension[1]
    * url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/pipeline-retry-semantics"
    * valueString = "exponential-backoff-3-max"

  * extension[2]
    * url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/pipeline-error-reporting"
    * valueUrl = "https://2rdoc.pt/api/pipeline/errors"

  // ========================================================================
  // Bundle — accepts ETL batch payloads (Profile #1 LifestyleMedicineETLBatch)
  // ========================================================================
  * resource[0]
    * type = #Bundle
    * documentation = "Server accepts Bundle.type=batch payloads conforming to LifestyleMedicineETLBatch profile. Each batch contains 1 PGHDProvenance entry (run-level) + 1 Device entry (source device) + 0..* Observation entries + 0..1 AuditEvent entry."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/lifestyle-medicine-etl-batch"
    * interaction[0].code = #create
    * interaction[1].code = #read
    * interaction[2].code = #search-type
    * searchParam[0]
      * name = "identifier"
      * type = #token
      * documentation = "Search by ETL run identifier (Bundle.identifier with system https://2rdoc.pt/.../identifier/etl-run-id)"
    * searchParam[1]
      * name = "type"
      * type = #token
      * documentation = "Search by Bundle.type (=batch for pipeline endpoints)"
    * searchParam[2]
      * name = "timestamp"
      * type = #date
      * documentation = "Search by Bundle.timestamp (when batch was assembled)"

  // ========================================================================
  // Observation — pipeline output (entries from extracted Bundle)
  // ========================================================================
  * resource[1]
    * type = #Observation
    * documentation = "Pipeline server materializes Observation entries from incoming Bundle.entry[observations]. Provenance + AuditEvent are populated automatically by the pipeline. Supports search by patient + date + code + source device for downstream consumers."
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
    * searchParam[1]
      * name = "date"
      * type = #date
    * searchParam[2]
      * name = "device"
      * type = #reference
    * searchParam[3]
      * name = "code"
      * type = #token

  // ========================================================================
  // Provenance — per-Observation provenance (Profile #2)
  // ========================================================================
  * resource[2]
    * type = #Provenance
    * documentation = "Pipeline server creates 1 Provenance per Observation (per Profile #2 WearableMeasurementProvenance) capturing firmware version + time of measurement + time of upload + transformation lineage. Run-level Provenance (Profile #1 entry[etlProvenance]) is also indexed for ETL batch auditability."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/wearable-measurement-provenance"
    * supportedProfile[1] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/PGHDProvenance"
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0]
      * name = "target"
      * type = #reference
    * searchParam[1]
      * name = "recorded"
      * type = #date
    * searchParam[2]
      * name = "agent"
      * type = #reference

  // ========================================================================
  // Device — source wearable device (Apple Watch, Fitbit, Garmin, etc.)
  // ========================================================================
  * resource[3]
    * type = #Device
    * documentation = "Pipeline server creates Device records for each vendor device emitting batch payloads (1 Device per Bundle.entry[batchDevice]). Device.identifier carries the vendor-specific device serial."
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0]
      * name = "manufacturer"
      * type = #string
    * searchParam[1]
      * name = "model"
      * type = #string
    * searchParam[2]
      * name = "identifier"
      * type = #token

  // ========================================================================
  // Patient — subject of the pipeline-ingested observations
  // ========================================================================
  * resource[4]
    * type = #Patient
    * documentation = "Pipeline server requires the subject Patient to exist before ETL ingestion. Used as reference target for Observation.subject + Provenance.target. Created via separate Patient-management workflow."
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0]
      * name = "_id"
      * type = #token
    * searchParam[1]
      * name = "identifier"
      * type = #token

  // ========================================================================
  // AuditEvent — pipeline audit trail (optional per-batch + per-Observation)
  // ========================================================================
  * resource[5]
    * type = #AuditEvent
    * documentation = "Pipeline server emits AuditEvent records per AuditEventDataAccess profile for each batch ingestion event. Indexed for compliance auditing (LGPD Art. 37, GDPR Art. 30) + EU AI Act Art. 12 (record-keeping for AI systems processing health data)."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/audit-event-data-access"
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0]
      * name = "date"
      * type = #date
    * searchParam[1]
      * name = "patient"
      * type = #reference
    * searchParam[2]
      * name = "agent"
      * type = #reference

  // ========================================================================
  // Security — SMART scopes for pipeline endpoints
  // ========================================================================
  * security
    * cors = true
    * service[0] = http://terminology.hl7.org/CodeSystem/restful-security-service#SMART-on-FHIR "SMART-on-FHIR"
    * service[0].text = "SMART on FHIR App Launch STU2.2 with system-level scopes for backend ETL clients"
    * description = """
      Pipeline endpoints require SMART backend service authentication with
      `system/*.cruds` scope for Bundle.type=batch POSTing. Patient-facing
      apps may use `patient/*.rs` scope for downstream Observation reading.
      See LifestyleMedicineSMARTCapabilityStatement for full auth details.
    """

// ============================================================================
// Extension: Pipeline Rate Limit
// ============================================================================

Extension: PipelineRateLimit
Id: pipeline-rate-limit
Title: "Pipeline Rate Limit Extension"
Description: """
Maximum throughput (requests per unit time) the pipeline server accepts from
a single client. Conforms to RFC 6585 §4 (HTTP 429 Too Many Requests) rate
limiting semantics. Clients exceeding the limit receive HTTP 429 with optional
Retry-After header per the pipeline-retry-semantics extension.

Used as a hint for vendor API integrators to throttle outbound requests in
their ETL pipeline before hitting server-side rate limiting.
"""
* ^context.type = #element
* ^context.expression = "CapabilityStatement.rest"

* value[x] only Quantity
* valueQuantity 1..1 MS
* valueQuantity.value 1..1 MS
* valueQuantity.unit 1..1 MS
* valueQuantity.system 1..1 MS
* valueQuantity.code 1..1 MS

// ============================================================================
// Extension: Pipeline Retry Semantics
// ============================================================================

Extension: PipelineRetrySemantics
Id: pipeline-retry-semantics
Title: "Pipeline Retry Semantics Extension"
Description: """
Retry strategy for transient failures (HTTP 429, 502, 503, 504) when posting
Bundle.type=batch payloads to this pipeline server. Clients SHOULD honor
the declared semantics to avoid amplifying server load during incidents.

Recommended string values (free-form for v0.4.0; may be promoted to a
CodeSystem in v0.5.0 if interoperability friction observed):
  - "no-retry" — Single attempt; failures are reported immediately
  - "linear-3-max" — Linear backoff (e.g., 5s between attempts), max 3 retries
  - "linear-5-max" — Linear backoff, max 5 retries
  - "exponential-backoff-3-max" — Exponential (2^n seconds), max 3 retries
  - "exponential-backoff-5-max" — Exponential, max 5 retries
  - "retry-after-aware" — Honor server Retry-After header (RFC 7231 §7.1.3)
"""
* ^context.type = #element
* ^context.expression = "CapabilityStatement.rest"

* value[x] only string
* valueString 1..1 MS

// ============================================================================
// Extension: Pipeline Error Reporting
// ============================================================================

Extension: PipelineErrorReporting
Id: pipeline-error-reporting
Title: "Pipeline Error Reporting Endpoint Extension"
Description: """
URL of the OperationOutcome endpoint where pipeline failure notifications are
emitted. Clients may query this endpoint to retrieve detailed error reports
for batches that failed validation or ingestion. AuditEvent records of pipeline
failures are also indexed at this endpoint per AuditEventDataAccess profile.

The endpoint MUST conform to FHIR R4 OperationOutcome resource semantics
(OperationOutcome resource) and SHOULD support OAuth 2.0 authorization with
system/AuditEvent.rs + system/OperationOutcome.rs scopes per
SMARTOnFHIRConformance.fsh.
"""
* ^context.type = #element
* ^context.expression = "CapabilityStatement.rest"

* value[x] only url
* valueUrl 1..1 MS

// ============================================================================
// Example: Apple HealthKit Pipeline Server Declaration
// ============================================================================

Instance: PatientDataPipelineCapabilityAppleHealthKitExample
InstanceOf: CapabilityStatement
Usage: #example
Title: "Patient Data Pipeline Capability — Apple HealthKit Pipeline Server Example"
Description: """
Example concrete pipeline server declaration for an Apple HealthKit-integrated
ETL endpoint. Rate-limited at 10 requests/s per Apple's HealthKit RESTful API
guidelines; exponential-backoff retry; error reporting at /api/pipeline/errors.
"""

* status = #active
* date = "2026-05-19"
* kind = #instance
* implementation
  * description = "iOS Lifestyle Medicine pipeline server — Apple HealthKit vendor integration endpoint"
  * url = "https://2rdoc.pt/fhir/pipeline/applehealthkit"
* fhirVersion = #4.0.1
* format[0] = #json
* format[1] = #xml

* rest[0]
  * mode = #server
  * documentation = "Apple HealthKit pipeline endpoint for Bundle.type=batch ETL payloads."

  * extension[0]
    * url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/pipeline-rate-limit"
    * valueQuantity.value = 10
    * valueQuantity.unit = "requests/s"
    * valueQuantity.system = "http://unitsofmeasure.org"
    * valueQuantity.code = #1/s

  * extension[1]
    * url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/pipeline-retry-semantics"
    * valueString = "exponential-backoff-3-max"

  * extension[2]
    * url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/pipeline-error-reporting"
    * valueUrl = "https://2rdoc.pt/api/pipeline/applehealthkit/errors"

  * resource[0]
    * type = #Bundle
    * documentation = "Apple HealthKit batch ETL endpoint. Expects LifestyleMedicineETLBatch payloads."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/lifestyle-medicine-etl-batch"
    * interaction[0].code = #create
    * interaction[1].code = #read

  * resource[1]
    * type = #Observation
    * documentation = "HRV / heart rate / step count / sleep observations from Apple Watch + iPhone HealthKit."
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
    * searchParam[1]
      * name = "date"
      * type = #date

  * security
    * cors = true
    * service[0] = http://terminology.hl7.org/CodeSystem/restful-security-service#SMART-on-FHIR "SMART-on-FHIR"
