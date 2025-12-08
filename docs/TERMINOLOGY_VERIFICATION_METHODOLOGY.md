# Terminology Code Verification Methodology

**Version**: 1.0
**Date**: 2025-12-08
**Author**: Ricardo Lourenco dos Santos / Claude Code
**Status**: Active

---

## 1. Purpose

This document establishes the **Zero Errors Policy** for terminology code verification in the iOS Lifestyle Medicine FHIR Implementation Guide. All terminology codes (SNOMED CT, LOINC, OMOP) must be verified via official sources before clinical use.

---

## 2. Scope

### Code Inventory
| Terminology | Files | Codes | Status |
|-------------|-------|-------|--------|
| LOINC | 6 ConceptMaps | ~67 codes | ~75% verified |
| SNOMED CT | 6 ConceptMaps | ~45 codes | ~30% verified |
| OMOP | 5 ConceptMaps | ~22 concepts | ~15% verified |
| Custom | 3 CodeSystems | ~65 codes | N/A |
| **Total** | **23 files** | **~200 codes** | **~40% verified** |

---

## 3. Verification Sources

### 3.1 LOINC
- **Primary**: https://loinc.org (manual search)
- **API**: FHIR $lookup via tx.fhir.org
- **Verify**: Code exists, Status = ACTIVE, Component matches

```bash
curl -s "https://tx.fhir.org/r4/CodeSystem/\$lookup?system=http://loinc.org&code=CODE" \
  -H "Accept: application/fhir+json"
```

### 3.2 SNOMED CT
- **Primary**: Australian Ontoserver FHIR API
- **Fallback**: browser.ihtsdotools.org (International edition)
- **Verify**: Code exists, Display name correct, Edition noted

```bash
curl -s "https://r4.ontoserver.csiro.au/fhir/CodeSystem/\$lookup?system=http://snomed.info/sct&code=CODE" \
  -H "Accept: application/fhir+json" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); params={p['name']:p.get('valueString','') for p in d.get('parameter',[])}; print(f\"Display: {params.get('display','NOT_FOUND')}\")"
```

### 3.3 OMOP CDM
- **Primary**: https://athena.ohdsi.org (manual search)
- **Verify**: concept_id exists, domain, vocabulary_id, standard_concept
- **Direct URL**: https://athena.ohdsi.org/search-terms/terms/{concept_id}

---

## 4. Verification Status Codes

| Status | Symbol | Meaning | Action |
|--------|--------|---------|--------|
| VERIFIED | ✅ | Code confirmed via official source | None |
| WRONG | ⚠️ | Code exists but wrong meaning | **REPLACE immediately** |
| NOT FOUND | ❌ | Code not in edition searched | Try International edition |
| PENDING | 🔄 | Not yet verified | Schedule verification |
| GAP | 📝 | No standard code exists | Document, consider submission |
| unmatched | #unmatched | FSH equivalence for missing | Acceptable if documented |

---

## 5. Documentation Standard

### 5.1 ConceptMap Comments
Every code mapping must include:

```fsh
// CODE: XXXXXX - [STATUS]
// Display: [actual display name from official source]
// Verified: YYYY-MM-DD via [source: Ontoserver/loinc.org/Athena]
// Edition: [AU/INT/US] for SNOMED CT
// Note: [clinical context or correction note]
```

### 5.2 Verification Status File
Update `CODE_VERIFICATION_STATUS_YYYYMMDD.md` with:

```markdown
## [Terminology] Codes - [STATUS]

| Code | Expected | Actual | File | Status | Date |
|------|----------|--------|------|--------|------|
| 123456 | Walking | Walking | ConceptMapX | VERIFIED | 2025-12-08 |
```

---

## 6. Verification Process

### Step 1: Extract Codes
1. Read ConceptMap file
2. Extract all `target[0].code` values
3. Note expected display name from `target[0].display`

### Step 2: Verify via API
1. Run verification command for each code
2. Compare returned display with expected
3. Mark status: VERIFIED, WRONG, NOT FOUND

### Step 3: Document Results
1. Update ConceptMap comments with verification date
2. Update verification status file
3. If WRONG: Replace code immediately

### Step 4: Handle NOT FOUND
1. Try alternate edition (International for SNOMED)
2. If still not found: Mark as #unmatched
3. Document gap for potential submission

---

## 7. Critical Findings (2025-12-08)

### Wrong SNOMED Codes Discovered
| Code | Expected | Actual | Severity |
|------|----------|--------|----------|
| 228432001 | Meditation | Drug tolerance | CRITICAL |
| 266940006 | Cycling | Lives in squat | CRITICAL |
| 266938001 | Swimming | Hospital patient | CRITICAL |
| 25999001 | Basketball | Atrophy of corpus cavernosum | CRITICAL |
| 271706000 | Gait function | Waddling gait | CRITICAL |

**Lesson**: NEVER use SNOMED codes without API verification.

### Verified Replacement Codes
| Concept | Code | Display | Status |
|---------|------|---------|--------|
| Physical activity | 68130003 | Physical activity | VERIFIED |
| Physical exercise | 61686008 | Physical exercise | VERIFIED |
| Sports activity | 14468000 | Sports activity | VERIFIED |
| Relaxation therapy | 64299003 | Relaxation training therapy | VERIFIED |
| Jogging | 229166008 | Jogging training | VERIFIED |
| Exercise therapy | 229065009 | Exercise therapy | VERIFIED |
| Walking | 129006008 | Walking | VERIFIED |

---

## 8. Documented Gaps

### No LOINC Code Available
- RMSSD (Root Mean Square of Successive Differences)
- pNN50 (Percentage of NN intervals >50ms)
- LF/HF Ratio (Low/High Frequency power ratio)
- LF Power, HF Power (frequency domain HRV)

### No OMOP Concept Available (concept_id = 0)
- RMSSD
- pNN50
- LF/HF Ratio
- Time in Range (TIR), Time Below Range (TBR), Time Above Range (TAR)
- Deep Sleep Duration, REM Sleep Duration
- Sleep Efficiency
- MET-minutes

---

## 9. Maintenance Schedule

| Task | Frequency | Responsible |
|------|-----------|-------------|
| New code verification | Before commit | Developer |
| Quarterly audit | Every 3 months | Lead |
| SNOMED edition update | Annual | Lead |
| LOINC version check | Semi-annual | Lead |
| Gap submission review | Annual | PI |

---

## 10. References

- LOINC: https://loinc.org/
- SNOMED CT Browser: https://browser.ihtsdotools.org/
- Australian Ontoserver: https://r4.ontoserver.csiro.au/fhir/
- OMOP Athena: https://athena.ohdsi.org/
- FHIR Terminology: https://tx.fhir.org/

---

*Document created: 2025-12-08*
*Last updated: 2025-12-08*
*FHIR IG Version: 0.1.0*
