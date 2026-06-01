This page describes how this Implementation Guide profiles **AI- and LLM-agent-driven clinical decision support** as a *conformance and governance layer*, without embedding any inference runtime in the IG itself. It complements the [Integrated Walkthrough (M4)](smart-cds-integrated-walkthrough.html) — which shows a concrete worked instance — by enumerating the artifact catalogue and the design discipline that backs it.

<!-- AUTHORED-BY-CLAUDE-T1-S47 -->

> **Scope (honest):** Every artifact referenced below is a conformance artifact published by this IG (Profile, Extension, CodeSystem, ValueSet, Instance). The runtime that *executes* AI inference — an LLM serving endpoint, a CQL engine, an agent-orchestration runtime such as MedAgentBench, an embedding store — is **not** part of this IG. The IG provides FHIR shape, governance fields, and conformance contracts; the engines remain external. This is the *adopted-pattern, not embedded-engine* stance documented in [Implementation Scope and Roadmap](implementation-scope-and-roadmap.html) — operational deployment is future work (RS13, post-defense).

### Design discipline (one-sentence summary)

**Deterministic clinical logic stays in CQL Library resources referenced by canonical `urn:cql:library:` URNs and resolved against an external CQL engine; AI/LLM augmentation is expressed as additional structured metadata on FHIR resources (Clinical Impression, Service Request, Task, Audit Event, Risk Assessment) so that any non-deterministic recommendation is auditable, override-able, and EU AI Act-compliant by construction.** The runtime sequence — when there is one — is shown step-by-step in the [Integrated Walkthrough (M4)](smart-cds-integrated-walkthrough.html).

### Artefact catalogue

The IG ships the following conformance artifacts for AI/LLM-agent integration. The catalogue is organised by the FHIR resource family each artifact constrains or extends.

#### AI agent profiles (5)

These StructureDefinitions adapt FHIR base resources to the agent-orchestration pattern (the IG's vocabulary uses *agent* for an LLM acting under human-in-the-loop supervision):

| Profile | Parent | Purpose |
|---------|--------|---------|
| [`AgentServiceRequest`](StructureDefinition-agent-service-request.html) | `ServiceRequest` | Captures agent-initiated clinical recommendations (labs, imaging, referrals, interventions) that still require clinician authorization before execution. |
| [`AgentPlanDefinition`](StructureDefinition-agent-plan-definition.html) | `PlanDefinition` | Encodes the decision logic of an agent service — trigger conditions, prefetch templates, recommended actions — so the rule that produced a Card is itself a publishable, citable artefact. |
| [`AgentTask`](StructureDefinition-agent-task.html) | `Task` | Wraps agent-generated actionable workflow items (e.g., "draft a 12-week lifestyle care plan") in the same FHIR Task semantics human-authored tasks use, enabling unified routing, escalation, and completion tracking. |
| [`AuditEventAIInteraction`](StructureDefinition-audit-event-ai-interaction.html) | `AuditEvent` | Records every AI inference event (request, response, override, retraction) in a shape that satisfies the EU AI Act Article 12 "automatic logging" obligation and ISO 27001-style audit-trail requirements. |
| [`ClinicalImpressionAIAssessment`](StructureDefinition-clinical-impression-ai-assessment.html) | `ClinicalImpression` | The canonical container for the *reasoning artefact* produced by an agent: it holds the summary, confidence, evidence references, the CQL/LLM provenance, and the override status — all in a profile that a clinician can read, sign, modify, or reject. |

Two additional profiles ship under the EU AI Act foundation file ([`EUAIActFoundation.fsh`](https://github.com/RicardoLSantos/shorthand/blob/main/input/fsh/regulatory/EUAIActFoundation.fsh)) and complete the governance footprint:

| Profile | Parent | EU AI Act mapping |
|---------|--------|-------------------|
| [`RiskAssessmentAISystem`](StructureDefinition-risk-assessment-ai-system.html) | `RiskAssessment` | Article 9 — risk management system; documents intended purpose, foreseeable misuse, residual risks, and mitigation per AI system. |
| [`DocumentReferenceAITechnicalDoc`](StructureDefinition-document-reference-ai-technical-doc.html) | `DocumentReference` | Article 11 + Annex IV — technical documentation (system description, data governance, performance metrics, conformity declaration). |

#### Extensions (7)

The agent metadata that *attaches* to standard FHIR resources is carried by these extensions (declared in [`AgentDecisionSupportExtensions.fsh`](https://github.com/RicardoLSantos/shorthand/blob/main/input/fsh/extensions/AgentDecisionSupportExtensions.fsh), [`AIInferenceMetadata.fsh`](https://github.com/RicardoLSantos/shorthand/blob/main/input/fsh/extensions/AIInferenceMetadata.fsh), and [`EUAIActFoundation.fsh`](https://github.com/RicardoLSantos/shorthand/blob/main/input/fsh/regulatory/EUAIActFoundation.fsh)):

- [`AgentRecommendation`](StructureDefinition-agent-recommendation.html) — confidence score, reasoning narrative, evidence references; the "what did the agent say and why?" record on a `ClinicalImpression`.
- [`AgentEvidenceQuality`](StructureDefinition-agent-evidence-quality.html) — completeness assessment (complete / mostly-complete / partial / sparse / insufficient) for the evidence the agent had access to.
- [`AgentActionStatus`](StructureDefinition-agent-action-status.html) — status of an agent-recommended action in clinical workflow (pending / accepted / rejected / modified / completed / expired).
- [`AIInferenceMetadata`](StructureDefinition-ai-inference-metadata.html) — runtime metadata (model identifier, version, latency, classification) for a single inference call.
- [`AIPerformanceMetrics`](StructureDefinition-ai-performance-metrics.html) — accuracy, precision, recall, AUC, calibration metrics per EU AI Act Article 13.
- [`AITrainingDataGovernance`](StructureDefinition-ai-training-data-governance.html) — training-dataset provenance, representativeness, bias assessment per Article 10.
- [`AIRiskAssessmentStatus`](StructureDefinition-ai-risk-assessment-status.html) — status of the AI risk management assessment per Article 9.

#### Terminology (1 CodeSystem + 8 ValueSets)

A single CodeSystem ([`AgentDecisionSupportCS`](CodeSystem-agent-decision-support-cs.html), ~33 codes) covers four orthogonal axes used across the extensions above:

- **Action status** — pending, accepted, rejected, modified, completed, expired
- **Confidence level** — very-high (≥0.9), high (0.75–0.89), moderate (0.5–0.74), low (0.25–0.49), very-low (<0.25)
- **Evidence completeness** — complete, mostly-complete, partial, sparse, insufficient
- **Interpretation category** — high-risk, moderate-risk, low-risk, minimal-risk, escalate-clinician, schedule-followup, continue-monitoring, lifestyle-intervention, medication-review, uncertain, insufficient-data, conflicting-evidence, alert-generated, documentation-needed, patient-education

Eight ValueSets specialise this CodeSystem for each binding site (`agent-confidence-level-vs`, `agent-action-status-vs`, `agent-data-completeness-vs`, `agent-interpretation-vs`, plus four EU AI Act-specific VS for technical document type, performance metric type, training data status, risk assessment status). The taxonomy is intentionally simple: it must be readable by a clinician *during* the consultation, not just by an auditor afterwards.

### Sidecar pattern (how this composes at runtime)

When the artifacts above are deployed, they realise the following pattern. The IG does not specify *which* runtime — that is the design point — but it specifies the conformance shape every runtime must respect.

```
┌──────────────────────────────────────────────────────────────────────────┐
│  EHR / SMART-launched app                                                 │
│                                                                            │
│       │                                                                    │
│       ▼                                                                    │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  CDS Hooks 2.0 service endpoint   ← LifestyleMedicineCDSServicesRegistry│   │
│  │                                                                       │   │
│  │       │                                                               │   │
│  │       ├──► (1) Deterministic path:  CQL engine resolves               │   │
│  │       │       urn:cql:library:CVR-003:v1.2  (registered as Library)   │   │
│  │       │       → returns a numeric risk score (auditable, repeatable)  │   │
│  │       │                                                               │   │
│  │       └──► (2) Augmentation path:    LLM agent receives the score     │   │
│  │               + the prefetch bundle  → produces ClinicalImpressionAI- │   │
│  │               Assessment with AgentRecommendation + AIInferenceMeta-  │   │
│  │               data extensions; emits AuditEventAIInteraction.         │   │
│  │                                                                       │   │
│  │  Card returned to EHR with summary + suggestions + override option.   │   │
│  └────────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────────┘
```

The deterministic CQL path is **primary**: it must succeed standalone, and its output is the *anchored* risk score. The LLM augmentation is **additive**: it produces narrative explanation, evidence integration, and contextualised recommendations *on top of* the CQL score. If the LLM fails, the deterministic path still returns a usable Card. This is the architectural defence against the most common AI failure mode in clinical CDS — opaque silent error — and is the operational reading of the EU AI Act's Article 14 human-oversight requirement.

### CQL Library discipline (urn:cql:library + special-url + external doc-pointer)

The IG ships two thin `Library` resources — [`Library-LibraryCVR003HRVRisk`](Library-LibraryCVR003HRVRisk.html) and [`Library-LibraryMET002MetabolicOverride`](Library-LibraryMET002MetabolicOverride.html) — both with `url = "urn:cql:library:<id>:<version>"` and `type = #logic-library`. They serve **three** roles:

1. They are the canonical FHIR resolution targets for the `ClinicalImpression.protocol[0]` URN references in the worked examples (`urn:cql:library:CVR-003:v1.2` and `urn:cql:library:MET-002:v1.0`).
2. They make the CQL libraries discoverable from the IG's HTML browse, with description + author + license + status — without embedding the executable CQL itself (the CQL coordinate convention treats `urn:cql:library:` as the authoritative identifier across engines).
3. They are documented as *external pointers* — the executable CQL is maintained in the HEADS-ETL repository, outside this IG; the Library resource exists in this IG for resolvability and conformance, not for distribution.

This shape required the `special-url` IG parameter to clear a *URL Mismatch* validation error that SUSHI raises when `Resource.url` does not match the IG-generated canonical (`https://2rdoc.pt/.../Library/LibraryCVR003HRVRisk`). Both URNs are registered under `parameters: special-url:` in [`sushi-config.yaml`](https://github.com/RicardoLSantos/shorthand/blob/main/sushi-config.yaml), alongside the other intentionally-non-IG-canonical endpoints (vendor APIs, Athena, openEHR CKM). The detailed rationale is in [Implementation Scope and Roadmap §CQL Libraries](implementation-scope-and-roadmap.html). The general rule — any conformance resource with a non-namespace canonical (urn:*, http://* external) must be in `special-url` *or* must use the IG-namespace canonical — has been added to the project's pitfall ledger.

### EU AI Act conformance mapping

The artefacts above are organised so that the IG can be *cited as a conformance reference* for an EU AI Act high-risk AI system audit. The mapping is:

| EU AI Act provision | IG artefact(s) |
|---------------------|----------------|
| Article 9 — Risk management system | [`RiskAssessmentAISystem`](StructureDefinition-risk-assessment-ai-system.html), [`AIRiskAssessmentStatus`](StructureDefinition-ai-risk-assessment-status.html) extension |
| Article 10 — Data and data governance | [`AITrainingDataGovernance`](StructureDefinition-ai-training-data-governance.html) extension |
| Article 11 + Annex IV — Technical documentation | [`DocumentReferenceAITechnicalDoc`](StructureDefinition-document-reference-ai-technical-doc.html), `AITechnicalDocumentTypeVS` |
| Article 12 — Automatic logging | [`AuditEventAIInteraction`](StructureDefinition-audit-event-ai-interaction.html) |
| Article 13 — Transparency and information for users | [`AgentRecommendation`](StructureDefinition-agent-recommendation.html) (reasoning narrative + evidence), [`AIInferenceMetadata`](StructureDefinition-ai-inference-metadata.html), [`AIPerformanceMetrics`](StructureDefinition-ai-performance-metrics.html) |
| Article 14 — Human oversight | [`AgentActionStatus`](StructureDefinition-agent-action-status.html) (override status), the [Integrated Walkthrough M4](smart-cds-integrated-walkthrough.html) override path |

The mapping is documented here at the *conformance-shape* level; substantive evidence of compliance (validation runs, real performance metrics, training-data lineage records) is system-implementation work and is out of scope for the IG. The point of the artefacts is that *those records, once produced by an implementer, have a structured FHIR shape to live in*.

### MedAgentBench alignment (forward look)

The AI agent profiles (`AgentServiceRequest`, `AgentPlanDefinition`, `AgentTask`) and the `AgentActionStatus` extension were designed so that agent benchmark suites such as **MedAgentBench** ([Schmidgall et al., 2024](https://github.com/stanfordmlgroup/MedAgentBench), evaluation framework for medical LLM agents) can score agent performance against the same conformance contracts a clinical deployment must meet. The IG does not implement the benchmark, but it provides the artefacts that benchmark-aligned evaluations would emit and consume. This is a deliberate alignment with the academic LLM-agent evaluation community and reflects the same *adopted-pattern* stance as the rest of the IG.

### What this does not do

- It does not bundle, distribute, or version any LLM model file.
- It does not specify an LLM inference API (request/response payloads beyond what FHIR carries).
- It does not specify hardware, latency, or throughput requirements.
- It does not provide a CQL engine, a prompt template, or a fine-tuning recipe.
- It does not provide a model registry — model identity is carried in the `AIInferenceMetadata` extension as opaque text; resolution to a specific model artefact is implementer responsibility (the Hugging Face model card or an internal MLOps registry being typical choices).

All of these are deliberately out of scope and are the substantive content of post-defense work (RS13). The IG's contribution is the **FHIR conformance and governance shape** that any implementation must satisfy to be auditable.

### Artefact index for this page

| Layer | Artefact | Type |
|-------|----------|------|
| Profile | `AgentServiceRequest` | ServiceRequest |
| Profile | `AgentPlanDefinition` | PlanDefinition |
| Profile | `AgentTask` | Task |
| Profile | `AuditEventAIInteraction` | AuditEvent |
| Profile | `ClinicalImpressionAIAssessment` | ClinicalImpression |
| Profile | `RiskAssessmentAISystem` | RiskAssessment |
| Profile | `DocumentReferenceAITechnicalDoc` | DocumentReference |
| Extension | `AgentRecommendation`, `AgentEvidenceQuality`, `AgentActionStatus`, `AIInferenceMetadata`, `AIPerformanceMetrics`, `AITrainingDataGovernance`, `AIRiskAssessmentStatus` | 7 extensions |
| CodeSystem | `AgentDecisionSupportCS` (~33 codes) | local |
| ValueSets | `agent-confidence-level-vs`, `agent-action-status-vs`, `agent-data-completeness-vs`, `agent-interpretation-vs`, `AITechnicalDocumentTypeVS`, `AIPerformanceMetricTypeVS`, `AITrainingDataStatusVS`, `AIRiskAssessmentStatusVS` | 8 ValueSets |
| Library | `LibraryCVR003HRVRisk`, `LibraryMET002MetabolicOverride` (urn:cql:library, special-url) | 2 doc-pointers |

### Related pages

- [Integrated Walkthrough (M4)](smart-cds-integrated-walkthrough.html) — concrete worked instance using these artefacts end-to-end.
- [CDS Hooks Integration](cds-hooks-integration.html) — service catalogue and Card examples.
- [SMART on FHIR Integration](smart-on-fhir-integration.html) — authentication and scope grammar.
- [Implementation Scope and Roadmap](implementation-scope-and-roadmap.html) — what is and is not in scope for this IG.
- [openEHR Integration](openehr-integration.html) — clinical-content authoring side (archetype ↔ FHIR profile correspondence).
- [GDL Integration](gdl-integration.html) — guideline logic authored in openEHR GDL2 and mapped to CDS Hooks.
