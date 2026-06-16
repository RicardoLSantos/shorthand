# Change Log

All notable changes to this Implementation Guide are documented on this page.

## Version 0.4.3 (2026-06-13) — Current

### Vital Signs — SpO₂ dual-coding + HRV/panel profiles

- **SpO₂ dual-coding (US Core Pulse Oximetry pattern)**: `OxygenSaturationObservation` slices `code` into `O2Sat` (LOINC `2708-6`, the FHIR `oxygensat` method-independent anchor mandated by R4/R5) + `PulseOx` (LOINC `59408-5`, pulse-ox method). Aligns the IG with the most widely implemented FHIR profile (US Core) and HL7 discussion FHIR-31574; `2708-6` is retained in the ValueSet for true arterial blood-gas samples.
- **New profiles**: `SdnnObservation` (HRV-SDNN, LOINC `80404-7`, ms) and `VitalSignsPanel` (LOINC `85353-1`, `hasMember` → HR / BP / SpO₂ / Temp / RR + Body Metrics), with examples.
- **Narrative**: new "SpO₂ Coding — Pulse Oximetry vs Arterial Blood Gas" subsection; four pagecontent pages aligned to the dual-coding.

### Updated Totals (v0.4.3, FSH source)

- **96 Profiles**, **77 Extensions**, **19 CodeSystems**, **204 ValueSets**, **265 Instances** (incl. **29 ConceptMaps**) = **661 artefacts**
- **1,123 custom codes** + **34 ICD-11 codes**
- IG Publisher 2.2.7, EN locale: genonce **0 errors / 0 warnings / 0 broken links**

---

## Version 0.4.2 (2026-06-08)

- **Activity profile device-method binding**: `PhysicalActivityObservation` gains `moderateMinutes` (LOINC `101689-8`) + `vigorousMinutes` (LOINC `101690-6`) component slices (UCUM `min`, Database-First Athena-verified), closing the openEHR↔FHIR↔OMOP round-trip.
- **Terminology**: Amphetamine `SCT#373338002` (inactive since 2014) → active successor `SCT#703842006`; openEHR ConceptMap internal-consistency alignment (F1/F2 — display/comment only, no binding changes).

---

## Version 0.4.1 (2026-06-01)

- **LifestyleMedicationRequest** profile + `DrugLifestyleInteraction` extension — a concrete FHIR resource for the CDS Hooks `drug-lifestyle-interaction` service.
- New narrative pages (GDL2→CDS Hooks bridge, implementation scope/roadmap, integrated SMART+CDS walkthrough) and two CQL Library doc-pointers.
- **VRF-TERM-018**: ~26 wrong-concept SNOMED/LOINC codes corrected (right code-system + valid code + *wrong* concept — invisible to the FHIR validator) via Database-First + tx.fhir.org `$validate-code`.

---

## Version 0.4.0 (2026-05-21)

- **Nutrition OMOP ConceptMap remediation (CN1)**: 11/11 fabricated OMOP `concept_id` mappings corrected via the Database-First Protocol (Athena direct lookup). *Errata*: the immutable v0.3.0 release shipped the pre-remediation map.
- +4 Profiles (incl. `WearableMeasurementProvenance` and `LifestyleMedicineGroupETL` for population/ETL export) + 11 Extensions; IPS upstream baseline (Pitfall #31) eliminated; first fully clean build (0 errors / 0 warnings).

---

## Version 0.3.0 (2026-05-14)

- **SMART on FHIR STU2.2**, **CDS Hooks 2.0** (4-service catalog), **Bulk FHIR Export**, **AuditEvent** profiles, and **Multi-Jurisdictional Consent** (LGPD + GDPR + HIPAA).
- 5 new profiles (`AuditEventDataAccess`, `AuditEventAIInteraction`, `MultiJurisdictionalConsent`, `BulkExportGroup`, `BulkExportConsent`) plus CDS Hooks discovery/registry instances and a SMART CapabilityStatement.

---

## Version 0.2.1 (2026-03-25)

### ICD-11 CodeSystem Restored (Option B)

- **ICD-11 CS republished under IG namespace**: The ICD-11 CodeSystem (34 codes) removed in v0.2.0 was restored because IG Publisher v2.2.1+ treats unknown CodeSystem codes as errors (not warnings). Since tx.fhir.org does not support ICD-11 validation (as of March 2026), codes are republished under the IG namespace (`ICD11LifestyleMedicineCS`) with `content = #complete`. WHO attribution preserved in description and copyright. See [Design Decisions](design-decisions.html) for full rationale.
- **CodeSystem count**: 14 → **15**

### OMOP ConceptMap Audit

- **28 corrections** across 6 ConceptMaps (VRF-TERM-017):
  - 11 hallucinated OMOP concept_ids in OpenEHR ConceptMap
  - 9 corrections in Activity/Sleep/HRV ConceptMaps (5 hallucinated IDs + 4 false GAPs)
  - Sleep quality LOINC corrected: 28323-4 → 95607-8
  - Sleep display mismatches fixed (deep sleep, light sleep)
  - `measurement_type_concept_id`: 44818707 → 44818706 (patient reported device) across all ConceptMaps
- All corrections verified against Athena CONCEPT.csv (Database-First protocol)

### Phase 3 LOINC Substitutions

- **8 new LOINC substitutions** (total: 11 → **19**):
  - 6 CGM codes from CGM IG v1.0.0 family (TBR, TBR-L2, TAR, TAR-L2, CV, Mean Glucose)
  - 1 CGM improved (Sensor Active Time: 97504-5 → 104637-4)
  - 1 Sport code (Activity Type → LOINC 73985-4)
  - 1 Sensor Days (→ LOINC 104636-6)

### LGPD Regulatory Framework (Phases 1-3)

- **Phase 1**: Processing purposes (7 codes), AI consent categories (3 codes), DataAnonymizationStatus extension
- **Phase 2**: OrganizationDataController, PractitionerRoleDPO, TaskDataSubjectRequest profiles
- **Phase 3**: DataMinimizationScope extension, BiasDetectionFlag extension, CommunicationSecurityIncident profile, anonymization methods ValueSet
- 4 LGPD example instances (controller, DPO, data subject request, incident notification)
- Cross-jurisdictional design: DataAnonymizationStatus and DataMinimizationScope shared by LGPD, GDPR, and HIPAA

### AI/CDSS Compliance (3 Levels)

- **Level 1**: 20 AgentCS codes (risk assessment, model metadata, clinician override, audit events) + 3 ValueSets + AIInferenceMetadata extension
- **Level 2**: AuditEventAIInteraction, ClinicalImpressionAIAssessment, CarePlanLifestyleMedicine profiles
- **Level 3**: DeviceDefinitionSLM profile, ConceptMapAIRiskLevels, 2 round-trip compliance Bundles

### Infrastructure

- **CapabilityStatement**: 12 resource types, 32 Observation supportedProfiles
- **7 SearchParameters**: domain, vendor, value-range, AI-model, AI-confidence, careplan-category, consent-jurisdiction
- **CI/CD pipeline**: GitHub Actions (SUSHI validation + IG Publisher build, QA threshold ≤23 errors)
- **License**: CC-BY-4.0

### Updated Totals

- **82 Profiles**, **56 Extensions**, **15 CodeSystems**, **189 ValueSets**, **236 Instances** (incl. 29 ConceptMaps)
- **1,103 custom codes** (719 TemporaryCS + 277 AppLogicCS + 107 AgentCS) + 34 ICD-11
- **19 LOINC substitutions** with documented migration paths
- SUSHI: 0 errors, 0 warnings
- genonce: 23 errors (IPS upstream baseline), ~200 warnings (30 suppressed)

---

## Version 0.2.0 (2026-03-02)

### Terminology Improvements

- **ICD-11 CodeSystem removed** (Phase 6a): Eliminated the 34-code ICD-11 republication in favour of direct WHO URL references. *Note: subsequently restored in v0.2.1 due to IG Publisher v2.2.1+ validation requirements.*
- **6 Sleep LOINC substitutions** (Phase 6b): Replaced 6 custom sleep codes with LOINC equivalents:
  - `sleep-time-bed` → LOINC 103213-5 (Duration in bed)
  - `sleep-deep` → LOINC 93831-6 (Deep sleep duration)
  - `sleep-light` → LOINC 93830-8 (Light sleep duration)
  - `sleep-awakenings` → LOINC 103211-9 (Number of awakenings)
  - `rem-sleep` → LOINC 93829-0 (REM sleep duration)
  - `waso` → LOINC 103215-0 (Wake after sleep onset)
- **ConceptMapSleepToLOINC**: 4 mappings corrected from GAP → EQUIVALENT

### Documentation

- Added Getting Started guide for implementers
- Added Must Support definitions page
- Added Conformance Requirements page
- Added this Change Log

---

## Version 0.1.0 (2025-2026) — Initial Development

### Phase 5: Evidence-Based Remediation (2026-02-27)

- Reduced CodeSystems from 19 → 15 (merged 4 small CS into existing ones)
- Removed 37 unreferenced codes with verified SNOMED/LOINC equivalents
- Reduced `required` bindings from 98 → 57 (required → extensible)
- Replaced bulk `include codes from system` with enumerated codes in 27 ValueSets
- 7 SharedQualifier SNOMED ValueSets adopted in profiles

### Phase 4: CodeSystem Consolidation (2026-02-27)

- Consolidated from 148 CodeSystems to 15
- Separated non-terminology codes into `AppLogicCS` (277 codes) and `AgentDecisionSupportCS` (107 codes)
- Created CDSS ValueSet with 15 LOINC/SNOMED lab + 23 SNOMED intervention codes

### Comparative Audit (2026-02-26)

- Benchmarked against PA IG, mCODE, US Core, SDOH, IPS, PHD, CGM IG v1.0.0
- Identified 244 codes that should use standard terminologies instead of custom codes
- Implemented 38 standard code substitutions

### RS11 Full Audit (2026-02-20)

- 1,173 custom codes audited against ~2.5M embeddings (8 ChromaDB collections)
- 97.4% confirmed as genuine terminology gaps
- 148 LOINC LA/LP part-level matches identified
- 5 LOINC substitutions implemented (CGM family: GMI, TIR, SD, Active Time; Sport: max-hr)

### Core Development (2025-2026)

- 82 profiles across 11 lifestyle medicine domains + regulatory
- 56 extensions for wearable and lifestyle data context
- 29 ConceptMaps for multi-vendor terminology translation
- 189 ValueSets with verified terminology bindings
- 236 example instances with dual-coding
- IPS STU2 integration for cross-border interoperability
- 5 round-trip validation Bundles (Apple HRV, Fitbit Sleep, Garmin Activity, Oura Sleep, Withings BP) + 2 AI/CDSS compliance Bundles
- 4-level terminology verification protocol
