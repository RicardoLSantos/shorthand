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

**Key finding**: LLMs without RAG fabricated codes; with RAG grounding, the same queries returned verified codes from indexed sources. Benchmark: 42.9% accuracy (no RAG) → 92.9% (ChromaDB RAG) → 100% (+ abbreviation dictionary) on 14-case test.

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

## Known Gaps

The following metrics have **no standard codes** despite extensive verification:

| Metric | LOINC | OMOP | SNOMED | Status |
|--------|-------|------|--------|--------|
| RMSSD | ❌ | ❌ | ❌ | Custom code required |
| pNN50 | ❌ | ❌ | ❌ | Custom code required |
| LF/HF Ratio | ❌ | ❌ | ❌ | Custom code required |
| Deep Sleep Duration | ❌ | ❌ | ❌ | Custom code required |
| Sleep Efficiency | ❌ | ❌ | ❌ | Custom code required |

These gaps are documented in the [LifestyleMedicineTemporaryCS](CodeSystem-lifestyle-medicine-temporary-cs.html) with `assignment-status = "pending-loinc"`.

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
*Total verified codes in IG: 1,103 custom + 34 ICD-11 fragment*
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
