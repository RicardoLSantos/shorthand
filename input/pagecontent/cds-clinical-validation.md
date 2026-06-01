<!-- AUTHORED-BY-CLAUDE-T1-S48 (Pitfall #97) · IG narrative · pasted at v0.4.1 release (T1 S49) -->

# CDS Clinical Validation

The [CDS Hooks Integration](cds-hooks-integration.html) page declares *which* decision-support services this IG exposes; the [Integrated Walkthrough](smart-cds-integrated-walkthrough.html) shows them firing end-to-end. This page answers the prior question that determines whether any of that is safe to deploy: **how is the clinical logic validated against the guideline it claims to encode, and against the patient?**

It is a conformance-and-validation framework, not an execution engine. The runtime decision logic itself (CQL evaluation, model inference) is operated outside the IG (see [Implementation Scope](implementation-scope-and-roadmap.html)); what the IG specifies is the *contract* the logic must satisfy and the *evidence* that must accompany it.

## 1. Two kinds of decision logic — and why the IG separates them

Decision support divides into **knowledge-based** logic (explicit IF-THEN rules / computable guidelines, where the recommendation is traceable to an encoded rule) and **non-knowledge-based** logic (machine learning / statistical pattern recognition, where the recommendation emerges from a model and the reasoning is not directly inspectable). The two carry different validation burdens, and the difference in *explainability* is precisely why this IG keeps them in separate lanes:

- **Deterministic logic is primary.** Guideline rules are encoded as computable artifacts ([`LifestyleRiskAssessmentPlanDefinition`](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html) and the CQL libraries it references). The recommendation is traceable to the rule.
- **AI/model logic is an augmentation sidecar**, governed but never the silent author of a clinical action (see [LLM/AI Integration](llm-ai-integration.html) and `AgentDecisionSupportCS`). A non-inspectable "black box" cannot be the unaccountable origin of a recommendation in a regulated setting.

This separation is what makes the validation framework below tractable: a deterministic rule can be validated against its source guideline; a model can only be validated against held-out outcomes.

## 2. The four-step validation framework

A decision-support intervention is validated in four cumulative steps, each a gate before the next:

| Step | What is validated | Target |
|---|---|---|
| **1 — Technical** | The rule fires on the cases it should and not on those it should not | Positive predictive value **> 90%**, negative predictive value **> 95%** against a labelled test set |
| **2 — Therapeutic (retrospective)** | The recommendation, applied to historical records, would have improved care | retrospective cohort comparison |
| **3 — Pre-implementation (prospective)** | The intervention behaves as intended in a controlled prospective setting before go-live | prospective pilot |
| **4 — Post-implementation (prospective)** | The deployed intervention continues to help — and is not fatiguing or harming users — over time | ongoing monitoring (override rate, outcome trend, alert burden) |

Steps 1–2 can be performed against the IG's example instances and a labelled dataset; Steps 3–4 are operational and are the responsibility of the deploying site. The framework is stated here so that an implementer knows *which evidence to produce*, not because the IG runs the trials.

## 3. From guideline to validated recommendation (CPG-on-FHIR provenance)

A validated recommendation is only as good as its link back to the evidence it encodes. The IG aligns its guideline-derived artifacts with the **FHIR Clinical Guidelines (CPG-on-FHIR)** pattern, in which a recommendation decomposes into:

- a **plan** (PlanDefinition) carrying the recommended action(s) — the role our `LifestyleRiskAssessmentPlanDefinition` plays;
- an **eligibility / population** definition (the patients to whom it applies);
- a **justification** carrying the recommendation's **strength** and the **certainty of the underlying evidence** (a GRADE Evidence-to-Decision rating), so a recommendation is never a bare binary alert but a graded statement;
- **citations** linking to the source guideline and the systematic review beneath it.

Encoding the *justification and certainty*, not just the action, is what lets a CDS Card carry a defensible source — and what lets the loop **evidence → recommendation → real-world outcome → evidence** eventually close (the learning-health-system cycle): recommendations implemented against an EHR generate outcome data that feeds the next evidence update. This IG models the recommendation end of that loop; the [openEHR Integration](openehr-integration.html) and ETL layers model the data end.

## 4. Card conformance — JSON-schema validation in CI

Every CDS Hooks Card this IG's services return must conform to the **CDS Hooks 2.0 Card schema**. Conformance is enforced mechanically, not by review:

- A **pre-commit / CI check** validates each example Card (and each Card template) against the published CDS Hooks 2.0 JSON Schema, using a JSON-schema validator (e.g. `ajv-cli` or Python `jsonschema`).
- The check asserts the required structure: `summary` (≤ 140 chars), `indicator` (`info | warning | critical`), `detail` (markdown), **`source`** (singular — a `{label, url}` object), and well-formed `suggestions[]` / `links[]`.
- A Card that fails the schema fails the build, before it can be published.

This makes "the services return valid Cards" an enforced invariant rather than a documented intention.

> This section fulfils FHIR-Intermediate-course cross-walk item **4.3 (CDS Hooks Card JSON-schema validation)**.

## 5. Alert burden and source-traceability discipline

Validation is not only about correctness; an intervention that is correct but **fatiguing** fails in practice (a large fraction of CDSS alerts are dismissed because too many are inconsequential). The IG's Card contract encodes the mitigations directly:

- **Indicator tiering** — `critical` is reserved for genuinely consequential, life-or-safety contraindications (e.g. a hard drug–lifestyle interaction); routine guidance uses `info`/`warning`. The four declared services in [`CDSHooksServiceDeclaration`](MessageDefinition-LifestyleMedicineCDSHooksDiscovery.html) map their use cases onto this tiering.
- **Source on every Card** — the `source` element gives the clinician a verifiable reference for *why* the recommendation exists, which both builds trust and offers a path to update their knowledge. (The element is singular, `source`, by specification.)
- **Non-disruptive delivery** — supporting detail belongs in the Card's `detail`/`links`, surfaced on demand, not as a modal interruption.

## 6. Drift and ongoing monitoring

A validated rule decays as its terminology, evidence, and guideline change — keeping the knowledge base current is the most-neglected part of the CDS lifecycle, and an unmonitored model can degrade silently as input distributions shift. Step 4 of §2 therefore pairs with two concrete controls:

- **Terminology drift** — the codes a rule depends on are re-validated on each terminology release (see [Vocabularies and Value Sets Catalog §7](terminology-vocabularies-catalog.html)).
- **Performance drift** — for model-based logic, post-deployment monitoring tracks input distribution and output behaviour against the validation baseline, so degradation surfaces as a review item rather than as quiet harm.

## 7. Scope statement

This page specifies a **validation contract and the artifact shapes** that satisfy it (PlanDefinition-based recommendations with graded justification, schema-valid Cards, terminology drift control). The **execution** of decision logic — running CQL, evaluating models, integrating with a live EHR/CDR — is an operational layer documented as future work under RS13 (see [Implementation Scope](implementation-scope-and-roadmap.html)). The IG follows the validation *pattern*; it does not host the *engine*.

## Cross-references
- [CDS Hooks Integration](cds-hooks-integration.html) — the service declarations and Card examples.
- [Integrated Walkthrough (M4)](smart-cds-integrated-walkthrough.html) — SMART launch → CDS Hooks → PlanDefinition → CarePlan.
- [GDL Integration](gdl-integration.html) — the openEHR GDL2 → CDS bridge.
- [LLM/AI Integration](llm-ai-integration.html) — the AI augmentation sidecar and EU AI Act governance.
- [Vocabularies and Value Sets Catalog](terminology-vocabularies-catalog.html) — terminology drift control.

## Sources
This page is defensible from the IG's own artifacts (the CDS Hooks service declaration, the risk-assessment PlanDefinition, the AI decision-support CodeSystem) together with the public specifications it references: [CDS Hooks 2.0](https://cds-hooks.org/), the FHIR Clinical Guidelines (CPG-on-FHIR) implementation guide, and GRADE. The four-step validation framework follows the established clinical-decision-support evaluation literature; no claim here depends on an unpublished or internal source.
