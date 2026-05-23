# openEHR Integration

This page documents how the iOS Lifestyle Medicine FHIR IG bridges to **openEHR** archetypes for consumer wearable health data, and how the IG addresses the three design patterns that a systematic review of consumer-wearable archetype coverage found to be the most frequently missing in published archetypes: **data-quality representation**, **vendor/algorithm provenance**, and **temporal (epoch) semantics**.

The IG follows a **dual-model architecture**: FHIR provides the exchange layer (profiles, terminology, conformance) while openEHR provides a semantically rich persistence layer (two-level modelling: reference model + archetypes). Neither standard is treated as primary; the IG provides translation infrastructure between them.

## Why two models

| Concern | FHIR (exchange) | openEHR (persistence) |
|---------|-----------------|------------------------|
| Strength | REST API, conformance, broad EHR support | Deep clinical modelling, archetype governance (CKM) |
| Wearable fit | Observation profiles + custom HRV codes | OBSERVATION archetypes with protocol/state slots |
| Role in IG | point-of-care exchange, CDS, bulk export | research-grade semantic storage |

Translation is declarative, via ConceptMaps (see [ConceptMaps](conceptmaps.html) for the full mapping tables and the expected cross-standard validator warnings).

## Archetype coverage (consumer wearable scope)

The IG maps to four custom openEHR archetypes covering the consumer-wearable domains (heart-rate variability, sleep, physical activity, and device provenance). These are the four archetypes the systematic review identified as the priority CKM gaps for consumer wearables:

| Domain | Archetype identifier | FHIR↔openEHR ConceptMaps |
|--------|----------------------|---------------------------|
| HRV | `openEHR-EHR-OBSERVATION.heart_rate_variability.v0` | ConceptMapFHIRToOpenEHR, ConceptMapOpenEHRToFHIR, ConceptMapVendorToOpenEHR |
| Physical activity | `openEHR-EHR-OBSERVATION.physical_activity_detailed.v0` | ConceptMapFHIRToOpenEHR, ConceptMapOpenEHRToFHIR |
| Sleep | `openEHR-EHR-OBSERVATION.sleep_architecture.v0` | ConceptMapFHIRToOpenEHR, ConceptMapOpenEHRToFHIR |
| Device provenance | `openEHR-EHR-CLUSTER.wearable_device.v0` | ConceptMapVendorToOpenEHR |

Domains outside the consumer-wearable scope (nutrition, mindfulness, environmental, social, reproductive, mobility) are mapped to LOINC/SNOMED CT at the FHIR layer but are intentionally **not** given openEHR archetypes in this IG — they are out of the consumer-wearable archetype scope and are documented as future archetype work.

## Bidirectional translation

The bridge is bidirectional and includes a direct vendor ingestion path and a research warehouse path:

- **FHIR → openEHR** (`ConceptMapFHIRToOpenEHR`): maps FHIR Observation profile elements to archetype node paths (e.g., an HRV `Observation.component` to `heart_rate_variability.v0` data items).
- **openEHR → FHIR** (`ConceptMapOpenEHRToFHIR`): the inverse, for systems whose system of record is an openEHR CDR.
- **Vendor API → openEHR** (`ConceptMapVendorToOpenEHR`): a direct ingestion path mapping Apple HealthKit, Fitbit, Oura, Garmin and Polar fields to archetype nodes, enabling ETL that bypasses FHIR where appropriate.
- **openEHR → OMOP** (`ConceptMapOpenEHRToOMOP`): bridges archetype data to OMOP CDM `MEASUREMENT`/`OBSERVATION` for population analytics (see the OMOP ConceptMaps for the verified `concept_id` mappings).

## Design pattern 1 — Data-quality representation

Wearable signals are noisy; a clinically usable record must carry a data-quality indicator. Each OBSERVATION archetype mapped here exposes a **data-quality slot** in its protocol section (e.g., `data_quality_flag: Good | Fair | Poor`) capturing motion-artefact level, sensor-contact quality, and recording completeness. On the FHIR side this surfaces as an Observation `component` / `dataAbsentReason` / quality extension, so a downstream CDS service (see [CDS Hooks Integration](cds-hooks-integration.html)) can suppress or down-weight low-quality readings before computing risk.

## Design pattern 2 — Vendor and algorithm provenance

Two devices reporting "RMSSD" may compute it differently (artefact-correction method, interpolation, window length). The `wearable_device.v0` CLUSTER and the protocol section of each OBSERVATION archetype carry **algorithm metadata** — vendor, model, firmware/algorithm version, and preprocessing notes. This makes a reading reproducible and lets analysts stratify by device platform. On the FHIR side this maps to `Observation.device` + a device-metadata extension and the `ConceptMapVendorToOpenEHR` lineage.

## Design pattern 3 — Temporal (epoch) semantics

A single HRV value summarises an underlying window; a sleep value summarises a night composed of epochs. The archetypes make the **measurement window explicit** (`measurement_duration`, e.g., 5-minute resting vs 24-hour ambulatory) and, for time-series metrics, model epoch length so that aggregation is unambiguous. On the FHIR side this maps to `Observation.effectivePeriod` and method/timing extensions rather than a bare instant.

## Terminology bindings

Archetype data items carry term_bindings to LOINC/SNOMED CT **where a code exists**, and to the IG custom CodeSystem where it does not. For HRV specifically, only **SDNN** has a LOINC code (`80404-7`); **RMSSD, pNN50, LF power, HF power, and LF/HF ratio have no LOINC code** (verified via the project Database-First protocol). These bind to IG custom codes (`#hrv-rmssd`, `#hrv-pnn50`, `#hrv-lf-power`, `#hrv-hf-power`, `#hrv-lf-hf-ratio`) with a documented migration path should LOINC assign codes in future. See [ConceptMaps](conceptmaps.html) and [Inflammatory Markers](inflammatory_markers.html).

## Cross-references

- [ConceptMaps](conceptmaps.html) — full FHIR↔openEHR↔OMOP↔Vendor mapping tables and validator-warning rationale
- [CDS Hooks Integration](cds-hooks-integration.html) — how quality-flagged observations feed decision support
- [SMART on FHIR Integration](smart-on-fhir-integration.html) — exchange-layer companion
- [Inflammatory Markers](inflammatory_markers.html) — laboratory archetype companion

## Sources

This narrative is a companion to the openEHR-related ConceptMaps committed under `input/fsh/terminology/` (`ConceptMapFHIRToOpenEHR`, `ConceptMapOpenEHRToFHIR`, `ConceptMapVendorToOpenEHR`, `ConceptMapOpenEHRToOMOP`). The four-archetype consumer-wearable scope and the three priority design patterns (data quality, algorithm provenance, temporal semantics) reflect the findings of the project systematic review of openEHR archetypes for consumer wearable health devices (RS6). Archetype identifiers follow the openEHR naming convention (`openEHR-EHR-OBSERVATION.<concept>.v0`); the `v0` suffix denotes pre-CKM-submission drafts. HRV LOINC status (SDNN `80404-7` present; RMSSD/pNN50/LF/HF absent) is database-verified per the IG terminology verification protocol.
