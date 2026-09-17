# Changelog - iOS Lifestyle Medicine FHIR Implementation Guide

## [0.5.1] - 2026-09-17

### Changed
- **Terminology ledger reads every binding form** — split-form bindings (`system` and `code` on separate rules of the same element) and the Quantity shorthand (`value 'unit'`) are now extracted, so the 47 UCUM codes that the IG's examples and profiles carry beyond the 9 bound in ValueSets were verified for the first time (Athena snapshot, NLM UCUM validator, tx.fhir.org UCUM 2.2): 45 active, 2 not UCUM units (below). A Quantity's `unit` text is recorded with the code but not treated as a display claim. Ledger 431 → 477 rows; findings 30 (unchanged after the two corrections).
- **Two bindings decided** (marked for review since 0.5.0): the `ReproductiveObservation` profile's *frequency* (LOINC 92656-8, a quantitative concept) and *pattern* (LOINC 64699-2, a PhenX questionnaire item) components are replaced by one *regularity* component coded SNOMED CT 364307006 "Regularity of menstrual cycle" with a required binding to the new `MenstrualCycleRegularityVS` (302757007 "Regular periods", 80182007 "Irregular periods"; all three verified in the Vocab2 snapshot and on tx.fhir.org, SNOMED CT International 20250201); the social-history example loses its former frequency component ("Number of menstrual periods per year" = Daily) and carries no reproductive component. In `ConceptMapVendorToLOINC` the HealthKit walking + running distance, mapped until 0.5.0 to a step count (41950-7), now maps to LOINC 55430-3 "Walking distance unspecified time Pedometer" (equivalence *narrower*, coherent with the step-count row 55423-8). `SymptomFrequencyVS` and `SymptomProgressionVS` are kept (the first is still used by the reproductive questionnaire). Ledger after all of today's changes: 483 codes (LOINC 209 · SNOMED 172 · ICD-11 46 · UCUM 56), findings 30, no line marked for review.
- **Optional frequency component kept as a quantity** — `ReproductiveObservation` also keeps an optional (not must-support) *frequency* component coded LOINC 92656-8 "Number of menstrual periods per year" with a Quantity value in periods per year (UCUM `/a`), the value type its quantitative LOINC concept calls for; the former coded value set is no longer bound there.
- **Heart-rate-variability value set revised** — 8867-4 "Heart rate" left `HeartRateVariabilityVS` (a heart rate is not an HRV metric; it stays in `ValueSetLOINCObservations` and the vital-signs profiles) and five R-R interval codes joined it: 18505-8, 76638-6, 76639-4 (mean / maximum / minimum R-R interval by EKG), 76643-6 (SDNN by EKG) and 76644-4 (coefficient of variation by EKG), each verified in the Athena LOINC snapshot and on tx.fhir.org (LOINC 2.82). The set and the HRV profile's `method` element now state the method caveat: LOINC R-R codes are defined by EKG, wearable inter-beat intervals are PPG-derived (pulse rate variability), so the acquisition method belongs in `Observation.method`; 80404-7 (SDNN, no method) remains the primary code for wearable SDNN. `ConceptMapHRVToOMOP` gains the five optional LOINC → OMOP mappings (concept_id 3006307, 46235177, 46235178, 46235182, 46235183, from the Athena snapshot); `ConceptMapHRVToLOINC` is unchanged.
- **VO2max profile: LOINC code per body weight** — the fixed `loinc` slice of `VO2MaxEstimationObservation` moves from 60842-2 "Oxygen consumption (VO2)" (an absolute rate) to **94122-9** "Oxygen consumption (VO2)/Body weight [Volume Rate Content] --peak during exercise", whose unit (mL/kg/min) is the one the profile's value and example carry (verified in the Athena LOINC snapshot and on tx.fhir.org, LOINC 2.82); the `snomed` slice 251898000 "Maximum oxygen uptake" is unchanged. 94122-9 is defined as *peak during exercise* while this profile carries a submaximal-algorithm estimate — the estimation method is declared in the `methodType` component and, when a coded procedure exists, in `Observation.method`; no LOINC concept yet describes an estimated maximal uptake per body weight by wearable algorithm. The bulk-export group's VO2 characteristic follows the profile.
- **Sleep observation: the HRV component code identifies the metric** — `SleepObservation.component[heartRateVariability].code` is no longer fixed to 80404-7 (SDNN) whatever the source reported; it is bound (required) to the new `SleepHRVMetricVS`: LOINC 80404-7 for SDNN or the custom `hrv-rmssd` for RMSSD (LOINC has no RMSSD concept). Consumers must read the code — Apple HealthKit reports SDNN; Fitbit, Garmin and Oura report RMSSD. The Fitbit and Oura round-trip sleep examples now carry `hrv-rmssd`; the generic sleep-monitor example keeps SDNN. The openEHR mapping to `sleep_architecture` node at0052 (average RMSSD) is exact for `hrv-rmssd` and by role only for SDNN, for which the archetype has no node (the archetype is unchanged).
- **Release notes of 0.5.0 corrected** — the ICD-11 line now reads 11 codes absent · 16 carrying another concept's title · 7 of 34 correct, as the ICD-11 and terminology-verification pages already stated (the 9 + 12 figure predated the recount); the published release text was corrected on 2026-09-17, the package was not touched.
- **README, home page and Known Issues synchronised with v0.5.0** — 103 profiles / 77 extensions / 19 CodeSystems / 204 ValueSets / 279 instances (682 artefacts); build validation 2026-09-16 (0 errors, 223 warnings of a single OID-advisory class, 13,221 informational, 0 broken links); toolchain IG Publisher 2.2.10 / SUSHI 3.18.1. A CI step (`.github/scripts/ig_counts.sh --check`) now fails `sushi-validate` if the README's artefact table drifts from the FSH sources.
- **Honest status wherever the text implied execution or deployment** — CQL and GDL2 shown as authored/bridged, not executed; the standards gantt replaced by a status table (LOINC not submitted, CKM not submitted, ballot not started); the canonical URL described as an identifier with no hosted site yet; an external terminology router described as a *specification only* (the interfaces, extensions and CodeSystems that carry an agent's outputs; no implementation distributed or required by this IG); the development-time retrieval aid described as a verification method, with the ledger as the evidence.
- **Reuse figures aligned to the published article** (Int J Med Inform 217:106465) — 75% weighted reuse (Model 100% / Extension 67% / Context vendor-specific); the 65.8% of January 2026 kept only as a dated historical note; FHIRconnect's ~65% described as an expected rate and its 21 M patients as the German Core Dataset's population.
- **openEHR bridge page** lists the five mapped archetypes (VO2max estimation added, with its catalog status).
- **Symptoms page** — the severity component is an integer score (LOINC 72514-3); duration uses LOINC 64748-7 "Symptoms duration"; frequency has no generic LOINC code and uses `SymptomFrequencyVS`; two codes previously listed (103333-2, 103334-0) do not exist in LOINC and were removed; the page now states that no dedicated Symptom Observation profile exists in this release.
- **Name history recorded** — the *Heart Rate Variability CodeSystem* (`HeartRateVariabilityCS`, v0.1.0–v0.2.0) described in the published article was consolidated into `LifestyleMedicineTemporaryCS` (2026-02-25, released in v0.2.1); its six codes are unchanged and exposed through `HeartRateVariabilityVS` (terminology catalog, §6).
- Two source links that pointed at a non-existent repository name fixed; Quick Start now works from a clean clone (`cd shorthand`, the CI's publisher command).

### Fixed
- **Two invalid UCUM unit codes that no build had reported** (a base Quantity or Duration carries no required UCUM binding; invariant drt-1 checks only that the system is UCUM): `days` → `d` in the two example Durations of the mindfulness audit configuration; `MET` → `{MET}` (the UCUM annotated form, already used for `{MET-min}/wk`) as the fixed unit of the VO2max profile's MET-capacity component. Both confirmed against the NLM UCUM validator and tx.fhir.org.
- **`MindfulnessProgressReport` Measure — CI build restored.** With IG Publisher 2.3.4 (the version the CI downloads) the four criteria declared as `text/cql-identifier` without a CQL Library raised `MEASURE_M_CRITERIA_CQL_NO_LIB` ×4 and failed the CI build of v0.5.0 and of the following commits (the 0.5.0 release itself was built locally with 2.2.10, which only warned). The expressions are FHIRPath, so `criteria.language` is now `text/fhirpath`; the weekly stratifier expression, which was not valid FHIRPath, is now the observation's effective date with the weekly aggregation stated in the stratifier description. Reproduced and cleared with the standalone FHIR validator 6.10.4 (same core as 2.3.4): 4 errors → 0.

### Added
- `openehr/` — the **12 genuinely original ADL 1.4 archetypes and the 6 composition templates are distributed with the IG** (previously described in the catalog only). The folder's README records provenance (copies of the working corpus with internal working comments removed; no node, constraint, ontology term or terminology binding changed — both versions of each archetype parsed, converted and validated with Archie 3.15.0, 24 parses and 0 errors), and the validation status of the templates: well-formed XML in the openEHR v1 namespace but **not valid Operational Templates** (rejected by the openEHR `Template.xsd`, Release-1.0.2, at their first element), four of the six referencing `physical_activity_detailed.v0`, which is not distributed. The catalog page names the CKM-reuse and specialisation statements that the files do not yet express.
- Suppressions: the *"expression language text/fhirpath is not supported"* line (full text, alongside the existing `text/cql-identifier` line) and the **English twins of the suppressions the CI runner reported** — the runner downloads the latest IG Publisher and emits its messages in English, the local builds in Portuguese, and a suppression matches only its exact text; 67 English lines copied from the 2.3.4 run plus a Portuguese/English pair for the annotated unit `{MET}` (98 → 168 active lines; nothing removed). See Known Issues → Continuous integration.
- `CITATION.cff` — preferred citation = the published article; software entry at v0.5.0 (enables GitHub's "Cite this repository").
- Known Issues page added to the Implementation menu.
- Security audit check 12 — the number of tracked files carrying internal process markers may never rise (ratchet against a recorded baseline, target 0); proven to fail on a planted marker.

### Removed
- Internal process markers from page comments, the CI workflows and scripts, `sushi-config.yaml` comments and `input/ignoreWarnings.txt` comments (that clean-up left the suppressions themselves unchanged; the 0.5.1 additions are listed under *Added*).

## [0.5.0] - 2026-09-16

### Added
- **`HeartRateVariabilityObservation` profile** (`heart-rate-variability-observation`) — one HRV metric per Observation, `code` bound to `HeartRateVariabilityVS` (extensible): SDNN (LOINC 80404-7) or, for the metrics without a LOINC code, RMSSD, pNN50, LF power, HF power and the LF/HF ratio (custom codes bridged by `ConceptMapHRVToLOINC`); Quantity in UCUM (ms, %, ms2, 1); personal baseline via `referenceRange`/`interpretation`; `MeasurementContext` extension. Three examples (RMSSD 42 ms, pNN50 18 %, LF/HF 1.8). `SdnnObservation` is unchanged.
- **Terminology verification ledger** — `input/data/terminology-verification-ledger.csv` records, for every externally-defined code bound in the FSH sources (LOINC, SNOMED CT, ICD-11, UCUM), the date, source and version of its last verification; produced by `.github/scripts/terminology_ledger_check.py` (owner sources → dated local snapshots → tx.fhir.org, advisory; never on the build path) and summarised in a dated table on the Terminology Verification page; advisory weekly step in the ConceptMap Drift workflow. Three concept-property definitions in `AppLogicCS` (`verified-on`, `verified-via`, `source-version`).
- **Questionnaire instrument codes** — PSS-10 (LOINC 106875-8), IPAQ short form (LOINC 77582-5 and the seven item codes 77583-3…77589-0, matched by question text) and PSQI (SNOMED CT 699200007); score Observation examples for the PSS-10 total (106860-0) and the IPAQ total physical activity (77594-0, MET-min/wk).
- **Wearable device profiles** — `WearableDataSource` (the application is the first-class device: type fixed to SNOMED CT 706689003, `parent` → sensor) and `WearableSensorDevice` (type from the Personal Health Device IG's IEEE 11073-10101 MDC device specialisations, extensible); the six software Device examples now conform to `WearableDataSource`; two sensor examples (pulse oximeter 528388, step counter 528484) linked through `parent`.
- **VO2max dual coding** — `VO2MaxEstimationObservation` (`vo2max-estimation-observation`): `code.coding` is sliced (pattern discriminator on `$this`, as in `OxygenSaturationObservation`) so that the `loinc` slice fixes LOINC 60842-2 *Oxygen consumption (VO2)*, the code the profile has always carried, and an optional must-support `snomed` slice carries SNOMED CT 251898000 *Maximum oxygen uptake*; both names verified in two sources (Athena/Vocab2 snapshots and tx.fhir.org, 2026-09-15) and recorded in the ledger; the example carries both codings.
- **openEHR mappings on the profiles whose archetype was developed for this IG** — five `Mapping:` blocks (`input/fsh/mappings/OpenEHRMappings.fsh`, rendered on each profile's *Mappings* tab): `HeartRateVariabilityObservation` → `openEHR-EHR-OBSERVATION.heart_rate_variability.v0`, `VO2MaxEstimationObservation` → `openEHR-EHR-OBSERVATION.vo2max_estimation.v0`, `SleepObservation` → `openEHR-EHR-OBSERVATION.sleep_architecture.v0`, `WearableSensorDevice` and `WearableDataSource` → `openEHR-EHR-CLUSTER.wearable_device.v0`. Every target path is written as a full ADL 1.4 path of the named archetype, including cluster containment (for example `items[at0009]/items[at0010|at0011|at0012]/value`); where the archetype's metric differs from the profile's, the mapping comment says so.
- **EU AI Act examples** — `DeviceDefinitionBioMistral7BExample` (`DeviceDefinitionSLM`), `DocumentReferenceBioMistral7BModelCardExample` (`DocumentReferenceAITechnicalDoc`) and `RiskAssessmentBioMistral7BExample` (`RiskAssessmentAISystem`, `basis` → the two above). Every concrete profile now has at least one example; the abstract `ConsumerECGObservation` has none by design.

### Changed
- **openEHR ConceptMaps use the ADL 1.4 node identifiers** — the four FHIR↔openEHR maps had carried ADL2 identifiers (`idN`) from a 2025-11 authoring pass that the archetype corpus no longer uses; every node code is now the `atNNNN` identifier of the published draft archetype, decided by the archetype term text and checked against the term definitions. Five vendor elements that had no ADL 1.4 counterpart were removed and recorded; the Fitbit coverage element moved to the wearable-device CLUSTER data-quality node.
- **ICD-11 CodeSystem rebuilt** — the 2026-03 edition (34 codes) contained 11 codes absent from ICD-11 MMS and 16 codes carrying another concept's title (7 of 34 were correct); rebuilt from the WHO MMS linearization export and tx.fhir.org (MMS 2026-01) with 46 concepts, WHO titles verbatim and per-concept verification properties; ValueSets regenerated; the ICD-10-CM → ICD-11 ConceptMap follows the WHO ICD-10 to ICD-11 mapping tables (2024-01). tx.fhir.org now serves ICD-11 MMS; the republished CodeSystem is retained by design so that validation never depends on a terminology server.
- **Terminology corrections surfaced by the ledger** — `ConceptMapHRVToOMOP`: the custom HRV codes had been declared as pseudo-LOINC codes (`hrv-*-local`), now in a group whose source is the custom CodeSystem; *Heavy drinker* is SNOMED CT 86933000 (228279004 is *Very heavy drinker*); *Cohabiting* is SNOMED CT 38070000 (14012001 is *Common law partnership*).
- **Ledger verifier: population and display checks** — the code extractor cut every line at its first `//`, which also matched the `://` of `http://loinc.org#…` bindings, so 84 codes (24 LOINC, 60 SNOMED) bound in ValueSets, extensions and the bulk-export Group had never been verified; the comment stripper now honours token boundaries (`//` opens a comment only at the start of a line or after whitespace, as in the FSH lexer). ConceptMap element and target displays are now read and validated too. The ledger holds 431 codes at this release (its first run, on 2026-09-11, listed 350; it reached 436 before the retirements below); `--only-new` re-verifies only the codes that are new or whose display changed; a row whose FSH binding carries no display is marked *existence verified, meaning not checked* (no such row remains).
- **Bindings corrected with the official name confirmed in two sources** (Athena/Vocab2 snapshots and tx.fhir.org) — `ValueSetLOINCObservations`: protein, carbohydrate, fat and fluid intake 24 hour are LOINC 9085-2, 9065-4, 9072-0 and 8990-4 (the codes previously used named other observables; 9059-7 is kept under its own name, *Carbohydrate intake Estimated*); *R-R interval by EKG* is 8637-1 and *Q-T interval* is 8634-8 (8636-3 *Q-T interval corrected* and 8625-6 *P-R interval* are kept under their own names); the step-count displays (55423-8, 41950-7) and *Sleep duration* (93832-4) follow the published names, and five sleep observables were added (103213-5, 93831-6, 93830-8, 103211-9, 90568-7). `ConceptMapNutritionToLOINC` targets and the `BulkExportGroup` activity criterion (55423-8) follow. `ConceptMapSocialToLOINC`: the answer *None* (LA137-2) had been used for *Family member*, *Friend* and *Significant other* → LA9277-0, LA6656-8, LA30381-0. `ConceptMapVendorToLOINC`: the daily-step targets → 41950-7. `SharedQualifierValueSets`: *Worsening* is the qualifier SNOMED CT 230993007 (271299001 is the finding *Patient's condition worsened*). `ValueSetCDSSInterventionRecommendations`: *Self-monitoring* is SNOMED CT 310858007 and *Provision of device* 439894008 (722172003 and 840534001 name a military health institution and a SARS-CoV-2 vaccine administration). `ReproductiveObservation`: the four component codes now carry their official displays (72514-3, 3144-3, 92656-8, 64699-2). Fibre, saturated-fat and caffeine intake 24 hour are LOINC 81133-1, 81033-3 and 80489-8 (the *Estimated* variants, the one this IG already used for caffeine in `SubstanceUseProfile`; the codes previously bound named calorie and carbohydrate intakes) in the value set and in `ConceptMapNutritionToLOINC`.
- **Bindings retired rather than approximated** — where LOINC or SNOMED CT International has no code for the intended concept, the mis-bound code was removed and the concept is declared unmapped: *Eating habits* (65968-0 is *How many hours do you normally sleep*) and *Diet* (75282-4 is the *Nutrition assessment panel*) left `ValueSetLOINCObservations`, and the `meal-frequency` and `diet-quality-score` elements of `ConceptMapNutritionToLOINC` now carry `equivalence` *unmatched*; household members (63503-7 is *Marital status [NHANES]*) left the value set and the `dependent-count` element of `ConceptMapSocialToLOINC` is *unmatched*; *Fair* (bound to 260347006, whose meaning is the grade *+*; a *Fair* qualifier exists only in the US extension, 445511000124105) left `SleepQualityExtendedVS` and `QualityGradeSNOMEDVS`, which now grade Excellent / Good / Poor; the `ConceptMapCGMToOMOP` element that mapped 41653-7 (a capillary glucometer reading) under the name of mean glucose was removed (97507-8 already carries the CGM mean). Still marked inline for review: distance → steps in `ConceptMapVendorToLOINC`, and the `ReproductiveObservation` frequency (92656-8, a quantitative concept bound to a coded value) and pattern (64699-2, a PhenX questionnaire item with status TRIAL) components.
- Terminology pages (ICD-11 Integration, Design Decisions, Known Issues, Terminology Verification, openEHR Integration, Getting Started) updated accordingly; the Terminology Verification page's ledger section re-generated (431 codes; findings dated 2026-09-15 and 2026-09-16).

### Source counts (FSH)
- Profiles 103 / Extensions 77 / CodeSystems 19 / ValueSets 204 / Instances 279 (incl. 29 ConceptMaps) = **682 artefacts** (+3 profiles, +10 instances vs 0.4.8); ICD-11 CodeSystem 34 → 46 concepts; `Mapping:` blocks 7 → 12. Built with IG Publisher 2.2.10 on 2026-09-16: err 0 / warn 223 / info 13221 / 0 broken links; the 223 warnings are the same set as in the 2026-09-11 build (three builds on 2026-09-16: 10:19, 14:04 and 14:52; the last two identical in every count).

### Built against
- LOINC 2.82 (tx.fhir.org; Athena snapshot 2026-01-21) · SNOMED CT International 20250201 (tx.fhir.org; Vocab2 snapshot 2025-02-01) · ICD-11 MMS 2026-01 (tx.fhir.org; WHO linearization export 2026-03-20) · UCUM 2.2 · IEEE 11073-10101 MDC 2024-12-05 (via hl7.fhir.uv.phd 1.1.0) · IG Publisher 2.2.10 · ledger verification dated 2026-09-15/16.

## [0.4.8] - 2026-07-18

### Changed
- **openEHR Archetype Catalog page — binding count 7/12·18 → 8/12·19 (accelerometer)** — the `wearable_device` CLUSTER now carries one external term-binding, `[SNOMED::471451000124109]` "Accelerometer" (Physical Object, `std=S`, active — verified Database-First against Vocab2), applied to the `at0012` node in the working ADL and adopted as an author scoping decision. The catalog's binding column moves from **7 of 12 · 18 bindings** to **8 of 12 · 19** (14 LOINC + 5 SNOMED occurrences / 18 distinct codes; the archetype count stays **12** — this is a binding, not a new concept). The page also records, honestly, that not every unbound sensor flag is a gap: GPS (`SNOMED::897293009`) and temperature (`SNOMED::720387005`) have exact active codes and are unbound by decision, not by absence — the claim is scoped to the two flags actually verified, not over-generalised.

### Source counts (FSH) — unchanged from v0.4.7
- Profiles 100 / Extensions 77 / CodeSystems 19 / ValueSets 204 / Instances 269 (incl. 29 ConceptMaps) = **669 artefacts** — **unchanged**: this release re-renders one narrative page with a corrected binding count; no FSH artefact was added, removed, or re-shaped.
- Built with **IG Publisher 2.2.10**; genonce **err=0 / warn=223 / 0 broken links** (info 12984). The `warn=223` is **identical to v0.4.6/v0.4.7** and remains the same single benign class — the OID-assignment advisory emitted for the 223 terminology resources (204 ValueSets + 19 CodeSystems); none is a FHIR conformance error, and a registered OID root (IANA Private Enterprise Number) is planned for the production phase. A per-resource diff against the v0.4.7 baseline shows **zero new errors and zero new warnings** (#99). `err=0` remains the release gate. Both the rendered catalog HTML and the `package.tgz` (version `0.4.8`) carry the corrected **8 of 12 · 19** count.

## [0.4.7] - 2026-07-17

### Added
- **openEHR Archetype Catalog page** (`openehr-archetypes-catalog.html`, Implementation menu) — a public, checkable inventory of the openEHR ADL 1.4 archetype set developed for this IG. It reports the reconciled contribution as **12 genuinely original artefacts** (11 novel concepts + 1 specialisation of `CLUSTER.device.v1`, `wearable_device`) out of a 48-concept development snapshot, and publishes the evidence so the number can be checked rather than taken on trust: the four-way classification (**12** genuine + **5** CKM extensions + **21** duplicates + **10** classified = **48**), the CKM-mirror cross-check behind it (`openEHR/CKM-mirror` commit `c798e8a`, **689** `.adl` files, **every RM type** — the mirror is of the trunk, **455** `in_development` / **232** `published`, which makes "no CKM equivalent" a *stronger* claim: the concept is absent even as a draft), the per-archetype external term-bindings (**7 of 12** bound, **18** bindings, Archie 3.15.0 → 12/12 `OK | VALID`), and the method caveats. It also states the second level explicitly: a further ~7 concepts exist without a CKM duplicate but are **not claimed** as original. The ADL files themselves remain **not distributed with this IG** (git-ignored) — the page describes the set, it is not a download point.

### Changed
- **Example instances use RFC-2606 addresses** — the LGPD and CFM example instances carried real third-party contact addresses; they now use `dpo@example.org` / `support@example.org`. Synthetic examples must never ship real contact details.
- **Untracked a pre-remediation ConceptMap backup** — `backup/fsh_backups/terminology/ConceptMapNutritionToOMOP_PRE_CN1_REMEDIATION_*.fsh` no longer travels with the repository (the file is kept on disk). It predates the `/backup/` ignore rule; note that untracking does not remove it from the published history.

### Source counts (FSH) — unchanged from v0.4.6
- Profiles 100 / Extensions 77 / CodeSystems 19 / ValueSets 204 / Instances 269 (incl. 29 ConceptMaps) = **669 artefacts** — **unchanged**: this release adds one narrative page and edits two example contact strings; no FSH artefact was added, removed, or re-shaped. ValueSets remain **204** published (205 raw in FSH → SUSHI dedup; Pitfall #81).
- Built with **IG Publisher 2.2.10**; genonce **err=0 / warn=223 / 0 broken links** (3,222,366 links checked; 8,318 HTML files, 0 invalid xhtml). The `warn=223` is **identical to v0.4.6** and remains the same single benign class — the OID-assignment recommendation emitted by IG Publisher ≥2.2.10 for the 223 terminology resources (204 ValueSets + 19 CodeSystems) for interoperability with OID-based ecosystems (e.g. CDA). None is a FHIR conformance error; a registered OID root (IANA Private Enterprise Number) is planned for the production phase as the genuine remediation — OIDs are never invented without a registered root. A per-resource diff against the v0.4.6 baseline shows **zero new errors and zero new warnings** (info 12979 → 12984, the new page). `err=0` remains the release gate (Opção C — CI `ig-build.yml` Gate A fails on `errors > 0`).

## [0.4.6] - 2026-07-13

### Added
- **Inflammatory Marker Bindings — mitochondria↔inflammation panel (T1 wire 10 Jul + T2 build-trial 11 Jul, released 13 Jul)** — four bridge-cytokine / metabolite Observation profiles binding the Castro-Marrero 2022 (PMID 35229657) mitochondria↔inflammation panel: **IL-1β** (LOINC `13629-1`), **IL-8** (`33211-4`), **IL-10** (`26848-2`), and **lactate** (`14118-4`). IL-1β / IL-8 / IL-10 join the existing **`InflammatoryMarker` ValueSet** (they are new *members* of that VS — **not** a new ValueSet, so the ValueSet count stays **204**, per the raw-FSH-205-vs-published-204 SUSHI-dedup distinction, Pitfall #81); **lactate is deliberately kept OUTSIDE the inflammatory ValueSet** (metabolic, not inflammatory). All four codes verified Database-First (Athena, `std=S`) + live-validated against `tx.fhir.org` `$lookup`. Each profile ships one example instance. Supports the HRV↔inflammation evidence base cited by G1 (RS5/RS6/RS12 merge).

### Source counts (FSH)
- Profiles **100** (+4) / Extensions 77 / CodeSystems 19 / ValueSets **204** / Instances **269** (+4 examples; incl. 29 ConceptMaps) = **669 artefacts** (+8 vs v0.4.5: +4 profiles +4 examples; Extensions / CodeSystems / **ValueSets unchanged** — the 3 cytokine codes join the existing `InflammatoryMarker` VS, they do not create a new one). Built with **IG Publisher 2.2.10** + EN locale; genonce **err=0 / warn=223 / 0 broken links**. The 223 warnings are a **single benign class** — the OID-assignment recommendation newly emitted by IG Publisher ≥2.2.10 for the 223 terminology resources (204 ValueSets + 19 CodeSystems) for interoperability with OID-based ecosystems (e.g. CDA). None is a FHIR conformance error; the build validates with **zero errors**, all terminology is live-validated against `tx.fhir.org`, and a registered OID root (IANA Private Enterprise Number) is planned for the production phase (post-defense) as the genuine remediation — OIDs are never invented without a registered root. This is **not** a regression from v0.4.5's `warn=0` and **not** a suppression-file drift (`ignoreWarnings.txt` unchanged): it is the IG Publisher 2.2.7 → 2.2.10 upgrade surfacing an advisory class. `err=0` remains the release gate (Opção C — the CI `ig-build.yml` Gate A fails on `errors > 0`, treating the OID `warn=223` as benign). Released public + immutable (GitHub Release + `package.tgz` asset; tag `v0.4.6` → commit `055fa32f9`); CI IG-Build green.

## [0.4.5] - 2026-06-20

### Changed
- **IPS dependency upgrade `hl7.fhir.uv.ips` 2.0.0 → 2.0.1 (T1 S61)** — HL7 published the formal IPS 2.0.1 release (GitHub tag `2.0.1`, non-prerelease, 18 Jun 2026; FHIR-registry `dist-tags.latest = 2.0.1`) after the v0.4.3/v0.4.4 builds, which surfaced as the single `warn=1` dependency-staleness advisory in v0.4.4. Bumping the pin to 2.0.1 resolves it. The transitive `hl7.fhir.uv.extensions.r4` is **unchanged at 5.3.0** (the stable formal release our prior builds already resolved — so the historical Pitfall #31 extensions-version risk did not apply); IPS 2.0.1 additionally pins `hl7.terminology.r4 7.2.0` + `hl7.fhir.uv.ipa 1.1.0`. genonce verified the upgrade with **zero regressions** to the derived `IPSLifestyleMedicineComposition`: a Pitfall #99 diff against the v0.4.4 baseline shows an identical per-resource err/warn distribution, minus the one cleared staleness advisory (no resource gained an error or warning).

### Source counts (FSH)
- Profiles 96 / Extensions 77 / CodeSystems 19 / ValueSets 204 / Instances 265 = **661 artefacts** (unchanged vs v0.4.4 — dependency-bump only, no FSH/pagecontent change). Built with IG Publisher 2.2.7 + EN locale + A3 JVM flags; genonce **err=0 / warn=0 / 0 broken links** (3,087,608 links checked). **Restores `warn=0`**: the v0.4.4 staleness advisory is cleared, making this the fifth consecutive zero-error release (v0.4.1→v0.4.5). The first build to reach `warn=0` was **v0.4.1** (warnings 137 → 0, T1 Fase 3 + T2 S35); v0.4.4's single staleness advisory was the only interruption between v0.4.1 and here.

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
