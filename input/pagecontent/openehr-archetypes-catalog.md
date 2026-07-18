<!-- openEHR Archetype Catalog · iOS Lifestyle Medicine Implementation Guide -->

> **Status of the number below.** The count of genuinely original archetypes is **12**. This is the reconciled figure obtained by cross-checking the full development set against the openEHR CKM corpus — drafts included, not only the published archetypes. The reconciliation method, the evidence, and the archetypes that were **excluded** are all set out below so the claim can be checked rather than taken on trust.

# openEHR Archetype Catalog

> **Where the files live.** The ADL source files are **not currently distributed with this IG**: they were removed from the public repository in `ff0e86377` and the directory is git-ignored. This page is a *description* of that archetype set and of the reconciliation behind the count — it is not a download point. Distribution is a separate decision, tied to a CKM submission plan.

## 1. Scope: what this catalog claims, and what it does not

This catalog describes a set of openEHR ADL 1.4 archetypes developed by **Ricardo Lourenço dos Santos + Ricardo Correia** (FMUP, HEADS2 thesis) to model advanced wearable metrics that have **no published openEHR/CKM coverage** — the ~85% gap identified in the thesis. The strategy was **corrected in December 2025**, following the openEHR Transatlântico course, from "create everything" to **Template-First**: search the CKM → reuse what is already published → create only what is genuinely new → combine through operational templates.

**What this catalog does not do.** It does **not** present the 48 ADL files of the development snapshot as "48 archetypes ready for the CKM". Of the 48 unique concepts, **12 are candidates for genuine originality**; the remaining 36 (**5 extensions + 21 duplicates + 10 classified**) reuse, specialise, or duplicate existing CKM archetypes. Presenting those as original work would be a guaranteed CKM rejection, and indefensible.

**The claimed contribution has two levels:**

| Level | Content | Claimed as original? |
|---|---|:-:|
| **Core (12)** | **11 original concepts** + **1 specialisation** of `CLUSTER.device.v1` (`wearable_device`) = **12 artefacts** | **Yes** |
| **Further (7)** | The 7 concepts in §2.4 that have no CKM duplicate: `cognitive_assessment` · `mental_wellness` · `balance_assessment` · `posture_assessment` · `fall_detection` · `social_engagement` · `fertility_indicators` | **Not claimed** — they exist, but stay outside the originality claim |

Plus **6 `.oet` templates** and **2 reused CKM archetypes, credited** (§3). Every custom archetype is at lifecycle state `in_development` (draft). The roadmap is to complete the term-binding audit and then submit the audited genuine set to the CKM (§5).

## 2. Four-way classification (CKM mirror, deterministic cross-check)

> **Method.** `git clone --depth 1 openEHR/CKM-mirror` (mirror commit `c798e8a`, 2026-07-15) → **689 `.adl` files**, covering **every RM type**: OBSERVATION, CLUSTER, EVALUATION, ACTION and INSTRUCTION. The mirror is of the **trunk**, not of a published-only subset: **455 `in_development` against 232 `published`**. That composition makes "no CKM equivalent" a *stronger* statement rather than a weaker one — the concept is absent from the CKM even as a draft. Covering every RM type is also what allows the concepts in §2.4 to be classified from the mirror alone.
>
> ⚠️ **Matching trap** (recorded for anyone reproducing this). **Substring** matching fabricates duplicates: `mental` matches *environ**mental**_conditions*; `fall` matches *__fall__opian_tube*. Match on the exact concept name. The inverse bites just as hard: an **anchored** search (`^term`) produces false negatives — see §4.3.

### 2.1 🟢 GENUINE — no CKM equivalent (**12**) — the actual original contribution

| Archetype (concept) | RM type | CKM equivalent | Bindings **external, in the ADL** |
|---|---|---|---|
| `heart_rate_variability` | OBSERVATION | none | **1** — `[LOINC::80404-7]` (SDNN) |
| `sleep_architecture` | OBSERVATION | the CKM has only a PROMIS questionnaire on *disturbance*, not *architecture/stages* | **7** — `93832-4` sleep · `93830-8` light · `93831-6` deep · `93829-0` REM · `59408-5` SpO2 · `9279-1` RR · `[SNOMED::258158006]` |
| `stress_assessment` | OBSERVATION | none for wearables | **4** — `106860-0` PSS-10 · `70274-6` GAD-7 · `70272-0` PHQ-4 · `[SNOMED::73595000]` |
| `skin_temperature_wearable` | OBSERVATION | `body_temperature.v2` differs (wrist / continuous) | **1** — `[LOINC::39106-0]` |
| `screen_time` | OBSERVATION | none | **1** — `[SNOMED::2781000175103]` |
| `circadian_rhythm` | OBSERVATION | none (live-confirmed) | **0** — the metrics (acrophase, IS/IV) have no code |
| `lactate_threshold` | OBSERVATION | none (live-confirmed) | **2** — `2524-7` ×2 (LT1 + LT2; 🟡 specimen is Serum/Plasma, the test is capillary) |
| `recovery_readiness` | OBSERVATION | none — a standalone OBSERVATION | **0** — **a genuine gap** |
| `vo2max_estimation` | OBSERVATION | none — a standalone OBSERVATION | **2** — `[SNOMED::251898000]` + `60842-2` (🟡 generic) |
| `wearable_device` | CLUSTER | **specialisation** of `CLUSTER.device.v1` | **1** — `[SNOMED::471451000124109]` (accelerometer; other sensor flags unbound — see the note below) |
| `data_quality_indicator` | CLUSTER | none | 0 (cluster, by design) |
| `vendor_data_provenance` | CLUSTER | none | 0 (cluster, by design) |

> **State of the binding column: 8 of the 12 carry an external binding · 19 bindings in total.** Measured directly in the ADL source (the `wearable_device` accelerometer binding was added on 2026-07-17), and validated with Archie 3.15.0: 12/12 `OK | VALID | 0 errors | 0 warnings`.

> **Why the column counts only bindings that live in the ADL.** The CKM expects `term_bindings` **in the archetype** — *a binding that lives only in a FHIR profile does not travel with the archetype* — so FHIR-side coverage is deliberately excluded here. For `heart_rate_variability` that makes the count **1** rather than 3: only SDNN (`[LOINC::80404-7]`) has an external binding, while the custom RMSSD and pNN50 codes live in the FHIR CodeSystem. The archetype itself records both the reason and the exit: *"RMSSD, pNN50, LF/HF ratio, SD1, SD2 have NO LOINC codes … Migration path: When LOINC assigns codes, add bindings here"*. (The `openehr::128/380/382` references in that archetype are **RM property** references, not bindings to external terminologies.)

> **The terminology-gap argument, made precise.** The point is not that little is bound — it is that **the gaps sit exactly where the contribution is most original**. `recovery_readiness` = **0**: a confirmed genuine gap, as neither LOINC nor SNOMED CT carries a physiological-readiness concept. `circadian_rhythm` = **0** across its metrics (acrophase, interdaily stability and variability) even though the *phenomenon* itself has a code (`SNOMED::30920001`). And `heart_rate_variability` carries **1 of 6** metrics: SDNN has a code; **RMSSD, pNN50 and LF/HF do not** (Athena/OHDSI `concept_id` = 0). Finally, `wearable_device` draws the distinction sharply — and honestly: of its eight sensor flags, the accelerometer is now bound (`[SNOMED::471451000124109]`, exact and active); PPG, gyroscope, ECG, SpO₂ and barometer are genuinely unbound for lack of a code (a gap); but the GPS and temperature flags **do** have exact, active SNOMED codes (`897293009` "GPS tracker" and `720387005` "Wireless patient thermometer sensor", both *Physical Object*) and are unbound by decision, not by gap. Not everything unbound is a gap.

> **Composition of the 12.** The table lists **12** artefacts — 9 OBSERVATION + 3 CLUSTER — made up of **11 strictly original concepts + 1 specialisation** (`wearable_device`, which specialises `CLUSTER.device.v1` and is therefore not a new concept). An alternative modelling that placed `recovery_readiness` and `vo2max_estimation` as slots inside `physical_activity` was considered and rejected; both are modelled as standalone OBSERVATIONs. The reported number is **12** — a fixed count, not a range.

### 2.2 🟡 CKM EXTENSIONS — a base OBSERVATION exists, the wearable part is a slot or protocol (**5**) — **reuse, do not create**

`spo2_wearable` → **`pulse_oximetry`** · `respiratory_rate_wearable` → **`respiration`** · `electrocardiogram_wearable` → **`ecg_result`** · `blood_pressure_home` → **`blood_pressure`** · `physical_activity_detailed` → **`physical_activity`** (plus the `moderateMinutes` / `vigorousMinutes` device-method slices that the `PhysicalActivityObservation` FHIR profile already binds).

### 2.3 🔴 DUPLICATES — CKM equivalent confirmed → **removed from the submittable set** (**21**)

`exercise` / `running` / `swimming` / `hiking` / `cycling` / `strength` / `yoga` → **`physical_activity`** · `nutrition_intake` → **`nutrition_intake`** · `substance_use_tracking` → **`substance_use`** · `gait_analysis` → **`gait`** · `pain` / `fatigue` / `symptom_diary` → **`symptom_sign`** · `hydration_tracking` → **`fluid_balance`** · `medication_adherence` → **`medication`** · `hearing_health` → **`audiogram_result`** · `physiological_context` [CLUSTER] → **`level_of_exertion`** · `body_composition_wearable` → **`body_composition`** · `menstrual_cycle` / `pregnancy_tracking` → **`menstrual_diary`** + `pregnancy_assertion` · `recording_context` [CLUSTER] → merge into **`CLUSTER.device.v1`**.

### 2.4 ✅ CLASSIFIED (**10**)

Extending the cross-check to every RM type resolved the 10 concepts that were previously unclassified:

| Outcome | N | Concepts |
|---|:-:|---|
| **No CKM duplicate** → they exist, but are **not claimed** as original (the second level in §1) | **7** | `cognitive_assessment` · `mental_wellness` · `balance_assessment` · `posture_assessment` · `fall_detection` (the CKM has fall-*risk*, not a detection *event*) · `social_engagement` · `fertility_indicators` |
| **Duplicate / extension** | 1 | `environmental_exposure` |
| **Wrong RM type** (an ACTION/INSTRUCTION, not an OBSERVATION) | 1 | `sleep_intervention` |
| **Laboratory extension** → reuse `OBSERVATION.laboratory_test_result.v1` + `CLUSTER.laboratory_test_analyte` | 1 | `blood_glucose_cgm` |

**The arithmetic closes:** 48 = **12** (§2.1) + **5** (§2.2) + **21** (§2.3) + **10** (§2.4) ✔ — and the 48 is itself reproducible from the file set: 62 files − 5 extra files belonging to multi-version concepts = 57 names − 9 `_adl14` variants = **48** unique concepts. (The `adl14` marker sits in the *version*, not in the file extension, which is why `find -name "*.adl14"` returns nothing.)

## 3. Operational templates (`.oet`) and reused CKM archetypes

- **6 operational `.oet` templates**: `hrv` · `activity` · `sleep` · `stress` · `encounter` · `Wearable_Summary`. Like the ADL files, these are not distributed with this IG.
- **2 CKM archetypes reused, and credited**: `COMPOSITION.self_reported_data.v1` (Venheim / Helse Vest) and `CLUSTER.device.v1` (Leslie / Atomica).

## 4. Method caveats (for the reader to weigh)

1. **The term-binding audit is not complete.** It covers 7 OBSERVATION archetypes — `sleep_architecture` · `stress_assessment` · `screen_time` · `circadian_rhythm` · `lactate_threshold` · `recovery_readiness` · `vo2max_estimation` — and two of those bindings already carry a known caveat: `lactate_threshold` binds `2524-7`, whose specimen is Serum/Plasma while the threshold test is capillary; `vo2max_estimation` binds `60842-2`, which is generic. The 3 CLUSTER archetypes carry no external bindings **by design**. Completing this audit is the first step of the roadmap in §5.

2. **`glucose` returns nothing against the mirror — and that does not make the mirror incomplete.** Searching `glucos|glyc|hba1c` across all 689 files, every RM type, returns no match. The reason is that the CKM does not model analytes as dedicated archetypes: it uses `OBSERVATION.laboratory_test_result.v1` — which names "Glucose" as one of its examples — together with `CLUSTER.laboratory_test_analyte`. The mirror is therefore not shown to be incomplete, which makes the "no CKM equivalent" statements in §2.1 firmer rather than weaker.

3. **The form of the search changes the answer.** An **anchored** search (`^term`) produces false negatives: *"Video, television or computer **screen time**"* does not *begin* with "screen time", and that nearly cost `screen_time` a standard code that does exist. The false negative is the dangerous direction — it routes you toward minting a custom code where a standard one is already available and, unlike a false positive, nothing downstream catches it. The rule that follows: **search unanchored, filter afterwards.**

## 5. Lifecycle & submission roadmap

All custom archetypes in this catalog are at lifecycle state `in_development` (draft). The **12** genuinely original archetypes (§2.1) are the candidate contribution for openEHR CKM submission; the extensions, duplicates, and reused archetypes (§2.2–§2.4) are, by design, **not** submitted as original work.

**Roadmap:** complete the term-binding audit (§4) → submit the audited genuine set to the openEHR CKM (Batch-1A). The reused CKM archetypes and operational templates (§3) are combined via `.oet` templates, not submitted as new archetypes.

---
*The method rests on the cross-check against the CKM mirror (`openEHR/CKM-mirror`, commit `c798e8a`, 689 `.adl` files, every RM type) and on direct verification of the ADL source; the archetypes are validated with Archie 3.15.0 (12/12 `OK | VALID`). Contribution developed by Ricardo Lourenço dos Santos + Ricardo Correia (FMUP, HEADS2 thesis).*
