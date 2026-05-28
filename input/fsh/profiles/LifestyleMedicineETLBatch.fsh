// ============================================================================
// Lifestyle Medicine ETL Batch Bundle Profile
// ============================================================================
// Date: 2026-05-15 (T2 S24 — Tier 1B Profile #1)
// Purpose: Profile Bundle resource for batch ETL operations from vendor APIs
//          into the Lifestyle Medicine IG. Defines the FHIR-side contract for
//          patient-data-pipeline batch insertion, with explicit provenance
//          (PGHDProvenance) + source device (Device) + audit trail
//          (AuditEventDataAccess) entries.
// Reference:
//   - FHIR R4 Bundle: https://hl7.org/fhir/R4/bundle.html
//   - Bundle.type = #batch semantics
//   - PGHDProvenance: see ProvenanceProfile.fsh (T2 S22, 2025-11-25)
//   - AuditEventDataAccess: see AuditEventDataAccess.fsh (T2 S20, 2026-05-07)
// Companion:
//   - Profile #2 WearableMeasurementProvenance (refines PGHDProvenance — T2 S24 spike OR S25)
//   - Profile #3 PatientDataPipelineCapability (CapabilityStatement — T2 S25)
//   - Profile #4 LifestyleMedicineGroupETL (extends BulkExportGroup — T2 S25)
// G2 RS antecedent:
//   - RS4 (Living SR methodology, Elliott 2017 adaptive search)
//   - RS13 (FHIRconnect implementation)
// ============================================================================

Profile: LifestyleMedicineETLBatch
Parent: Bundle
Id: lifestyle-medicine-etl-batch
Title: "Lifestyle Medicine ETL Batch Bundle"
Description: """
Profile for `Bundle` resources of type `batch` carrying ETL (Extract-Transform-Load)
results from consumer wearable vendor APIs into the Lifestyle Medicine IG.

Each ETL run produces ONE `LifestyleMedicineETLBatch` Bundle containing:

- ONE `PGHDProvenance` entry (run-level provenance: who/what/when/how)
- ONE `Device` entry (the source vendor device — Apple Watch, Fitbit Sense, etc.)
- ZERO-or-ONE `AuditEventDataAccess` entry (the audit trail)
- ZERO-or-MORE `Observation` entries (the actual ETL'd measurements)

The `Bundle.type = #batch` (fixed) semantics enable flexible per-entry processing
on the FHIR server: each `entry.request.method` independently inserts/updates its
resource. Failure of one entry does NOT roll back the entire Bundle (unlike
`type = #transaction`). This matches the best-effort batch ingestion pattern
used by Living SR (RS4) and FHIRconnect (RS13) wearable ETL pipelines.

Profile constraints (all `MS = mustSupport`):

- `type` is fixed to `#batch`
- `timestamp` carries the ETL-run-assembly time
- `identifier` carries the dedup-stable ETL run ID
- `entry` is sliced (open) on `resource.meta.profile`: etlProvenance / batchDevice / auditEvent / observations
- `entry.fullUrl`, `entry.request.method`, `entry.request.url` are all required per FHIR R4 batch semantics
- `total` and `link` are prohibited (Bundle.type=batch is neither search-set nor history)
"""

* ^experimental = false
* ^status = #active

// ----- Bundle.type — fixed to batch -----
* type 1..1 MS
* type = #batch (exactly)

// ----- Bundle.timestamp — when batch was assembled by ETL run -----
* timestamp 1..1 MS

// ----- Bundle.identifier — dedup-stable ETL run ID -----
* identifier 1..1 MS
* identifier.system 1..1 MS
* identifier.value 1..1 MS

// ----- Bundle.entry — sliced (open) on resource type -----
// Discriminator type = #type because each slice carries a different FHIR
// resource type (Provenance / Device / AuditEvent / Observation). Slice-level
// profile constraints (`only PGHDProvenance` etc.) further refine within type.
* entry ^slicing.discriminator.type = #type
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open
* entry ^slicing.description = "Slice by resource type: etlProvenance (Provenance/PGHDProvenance), batchDevice (Device), auditEvent (AuditEvent/AuditEventDataAccess), observations (Observation)."

* entry contains
    etlProvenance 1..1 MS and
    batchDevice 1..1 MS and
    auditEvent 0..1 MS and
    observations 0..* MS

// ----- Per-slice resource type constraints (forward-dep only — FM4 mitigation) -----
* entry[etlProvenance].resource only PGHDProvenance
* entry[batchDevice].resource only Device
* entry[auditEvent].resource only AuditEventDataAccess
* entry[observations].resource only Observation

// ----- Bundle.entry FHIR R4 batch invariants (FM1 mitigation) -----
* entry.fullUrl 1..1 MS
* entry.request 1..1 MS
* entry.request.method 1..1 MS
* entry.request.url 1..1 MS

// ----- Bundle.total — prohibited (batch is not search-set) -----
* total 0..0

// ----- Bundle.link — prohibited (batch is not history) -----
* link 0..0

// ----- Bundle.signature — optional for batch integrity -----
* signature 0..1 MS

// ============================================================================
// NamingSystem — ETL Run Identifier URN
// ============================================================================
// Formal registration for the URN namespace used by
// LifestyleMedicineETLBatch.identifier.system. Resolves the IG Publisher
// warning about unknown identifier system URL.

Instance: LifestyleMedicineETLRunIdNamingSystem
InstanceOf: NamingSystem
Usage: #definition
Title: "Lifestyle Medicine ETL Run Identifier URN"
Description: "NamingSystem defining the URN namespace for ETL run identifiers used in LifestyleMedicineETLBatch Bundle.identifier"

* name = "LifestyleMedicineETLRunId"
* status = #active
* kind = #identifier
* date = "2026-05-15"
* publisher = "iOS Lifestyle Medicine HEADS FHIR IG"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* responsible = "iOS Lifestyle Medicine HEADS FHIR IG"
* type = http://terminology.hl7.org/CodeSystem/v2-0203#FILL "Filler Identifier"
* description = "URN namespace for ETL (Extract-Transform-Load) run identifiers. Each ETL run from a wearable vendor API into the Lifestyle Medicine IG receives a stable, dedup-safe identifier scoped to this namespace. Identifier values follow the pattern {vendor}-{source}-{YYYYMMDD}-{HHMMSS}-{runseq} (e.g., apple-healthkit-etl-20260515-100000-001)."
* jurisdiction = urn:iso:std:iso:3166#PT "Portugal"
* uniqueId.type = #uri
* uniqueId.value = "https://2rdoc.pt/ig/ios-lifestyle-medicine/identifier/etl-run-id"
* uniqueId.preferred = true

// ============================================================================
// Supporting Instance — PGHDProvenance for Apple HealthKit ETL run
// ============================================================================
// Standalone Provenance Instance used by LifestyleMedicineETLBatchAppleExample.
// Documents the run-level (NOT per-Observation) provenance of an ETL batch
// assembled from Apple HealthKit API.

Instance: ProvenanceETLBatchAppleHealthKitExample
InstanceOf: PGHDProvenance
Usage: #example
Title: "Provenance Example: Apple HealthKit ETL run"
Description: "Run-level provenance for the LifestyleMedicineETLBatchAppleExample Bundle (Apple HealthKit batch ingestion, 7-day HRV window)"

* target = Reference(PatientExample)
* recorded = "2026-05-15T10:00:00Z"
* activity = http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle|1.0.0#transform "Transform/Translate Record Lifecycle Event"

// Device that captured the data (the wearable that originated the samples)
// Bundle resolution: matches LifestyleMedicineETLBatchAppleExample.entry[batchDevice].fullUrl
* agent[device].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#performer
* agent[device].who = Reference(urn:uuid:22222222-2222-4222-8222-222222222222)

// Assembler — the iOS HealthKit framework that delivered the batch (external reference)
* agent[assembler].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#assembler
* agent[assembler].who = Reference(Device/iphone-example)

// Author — the Patient who generated the data (external reference)
* agent[author].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
* agent[author].who = Reference(Patient/PatientExample)

// ============================================================================
// Example Instance — Apple HealthKit batch ETL ingestion
// ============================================================================
// Scenario:
// Apple HealthKit batch query for HRV over a 7-day window assembled as one
// ETL batch. The Bundle carries 1 run-level Provenance + 1 source Device
// reference + 1 placeholder Observation entry. In production runs the
// `observations` slice would carry N HRV Observation resources; here we
// keep the example minimal (1 Observation) for clarity.
//
// References reuse existing FSH Instances (Pitfall #101 sub-class B avoidance):
// - PatientExample            (PatientExample.fsh)
// - AppleWatchDevice          (ProvenanceExamples.fsh:131)
// - iphone-example            (DeviceExamples.fsh:1)
// - HRVObservationExample     (ProvenanceExamples.fsh:9)
// - ProvenanceETLBatchAppleHealthKitExample (this file, above)

Instance: LifestyleMedicineETLBatchAppleExample
InstanceOf: LifestyleMedicineETLBatch
Usage: #example
Title: "Example: Apple HealthKit batch ETL ingestion (7-day HRV window)"
Description: "Example ETL batch Bundle from Apple HealthKit: 1 PGHDProvenance (run-level) + 1 Device (Apple Watch) + 1 HRV Observation. Demonstrates the LifestyleMedicineETLBatch profile end-to-end."

* type = #batch
* timestamp = "2026-05-15T10:00:00Z"

* identifier.system = "https://2rdoc.pt/ig/ios-lifestyle-medicine/identifier/etl-run-id"
* identifier.value = "apple-healthkit-etl-20260515-100000-001"

// ----- Entry 1: etlProvenance (run-level PGHDProvenance) -----
* entry[etlProvenance].fullUrl = "urn:uuid:11111111-1111-4111-8111-111111111111"
* entry[etlProvenance].resource = ProvenanceETLBatchAppleHealthKitExample
* entry[etlProvenance].request.method = #PUT
* entry[etlProvenance].request.url = "Provenance/ProvenanceETLBatchAppleHealthKitExample"

// ----- Entry 2: batchDevice (source vendor Device) -----
* entry[batchDevice].fullUrl = "urn:uuid:22222222-2222-4222-8222-222222222222"
* entry[batchDevice].resource = AppleWatchDevice
* entry[batchDevice].request.method = #PUT
* entry[batchDevice].request.url = "Device/AppleWatchDevice"

// ----- Entry 3: observations (placeholder — one HRV measurement) -----
* entry[observations][0].fullUrl = "urn:uuid:33333333-3333-4333-8333-333333333333"
* entry[observations][0].resource = HRVObservationExample
* entry[observations][0].request.method = #POST
* entry[observations][0].request.url = "Observation"
