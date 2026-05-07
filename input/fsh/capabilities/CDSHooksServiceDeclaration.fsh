// ============================================================================
// CDS Hooks Service Declaration
// ============================================================================
// Date: 2026-05-07 (T2 S20 Caminho C — IG v0.3.0 sprint partial)
// Purpose: Declare CDS Hooks 2.0 service definitions for lifestyle medicine
//          decision support integration. Apps can subscribe to clinical events
//          (patient-view, order-sign, medication-prescribe) and receive
//          contextual lifestyle medicine recommendations from this server.
// Reference: https://cds-hooks.hl7.org/2.0/
// Companion: existing AgentPlanDefinitionProfile / AgentServiceRequestProfile
//            already define CDS-style assistance; this declares the
//            HTTP/JSON discovery endpoint for external CDS consumers.
// ============================================================================
// NOTE (T2 S20): FSH written without IG build validation due to local disk
//                constraint. Pending validation: build via _genonce.sh when
//                disk recovery (Pitfall #65, ≥5GB free) achieved.
// ============================================================================

// ============================================================================
// MessageDefinition: CDS Hooks Discovery Document
// ============================================================================
// Note: CDS Hooks 2.0 spec uses HTTP /cds-services endpoint returning JSON,
// not a FHIR resource. This MessageDefinition documents the FHIR-side
// metadata about CDS services advertised by this IG's reference server.
// ============================================================================

Instance: LifestyleMedicineCDSHooksDiscovery
InstanceOf: MessageDefinition
Usage: #definition
Title: "Lifestyle Medicine CDS Hooks Discovery Metadata"
Description: """
FHIR-side metadata documenting the 4 CDS Hooks 2.0 services exposed by
servers conforming to this IG. The actual discovery endpoint is HTTP-side
(/cds-services returning JSON per CDS Hooks spec); this resource captures
service intent + bound profile dependencies for FHIR-tooling discovery.
"""

* status = #active
* date = "2026-05-07"
* publisher = "Ricardo Lourenço dos Santos"
* eventCoding = http://hl7.org/fhir/RestfulInteraction#operation
* category = #notification

// Service 1 — Lifestyle Risk Assessment on Patient View
* useContext[0]
  * code = http://terminology.hl7.org/CodeSystem/usage-context-type#focus
  * valueCodeableConcept = http://hl7.org/fhir/cdshooks#patient-view
  * valueCodeableConcept.text = "patient-view: Lifestyle risk assessment displayed when practitioner opens a patient chart. Returns recommendations based on activity, sleep, nutrition, stress, and substance use observations."

// Service 2 — Order-Sign Lifestyle Counseling
* useContext[1]
  * code = http://terminology.hl7.org/CodeSystem/usage-context-type#focus
  * valueCodeableConcept = http://hl7.org/fhir/cdshooks#order-sign
  * valueCodeableConcept.text = "order-sign: Lifestyle counseling recommendation triggered when a practitioner signs an order, especially medication orders for hypertension/diabetes/depression where lifestyle intervention is first-line. Suggests counseling order entry."

// Service 3 — Medication-Prescribe Drug-Lifestyle Interaction
* useContext[2]
  * code = http://terminology.hl7.org/CodeSystem/usage-context-type#focus
  * valueCodeableConcept = http://hl7.org/fhir/cdshooks#medication-prescribe
  * valueCodeableConcept.text = "medication-prescribe: Drug-lifestyle interaction warning. E.g., MAOI + tyramine-rich diet, SSRIs + alcohol, anticoagulants + Vitamin K rich foods."

// Service 4 — Encounter-Discharge Lifestyle Plan
* useContext[3]
  * code = http://terminology.hl7.org/CodeSystem/usage-context-type#focus
  * valueCodeableConcept = http://hl7.org/fhir/cdshooks#encounter-discharge
  * valueCodeableConcept.text = "encounter-discharge: Discharge lifestyle plan recommendation. Generates personalized lifestyle care plan based on diagnosis + wearable data history."

// ============================================================================
// PlanDefinition: Patient-View Lifestyle Risk Assessment Service Logic
// ============================================================================

Instance: LifestyleRiskAssessmentPlanDefinition
InstanceOf: PlanDefinition
Usage: #definition
Title: "Lifestyle Risk Assessment PlanDefinition (CDS Hooks patient-view)"
Description: """
PlanDefinition encoding the decision logic of the patient-view CDS service.
When invoked with patient context, this plan retrieves recent lifestyle
observations (last 30 days), evaluates against established thresholds,
and emits recommendations as Card outputs per CDS Hooks 2.0 spec.

Cards may include:
 - Activity below WHO recommended (150 min/week MVPA)
 - Sleep duration outside 7-9h adult range
 - HRV trend declining (sympathetic dominance indicator)
 - Nutrition pattern flags (high ultra-processed food intake)
 - Stress score elevated for >14 consecutive days
"""

* status = #active
* experimental = false
* date = "2026-05-07"
* publisher = "Ricardo Lourenço dos Santos"
* description = "Patient-view CDS Hooks service for lifestyle risk assessment based on wearable observation history."
* purpose = "Enable real-time clinical decision support for lifestyle medicine integration in EHR workflows."

* useContext[0]
  * code = http://terminology.hl7.org/CodeSystem/usage-context-type#focus
  * valueCodeableConcept = http://hl7.org/fhir/cdshooks#patient-view

* action[0]
  * title = "Evaluate lifestyle observations"
  * description = "Query recent (30-day) Observation resources matching all 11 lifestyle medicine domains. Aggregate per-domain summary statistics."
  * trigger[0].type = #named-event
  * trigger[0].name = "patient-view"

* action[1]
  * title = "Compute risk scores"
  * description = "Apply domain-specific risk scoring (WHO PA thresholds, AASM sleep guidelines, RMSSD/SDNN trend analysis, ultra-processed food fraction)"

* action[2]
  * title = "Emit CDS cards"
  * description = "For each elevated risk domain, generate a CDS Hooks Card with summary, suggestion, and link to detailed recommendation. Maximum 3 cards per invocation per CDS Hooks 2.0 best practice."

// ============================================================================
// Library: CDS Hooks Service Registry
// ============================================================================

Instance: LifestyleMedicineCDSServicesRegistry
InstanceOf: Library
Usage: #definition
Title: "Lifestyle Medicine CDS Hooks Services Registry"
Description: """
Registry library cataloguing all 4 CDS Hooks services exposed by this IG.
Provides metadata for /cds-services discovery endpoint construction:
 - Service ID
 - Hook name (CDS Hooks 2.0 spec event)
 - Description
 - PrefetchTemplates (FHIR queries the service expects pre-fetched)

Implementing servers should return this library's content (transformed to
CDS Hooks JSON format) at HTTP GET /cds-services.
"""

* status = #active
* experimental = false
* date = "2026-05-07"
* publisher = "Ricardo Lourenço dos Santos"
* type = http://terminology.hl7.org/CodeSystem/library-type#asset-collection

* parameter[0]
  * name = "service-id-1"
  * use = #out
  * type = #string
  * documentation = "lifestyle-risk-patient-view"

* parameter[1]
  * name = "hook-1"
  * use = #out
  * type = #string
  * documentation = "patient-view"

* parameter[2]
  * name = "prefetch-1-observations"
  * use = #out
  * type = #string
  * documentation = "Observation?patient={{context.patientId}}&category=lifestyle&date=ge{{today-30d}}"

* parameter[3]
  * name = "service-id-2"
  * use = #out
  * type = #string
  * documentation = "lifestyle-counseling-order-sign"

* parameter[4]
  * name = "hook-2"
  * use = #out
  * type = #string
  * documentation = "order-sign"

* parameter[5]
  * name = "service-id-3"
  * use = #out
  * type = #string
  * documentation = "drug-lifestyle-interaction-rx"

* parameter[6]
  * name = "hook-3"
  * use = #out
  * type = #string
  * documentation = "medication-prescribe"

* parameter[7]
  * name = "service-id-4"
  * use = #out
  * type = #string
  * documentation = "discharge-lifestyle-plan"

* parameter[8]
  * name = "hook-4"
  * use = #out
  * type = #string
  * documentation = "encounter-discharge"

// ============================================================================
// Implementation note for IG narrative
// ============================================================================
// The actual CDS Hooks discovery endpoint is HTTP-side per CDS Hooks 2.0:
//   GET https://2rdoc.pt/cds-services
//   Response: JSON document listing the 4 services above
//
// Each service endpoint is invoked via HTTP POST:
//   POST https://2rdoc.pt/cds-services/{service-id}
//   Request body: CDS Hooks request JSON with hookInstance + context + prefetch
//   Response: { "cards": [...] }
//
// FHIR resources above (MessageDefinition, PlanDefinition, Library) document
// the FHIR-side metadata; the runtime CDS Hooks server is a separate HTTP/JSON
// implementation per CDS Hooks 2.0 spec.
// ============================================================================
