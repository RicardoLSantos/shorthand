# Design Decisions

This page documents key architectural decisions made during the development of the iOS Lifestyle Medicine FHIR IG, including context, alternatives considered, and rationale.

---

## 1. ConceptMap Source Validation Strategy (2025-11-25)

### Decision
Removed `sourceCanonical` from ConceptMaps that map proprietary/local codes to standard terminologies.

### Context
ConceptMaps like `ConceptMapPhysicalActivityToSNOMED` map iOS HealthKit codes (#walking, #running) to SNOMED CT codes. The FHIR validator checks that source codes exist in the `sourceCanonical` ValueSet.

### Problem
The `physical-activity-type-vs` ValueSet contained SNOMED codes for semantic interoperability, but the ConceptMap needed iOS codes as source. This caused 26 validation errors.

### Options Considered
1. **Two ValueSets** - Separate iOS and SNOMED ValueSets
2. **Remove sourceCanonical** - Let ConceptMap validate only by CodeSystem (CHOSEN)
3. **Mixed ValueSet** - Include both iOS and SNOMED codes

### Rationale
- Preserves SNOMED codes in ValueSets for semantic interoperability
- ConceptMap still validates source codes against the CodeSystem (`group.source`)
- Simpler architecture without duplicate ValueSets

### Affected ConceptMaps
ConceptMapPhysicalActivityToSNOMED, ConceptMapEnvironmentalToSNOMED, ConceptMapMindfulnessToSNOMED, ConceptMapMobilityToSNOMED, ConceptMapNutritionToSNOMED

---

## 2. ICD-11 Republication Under IG Namespace — Option B (2026-03-25)

### Decision
Republish 34 ICD-11 MMS codes under the IG namespace (`ICD11LifestyleMedicineCS`) with `content = #complete`, rather than using a `#fragment` CodeSystem with the WHO URL.

### Context
ICD-11 is not available on tx.fhir.org (the FHIR terminology server used by the IG Publisher) as of March 2026. ValueSets referencing ICD-11 codes therefore fail validation.

### Options Considered
1. **Fragment with WHO URL** (`^url = http://id.who.int/icd/release/11/mms`, `content = #fragment`) — IG Publisher cannot associate the WHO URL with the SUSHI-generated canonical, so codes are sent to tx.fhir.org which rejects them. Result: 57 errors.
2. **IG namespace with #complete** (CHOSEN) — Codes published under `https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/icd-11-lifestyle-cs`. SUSHI resolves locally. Result: 0 extra errors.
3. **Accept CI failure** — WHO's own DDCC IG has 1,622 errors for the same reason. Not acceptable for this IG.
4. **Suppress with ignoreWarnings.txt** — Cannot suppress errors, only warnings (HL7 issue #470).

### Rationale
- Option B resolves all 57 validation errors while preserving WHO attribution in Description and copyright
- `special-url` parameter was tested but does not override tx.fhir.org validation behaviour
- Migration plan: when tx.fhir.org adds ICD-11 support, ValueSets will switch to the WHO URL and this CodeSystem will be removed

### Evidence
CI GREEN (23 errors, all IPS upstream baseline). FAQ Q41 documents the full analysis.

---

## 3. Database-First Terminology Verification Protocol (2026-02-09)

### Decision
All terminology code lookups (LOINC, SNOMED CT, ICD-10, OMOP) must be verified against authoritative databases before use. LLM-suggested codes are never trusted directly.

### Context
Empirical validation during term_bindings work found a 33% error rate in LLM-suggested codes: 3/12 LOINC codes wrong (25%), 3/6 SNOMED codes wrong (50%). This confirmed the RS11 systematic review finding that LLMs have near-zero accuracy on exact code lookup.

### Workflow
1. Identify the clinical concept needed
2. Search the authoritative database (Athena CONCEPT.csv for LOINC, Vocab2 for SNOMED)
3. Select code based on the official description from the database
4. LLM role: only suggest search terms or disambiguate candidates

### Authoritative Databases
- **LOINC**: `etl/data/athena/CONCEPT.csv` (278K codes)
- **SNOMED CT**: `knowledge_base/Vocabulario/vocabulary_download_v5_{752480b0...}/CONCEPT.csv` (1.09M codes)
- **Online**: `tx.fhir.org $lookup` for final verification

### Evidence
VRF-TERM-012 documents the empirical validation. The OMOP ConceptMap audit (VRF-TERM-017) caught 28 errors using this protocol, including 5 hallucinated OMOP concept_ids and 4 false GAPs.

---

## 4. OMOP measurement_type_concept_id for Wearable Data (2026-03-20)

### Decision
Use OMOP concept `44818706` ("Patient reported — from device") as `measurement_type_concept_id` for all wearable-derived measurements, not `44818707` ("EHR Detail").

### Context
OMOP CDM distinguishes the provenance of measurements. Wearable data comes from patient-worn devices, not from clinical EHR systems.

### Options Considered
1. **44818707** ("EHR Detail") — implies data was entered by a clinician into an EHR. Wrong for wearable data.
2. **44818706** ("Patient reported — from device") (CHOSEN) — correctly indicates data originated from a patient device.

### Rationale
Accurate provenance metadata is critical for OMOP analytics. Using "EHR Detail" for wearable data would mislead researchers about data quality and source characteristics.

### Affected Files
All 6 OMOP ConceptMaps (Activity, Sleep, HRV, CGM, Nutrition, OpenEHR). Corrected in T2 S8 OMOP audit.

---

## 5. Temporary Codes Architecture — Three-CodeSystem Pattern (2026-02-27)

### Decision
Consolidate 148 domain-specific CodeSystems into three main systems following the HL7 Physical Activity IG "Temporary Codes" pattern:
- `LifestyleMedicineTemporaryCS` (719 codes) — clinical concepts intended for future LOINC/SNOMED CT proposal
- `AppLogicCS` (277 codes) — device metadata, equipment, governance, regulatory
- `AgentDecisionSupportCS` (107 codes) — CDS workflow, AI consent, regulatory events

### Context
Initial development created per-domain CodeSystems (ActivityCS, SleepCS, HRVCS, etc.), reaching 148 CodeSystems. This made maintenance difficult and contradicted HL7 best practices.

### Options Considered
1. **Single CodeSystem** — too large, mixes clinical and operational codes
2. **Per-domain CodeSystems** — original approach, 148 CS, maintenance nightmare
3. **Three-CS separation** (CHOSEN) — clinical vs operational vs AI/CDS distinction

### Rationale
Comparative analysis of 8 published FHIR IGs (PA IG, mCODE, SDOH, IPS, PHD, US Core, CARIN BB, CGM IG) found that successful IGs separate clinical terminology from application logic. The PA IG's "Temporary Codes" pattern explicitly designed for codes awaiting standardization.

### Evidence
91% reduction (148 → 15 CodeSystems including vendor stubs and external governance). Each code includes migration triggers specifying when to adopt standard codes.

---

## 6. LGPD Cross-Jurisdictional Design (2026-03-15)

### Decision
Design LGPD regulatory artifacts as cross-jurisdictional from the start, with shared extensions and ValueSets reusable by GDPR and HIPAA.

### Context
LGPD (Brazil), GDPR (EU), and HIPAA (US) share common concepts: data anonymization, data minimization, consent categories, incident notification. Building separate artifacts for each framework would create duplication and inconsistency.

### Shared Artifacts
- `DataAnonymizationStatus` extension — LGPD Art. 5/12, GDPR Art. 4(5)/Rec.26, HIPAA §164.514
- `DataMinimizationScope` extension — LGPD Art. 6, GDPR Art. 5(1)(c), HIPAA Minimum Necessary
- `DataAnonymizationMethodVS` — k-anonymity, differential privacy, generalization, suppression, safe-harbor

### Rationale
A single cross-jurisdictional artifact set reduces maintenance, ensures consistency, and allows jurisdictional metadata (consent-jurisdiction SearchParameter) to differentiate requirements at query time rather than at artifact level.

### Implementation Order
CFM 2.454 → LGPD → EU AI Act → SBIS → GDPR → HIPAA (~60h total estimated)
