# openEHR Archetypes for Lifestyle Medicine Wearables

This directory contains openEHR archetypes designed for wearable device health data, complementing the FHIR Implementation Guide.

## Directory Structure

```
archetypes/openEHR/
├── adl/                    # ADL 1.4 Archetype files
├── templates/              # Operational templates (.oet)
├── terminology/            # Terminology binding documentation
└── README.md               # This file
```

## Archetypes Included (10 Total)

### CLUSTER Archetypes (5)

| Archetype | Description | Lines | Status |
|-----------|-------------|-------|--------|
| `wearable_device.v0.adl` | Device metadata (vendor, model, firmware) | 364 | CKM Ready |
| `data_quality_indicator.v0.adl` | Signal quality, artifacts, coverage | ~420 | CKM Ready |
| `physiological_context.v0.adl` | Body position, activity, emotional state | ~570 | CKM Ready |
| `recording_context.v0.adl` | Recording duration, sampling, analysis window | ~520 | CKM Ready |
| `vendor_data_provenance.v0.adl` | Data source, export method, transformations | ~490 | CKM Ready |

### OBSERVATION Archetypes (5)

| Archetype | Description | Lines | Status |
|-----------|-------------|-------|--------|
| `heart_rate_variability.v0.adl` | HRV metrics (SDNN, RMSSD, frequency domain) | 781 | CKM Ready |
| `physical_activity_detailed.v0.adl` | Detailed physical activity tracking | 341 | CKM Ready |
| `sleep_architecture.v0.adl` | Sleep stages and quality metrics | 360 | CKM Ready |
| `spo2_wearable.v0.adl` | SpO2, ODI, sleep oximetry | ~700 | CKM Ready |
| `stress_assessment.v0.adl` | Stress scores, EDA, recovery metrics | ~990 | CKM Ready |

## Terminology Bindings

- **LOINC 80404-7**: SDNN (Standard Deviation of NN intervals)
- **LOINC 59408-5**: SpO2 (Oxygen saturation by pulse oximetry)
- **SNOMED CT**: Activity types, sleep stages
- **Custom codes**: RMSSD, pNN50, LF/HF ratio, ODI (pending LOINC submission)

## Vendor Support (11 Platforms)

All archetypes support data from:
- Apple Watch / HealthKit
- Fitbit
- Garmin
- Polar
- Oura Ring
- Samsung Galaxy Watch
- Whoop
- Withings
- Xiaomi
- Amazfit
- Other (extensible)

## Cross-Standard Interoperability

These archetypes are designed to work with:
- **FHIR profiles** in this IG (ConceptMaps available in `input/fsh/terminology/`)
- **OMOP CDM** via MEASUREMENT table mapping

## Synchronization

This content is synchronized with:
- `Thesis_github/knowledge_base/openEHR/archetypes/new/` (documentation repository)

See: `Thesis_github/.claude/skills/code-documentation-locations.md` for sync procedures.

## Validation Status

All 10 archetypes validated with ADL 1.4 structural validator:
- **Errors**: 0
- **Warnings**: 6 (minor, non-blocking)
- **Report**: `Thesis_github/knowledge_base/openEHR/validation/BATCH_1A_VALIDATION_REPORT_20251127.md`

## Related Resources

- [openEHR CKM](https://ckm.openehr.org/) - Clinical Knowledge Manager
- [ADL 1.4 Specification](https://specifications.openehr.org/releases/AM/Release-1.4/)
- [HRV Knowledge Base](../../Thesis_github/knowledge_base/openEHR/hrv_knowledge_base_parts/)

---

*Part of iOS Lifestyle Medicine FHIR IG - HEADS#2 PhD Project*
*Last updated: 2025-11-27*
*Archetypes: 10 (5 CLUSTERs + 5 OBSERVATIONs)*
