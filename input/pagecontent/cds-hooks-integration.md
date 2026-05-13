# CDS Hooks Integration

This page documents how the iOS Lifestyle Medicine FHIR IG declares **CDS Hooks 2.0** services for clinical decision support integration. A CDS service exposes a deterministic, structured response to a clinical event ("hook"), allowing host EHRs to surface contextual recommendations at the point of decision without changing the host's user interface.

The companion FSH artifact is [CDSHooksServiceDeclaration.fsh](StructureDefinition-LifestyleMedicineCDSHooksDiscovery.html) — a FHIR-side metadata document for the four lifestyle medicine CDS services declared by this IG. The runtime discovery endpoint, however, is HTTP-side (`GET /cds-services` returning JSON per the CDS Hooks 2.0 spec).

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

## Card Examples (illustrative)

These illustrative Card payloads show how each service serializes recommendations per the CDS Hooks 2.0 Card schema. The example values reflect the IG's eleven-domain coverage but are not normative; concrete Card JSON schemas are linked at the end of this page.

### HRVOvertraining Card (from `patient-view`)

A Card summarizing a declining RMSSD trend over the last 14 days, suggesting potential overtraining or sympathetic dominance. The Card includes:

- **Summary**: "RMSSD trending down (mean 28 ms, last 14 days) — consider recovery review"
- **Indicator**: `warning`
- **Source**: declared in the Card's `source` element (singular per CDS Hooks 2.0 Card schema — note the schema field is `source` not `sources`) pointing to the [LifestyleRiskAssessmentPlanDefinition](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html) canonical URL.
- **Suggestion**: launch a SMART app to view full RMSSD trajectory; optionally place a referral order for sleep study if RMSSD decline correlates with sleep fragmentation.
- **Link**: detailed recommendation page in the IG, including reference to [Wasylewicz & Scheepers-Hoeks 2019](https://doi.org/10.1007/978-3-319-99713-1_11) Chapter 11 four-step validation framework.

### SleepDebt Card (from `patient-view`)

A Card summarizing cumulative sleep debt (mean sleep duration below 6 h for ≥ 7 consecutive days):

- **Summary**: "Sleep debt accumulating (mean 5.8 h × 9 days) — review sleep hygiene"
- **Indicator**: `info`
- **Suggestion**: open lifestyle counseling order; link to AASM-aligned sleep hygiene patient handout.
- **Link**: relevant CarePlan template (advanced sleep stage observations are covered by the [advanced_vitalsigns](advanced_vitalsigns.html) page).

### Polypharmacy Card (from `medication-prescribe`)

A Card emitted when the prescribed medication brings the patient's active medication list above five chronic agents, triggering a polypharmacy review per Beers Criteria / STOPP/START guidelines:

- **Summary**: "Polypharmacy threshold reached (6 chronic agents) — consider deprescribing review"
- **Indicator**: `warning`
- **Suggestion**: launch lifestyle medicine deprescribing protocol; link to evidence-based deprescribing toolkit.
- **Source**: an AI-assistance disclosure per [CFM Resolution 2.454/2026](cfm-2454-compliance.html) Art. 4 transparency requirement (the recommendation is generated with AI assistance and the source attribution is mandatory).

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

The FHIR-side metadata for these four services is captured in [LifestyleMedicineCDSHooksDiscovery](StructureDefinition-LifestyleMedicineCDSHooksDiscovery.html) (MessageDefinition) and [LifestyleMedicineCDSServicesRegistry](Library-LifestyleMedicineCDSServicesRegistry.html) (Library). The actual `/cds-services` JSON document is generated at runtime by the reference CDS server, transforming the Library parameters into CDS Hooks JSON.

## Four-Step Validation Framework

CDS service validation should follow the four-stage framework articulated by [Wasylewicz & Scheepers-Hoeks (2019)](https://doi.org/10.1007/978-3-319-99713-1_11), Fundamentals of Clinical Data Science, Chapter 11:

| Step | Stage | Acceptance gate | Suggested metric |
|:---:|-------|-----------------|------------------|
| **1** | Technical validation | PPV > 90%, NPV > 95% on retrospective dataset | per-rule precision and recall |
| **2** | Therapeutic validation (retrospective) | Net clinical benefit demonstrated on chart review | adverse event reduction, intervention adherence |
| **3** | Pre-implementation validation (prospective) | Alert override rate < 90%, alert fatigue trend stable | override rate, time-to-action |
| **4** | Post-implementation validation (prospective, ongoing) | Sustained clinical benefit; no measurable harm | outcome trend, near-miss rate |

The IG recommends that any production deployment of these four services pass Steps 1-2 before pre-implementation pilot, and Step 3 before general availability. Step 4 is continuous and integrates with the audit pipeline (see [AuditEventDataAccess](StructureDefinition-AuditEventDataAccess.html) and AuditEventAIInteraction).

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

- [CDSHooksServiceDeclaration / MessageDefinition](StructureDefinition-LifestyleMedicineCDSHooksDiscovery.html) (FSH-defined)
- [LifestyleRiskAssessmentPlanDefinition](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html) (PlanDefinition logic encoding)
- [LifestyleMedicineCDSServicesRegistry](Library-LifestyleMedicineCDSServicesRegistry.html) (Library)
- [CDSHooksHookTypesCS](CodeSystem-cds-hooks-hook-types.html) (local CodeSystem, 4 hooks)
- [SMART on FHIR Integration](smart-on-fhir-integration.html) (companion narrative)
- [CFM Resolution 2.454/2026 Compliance](cfm-2454-compliance.html) (AI disclosure on cards)
- [Data Protection Policies](data-protection-policies.html) (audit + consent overlay)
- [AuditEventAIInteraction](StructureDefinition-AuditEventAIInteraction.html) (CDS card output auditing)

## Normative References

- [CDS Hooks 2.0](https://cds-hooks.hl7.org/2.0/) — service contract, Card schema, discovery
- [CDS Hooks Card JSON Schema](https://cds-hooks.org/schemas/) (v1.0, v2.0)
- [Wasylewicz ATM, Scheepers-Hoeks AMJW (2019)](https://doi.org/10.1007/978-3-319-99713-1_11). Clinical Decision Support Systems. In: *Fundamentals of Clinical Data Science*, Springer (Open Access, CC BY 4.0).

## Sources

This narrative was authored as a companion to the FSH artifact [CDSHooksServiceDeclaration.fsh](https://github.com/RicardoLSantos/iOS_Lifestyle_Medicine_HEADS2_FMUP/blob/main/input/fsh/capabilities/CDSHooksServiceDeclaration.fsh) committed by T2 S20 (7 May 2026) and confirmed at IG v0.3.0 source HEAD `8333a04c4` (T2 S21, 12 May 2026). Drafted by T1 S34 (13 May 2026). The 4-service catalog (patient-view / order-sign / medication-prescribe / encounter-discharge) reflects the consensus pattern observed in CDS Hooks 2.0 reference implementations and the HL7 FHIR Intermediate Brasil 1ª Edição course (Mabi A. Souza + Lucas A. de Paula, 2026), Unit 4. The four-step validation framework citation (Wasylewicz & Scheepers-Hoeks, 2019) is Level 5 content-verified per T1 S32 graduation (DOI 10.1007/978-3-319-99713-1_11; CC BY 4.0 Open Access, 18 pp full read). Domain-specific thresholds (WHO PA, AASM sleep, RMSSD/SDNN) are operationalised in [LifestyleRiskAssessmentPlanDefinition](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html). The JSON Schema validation discussion is informed by U04-03 course exercise documenting the `sources` vs `source` plural-singular trap (Pitfall #95).
