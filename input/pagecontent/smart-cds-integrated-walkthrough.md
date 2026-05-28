This page presents an **end-to-end worked walkthrough** that ties together the standards layers profiled elsewhere in this Implementation Guide — SMART on FHIR App Launch, CDS Hooks, the openEHR archetype bridge, the EU AI Act governance profiles, and externally-referenced CQL decision logic — into a single clinical scenario. It corresponds to Module 4 ("SMART + CDS Hooks") of the HL7 FHIR Intermediate curriculum and demonstrates that the conformance artifacts in this IG compose into a coherent decision-support flow.

> **Scope (honest):** Every artifact referenced below is a conformance artifact published by this IG (profile, extension, CodeSystem, Instance, or narrative). The runtime that *executes* this flow — a SMART authorization server, a CDS Hooks service endpoint, a CQL engine, an openEHR CDR — is **not** part of this IG. This is the *adopted-pattern, not embedded-engine* stance documented in [Implementation Scope and Roadmap](implementation-scope-and-roadmap.html); operational deployment is future work (RS13, post-defense). The walkthrough therefore demonstrates **artifact-level integration**, not a running system.

### Clinical scenario

A 54-year-old patient under lifestyle-medicine follow-up wears a consumer device that streams heart-rate-variability (HRV) and a recent laboratory result shows elevated C-reactive protein (CRP). When the clinician opens the patient's chart in a SMART-enabled EHR, a decision-support service evaluates the wearable history and inflammatory markers, raises a cardiovascular-risk Card, and — on acceptance — drafts a structured lifestyle care plan. The flow below shows which IG artifact governs each step.

### Step 1 — SMART App Launch (authentication & authorization)

The clinician's app is launched from the EHR and obtains an access token via OAuth 2.0 + OpenID Connect, as declared by [`CapabilityStatement-LifestyleMedicineSMARTCapabilityStatement`](CapabilityStatement-LifestyleMedicineSMARTCapabilityStatement.html). The `security.service` element advertises `SMART-on-FHIR`, and the standard `oauth-uris` extension exposes the `authorize`/`token`/`register`/`manage` endpoints. Scope grammar (v1 `patient/Observation.read` and v2 `patient/Observation.rs`) and the launch contexts (`launch/patient`, `launch/practitioner`, `launch/encounter`) are described in [SMART on FHIR Integration](smart-on-fhir-integration.html).

### Step 2 — CDS Hooks service discovery

The EHR's CDS client queries the `/cds-services` discovery endpoint. The catalogue of services exposed by this IG is declared in [`Library-LifestyleMedicineCDSServicesRegistry`](Library-LifestyleMedicineCDSServicesRegistry.html), which enumerates the four services (`lifestyle-risk-patient-view`, `lifestyle-counseling-order-sign`, `drug-lifestyle-interaction`, `discharge-lifestyle-plan`) with their hooks, prefetch templates, and descriptions. The discovery contract and four concrete Card examples are in [CDS Hooks Integration](cds-hooks-integration.html).

### Step 3 — `patient-view` hook fires → decision logic

Opening the chart triggers the `patient-view` hook, invoking the `lifestyle-risk-patient-view` service. The decision logic of that service is encoded as [`PlanDefinition-LifestyleRiskAssessmentPlanDefinition`](PlanDefinition-LifestyleRiskAssessmentPlanDefinition.html): it queries recent (30-day) Observations across the eleven lifestyle-medicine domains, computes per-domain risk scores (WHO physical-activity thresholds, AASM sleep guidelines, RMSSD/SDNN trend analysis), and emits up to three Cards. The PlanDefinition's `useContext` pins it to the `patient-view` hook via `CDSHooksHookTypesCS`.

### Step 4 — AI inference produces a ClinicalImpression with CQL provenance

For the risk computation that combines HRV decline with inflammatory elevation, the service delegates to an AI model and records the result as a `ClinicalImpressionAIAssessment`. The worked instance [`Bundle-AIComplianceRoundTripBundle`](Bundle-AIComplianceRoundTripBundle.html) contains `ClinicalImpressionComplianceRT`, which demonstrates the full governance footprint required by the EU AI Act profiles:

- **Decision provenance** — `protocol[0]` references the CQL logic library `urn:cql:library:CVR-003:v1.2`, now registered in this IG as [`Library-LibraryCVR003HRVRisk`](Library-LibraryCVR003HRVRisk.html). The executable CQL is maintained externally (see [Implementation Scope](implementation-scope-and-roadmap.html#cql-libraries-decision-recorded)); the Library resource is a resolvable documentation pointer.
- **Model transparency** — the `agentRecommendation` extension records the model identifier, confidence (0.78), interpretation, and human-readable reasoning; the `inferenceMetadata` extension records latency and risk classification.
- **Auditability** — a companion `AuditEvent` (see [`Bundle-AIComplianceRoundTripBundle`](Bundle-AIComplianceRoundTripBundle.html)) captures the AI interaction for the EU AI Act Article 12 record-keeping obligation.

The summary in the worked example reads: *"SDNN 28 ms (< 40 ms threshold) + CRP 4.8 mg/L (> 3.0 threshold). CQL rule CVR-003 triggered. Moderate cardiovascular risk. Lifestyle intervention recommended."*

### Step 5 — physician decision → CarePlan

On the clinician accepting the Card's suggestion, `CarePlanComplianceRT` is created: a twelve-week structured lifestyle programme (`CarePlanLifestyleMedicine`) targeting stress reduction and an anti-inflammatory dietary pattern. The companion [`Bundle-AIOverrideWorkflowBundle`](Bundle-AIOverrideWorkflowBundle.html) demonstrates the alternative path — physician *override* of the AI recommendation — with the original assessment, the rejected and modified care plans, and an override AuditEvent, satisfying the EU AI Act Article 14 human-oversight requirement.

### Step 6 — openEHR & GDL bridges (authoring-side)

The clinical content modelled above can be authored and governed on the openEHR side: the archetype↔FHIR-profile correspondence is documented in [openEHR Integration](openehr-integration.html), and guideline logic authored in GDL2 maps to the same CDS Hooks services via the IG's ConceptMaps, as described in [GDL Integration](gdl-integration.html). Both are *adopted patterns* — the IG provides the FHIR conformance and mapping artifacts; the openEHR CDR and GDL2 engine are out of scope.

### What this demonstrates

Composed together, the artifacts above wire **SMART App Launch + CDS Hooks 2.0 + PlanDefinition decision logic + AI/CQL governance + openEHR/GDL bridges + multi-jurisdictional consent** into one coherent, worked flow. To the authors' knowledge this is the first published FHIR IG to assemble these layers into a single artifact set with end-to-end worked examples for the lifestyle-medicine vertical. The novelty is in the *integration and conformance tooling*, not in any single standard; each layer follows its respective specification, and the executing runtime is deliberately left to implementers (and to the post-defense RS13 work).

#### Artifact index for this walkthrough

| Step | Artifact | Type |
|------|----------|------|
| 1 | `LifestyleMedicineSMARTCapabilityStatement` | CapabilityStatement |
| 2 | `LifestyleMedicineCDSServicesRegistry` | Library (service registry) |
| 3 | `LifestyleRiskAssessmentPlanDefinition` | PlanDefinition |
| 4 | `ClinicalImpressionComplianceRT` (in `AIComplianceRoundTripBundle`) | ClinicalImpression + agentRecommendation |
| 4 | `LibraryCVR003HRVRisk` | Library (CQL pointer) |
| 5 | `CarePlanComplianceRT` (in `AIComplianceRoundTripBundle`) | CarePlan |
| 5 | `AIOverrideWorkflowBundle` | Bundle (override path) |
| 6 | openEHR / GDL bridges | ConceptMaps + narratives |
