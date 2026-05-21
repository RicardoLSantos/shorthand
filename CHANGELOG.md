# Changelog - iOS Lifestyle Medicine FHIR Implementation Guide

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
