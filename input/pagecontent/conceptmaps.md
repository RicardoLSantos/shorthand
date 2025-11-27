# ConceptMaps Architecture

This page documents the ConceptMap architecture used in the iOS Lifestyle Medicine FHIR Implementation Guide, explaining the rationale for cross-standard mappings and expected validator warnings.

## Overview

This Implementation Guide uses ConceptMaps to bridge multiple health information systems:

- **FHIR** (HL7 Fast Healthcare Interoperability Resources)
- **openEHR** (dual-model clinical architecture)
- **OMOP CDM** (Observational Medical Outcomes Partnership Common Data Model)
- **Vendor APIs** (Apple HealthKit, Fitbit, Garmin, Polar, Oura)

## Terminology Concepts: CodeSystem vs ValueSet vs ConceptMap

Understanding the distinction between these FHIR terminology resources is essential for implementing semantic interoperability.

### CodeSystem

A **CodeSystem** is a vocabulary that defines codes and their meanings. It is the authoritative source of terminology.

| Characteristic | Description |
|----------------|-------------|
| **Purpose** | Define codes with meanings |
| **Analogy** | Dictionary |
| **Examples** | LOINC, SNOMED CT, ICD-10 |
| **Ownership** | Maintained by terminology authority |

```
Example: LOINC CodeSystem
┌──────────┬────────────────────────────────────────┐
│ Code     │ Meaning                                │
├──────────┼────────────────────────────────────────┤
│ 8867-4   │ Heart rate                             │
│ 80404-7  │ R-R interval standard deviation (SDNN)│
│ 1988-5   │ C reactive protein [Mass/volume]      │
└──────────┴────────────────────────────────────────┘
```

### ValueSet

A **ValueSet** selects codes from one or more CodeSystems for a specific use case. It defines which codes are valid for a particular element binding.

| Characteristic | Description |
|----------------|-------------|
| **Purpose** | Select codes for a specific purpose |
| **Analogy** | Vocabulary list for an exam |
| **Examples** | InflammatoryMarkerVS, HRVMetricsVS |
| **Composition** | Codes from LOINC, SNOMED CT, etc. |

```
Example: InflammatoryMarkerVS
"LOINC codes used for inflammatory biomarkers"
┌──────────────────────────────────────────────────┐
│ Includes from LOINC:                             │
│   - 1988-5 (CRP)                                 │
│   - 30522-7 (hs-CRP)                             │
│   - 26881-3 (IL-6)                               │
│   - 3074-2 (TNF-α)                               │
└──────────────────────────────────────────────────┘
```

### ConceptMap

A **ConceptMap** translates codes between different systems. It is infrastructure for interoperability, not semantic definition.

| Characteristic | Description |
|----------------|-------------|
| **Purpose** | Translate between code systems |
| **Analogy** | Translation dictionary |
| **Examples** | VendorToLOINC, FHIRToOpenEHR |
| **Role** | Infrastructure, not definition |

```
Example: VendorToLOINC ConceptMap
┌─────────────────────────────┬─────────────────────────┐
│ Source (Vendor)             │ Target (LOINC)          │
├─────────────────────────────┼─────────────────────────┤
│ Apple: HKQuantityType       │ 8867-4                  │
│ IdentifierHeartRate         │ (Heart rate)            │
├─────────────────────────────┼─────────────────────────┤
│ Fitbit: activities-heart    │ 40443-4                 │
│ -restingHeartRate           │ (Heart rate --resting)  │
└─────────────────────────────┴─────────────────────────┘
```

## Semantic Architecture

This Implementation Guide follows a layered semantic architecture:

```
┌─────────────────────────────────────────────────────────────────┐
│  SEMANTIC LAYER (Source of Truth)                               │
│  LOINC + SNOMED-CT                                              │
│  - International standard codes                                 │
│  - 100% semantic preservation                                   │
│  - FHIR Profiles bind directly here                             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PERSISTENCE LAYER                                              │
│  openEHR Archetypes (with term_bindings to SNOMED/LOINC)        │
│  - Clinical models with context                                 │
│  - Two-level modeling                                           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  EXCHANGE LAYER                                                 │
│  FHIR Profiles (with bindings to LOINC/SNOMED)                  │
│  - REST interoperability                                        │
│  - IPS/IPA conformance                                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  TRANSLATION LAYER (Infrastructure)                             │
│  ConceptMaps (FHIR↔openEHR↔OMOP↔Vendor)                         │
│  - Operational mappings                                         │
│  - DO NOT substitute direct bindings                            │
└─────────────────────────────────────────────────────────────────┘
```

## Cross-Standard Mapping Strategy

### Why Warnings Occur

The FHIR validator expects ConceptMap source and target systems to be valid FHIR CodeSystem URIs. However, cross-standard mappings necessarily reference non-FHIR systems:

| System | Example Identifier | Valid FHIR CodeSystem? |
|--------|-------------------|------------------------|
| LOINC | `http://loinc.org` | Yes |
| SNOMED CT | `http://snomed.info/sct` | Yes |
| openEHR | `openEHR-EHR-OBSERVATION.heart_rate` | No (archetype ID) |
| OMOP | `MEASUREMENT` | No (table name) |
| Apple | `HKQuantityTypeIdentifierHeartRate` | No (proprietary) |

### Warning Categories

| Category | Count | Status | Rationale |
|----------|-------|--------|-----------|
| FHIR↔openEHR mappings | ~34 | Expected | Dual-model architecture |
| openEHR↔OMOP mappings | ~35 | Expected | Research data bridge |
| Vendor→LOINC mappings | ~10 | Expected | Ingest infrastructure |
| **Total** | ~79 | **Documented** | Cross-standard by design |

These warnings do NOT indicate errors in semantic preservation. They reflect the architectural reality of bridging heterogeneous health information systems.

## Thesis Justification

This approach aligns with the thesis semantic architecture:

> "The thesis treats ConceptMaps as infrastructure for managed evolution of semantic standards, not as substitutes for real standardization."
> — Chapter 5, Section 5.3

The dual-model architecture (FHIR + openEHR) requires translation infrastructure:

1. **Semantic layer**: LOINC/SNOMED-CT codes in FHIR profiles
2. **Persistence layer**: openEHR archetypes with term_bindings
3. **Translation layer**: ConceptMaps bridging the two

### Semantic Hierarchy

| Level | Method | Preservation | Use Case |
|-------|--------|--------------|----------|
| 1 | **Direct LOINC/SNOMED code** | 100% | Always preferred |
| 2 | SNOMED-CT post-coordination | 95%+ | Complex concepts |
| 3 | Local code + documented source | 85%+ | Unmapped metrics (RMSSD) |
| 4 | Local code + raw data | 70-80% | Proprietary algorithms |
| 5 | ConceptMap without provenance | 40-60% | **Avoid** |

## Architectural Decisions

### Decision 1: Profiles Bind to LOINC Directly

**Correct**:
```fsh
Profile: HeartRateObservation
* code = $LOINC#8867-4 "Heart rate"
```

**Incorrect** (using vendor codes):
```fsh
Profile: HeartRateObservation
* code = AppleHealthKit#HKQuantityTypeIdentifierHeartRate  // Wrong!
```

### Decision 2: Vendor Codes Only in ConceptMaps

Vendor codes (Apple, Fitbit, etc.) are proprietary identifiers, not clinical terminology. They belong in:
- ConceptMaps (for translation during data ingest)

They do NOT belong in:
- ValueSets (not clinical terminology)
- Profile bindings (not standard codes)

### Decision 3: Cross-Standard Warnings Accepted

The ~79 warnings from cross-standard ConceptMaps are accepted and documented because:
- They represent legitimate semantic bridges
- Alternative approaches would compromise interoperability
- The thesis architecture requires multi-standard support

## References

1. HL7 FHIR R4 ConceptMap Resource: [https://hl7.org/fhir/R4/conceptmap.html](https://hl7.org/fhir/R4/conceptmap.html)
2. HL7 FHIR R4 Terminology: [https://hl7.org/fhir/R4/terminologies.html](https://hl7.org/fhir/R4/terminologies.html)
3. openEHR Architecture Overview: [https://specifications.openehr.org/releases/AM/latest](https://specifications.openehr.org/releases/AM/latest)
4. OMOP CDM: [https://ohdsi.github.io/CommonDataModel/](https://ohdsi.github.io/CommonDataModel/)
5. SNOMED on FHIR: [https://confluence.ihtsdotools.org/display/FHIR](https://confluence.ihtsdotools.org/display/FHIR)
6. mCODE Implementation Guide: [https://build.fhir.org/ig/HL7/fhir-mCODE-ig/](https://build.fhir.org/ig/HL7/fhir-mCODE-ig/)

---

*Documentation created: 2025-11-27*
*Reference: Thesis Chapter 5 - Semantic Interoperability Architecture*
