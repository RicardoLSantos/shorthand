<!-- AUTHORED-BY-CLAUDE-T1 (Pitfall #97) · IG narrative · pasted at v0.4.1 release (T1 S49) · closes T4 Iozzia deployment handoff -->

### Deployment & Serving

This page describes **how** the artifacts defined in this Implementation Guide (the SMART on FHIR conformance, the CDS Hooks services, the FHIR profiles and terminology) are **deployed and served** in practice. The IG defines *what* is exchanged and *which* conformance applies; this narrative covers the deployment topology, the serving backends, release safety, and post-deployment monitoring. It complements [SMART on FHIR Integration](smart-on-fhir-integration.html), [CDS Hooks Integration](cds-hooks-integration.html), [LLM/AI Integration](llm-ai-integration.html) and [Terminology Verification](terminology-verification.html).

> **Scope.** Operational deployment (running CDS endpoints, SLM backends, ETL orchestration, CDR/terminology servers) is **reference architecture** documented for completeness and for the post-defense RS13 implementation; it is not claimed as a live production deployment of this IG (see [Implementation Scope & Roadmap](implementation-scope-and-roadmap.html)). Conditional language ("when running") is used throughout to preserve that distinction.

#### 1. Serving topology — a stable API over a swappable backend

A clinical decision-support endpoint conforming to this IG follows a layered serving topology drawn from established ML-systems practice (model serving has three strategies: *direct model embedding*, *model service*, and *model server* — the choice is driven by the use case, not a universal best). For a lifestyle-medicine CDS endpoint the recommended pattern is:

```
EHR / SMART app  ──(CDS Hooks 2.0 / FHIR R4)──▶  CDS service endpoint (stable public contract = this IG's CapabilityStatement + CDS Hooks service declaration)
                                                         │
                                                         ▼  adapter / sidecar (FastAPI), OpenAI-compatible API
                                                         │
                                          swappable SLM/inference backend  ──▶  (local: Ollama · llama.cpp · LM Studio/MLX)
                                                                              └▶  (server: vLLM · FastAPI + ONNX-optimised)
```

The **CDS Hooks service** (defined in this IG) is the stable public contract; the **SLM/inference backend is a swappable implementation** behind an adapter. This "integrate without disrupting" pattern — a proxy/sidecar that exposes a uniform serving API while encapsulating the backend's specifics — lets the backend be replaced (local ↔ server, one model ↔ another) without changing the IG-conformant interface the EHR consumes. A standardized serving protocol (the same idea behind KServe's cross-tool inference protocol, and the **OpenAI-compatible API** that local and server SLM runtimes all expose) is what makes the backend swappable.

#### 2. SLM/inference backend landscape (by deployment scenario)

When a deployment chooses to back the CDS service with a small language model (for the LLM-assisted paths described in [LLM/AI Integration](llm-ai-integration.html)), the backend is selected by scenario. All the runtimes below expose an OpenAI-compatible API, so the adapter in §1 is unchanged across them:

| Scenario | Runtime(s) | Hardware |
|---|---|---|
| On-device iOS / iPad | MLC LLM (Metal, q4f16) | iPhone / iPad |
| On-device Android | mllm (INT8 NPU) · MLC LLM (OpenCL) | Android |
| Laptop (Apple Silicon) | llama.cpp (Metal) · **Ollama** (GGUF) · LM Studio (**Apple MLX**) | MacBook M-series |
| Server, single clinician (latency-critical) | **llama.cpp / Ollama** (≈ sub-second TTFT) | CPU / modest GPU |
| Server, hospital multi-user (throughput) | **vLLM** (PagedAttention, OpenAI API) | GPU cluster |

**Latency vs throughput.** A single-clinician, latency-critical CDS call favours a local runtime (llama.cpp/Ollama, sub-second time-to-first-token); a hospital-scale multi-user service favours a throughput-oriented server (vLLM). Document both in any deployment plan.

**Privacy by local execution.** Offline/local execution means clinical data never leaves the device — the compliance argument for on-device deployment, reinforcing the EU AI Act data-minimisation posture described in this IG. **Hardware rule of thumb:** ~8 GB RAM accommodates a 7B/8B model; **GGUF** is the de-facto edge model format; **MLX** is the Apple-native acceleration path.

#### 3. Release safety & rollout

A CDS rule or model version change is rolled out with a **versioned-release** mechanism (a static `STG`/`PROD` tag remapped to the actual version in a registry, so consumers call a stable tag and the swap is imperceptible; rollback = remap the tag back) and one of three traffic strategies:

- **Canary** — route a small fraction of CDS traffic (e.g. a pilot clinician cohort) to the new rule/model; roll back by routing all traffic to the prior version.
- **Blue-green** — cut all traffic to the new version while keeping the old online until confidence is established (simplest; instant rollback).
- **Multi-armed bandit** — continuously shift traffic toward the better-performing version (most complex; for in-production experimentation).

These map directly to the IG's versioning discipline and to the safe-rollout question for any new clinical CDS rule.

#### 4. Post-deployment monitoring (model/rule drift)

A deployed CDS rule or model degrades over time as the clinical population shifts ("drift"), even while the service itself is healthy. Monitoring therefore tracks, at minimum: prediction tracing (a request ID, plus a group ID for chained/composite calls), the model/rule version, the observation (logged input + result + a feedback channel), and quality-gate thresholds. This post-implementation surveillance is the engineering substrate of the post-implementation validation step in the CDS validation framework referenced by this IG (see [CDS Hooks Integration](cds-hooks-integration.html)).

#### 5. ETL orchestration & provenance (data pipeline)

The data feeding the CDS service (wearable/clinical data normalised to FHIR, and onward to analytics stores) is moved by an **orchestrated workflow** — a directed-acyclic-graph of reusable steps (ingest → normalise to FHIR → validate → store), run by a workflow orchestrator (Airflow is the de-facto ETL-pipeline orchestrator; alternatives Argo Workflows, Metaflow). Each run records **lineage/provenance metadata** (what data + which transform version produced each artifact) — the basis for reproducibility and for FHIR `Provenance`. See [Terminology Verification](terminology-verification.html) and the openEHR/OMOP integration narratives for the normalisation + mapping layers.
