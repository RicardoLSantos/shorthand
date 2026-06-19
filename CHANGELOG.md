# Changelog - iOS Lifestyle Medicine FHIR Implementation Guide

## [Unreleased]

## [0.4.4] - 2026-06-19

### Changed
- **Course-CI narrative accuracy (T1 S59 staged → T2 S45 applied)** — `fhir-intermediate-course-alignment.md` items 4.3 + 4.9 corrected from an *under-claim* ("CI tooling = roadmap / not yet implemented") to ✅ DONE (spec + CI): the CDS Hooks Card validation is a Python `jsonschema` validator (`.github/scripts/validate_cds_cards.py`, `--self-test`) in a hard-fail GitHub Actions workflow (`cds-card-validation.yml`), and the ConceptMap drift mitigation a weekly Python drift-check (`.github/scripts/conceptmap_drift_check.py`, Database-First local + tx.fhir.org advisory) in `conceptmap-drift.yml` (continue-on-error) — both shipped in commit `f2bff6fe9` (T1 S55). The 10/13 = 76.9% in-IG-scope figure is unchanged (these items were already counted as satisfied; this upgrades only *how*).

### Source counts (FSH)
- Profiles 96 / Extensions 77 / CodeSystems 19 / ValueSets 204 / Instances 265 = **661 artefacts** (unchanged vs v0.4.3 — pagecontent-only edit). Built with IG Publisher 2.2.7 + EN locale + A3 JVM flags; genonce **err=0 / warn=1 / 0 broken links**. The single warning is the upstream `hl7.fhir.uv.ips` 2.0.0→2.0.1 dependency-staleness advisory (HL7 published IPS 2.0.1 after the v0.4.3 build) — benign and informative, **not introduced by this change**; the IPS-upgrade decision is deferred to a future release (T1/FSH lane). NOT suppressed (an "upgrade the dependency" advisory should surface, not be hidden).

## [0.4.3] - 2026-06-13

### Added
- **SpO₂ dual-coding (US Core Pulse Oximetry pattern)** — `OxygenSaturationObservation` now slices `code` into `O2Sat` (1..1, LOINC `2708-6` — the FHIR `oxygensat` method-independent anchor, mandated by R4/R5 core) + `PulseOx` (1..1, LOINC `59408-5` — pulse-ox method). Aligns the IG with the most widely implemented FHIR profile (US Core) and the HL7 discussion FHIR-31574. C1 remediation (T1 S57 FSH `b98a5d76d` + T2 S43 narrative).
- **`SdnnObservation`** profile (parent `LifestyleVitalSigns`, LOINC `80404-7`, ms) + example — H1; the HRV-SDNN ETL (`fhir_hrv_sdnn.json`) already targeted it (T1 S57).
- **`VitalSignsPanel`** profile (LOINC `85353-1`, `hasMember` → HR/BP/SpO2/Temp/RR + Body Metrics) + 8-member example; `85353-1` added to `ValueSetLOINCObservations` (M5, T1 S57).
- **Narrative**: new `### SpO₂ Coding — Pulse Oximetry vs Arterial Blood Gas` subsection (`vitalsigns.md`) + 4 pagecontent pages aligned to the dual-coding (`vitalsigns` / `advanced_vitalsigns` / `conformance` / `bibliography`) (T2 S43).

### Fixed / Changed
- **C1 (Critical) SpO₂ wearable** — default `2708-6` ("Oxygen saturation in Arterial blood", read as ABG/invasive) → dual-coding `2708-6` (anchor) + `59408-5` (pulse-ox method). AI-flagged (Fable 5 audit) + clinician-confirmed + FHIR-conformance-driven (the `oxygensat` profile fixes `2708-6`) → tri-axial co-validation; `2708-6` retained in the ValueSet for true arterial samples (T1 S57).
- **H2/H3** — `BodyMetricsObservation` + `AdvancedVitalSigns` re-parented `Observation` → `LifestyleVitalSigns` (inherit vs-1/2/3 invariants; manual `category` removed) (T1 S57).
- **M4** — `AdvancedVitalSignsExample` code `8716-3` display "Vital signs note" → "Vital signs" (Athena Database-First) (T1 S57).
- **M6** — `dataAbsentReason 0..1 MS` in `LifestyleVitalSigns` (vs-2 escape-hatch) (T1 S57).
- **M2 (terminology, T1 S58)** — `HeartRateVariabilityCodeSystem.fsh` renamed → `ValueSetHeartRateVariability.fsh` (the file declares a ValueSet; `Id`/canonical unchanged) + `hrv-*` custom codes re-attributed to their real CodeSystem (`LifestyleMedicineTemporaryCS`, Database-First) in `BulkExportGroup.fsh` + `cds-hooks-integration.md` + `hrv-overtraining.json` card.
- **README** refreshed to v0.4.3 reality (96P/77E/19CS/204VS/265I/661) + RISE-Health affiliation (Pitfall #98; CINTESIS retired) + RS10-published note + private-repo links dropped (T1 S58 + T2 S43).

### Source counts (FSH)
- Profiles **96** / Extensions 77 / CodeSystems 19 / ValueSets 204 / Instances **265** = **661 artefacts** (+4 vs v0.4.2: +`SdnnObservation` +`VitalSignsPanel` profiles, +2 examples). Built with IG Publisher 2.2.7 + EN locale + A3 JVM flags; err=0 / warn=0 (genonce-verified this release).

## [0.4.2] - 2026-06-08

### Added
- **Activity profile device-method binding (T1 S53)**: `PhysicalActivityObservation` gains 2 component slices — `moderateMinutes` (LOINC `101689-8` "Duration of moderate activity") + `vigorousMinutes` (LOINC `101690-6` "Duration of vigorous activity"), UCUM `min`, Database-First Athena-verified (std=S). Resolves the profile↔ConceptMap inconsistency flagged by T2 S38: the device-method codes lived only in the 3 openEHR ConceptMaps + the OMOP map, with **no profile binding them**. The profile now guarantees them — closing the openEHR↔FHIR↔OMOP round-trip (VRF-TERM-019 addendum, T1 S53). `sushi .` 0/0.

### Fixed
- **Terminology (#147)**: `SubstanceUseValueSets` Amphetamine code `SCT#373338002` (INACTIVE since 2014-07-31, shipped in v0.4.1) → active successor `SCT#703842006` "Amphetamine" (Database-First Protocol v3: OMOP `CONCEPT_RELATIONSHIP` replaced-by `4188670`→`45773119` + tx.fhir.org `$lookup inactive=false` @ SNOMED Intl 20250201). `sushi .` 0/0; genonce-verified this release (v0.4.2).
- **Terminology (F1/F2, T2 S38)**: openEHR ConceptMap internal-consistency alignment (display/comment text only — no code/binding changes). **F2** — activity moderate/vigorous LOINC in `ConceptMapFHIRToOpenEHR` + `ConceptMapOpenEHRToFHIR` aligned from IPAQ-survey `77592-4`/`77593-2` → device-method `101689-8`/`101690-6` (matching the Athena-verified `ConceptMapOpenEHRToOMOP`; device codes are the correct fit for wearable data — resolves a 3-map internal inconsistency). **F1** — sleep Deep/REM comments in `ConceptMapFHIRToOpenEHR` updated "Custom code - no LOINC" → `93831-6` (Deep) / `93829-0` (REM), already used IG-wide (SleepProfile, ConceptMapSleepToLOINC, ConceptMapSleepToOMOP, examples). All 4 codes tx.fhir.org `$lookup inactive=false` (Database-First 2-source; VRF-TERM-019). Makes the openEHR narrative's "queued to terminology lane" footnote (T1 S51) true. **Applied in profile + narrative (T1 S53).**
- **openEHR narrative reconciliation (T1 S53)**: `openehr-integration.md` — sleep Deep/REM rows `custom code†` → `93831-6`/`93829-0` (the `SleepProfile` already bound them; the table was stale); activity rows IPAQ-survey → device-method; binding-status footnote `queued` → **APPLIED**.

### Source counts (FSH)
- Profiles 94 / Extensions 77 / CodeSystems 19 / ValueSets 204 / Instances 263 (**657 artefacts — unchanged vs v0.4.1**; the 2 new activity component slices are intra-profile, not new artefacts). Built with IG Publisher 2.2.7 + EN locale + A3 JVM flags; err=0 / warn=0 target (genonce-verified this release).

## [0.4.1] - 2026-06-01

### Added
- **LifestyleMedicationRequest** profile (`lifestyle-medication-request`) — MedicationRequest specialization with `DrugLifestyleInteraction` extension (local CodeSystems: maoi-tyramine / ssri-alcohol / anticoagulant-vitamink) — concrete FHIR resource for the CDS Hooks `drug-lifestyle-interaction` service (T1 S44).
- Server CapabilityStatement enriched: MedicationRequest resource (typed search params) + Observation `$lastn` operation (T1 S44).
- Narrative pages: `gdl-integration.md` (GDL2→CDS Hooks bridge + honest scope: native GDL2 engine = openEHR-side, out-of-scope/RS13) + `implementation-scope-and-roadmap.md` (artifact-vs-deployment scope; operational layers CDR/CDS-endpoint/OMOP-ETL/OCL/GDL-engine/CQL-exec/LLM-RAG = RS13 post-defense) (T1 S45/S45 EXT).
- Narrative page: `smart-cds-integrated-walkthrough.md` (M4 integrated walkthrough; SMART+CDS+ETL+Audit+Bulk+Consent across a single Apple HealthKit HRV-decline cohort; defensible-by-IG-content-only per Pitfall #57) (T1 S46).
- 2 thin CQL Library doc-pointer resources (`LibraryCVR003HRVRisk` + `LibraryMET002MetabolicOverride`) resolving 3 unresolved `ClinicalImpression.protocol[0]` references; URLs use the CQL coordinate convention (`urn:cql:library:<id>:<version>`) exempted via `sushi-config.yaml parameters: special-url:` (T1 S46; Pitfall #112 NEW).

### Fixed
- **Build errors 5 → 0** (T1 S43): 3 Consent terminology errors (`regulatory-framework-cs#gdpr` → `AppLogicCS#gdpr`, resolves locally — removes tx.fhir.org dependency, Pitfall #100) + 2 `Group.characteristic [Range]` binding errors (drop `valueRange` narrowing on inherited slice). **Zero suppression** (USER firm rule, T2 S21).
- **41 supportedProfile canonical references** PascalCase → kebab-case FSH Id (Pitfall #101) across LifestyleMedicineCapabilityStatement + PatientDataPipelineCapability; map-based per-canonical audit, not blind sed (T1 S45; convergent with T2 S33 fix-list).
- **SleepObservation Id root-fix**: `activity-observation` → `sleep-observation` (Sleep profile was published under the wrong canonical; blast-radius grep = 1) (T1 S45).
- **VRF-TERM-018 terminology remediation** (T2 S33): ~26 wrong-concept SNOMED/LOINC codes corrected (right code-system + valid code + WRONG concept — invisible to the FHIR validator). Examples: At-rest `255214003`→`263678003`; Abdomen `62413002`(=Radius)→`818983003`; Back `32849002`(=Esophagus)→`281213008`; Amphetamine `75672003`(=Platelet volume)→`373338002`; Holter `252339003`(=Iodination)→`427047002`; VO2max `92841-6`(=Countermeasure report)→`60842-2` "Oxygen consumption (VO2)". Method: Database-First (Vocab2/Athena) + tx.fhir.org `$validate-code` (Pitfall #109, Lesson #527). Origin: Dec 2024, LLM-assisted FSH pre-Database-First (git-blame, Pitfall #71).
- **5 SNOMED inactive → active** swaps (Database-First + family check, Pitfall #55) (T2 S32).
- **T1 Fase 3 warnings 137 → 1** (-99%): NamingSystem `<vendor>`→`{vendor}` placeholder convention; `etl-group-characteristic` http→https 6 refs; ~40 accept-class suppressions refreshed with exact full-message text in EN (Pitfall #64); special-url for 2 CQL Library urns (T1 S46).
- **T2 S35 Opção γ — bulk-export-group-category example** (1-line fix; root-cause): `LifestyleMedicineGroupETL.fsh:211` `bulk-export-group-category#research` → `v3-ActReason#HRESCH` (HL7 standard, already enumerated in `BulkExportGroupCategoryVS`). Refines T1 S46 CoC Decisão 3.1 (which had proposed creating a local CS — would have duplicated HL7 standard terminology, Pitfall #33 risk). USER ratified γ via AskUserQuestion 2026-05-28 11:13 WEST after empirical diagnostic.
- **T2 S35 — 2 display normalisations** in `BulkExportGroupCategoryVS`: `HQUALIMP` "healthcare quality improvement" → "health quality improvement"; `HSYSADMIN` "healthcare system administration" → "health system administration" (matches v3-ActReason canonical; resolves 2 INFORMATION entries; Pitfall #33 sub-rule).

### Changed
- **T2 S35 — Build script locale**: added `export LANG=en_US.UTF-8` + `export LC_ALL=en_US.UTF-8` to `_genonce.sh` (T2 lane, gitignored). T1 S46 CoC Decisão 3.3 — root-cause Pitfall #64 (locale-driven message drift between IG Publisher versions); EN-side `ignoreWarnings.txt` entries (authored by T1 S46) now match emitted warning messages. Lesson #538.
- Warnings **137 → 0** (cumulative: T1 Fase 3 −136 [41 supportedProfile + 9 NamingSystem placeholder + 6 etl-group-characteristic + ~40 accept-class refresh + minor] + T2 S35 Opção γ −1 = 0; remaining ~48 fragment-CS ACCEPTED per Pitfall #61, suppressed in `ignoreWarnings.txt`).
- 5 flagged terminology codes (Fair `445511000124105`, wearable-monitoring, device-prescription, meal-frequency `45978-4` #relatedto, dependent-count `68508-1` #relatedto): documented as defensible local CodeSystem gaps OR `#relatedto` bridges per Database-First menu (T2 S34, `T2_TO_T1_FLAGGED_CODES_DBFIRST_MENU_20260527_101517.md`). 3/5 = genuine terminology gaps (the IG/thesis HRV-gap finding), 2/5 = LOINC-bridge with #relatedto.

### Methodology / provenance
- Database-First display-semantic terminology audit IG-wide (163 LOINC + 167 SNOMED) via `$lookup` (existence) + `$validate-code` (concept correctness). This release is a demonstration of the IG's own anti-LLM-hallucination thesis (Pitfall #33; RS11/RS12).
- Built with IG Publisher 2.2.7 + A3 JVM DNS flags (Pitfall #100) + EN locale (Pitfall #64 Lesson #538); err=0, warn=0, 0 broken links.
- Special-url exemptions documented in `sushi-config.yaml parameters: special-url:` for non-namespace canonicals (vendor APIs, athena/ckm, CQL library urns); Pitfall #112 refines Pitfall #61 (URL-mismatch errors on complete-content resources DO accept special-url).

### Source counts (FSH)
- Profiles 94 / Extensions 77 / CodeSystems 19 / ValueSets 204 / Instances 263 (657 artefacts; +1 Library doc-pointer Instance vs T1 S45 baseline; +0 vs T1 S46 close 263I).

---

## [0.4.0] - 2026-05-21

### Errata vs v0.3.0 (Pitfall #67 conditional disclosure — v0.3.0 immutable per Pitfall #66)

> **Notice — v0.3.0 known issue**: `ConceptMapNutritionToOMOP.fsh` shipped in v0.3.0 contained 11/11 fabricated OMOP `concept_id` mappings (e.g., `nutrition-caloric-intake → 3004249` = "Systolic blood pressure" per OHDSI Athena, NOT caloric intake). Root cause: ConceptMap committed 2026-01-12 (pre-Database-First Protocol) without empirical Athena verification. **Detected** via T2 S27 (2026-05-21 12:00 WEST) systematic Pitfall #103 audit of T2 ConceptMaps. **Remediated** in v0.4.0 commit `c1d51e511` (2026-05-21 13:40 WEST) — all 11 mappings replaced via Database-First Protocol (Athena CONCEPT.csv direct lookup; Pitfall #56 + #103 + Lesson #461 4-source verification). v0.3.0 GitHub Release remains immutable; users citing v0.3.0 should reference this errata callout for any nutrition ConceptMap usage.

- **id41 (Physiological state) audit false-positive resolved**: T2 S28 CN2 audit (2026-05-21 14:05 WEST) flagged `id41 → 4287468` as "minor" (Athena CONCEPT.csv returned empty); T2 S29 (2026-05-21 18:55 WEST) Database-First v2 lookup via Vocab2 CONCEPT.csv (SNOMED-containing) confirmed mapping is **VERIFIED CORRECT** (concept_id 4287468 = "Body position" SNOMED 397155001 Standard, Domain=Observation). Root cause: Athena LOINC-only database vs Vocab2 SNOMED-containing database semantics. **Audit methodology lesson #494 candidate**: ConceptMap audit scripts must select target-vocabulary-aware database (LOINC→Athena, SNOMED→Vocab2).

### Added (since v0.2.0 = cumulative v0.2.0→v0.3.0→v0.4.0)

#### New Profiles in v0.4.0 (4 net Profiles added since v0.3.0)

T2 S24 (2026-05-15):
1. **LifestyleMedicineETLBatch** — `lifestyle-medicine-etl-batch` (Bundle.type=batch with 4 entry slices for RS4+RS13 ETL provenance)
2. **WearableMeasurementProvenance** — `wearable-measurement-provenance` (specializes HL7 PHD `PGHDProvenance`; 75-80% scope reuse; reference target Observation)

T2 S25 (2026-05-19):
3. **PatientDataPipelineCapability** — `patient-data-pipeline-capability` (Instance pattern, CapabilityStatement with 3 Pipeline Extensions: rate-limit Quantity + retry-semantics + error-reporting)
4. **LifestyleMedicineGroupETL** — `lifestyle-medicine-group-etl` (specializes HL7 Bulk Data `BulkExportGroup`; 4 ETL Extensions: vendor-cohort + time-window + transformation-pipeline + destination-warehouse; characteristic slicing on `code`)

#### New Profiles in v0.3.0 (5 Profiles added between v0.2.0 and v0.3.0)

(Backfill from v0.3.0 GitHub Release notes 2026-05-14:)
- **AuditEventDataAccess** — `audit-event-data-access` (FHIR Audit Event Pattern, ISO 27789 alignment)
- **AuditEventAIInteraction** — `audit-event-ai-interaction` (EU AI Act Art. 12 logging requirements)
- **MultiJurisdictionalConsent** — `multi-jurisdictional-consent` (LGPD + GDPR + HIPAA mapping)
- **BulkExportGroup** — `bulk-export-group` (HL7 FHIR Bulk Data Access v2.0.0 cohort definition)
- **BulkExportConsent** — `bulk-export-consent` (research consent for population-scope export)

#### New Extensions in v0.4.0 (+11 since v0.3.0)

T2 S24 — 4 wearable Extensions on `WearableMeasurementProvenance`:
- `firmwareVersion`, `timeOfMeasurement`, `timeOfUpload`, `transformationLineage`

T2 S25 — 3 Pipeline Extensions on `PatientDataPipelineCapability.rest`:
- `pipeline-rate-limit` (Quantity, requests/sec), `pipeline-retry-semantics` (string), `pipeline-error-reporting` (url)

T2 S25 — 4 ETL Extensions on `LifestyleMedicineGroupETL.characteristic`:
- `etl-vendor-cohort`, `etl-time-window`, `etl-transformation-pipeline`, `etl-destination-warehouse`

#### New CodeSystem in v0.4.0 (+1 since v0.3.0)

T2 S25:
- **ETLGroupCharacteristicCS** — `etl-group-characteristic` (4 codes: vendor-cohort, time-window, transformation-pipeline, destination-warehouse — IG-local stability for Bulk Export ETL Group characteristic discriminators)

#### New Instances + Examples in v0.4.0 (+7 since v0.3.0)

T2 S24:
- `LifestyleMedicineETLRunIdNamingSystem` (Instance of NamingSystem)
- `ProvenanceETLBatch` (Instance of Provenance with urn:uuid ref)
- `WearableMeasurementProvenanceAppleHRVExample` (Instance of WearableMeasurementProvenance — Apple Watch HRV with firmware lineage)
- `LifestyleMedicineETLBatchAppleExample` (Instance of LifestyleMedicineETLBatch — Apple HealthKit batch)
- `ProvenanceUpdated` (revised Provenance instance)

T2 S25:
- `AppleHealthKitPatientDataPipelineExample` (Instance of PatientDataPipelineCapability — 10 req/s + exp backoff)
- `AppleHRVDecline90dCohortGroupExample` (Instance of LifestyleMedicineGroupETL — LOINC 80404-7 SDNN + 90d HRV decline cohort criterion)

### Changed

#### Production counts (post-sushi build verification)

| Metric | v0.2.0 | v0.3.0 | **v0.4.0** | Δ v0.3.0→v0.4.0 |
|---|---:|---:|---:|---:|
| Profiles | 81 | 90 | **93** | +3 |
| Extensions | ~55 | 65 | **76** | +11 |
| CodeSystems | ~14 | 17 | **18** | +1 |
| ValueSets (sushi-parsed) | ~190 | 203 | **203** | 0 |
| ValueSets (FSH source raw grep) | n/a | 203 | **204** | +1 |
| Instances | ~232 | 253 | **260** | +7 |
| **Total artifacts** (sushi) | ~572 | **628** | **650** | +22 |

#### IPS upstream Pitfall #31 baseline ELIMINATED

T2 S25 (iter13) + T2 S26 (iter14 retry) — **2 consecutive builds with 0 IPS upstream errors** (vs v0.3.0 build iter9 = 22 IPS upstream errors per `note|5.3.0-ballot-tc1` extension reference). Forensic H1 CONFIRMED via SUSHI log: `Resolved hl7.fhir.uv.extensions.r4#latest to concrete version 5.3.0` (formal release, NOT pre-release `5.3.0-ballot-tc1`). HL7 published formal `hl7.fhir.uv.extensions.r4#5.3.0` package between 13 Mai (iter8 had 21 IPS errors) and 19 Mai (iter13 + iter14 retry had 0 IPS errors). H2 (IG Publisher 2.2.7 behavior change) + H3 (race condition) RULED OUT empirically (2 consecutive builds with same outcome).

#### IG Publisher unchanged

- IG Publisher 2.2.7 (unchanged since v0.3.0)
- A3 JVM flags `-Dnetworkaddress.cache.ttl=0 -Dnetworkaddress.cache.negative.ttl=0 -Dsun.net.http.retry-on-error=true -Djava.net.preferIPv4Stack=true` (unchanged since v0.3.0)

### Audit transparency (Pitfall #67 conditional disclosure)

- **CN1 method**: Database-First Protocol (Pitfall #56 + #103) — Athena CONCEPT.csv direct lookup for OMOP `concept_id`s; NEVER trust LLM for exact code lookup (33%+ empirical error rate validated 2026-02-09). 11/11 fabrications in `ConceptMapNutritionToOMOP.fsh` corrected in v0.4.0.
- **CN2 audit (T2 S28)**: 5 OMOP-targeting ConceptMaps (Activity + CGM + HRV + Sleep + OpenEHR) — 4/5 fully clean + 1 minor false-positive (id41 SNOMED, resolved via Vocab2 lookup in T2 S29).
- **CN3 future scope (deferred post-G1+RS11 submission)**: pre-2026-02 ConceptMaps with LOINC/SNOMED/openEHR targets — systematic Database-First verification with target-vocabulary-aware DB selection (LOINC→Athena, SNOMED→Vocab2).

### Build provenance

- Build: iter16 (estimated ~25-30 min wall-clock; IG Publisher 2.2.7)
- A3 JVM flags applied (Pitfall #100 v4 — tx.fhir.org server-side transient handling)
- iter14 retry baseline: 17 errors (1 IG Publisher 2.2.7 quirk on Group.characteristic [Range] binding + 14 transient `UnknownHostException` per Pitfall #100 v4 documented + 2 IPS-related)
- Pre-flight tx.fhir.org HTTP 200 / 0.5s ✅
- Pitfall #65 v5 disk ≥12 Gi prod threshold MET (12 Gi free at iter16 trigger)

### Methodology — Counts

Canonical FSH source enumeration uses recursive grep: `grep -rh '^Profile:' input/fsh/ | wc -l` (and equivalents for Extension, CodeSystem, ValueSet, Instance, NamingSystem, ConceptMap). Production counts (post-sushi parse) may differ by ≤1 from canonical FSH source counts due to: (a) FSH declarations that fail sushi validation get filtered, (b) duplicate FSH declarations get deduplicated. For reviewer transparency, both metrics are reported for ValueSets (v0.4.0: 203 sushi-parsed vs 204 FSH source raw grep). Bash `**` glob WITHOUT `shopt -s globstar` recurses only 1 level — use recursive grep instead (lesson learned T2 S29 Phase 4).

### Compatibility

- FHIR R4 (4.0.1) — unchanged
- Dependencies: `hl7.fhir.uv.ips#2.0.0` + `hl7.fhir.us.physical-activity#1.0.0` + `hl7.fhir.uv.phd#1.1.0` + `hl7.fhir.uv.bulkdata#2.0.0` + `ihe.iti.pcf#1.1.0` — unchanged since v0.3.0
- IG Publisher: 2.2.7 — unchanged since v0.3.0

---

## [0.3.0] - 2026-05-14 (backfilled from GitHub Release notes per T2 S29 in-repo CHANGELOG hygiene)

### Overview

Production-ready FHIR R4 Implementation Guide release adding **SMART on FHIR STU2.2**, **CDS Hooks 2.0 Service Declaration**, **Bulk FHIR Export**, **AuditEvent profiles**, and **Multi-Jurisdictional Consent** support.

### Added (T2 S20-S23 cycle)

#### New Profiles (5)

- **AuditEventDataAccess** — `audit-event-data-access` (FHIR Audit Event Pattern, ISO 27789 alignment)
- **AuditEventAIInteraction** — `audit-event-ai-interaction` (EU AI Act Art. 12 logging requirements)
- **MultiJurisdictionalConsent** — `multi-jurisdictional-consent` (LGPD + GDPR + HIPAA mapping)
- **BulkExportGroup** — `bulk-export-group` (HL7 FHIR Bulk Data Access v2.0.0 cohort definition)
- **BulkExportConsent** — `bulk-export-consent` (research consent for population-scope export)

#### New Instances + CapabilityStatement (4)

- **LifestyleMedicineCDSHooksDiscovery** (MessageDefinition) — CDS Hooks 2.0 4-service catalog
- **LifestyleRiskAssessmentPlanDefinition** (PlanDefinition) — service logic encoding per-hook
- **LifestyleMedicineCDSServicesRegistry** (Library) — runtime discovery payload parameters
- **LifestyleMedicineSMARTCapabilityStatement** (CapabilityStatement) — SMART STU2.2 conformance

#### New CodeSystem (1 local)

- **CDSHooksHookTypesCS** — `cds-hooks-hook-types` (4 hooks: patient-view, order-sign, medication-prescribe, encounter-discharge — IG-local stability for CDS Hooks 2.0 hook identifiers)

#### Pagecontent narratives (2, T1 ownership per Path 4b)

- SMART on FHIR Integration (~1.7K words) — `smart-on-fhir-integration.html`
- CDS Hooks Integration (~2.0K words) — `cds-hooks-integration.html`

### Production Counts v0.3.0 (post-build verified)

| Metric | v0.2.1 | **v0.3.0** |
|---|---:|---:|
| Profiles | 87 | **90** |
| Extensions | 61 | **65** |
| CodeSystems | 15 | **17** |
| ValueSets | 197 | **203** |
| Instances | 240 | **253** |

### New Dependencies

- `hl7.fhir.uv.bulkdata#2.0.0` — NEW (T2 S21; resolves group-export canonical)

### Build Discipline + Quality Gates

- **Pitfall #100 v3 (T2 S21)**: JVM tx.fhir.org DNS transient — A3 flags reduced `UnknownHostException` from 44 (iter8) → 14 (iter9, 68% reduction)
- **Pitfall #101 NEW (T2 S22)**: pagecontent kebab-case discipline — iter9 with B1 fix → 0 broken-link errors (100% resolved)
- **Root-cause discipline (USER firm rule msg 5)**: ZERO `ignoreWarnings.txt` additions for any new error category since v0.2.1 baseline
- **Final qa.txt**: 37 errors (22 IPS upstream Pitfall #31 + 14 `UnknownHostException` + 1 Group [Range] quirk); 133 warnings; 0 broken links (`2,846,324 links checked`)

### Canonical URLs (G1 RS12 antecedent infrastructure)

Production-ready URLs for academic citation:
- https://2rdoc.pt/ig/ios-lifestyle-medicine/MessageDefinition/LifestyleMedicineCDSHooksDiscovery
- https://2rdoc.pt/ig/ios-lifestyle-medicine/PlanDefinition/LifestyleRiskAssessmentPlanDefinition
- https://2rdoc.pt/ig/ios-lifestyle-medicine/Library/LifestyleMedicineCDSServicesRegistry
- https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cds-hooks-hook-types
- https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/audit-event-data-access
- https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/audit-event-ai-interaction
- https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/multi-jurisdictional-consent
- https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/bulk-export-group
- https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/bulk-export-consent
- https://2rdoc.pt/ig/ios-lifestyle-medicine/CapabilityStatement/LifestyleMedicineSMARTCapabilityStatement

### License + Citation v0.3.0

License: CC-BY-4.0 — Publisher: Ricardo Lourenço dos Santos (Universidade do Porto — FMUP, RISE-Health) — Canonical: https://2rdoc.pt/ig/ios-lifestyle-medicine — Package: iOS-Lifestyle-Medicine#0.3.0

---

## [0.2.0] - 2026-02-19

### Build Quality
- **Warning suppressions implemented**: Reduced warnings from 145 to 71 (-51%)
- **ignoreWarnings.txt**: PT locale messages for suppressible validation messages
- **Documented IPS upstream limitation**: `note|5.3.0-ballot-tc1` extension never published
- **Cross-paradigm ConceptMaps**: openEHR/OMOP targets documented as expected warnings
- **HTML validation**: 7907/7907 pages valid (100%)
- **Broken links**: 0

### Added

#### New Profiles (6 profiles)
1. **CyclingDynamicsObservation** (`SportSpecificProfiles.fsh`)
   - Power metrics (instantaneous, average, normalized, max)
   - FTP, TSS, Intensity Factor
   - Cadence and left/right balance
   - Coggan power zones (1-7)
   - Based on openEHR archetype `cycling_dynamics.v0`

2. **RunningDynamicsObservation** (`SportSpecificProfiles.fsh`)
   - Ground contact time and balance
   - Vertical oscillation and ratio
   - Running power (Stryd/Garmin compatible)
   - Stride length, cadence, pace
   - Footstrike type classification
   - Injury risk indicator
   - Based on openEHR archetype `running_dynamics.v0`

3. **SwimmingMetricsObservation** (`SportSpecificProfiles.fsh`)
   - SWOLF score (Swimming Golf)
   - Stroke metrics (type, rate, distance per stroke)
   - Lap counting and pace
   - Swimming environment (pool/open water)
   - Aerobic/Anaerobic Training Effect
   - Based on openEHR archetype `swimming_metrics.v0`

4. **StrengthTrainingObservation** (`SportSpecificProfiles.fsh`)
   - Sets, reps, load tracking
   - Velocity-based training metrics (VBT)
   - 1RM testing and estimation
   - Volume load calculation
   - Session RPE and training load
   - Based on openEHR archetype `strength_training.v0`

5. **CGMObservation** (`CGMProfile.fsh`)
   - Continuous glucose monitoring specific
   - Time in Range (TIR) per International Consensus 2019
   - Glycemic variability (CV, GMI)
   - Trend arrows and rate of change
   - Supports Dexcom, Libre, consumer CGM (Levels, Stelo)
   - Based on openEHR archetype `blood_glucose_cgm.v0`

6. **RecoveryReadinessObservation** (`RecoveryVO2maxProfiles.fsh`)
   - Vendor readiness scores (Oura, WHOOP, Garmin, Fitbit)
   - Contributing factors (sleep, HRV, resting HR)
   - Strain-recovery balance
   - Training status classification
   - Based on openEHR archetype `recovery_readiness.v0`

7. **VO2MaxEstimationObservation** (`RecoveryVO2maxProfiles.fsh`)
   - Estimated VO2max from wearables
   - CRF category (ACSM classification)
   - Fitness age estimation
   - Multiple estimation methods supported
   - Cardiovascular risk classification
   - Based on openEHR archetype `vo2max_estimation.v0`

#### New Questionnaires (4 questionnaires)
1. **Sleep Quality (PSQI-Based)** (`SleepQuestionnaires.fsh`)
   - Pittsburgh Sleep Quality Index adaptation
   - 7 component scores
   - Sleep latency, duration, efficiency
   - Daytime dysfunction assessment

2. **Stress Assessment (PSS-10)** (`StressQuestionnaires.fsh`)
   - Perceived Stress Scale
   - 10 validated items
   - Reverse-scored items indicated
   - Score interpretation guide

3. **Physical Activity (IPAQ-Short)** (`PhysicalActivityQuestionnaires.fsh`)
   - International Physical Activity Questionnaire
   - Vigorous, moderate, walking assessment
   - Sitting time tracking
   - MET-minutes calculation support

4. **Fatigue Assessment (FSS)** (`FatigueQuestionnaires.fsh`)
   - Fatigue Severity Scale
   - 9-item validated scale
   - Clinical interpretation threshold (≥4)
   - Impact on daily functioning

#### New CodeSystems (18 CodeSystems)
- CyclingMetricsCS, CyclingTrainingZoneCS, CyclingActivityTypeCS
- RunningMetricsCS, FootstrikeTypeCS, InjuryRiskLevelCS
- SwimmingMetricsCS, SwimmingStrokeTypeCS, SwimmingEnvironmentCS
- StrengthTrainingCS, ExerciseCategoryCS, MuscleGroupCS
- StrengthEquipmentCS, SetTypeCS, StrengthTrainingTypeCS
- CGMMetricsCS, RecoveryMetricsCS, VO2maxMetricsCS

#### New ValueSets (17 ValueSets)
- CyclingTrainingZoneVS, CyclingActivityTypeVS
- FootstrikeTypeVS, InjuryRiskLevelVS
- SwimmingStrokeTypeVS, SwimmingEnvironmentVS
- ExerciseCategoryVS, MuscleGroupVS, StrengthEquipmentVS
- SetTypeVS, StrengthTrainingTypeVS
- CGMTrendArrowVS, CGMSystemVS, CGMInsertionSiteVS
- ReadinessCategoryVS, TrainingStatusVS, CRFCategoryVS

#### New ConceptMap
- **ConceptMapHRVToOMOP** (`ConceptMapHRVToOMOP.fsh`)
  - LOINC 80404-7 → OMOP concept_id 37547368 (VERIFIED)
  - Documents RMSSD, pNN50, LF/HF gaps (concept_id = 0)
  - ETL implementation guidance
  - Unit concept_id references

### Changed
- Updated IG statistics:
  - Profiles: 54 → 56 (+2)
  - CodeSystems: 82 → 100 (+18)
  - ValueSets: 94 → 111 (+17)
  - Instances: 111 → 116 (+5)
  - Total resources: 384 → 426 (+42)

### Alignment with Thesis
- RS4 finding integrated: ZERO HRV-OMOP transformations documented in 354 papers
- Verified OMOP concept_id 37547368 for SDNN via Athena
- Addressed 29-profile gap between openEHR archetypes (57) and FHIR profiles

### Technical Notes
- All new resources validated with SUSHI: 0 Errors, 0 Warnings
- Compatible with FHIR R4 (4.0.1)
- Compatible with IPS (2.0.0)
- UCUM units properly referenced throughout

### References
- Buysse DJ et al. The Pittsburgh Sleep Quality Index. Psychiatry Research 1989
- Cohen S et al. A global measure of perceived stress. J Health Soc Behav 1983
- Craig CL et al. International Physical Activity Questionnaire. Med Sci Sports Exerc 2003
- Krupp LB et al. The Fatigue Severity Scale. Arch Neurol 1989
- Battelino T et al. Clinical Targets for CGM Data Interpretation. Diabetes Care 2019
