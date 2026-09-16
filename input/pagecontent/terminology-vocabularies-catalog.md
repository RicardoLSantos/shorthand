<!-- AUTHORED-BY-CLAUDE-T1-S48 (Pitfall #97) · IG narrative · pasted at v0.4.1 release (T1 S49) -->

# Vocabularies and Value Sets Catalog

This page is a single-glance **catalog** of the terminology the Implementation Guide adopts, defines, and bridges. It complements — and does not replace — the [Verification Protocol](terminology-verification.html), which documents *how* terminology codes are verified to prevent hallucination; here we document *what* terminology the IG contains and *how it is governed*.

Interoperability in health is, before a technical problem, a **modeling and terminology problem**. Following that principle, this IG (a) **reuses** standard terminologies wherever an authoritative concept exists, (b) **defines** local CodeSystems only where a genuine gap exists, and (c) **bridges** the two with ConceptMaps — explicitly avoiding the "profile/terminology proliferation" that arises when every project re-models the same concepts.

## 1. Standard terminologies adopted (reuse-first)

| Terminology | Used for | Resolution |
|---|---|---|
| **LOINC** | Quantitative observations (HRV SDNN, vital signs, labs, anthropometrics) | [tx.fhir.org](http://tx.fhir.org/) / local Athena `CONCEPT.csv` |
| **SNOMED CT** | Conditions, substances, procedures, qualifiers, body sites | [tx.fhir.org](http://tx.fhir.org/) (International edition) |
| **UCUM** | Units of measure | [tx.fhir.org](http://tx.fhir.org/) |
| **ICD-10 / ICD-11** | Diagnoses (with a transition map, see §4) | tx.fhir.org / WHO |
| **HL7 Terminology (THO)** | Provenance, consent, audit, interpretation, participation-type code systems | base FHIR R4 / HL7 |

The IG verifies every external code against an authoritative source (the **Database-First** discipline, §5) before binding it. This is the discipline that turns "reuse-first" from a slogan into an auditable practice.

## 2. IG-defined CodeSystems (19)

Local CodeSystems are defined **only** where a standard concept is missing or where a vendor/operational vocabulary must be represented. They group into four families:

| Family | CodeSystems | Why local |
|---|---|---|
| **Clinical / decision concepts** | `LifestyleMedicineTemporaryCS`, `AgentDecisionSupportCS`, `DrugLifestyleInteractionCS`, `ICD11LifestyleMedicineCS`, `OpenEHRArchetypesCS`, `OMOPConceptsCS` | provisional codes for advanced metrics with no standard code (see §6); AI/CDS decision taxonomy; drug↔lifestyle interactions; ICD-11 lifestyle fragment; openEHR archetype references; OMOP concept references |
| **Vendor API vocabularies** | `AppleHealthKitCS`, `FitbitAPICS`, `GarminConnectCS`, `OuraAPICS`, `PolarAPICS` | each vendor exposes proprietary metric identifiers that must be represented before they can be mapped to standards |
| **Vendor sleep-stage vocabularies** | `AppleSleepStagesCS`, `FitbitSleepStagesCS`, `GarminSleepStagesCS`, `OuraSleepStagesCS` | vendors use incompatible sleep-stage encodings; explicit CodeSystems make the divergence visible and mappable |
| **SMART / app / ETL infrastructure** | `IOSLifestyleMedicineSMARTScopes`, `AppLogicCS`, `CDSHooksHookTypesCS`, `ETLGroupCharacteristicCS` | SMART scope grammar, application logic, CDS Hooks hook types, ETL cohort-group characteristics |

The complete, machine-generated list (with canonical URLs and concept counts) is in the IG's [artifacts index](artifacts.html).

## 3. Value Sets (204)

The IG defines **205 ValueSets**. Binding strategy:

- **Enumerated ValueSets** (explicit codes) are used wherever the IG must validate against a local CodeSystem during development — because a terminology server cannot expand a CodeSystem it does not yet host. This is the same constraint that drives the `sourceCanonical` choice in ConceptMaps.
- **Intensional ValueSets** (`include codes from system`) are used for standard terminologies (LOINC/SNOMED) where the terminology server can expand them.

The full ValueSet list with bindings is auto-generated in [artifacts.html](artifacts.html); this page documents the *strategy*, not the 205-row enumeration (which would inevitably drift from source).

## 4. ConceptMaps (29) — the bridge layer

ConceptMaps are where reuse becomes concrete: every local or vendor concept is mapped to a standard target. They group by target:

| Target | ConceptMaps |
|---|---|
| **→ LOINC** | HRV, BodyMetrics, Nutrition, Reproductive, Sleep, Social, Vendor |
| **→ SNOMED CT** | PhysicalActivity, Mindfulness, Mobility, Nutrition, Environmental, VendorSleep |
| **→ OMOP CDM** | HRV, Activity, CGM, Nutrition, Sleep, OpenEHR |
| **openEHR ↔ FHIR** | FHIR→openEHR, openEHR→FHIR, Vendor→openEHR |
| **Cross-terminology / other** | ICD-10→ICD-11, AI risk levels, Mindfulness diagnostic mappings |

This mirrors a **four-standard equivalence pattern** (HL7v2 ↔ openEHR ↔ FHIR ↔ OMOP) where the same clinical element is expressed once per target — the explicit cost of which is exactly what a maintained ConceptMap set makes visible and governable (§7).

> ⚠️ **OMOP column discipline.** ConceptMap targets to OMOP carry the OMOP **`concept_id`** (the internal integer primary key), never the source vocabulary **`concept_code`** (e.g. a LOINC `NNNNN-N` string). These are categorically different OMOP CDM fields; confusing them silently attaches a valid code to the wrong concept. Every OMOP target is verified against OHDSI Athena before binding.

## 5. Database-First governance

Large language models have a high error rate on **exact** terminology lookup, so no terminology code is bound on the basis of model output. The governance rule is:

1. Identify the clinical concept.
2. **Search an authoritative database** (Athena `CONCEPT.csv` for LOINC; a SNOMED `CONCEPT.csv` / `tx.fhir.org $lookup` for SNOMED) — not a model.
3. Select the code by its **official description**.
4. Verify **active status** (a code can exist but be inactive/deprecated).
5. A model may only suggest *search terms* or disambiguate *candidates*; it never supplies the code.

This discipline is applied not only to profiles but to **ConceptMap targets and CodeSystem members** — the same surfaces where a wrong-but-valid code is invisible to the FHIR validator (the build passes; the meaning is wrong). The audit findings and remediations are tracked under `VRF-TERM-018`.

## 6. The advanced-metric gap and provisional codes

Several advanced wearable metrics have **no standard code in any terminology** — most prominently HRV time/frequency-domain metrics RMSSD, pNN50, LF power, HF power, and the LF/HF ratio (only SDNN, SDNN-by-EKG and the coefficient-of-variation have LOINC codes). Rather than mis-attach an unrelated code (a silent error) or leave the data uncoded, the IG publishes these as provisional codes in `LifestyleMedicineTemporaryCS`, each with a documented **migration path** to the standard code if and when one is created.

**Name history.** The *Heart Rate Variability CodeSystem* (`HeartRateVariabilityCS`, v0.1.0–v0.2.0) described in Lourenço Santos & Cruz-Correia 2026 (Int J Med Inform 217:106465, [doi:10.1016/j.ijmedinf.2026.106465](https://doi.org/10.1016/j.ijmedinf.2026.106465)) was consolidated into `LifestyleMedicineTemporaryCS` on 2026-02-25 (released in v0.2.1) together with the other lifestyle-medicine gap CodeSystems. Its six codes — `hrv-sdnn`, `hrv-rmssd`, `hrv-pnn50`, `hrv-lf-power`, `hrv-hf-power`, `hrv-lf-hf-ratio` — are unchanged and are exposed through the ValueSet `HeartRateVariabilityVS`; the file that carried the old name declared only that ValueSet from v0.2.1 onwards and was renamed to the current file convention in v0.4.3.

This is the IG's terminology-gap finding made operational: the gap is **named**, the data is **codable today**, and the path to standardization is **explicit** — which is exactly the contribution a vertical IG can make upstream to the standards bodies.

## 7. ConceptMap drift governance (continuous integration)

A ConceptMap is only as trustworthy as its alignment with the *current* releases of its source and target terminologies — and clinical terminologies change continuously. A maintained mapping set therefore needs a **drift control**:

- **Scope.** The 29 ConceptMaps targeting LOINC / SNOMED CT / ICD-11 / OMOP.
- **Check.** A scheduled job re-validates every mapped target code against its authoritative source (Athena / `tx.fhir.org $validate-code`), flagging any target that has become **inactive**, **deprecated**, or whose **display** no longer matches.
- **Trigger.** Run on each new terminology release and on a periodic cadence; a flagged mapping opens a review item, it is never auto-rewritten.
- **Rationale.** This is the terminology analogue of the "maintain the knowledge base apace with changing guidelines" discipline that the CDS literature identifies as the most-neglected part of the lifecycle.

> This section fulfils FHIR-Intermediate-course cross-walk item **4.9 (ConceptMap drift mitigation)**.

## Cross-references
- [Verification Protocol](terminology-verification.html) — how individual codes are verified (Database-First).
- [ConceptMaps](conceptmaps.html) — the architecture of the bridge layer.
- [OMOP Integration](omop-integration.html) — the FHIR↔OMOP mapping and `concept_id` discipline.
- [openEHR Integration](openehr-integration.html) — the FHIR↔openEHR bridge.
- [ICD-11 Integration](icd11-integration.html) — the ICD-10→ICD-11 transition map.

## Sources
This catalog is defensible entirely from the IG's own artifacts (CodeSystems, ValueSets, ConceptMaps) and the public terminology services it references (LOINC, SNOMED International, UCUM, WHO ICD, HL7 Terminology, OHDSI Athena). The reuse-first / no-proliferation framing follows the openEHR–FHIR community position that a clinical data model is best curated once (in a stable model registry) and projected into exchange formats, rather than re-modeled per use case.
