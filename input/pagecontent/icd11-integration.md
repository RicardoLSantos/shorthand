# ICD-11 Integration Roadmap

This page documents the WHO ICD-11 integration strategy for the iOS Lifestyle Medicine FHIR Implementation Guide, including current status, future ConceptMap development, and alignment with global health classification transitions.

## Background: The ICD-11 Transition

The World Health Organization (WHO) released ICD-11 in 2019 as the successor to ICD-10, with mandatory reporting beginning January 2022. As of 2025:

- **132 countries** are in various stages of ICD-11 transition planning
- **59 hospitals** in China completed a national pilot achieving **82.9% coding accuracy** (Zhang et al., 2024)
- **60.5% of mappings** require postcoordination (compound codes) rather than simple 1:1 equivalence (Xu et al., 2024)

### Why ICD-11 Matters for Lifestyle Medicine

ICD-11 introduces several features particularly relevant to wearable-derived health data:

| Feature | ICD-10 | ICD-11 | Lifestyle Medicine Impact |
|---------|--------|--------|---------------------------|
| **Postcoordination** | Limited | Extensive | Combine conditions with context (e.g., obesity + sleep apnea) |
| **Extension Codes** | None | Chapter X | QE86.0 "Monitoring: ongoing" for continuous tracking |
| **Digital Foundation** | Retrofitted | Native | Foundation URIs enable API integration |
| **FHIR Alignment** | Manual | WHO FHIR API | Native ConceptMap support |

## Current IG Status

### What This IG Provides

This Implementation Guide currently maps lifestyle medicine metrics to:

- **LOINC** (primary clinical terminology) - 80+ codes
- **SNOMED CT** (clinical findings) - 50+ codes
- **OMOP CDM** (research analytics) - 22 ConceptMaps
- **openEHR** (dual-model architecture) - Bidirectional mappings

### ICD-11 Gap

**Current ICD-11 Coverage: 0 ConceptMaps**

ICD-11 integration is planned as future work (see Roadmap below). The primary reason is that:

1. **ICD-11 is NOT in OHDSI Athena** - No standard OMOP concept_ids exist
2. **Lifestyle medicine codes are condition-adjacent** - We capture biomarkers (HRV, sleep stages) rather than diagnoses
3. **Mapping complexity** - 60%+ of ICD-11 mappings require postcoordination rules

## WHO ICD-11 FHIR API

The WHO provides a production FHIR R5 API for ICD-11 terminology services:

### API Endpoints

| Endpoint | URL | Purpose |
|----------|-----|---------|
| **Registration** | https://icd.who.int/icdapi | OAuth 2.0 credentials |
| **FHIR Base** | `https://icd-p-icdapiwebapp-*.azurewebsites.net/fhir/` | Terminology operations |
| **Metadata** | `.../fhir/metadata` | CapabilityStatement |

### Supported Operations

```
$lookup        - Retrieve code metadata
$validate-code - Verify code existence
$expand        - Expand ValueSets
$translate     - ConceptMap translation (future)
```

### Technical Details

- **FHIR Version**: R5 (5.0.0)
- **API Version**: v2.5.0
- **Authentication**: OAuth 2.0 Client Credentials
- **Formats**: JSON, XML

## Mapping Strategy

### Approach: LOINC-Centric with ICD-11 Secondary

This IG uses LOINC as the primary terminology for observations because:

1. **Wearable metrics are measurements**, not diagnoses
2. **LOINC has established OMOP mappings** (OHDSI standard vocabulary)
3. **ICD-11 excels at conditions**, not physiological parameters

The recommended mapping pattern:

```
Wearable Metric → LOINC (primary) → OMOP (analytics)
                      ↓
                  ICD-11 (when clinically indicated)
```

### Example: HRV as Cardiovascular Risk Biomarker

**Important clarification**: HRV does NOT directly diagnose hypertension. Instead, reduced HRV (low SDNN, low RMSSD) serves as a **cardiovascular risk biomarker** that correlates with:

- Autonomic dysfunction (reduced parasympathetic tone)
- Increased sympathetic activation
- Higher cardiovascular event risk
- Presence of hypertension and other cardiovascular conditions

**Clinical evidence**: Meta-analyses show inverse associations between HRV metrics and blood pressure, with reduced SDNN associated with 1.5-2x increased cardiovascular risk (Shaffer & Ginsberg, 2017; Task Force, 1996).

| Layer | Code | System | Description |
|-------|------|--------|-------------|
| **Measurement** | 80404-7 | LOINC | R-R interval.standard deviation (SDNN) |
| **OMOP** | 37547368 | Athena | SDNN concept_id |
| **Risk Assessment** | - | Clinical | Low SDNN (<100ms 24h) → Elevated CV risk |
| **Condition** | BA00.Z | ICD-11 | Essential hypertension (diagnosed separately via BP measurement) |

**Use case**: A patient with low wearable-derived SDNN may warrant clinical BP screening, but the ICD-11 diagnosis requires standard diagnostic criteria (≥140/90 mmHg on repeated measurements).

### Postcoordination Considerations

ICD-11 postcoordination allows combining codes:

```
BA00.Z (Essential hypertension)
  + QE86.0 (Monitoring: ongoing)
  + XY01 (Wearable device as source)
```

This IG does NOT implement postcoordination rules. Organizations adopting this IG should:

1. Consult WHO ICD-11 Reference Guide for postcoordination syntax
2. Implement local business rules for condition inference
3. Validate with clinical informaticists before production use

## Implementation Roadmap

### Phase 1: Documentation (Current - Q1 2026)

- [x] Document ICD-11 integration strategy (this page)
- [x] Reference WHO FHIR API specifications
- [ ] Add ICD-11 citations to bibliography

### Phase 2: Reference ConceptMaps (Q2-Q3 2026)

Planned ConceptMaps for lifestyle medicine conditions:

| ConceptMap | Source | Target | Scope |
|------------|--------|--------|-------|
| `ConceptMapLOINCToICD11` | LOINC observations | ICD-11 conditions | Hypertension, diabetes, obesity |
| `ConceptMapSleepToICD11` | Sleep metrics | ICD-11 Chapter 7 | Sleep apnea, insomnia |
| `ConceptMapActivityToICD11` | Activity codes | ICD-11 Chapter 5 | Metabolic conditions |

### Phase 3: Validation (Q4 2026)

- Pilot testing with healthcare organizations
- Accuracy benchmarking against 82.9% baseline (Zhang et al., 2024)
- CFIR-based implementation assessment (Ooi et al., 2025)

## WHO Mapping Tables

WHO provides official ICD-10 to ICD-11 mapping tables:

| File | Records | Description |
|------|---------|-------------|
| `10To11MapToOneCategory.txt` | 12,597 | 1:1 mappings |
| `10To11MapToMultipleCategories.txt` | 15,658 | 1:N mappings |
| `11To10MapToOneCategory.txt` | 17,908 | Reverse mappings |

**Download**: https://icdcdn.who.int/static/releasefiles/2024-01/mapping.zip

These tables form the foundation for future ConceptMap development in this IG.

## References

1. Zhang M, Wang Y, Jakob R, Su S, Bai X. Methodologies and key considerations for implementing the International Classification of Diseases-11th revision morbidity coding: insights from a national pilot study in China. *J Am Med Inform Assoc*. 2024;31(4):855-63. doi:10.1093/jamia/ocae031

2. Xu Y, et al. Mapping neoplasm concepts between ICD-10 and ICD-11. *J Med Internet Res*. 2024. doi:10.2196/52296

3. Ooi SY, Isa ZM, Manaf MRA, Fuad A, Sidek S. Facilitators and challenges to ICD-11 implementation: a qualitative study using the consolidated framework for implementation science. *BMC Med Inform Decis Mak*. 2025;25:14. doi:10.1186/s12911-025-03157-7

4. WHO. ICD-11 Reference Guide. Geneva: World Health Organization; 2024. Available from: https://icd.who.int/

5. Tegegne MD, et al. Mapping Early Rescue Chain concepts to ICD-11 using FHIR ConceptMap. *Stud Health Technol Inform*. 2025. doi:10.3233/SHTI250808

---

*Last updated: 2026-01-24*
*Status: Documentation phase (Phase 1)*
*Next milestone: ConceptMap development (Q2 2026)*
