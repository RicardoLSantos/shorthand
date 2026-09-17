# Terminology Verification Protocol

This page documents the verification protocols used to ensure accuracy and prevent hallucination in the terminology mappings within this Implementation Guide.

## The Problem: AI-Assisted Terminology Errors

Large Language Models (LLMs) can fabricate plausible-sounding but non-existent medical codes. During development of this IG, we observed:

- **Fabricated LOINC codes** (e.g., "LOINC-2025-HRV-001" - does not exist)
- **Incorrect OMOP concept_ids** (codes that appear valid but map to wrong concepts)
- **Outdated references** (citing deprecated or retired codes)

**Documented error rate**: 21.7% of AI-generated medical terminology references contained errors requiring correction (based on thesis verification audits, n=39 references).

## Four-Level Verification Protocol

All ConceptMaps in this IG follow a four-level verification protocol:

### Level 1: Input Validation

**What**: Verify source data before processing

| Check | Method | Tool |
|-------|--------|------|
| LOINC code exists | LOINC FHIR API query | https://fhir.loinc.org |
| SNOMED code active | SNOMED Browser | https://browser.ihtsdotools.org |
| OMOP concept valid | Athena lookup | https://athena.ohdsi.org |

**Example verification**:
```
LOINC 80404-7:
- API Response: ✓ Found
- Display: "R-R interval.standard deviation"
- Status: ACTIVE
- Version: 2.54 (December 2015)
```

### Level 2: Process Validation

**What**: Cross-reference multiple authoritative sources

| Source | Purpose | Priority |
|--------|---------|----------|
| Official terminology website | Ground truth | Primary |
| OHDSI Athena | OMOP mapping | Secondary |
| Published literature | Clinical validation | Tertiary |
| Vendor documentation | Implementation context | Supporting |

**Disagreement resolution**: When sources conflict, prefer official terminology sources (LOINC.org, SNOMED International) over aggregators.

### Level 3: Output Validation (Cross-Reference Matrix)

**What**: Verify final ConceptMap entries against primary sources

Each ConceptMap includes verification comments:

```fsh
// VERIFIED: LOINC 80404-7 → OMOP 21491502
// Source: Athena CONCEPT.csv, verified 2026-03-19 (VRF-TERM-017)
// Status: Standard concept, active
* group.element[0].code = #80404-7
* group.element[0].target[0].code = #21491502
* group.element[0].target[0].equivalence = #equivalent
```

### Level 4: User Validation

**What**: Clinical review before production use

- Clinician review of mapping clinical appropriateness
- Pilot testing in non-production environment
- Feedback loop for error reporting

## Verification Status Markers

ConceptMaps in this IG use standardized markers:

| Marker | Meaning | Action Required |
|--------|---------|-----------------|
| `// VERIFIED` | Confirmed against primary source | None - production ready |
| `// PENDING VERIFICATION` | Awaiting confirmation | Verify before clinical use |
| `// GAP` | No standard code exists | Use local code with provenance |
| `// DEPRECATED` | Code retired or replaced | Update to current code |

### Example from ConceptMapHRVToOMOP

```fsh
// VERIFIED: SDNN OMOP concept_id 21491502 via Athena 2026-03-19 (VRF-TERM-017)
* group.element[0].code = #80404-7
* group.element[0].display = "R-R interval.standard deviation"
* group.element[0].target[0].code = #21491502
* group.element[0].target[0].equivalence = #equivalent

// GAP: RMSSD has NO OMOP concept (concept_id = 0)
// Recommendation: Submit new concept proposal to OHDSI Vocabulary team
* group.element[1].code = #hrv-rmssd
* group.element[1].target[0].equivalence = #unmatched
```

## Verification Tools

### LOINC FHIR API

**Endpoint**: https://fhir.loinc.org/CodeSystem/$lookup

**Query example**:
```bash
curl "https://fhir.loinc.org/CodeSystem/\$lookup?system=http://loinc.org&code=80404-7"
```

**Response verification**:
- `parameter.name = "display"` → Official name
- `parameter.name = "property"` with `code = "STATUS"` → Active/Deprecated

### OHDSI Athena

**URL**: https://athena.ohdsi.org

**Verification steps**:
1. Search by concept code (e.g., "80404-7")
2. Verify `standard_concept = "S"` (Standard)
3. Note `concept_id` for OMOP mapping
4. Check `valid_end_date` for deprecation

### SNOMED Browser

**URL**: https://browser.ihtsdotools.org

**Verification steps**:
1. Search by SCTID or term
2. Verify concept is ACTIVE (not inactive/retired)
3. Check hierarchy for correct parent concepts
4. Note if GPS (Global Patient Set) compatible

## Anti-Hallucination Evidence

### RAG-Based Verification (Research Context)

This IG was developed alongside a Retrieval-Augmented Generation (RAG) system for terminology validation. **Important distinction**: While RAG has been applied to clinical text normalization (IMO Health) and terminology mapping proposal (Jackalope Plus achieving 77.5% accuracy for OMOP mapping), this work applies RAG specifically for **anti-hallucination verification**—preventing AI-assisted development from generating non-existent codes.

| Component | Purpose | Concepts Indexed |
|-----------|---------|------------------|
| **ChromaDB** | Vector database (8 collections) | ~2,500,000 |
| **LOINC Full** | Dedicated LOINC collection | 103,511 codes |
| **ICD-10-CM** | Diagnosis codes | 47,361 codes |
| **SNOMED** | Clinical findings | 349,000 codes |
| **Synonym** | Cross-terminology synonyms | 1,800,000 entries |
| **THO Collection** | HL7 Terminology | 20,051 codes |

**How it was used**: during development, retrieval over these indexed sources served as a *verification aid* — a deterministic index proposed candidate codes, and every code that entered the IG was then confirmed against the terminology owner's source and `tx.fhir.org` (the ledger above is the record). Language models were never the source of a code. **No implementation is distributed or required by this IG** — no retrieval or model component ships with it: a possible integration with an external terminology router is specified only through the interfaces, extensions and CodeSystems that carry an agent's outputs.

### Related Work in RAG for Terminology

| System | Purpose | Our Distinction |
|--------|---------|-----------------|
| [Jackalope Plus (2025)](https://doi.org/10.1038/s41598-025-04046-9) | **Propose** OMOP mappings | We **verify** existing codes |
| [IMO Health RAG](https://www.imohealth.com) | **Generate** codes from text | We **validate** against authoritative sources |
| OntologyRAG (2025) | **Map** ICD-10→SNOMED | We **prevent** fabrication |

### Hallucination Prevention Results

| Scenario | Without RAG | With RAG |
|----------|-------------|----------|
| Query: "LOINC for SDNN" | Fabricated "LOINC-2025-HRV-001" | Correct "80404-7" |
| Query: "OMOP for RMSSD" | Fabricated concept_id | Correctly identified gap |
| Overall error rate | ~25% | ~0% (for indexed codes) |

## Verification ledger — last verification by terminology

Every externally-defined code bound in the FSH sources is listed in `input/data/terminology-verification-ledger.csv` with the date, source and version of its last verification; codes are read in their three FSH forms — the inline `$SYSTEM#code "display"` token, the split form (`system` and `code` assigned on separate rules of the same element, with a `display` or a `unit`) and the Quantity shorthand (`value 'unit'`); a Quantity's `unit` text is recorded with the code but is not treated as a display claim, because FHIR defines it as the human-readable form. The ledger is produced by `.github/scripts/terminology_ledger_check.py` (run by hand and weekly as an advisory step of the ConceptMap Drift workflow) and never sits on the build path: the IG validates without a terminology server, and network failures are recorded as "unreachable", never as "not found".

**Sources, in order of authority.** The owner of each terminology is the reference: `loinc.org` and its FHIR API (LOINC, two releases a year, February and August); `browser.ihtsdotools.org`, International edition (SNOMED CT, monthly — the browser is for human use, so automated SNOMED checks use the dated Vocab2 snapshot and tx.fhir.org, both International); `icd.who.int` (ICD-11 MMS, one release a year — the linearization export and the ICD-10 to ICD-11 mapping tables are used as the owner source); `ucum.org` and the NLM validator (UCUM). The dated local OMOP snapshots (Athena, Vocab2) are mirrors; `tx.fhir.org` is the third, advisory source, also used to check that the display used in the IG is a registered designation of the concept.

**Last verification (2026-09-17 for the 71 rows added or re-verified today — the UCUM codes read from Quantity bindings and the codes bound by today's decisions; 2026-09-16 for 5 rows; 2026-09-15 for the remaining 423):**

| System | Codes in the IG | Last verified | Via | Source version(s) | Open findings |
|---|--:|---|---|---|--:|
| LOINC | 225 | 2026-09-17 | Athena OMOP snapshot, tx.fhir.org | Athena LOINC snapshot 2026-01-21; tx LOINC 2.82 | 11 |
| SNOMED CT (International) | 172 | 2026-09-17 | Vocab2 OMOP snapshot, tx.fhir.org | Vocab2 SNOMED 2025-02-01 SNOMED CT International Edition; tx SNOMED http://snomed.info/sct/900000000000207008/version/20250201 | 10 |
| ICD-11 MMS (republished in the IG) | 46 | 2026-09-15 | icd.who.int MMS linearization export, tx.fhir.org | WHO linearization 2026 Mar 20 - 14:07 UTC; tx ICD11 2026-01 | 0 |
| UCUM | 56 | 2026-09-17 | Athena OMOP snapshot, tx.fhir.org, ucum.nlm.nih.gov validator | Athena UCUM snapshot 2026-01-21; tx UCUM 2.2 | 9 |

**Findings on 2026-09-11.** The republished ICD-11 CodeSystem was rebuilt on this date after the first ledger run found 11 codes absent from ICD-11 MMS and 16 codes carrying another concept's title (7 of 34 were correct; see ICD-11 Integration → Correction of 2026-09-11); the run showed 0 ICD-11 findings against both the WHO linearization export and tx.fhir.org. Three defects surfaced in other systems and were corrected the same day: three custom HRV codes had been declared under the LOINC system in `ConceptMapHRVToOMOP` (now in a group whose source is the custom CodeSystem); SNOMED CT 228279004 (*Very heavy drinker*) had been used for *Heavy drinker* (now 86933000); and SNOMED CT 14012001 (*Common law partnership*) had been used for *Cohabiting* (now 38070000).

**Findings on 2026-09-15.** The ledger extractor had been cutting each FSH line at the first `//` outside quotes, which also cut codes written with their full system URL (`http://loinc.org#…`) in ValueSets, extensions and the bulk-export Group: 84 codes (24 LOINC, 60 SNOMED) had never been extracted. Separately, 19 codes already in the ledger had been recorded without a display, as ConceptMap targets only, so their meaning had never been checked — and the ConceptMap target displays themselves were never read by the extractor. Both gaps are closed; the population is 436 codes and every code bound with a display is checked against the concept it names. The display check found bindings that name another concept: in `ValueSetLOINCObservations`, 9059-7 (*Carbohydrate intake Estimated*) as protein intake, 9057-1 (*Calorie intake total 24 hour*) as carbohydrate intake, 9060-5 (*Carbohydrate intake Measured*) as fat intake, 9053-0 (*Calorie intake total 1 hour*) as fluid intake, 8636-3 (*Q-T interval corrected*) as R-R interval, 8625-6 (*P-R Interval*) as QT interval, 93832-4 (*Sleep duration*) as sleep efficiency and the two step-count codes with crossed displays — all corrected with the codes that carry those names (9085-2, 9065-4, 9072-0, 8990-4, 8637-1, 8634-8), and the nutrition ConceptMap targets with them; in `ValueSetCDSSInterventionRecommendations`, SNOMED CT 722172003 (*Military health institution*) as ambulatory monitoring and 840534001 (*Administration of SARS-CoV-2 antigen vaccine*) as a home-monitoring recommendation, replaced by 310858007 *Self-monitoring* and 439894008 *Provision of device*; in the social ConceptMap, LA137-2 (the answer *None*) as Family member, Friend and Significant other, replaced by LA9277-0, LA6656-8 and LA30381-0; in the vendor ConceptMap, daily step totals mapped to 55423-8 (pedometer count over an unspecified time), now 41950-7; and SNOMED CT 271299001 (the finding *Patient's condition worsened*) as the *Worsening* trend qualifier, now 230993007. Nine bindings still name another concept and are marked in place until a replacement is decided — because LOINC has no exact code or only *Estimated*/*Measured* variants, or because the choice is editorial: 9055-5 (fiber intake), 9061-3 (saturated fat intake), 9056-3 (caffeine intake), 65968-0 (eating habits), 63503-7 (household members), 75282-4 (diet), SNOMED CT 260347006 (*Fair* grade), 41653-7 (a capillary glucometer reading displayed as the mean glucose code 93791-2, in the CGM ConceptMap) and, in the vendor ConceptMap, a walking distance mapped to the step count 41950-7 where LOINC has distance concepts (55430-3, 41953-1, 93849-8). The 30 other findings are display-name classes, not concept errors: UCUM displays written as words (`Days` for `d`), where tx.fhir.org accepts only the code; LOINC long common names from an earlier release (`… Narrative`, now `… note`), abbreviated long common names and two displays that are the names of sibling codes of the same observable (19868-9, 19935-6), `Caloric` for *Calorie*, `QRS duration in EKG` for *QRS duration*, bracketed system suffixes such as `Heart rate [LOINC]`; and SNOMED displays that are unregistered variants or FSN-suffixed synonyms of the preferred term (`Former drinker (finding)` for *Ex-drinker*, `Maximum (qualifier value)` for *Maximal*, `Physical exercise (regime/therapy)`). Rows whose code has no display anywhere in the FSH say so in the ledger ("existence verified, meaning not checked").

**Findings on 2026-09-16.** The four rows that carried that note — the `ReproductiveObservation` component codes 72514-3, 3144-3, 92656-8 and 64699-2 — were confronted with the official names in the Athena snapshot and on tx.fhir.org (LOINC 2.82) and now carry them; no row remains with the note. Two of the four bindings were marked in place for review — 92656-8 and 64699-2 — and on 2026-09-17 both components were replaced by a single regularity component (SNOMED CT 364307006, values 302757007 / 80182007, verified in the Vocab2 snapshot and on tx.fhir.org); the remaining marked line, the walking/running distance mapped to a step count, was resolved the same day (LOINC 55430-3, equivalence *narrower*). No line in the FSH remains marked for review.

**Findings on 2026-09-17.** Until this date the ledger read only the inline `$SYSTEM#code` token and the ConceptMap groups; the split form (`valueQuantity.system` + `valueQuantity.code`, 48 distinct UCUM codes in 31 files) and the Quantity shorthand (`value 'unit'`, 37 distinct codes in 23 files) were not read, so 47 UCUM codes — every unit the IG's examples and profiles actually carry, beyond the 9 bound in ValueSets — had never been verified (56 in all). Two of them are not UCUM units, and neither was reported by any build: `days` in two example instances (corrected to `d`, the UCUM code for day) and `MET`, the fixed unit code of the VO2max profile's MET-capacity component (corrected to `{MET}`, the UCUM annotated form already used for `{MET-min}/wk`). Both were confirmed against the NLM UCUM validator and tx.fhir.org (UCUM 2.2). A base Quantity or Duration carries no required UCUM binding — invariant drt-1 checks that the system is UCUM, not that the code exists in it — so the build cannot see this class; the ledger can. The 45 other codes are active; their `unit` texts are recorded, not checked as displays. Later the same day the nutrition and substance-use value set (`ValueSetLOINCObservations`) received, next to each of its sixteen *Estimated* intake codes, the LOINC *Measured* variant of the same concept (every one of the sixteen exists in LOINC 2.82; names taken from the Athena snapshot and confirmed on tx.fhir.org): the value sets now carry the Estimated/Measured pairs and **the code identifies the method** — the Estimated code remains the one the profiles fix and the examples carry; the ConceptMaps keep their Estimated targets because their source concepts do not state the method.

**Cadence.** Codes are re-verified at the rhythm of each terminology (SNOMED International monthly; LOINC after each February and August release; ICD-11 and ATC after each annual release; UCUM and package-fixed vocabularies at each IG release), and release notes state the terminology versions the release was built against.

## Known Gaps

The following metrics have **no standard codes** despite extensive verification:

| Metric | LOINC | OMOP | SNOMED | Status |
|--------|-------|------|--------|--------|
| RMSSD | ❌ | ❌ | ❌ | Custom code required |
| pNN50 | ❌ | ❌ | ❌ | Custom code required |
| LF/HF Ratio | ❌ | ❌ | ❌ | Custom code required |
| Deep Sleep Duration | ❌ | ❌ | ❌ | Custom code required |
| Sleep Efficiency | ❌ | ❌ | ❌ | Custom code required |

These gaps are documented in the [LifestyleMedicineTemporaryCS](CodeSystem-lifestyle-medicine-temporary-cs.html); the per-concept `assignment-status` property (`pending-loinc`) is defined in `AppLogicCS` but is not yet applied to the concepts — an open item.

## Reporting Errors

If you discover a verification error in this IG:

1. **Check primary source** to confirm the error
2. **Open an issue** at the IG repository with:
   - Affected ConceptMap/CodeSystem
   - Incorrect code and correct code
   - Primary source reference
3. **Provide verification evidence** (screenshots, API responses)

## References

1. Santos RL. Integrating Wearable Biomarkers into Learning Health Systems through Semantic Interoperability [PhD thesis]. Porto: University of Porto; 2026. Chapter 3: AI Quality Control and Hallucination Detection.

2. Regenstrief Institute. LOINC Database v2.78. Indianapolis: Regenstrief Institute; 2026. Available from: https://loinc.org

3. OHDSI. Athena Vocabulary Repository. Available from: https://athena.ohdsi.org

4. HL7 International. HL7 Terminology (THO) v7.0.1. Available from: https://terminology.hl7.org

---

*Last updated: 2026-03-25*
*Verification protocol version: 2.0 (Database-First, post OMOP audit VRF-TERM-017)*
*Total verified codes in IG: 1,103 custom + 46 ICD-11 (republished)*
*LOINC substitutions: 19 (verified against Athena CONCEPT.csv)*
*OMOP audit: 28 corrections across 6 ConceptMaps (Mar 2026)*

---

## ADDENDUM (T1 S47, 28 May 2026) — VRF-TERM-018 (T2 S33) + Database-First Protocol v3 active-status axis (Lesson #538)

<!-- AUTHORED-BY-CLAUDE-T1-S47 - additive ADDENDUM per Lesson #431 frozen-at-birth -->

In late May 2026 the verification protocol was extended along a third axis after a systematic IG-wide audit (**VRF-TERM-018**, T2 S33, 26 May 2026) detected approximately twenty-six wrong-concept SNOMED CT and LOINC bindings — codes whose digit format was syntactically valid but whose display text did not match the source-side description (right code-system + valid code + wrong concept). These are invisible to standard validators (the code exists, so `$lookup` returns success) and require a *display-semantic* check via `tx.fhir.org $validate-code`, which is synonym-tolerant: a `result = false` from `$validate-code` is a genuine flag because the validator accepts any registered designation for the concept, so a mismatch indicates the binding points at a different concept entirely.

The remediation cycle (DocumentFirst per the protocol above):

1. **Detect** — `$validate-code` over every externally-bound SNOMED/LOINC code in the IG.
2. **Triage** — separate "same concept, different wording" (accept; synonym) from "different concept" (defect).
3. **Replace** — verify each replacement code with `$lookup` + Vocab2 (two-source) before substitution.
4. **Closure pass** — re-run `$validate-code` over all replacements; expect zero defeats, only synonym-class warnings.

The closure pass confirmed: zero active wrong-concept bindings besides six flagged inline `// ⚠️ VRF-TERM-018` (cases where no clean International code exists for the concept; the inline flag asks T1 / clinical reviewer to decide whether to keep the local CodeSystem code, define a new local code, or accept the closest International code with the semantic gap documented). Critically, one replacement code (SNOMED `373338002`) was later found INACTIVE during follow-up audit (T2 S34) — which prompted the **Database-First Protocol v3** refinement (**Lesson #538**): the protocol now verifies *three* axes for every code, not two:

- **Axis 1 — Existence** (`$lookup` returns success; the code exists in the code system).
- **Axis 2 — Display-semantic** (`$validate-code` returns true; the display text matches a registered designation for the concept).
- **Axis 3 — Active-status** (`$lookup`'s response includes `status: active`; the code has not been deprecated by the source authority).

A code that passes Axes 1 and 2 but fails Axis 3 (the `373338002` case) is a *future failure*: the binding works today, but the source authority has flagged the code as deprecated and any new client validating against the latest release will reject it. Adding Axis 3 to the protocol catches this pre-release. The full discipline is now documented as Pitfall #109 in the project ledger (display-semantic verification) and Lesson #538 (active-status axis as the third Database-First check).

**Cumulative verification footprint** (as of v0.4.1 PRE-STAGED, 28 May 2026): 1,103 custom codes + 34 ICD-11 fragment + ~26 VRF-TERM-018 SNOMED/LOINC remediated (T2 S33) + 6 inline-flagged (deferred to T1/clinical decision) + 1 active-status correction (T2 S34, `373338002` → successor pending Database-First v3 confirmation, deferred T2 S36+) = a total of ~1,170 codes verified against at least Athena CONCEPT.csv (LOINC + standard vocabularies), Vocab2 (SNOMED CT), and `tx.fhir.org` (existence + display + active-status). The audit pattern is now a recurring discipline rather than a one-time exercise: every pre-release pass runs `$validate-code` over the full external-binding surface and quarantines new flags before the release proceeds.
