This page documents the alignment between the **HL7 FHIR Intermediate Brasil — 1ª Edição** course (FHIR_INT_EN_2026_03_1, March 2026 cohort) and the conformance artefacts published in this Implementation Guide. The course covers four modules (U01–U04: Implementation Guides; FHIR Clients; FHIR Servers; SMART on FHIR + CDS Hooks). The IG is, in part, a working answer to "what would a complete realisation of the course curriculum look like, applied to a real clinical vertical?".

> **Scope (honest):** This page is a *retrospective alignment* — the IG's design predates the course but its current state, by coincidence and by deliberate adoption of the same standards, satisfies almost all of the course's expected learning outcomes. Where the IG does NOT cover a course item (e.g., U02 client library guide), the gap is named honestly and tracked. The 13 action items referenced below come from an internal report on the course (May 2026), which is not part of this IG.

### Module cross-walk

| Course module | Topic | IG content (links resolve in the IG) | Status |
|---------------|-------|--------------------------------------|--------|
| **U01** | Implementation Guides (Argonaut, US Core, IPS, Patient Discovery) | [`getting-started.md`](getting-started.html), [`conformance.md`](conformance.html), `IPSLifestyleMedicineComposition` profile (IPS Bundle), [`bibliography.md`](bibliography.html) for the relevant IG citations | ✅ COMPREHENSIVE |
| **U02** | FHIR REST clients (`$validate`, `$expand`, `$everything`, search) | CapabilityStatement Server profile (`LifestyleMedicineSMARTCapabilityStatement` advertises the operations); SMART client-side advertised in `smart-on-fhir-integration.md` | ⏳ PARTIAL — operations declared, full client-library walkthrough deferred to S48+ |
| **U03** | FHIR servers (CapabilityStatement, search params, conformance, version pinning) | `LifestyleMedicineSMARTCapabilityStatement`, `PatientDataPipelineCapability`; search params explicitly typed; conformance documented in `conformance.md` and `must-support.md` | ✅ COMPREHENSIVE |
| **U04** | SMART on FHIR + CDS Hooks (scopes, launch, services, Cards) | `smart-on-fhir-integration.md`, `cds-hooks-integration.md`, four declared CDS services + four Card examples in [`Library-LifestyleMedicineCDSServicesRegistry`](Library-LifestyleMedicineCDSServicesRegistry.html), and the end-to-end [Integrated Walkthrough (M4)](smart-cds-integrated-walkthrough.html) | ✅ COMPREHENSIVE |

### Action-item status table (13 items)

An internal report on the course (May 2026) identified thirteen design action items where the course pedagogy could improve or refine the IG. The current state per action item is:

| # | Action item (from § 4) | IG artefact | Status |
|---|------------------------|-------------|--------|
| 4.1 | SMART scopes mapping for our profiles | [`smart-on-fhir-integration.md`](smart-on-fhir-integration.html) with scope grammar v1+v2 and resource-mapping table | ✅ DONE |
| 4.2 | CDS Hooks service catalog for LMConnect (4 services) | [`Library-LifestyleMedicineCDSServicesRegistry`](Library-LifestyleMedicineCDSServicesRegistry.html); narrative in [`cds-hooks-integration.md`](cds-hooks-integration.html) with four Card examples (`HRVOvertraining`, `SleepDebt`, `Polypharmacy`, `DischargeLifestylePlan`) | ✅ DONE |
| 4.3 | CDS Hooks Card schema strict validation | Validation contract + Card schema in [CDS Clinical Validation](cds-clinical-validation.html) §4 and [`cds-hooks-integration.md`](cds-hooks-integration.html); the `ajv-cli`/`jsonschema` pre-commit check against [cds-hooks.org/schemas/2.0/Card.json](https://cds-hooks.org/schemas/2.0/Card.json) is implemented as a Python `jsonschema` validator (`.github/scripts/validate_cds_cards.py`, `--self-test`) wired into a hard-fail GitHub Actions workflow (`cds-card-validation.yml`) | ✅ DONE (spec + CI, commit f2bff6fe9) |
| 4.4 | CapabilityStatement-LMConnect-Server (typed search params, `$validate-code`, `$expand`, `$everything`, `$lookup`, `$lastn`) | `LifestyleMedicineSMARTCapabilityStatement` + `PatientDataPipelineCapability`; `$lastn` operation explicitly declared | ✅ DONE |
| 4.5 | `LifestyleMedicationRequest` profile | [`StructureDefinition-lifestyle-medication-request`](StructureDefinition-lifestyle-medication-request.html) with `intent`, `status`, `medicationCodeableConcept`, `authoredOn`, drug-lifestyle interaction extension | ✅ DONE |
| 4.6 | IPS Bundle integration (M1 reference) | `IPSLifestyleMedicineComposition` profile already implements the Patient + Observation + MedicationRequest + Condition + Procedure slices the course expected | ✅ NO ACTION NEEDED (pre-existing) |
| 4.7 | Patient Discovery (M1 Carequality demographic match) | Not in IG; would belong to a TEFCA/QHIN integration layer | OUT OF SCOPE |
| 4.8 | Conformance testing — version pinning (LOINC, SNOMED, UCUM) | Version pinning documented in [`conformance.md`](conformance.html) and the [Terminology Verification Protocol](terminology-verification.html) | ✅ DOCUMENTED (TestScripts deferred) |
| 4.9 | ConceptMap drift mitigation (weekly vendor diff) | Drift governance documented in [Vocabularies and Value Sets Catalog](terminology-vocabularies-catalog.html) §7 (scope, check, trigger, rationale) + [Terminology Verification Protocol](terminology-verification.html) §"Database-First protocol" + [ConceptMaps Architecture](conceptmaps.html); the scheduled re-validation is implemented as a Python drift-check (`.github/scripts/conceptmap_drift_check.py`, Database-First local + tx.fhir.org advisory) on a weekly GitHub Actions workflow (`conceptmap-drift.yml`, continue-on-error) | ✅ DONE (spec + CI, commit f2bff6fe9) |
| 4.10 | Multi-file submission discipline | Already followed in this IG's FSH layout (one resource type per file, < 1 MB each); not a published narrative because it is implicit | ✅ FOLLOWED (implicit) |
| 4.11 | SMART app demo (B2B sales) | Out of scope for this IG | OUT OF SCOPE |
| 4.12 | Internal training quizzes | Out of scope for this IG | OUT OF SCOPE |
| 4.13 | Database-First Protocol — empirical validation | Empirically validated during the course (M1 Activity A8 Q8 funduscopy case — `252779009` vs correct `78831002`); discipline encoded in [Terminology Verification Protocol](terminology-verification.html) | ✅ VALIDATED |

**Summary**: of the 13 action items, **10 are satisfied by the IG** — 4.1/4.2/4.4/4.5 ✅ DONE, 4.6 pre-existing, 4.8 documented, 4.10 followed (implicit), 4.13 validated, and 4.3 + 4.9 now ✅ DONE (spec + CI) (the Card-validation contract and the ConceptMap-drift governance are documented in [`cds-clinical-validation.md`](cds-clinical-validation.html) §4 and [`terminology-vocabularies-catalog.md`](terminology-vocabularies-catalog.html) §7; their CI/CD automation — a Python `jsonschema` Card validator and a weekly ConceptMap drift-check, both as GitHub Actions workflows — was implemented in commit f2bff6fe9). The remaining **3 items (4.7 Patient Discovery, 4.11 SMART demo, 4.12 training pack) are out of IG scope.** In-IG-scope coverage is therefore complete; overall 10/13 = 76.9% (the 3 commercial items excluded by design).

### Provenance

The course was taught by Mabi A. Souza and Lucas Adati de Paula (HL7 Brazil). The IG does not redistribute course content.

### Related pages

- [SMART on FHIR Integration](smart-on-fhir-integration.html) — U04 SMART layer realisation.
- [CDS Hooks Integration](cds-hooks-integration.html) — U04 CDS Hooks layer realisation.
- [Integrated Walkthrough (M4)](smart-cds-integrated-walkthrough.html) — end-to-end U04 worked example.
- [Conformance](conformance.html) — U01+U03 conformance contracts.
- [Terminology Verification Protocol](terminology-verification.html) — Database-First Protocol (course 4.13).
- [LLM/AI Integration](llm-ai-integration.html) — additional governance layer beyond the course scope.
- [OMOP Integration](omop-integration.html) — additional bridging layer beyond the course scope.
- [GDL Integration](gdl-integration.html) — additional bridging layer (openEHR GDL ↔ FHIR CDS Hooks).
- [Implementation Scope and Roadmap](implementation-scope-and-roadmap.html) — what is and is not in scope.
