// Operational ConceptMap: Body Metrics Custom Codes → LOINC
// Created: 2025-11-22
// Purpose: Enable $translate operations for body composition terminology interoperability
// Status: Maps body composition panel to LOINC codes

Instance: ConceptMapBodyMetricsToLOINC
InstanceOf: ConceptMap
Title: "Body Metrics to LOINC Mapping"
Description: "Maps custom body composition measurement codes to LOINC codes where available. Enables interoperability between consumer body composition scales (Withings, Fitbit Aria, etc.) and clinical systems."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapBodyMetricsToLOINC"
* version = "0.1.0"
* name = "ConceptMapBodyMetricsToLOINC"
* title = "Body Metrics to LOINC Mapping"
* status = #active
* experimental = false
* date = "2025-11-22"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* description = "Operational ConceptMap for body composition measurement terminology translation. Enables runtime $translate operations for semantic interoperability between consumer bioimpedance scales and LOINC standard terminology."
* purpose = "Provides semantic mappings from custom body composition codes to standard LOINC codes. Consumer body composition scales measure metrics like body fat percentage, lean mass, BMI via bioimpedance analysis (BIA)."

// ARCHITECTURE NOTE (2025-11-25):
// Removed sourceCanonical/targetCanonical - source validation via group.source CodeSystem.
// See design-decisions.md for rationale.

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs"
* group[0].target = "http://loinc.org"

// ============================================================================
// BODY COMPOSITION PANEL - VERIFIED 2025-12-08 ✅
// Note: LOINC has no dedicated BIA body composition panel code.
// Using individual measurement codes instead.
// ============================================================================
* group[0].element[0].code = #body-composition-panel
* group[0].element[0].display = "Body composition measurement panel"
* group[0].element[0].target[0].code = #77233-5
* group[0].element[0].target[0].display = "Percentage of body fat by Bioelectrical impedance analysis"
* group[0].element[0].target[0].equivalence = #relatedto
* group[0].element[0].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 77233-5 = Percentage of body fat by Bioelectrical impedance analysis. LOINC has no dedicated BIA panel code. Related individual codes: 73965-6 (Body muscle mass/Body weight Measured), 73708-0 (Body fat [Mass] Calculated)."
