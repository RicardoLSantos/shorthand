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
// VERIFIED: LOINC 80404-7 → OMOP 37547368
// Source: Athena v5.0, verified 2025-12-08
// Status: Standard concept, active
* group.element[0].code = #80404-7
* group.element[0].target[0].code = #37547368
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
// VERIFIED: SDNN OMOP concept_id 37547368 via Athena 2025-12-08
* group.element[0].code = #80404-7
* group.element[0].display = "R-R interval.standard deviation"
* group.element[0].target[0].code = #37547368
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
| **ChromaDB** | Vector database | 827,000+ |
| **Athena Collection** | LOINC + SNOMED codes | 277,764 LOINC |
| **THO Collection** | HL7 Terminology | 20,051 codes |

**Key finding**: LLMs without RAG fabricated codes; with RAG grounding, the same queries returned verified codes from indexed sources.

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

*Last updated: 2026-01-24*
*Verification protocol version: 1.0*
*Total verified codes in IG: 130+*
