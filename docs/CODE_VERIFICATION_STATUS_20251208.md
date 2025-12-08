# ConceptMap Code Verification Status
**Date**: 2025-12-08
**Author**: Claude Code (Terminal 1)
**Purpose**: Track verification status of terminology codes used in iOS Lifestyle Medicine FHIR IG

---

## Summary

| Category | Verified | Pending | Total |
|----------|----------|---------|-------|
| LOINC Codes | 8 | 3 | 11 |
| SNOMED CT Codes | 0 | 15+ | 15+ |
| OMOP Concepts | 2 | 10+ | 12+ |
| **Total** | **10** | **28+** | **38+** |

---

## LOINC Codes - VERIFIED

| Code | Component | Status | Verification Date |
|------|-----------|--------|-------------------|
| **80404-7** | R-R interval.standard deviation (HRV SDNN) | **ACTIVE** | 2025-12-08 |
| **8867-4** | Heart rate | **ACTIVE** | 2025-12-08 |
| **40443-4** | Heart rate --resting | **ACTIVE** | 2025-12-08 |
| **77233-5** | Body fat percentage (BIA method) | **ACTIVE** | 2025-12-08 |
| **2345-7** | Glucose [Mass/volume] in Serum or Plasma | **ACTIVE** | 2025-12-08 |
| **9279-1** | Respiratory rate (Breaths NRat) | **ACTIVE** | 2025-12-08 |
| **29463-7** | Body weight | **ACTIVE** | 2025-12-08 |
| **82611-5** | Wearable device external physiologic monitoring panel | **ACTIVE** | 2025-12-08 |
| **55423-8** | Number of steps (Pedometer) | **ACTIVE** | 2025-12-08 |

### LOINC Panel 82611-5 Members (Wearable Device Panel)
1. Heart rate
2. Body temperature
3. Sagittal plane body position
4. Activity level [Acceleration]
5. Respiratory wave amplitude
6. R-R interval standard deviation (HRV)
7. Systolic blood pressure
8. Diastolic blood pressure

---

## LOINC Codes - CONFIRMED NOT EXISTING

| Metric | LOINC Status | Notes |
|--------|--------------|-------|
| **RMSSD** | NO CODE | Primary wearable HRV metric - needs LOINC submission |
| **pNN50** | NO CODE | Parasympathetic marker - needs LOINC submission |
| **LF/HF Ratio** | NO CODE | Autonomic balance - needs LOINC submission |
| **LF Power** | NO CODE | Frequency domain HRV |
| **HF Power** | NO CODE | Frequency domain HRV |
| **Sleep Duration** | PENDING | Need to search |
| **Deep Sleep** | PENDING | Need to search |
| **REM Sleep** | PENDING | Need to search |

---

## SNOMED CT Codes - VERIFIED (via Australian Ontoserver)

| Code | Actual Display Name | ConceptMap File | Status |
|------|---------------------|-----------------|--------|
| **86290005** | Respiratory rate | Multiple | **VERIFIED** ✅ |
| **129006008** | Walking | ConceptMapPhysicalActivityToSNOMED | **VERIFIED** ✅ |
| **229065009** | Exercise therapy | ConceptMapPhysicalActivityToSNOMED | **VERIFIED** ✅ |
| **41355003** | Ultraviolet radiation | ConceptMapEnvironmentalToSNOMED | **VERIFIED** ✅ |
| **68130003** | Physical activity | Multiple | **VERIFIED** ✅ |
| **61686008** | Physical exercise | Multiple | **VERIFIED** ✅ |
| **14468000** | Sports activity | Multiple | **VERIFIED** ✅ |
| **64299003** | Relaxation training therapy | Multiple | **VERIFIED** ✅ |
| **229166008** | Jogging training | Multiple | **VERIFIED** ✅ |
| **61334006** | Biofeedback | Multiple | **VERIFIED** ✅ |
| **225365006** | Care regime | Multiple | **VERIFIED** ✅ |
| **48761009** | Motor behaviour | ConceptMapPhysicalActivityToSNOMED | **VERIFIED** ⚠️ (expected "Regular exercise") |

## SNOMED CT Codes - WRONG MAPPINGS (via Australian Ontoserver)

| Code | Expected Concept | Actual Concept | ConceptMap File | Action |
|------|------------------|----------------|-----------------|--------|
| **228432001** | Meditation | Drug tolerance | ConceptMapMindfulnessToSNOMED | **REPLACE** |
| **271706000** | Gait function | Waddling gait | ConceptMapMobilityToSNOMED | **REPLACE** |
| **266940006** | Cycling | Lives in squat | ConceptMapPhysicalActivityToSNOMED | **REPLACE** |
| **266938001** | Swimming | Hospital patient | ConceptMapPhysicalActivityToSNOMED | **REPLACE** |
| **25999001** | Basketball | Atrophy of corpus cavernosum | ConceptMapPhysicalActivityToSNOMED | **REPLACE** |

## SNOMED CT Codes - NOT FOUND IN ONTOSERVER (Australian Edition)

**Note**: Ontoserver uses Australian edition. Some codes may exist in International or US editions.

| Code | Expected Concept | ConceptMap File | Status |
|------|------------------|-----------------|--------|
| 60156001 | Deep breathing exercise | ConceptMapEnvironmentalToSNOMED | NOT FOUND |
| 398144009 | Relaxation | ConceptMapMindfulnessToSNOMED | NOT FOUND |
| 271722003 | Balance | ConceptMapMobilityToSNOMED | NOT FOUND |
| 249869000 | Walking speed | ConceptMapMobilityToSNOMED | NOT FOUND |
| 364555000 | Movement quality | ConceptMapMobilityToSNOMED | NOT FOUND |
| 71537002 | Hiking | ConceptMapPhysicalActivityToSNOMED | NOT FOUND |
| 229070001 | Exercise training | ConceptMapPhysicalActivityToSNOMED | NOT FOUND |
| 85098004 | Tennis | ConceptMapPhysicalActivityToSNOMED | NOT FOUND |
| 81598007 | Football | ConceptMapPhysicalActivityToSNOMED | NOT FOUND |
| 418818004 | Tai chi | ConceptMapPhysicalActivityToSNOMED | NOT FOUND |
| 10335005 | Rowing | ConceptMapPhysicalActivityToSNOMED | NOT FOUND |
| 15128009 | Climbing | ConceptMapPhysicalActivityToSNOMED | NOT FOUND |
| 49774004 | Golf | ConceptMapPhysicalActivityToSNOMED | NOT FOUND |

## CRITICAL ISSUES FOUND

### Wrong SNOMED Mappings Requiring Fix (5 total):
1. **228432001**: Mapped as "Meditation" but is actually "Drug tolerance"
2. **271706000**: Mapped as "Gait function" but is "Waddling gait"
3. **266940006**: Mapped as "Cycling" but is "Lives in squat"
4. **266938001**: Mapped as "Swimming" but is "Hospital patient"
5. **25999001**: Mapped as "Basketball" but is "Atrophy of corpus cavernosum"

### Incorrect Semantic Mapping (1 total):
1. **48761009**: Expected "Regular exercise" but is "Motor behaviour" - semantically different

**Action Required**: These ConceptMaps need to be corrected with proper SNOMED codes.

**Manual Verification Required**: Use browser.ihtsdotools.org for codes returning NOT FOUND

---

## OMOP Concepts - VERIFIED

| Concept ID | Concept Name | Domain | Vocabulary | Status |
|------------|--------------|--------|------------|--------|
| **37547368** | R-R interval.standard deviation (HRV) | Measurement | LOINC | **VERIFIED** (Athena 2025-11-28) |
| **3027018** | Heart rate | Measurement | LOINC | **VERIFIED** |

---

## OMOP Concepts - DOCUMENTED GAPS (concept_id = 0)

| Metric | Status | ConceptMap | Notes |
|--------|--------|------------|-------|
| RMSSD | **NO OMOP CONCEPT** | ConceptMapHRVToOMOP | Critical gap - primary wearable metric |
| pNN50 | **NO OMOP CONCEPT** | ConceptMapHRVToOMOP | Parasympathetic marker |
| LF/HF Ratio | **NO OMOP CONCEPT** | ConceptMapHRVToOMOP | Autonomic balance |
| Time in Range (TIR) | **NO OMOP CONCEPT** | ConceptMapCGMToOMOP | CGM metric |
| Time Below Range (TBR) | **NO OMOP CONCEPT** | ConceptMapCGMToOMOP | CGM metric |
| Time Above Range (TAR) | **NO OMOP CONCEPT** | ConceptMapCGMToOMOP | CGM metric |
| Deep Sleep Duration | **NO OMOP CONCEPT** | ConceptMapSleepToOMOP | Sleep architecture |
| REM Sleep Duration | **NO OMOP CONCEPT** | ConceptMapSleepToOMOP | Sleep architecture |
| Sleep Efficiency | **NO OMOP CONCEPT** | ConceptMapSleepToOMOP | Sleep quality |
| MET-minutes | **NO OMOP CONCEPT** | ConceptMapActivityToOMOP | WHO activity metric |

---

## OMOP Concepts - PENDING VERIFICATION

| Concept ID | Expected Name | ConceptMap | Status |
|------------|---------------|------------|--------|
| 40771089 | Step count | ConceptMapActivityToOMOP | PENDING |
| 4272025 | ? | Multiple | PENDING |
| 4090484 | Physical activity | ConceptMapActivityToOMOP | PENDING |
| 3004501 | Glucose | ConceptMapCGMToOMOP | PENDING |
| 3024171 | Respiratory rate | ConceptMapHRVToOMOP | PENDING |
| 40770386 | ? | ConceptMapOpenEHRToOMOP | PENDING |
| 4149130 | ? | ConceptMapOpenEHRToOMOP | PENDING |
| 4074432 | ? | ConceptMapOpenEHRToOMOP | PENDING |
| 40771110 | Sleep duration | ConceptMapSleepToOMOP | PENDING |
| 4044180 | ? | ConceptMapOpenEHRToOMOP | PENDING |

**Manual Verification Required**: Use athena.ohdsi.org

---

## Next Steps

1. **SNOMED Verification** (Priority: High)
   - Use browser.ihtsdotools.org for each pending SNOMED code
   - Update ConceptMaps with verification dates
   - Document any codes that don't exist

2. **OMOP Verification** (Priority: High)
   - Use athena.ohdsi.org for each pending OMOP concept
   - Verify domain, vocabulary, and standard status
   - Update ConceptMaps with verification dates

3. **OHDSI Vocabulary Submission** (Priority: Medium)
   - Prepare submission for RMSSD, pNN50, LF/HF
   - Include clinical justification from RS1/RS5 findings
   - Reference LOINC codes where available

---

## Verification Sources

- **LOINC**: https://loinc.org/
- **SNOMED CT**: https://browser.ihtsdotools.org/
- **OMOP/Athena**: https://athena.ohdsi.org/
- **FHIR Terminology**: https://tx.fhir.org/

---

---

## CORRECTIONS APPLIED (2025-12-08)

### ConceptMapMindfulnessToSNOMED
| Original Code | Wrong Display | Replaced With | Verified Display |
|---------------|---------------|---------------|------------------|
| 228432001 | Drug tolerance | **64299003** | Relaxation training therapy ✅ |
| 398144009 | NOT FOUND | **64299003** | Relaxation training therapy ✅ |

### ConceptMapMobilityToSNOMED
| Original Code | Issue | Action |
|---------------|-------|--------|
| 271706000 | "Waddling gait" (WRONG) | Changed to **#unmatched** |
| 271722003 | NOT FOUND | Changed to **#unmatched** |
| 249869000 | NOT FOUND | Changed to **#unmatched** |
| 364555000 | NOT FOUND | Changed to **#unmatched** |

### ConceptMapPhysicalActivityToSNOMED
| Original Code | Issue | Replaced With | New Display |
|---------------|-------|---------------|-------------|
| 229065009 | Was "Running" but is "Exercise therapy" | **229166008** | Jogging training ✅ |
| 266940006 | "Lives in squat" (WRONG) | **68130003** | Physical activity ✅ |
| 266938001 | "Hospital patient" (WRONG) | **68130003** | Physical activity ✅ |
| 25999001 | "Atrophy of corpus cavernosum" (WRONG) | **14468000** | Sports activity ✅ |
| 71537002 | NOT FOUND | **68130003** | Physical activity ✅ |
| 48761009 | "Motor behaviour" (semantic mismatch) | **61686008** | Physical exercise ✅ |
| 229070001 | NOT FOUND | **229065009** | Exercise therapy ✅ |
| 85098004 | NOT FOUND | **14468000** | Sports activity ✅ |
| 81598007 | NOT FOUND | **14468000** | Sports activity ✅ |
| 418818004 | NOT FOUND | **61686008** | Physical exercise ✅ |
| 10335005 | NOT FOUND | **68130003** | Physical activity ✅ |
| 15128009 | NOT FOUND | **68130003** | Physical activity ✅ |
| 49774004 | NOT FOUND | **14468000** | Sports activity ✅ |

---

## SUSHI Validation Result

```
SUSHI v3.16.5: 0 Errors, 0 Warnings
```

---

## Remaining Actions

1. **Manual Verification Required**: Use browser.ihtsdotools.org (International edition) to find specific sport codes
2. **ConceptMap Comments**: All corrected codes now include verification dates and notes
3. **Full IG Build**: Run `_genonce.sh` to generate complete IG with updated ConceptMaps

---

*Document created: 2025-12-08*
*Last updated: 2025-12-08 15:50*
*Terminal: 1*
*SUSHI Status: 0 Errors, 0 Warnings*
