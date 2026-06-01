This page describes how the Implementation Guide bridges FHIR clinical data to the **OHDSI OMOP Common Data Model** for federated observational research, while keeping the OMOP vocabulary external (not embedded). The IG ships six ConceptMaps that translate IG-defined or upstream codes (LOINC, SNOMED CT, custom local) to OMOP `concept_id` values, plus one stub CodeSystem that anchors the OMOP namespace in the IG without mirroring the full OMOP vocabulary.

<!-- AUTHORED-BY-CLAUDE-T1-S47 -->

> **Scope (honest):** The IG provides the *mapping shape* — `ConceptMap` resources that name source and target codes, with the relationship semantics FHIR requires — and references the OMOP vocabulary canonically via `http://athena.ohdsi.org/search-terms/terms`. The IG does **not** distribute the OMOP vocabulary itself (>10 million concept_ids, maintained by OHDSI under their own license terms), does **not** run an ETL pipeline (that is HEADS-ETL, external; see [Implementation Scope and Roadmap](implementation-scope-and-roadmap.html)), and does **not** ship an OMOP database. This is the *adopted-pattern, not embedded-engine* stance; operational deployment is post-defense work (RS13).

### Design discipline (one-sentence summary)

**For each clinical-data domain that has both an upstream FHIR shape in this IG and a target OMOP concept_id in the OHDSI Standardized Vocabularies, ship a `ConceptMap` that names the mapping explicitly — and never enumerate OMOP `concept_id` values inside the IG except where they appear inside a `ConceptMap.element.target.code` field, because the authoritative source is Athena, not the IG.**

The single-sentence rule above is what prevents two recurring failure modes — (a) OMOP vocabulary drift between the IG and Athena, and (b) fabricated `concept_id` values mistakenly accepted as real because they have the same digit format. Both modes are documented below.

### Why ConceptMap-not-enumerate

The OHDSI Standardized Vocabularies contain ~10 million `concept_id` entries spanning ~150 source vocabularies. They are maintained by the OHDSI community, released as quarterly downloads through Athena ([https://athena.ohdsi.org](https://athena.ohdsi.org)), and licensed under terms that vary by source vocabulary. Embedding any non-trivial fraction of this in the IG would:

1. Force every IG release to coincide with an OMOP release, creating an artificial cadence pressure.
2. Triple or quadruple the IG package size without adding semantic value (the source-of-truth still lives at Athena).
3. Drift silently between IG releases — there is no automated mechanism to keep an embedded copy synchronised.
4. Risk *fabricated* concept_ids slipping in undetected: a six-to-eight-digit integer that happens to fall in the OMOP range will type-check but may not actually exist (see Pitfall #103 below).

The ConceptMap-not-enumerate strategy instead:

- Ships a single stub CodeSystem ([`OMOPConceptsCS`](CodeSystem-omop-concepts-stub.html)) with `content = #not-present` and `^url = http://athena.ohdsi.org/search-terms/terms` — so the OMOP namespace is *resolvable* and *citable* inside the IG without claiming to enumerate it.
- Ships one ConceptMap per clinical-data domain (six at present) that names *which source codes map to which target concept_ids*. Each ConceptMap is small (10–50 mappings typically), independently verifiable against Athena, and updated only when the *source* side of the mapping changes (rarely) or when a target concept_id is corrected (Pitfall #56 cleanup, T2 S27→S28).
- Documents that every `concept_id` appearing as a `target.code` value must have been verified against Athena's `CONCEPT.csv` *at the time of insertion* — and re-verified at each release.

### ConceptMap catalogue (six maps)

The IG currently publishes six OMOP-targeted ConceptMaps. Each entry below links to the rendered HTML and gives the source side, target side, and a one-line summary of the clinical domain.

| ConceptMap | Source | Target | Clinical domain |
|------------|--------|--------|-----------------|
| [`ConceptMapHRVToOMOP`](ConceptMap-ConceptMapHRVToOMOP.html) | LOINC (HRV LOINC family) | OMOP CDM concept_id | Heart Rate Variability — first published HRV→OMOP mapping per the RS4 systematic review finding (see below). |
| [`ConceptMapCGMToOMOP`](ConceptMap-ConceptMapCGMToOMOP.html) | LOINC + custom CGM codes | OMOP CDM concept_id | Continuous Glucose Monitoring (Dexcom Stelo, FreeStyle Libre, clinical CGM). |
| [`ConceptMapActivityToOMOP`](ConceptMap-ConceptMapActivityToOMOP.html) | LOINC + wearable-derived activity codes | OMOP CDM concept_id | Physical Activity (consumer fitness trackers + clinical activity monitors). |
| [`ConceptMapSleepToOMOP`](ConceptMap-ConceptMapSleepToOMOP.html) | LOINC + wearable sleep codes | OMOP CDM concept_id | Sleep metrics (Oura, WHOOP, Apple Watch, Fitbit). |
| [`ConceptMapNutritionToOMOP`](ConceptMap-ConceptMapNutritionToOMOP.html) | Local nutrition CodeSystem | OMOP CDM concept_id | Nutrition intake (caloric, macronutrient, micronutrient). Subject of a 2026-05 governance-discipline audit (see Pitfall #56 case study below). |
| [`ConceptMapOpenEHRToOMOP`](ConceptMap-ConceptMapOpenEHRToOMOP.html) | openEHR archetype paths | OMOP CDM concept_id | openEHR archetype elements for wearable lifestyle medicine data, mapping to OMOP for federated OHDSI-network research. |

These six were chosen because they correspond to the IG's eleven clinical-domain coverage (HRV, sleep, physical activity, nutrition, glucose, mental health/mindfulness, stress, social interaction, environmental, reproductive, mobility) collapsed to the subset where (a) the source side has stable LOINC or local representation in this IG, and (b) Athena has a defensible target concept_id. Domains not yet mapped (e.g., environmental, mindfulness practice) are open work and are tracked in the GitHub issue tracker.

### RS4 empirical anchor — first published HRV→OMOP transformation

The systematic review **RS4 (Wearables × Learning Health Systems × ETL)** screened 354 papers and **found zero documented HRV-to-OMOP transformations**. The [`ConceptMapHRVToOMOP`](ConceptMap-ConceptMapHRVToOMOP.html) shipped in this IG is, to the authors' knowledge, the first publicly published artefact that names the LOINC↔OMOP correspondence for the HRV time-domain metrics. The description field of that ConceptMap states this explicitly:

> "Verified against OHDSI Athena vocabulary. Critical finding from RS4 systematic review: ZERO documented implementations of HRV-OMOP transformation in 354 papers — this ConceptMap addresses that gap."

That finding is more than provenance: it is the substantive contribution of the OMOP integration layer in this IG. The CGM, activity, sleep, and nutrition mappings have prior art in OHDSI's existing observational network; the HRV mapping does not, and it was hand-built against Athena with the source code citations preserved in the ConceptMap's element.target entries.

### Pitfall #103 — `concept_code` vs `concept_id` discipline

The OMOP CDM has two distinct identifier columns for every concept entry, and conflating them is the single most common error class observed in tabular OMOP-targeted artefacts:

- **`concept_id`** — the OHDSI-assigned integer primary key, used in `MEASUREMENT.measurement_concept_id`, `OBSERVATION.observation_concept_id`, etc. This is what a `ConceptMap.element.target.code` should hold when the target is OMOP-standardised. Examples: `4068976` (Body height), `4083586` (Body weight), `3013682` (Body Mass Index).
- **`concept_code`** — the *source-vocabulary* code as it appears in the original source (e.g., LOINC code `8302-2` for body height, SNOMED CT `50373000` for body height). This is what appears in the source side of the ConceptMap or in legacy source databases.

The two share a digit format in some ranges and can be confused at a glance. The IG has hit this confusion twice in published artefacts (RS10 Tables 2 and 11 in 2026-05; both detected and corrected via a 4-source verification protocol — see [Terminology Verification Protocol](terminology-verification.html)) and has formalised the rule as Pitfall #103 in the project's pitfall ledger:

> **Pitfall #103** — When a ConceptMap or any tabular artefact has both a source and a target column, perform a column-level role check (not just a value-level lookup): assert that every value in the target column is shaped like the expected target identifier (OMOP `concept_id` = ≥6-digit integer in the OHDSI-assigned ranges; OMOP `concept_code` = source-vocabulary string). Confusion is silent — both shapes pass schema validation; only the role check catches the swap.

The discipline is enforced before any new `ConceptMap` is published by verifying each `target.code` value with `awk -F'\t' '$1 == "<concept_id>"' /path/to/athena/CONCEPT.csv` (or equivalent SQL) and confirming the returned `concept_name` matches the source-side description. The verification protocol is documented in [Terminology Verification Protocol](terminology-verification.html); the OMOP-specific application is what is described here.

### Pitfall #56 — fabricated-mapping detection case study (ConceptMapNutritionToOMOP)

In 2026-05 a routine pre-release audit of the nutrition ConceptMap revealed that the original (2026-01) version of [`ConceptMapNutritionToOMOP`](ConceptMap-ConceptMapNutritionToOMOP.html) contained a high proportion of fabricated `target.code` values — concept_ids that look syntactically valid (six-to-seven-digit integers in the OHDSI-assigned range) but do not correspond to nutrition concepts in Athena. The ConceptMap was shipping in v0.3.0 with up to ~82–91% of its mappings pointing to unrelated concepts (e.g., nutrition→Systolic BP, protein→Avian virus antibody).

The detection and remediation cycle is documented in the project's verification record (`VRF-TERM-018`, 2026-05) and proceeded as:

1. **Detect** — a spot-check against Athena's `CONCEPT.csv` directly (not against an LLM-generated description) flagged a systematic mismatch.
2. **Quarantine** — the affected mappings were marked for remediation; no v0.4.0 release proceeded until the audit completed.
3. **Remediate** — every `target.code` was re-derived from Athena by searching for the source-side description ("dietary protein intake", "total carbohydrate intake", etc.) and selecting the closest standardised concept.
4. **Publish** — the corrected ConceptMap shipped in v0.4.1, with the description field annotated to record the audit.

The cycle is in the project record as a *governance-discipline empirical evidence point* — a pre-release audit, performed inside the IG's own governance, caught a fabricated-mapping pattern that would otherwise have entered a public release. The companion Pitfall #56 codifies the discipline: *every LLM-generated terminology binding must be verified database-first against the authoritative vocabulary; an LLM-generated description that matches a source concept is not evidence that the target concept_id is correct*.

### Vulcan FHIR-to-OMOP IG alignment

In 2026 the HL7 **Vulcan Accelerator** published an INFORMATIVE 1 release of its **FHIR-to-OMOP Implementation Guide** ([http://hl7.org/fhir/uv/fhir-to-omop](http://hl7.org/fhir/uv/fhir-to-omop), v1.0.0, R5). The Vulcan IG specifies a normative *transformation contract* between FHIR resources (Observation, Condition, MedicationRequest, Procedure, etc.) and OMOP CDM tables (MEASUREMENT, CONDITION_OCCURRENCE, DRUG_EXPOSURE, PROCEDURE_OCCURRENCE), including the role of ConceptMaps in the transformation pipeline.

This IG is **compatible-by-design** with the Vulcan FHIR-to-OMOP IG, with two complementary positioning notes:

1. **Scope complementarity, not duplication.** The Vulcan IG covers the *generic* FHIR↔OMOP transformation patterns at the resource level (Observation→MEASUREMENT, etc.). This IG provides the *domain-specific* terminology mappings for lifestyle-medicine concepts (HRV, CGM, activity, sleep, nutrition, openEHR-derived data) — content the Vulcan IG does not specify. The two compose: a Vulcan-conformant ETL engine can ingest the ConceptMaps from this IG and apply the Vulcan transformation rules.
2. **Repositioning the post-defense ETL work (RS13).** The HEADS-ETL pipeline described in [Implementation Scope and Roadmap](implementation-scope-and-roadmap.html) is now positioned as a *Vulcan-conformant implementation* of the patterns this IG specifies for the lifestyle-medicine vertical, rather than a novel ETL framework. This is a deliberate de-claim — the academic contribution narrows from "new ETL pipeline" to "first lifestyle-medicine-vertical FHIR-to-OMOP ConceptMap suite, conformant to Vulcan v1.0.0 FHIR-to-OMOP IG and addressing the HRV gap RS4 documented".

The repositioning is the operational reading of Pitfall #110 — *external-input survey before scoping new work*: a thorough scan of the OHDSI and HL7 ecosystems for prior art was the precondition for narrowing the IG's claimed novelty without losing the substantive contribution (the HRV→OMOP first-publication anchor + the lifestyle-medicine domain coverage).

### Architecture (high-level)

The pattern below shows how the IG, the HEADS-ETL pipeline (external, post-defense), and the Athena vocabulary compose at runtime. The IG ships only the leftmost column; the engines, OMOP database, and Athena vocabulary are all external.

```
This IG                            HEADS-ETL pipeline                OMOP database
─────────────────────              ───────────────────────────       ─────────────────
FHIR Observation                                                     MEASUREMENT
  + LOINC code 80404-7   ──────►   Vulcan transformation rule  ─►      measurement_concept_id
  (SDNN HRV)                       (Observation→MEASUREMENT)            = ConceptMapHRVToOMOP
                                                                          target lookup
                                   ConceptMap.element[
                                     source = LOINC 80404-7
                                     target = OMOP concept_id N
                                   ]
                                            │
                                            ▼
                                   Apply target concept_id
                                   to MEASUREMENT row

Athena vocabulary  (external, authoritative)
─────────────────────────────────────────────
CONCEPT.csv  →  concept_id N  →  concept_name "R-R interval.standard deviation"
                                  domain = MEASUREMENT
                                  standard_concept = "S"
```

A ConceptMap in this IG names the leftmost arrow (source→target). A Vulcan-conformant ETL engine implements the middle column (transformation rule). Athena owns the rightmost column (vocabulary). Each column is independently maintained, independently versioned, and independently auditable.

### What this does not do

- It does not embed any subset of the OMOP vocabulary larger than what appears as `target.code` values inside the six ConceptMaps.
- It does not specify an ETL engine, a transformation runtime, or a query language. The Vulcan IG owns the engine layer; the HEADS-ETL repository (post-defense, RS13) owns the implementation.
- It does not ship CDM table definitions (`MEASUREMENT`, `OBSERVATION`, `CONDITION_OCCURRENCE`, etc.) — those are defined by OHDSI in the [OMOP CDM specification](https://ohdsi.github.io/CommonDataModel/).
- It does not maintain a SQL schema for the OMOP database — the OHDSI [`CommonDataModel`](https://github.com/OHDSI/CommonDataModel) repository is the canonical source.
- It does not provide ETL test data or synthetic patient cohorts — Synthea and the OHDSI synthetic Eunomia dataset are the standard tooling.

Each "does not" item is the substantive content of an existing OHDSI artefact or of post-defense RS13 work, and is referenced rather than duplicated in this IG. The deliberate narrowing protects the IG's claim of novelty (the HRV gap and the lifestyle-medicine domain coverage) from being diluted.

### Artefact index for this page

| Layer | Artefact | Notes |
|-------|----------|-------|
| CodeSystem | [`OMOPConceptsCS`](CodeSystem-omop-concepts-stub.html) | Stub (`content = #not-present`); anchors OMOP namespace; points to Athena |
| ConceptMap | [`ConceptMapHRVToOMOP`](ConceptMap-ConceptMapHRVToOMOP.html) | First-published HRV→OMOP mapping (RS4 finding) |
| ConceptMap | [`ConceptMapCGMToOMOP`](ConceptMap-ConceptMapCGMToOMOP.html) | Consumer + clinical CGM |
| ConceptMap | [`ConceptMapActivityToOMOP`](ConceptMap-ConceptMapActivityToOMOP.html) | Wearable + clinical activity |
| ConceptMap | [`ConceptMapSleepToOMOP`](ConceptMap-ConceptMapSleepToOMOP.html) | Multi-vendor sleep metrics |
| ConceptMap | [`ConceptMapNutritionToOMOP`](ConceptMap-ConceptMapNutritionToOMOP.html) | Subject of Pitfall #56 case study (T2 S27→S28 remediation) |
| ConceptMap | [`ConceptMapOpenEHRToOMOP`](ConceptMap-ConceptMapOpenEHRToOMOP.html) | Cross-standard bridge for federated research |

### Related pages

- [ConceptMaps Architecture](conceptmaps.html) — general ConceptMap design rationale (across all standards, not just OMOP).
- [openEHR Integration](openehr-integration.html) — the openEHR side that `ConceptMapOpenEHRToOMOP` bridges from.
- [Terminology Verification Protocol](terminology-verification.html) — the database-first verification protocol cited under Pitfall #103.
- [Implementation Scope and Roadmap](implementation-scope-and-roadmap.html) — explicit statement that ETL execution is RS13 (post-defense).
- [Integrated Walkthrough (M4)](smart-cds-integrated-walkthrough.html) — runtime example (does not invoke OMOP, but the same source observations would feed an OMOP ETL).
- [LLM/AI Integration](llm-ai-integration.html) — companion governance layer for AI augmentation of CDS.
- [GDL Integration](gdl-integration.html) — guideline logic that can be authored against either FHIR or openEHR sources, then mapped through to OMOP via the maps on this page.
