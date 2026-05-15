// ============================================================================
// Wearable Measurement Provenance Profile + Supporting Extensions
// ============================================================================
// Date: 2026-05-15 (T2 S24 spike — Tier 1B Profile #2)
// Purpose: Profile specialising PGHDProvenance (T2 S22, 25 Nov 2025) for
//          per-Observation provenance of wearable-sourced data. Adds the
//          4 capabilities NOT covered by the parent PGHDProvenance:
//          (1) firmware version captured at the time of measurement
//          (2) explicit time-of-measurement (when the sensor sampled)
//          (3) explicit time-of-upload (when the data reached the vendor cloud)
//          (4) transformation lineage chain (raw → derived metrics, recursive)
// Reference:
//   - PGHDProvenance: see ProvenanceProfile.fsh (T2 S22)
//   - Bayoumy 2021 wearables (cited in parent)
//   - W3C PROV-DM transformation lineage semantics
// G2 RS antecedent:
//   - RS4 (Living SR methodology, Elliott 2017) — per-Observation provenance
//     anchors the audit trail required by adaptive search
//   - RS13 (FHIRconnect implementation) — provenance is one of FHIRconnect's
//     three layered concerns: clinical fidelity, transformation lineage,
//     deployment metadata
// Companion:
//   - LifestyleMedicineETLBatch (Profile #1) — Bundle.entry[etlProvenance]
//     constraint will be tightened from `only PGHDProvenance` to
//     `only WearableMeasurementProvenance` for wearable ETL batches
// ============================================================================

Profile: WearableMeasurementProvenance
Parent: PGHDProvenance
Id: wearable-measurement-provenance
Title: "Wearable Measurement Provenance"
Description: """
Profile specialising `PGHDProvenance` for per-Observation provenance of
wearable-sourced measurements (HRV, sleep, steps, heart rate, SpO2, etc.).

Adds 4 wearable-specific extensions on top of the parent PGHDProvenance:

- `firmwareVersion` (0..1): firmware version of the source device at the
  time of measurement (mandatory for FDA Class II / EU MDR Class IIa device
  audit trails)
- `timeOfMeasurement` (1..1): when the sensor actually sampled (not when
  the data was recorded — see FHIR `Provenance.recorded` for that)
- `timeOfUpload` (1..1): when the data reached the vendor cloud (typically
  later than `timeOfMeasurement` due to background sync)
- `transformationLineage` (0..*): chain of upstream Provenances representing
  raw-to-derived transformation steps (raw sample → vendor-derived metric →
  IG-recomputed metric)

Target tightening: `target` constraint narrows to `Reference(Observation)`
only (parent allows `Reference(Any)`); for wearable measurement provenance,
the target is always the Observation that carries the measurement.

Inherits all parent constraints unchanged: agent slicing (device + assembler
+ author), DeviceCaptureMetadata extension (samplingRate + sensorType +
captureMethod), PGHDProvenanceActivityVS activity binding, signature MS.
"""

* ^experimental = false
* ^status = #active

// ----- Target tightening — only Observations -----
* target only Reference(Observation)
* target 1..* MS

// ----- New extensions specific to wearable measurements -----
* extension contains
    WearableFirmwareVersion named firmwareVersion 0..1 MS and
    WearableTimeOfMeasurement named timeOfMeasurement 1..1 MS and
    WearableTimeOfUpload named timeOfUpload 1..1 MS and
    WearableTransformationLineage named transformationLineage 0..* MS

// ============================================================================
// Extension — Wearable Firmware Version
// ============================================================================
Extension: WearableFirmwareVersion
Id: wearable-firmware-version
Title: "Wearable Firmware Version"
Description: "Firmware version of the wearable device at the time of measurement. Required for FDA Class II / EU MDR Class IIa device audit trails."

* ^context.type = #element
* ^context.expression = "Provenance"

* value[x] only string
* valueString 1..1 MS

// ============================================================================
// Extension — Time of Measurement
// ============================================================================
Extension: WearableTimeOfMeasurement
Id: wearable-time-of-measurement
Title: "Time of Measurement"
Description: "When the sensor actually sampled the measurement (distinct from Provenance.recorded which is when the Provenance record was created, and from time-of-upload which is when data reached the vendor cloud)."

* ^context.type = #element
* ^context.expression = "Provenance"

* value[x] only dateTime
* valueDateTime 1..1 MS

// ============================================================================
// Extension — Time of Upload
// ============================================================================
Extension: WearableTimeOfUpload
Id: wearable-time-of-upload
Title: "Time of Upload to Vendor Cloud"
Description: "When the measurement data reached the vendor cloud (typically later than time-of-measurement due to background sync intervals; relevant for latency-sensitive workflows like CDS Hooks)."

* ^context.type = #element
* ^context.expression = "Provenance"

* value[x] only dateTime
* valueDateTime 1..1 MS

// ============================================================================
// Extension — Transformation Lineage
// ============================================================================
Extension: WearableTransformationLineage
Id: wearable-transformation-lineage
Title: "Wearable Transformation Lineage"
Description: "Reference to an upstream Provenance representing one step of the transformation chain (raw sample → vendor-derived metric → IG-recomputed metric). Recursive: the upstream Provenance MAY itself carry transformationLineage extensions to walk further back."

* ^context.type = #element
* ^context.expression = "Provenance"

* value[x] only Reference
* valueReference 1..1 MS
* valueReference only Reference(Provenance)

// ============================================================================
// Example Instance — Apple Watch HRV measurement with full provenance chain
// ============================================================================
// Scenario:
// Apple Watch Series 10 (firmware watchOS 11.4) captures HRV at 08:30:00 local.
// HealthKit syncs to Apple Cloud at 08:35:12 (background sync delay 5 min 12s).
// IG ETL run extracts the sample at 10:00:00 (data ingestion latency ~1.5h).
// Provenance carries: firmware + time-of-measurement + time-of-upload, plus
// the existing PGHDProvenance agent slicing (device + assembler + author).

Instance: WearableMeasurementProvenanceAppleHRVExample
InstanceOf: WearableMeasurementProvenance
Usage: #example
Title: "Wearable Measurement Provenance Example — Apple Watch HRV"
Description: "Example WearableMeasurementProvenance for an Apple Watch Series 10 HRV measurement, demonstrating firmware version + time-of-measurement + time-of-upload + agent chain."

* target = Reference(Observation/HRVObservationExample)
* recorded = "2026-05-15T10:00:00Z"
* activity = http://terminology.hl7.org/CodeSystem/iso-21089-lifecycle|1.0.0#originate "Originate/Retain Record Lifecycle Event"

// Wearable-specific extensions
* extension[firmwareVersion].valueString = "watchOS 11.4 (build 22T230)"
* extension[timeOfMeasurement].valueDateTime = "2026-05-15T08:30:00Z"
* extension[timeOfUpload].valueDateTime = "2026-05-15T08:35:12Z"

// Agent chain (inherited from PGHDProvenance)
* agent[device].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#performer
* agent[device].who = Reference(Device/AppleWatchDevice)

* agent[assembler].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#assembler
* agent[assembler].who = Reference(Device/iphone-example)

* agent[author].type = http://terminology.hl7.org/CodeSystem/provenance-participant-type#author
* agent[author].who = Reference(Patient/PatientExample)
