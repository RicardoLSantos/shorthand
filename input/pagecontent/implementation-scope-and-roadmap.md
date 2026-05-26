This page states precisely **what this Implementation Guide (IG) delivers today** versus **what is deferred to operational deployment**, so that claims of "integration" across openEHR, OMOP, CDS Hooks, GDL, SMART and AI/LLM decision support are read at the correct level.

### Artifact-level integration vs operational deployment

This IG is an **artifact-level specification**. It defines, binds and **validates** the resources, profiles, extensions, terminologies and cross-standard maps needed to integrate lifestyle-medicine wearable data across several standards, and it builds clean (IG Publisher: 0 errors). It does **not** assert that any of these integrations is running in production. A specification that *validates* is a different — and appropriate — claim from a system that is *deployed*. Conflating the two would overstate the work; keeping them distinct is what makes the integration claims defensible.

### Delivered now — artifact-level, validated in this IG

| Axis | What the IG ships (validated) |
|---|---|
| **openEHR** | Bidirectional archetype↔FHIR ConceptMaps (`ConceptMapOpenEHRToFHIR`, `ConceptMapFHIRToOpenEHR`, `ConceptMapVendorToOpenEHR`) + design-pattern narrative ([openEHR Integration](openehr-integration.html)) |
| **OMOP CDM** | `concept_id` ConceptMaps for the lifestyle domains (Activity, CGM, HRV, Nutrition, Sleep, openEHR→OMOP), each Database-First verified against OHDSI Athena ([Verification Protocol](terminology-verification.html), [ConceptMaps](conceptmaps.html)) |
| **CDS Hooks** | Service contract + four hook services with Card examples + a concrete `LifestyleMedicationRequest` resource the `medication-prescribe` hook reasons over ([CDS Hooks Integration](cds-hooks-integration.html)) |
| **GDL** | The GDL2→CDS Hooks bridge pattern + scope statement ([GDL Integration](gdl-integration.html)) |
| **SMART on FHIR** | App Launch (STU2.2) conformance + server `CapabilityStatement` with typed search parameters and the `$lastn`/`$export` operations ([SMART on FHIR Integration](smart-on-fhir-integration.html)) |
| **Terminology** | Local CodeSystems + ValueSets + external bindings (LOINC/SNOMED/ICD-11), all Database-First verified; ICD-11 republished as a fragment pending WHO-URL availability on the terminology server |
| **AI / regulatory** | AI decision-support extensions + CodeSystems + EU AI Act compliance profiles (Art. 9/10/11/15) for AI-surfaced recommendations |

### Deferred to operational deployment — out of scope for this IG (RS13, post-defense)

These are **reference-architecture** components. Where the IG mentions them, it uses conditional language ("when deployed…"); none is asserted as currently operational.

| Component | Status | Where it belongs |
|---|---|---|
| Live openEHR CDR (e.g., EHRbase) + archetype↔FHIR round-trip validation in a running repository | Reference architecture; not deployed | openEHR persistence layer (RS13) |
| Running CDS Hooks endpoint (`/cds-services` returning live Cards) | Service contract specified; endpoint not hosted | Deployment (RS13) |
| GDL2 execution engine (native `.gdl` guideline runtime) | Bridge documented; no engine shipped | openEHR side (RS13) |
| OMOP ETL pipeline + populated CDM warehouse + analytics cohorts | ConceptMaps specified; ETL not implemented | Research warehouse (RS13) |
| OCL / hosted terminology server | Prepared, not activated; tx.fhir.org used as fallback | Terminology infrastructure (RS13) |
| LLM agent + RAG terminology service (the Hybrid Model Router) | Extensions/CodeSystems specified to *carry* agent outputs; the router itself is RS11 | RS11 (router) + RS13 (integration) |

### CQL libraries (decision recorded)

The IG's `ClinicalImpression.protocol` elements reference CQL logic via `urn:cql:library:` URIs. These CQL libraries are maintained **externally** (`etl_poc/cql/`) and are **not embedded or executed** by the IG — the IG references them as documentation pointers, consistent with the CDS Hooks execution model. The corresponding build warnings (the unresolved `urn:cql:library:` references) are therefore **expected and accepted**; a decision to either register thin `Library` resources in the IG or suppress the warnings with this justification is taken at the release-preparation phase. This is the same *adopted-pattern-not-embedded-engine* stance used for GDL.

### Roadmap

1. **This IG (current)** — artifact-level integration across the six standards above, validated clean, with explicit scope statements (this page).
2. **RS13 (post-defense)** — operational deployment: CDR + CDS endpoint + OMOP ETL + terminology server, demonstrating the specified integrations end-to-end.

The IG's contribution is the **specified, validated, internally-consistent integration surface**; operational rollout is the natural follow-on, deliberately scoped out of the thesis IG rather than left implicit.
