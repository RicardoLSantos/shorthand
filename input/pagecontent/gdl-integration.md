This page documents how guideline decision logic in this Implementation Guide (IG) relates to the openEHR **Guideline Definition Language (GDL2)**, and states explicitly what is, and what is **not**, in scope for the IG.

### Two layers, one decision

Computable clinical guidelines separate two concerns:

1. **Authoring** — expressing a guideline's logic (conditions, rules, recommendations) in a portable, vendor-neutral form. openEHR **GDL2** is a mature standard for this: a GDL2 guideline binds to archetype element paths, evaluates boolean/arithmetic rules over them, and emits structured recommendations.
2. **Execution in a clinical workflow** — invoking that logic at the point of care and returning an actionable recommendation to the prescriber or care team.

This IG implements the **execution** layer with **[CDS Hooks 2.0](https://cds-hooks.org/)** — the FHIR-native, HTTP-stateless standard for surfacing decision support as *Cards* at workflow trigger points (see the [CDS Hooks Integration](cds-hooks-integration.html) page and the `CDSHooksServiceDeclaration`). The IG does **not** ship a GDL2 engine, and does **not** ship native GDL2 guideline artifacts. Instead, it documents the **bridge** between the two layers so that a GDL2-authored guideline can be deployed over this IG's FHIR resources.

### The GDL2 → CDS Hooks bridge

A GDL2 guideline and a CDS Hooks service share the same shape — *data in → rule logic → recommendation out* — differing only in their data model and transport. The bridge rests on correspondences this IG already defines:

| GDL2 (authoring, openEHR) | CDS Hooks 2.0 (execution, FHIR) | Bridge in this IG |
|---|---|---|
| Data binding to archetype element paths | `prefetch` queries returning FHIR resources | openEHR↔FHIR ConceptMaps (`ConceptMapOpenEHRToFHIR`, `ConceptMapFHIRToOpenEHR`) map archetype paths to the IG's Observation/Condition profiles |
| Rule predicates over bound data | Service logic evaluated over prefetched resources | Same predicate, re-expressed over the FHIR profile elements |
| `gt0xxx` recommendation terms (local/bound) | Card `summary` / `detail` / `indicator` + `suggestion` | Recommendation semantics map to a Card; severity maps to `indicator` (info / warning / critical) |
| Guideline metadata (id, version, purpose) | Service discovery entry (`/cds-services`) + optional `PlanDefinition` | `AgentPlanDefinitionProfile` can carry the FHIR-side guideline metadata |
| Bound terminology (SNOMED CT, LOINC, local) | Same terminology, validated against the IG's CodeSystems/ValueSets | Database-First terminology discipline applies on both sides |

Because the data correspondence is already published (the openEHR ConceptMaps) and the recommendation target is already standardised (CDS Hooks Cards), a guideline authored once in GDL2 can be executed over this IG without re-authoring its clinical logic — only the data and recommendation bindings are re-targeted.

### Why CDS Hooks is the IG's execution standard

- **FHIR-native and vendor-neutral**: CDS Hooks is the HL7-aligned way to deliver decision support to any FHIR-capable EHR or app, consistent with the rest of this IG.
- **Stateless and deployable**: an HTTP `/cds-services` endpoint returning Cards requires no openEHR runtime, so the four lifestyle-medicine services (patient-view, order-sign, medication-prescribe, encounter-discharge) are deployable wherever the IG's FHIR profiles are served.
- **Human oversight by design**: Cards are advisory; the prescriber decides. This aligns with CFM 2.454/2026 Art. 7 (physician autonomy) and EU AI Act Art. 14 (human oversight of AI-surfaced recommendations).

### Scope statement (what this IG does and does not assert)

This IG **adopts the GDL2 → CDS Hooks correspondence as a design pattern** and documents it so guideline logic remains portable across the openEHR and FHIR ecosystems. It does **not**:

- ship native GDL2 guideline artifacts (`.gdl` files), nor
- embed or require a GDL2 execution engine (the GDL2 reference engine is an openEHR-side component).

Native GDL2 authoring and an executing engine sit in the **openEHR persistence layer**, which is out of scope for a FHIR IG and is addressed as future work alongside the openEHR CDR integration (see [openEHR Integration](openehr-integration.html)). The IG's contribution is the **published bridge** — the ConceptMaps and the CDS Hooks service contract — that makes GDL2-authored guidelines executable over FHIR. This is an *adopted architectural pattern*, not an *employed tool*: the IG demonstrates the integration path without overclaiming a deployed GDL2 runtime.
