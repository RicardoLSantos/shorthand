# CDS Hooks Integration

This page documents how the iOS Lifestyle Medicine FHIR IG declares **CDS Hooks 2.0** services for clinical decision support integration. A CDS service exposes a deterministic, structured response to a clinical event ("hook"), allowing host EHRs to surface contextual recommendations at the point of decision without changing the host's user interface.

The companion FSH artifact is [CDSHooksServiceDeclaration.fsh](MessageDefinition-LifestyleMedicineCDSHooksDiscovery.html) — a FHIR-side metadata document for the four lifestyle medicine CDS services declared by this IG. The runtime discovery endpoint, however, is HTTP-side (`GET /cds-services` returning JSON per the CDS Hooks 2.0 spec).

## Overview

CDS Hooks 2.0 ([cds-hooks.hl7.org/2.0/](https://cds-hooks.hl7.org/2.0/)) defines:

1. **Discovery**: `GET <base>/cds-services` returns a JSON document listing all available services.
2. **Invocation**: `POST <base>/cds-services/<service-id>` with a JSON request body containing `hookInstance`, `context`, and `prefetch` triggers service execution.
3. **Response**: services return `{ "cards": [...] }` where each Card is a structured recommendation (summary, suggestion, links).

The iOS Lifestyle Medicine IG declares **four services** mapped to canonical CDS Hooks 2.0 hooks:

| Service ID | Hook | Purpose |
|------------|------|---------|
| `lifestyle-risk-patient-view` | `patient-view` | Lifestyle risk summary on chart open |
| `lifestyle-counseling-order-sign` | `order-sign` | Recommend lifestyle counseling at order entry |
| `drug-lifestyle-interaction-rx` | `medication-prescribe` | Drug-lifestyle interaction warning |
| `discharge-lifestyle-plan` | `encounter-discharge` | Generate discharge lifestyle care plan |

The set of hooks is open per CDS Hooks 2.0; sites MAY introduce additional service identifiers. The IG-local CodeSystem [CDSHooksHookTypesCS](CodeSystem-cds-hooks-hook-types.html) provides FHIR-side stability for these four identifiers without depending on an unpublished canonical CodeSystem.

## Hook Catalog

### Service 1 — `patient-view` (Lifestyle Risk Assessment)

**Trigger**: practitioner opens a patient chart.

**Prefetch query**: `Observation?patient={{context.patientId}}&category=lifestyle&date=ge{{today-30d}}` returns the last 30 days of lifestyle observations across the eleven IG domains (HRV, sleep, physical activity, nutrition, stress, substance use, etc.).

**Service logic**: encoded as [LifestyleRiskAssessmentPlanDefinition](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html). The PlanDefinition has three actions: (a) query recent observations, (b) compute per-domain risk scores against established thresholds (WHO 150 min/week MVPA, AASM 7-9h sleep, RMSSD/SDNN trend analysis, ultra-processed food fraction), and (c) emit at most three Cards per invocation (CDS Hooks 2.0 best practice).

**Latency target**: < 500 ms p95.

### Service 2 — `order-sign` (Lifestyle Counseling Recommendation)

**Trigger**: practitioner signs an order, especially medication orders for hypertension, type 2 diabetes, or depression — conditions for which lifestyle interventions are first-line per current guidelines.

**Service logic**: cross-reference the order being signed against a lifestyle-counseling indication map; if match and patient has no active lifestyle counseling care plan, return a `suggestion` Card proposing a counseling order.

**Cards emitted**: at most one per invocation.

### Service 3 — `medication-prescribe` (Drug-Lifestyle Interaction Warning)

**Trigger**: practitioner is at the medication order entry point (before signing).

**Service logic**: query medication being prescribed against a curated drug-lifestyle interaction matrix. Examples returned as warning Cards:

- **MAOI + tyramine-rich diet**: hypertensive crisis risk
- **SSRI + alcohol**: increased serotonergic load and depression breakthrough
- **Anticoagulants + Vitamin K-rich foods**: INR variability
- **Beta-blockers + intense aerobic exercise**: blunted heart rate response; counsel HR-based intensity recalibration

**Cards emitted**: zero (no interaction) or one warning Card per invocation.

### Service 4 — `encounter-discharge` (Personalized Lifestyle Discharge Plan)

**Trigger**: practitioner closes (discharges) an encounter.

**Service logic**: combine the encounter primary diagnosis with the patient's recent wearable observation history to generate a tailored lifestyle care plan (sleep, physical activity, nutrition, stress management) as a `CarePlan` resource referenced from the Card's `suggestion.actions`.

**Cards emitted**: one comprehensive Card with up to three suggested CarePlan instances (low / moderate / high intervention intensity).

## Card Examples (concrete)

The following are **concrete, copy-pasteable Card payloads** showing how each service serialises recommendations per the CDS Hooks 2.0 Card schema (a service returns `{ "cards": [ ... ] }`). The values are illustrative, not normative. The same payloads are committed as standalone files under `input/includes/cds-hooks-cards/` (`hrv-overtraining.json`, `sleep-debt.json`, `polypharmacy.json`) so reference implementations can validate them against the published Card schema (see [JSON Schema Validation Strategy](#json-schema-validation-strategy)).

> **Terminology integrity note.** RMSSD, pNN50, and LF/HF power have **no LOINC code** (verified against LOINC via the project's Database-First protocol). The HRV Card below references the IG custom code `#hrv-rmssd` from `HeartRateVariabilityCodeSystem` — *not* a fabricated LOINC code. Every clinical code in these examples is database-verified (e.g., SNOMED CT `60554003` Polysomnography — confirmed, **not** `23056005` which is *Sciatica*). This is the same discipline that the [ConceptMaps](conceptmaps.html) follow throughout the IG.

### HRVOvertraining Card (from `patient-view`)

A declining RMSSD trend over the last 14 days, suggesting potential overtraining or sympathetic dominance. Indicator `warning`; the `source` element (singular per CDS Hooks 2.0 — the schema field is `source`, **not** `sources`) points to [LifestyleRiskAssessmentPlanDefinition](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html); the suggestion proposes a polysomnography referral; the validation link references [Wasylewicz & Scheepers-Hoeks 2019](https://doi.org/10.1007/978-3-319-99713-1_11) Chapter 11.

```json
{
  "cards": [
    {
      "uuid": "a1f5c2e0-1b3d-4e8a-9c7f-0d2e6a8b4c10",
      "summary": "RMSSD trending down (mean 28 ms over 14 days) - consider recovery review",
      "indicator": "warning",
      "detail": "Root Mean Square of Successive Differences (RMSSD), the primary parasympathetic HRV marker, has declined for 14 consecutive days (current mean 28 ms vs prior baseline 41 ms). RMSSD has no LOINC code; this observation uses the IG custom code #hrv-rmssd (HeartRateVariabilityCodeSystem), not a fabricated LOINC code.",
      "source": {
        "label": "iOS Lifestyle Medicine - Lifestyle Risk Assessment",
        "url": "https://2rdoc.pt/ig/ios-lifestyle-medicine/PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html",
        "topic": {
          "system": "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cds-hooks-hook-types",
          "code": "patient-view",
          "display": "Lifestyle Risk Assessment"
        }
      },
      "suggestions": [
        {
          "label": "Refer for polysomnography (sleep study)",
          "uuid": "b2e6d3f1-2c4e-4f9b-8a1d-3e5f7b9c2d40",
          "isRecommended": true,
          "actions": [
            {
              "type": "create",
              "description": "Create ServiceRequest for polysomnography to evaluate RMSSD decline correlated with sleep fragmentation",
              "resource": {
                "resourceType": "ServiceRequest",
                "status": "draft",
                "intent": "proposal",
                "code": { "coding": [ { "system": "http://snomed.info/sct", "code": "60554003", "display": "Polysomnography" } ] },
                "subject": { "reference": "Patient/example" }
              }
            }
          ]
        }
      ],
      "selectionBehavior": "any",
      "links": [
        { "label": "View full RMSSD trajectory (SMART app)", "url": "https://2rdoc.pt/ig/ios-lifestyle-medicine/smart-on-fhir-integration.html", "type": "smart" },
        { "label": "Wasylewicz & Scheepers-Hoeks (2019) Ch.11 - CDS validation framework", "url": "https://doi.org/10.1007/978-3-319-99713-1_11", "type": "absolute" }
      ]
    }
  ]
}
```

### SleepDebt Card (from `patient-view`)

Cumulative sleep debt (mean sleep duration below the AASM-recommended 7 h for ≥ 7 consecutive days). Indicator `info`; suggests opening a sleep-hygiene lifestyle counseling CarePlan; links to the AASM-aligned handout (advanced sleep-stage observations are covered by the [advanced_vitalsigns](advanced_vitalsigns.html) page).

```json
{
  "cards": [
    {
      "uuid": "c3a7e4b2-3d5f-4a0c-9b2e-4f6a8c0d3e51",
      "summary": "Sleep debt accumulating (mean 5.8 h over 9 days) - review sleep hygiene",
      "indicator": "info",
      "detail": "Mean nightly sleep duration has stayed below the AASM-recommended 7 hours for 9 consecutive days (current mean 5.8 h). Cumulative sleep restriction is associated with impaired glucose tolerance, elevated inflammatory markers, and reduced HRV.",
      "source": {
        "label": "iOS Lifestyle Medicine - Lifestyle Risk Assessment",
        "url": "https://2rdoc.pt/ig/ios-lifestyle-medicine/PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html",
        "topic": {
          "system": "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cds-hooks-hook-types",
          "code": "patient-view",
          "display": "Lifestyle Risk Assessment"
        }
      },
      "suggestions": [
        {
          "label": "Open lifestyle counseling care plan (sleep hygiene)",
          "uuid": "d4b8f5c3-4e6a-4b1d-8c3f-5a7b9d1e4f62",
          "actions": [
            {
              "type": "create",
              "description": "Create a sleep-hygiene-focused lifestyle counseling CarePlan",
              "resource": {
                "resourceType": "CarePlan",
                "status": "draft",
                "intent": "proposal",
                "category": [ { "text": "Sleep hygiene lifestyle counseling" } ],
                "subject": { "reference": "Patient/example" }
              }
            }
          ]
        }
      ],
      "selectionBehavior": "at-most-one",
      "links": [
        { "label": "AASM-aligned sleep hygiene patient handout", "url": "https://2rdoc.pt/ig/ios-lifestyle-medicine/advanced_vitalsigns.html", "type": "absolute" }
      ]
    }
  ]
}
```

### Polypharmacy Card (from `medication-prescribe`)

Emitted when the prescribed medication brings the patient's active chronic medication list above five agents, triggering a polypharmacy review per Beers Criteria / STOPP-START. Indicator `warning`; the `source.label` carries the **AI-assistance disclosure** per [CFM Resolution 2.454/2026](cfm-2454-compliance.html) Art. 4 transparency requirement.

```json
{
  "cards": [
    {
      "uuid": "e5c9a6d4-5f7b-4c2e-9d4a-6b8c0e2f5a73",
      "summary": "Polypharmacy threshold reached (6 chronic agents) - consider deprescribing review",
      "indicator": "warning",
      "detail": "Signing this prescription brings the active chronic medication count to 6, crossing the polypharmacy threshold (>= 5 chronic agents). Beers Criteria and STOPP/START guidance recommend a structured deprescribing review, with lifestyle interventions as first-line where appropriate. This recommendation is generated with AI assistance; the source attribution below carries the mandatory transparency disclosure.",
      "source": {
        "label": "iOS Lifestyle Medicine - Drug-Lifestyle CDS (AI-assisted; CFM 2.454/2026 Art. 4 disclosure)",
        "url": "https://2rdoc.pt/ig/ios-lifestyle-medicine/cfm-2454-compliance.html",
        "topic": {
          "system": "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cds-hooks-hook-types",
          "code": "medication-prescribe",
          "display": "Drug-Lifestyle Interaction Warning"
        }
      },
      "suggestions": [
        {
          "label": "Launch lifestyle medicine deprescribing protocol",
          "uuid": "f6d0b7e5-6a8c-4d3f-8e5b-7c9d1f3a6b84",
          "actions": [
            {
              "type": "create",
              "description": "Initiate a deprescribing review task (Beers / STOPP-START) with lifestyle-first substitution where indicated",
              "resource": {
                "resourceType": "Task",
                "status": "draft",
                "intent": "proposal",
                "description": "Structured deprescribing review with lifestyle-first substitution where indicated",
                "for": { "reference": "Patient/example" }
              }
            }
          ]
        }
      ],
      "selectionBehavior": "any",
      "links": [
        { "label": "Evidence-based deprescribing toolkit", "url": "https://2rdoc.pt/ig/ios-lifestyle-medicine/cfm-2454-compliance.html", "type": "absolute" },
        { "label": "CFM Resolution 2.454/2026 compliance (AI disclosure requirement)", "url": "https://2rdoc.pt/ig/ios-lifestyle-medicine/cfm-2454-compliance.html", "type": "absolute" }
      ]
    }
  ]
}
```

## Discovery Endpoint Structure

CDS Hooks discovery is HTTP-side and returns a JSON document at `GET <base>/cds-services`. Reference implementations should serve a document of the form:

```json
{
  "services": [
    {
      "hook": "patient-view",
      "title": "Lifestyle Risk Assessment",
      "description": "Returns lifestyle risk recommendations based on last 30 days of observations.",
      "id": "lifestyle-risk-patient-view",
      "prefetch": {
        "observations": "Observation?patient={{context.patientId}}&category=lifestyle&date=ge{{today-30d}}"
      }
    },
    { /* lifestyle-counseling-order-sign */ },
    { /* drug-lifestyle-interaction-rx */ },
    { /* discharge-lifestyle-plan */ }
  ]
}
```

The FHIR-side metadata for these four services is captured in [LifestyleMedicineCDSHooksDiscovery](MessageDefinition-LifestyleMedicineCDSHooksDiscovery.html) (MessageDefinition) and [LifestyleMedicineCDSServicesRegistry](Library-LifestyleMedicineCDSServicesRegistry.html) (Library). The actual `/cds-services` JSON document is generated at runtime by the reference CDS server, transforming the Library parameters into CDS Hooks JSON.

## Four-Step Validation Framework

CDS service validation should follow the four-stage framework articulated by [Wasylewicz & Scheepers-Hoeks (2019)](https://doi.org/10.1007/978-3-319-99713-1_11), Fundamentals of Clinical Data Science, Chapter 11:

| Step | Stage | Acceptance gate | Suggested metric |
|:---:|-------|-----------------|------------------|
| **1** | Technical validation | PPV > 90%, NPV > 95% on retrospective dataset | per-rule precision and recall |
| **2** | Therapeutic validation (retrospective) | Net clinical benefit demonstrated on chart review | adverse event reduction, intervention adherence |
| **3** | Pre-implementation validation (prospective) | Alert override rate < 90%, alert fatigue trend stable | override rate, time-to-action |
| **4** | Post-implementation validation (prospective, ongoing) | Sustained clinical benefit; no measurable harm | outcome trend, near-miss rate |

The IG recommends that any production deployment of these four services pass Steps 1-2 before pre-implementation pilot, and Step 3 before general availability. Step 4 is continuous and integrates with the audit pipeline (see [AuditEventDataAccess](StructureDefinition-audit-event-data-access.html) and AuditEventAIInteraction).

Alert fatigue is a documented failure mode: published override rates for first-generation CDS systems span 49–96 % (Wasylewicz, ibid., synthesising meta-analyses). The validation gates above are tuned to detect and avert that drift before clinical harm.

## JSON Schema Validation Strategy

CDS Hooks Card payloads have published JSON schemas (`Card.json` v1.0 and v2.0 at [cds-hooks.org/schemas/](https://cds-hooks.org/schemas/)). The IG recommends a **pre-commit hook** in CDS service implementations that validates every emitted Card against the appropriate schema before publishing:

```bash
# Example using ajv-cli (Node.js) for Card.json v2.0
ajv validate \
  -s schemas/Card-v2.0.json \
  -d sample-card-output.json \
  --strict=false
```

Equivalent Python implementations may use [`jsonschema`](https://pypi.org/project/jsonschema/). Integration with continuous integration (CI) pipelines provides ongoing assurance that schema-breaking changes are caught before deployment. Reference implementations distributed with the IG include such hooks in their test suites.

This addresses **Pitfall #95** (FHIR schema drift) in a CDS-specific context: a single-character typo such as plural `sources` in place of singular `source` would fail schema validation immediately at commit time rather than at runtime, when an EHR is already consuming the broken Card.

## Cross-References

- [CDSHooksServiceDeclaration / MessageDefinition](MessageDefinition-LifestyleMedicineCDSHooksDiscovery.html) (FSH-defined)
- [LifestyleRiskAssessmentPlanDefinition](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html) (PlanDefinition logic encoding)
- [LifestyleMedicineCDSServicesRegistry](Library-LifestyleMedicineCDSServicesRegistry.html) (Library)
- [CDSHooksHookTypesCS](CodeSystem-cds-hooks-hook-types.html) (local CodeSystem, 4 hooks)
- [SMART on FHIR Integration](smart-on-fhir-integration.html) (companion narrative)
- [CFM Resolution 2.454/2026 Compliance](cfm-2454-compliance.html) (AI disclosure on cards)
- [Data Protection Policies](data-protection-policies.html) (audit + consent overlay)
- [AuditEventAIInteraction](StructureDefinition-audit-event-ai-interaction.html) (CDS card output auditing)

## Normative References

- [CDS Hooks 2.0](https://cds-hooks.hl7.org/2.0/) — service contract, Card schema, discovery
- [CDS Hooks Card JSON Schema](https://cds-hooks.org/schemas/) (v1.0, v2.0)
- [Wasylewicz ATM, Scheepers-Hoeks AMJW (2019)](https://doi.org/10.1007/978-3-319-99713-1_11). Clinical Decision Support Systems. In: *Fundamentals of Clinical Data Science*, Springer (Open Access, CC BY 4.0).

## Sources

This narrative was authored as a companion to the FSH artifact [CDSHooksServiceDeclaration.fsh](https://github.com/RicardoLSantos/iOS_Lifestyle_Medicine_HEADS2_FMUP/blob/main/input/fsh/capabilities/CDSHooksServiceDeclaration.fsh) committed by T2 S20 (7 May 2026) and confirmed at IG v0.3.0 source HEAD `8333a04c4` (T2 S21, 12 May 2026). Drafted by T1 S34 (13 May 2026). The 4-service catalog (patient-view / order-sign / medication-prescribe / encounter-discharge) reflects the consensus pattern observed in CDS Hooks 2.0 reference implementations and the HL7 FHIR Intermediate Brasil 1ª Edição course (Mabi A. Souza + Lucas A. de Paula, 2026), Unit 4. The four-step validation framework citation (Wasylewicz & Scheepers-Hoeks, 2019) is Level 5 content-verified per T1 S32 graduation (DOI 10.1007/978-3-319-99713-1_11; CC BY 4.0 Open Access, 18 pp full read). Domain-specific thresholds (WHO PA, AASM sleep, RMSSD/SDNN) are operationalised in [LifestyleRiskAssessmentPlanDefinition](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html). The JSON Schema validation discussion is informed by U04-03 course exercise documenting the `sources` vs `source` plural-singular trap (Pitfall #95).
