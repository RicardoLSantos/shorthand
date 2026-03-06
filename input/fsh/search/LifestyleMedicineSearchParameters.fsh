// ============================================================================
// SearchParameters: iOS Lifestyle Medicine FHIR IG
// ============================================================================
// Date: 2026-03-06
// Purpose: Custom search parameters for lifestyle medicine wearable data
// Enables: domain-specific queries, vendor filtering, AI audit queries
// ============================================================================

// ============================================================================
// Observation domain search — filter by lifestyle medicine domain
// ============================================================================

Instance: ObservationDomain
InstanceOf: SearchParameter
Usage: #definition
Title: "Observation Domain Search"
Description: "Search observations by lifestyle medicine domain using the domain extension value. Enables queries like 'all sleep observations' or 'all HRV observations' across vendor-specific profiles."

* status = #active
* code = #observation-domain
* name = "ObservationDomain"
* base = #Observation
* type = #token
* expression = "Observation.category.coding.where(system = 'http://terminology.hl7.org/CodeSystem/observation-category').code"
* xpathUsage = #normal
* multipleOr = true

// ============================================================================
// Observation device vendor — filter by wearable vendor
// ============================================================================

Instance: ObservationDeviceVendor
InstanceOf: SearchParameter
Usage: #definition
Title: "Observation Device Vendor Search"
Description: "Search observations by source wearable device manufacturer. Enables vendor-specific data retrieval (e.g., all Apple Watch observations, all Fitbit data)."

* status = #active
* code = #observation-device-vendor
* name = "ObservationDeviceVendor"
* base = #Observation
* type = #reference
* expression = "Observation.device"
* xpathUsage = #normal
* target = #Device

// ============================================================================
// Observation value range — search by numeric threshold
// ============================================================================

Instance: ObservationValueRange
InstanceOf: SearchParameter
Usage: #definition
Title: "Observation Value Range Search"
Description: "Search observations by quantitative value. Enables clinical queries such as 'SDNN below 40ms' or 'SpO2 below 90%' for risk stratification."

* status = #active
* code = #observation-value-range
* name = "ObservationValueRange"
* base = #Observation
* type = #quantity
* expression = "Observation.value.as(Quantity)"
* xpathUsage = #normal
* comparator[0] = #eq
* comparator[1] = #gt
* comparator[2] = #lt
* comparator[3] = #ge
* comparator[4] = #le

// ============================================================================
// AuditEvent AI model — search AI audits by model identifier
// ============================================================================

Instance: AuditEventAIModel
InstanceOf: SearchParameter
Usage: #definition
Title: "AuditEvent AI Model Search"
Description: "Search AI audit events by the SLM/LLM model that generated the inference. Supports EU AI Act Art. 12 model traceability requirements."

* status = #active
* code = #audit-ai-model
* name = "AuditEventAIModel"
* base = #AuditEvent
* type = #token
* expression = "AuditEvent.agent.name"
* xpathUsage = #normal

// ============================================================================
// ClinicalImpression AI confidence — search by confidence threshold
// ============================================================================

Instance: ClinicalImpressionAIConfidence
InstanceOf: SearchParameter
Usage: #definition
Title: "ClinicalImpression AI Confidence Search"
Description: "Search AI-generated clinical impressions by confidence score. Enables filtering low-confidence assessments for physician review prioritisation."

* status = #active
* code = #ai-confidence
* name = "ClinicalImpressionAIConfidence"
* base = #ClinicalImpression
* type = #number
* expression = "ClinicalImpression.extension('https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/agent-recommendation').extension('confidence').value.as(decimal)"
* xpathUsage = #normal
* comparator[0] = #gt
* comparator[1] = #lt
* comparator[2] = #ge
* comparator[3] = #le

// ============================================================================
// CarePlan lifestyle category — search care plans by intervention type
// ============================================================================

Instance: CarePlanLifestyleCategory
InstanceOf: SearchParameter
Usage: #definition
Title: "CarePlan Lifestyle Category Search"
Description: "Search lifestyle medicine care plans by intervention category (stress management, exercise, nutrition, sleep hygiene). Enables domain-specific plan retrieval."

* status = #active
* code = #careplan-lifestyle-category
* name = "CarePlanLifestyleCategory"
* base = #CarePlan
* type = #token
* expression = "CarePlan.category"
* xpathUsage = #normal

// ============================================================================
// Consent jurisdiction — search consents by regulatory framework
// ============================================================================

Instance: ConsentJurisdiction
InstanceOf: SearchParameter
Usage: #definition
Title: "Consent Jurisdiction Search"
Description: "Search patient consents by regulatory jurisdiction (GDPR, LGPD, HIPAA). Enables multi-jurisdictional compliance verification."

* status = #active
* code = #consent-jurisdiction
* name = "ConsentJurisdiction"
* base = #Consent
* type = #uri
* expression = "Consent.policy.uri"
* xpathUsage = #normal
