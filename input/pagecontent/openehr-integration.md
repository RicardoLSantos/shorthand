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

<!-- G-6 harmonized T1 S51 (2026-06-02): aligned with Decisão #16 / S50 live CKM-mirror reconciliation — replaced the "four priority CKM gaps" overclaim with honest per-archetype novel/reuse/specialisation status -->

The IG bridges to four openEHR archetypes covering core consumer-wearable domains (heart-rate variability, sleep, physical activity, and device provenance). Rather than presenting these as a uniform set of "CKM gaps", the IG records each archetype's **honest status relative to the published openEHR Clinical Knowledge Manager (CKM)** — a distinction confirmed by a live reconciliation against the CKM mirror (433 published OBSERVATION/CLUSTER concepts). Some are genuinely novel concepts with no CKM equivalent; others reuse or specialise an already-published CKM archetype. This is the characterisation a CKM reviewer expects, and it is the basis on which any future CKM submission would be scoped:

| Domain | Archetype identifier | Status vs published CKM | FHIR↔openEHR ConceptMaps |
|--------|----------------------|--------------------------|---------------------------|
| HRV | `openEHR-EHR-OBSERVATION.heart_rate_variability.v0` | **Novel** — no OBSERVATION CKM equivalent | ConceptMapFHIRToOpenEHR, ConceptMapOpenEHRToFHIR, ConceptMapVendorToOpenEHR |
| Sleep | `openEHR-EHR-OBSERVATION.sleep_architecture.v0` | **Novel concept** — the published CKM sleep archetype models disturbance questionnaires, not sleep architecture/stages | ConceptMapFHIRToOpenEHR, ConceptMapOpenEHRToFHIR |
| Physical activity | `openEHR-EHR-OBSERVATION.physical_activity_detailed.v0` | **Reuse** — aligns to a published CKM physical-activity OBSERVATION archetype (a wearable-detailed projection, not a new gap) | ConceptMapFHIRToOpenEHR, ConceptMapOpenEHRToFHIR |
| Device provenance | `openEHR-EHR-CLUSTER.wearable_device.v0` | **Specialisation** of the published CKM device CLUSTER archetype (`openEHR-EHR-CLUSTER.device.v1`) | ConceptMapVendorToOpenEHR |

These four are the consumer-wearable subset that this IG bridges into FHIR; the IG's broader original-archetype set is reconciled in an internal report whose genuine-versus-reuse classification is **pending clinical-supervisor validation before any CKM submission** (no draft archetype is submitted or catalogued until then). Domains outside the consumer-wearable scope (nutrition, mindfulness, environmental, social, reproductive, mobility) are mapped to LOINC/SNOMED CT at the FHIR layer but are intentionally **not** bridged to openEHR archetypes in this IG — they are documented as future archetype work.

## Bidirectional translation

The bridge is bidirectional and includes a direct vendor ingestion path and a research warehouse path:

- **FHIR → openEHR** (`ConceptMapFHIRToOpenEHR`): maps FHIR Observation profile elements to archetype node paths (e.g., an HRV `Observation.component` to `heart_rate_variability.v0` data items).
- **openEHR → FHIR** (`ConceptMapOpenEHRToFHIR`): the inverse, for systems whose system of record is an openEHR CDR.
- **Vendor API → openEHR** (`ConceptMapVendorToOpenEHR`): a direct ingestion path mapping Apple HealthKit, Fitbit, Oura, Garmin and Polar fields to archetype nodes, enabling ETL that bypasses FHIR where appropriate.
- **openEHR → OMOP** (`ConceptMapOpenEHRToOMOP`): bridges archetype data to OMOP CDM `MEASUREMENT`/`OBSERVATION` for population analytics (see the OMOP ConceptMaps for the verified `concept_id` mappings).

## Element-level mapping (openEHR data item → FHIR path)

<!-- AUTHORED-BY-CLAUDE-T1-S51 (2026-06-02): surfaced verbatim from committed ConceptMapOpenEHRToFHIR.fsh; LOINC codes Database-First verified vs Athena 2026-06-02 -->

The bridge above is defined at the granularity of **individual data items**, not only archetype-to-resource. The tables below surface the committed `ConceptMapOpenEHRToFHIR` instance so the projection is explicit and reviewable — each row is the actual mapping committed in `input/fsh/terminology/ConceptMapOpenEHRToFHIR.fsh`. The LOINC codes are Database-First verified against the OHDSI Athena vocabulary (2026-06-02).

**HRV** — `openEHR-EHR-OBSERVATION.heart_rate_variability.v0` → `Observation` (vital-signs):

| openEHR data item | FHIR path | Terminology | Equivalence |
|-------------------|-----------|-------------|-------------|
| SDNN | `Observation.component[sdnn].valueQuantity` | LOINC `80404-7` (ms) | equivalent |
| RMSSD | `Observation.component[rmssd].valueQuantity` | `LifestyleMedicineTemporaryCS#hrv-rmssd` (ms) — no LOINC | equivalent |
| pNN50 | `Observation.component[pnn50].valueQuantity` | `…#hrv-pnn50` (%) — no LOINC | equivalent |
| LF/HF ratio | `Observation.component[lf-hf-ratio].valueQuantity` | `…#hrv-lf-hf-ratio` — no LOINC | equivalent |
| Recording duration | `Observation.effectivePeriod` | derived (end − start) | relatedto |
| Physiological state | `Observation.component[state].valueCodeableConcept` | custom (resting/active/sleep) | equivalent |
| Device | `Observation.device` | Device reference | relatedto |

**Sleep** — `…sleep_architecture.v0` → `Observation` (sleep-analysis):

| openEHR data item | FHIR path | Terminology | Equivalence |
|-------------------|-----------|-------------|-------------|
| Total sleep time | `Observation.valueQuantity` | LOINC `93832-4` (h/min) | equivalent |
| Deep sleep duration | `Observation.component[deep-sleep].valueQuantity` | custom code† | equivalent |
| REM sleep duration | `Observation.component[rem-sleep].valueQuantity` | custom code† | equivalent |
| Sleep efficiency | `Observation.component[efficiency].valueQuantity` | custom (TST/TIB %) | equivalent |
| Sleep score | `Observation.component[score].valueInteger` | vendor composite (0–100) | equivalent |
| Avg HRV (RMSSD) during sleep | `Observation.component[sleep-hrv].valueQuantity` | `…#hrv-rmssd` (ms) | equivalent |

**Physical activity** — `…physical_activity_detailed.v0` → `Observation` (physical-activity):

| openEHR data item | FHIR path | Terminology | Equivalence |
|-------------------|-----------|-------------|-------------|
| Step count | `Observation.valueQuantity` | LOINC `55423-8` (steps) | equivalent |
| Distance | `Observation.component[distance].valueQuantity` | LOINC `55430-3` (km/m) | equivalent |
| Active calories | `Observation.component[active-calories].valueQuantity` | LOINC `41979-6` (kcal) | equivalent |
| Moderate-activity minutes | `Observation.component[moderate-minutes].valueQuantity` | LOINC `77592-4` (min) | equivalent |
| Vigorous-activity minutes | `Observation.component[vigorous-minutes].valueQuantity` | LOINC `77593-2` (min) | equivalent |

**Device provenance** — `…wearable_device.v0` (CLUSTER) → `Device`:

| openEHR data item | FHIR path | Equivalence |
|-------------------|-----------|-------------|
| Device platform | `Device.manufacturer` | equivalent |
| Device model | `Device.modelNumber` | equivalent |
| Device category | `Device.type` (SNOMED CT device type where available) | equivalent |
| Serial number | `Device.serialNumber` | equivalent |
| Firmware version | `Device.version[firmware]` | equivalent |

> **Node-code convention note (honest):** the committed ConceptMaps reference data items by their ADL2 element identifiers (`idN`), whereas the `*.v0` draft archetypes are authored in ADL 1.4 (`atNNNN`) — for example, SDNN is `at0004` in the v0 ADL and `id5` in the ConceptMap. Reconciling node-code conventions across the full archetype set is part of the pre-CKM term-bindings audit; it does not affect the data-item → FHIR-path projection above, which is the reviewable contract.

> **† Binding improvements (terminology audit, Database-First vs OHDSI Athena):** the deep/REM sleep rows currently bind custom codes, but LOINC codes **do exist** — `93831-6` (Deep sleep duration) and `93829-0` (REM sleep duration); and the activity-minute rows bind IPAQ-survey LOINC (`77592-4`/`77593-2`) where device-method LOINC (`101689-8` / `101690-6`) are preferable for wearable-sourced data. These ConceptMap binding updates are queued in the terminology lane (not yet applied); the tables above reflect the *currently committed* bindings so the narrative does not run ahead of the FSH.

## Worked AQL (semantic retrieval over the CDR)

Because openEHR separates the reference model from the archetype model, the same FHIR projection can be sourced from an openEHR CDR by querying data items via their **semantic archetype path** rather than a physical schema (the *AQL and semantic traceability* addendum below explains why this matters). Two illustrative queries over the HRV archetype use its ADL 1.4 node paths (`OBSERVATION[at0000]/data[at0001]/events[at0002]/data[at0003]/items[at0004]` = SDNN, `items[at0005]` = RMSSD):

*Resting SDNN below the 50 ms low-HRV threshold in the last 90 days:*

```sql
SELECT
  o/data[at0001]/events[at0002]/data[at0003]/items[at0004]/value/magnitude AS sdnn_ms,
  o/data[at0001]/events[at0002]/time AS measured_at
FROM EHR e
  CONTAINS OBSERVATION o[openEHR-EHR-OBSERVATION.heart_rate_variability.v0]
WHERE o/data[at0001]/events[at0002]/data[at0003]/items[at0004]/value/magnitude < 50
  AND o/data[at0001]/events[at0002]/time > '2026-03-04T00:00:00Z'
ORDER BY measured_at DESC
```

*RMSSD trend (parasympathetic marker) per subject, for a recovery review:*

```sql
SELECT
  e/ehr_id/value AS subject,
  o/data[at0001]/events[at0002]/data[at0003]/items[at0005]/value/magnitude AS rmssd_ms,
  o/data[at0001]/events[at0002]/time AS measured_at
FROM EHR e
  CONTAINS OBSERVATION o[openEHR-EHR-OBSERVATION.heart_rate_variability.v0]
ORDER BY subject, measured_at
```

Each result row carries its semantic lineage (archetype id + node path), so a FHIR `Observation` derived from it is traceable back to `items[at0004]` (SDNN) / `items[at0005]` (RMSSD) — the persistence-layer counterpart of the [ConceptMaps](conceptmaps.html) bridge.

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

---

## ADDENDUM (T1 S47, 28 May 2026) — Vulcan FHIR-to-OMOP IG alignment + OMOP integration cross-link

<!-- AUTHORED-BY-CLAUDE-T1-S47 - additive ADDENDUM per Lesson #431 frozen-at-birth -->

The companion ConceptMap `ConceptMapOpenEHRToOMOP` is also the cross-standard bridge that the new [OMOP Integration](omop-integration.html) page describes from the OMOP side. Together they let an openEHR archetype source feed an OHDSI-network federated analysis through a Vulcan FHIR-to-OMOP IG v1.0.0 (INFORMATIVE 1) compatible pipeline — this IG provides the mapping shape; the [HL7 Vulcan FHIR-to-OMOP IG](http://hl7.org/fhir/uv/fhir-to-omop) (v1.0.0, R5, CC0-1.0, BRR workgroup) provides the generic resource-level transformation contract; and the OHDSI [Standardized Vocabularies](https://athena.ohdsi.org) provide the target `concept_id` values.

The IG's RS13 post-defense ETL implementation is now positioned as a **Vulcan-conformant deployment**, not a novel framework — repositioning the openEHR↔OMOP bridge narrows the claimed novelty without losing the substantive contribution (the lifestyle-medicine-vertical archetype-to-OMOP mapping, which Vulcan does not specify). The four-archetype consumer-wearable scope (HRV, sleep, activity, device provenance) and the three design patterns above are unchanged; the new framing situates them inside the broader FHIR-to-OMOP standards landscape that emerged in 2026.


<!-- AUTHORED-BY-CLAUDE-T1-S48 (Pitfall #97) · 2nd additive ADDENDUM (Lesson #431 frozen-at-birth) · pasted v0.4.1 T1 S49 -->

## ADDENDUM (T1 S48, 30 May 2026) — Platform alignment: the system approach, the CDR, archetype governance, and AQL

The [Why two models](#why-two-models) section above states *that* this IG persists in openEHR and exchanges in FHIR. This addendum states *why that is the right division of labour at the platform level*, grounded in the openEHR–FHIR community's own analysis and in a national-scale openEHR reference architecture.

### A. The system approach to standardization

A widely-cited critique from the standards community is that FHIR, **as it is used in practice**, is message-oriented: every pair of systems and every business use case tends to spawn its own Implementation Guide and profiles, so the same clinical concept gets re-modeled many times over (one analysis counted **more than sixty different FHIR models for vital signs** alone). On that reading, *each FHIR IG is itself a standard* — FHIR is a framework of standards rather than a single data model.

The proposed remedy is a **"system approach"**: standardize once at the level of the **data source / clinical data repository**, then **derive FHIR messages from that canonical model** — and openEHR is the technology that implements this approach. The conclusion of that analysis is exactly this IG's architecture: *combine FHIR and openEHR to get the best of both worlds by deriving FHIR messages from openEHR data models.* This addendum records that our dual-model is not an idiosyncratic choice but the position of the openEHR–FHIR community and of national e-health agencies.

The practical consequence for this IG: the curated, governed clinical model lives as **openEHR archetypes** (stable, reusable, vendor-neutral), and the FHIR profiles in this IG are the **exchange projection** of that model — which is why the IG is reuse-heavy and adds local profiles/extensions only where genuinely necessary (the antidote to proliferation; see also the [Vocabularies and Value Sets Catalog](terminology-vocabularies-catalog.html)).

### B. The CDR reference architecture (layered, openEHR-native)

A national-scale openEHR platform demonstrates the persistence layer this IG's data ultimately targets: a **layered Medical Data Integration Centre (MeDIC)** pattern in which an **openEHR Clinical Data Repository (CDR)** sits at the centre, archetypes and templates define the canonical clinical content, and **standardized interfaces (including FHIR) project that content outward** for exchange and secondary use. The relevance to this IG: the FHIR resources defined here are the *interoperable surface* of such a CDR, not a competing store. The wearable-biomarker → CDR → exchange/secondary-use flow that this IG models is the same flow that the MeDIC pattern operationalizes at national scale, including for longitudinal cardiology/physical-activity use cases that are directly analogous to this IG's lifestyle-medicine vertical.

### C. Archetype governance (the CKM lifecycle)

openEHR's strength is governed reuse, and governance is a **lifecycle**, not a one-off authoring act. The Clinical Knowledge Manager (CKM) model — *need → draft → incubator → development → quality-assurance → review → approval* — is what keeps a shared archetype set trustworthy and reusable across institutions, and it is the discipline this IG assumes for any archetype it references via `OpenEHRArchetypesCS`. Named reuse of CKM archetypes ("reuse saves resources") is the governance counterpart to the IG's reuse-first terminology stance: the same anti-proliferation principle, applied to the clinical content models rather than to the exchange profiles.

This governance lifecycle parallels the IG's own release governance (versioned source, CI, transparent suppression of inherited build warnings) — the two registries (archetypes in CKM, profiles/terminology in this IG) are kept current by the same kind of discipline.

### D. AQL and semantic traceability

Because openEHR separates the reference model from the archetype model, a single **Archetype Query Language (AQL)** query can retrieve data across heterogeneous archetypes by semantic path rather than by physical schema — the query is stable even as the underlying templates evolve. For this IG, that is the property that makes the openEHR side a durable source for the FHIR projection: the meaning travels with the data (archetype paths + terminology bindings), so a FHIR resource derived from the CDR carries a traceable semantic lineage back to the archetype node it came from. This is the persistence-layer counterpart of the IG's ConceptMap bridge.

### E. openEHR-native patient-reported outcomes

Patient-reported outcome measures (PROMs) — quality of care assessed from the patient's perspective, a key indicator of value-based care — are a concrete, deployed precedent for openEHR-native patient-facing data: an NHS open-standard, open-source, openEHR-native PROMs platform delivering questionnaires across web and mobile and charting population-level outcomes. For this IG, PROMs sit naturally **alongside** wearable biomarkers as patient-reported, openEHR-persisted, FHIR-exchanged data — reinforcing that the lifestyle-medicine vertical spans device-measured *and* patient-reported signals, both governed by the same archetype/terminology discipline (relevant to the openEHR archetype scope for consumer wearables, RS6).

### F. Scope statement (unchanged)

This addendum documents **architecture alignment**, not deployment. Operating an openEHR CDR (running AQL, hosting archetypes, executing the MeDIC layers) is an operational concern documented as future work under RS13 (see [Implementation Scope](implementation-scope-and-roadmap.html)). This IG adopts the openEHR *pattern* and projects it into FHIR; it does not ship a running CDR.
