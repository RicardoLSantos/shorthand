# Archived FSH Files

This folder contains FSH files that were intentionally removed from the active Implementation Guide for architectural reasons.

## ValueSetVendorCodes.fsh

**Archived**: 2025-11-27
**Reason**: Architectural decision - Opção B (ConceptMaps only)

### Context

This ValueSet attempted to define vendor proprietary codes (Apple HealthKit, Fitbit, Garmin, Polar, Oura) as a FHIR ValueSet. This caused the following error:

```
Error: The system https://developer.apple.com/documentation/healthkit is not known
```

### Architectural Decision

Per thesis semantic hierarchy (Chapter 5), we chose **Opção B**:

1. **FHIR Profiles bind directly to LOINC/SNOMED-CT** (Semantic Layer - Level 1)
2. **ConceptMaps handle Vendor→LOINC translation** (Translation Layer - Infrastructure)
3. **ValueSets should NOT contain vendor codes** (they are not clinical terminology)

### Thesis Rationale

> "ConceptMaps são para tradução entre sistemas, NÃO para substituir terminologia padrão."

Vendor codes are proprietary identifiers used by device manufacturers, not clinical terminology. They belong in ConceptMaps (translation infrastructure), not in ValueSets (semantic bindings).

### Impact

- **ConceptMapVendorToLOINC.fsh**: Updated to remove `sourceCanonical` reference
- **Profiles**: Continue to bind to LOINC codes directly
- **Warnings**: ~34 warnings reduced (vendor system URIs no longer in ValueSets)

### Restoration

If needed in the future (e.g., if vendors register official CodeSystems with HL7), this file can be restored with appropriate modifications.

---

*Archived by: Claude Code (Terminal 1)*
*Decision date: 2025-11-27*
*Reference: SEMANTIC_STRATEGY_WARNINGS_137_20251127.md*
