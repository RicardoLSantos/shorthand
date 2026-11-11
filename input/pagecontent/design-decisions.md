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

### Update (2026-09-11)
tx.fhir.org serves ICD-11 MMS (release 2026-01). The migration plan above is withdrawn: the republished CodeSystem is retained **by design** so that the IG validates without depending on the availability of a terminology server, and tx.fhir.org and the WHO linearization export are used as verification sources instead. The same design applies to every external code in this IG: each code is recorded in `input/data/terminology-verification-ledger.csv` with the date, source and version of its last verification (see Terminology Verification). On the same date the CodeSystem was rebuilt from the WHO tables after the verification found 11 non-existent codes and 16 wrong titles in the 2026-03 edition, 7 of 34 correct (46 concepts now).

### Evidence
CI GREEN (23 errors, all IPS upstream baseline).

---

## 3. Database-First Terminology Verification Protocol (2026-02-09)

### Decision
All terminology code lookups (LOINC, SNOMED CT, ICD-10, OMOP) must be verified against authoritative databases before use. LLM-suggested codes are never trusted directly.

### Context
Empirical validation during term_bindings work found a 33% error rate in LLM-suggested codes: 3/12 LOINC codes wrong (25%), 3/6 SNOMED codes wrong (50%).

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
The OMOP ConceptMap audit caught 28 errors using this protocol, including 5 hallucinated OMOP concept_ids and 4 false GAPs.

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
All 6 OMOP ConceptMaps (Activity, Sleep, HRV, CGM, Nutrition, OpenEHR). Corrected in the OMOP audit.

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

## 7. IPS as the Exchange Baseline; IPA and the European Patient Summary (2026-11-11)

### Decision
Base the guide's exchange layer on the International Patient Summary (IPS) and do not declare conformance to the International Patient Access (IPA) guide.

### Context
The two HL7 International guides answer different questions. IPA "describes how an application acting on behalf of a patient can access information about the patient from a clinical records system using a FHIR R4 based API" (IPA 1.1.0, STU 1): it is an access specification. IPS defines the content of a summary: "The IPS dataset is minimal and non-exhaustive; specialty-agnostic and condition-independent; but still clinically relevant", and it is designed for "unplanned, cross border care" (IPS 2.0.1, STU 2). This guide defines content (profiles for wearable and lifestyle observations), depends on IPS 2.0.1, and does not depend on IPA.

In Europe, the HL7 Europe Patient Summary (`hl7.fhir.eu.eps` 1.0.0-ballot, STU 1 Ballot 1, draft as of 2026-06-06) "aims conformance with the HL7 FHIR International Patient Summary (IPS) Implementation Guide, version 2.0.0, and with the HL7 FHIR EU Core profiles". IPA 1.1.0 appears in its dependency tree.

The European Health Data Space Regulation (Regulation (EU) 2025/327) names patient summaries as the first priority category of personal electronic health data for primary use (Article 14(1)(a)), to be exchanged in the European electronic health record exchange format; for that category its provisions apply from 26 March 2029 (Article 105, point (a)).

### Options Considered
1. IPS as the exchange baseline (chosen).
2. Declare IPA conformance as well.
3. Depend directly on the HL7 Europe Patient Summary.

### Rationale
- IPS is the content model, and the European specification builds on it: content aligned with IPS stays aligned with the European patient summary.
- IPA is an API-access contract that this guide does not implement; conformance to it belongs to the systems that serve the data.
- The HL7 Europe Patient Summary is a ballot draft, not yet a published standard.

### Evidence
Dependencies in `sushi-config.yaml`; the IPA 1.1.0 and IPS 2.0.1 home pages (hl7.org) and the HL7 Europe Patient Summary home and introduction pages (hl7.eu), read on 2026-11-11.
