# Change Log

All notable changes to this Implementation Guide are documented on this page.

## Version 0.2.0 (2026-03-02) — Current

### Terminology Improvements

- **Removed ICD-11 duplicate CodeSystem** (Phase 6a): Eliminated `ICD11LifestyleCodeSystem` that republished 34 ICD-11 codes under a custom URL. All references now use the WHO official URL (`http://id.who.int/icd/release/11/mms`) directly.
- **6 Sleep LOINC substitutions** (Phase 6b): Replaced 6 custom sleep codes with newly discovered LOINC equivalents:
  - `sleep-time-bed` → LOINC 103213-5 (Duration in bed, published 2023-08)
  - `sleep-deep` → LOINC 93831-6 (Deep sleep duration, published 2019-12)
  - `sleep-light` → LOINC 93830-8 (Light sleep duration, published 2019-12)
  - `sleep-awakenings` → LOINC 103211-9 (Number of awakenings, published 2023-08)
  - `rem-sleep` → LOINC 93829-0 (REM sleep duration, published 2019-12)
  - `waso` → LOINC 103215-0 (Wake after sleep onset, published 2023-08)
- **CodeSystem count**: 15 → 14
- **Custom code count**: 725 → 712 (6 superseded + count correction)
- **ConceptMapSleepToLOINC**: 4 mappings corrected from GAP → EQUIVALENT

### Documentation

- Added Getting Started guide for implementers
- Added Must Support definitions page
- Added Conformance Requirements page
- Added this Change Log

### Build Quality

- SUSHI: 0 errors, 4 warnings
- Binding strengths: 30% required, 65% extensible, 5% preferred

## Version 0.1.0 (2025-2026) — Initial Development

### Phase 5: Evidence-Based Remediation (2026-02-27)

- Reduced CodeSystems from 19 → 15 (merged 4 small CS into existing ones)
- Removed 37 unreferenced codes with verified SNOMED/LOINC equivalents
- Reduced `required` bindings from 98 → 57 (Phase 3: required → extensible)
- Replaced bulk `include codes from system` with enumerated codes in 27 ValueSets
- 7 SharedQualifier SNOMED ValueSets adopted in profiles

### Phase 4: CodeSystem Consolidation (2026-02-27)

- Consolidated from 148 CodeSystems to 15
- Separated non-terminology codes into `AppLogicCS` (237 codes) and `AgentDecisionSupportCS` (84 codes)
- Created CDSS ValueSet with 15 LOINC/SNOMED lab + 23 SNOMED intervention codes

### Comparative Audit (2026-02-26)

- Benchmarked against PA IG, mCODE, US Core, SDOH, IPS, PHD
- Identified 244 codes that should use standard terminologies instead of custom codes
- Implemented 38 standard code substitutions

### RS11 Full Audit (2026-02-20)

- 1,173 custom codes audited against 2.4M embeddings (ChromaDB)
- 97.4% confirmed as genuine terminology gaps
- 148 LOINC LA/LP part-level matches identified
- 5 LOINC substitutions implemented (CGM family: GMI, TIR, SD, Active Time; Sport: max-hr)

### Core Development (2025-2026)

- 74 profiles across 11 lifestyle medicine domains
- 50 extensions for wearable and lifestyle data context
- 28 ConceptMaps for multi-vendor terminology translation
- 174 ValueSets with verified terminology bindings
- 188 example instances with dual-coding
- IPS STU2 integration for cross-border interoperability
- Multi-jurisdictional regulatory framework (GDPR, HIPAA, LGPD)
- 4-level terminology verification protocol
