# openEHR Archetypes for Lifestyle Medicine Wearables

This directory contains openEHR archetypes designed for wearable device health data, complementing the FHIR Implementation Guide.

## Directory Structure

```
archetypes/openEHR/
├── adl/                    # ADL 2.0 Archetype files
├── templates/              # Operational templates (.oet)
├── terminology/            # Terminology binding documentation
└── README.md               # This file
```

## Archetypes Included

| Archetype | Description | Lines | Status |
|-----------|-------------|-------|--------|
| `heart_rate_variability.v0.adl` | HRV metrics (SDNN, RMSSD, frequency domain) | 781 | Complete |
| `physical_activity_detailed.v0.adl` | Detailed physical activity tracking | 341 | Complete |
| `sleep_architecture.v0.adl` | Sleep stages and quality metrics | 360 | Complete |
| `wearable_device.v0.adl` | CLUSTER for device metadata | 364 | Complete |

## Terminology Bindings

- **LOINC 80404-7**: SDNN (Standard Deviation of NN intervals)
- **SNOMED CT**: Activity types, sleep stages
- **Custom codes**: RMSSD, pNN50, LF/HF ratio (pending LOINC submission)

## Cross-Standard Interoperability

These archetypes are designed to work with:
- **FHIR profiles** in this IG (ConceptMaps available in `input/fsh/terminology/`)
- **OMOP CDM** via MEASUREMENT table mapping

## Synchronization

This content is synchronized with:
- `Thesis_github/knowledge_base/openEHR/` (documentation repository)

See: `Thesis_github/.claude/skills/code-documentation-locations.md` for sync procedures.

## Related Resources

- [openEHR CKM](https://ckm.openehr.org/) - Clinical Knowledge Manager
- [ADL 2.0 Specification](https://specifications.openehr.org/releases/AM/latest)
- [HRV Knowledge Base](../../Thesis_github/knowledge_base/openEHR/hrv_knowledge_base_parts/)

---

*Part of iOS Lifestyle Medicine FHIR IG - HEADS#2 PhD Project*
*Last updated: 2025-11-25*
