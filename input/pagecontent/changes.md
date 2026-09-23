# Change Log

All notable changes to this Implementation Guide are documented on this page.

## Unreleased

### Changed
- **Walking speed has standard counterparts.** `ConceptMapMobilityToSNOMED` maps `walking-speed` to SNOMED CT 724237005 "Gait speed" (equivalent; the element had been declared unmatched since 2025-12-08 with the note that no verified SNOMED code existed), and `ConceptMapVendorToLOINC` relates the HealthKit walking-speed sample to LOINC 41957-2 "Walking speed 24 hour mean Calculated" (*relatedto*: a sample is the mean of one walking bout, the LOINC concept a 24-hour mean; 41956-4/41958-0/41959-8 are the other aggregates and 83144-6 the 4-metre test — the former "no LOINC code" note was false). `MobilityProfile` still binds the IG code. Both codes verified in two sources on 2026-09-22; ledger 499 → 502 rows.
- **Home page: the custom-code figure is now a declared count.** "1,211" was the total of all 19 locally defined CodeSystems at 0.5.0, including the republished ICD-11 fragment; the page now states 1,166 (the fragment's 46 WHO codes excluded) with its composition and the counting rule.
- **`MindfulnessDiagnosticMap`: every target re-chosen and the relations revised.** Three targets were the wrong concepts — 248234008 is *Mentally alert*, 285854004 *Emotion (observable entity)*, 736253002 *Mental health crisis plan* — and the fourth, 73595000 "Stress", was mapped as narrower although it subsumes the source. The targets are now SNOMED CT 79365001 "Decreased stress" (*equivalent*: the source is defined as decreased levels of stress and tension), 314939008 "Good sleep pattern" and 285850008 "Able to control emotions" (*relatedto*: the sources are improvements, the targets states, and neither subsumes the other), and 365929007 "Consciousness and/or awareness finding" (*wider*: no finding for increased awareness exists under it). `mindfulness-snomed-vs`, the map's target value set, had no content and now lists the four targets. The definition of the source code `improvedSleep` read "Enhanced activity quality" and now reads "Enhanced sleep quality". Codes and displays verified on 2026-09-23 in the Vocab2 snapshot (SNOMED CT International Edition 2025-02-01) and with `$validate-code` on tx.fhir.org (International 20250201); ledger 502 → 506 rows.
- **CQL library pointers state only what the IG holds.** The two `Library` resources (`urn:cql:library:CVR-003:v1.2`, `urn:cql:library:MET-002:v1.0`) and the pages that described their CQL (LLM/AI integration, GDL integration, implementation scope and roadmap, SMART + CDS walkthrough, known issues) named an external repository or path for it, or called it executable; they now say that the resources are documentation pointers and that no CQL is embedded in, executed by or distributed with this IG. The implementation-scope page also said that the unresolved `urn:cql:library:` references gave accepted build warnings and that registering `Library` resources was still to be decided; the resources have been registered since 2026-05-28 and the build reports no such warning. The CDS clinical-validation page said the risk-assessment `PlanDefinition` references CQL libraries; it references none and carries no condition expression. The README's CQL status note places the CQL work in the companion project it belongs to.
- **Companion-project status aligned on the GDL and OMOP pages.** They described the HEADS-ETL pipeline as a conformant deployment and as the home of everything operational; they now give its status as a proof of concept on synthetic bundles and point to the three companion projects listed in the README.
- **openEHR integration page, physical-activity row.** It said "**Reuse** — aligns to a published CKM physical-activity OBSERVATION archetype (a wearable-detailed projection, not a new gap)"; it now says that `physical_activity_detailed.v0` is not distributed, that how it relates to the published CKM `physical_activity` archetype has not been checked, and names the four ConceptMaps that point to it.
- **README: "Related Projects" replaced by "Companion projects"** — the three parallel tracks (wearable ETL pipeline; HRV–inflammation risk rules in CQL and GDL2; terminology router), each with its hook into this IG and its status, measured on 2026-09-23.

### Added
- The English twin of the *"expression language text/fhirpath is not supported"* suppression — the v0.5.1 CI run (IG Publisher 2.3.4) showed it 4 times on the `MindfulnessProgressReport` Measure, because the 2.3.4 run of v0.5.0 had reported that criteria language as an error (`MEASURE_M_CRITERIA_CQL_NO_LIB`), not as this warning, so no English line had been copied for it; the Known Issues page records the measured runs (0 errors, 229 warnings = 225 OID advisories + these 4; after the twin, 0 errors and 225 warnings).
- **`ReproductiveHealthGoal` profile** (`reproductive-health-goal`, on `Goal`) with two value sets and a standalone example: `ReproductiveGoalDescriptionVS` (what the goal aims at — SNOMED CT 169449001 "Trying to conceive", 710973002 "Prevention of unwanted pregnancy", 429070000 "Preconception care", 302757007 "Regular periods", 43664005 "Normal weight"; extensible on `Goal.description`) and `ReproductiveGoalMeasureVS` (what is measured — SNOMED CT 364307006 "Regularity of menstrual cycle", 161716008 "Usual length of menstrual cycle", LOINC 92656-8 "Number of menstrual periods per year", 39156-5 "Body mass index (BMI) [Ratio]", 29463-7 "Body weight"; extensible on `Goal.target.measure`); `target.detail[x]` is a coded state, a Quantity or a Range. Every code verified on 2026-09-22 in the Vocab2/Athena snapshots and on tx.fhir.org (SNOMED CT International 20250201, LOINC 2.82). Counts on `main`: 104 profiles / 77 extensions / 19 CodeSystems / 207 ValueSets / 281 instances (193 examples) = 688 artefacts.
- **openEHR: four limitations of the distributed archetypes declared** in `openehr/README.md` (step counts have no home in the twelve; the data-export-method value sets have no "manual export (XML)" value; the device slots of the HRV, sleep and VO2max archetypes are not designed alike; the sleep archetype's "Nightly sleep" interval event leaves its data tree unconstrained), each with the ADL change that would resolve it — found by a trial mapping of an Apple Health export; no archetype was changed.
- **openEHR: the ConceptMaps' use of a non-distributed archetype declared** in `openehr/README.md` — four ConceptMaps (19 mapped elements: step count, distance, active calories, activity minutes) use `physical_activity_detailed.v0` as a group system; the three publisher warning messages this causes are suppressed by six lines of `input/ignoreWarnings.txt`; the mappings are unchanged. The README also names a disagreement between two of its own notes: one describes the archetype as a duplicate of the published CKM `physical_activity` archetype, the other says that archetype models activity level and category only.

### Fixed
- **Narrative pages: the codes and the figure carried over from 0.5.1 are corrected.** Every code quoted in the affected pages is now the code the FSH binds for that concept, each re-verified in two sources on 2026-09-21 (the Athena/Vocab2 snapshots and tx.fhir.org — LOINC 2.82, SNOMED CT International 20250201; ICD-11 against the WHO MMS linearization and tx.fhir.org 2026-01): body-metrics table (LOINC 41982-0 · 8342-8 · 101683-1 · 73965-6 · 101685-6; the vital-signs query example uses 39156-5), reproductive table (92656-8 · SNOMED CT 364307006 · 3144-3 · 8310-5 with 8328-7 · 10570-0; 8665-2 is listed in `ReproductiveGoalVS`, which no profile binds, and the row says so), environmental and gait tables (the `LifestyleMedicineTemporaryCS` codes the profiles bind; LOINC has no observable for four of the five gait metrics — for walking speed it has 41956-4 to 41959-8 and 83144-6, which the profile does not bind — and none for the environmental metrics as a consumer device measures them; the former `LA…` identifiers belonged to the LOINC answer namespace, two answer codes and three non-existent), OMOP worked example (`concept_id` 3036277 · 3025315 · 3038553), ICD-11 page (`QE86.0` and `XY01`, both absent from the WHO linearization, replaced by the real course qualifier `XT8W` "Chronic" in the postcoordination example). Five codes beyond the 18 listed in 0.5.1 were wrong in the same tables and are corrected too (291-7 and 73708-0 in body metrics; 8664-5 and 49033-4 in reproductive; `XY01` in ICD-11). The "86 % terminology gap" figure (five occurrences on four pages) is replaced by the published figure — 97.4 % of 1,173 custom codes without a direct standard equivalent (Int J Med Inform 217:106465, doi:10.1016/j.ijmedinf.2026.106465). The binding-strength distribution on the conformance and must-support pages, unchanged since it entered the source in March 2026 (30/66/5; first released in 0.2.1), is re-measured on the v0.5.1 sources: 56 required / 107 extensible / 5 preferred over 168 binding statements. No resource and no ledger row changes.
- **The terminology ledger now reads indented FSH rules.** An indented rule takes the path of the rule above it as its context (`* group[0].element[0]` / `  * target[0]` / `    * code = #X`); the extractor read one line at a time and missed every code assigned on a line with no path of its own. The four SNOMED CT targets of `MindfulnessDiagnosticMap` had therefore never entered the ledger (three of them were wrong concepts, corrected above), and the UCUM `min` of the mindfulness session duration was not attributed to its file. Paths carrying the soft index `[=]` were also refused by the split-form and Quantity-shorthand patterns (one UCUM `%` in the sleep examples), and ConceptMap groups opened with `[+]` are now numbered from 0, as SUSHI numbers them. `.github/scripts/tests/test_terminology_ledger_check.py` has 14 tests: 7 fail against the previous version of the script, and the other 7 are controls and regression guards (caret rules and Measure groups under an indented context, flat forms) that pass on both. On this IG's sources, and on the sources of v0.4.8, v0.5.0 and v0.5.1, the extraction gains exactly six code–file pairs (the map's four targets, `min` and `%`) and loses none.

### Removed
- `ReproductiveGoalVS` (`social-history-goal-vs`): a value set of five LOINC observables and two SNOMED CT findings, bound by no profile since it was written, is replaced by the two goal value sets above. Four of its codes are no longer bound anywhere and leave the terminology ledger (LOINC 8665-2, 49033-4; SNOMED CT 118185001, 248957007); the others remain bound elsewhere. `ReproductiveActivityVS` (`social-history-activity-vs`, eight local codes) is likewise bound by no profile and is left as it is pending a decision.

### Changes relevant to the companion projects
- Hooks re-measured on 2026-09-23: every id the README's *Companion projects* section names (`sdnn-observation`, `crp-observation`, `hrv-inflammation-correlation`, `ConceptMapVendorToLOINC`, LOINC 80404-7 and 30522-7, `heart_rate_variability.v0`, the 14 cases in `RS11_benchmark/`) is present and unchanged. No profile, CodeSystem or ConceptMap was renamed or retired in this release.
- Changed targets: `ConceptMapVendorToLOINC` (HealthKit walking speed → LOINC 41957-2, *relatedto*), `ConceptMapMobilityToSNOMED` (walking speed → SNOMED CT 724237005) and `MindfulnessDiagnosticMap` (its four SNOMED CT targets). The value set `social-history-goal-vs` was retired.

### Pending (decisions not yet taken; listed so that the backlog is public)
- **Dates on the resources changed in 0.5.1.** Their manual `date` is 2026-09-17, the day the content changed (the FHIR meaning of the element); the release was published on 2026-09-21. Whether the `date` should instead carry the release day (10 edits, 6 additions, one build) is undecided.
- **Profile id `social-history-observation`** belongs to `ReproductiveObservation` (the file was renamed, the id was not). Renaming the id changes the canonical URL and every reference to it — a breaking change that needs a deprecation path; undecided.
- **The six composition templates** stay withheld (6/6 rejected by the openEHR Template XML schema at their first element); whether they are repaired as operational templates or replaced is undecided.
- **`ReproductiveActivityVS`** (`social-history-activity-vs`, eight local codes) is bound by no profile — keep, bind or retire, undecided.
- **A trial build with IG Publisher 2.3.4** (the version the CI runs) on the maintainers' machine is planned before adopting it for release builds; it needs the disk the release builds need (≥ 15 GB free).
- **Home page comparison table:** the "~30 custom codes" attributed to the Physical Activity IG has no stated source and will be measured or removed.
- **The four openEHR limitations above** wait for their authors' decisions on the proposed ADL changes.
- **The two CQL `Library` resources** (CVR-003, MET-002) are documentation pointers; whether they stay pointers, are backed by a published CQL library, or are retired is undecided.
- **The physical-activity archetype.** Whether `physical_activity_detailed.v0` is distributed, or the four ConceptMaps' physical-activity groups are re-targeted to a published CKM archetype, is undecided; how the two archetypes relate has not been checked.

## Version 0.5.1 (2026-09-21)

### Changed
- **Terminology ledger reads every binding form** — split-form bindings (`system` and `code` on separate rules of the same element) and the Quantity shorthand (`value 'unit'`) are now extracted, so the 47 UCUM codes that the IG's examples and profiles carry beyond the 9 bound in ValueSets were verified for the first time (Athena snapshot, NLM UCUM validator, tx.fhir.org UCUM 2.2): 45 active, 2 not UCUM units (below). A Quantity's `unit` text is recorded with the code but not treated as a display claim. Ledger 431 → 477 rows; findings 30 (unchanged after the two corrections).
- **Two bindings decided** (marked for review since 0.5.0): the `ReproductiveObservation` profile's *frequency* (LOINC 92656-8, a quantitative concept) and *pattern* (LOINC 64699-2, a PhenX questionnaire item) components are replaced by one *regularity* component coded SNOMED CT 364307006 "Regularity of menstrual cycle" with a required binding to the new `MenstrualCycleRegularityVS` (302757007 "Regular periods", 80182007 "Irregular periods"; all three verified in the Vocab2 snapshot and on tx.fhir.org, SNOMED CT International 20250201); the social-history example loses its former frequency component ("Number of menstrual periods per year" = Daily) and carries no reproductive component. In `ConceptMapVendorToLOINC` the HealthKit walking + running distance, mapped until 0.5.0 to a step count (41950-7), now maps to LOINC 55430-3 "Walking distance unspecified time Pedometer" (equivalence *narrower*, coherent with the step-count row 55423-8). `SymptomFrequencyVS` and `SymptomProgressionVS` are kept (the first is still used by the reproductive questionnaire). Ledger after all of today's changes: 499 codes (LOINC 225 · SNOMED 172 · ICD-11 46 · UCUM 56), findings 30, no line marked for review.
- **Optional frequency component kept as a quantity** — `ReproductiveObservation` also keeps an optional (not must-support) *frequency* component coded LOINC 92656-8 "Number of menstrual periods per year" with a Quantity value in periods per year (UCUM `/a`), the value type its quantitative LOINC concept calls for; the former coded value set is no longer bound there.
- **Heart-rate-variability value set revised** — 8867-4 "Heart rate" left `HeartRateVariabilityVS` (a heart rate is not an HRV metric; it stays in `ValueSetLOINCObservations` and the vital-signs profiles) and five R-R interval codes joined it: 18505-8, 76638-6, 76639-4 (mean / maximum / minimum R-R interval by EKG), 76643-6 (SDNN by EKG) and 76644-4 (coefficient of variation by EKG), each verified in the Athena LOINC snapshot and on tx.fhir.org (LOINC 2.82). The set and the HRV profile's `method` element now state the method caveat: LOINC R-R codes are defined by EKG, wearable inter-beat intervals are PPG-derived (pulse rate variability), so the acquisition method belongs in `Observation.method`; 80404-7 (SDNN, no method) remains the primary code for wearable SDNN. `ConceptMapHRVToOMOP` gains the five optional LOINC → OMOP mappings (concept_id 3006307, 46235177, 46235178, 46235182, 46235183, from the Athena snapshot); `ConceptMapHRVToLOINC` is unchanged.
- **VO2max profile: LOINC code per body weight** — the fixed `loinc` slice of `VO2MaxEstimationObservation` moves from 60842-2 "Oxygen consumption (VO2)" (an absolute rate) to **94122-9** "Oxygen consumption (VO2)/Body weight [Volume Rate Content] --peak during exercise", whose unit (mL/kg/min) is the one the profile's value and example carry (verified in the Athena LOINC snapshot and on tx.fhir.org, LOINC 2.82); the `snomed` slice 251898000 "Maximum oxygen uptake" is unchanged. 94122-9 is defined as *peak during exercise* while this profile carries a submaximal-algorithm estimate — the estimation method is declared in the `methodType` component and, when a coded procedure exists, in `Observation.method`; no LOINC concept yet describes an estimated maximal uptake per body weight by wearable algorithm. The bulk-export cohort-criteria value set (`LifestyleMetricCohortCriteriaVS`) follows the profile.
- **Sleep observation: the HRV component code identifies the metric** — `SleepObservation.component[heartRateVariability].code` is no longer fixed to 80404-7 (SDNN) whatever the source reported; it is bound (required) to the new `SleepHRVMetricVS`: LOINC 80404-7 for SDNN or the custom `hrv-rmssd` for RMSSD (LOINC has no RMSSD concept). Consumers must read the code — as reported in the published article (Int J Med Inform 217:106465, doi:10.1016/j.ijmedinf.2026.106465): Apple HealthKit exposes SDNN; Fitbit, Garmin and Oura expose RMSSD. The Fitbit and Oura round-trip sleep examples now carry `hrv-rmssd`; the generic sleep-monitor example keeps SDNN. The openEHR mapping to `sleep_architecture` node at0052 (average RMSSD) is exact for `hrv-rmssd` and by role only for SDNN, for which the archetype has no node (the archetype is unchanged).
- **Every concrete profile has a standalone example** — the v0.5.0 build listed two profiles without one: `ConsumerECGObservation`, which is abstract, and `CarePlanLifestyleMedicine`, which had only inline instances inside the AI workflow bundles; a standalone care-plan example is added; the 0.5.1 build lists 102 of 102 concrete profiles with at least one example (103 per-profile example pages, one "No examples" page: the abstract base profile).
- **Artefact counts at 0.5.1**: 103 profiles / 77 extensions / 19 CodeSystems / **206** ValueSets (two added today: `MenstrualCycleRegularityVS`, `SleepHRVMetricVS`) / **280** instances (one added today: a standalone example for the care-plan profile) = **685** artefacts, counted from the FSH sources by `ig_counts.sh` (the 682 quoted above is the 0.5.0 figure the README carried until this release).
- **"Fair" quality grade restored as a local code** — the grade removed on 2026-09-16 (SNOMED CT 260347006 |+| was a wrong concept) returns to `QualityGradeSNOMEDVS` and `SleepQualityExtendedVS` as `LifestyleMedicineTemporaryCS#quality-fair` "Fair": SNOMED CT International has Excellent, Good and Poor but no intermediate grade (the US Extension's 445511000124105 |Fair| does not resolve on the International edition), so the local code carries it with that migration note; no example or map used the removed code.
- **Estimated/Measured pairs for intake concepts** — next to each of the sixteen *Estimated* LOINC intake codes of `ValueSetLOINCObservations` (carbohydrate, fibre, saturated fat, caffeine, vitamins A, B9, B12, C, D, E, calcium, iron, magnesium, potassium, sodium, zinc) the LOINC *Measured* variant of the same concept is now offered (9060-5, 81057-2, 81136-4, 80490-6, 81073-9, 81134-9, 81063-0, 81075-4, 81930-0, 81077-0, 80975-6, 81083-8, 81006-9, 81009-3, 81012-7, 81088-7 — all sixteen exist in LOINC 2.82; names from the Athena snapshot, confirmed on tx.fhir.org). The code identifies the method; the Estimated codes stay fixed in the profiles and carried by the examples, and the ConceptMaps keep their Estimated targets (their source concepts do not state the method). The CGM "days worn … Estimated" code (104636-6) is not an intake concept and was not touched.
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
- `openehr/` — the **12 genuinely original ADL 1.4 archetypes are distributed with the IG** (previously described in the catalog only). The folder's README records provenance (copies of the working corpus with internal working comments removed; no node, constraint, ontology term or terminology binding changed — both versions of each archetype parsed, converted and validated with Archie 3.15.0, 24 parses and 0 errors). The 6 composition templates are **withheld**: well-formed XML in the openEHR v1 namespace but **not valid Operational Templates** (rejected by the openEHR Template XML schema (`Template.xsd`, schema version 1.0.1 by Ocean Informatics, taken from the openEHR specifications-ITS-XML repository at tag Release-1.0.2v2, commit f7a9377, `components/ALL/`) at their first element), four of the six referencing `physical_activity_detailed.v0`, which is not distributed either. The catalog page names the CKM-reuse and specialisation statements that the files do not yet express.
- Suppressions: the *"expression language text/fhirpath is not supported"* line (full text, alongside the existing `text/cql-identifier` line) and the **English twins of the suppressions the CI runner reported** — the runner downloads the latest IG Publisher and emits its messages in English, the local builds in Portuguese, and a suppression matches only its exact text; 68 English lines copied from the 2.3.4 run plus a Portuguese/English pair for the annotated unit `{MET}` (98 → 169 non-comment lines; nothing removed). See Known Issues → Continuous integration.
- `CITATION.cff` — preferred citation = the published article; software entry at v0.5.0 (enables GitHub's "Cite this repository").
- Known Issues page added to the Implementation menu.
- Security audit check 12 — the number of tracked files carrying internal process markers may never rise (ratchet against a recorded baseline, target 0); proven to fail on a planted marker.

### Removed
- Internal process markers from page comments, the CI workflows and scripts, `sushi-config.yaml` comments and `input/ignoreWarnings.txt` comments (that clean-up left the suppressions themselves unchanged; the 0.5.1 additions are listed under *Added*).

### Known issues (carried to 0.5.2)
- **Narrative pages: codes quoted only in page text.** A review of the narrative pages on 2026-09-17 — codes that appear in page text but are bound in no FSH resource, so outside the terminology ledger — found at least 18 that do not denote the concept the page attributes to them (verified against the Athena LOINC snapshot, the Vocab2 SNOMED snapshot and the WHO MMS linearization): LOINC 73711-4, 73713-0 and 88365-2 in the body-metrics page (two allergen mixes and a pre-meal glucose, quoted as bone mass, muscle mass and a vital-signs query); 8669-4 in the reproductive page (a history of eye disorders, quoted as cervical mucus); 89020-2, 89022-8, 89023-6, 89024-4 and 89025-1 in the environmental page (hearing thresholds, quoted as sound, UV and noise measures); the five `LA…` answer-list codes of the gait table in the mobility page (three of which do not exist); the three OMOP `concept_id`s of the worked example in the OMOP-integration page (they denote cerebral cysts, a patient address and urea nitrogen, not height, weight and BMI — the correct identifiers are 3036277, 3025315 and 3038553); and the ICD-11 code `QE86.0` in the ICD-11 page (absent from the WHO MMS linearization). The same review found an "86 % terminology gap" figure, repeated five times on four pages, that the published article does not report (its terminology-gap figure is 97.4 % of 1,173 custom codes without a direct standard equivalent). These pages are corrected in 0.5.2; no resource of this release and no ledger row is affected.

### Source counts (FSH)
- Profiles 103 / Extensions 77 / CodeSystems 19 / ValueSets 206 / Instances 280 (incl. 29 ConceptMaps) = **685 artefacts** (+2 ValueSets, +1 instance vs 0.5.0); ledger 431 → 499 verified codes. Built with IG Publisher 2.2.10 on 2026-09-21: err 0 / warn 225 / info 13,232 / 0 broken links; the 225 warnings are the OID advisories of 0.5.0 plus one for each of the two ValueSets added in this release.

### Built against
- LOINC 2.82 (tx.fhir.org; Athena snapshot 2026-01-21) · SNOMED CT International 20250201 (tx.fhir.org; Vocab2 snapshot 2025-02-01) · ICD-11 MMS 2026-01 (tx.fhir.org; WHO linearization export 2026-03-20) · UCUM 2.2 (NLM UCUM validator, tx.fhir.org) · IEEE 11073-10101 MDC 2024-12-05 (via hl7.fhir.uv.phd 1.1.0) · IG Publisher 2.2.10 · ledger verification dated 2026-09-15/17.

## Version 0.5.0 (2026-09-16)

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

## Version 0.4.8 (2026-07-18)

### openEHR Archetype Catalog

- **Term-binding count corrected to 8 of 12 (19 bindings).** The `CLUSTER.wearable_device` archetype gained an external binding: the `at0012` "Accelerometer" node is now bound to SNOMED CT `471451000124109` "Accelerometer" (Observable/Physical Object, `standard=S`, active — verified Database-First against the local Athena/Vocab2 downloads). This supersedes the **7 of 12 · 18 bindings** reported in the 0.4.7 entry below, which was accurate when that page was first published. Two OBSERVATION archetypes remain unbound by decision, both genuine terminology gaps: `circadian_rhythm` (the phenomenon has SNOMED `30920001`, but its metrics — acrophase, inter/intra-daily stability — have no code) and `recovery_readiness` (the adjacent `429157007` "Heart rate recovery time" is not equivalent). The two structural CLUSTERs carry no code by design.
- The catalogue page was re-rendered accordingly; **no FSH artefact was added, removed or reshaped** — the artefact counts are unchanged at 100 profiles / 77 extensions / 19 code systems / 204 value sets / 269 instances = **669**.

### Build

- IG Publisher 2.2.10 — **0 errors / 223 warnings / 0 broken links**. The warning class is unchanged from 0.4.7 (OID advisories on the 223 terminology resources); no conformance error.

## Version 0.4.7 (2026-07-17)

### openEHR Archetype Catalog

- Added the **openEHR Archetype Catalog** page (Implementation menu): a public inventory of the openEHR ADL 1.4 archetypes developed for this IG, reporting **12 genuinely original artefacts** (11 novel concepts + 1 specialisation of `CLUSTER.device.v1`) out of a 48-concept development snapshot. The page publishes the evidence behind that number rather than asking the reader to take it on trust — the four-way classification (**12** genuine + **5** CKM extensions + **21** duplicates + **10** classified = **48**), the CKM-mirror cross-check that produced it (`c798e8a`, **689** `.adl` files, **every RM type**; the mirror is of the trunk — 455 `in_development` / 232 `published` — so "no CKM equivalent" means absent even as a draft), the per-archetype external term-bindings (**7 of 12** bound, **18** bindings; Archie 3.15.0 → 12/12 `OK | VALID`), and the method caveats needed to weigh it. A further ~7 concepts exist without a CKM duplicate and are explicitly **not claimed** as original. The ADL files are **not distributed with this IG**: the page describes the archetype set, it is not a download point.

### Changed

- The LGPD and CFM example instances now use RFC-2606 example addresses (`dpo@example.org`, `support@example.org`) in place of real third-party contact details.

### Build

- genonce **0 errors / 223 warnings / 0 broken links** (IG Publisher 2.2.10). The 223 warnings are the same **single benign class** as v0.4.6: the IG Publisher (≥2.2.10) recommendation to assign OIDs to the 223 terminology resources (204 ValueSets + 19 CodeSystems) for interoperability with OID-based ecosystems such as CDA. None is a FHIR conformance error — the build validates with **zero errors**, and a registered OID root (IANA Private Enterprise Number) is planned for the production phase as the genuine remediation; OIDs are never invented without a registered root.

### Updated Totals (v0.4.7, FSH source)

- **100 Profiles**, **77 Extensions**, **19 CodeSystems**, **204 ValueSets**, **269 Instances** (incl. **29 ConceptMaps**) = **669 artefacts** — unchanged from v0.4.6: this release adds one narrative page and two example contact strings.

---

## Version 0.4.6 (2026-07-13)

### Inflammatory Marker Bindings — mitochondria↔inflammation panel

- Added four bridge-cytokine / metabolite Observation profiles binding the Castro-Marrero 2022 (PMID 35229657) mitochondria↔inflammation panel: **IL-1β (LOINC `13629-1`)**, **IL-8 (`33211-4`)**, **IL-10 (`26848-2`)**, and **lactate (`14118-4`)**. IL-1β / IL-8 / IL-10 join the `InflammatoryMarker` ValueSet; **lactate is deliberately kept OUTSIDE the inflammatory ValueSet** (metabolic, not inflammatory). All four codes verified Database-First (Athena, `std=S`) and live-validated against `tx.fhir.org`. Supports the HRV↔inflammation evidence base cited by G1.

### Build

- genonce **0 errors / 223 warnings / 0 broken links** (IG Publisher 2.2.10). The 223 warnings are a **single benign class**: the IG Publisher (≥2.2.10) recommendation to assign OIDs to the 223 terminology resources (204 ValueSets + 19 CodeSystems) for interoperability with OID-based ecosystems (e.g. CDA). None is a FHIR conformance error — the build validates with **zero errors** and all terminology is live-validated against `tx.fhir.org`. A registered OID root (IANA Private Enterprise Number) is planned for the production phase (post-defense) as the genuine remediation; OIDs are never invented without a registered root.

### Updated Totals (v0.4.6, FSH source)

- **100 Profiles** (+4), **77 Extensions**, **19 CodeSystems**, **204 ValueSets**, **269 Instances** (+4 examples; incl. **29 ConceptMaps**) = **669 artefacts**. IG Publisher 2.2.10, EN locale.

---

## Version 0.4.5 (2026-06-20)

### Dependency

- **IPS `hl7.fhir.uv.ips` 2.0.0 → 2.0.1**: HL7's formal IPS 2.0.1 release cleared the single dependency-staleness advisory carried in v0.4.4 — **restoring `warn=0`** (genonce **0 errors / 0 warnings / 0 broken links**) and making v0.4.5 the fifth consecutive zero-error release (v0.4.1 → v0.4.5). The first build to reach `warn=0` was **v0.4.1** (warnings 137 → 0); v0.4.4's single staleness advisory was the only interruption between them. The transitive `hl7.fhir.uv.extensions.r4` is unchanged at 5.3.0 (a per-resource diff against v0.4.4 shows zero regressions).

### Updated Totals (v0.4.5, FSH source — unchanged vs v0.4.4)

- **96 Profiles**, **77 Extensions**, **19 CodeSystems**, **204 ValueSets**, **265 Instances** (incl. **29 ConceptMaps**) = **661 artefacts** — dependency bump only, no FSH/pagecontent change. IG Publisher 2.2.7, EN locale.

---

## Version 0.4.4 (2026-06-19)

### Documentation / CI

- **Course-CI narrative accuracy**: `fhir-intermediate-course-alignment.md` items 4.3 + 4.9 upgraded from "roadmap" to ✅ DONE — the CDS Hooks Card `jsonschema` validator (`.github/scripts/validate_cds_cards.py`, `--self-test`) in a hard-fail GitHub Actions workflow, plus the weekly ConceptMap drift-check (`.github/scripts/conceptmap_drift_check.py`). genonce **0 errors / 1 warning / 0 broken links** — the single warning being the benign upstream IPS 2.0.0→2.0.1 staleness advisory (cleared in v0.4.5), not introduced by this change.

### Updated Totals (v0.4.4, FSH source — unchanged vs v0.4.3)

- **661 artefacts** (pagecontent-only edit).

---

## Version 0.4.3 (2026-06-13)

### Vital Signs — SpO₂ dual-coding + HRV/panel profiles

- **SpO₂ dual-coding (US Core Pulse Oximetry pattern)**: `OxygenSaturationObservation` slices `code` into `O2Sat` (LOINC `2708-6`, the FHIR `oxygensat` method-independent anchor mandated by R4/R5) + `PulseOx` (LOINC `59408-5`, pulse-ox method). Aligns the IG with the most widely implemented FHIR profile (US Core) and HL7 discussion FHIR-31574; `2708-6` is retained in the ValueSet for true arterial blood-gas samples.
- **New profiles**: `SdnnObservation` (HRV-SDNN, LOINC `80404-7`, ms) and `VitalSignsPanel` (LOINC `85353-1`, `hasMember` → HR / BP / SpO₂ / Temp / RR + Body Metrics), with examples.
- **Narrative**: new "SpO₂ Coding — Pulse Oximetry vs Arterial Blood Gas" subsection; four pagecontent pages aligned to the dual-coding.

### Updated Totals (v0.4.3, FSH source)

- **96 Profiles**, **77 Extensions**, **19 CodeSystems**, **204 ValueSets**, **265 Instances** (incl. **29 ConceptMaps**) = **661 artefacts**
- **1,123 custom codes** + **34 ICD-11 codes**
- IG Publisher 2.2.7, EN locale: genonce **0 errors / 0 warnings / 0 broken links**

---

## Version 0.4.2 (2026-06-08)

- **Activity profile device-method binding**: `PhysicalActivityObservation` gains `moderateMinutes` (LOINC `101689-8`) + `vigorousMinutes` (LOINC `101690-6`) component slices (UCUM `min`, Database-First Athena-verified), closing the openEHR↔FHIR↔OMOP round-trip.
- **Terminology**: Amphetamine `SCT#373338002` (inactive since 2014) → active successor `SCT#703842006`; openEHR ConceptMap internal-consistency alignment (F1/F2 — display/comment only, no binding changes).

---

## Version 0.4.1 (2026-06-01)

- **LifestyleMedicationRequest** profile + `DrugLifestyleInteraction` extension — a concrete FHIR resource for the CDS Hooks `drug-lifestyle-interaction` service.
- New narrative pages (GDL2→CDS Hooks bridge, implementation scope/roadmap, integrated SMART+CDS walkthrough) and two CQL Library doc-pointers.
- **VRF-TERM-018**: ~26 wrong-concept SNOMED/LOINC codes corrected (right code-system + valid code + *wrong* concept — invisible to the FHIR validator) via Database-First + tx.fhir.org `$validate-code`.

---

## Version 0.4.0 (2026-05-21)

- **Nutrition OMOP ConceptMap remediation (CN1)**: 11/11 fabricated OMOP `concept_id` mappings corrected via the Database-First Protocol (Athena direct lookup). *Errata*: the immutable v0.3.0 release shipped the pre-remediation map.
- +4 Profiles (incl. `WearableMeasurementProvenance` and `LifestyleMedicineGroupETL` for population/ETL export) + 11 Extensions; IPS upstream baseline (Pitfall #31) eliminated. This release cleared the 23 IPS-inherited errors but was **not** yet clean: five errors remained (two IG Publisher binding limitations in the ETL Group profiles, three transient terminology-server connectivity errors) together with 137 warnings. Both were cleared in v0.4.1, which is the **first fully clean build** (0 errors / 0 warnings).

---

## Version 0.3.0 (2026-05-14)

- **SMART on FHIR STU2.2**, **CDS Hooks 2.0** (4-service catalog), **Bulk FHIR Export**, **AuditEvent** profiles, and **Multi-Jurisdictional Consent** (LGPD + GDPR + HIPAA).
- 5 new profiles (`AuditEventDataAccess`, `AuditEventAIInteraction`, `MultiJurisdictionalConsent`, `BulkExportGroup`, `BulkExportConsent`) plus CDS Hooks discovery/registry instances and a SMART CapabilityStatement.

---

## Version 0.2.1 (2026-03-25)

### ICD-11 CodeSystem Restored (Option B)

- **ICD-11 CS republished under IG namespace**: The ICD-11 CodeSystem (34 codes) removed in v0.2.0 was restored because IG Publisher v2.2.1+ treats unknown CodeSystem codes as errors (not warnings). Since tx.fhir.org does not support ICD-11 validation (as of March 2026), codes are republished under the IG namespace (`ICD11LifestyleMedicineCS`) with `content = #complete`. WHO attribution preserved in description and copyright. See [Design Decisions](design-decisions.html) for full rationale.
- **CodeSystem count**: 14 → **15**

### OMOP ConceptMap Audit

- **28 corrections** across 6 ConceptMaps (VRF-TERM-017):
  - 11 hallucinated OMOP concept_ids in OpenEHR ConceptMap
  - 9 corrections in Activity/Sleep/HRV ConceptMaps (5 hallucinated IDs + 4 false GAPs)
  - Sleep quality LOINC corrected: 28323-4 → 95607-8
  - Sleep display mismatches fixed (deep sleep, light sleep)
  - `measurement_type_concept_id`: 44818707 → 44818706 (patient reported device) across all ConceptMaps
- All corrections verified against Athena CONCEPT.csv (Database-First protocol)

### Phase 3 LOINC Substitutions

- **8 new LOINC substitutions** (total: 11 → **19**):
  - 6 CGM codes from CGM IG v1.0.0 family (TBR, TBR-L2, TAR, TAR-L2, CV, Mean Glucose)
  - 1 CGM improved (Sensor Active Time: 97504-5 → 104637-4)
  - 1 Sport code (Activity Type → LOINC 73985-4)
  - 1 Sensor Days (→ LOINC 104636-6)

### LGPD Regulatory Framework (Phases 1-3)

- **Phase 1**: Processing purposes (7 codes), AI consent categories (3 codes), DataAnonymizationStatus extension
- **Phase 2**: OrganizationDataController, PractitionerRoleDPO, TaskDataSubjectRequest profiles
- **Phase 3**: DataMinimizationScope extension, BiasDetectionFlag extension, CommunicationSecurityIncident profile, anonymization methods ValueSet
- 4 LGPD example instances (controller, DPO, data subject request, incident notification)
- Cross-jurisdictional design: DataAnonymizationStatus and DataMinimizationScope shared by LGPD, GDPR, and HIPAA

### AI/CDSS Compliance (3 Levels)

- **Level 1**: 20 AgentCS codes (risk assessment, model metadata, clinician override, audit events) + 3 ValueSets + AIInferenceMetadata extension
- **Level 2**: AuditEventAIInteraction, ClinicalImpressionAIAssessment, CarePlanLifestyleMedicine profiles
- **Level 3**: DeviceDefinitionSLM profile, ConceptMapAIRiskLevels, 2 round-trip compliance Bundles

### Infrastructure

- **CapabilityStatement**: 12 resource types, 32 Observation supportedProfiles
- **7 SearchParameters**: domain, vendor, value-range, AI-model, AI-confidence, careplan-category, consent-jurisdiction
- **CI/CD pipeline**: GitHub Actions (SUSHI validation + IG Publisher build, QA threshold ≤23 errors)
- **License**: CC-BY-4.0

### Updated Totals

- **82 Profiles**, **56 Extensions**, **15 CodeSystems**, **189 ValueSets**, **236 Instances** (incl. 29 ConceptMaps)
- **1,103 custom codes** (719 TemporaryCS + 277 AppLogicCS + 107 AgentCS) + 34 ICD-11
- **19 LOINC substitutions** with documented migration paths
- SUSHI: 0 errors, 0 warnings
- genonce: 23 errors (IPS upstream baseline), ~200 warnings (30 suppressed)

---

## Version 0.2.0 (2026-03-02)

### Terminology Improvements

- **ICD-11 CodeSystem removed** (Phase 6a): Eliminated the 34-code ICD-11 republication in favour of direct WHO URL references. *Note: subsequently restored in v0.2.1 due to IG Publisher v2.2.1+ validation requirements.*
- **6 Sleep LOINC substitutions** (Phase 6b): Replaced 6 custom sleep codes with LOINC equivalents:
  - `sleep-time-bed` → LOINC 103213-5 (Duration in bed)
  - `sleep-deep` → LOINC 93831-6 (Deep sleep duration)
  - `sleep-light` → LOINC 93830-8 (Light sleep duration)
  - `sleep-awakenings` → LOINC 103211-9 (Number of awakenings)
  - `rem-sleep` → LOINC 93829-0 (REM sleep duration)
  - `waso` → LOINC 103215-0 (Wake after sleep onset)
- **ConceptMapSleepToLOINC**: 4 mappings corrected from GAP → EQUIVALENT

### Documentation

- Added Getting Started guide for implementers
- Added Must Support definitions page
- Added Conformance Requirements page
- Added this Change Log

---

## Version 0.1.0 (2025-2026) — Initial Development

### Phase 5: Evidence-Based Remediation (2026-02-27)

- Reduced CodeSystems from 19 → 15 (merged 4 small CS into existing ones)
- Removed 37 unreferenced codes with verified SNOMED/LOINC equivalents
- Reduced `required` bindings from 98 → 57 (required → extensible)
- Replaced bulk `include codes from system` with enumerated codes in 27 ValueSets
- 7 SharedQualifier SNOMED ValueSets adopted in profiles

### Phase 4: CodeSystem Consolidation (2026-02-27)

- Consolidated from 148 CodeSystems to 15
- Separated non-terminology codes into `AppLogicCS` (277 codes) and `AgentDecisionSupportCS` (107 codes)
- Created CDSS ValueSet with 15 LOINC/SNOMED lab + 23 SNOMED intervention codes

### Comparative Audit (2026-02-26)

- Benchmarked against PA IG, mCODE, US Core, SDOH, IPS, PHD, CGM IG v1.0.0
- Identified 244 codes that should use standard terminologies instead of custom codes
- Implemented 38 standard code substitutions

### RS11 Full Audit (2026-02-20)

- 1,173 custom codes audited against ~2.5M embeddings (8 ChromaDB collections)
- 97.4% confirmed as genuine terminology gaps
- 148 LOINC LA/LP part-level matches identified
- 5 LOINC substitutions implemented (CGM family: GMI, TIR, SD, Active Time; Sport: max-hr)

### Core Development (2025-2026)

- 82 profiles across 11 lifestyle medicine domains + regulatory
- 56 extensions for wearable and lifestyle data context
- 29 ConceptMaps for multi-vendor terminology translation
- 189 ValueSets with verified terminology bindings
- 236 example instances with dual-coding
- IPS STU2 integration for cross-border interoperability
- 5 round-trip validation Bundles (Apple HRV, Fitbit Sleep, Garmin Activity, Oura Sleep, Withings BP) + 2 AI/CDSS compliance Bundles
- 4-level terminology verification protocol
