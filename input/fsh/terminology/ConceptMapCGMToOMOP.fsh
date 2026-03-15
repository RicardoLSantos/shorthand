// ConceptMap: CGM LOINC/Custom → OMOP CDM
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
// Purpose: Enable CGM data transformation from FHIR to OMOP CDM
// Context: PhD Thesis - Continuous Glucose Monitoring for lifestyle medicine

Instance: ConceptMapCGMToOMOP
InstanceOf: ConceptMap
Title: "CGM Metrics to OMOP CDM Mapping"
Description: "Maps Continuous Glucose Monitoring metrics from LOINC codes and custom codes to OMOP CDM concept_ids for ETL transformation pipelines. Supports consumer CGM (Dexcom Stelo, Libre) and clinical CGM data."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapCGMToOMOP"
* version = "0.1.0"
* name = "ConceptMapCGMToOMOP"
* title = "CGM Metrics to OMOP CDM Mapping"
* status = #active
* experimental = false
* date = "2025-11-28"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "ricardolourencosantos@gmail.com"
* description = """
Maps Continuous Glucose Monitoring (CGM) metrics to OMOP CDM concepts for federated analytics.

International Consensus on Time in Range (Battelino et al., Diabetes Care 2019):
- TIR (Time in Range 70-180 mg/dL): Target >70% for most patients
- TBR-L1 (54-69 mg/dL): <4% target
- TBR-L2 (<54 mg/dL): <1% target
- TAR-L1 (181-250 mg/dL): <25% target
- TAR-L2 (>250 mg/dL): <5% target
- CV (Coefficient of Variation): <36% indicates stable glycemia

Target OMOP Table: MEASUREMENT
- measurement_concept_id: mapped OMOP concept
- value_as_number: CGM metric value
- unit_concept_id: 8840 (mg/dL) or 8753 (mmol/L)
- measurement_type_concept_id: 44818707 (Patient self-reported/device)

Supported CGM Systems:
- Dexcom G6/G7, Stelo (consumer)
- Abbott Libre 2/3
- Medtronic Guardian
- Consumer metabolic monitors (Levels, January AI)
"""
* purpose = "Enable ETL transformation of CGM data from FHIR to OMOP CDM for participation in OHDSI federated research networks, diabetes registries, and metabolic health research."

// Note: sourceUri/targetUri omitted - group.source and group.target define the code systems

// ============================================================================
// GROUP 1: LOINC CGM Codes → OMOP MEASUREMENT Concepts
// ============================================================================
* group[0].source = "http://loinc.org"
* group[0].target = "http://athena.ohdsi.org/search-terms/terms"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #0
* group[0].unmapped.display = "No OMOP concept - requires custom vocabulary extension"

// ============================================================================
// Glucose (interstitial) - VERIFIED OMOP MAPPING
// LOINC 2345-7 is blood glucose, interstitial glucose uses device-specific
// ============================================================================
* group[0].element[0].code = #2345-7
* group[0].element[0].display = "Glucose [Mass/volume] in Serum or Plasma"
* group[0].element[0].target[0].code = #3004501
* group[0].element[0].target[0].display = "Glucose [Mass/volume] in Serum or Plasma"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = """
VERIFIED OMOP mapping for blood glucose.
- OMOP concept_id: 3004501
- Domain: Measurement
- Use for CGM readings with measurement_type_concept_id = 44818707
- Unit_concept_id: 8840 (mg/dL) or 8753 (mmol/L)
"""

// ============================================================================
// GMI (Glucose Management Indicator) - LOINC available
// CORRECTED 2026-02-24: 97507-8 was "Average glucose in Interstitial fluid", NOT GMI
// CORRECT: 97506-0 = "Glucose management indicator" (Athena concept_id 1617515)
// ============================================================================
* group[0].element[1].code = #97506-0
* group[0].element[1].display = "Glucose management indicator"
* group[0].element[1].target[0].code = #0
* group[0].element[1].target[0].display = "No OMOP concept - requires custom"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = """
GMI (formerly eA1C) estimates HbA1c from CGM data.
Formula: GMI (%) = 3.31 + 0.02392 × [mean glucose in mg/dL]
Clinical significance: Allows real-time A1c estimation without blood draw.
GAP: No OMOP concept exists for GMI.
"""

// ============================================================================
// Mean Glucose
// ============================================================================
* group[0].element[2].code = #41653-7
* group[0].element[2].display = "Glucose [Mass/volume] mean in Serum or Plasma"
* group[0].element[2].target[0].code = #0
* group[0].element[2].target[0].display = "No OMOP concept for mean glucose"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "Mean glucose over CGM recording period. Use measurement_source_value for context."

// ============================================================================
// LOINC CGM Codes (Phase 3 additions, 2026-03-10 — from CGM IG v1.0.0)
// ============================================================================
* group[0].element[3].code = #104641-6
* group[0].element[3].display = "Time below range, low in Reporting Period Interstitial fluid by calculation"
* group[0].element[3].target[0].code = #0
* group[0].element[3].target[0].display = "No OMOP concept available"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "LOINC Phase 3. Target: <4% (<70 mg/dL). Replaces custom #tbr."

* group[0].element[4].code = #104642-4
* group[0].element[4].display = "Time below range, very low in Reporting Period Interstitial fluid by calculation"
* group[0].element[4].target[0].code = #0
* group[0].element[4].target[0].display = "No OMOP concept available"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "LOINC Phase 3. Target: <1% (<54 mg/dL). Replaces custom #tbr-l2."

* group[0].element[5].code = #104640-8
* group[0].element[5].display = "Time above range, high in Reporting Period Interstitial fluid by calculation"
* group[0].element[5].target[0].code = #0
* group[0].element[5].target[0].display = "No OMOP concept available"
* group[0].element[5].target[0].equivalence = #unmatched
* group[0].element[5].target[0].comment = "LOINC Phase 3. Target: <25% (>180 mg/dL). Replaces custom #tar."

* group[0].element[6].code = #104639-0
* group[0].element[6].display = "Time above range, very high in Reporting Period Interstitial fluid by calculation"
* group[0].element[6].target[0].code = #0
* group[0].element[6].target[0].display = "No OMOP concept available"
* group[0].element[6].target[0].equivalence = #unmatched
* group[0].element[6].target[0].comment = "LOINC Phase 3. Target: <5% (>250 mg/dL). Replaces custom #tar-l2."

* group[0].element[7].code = #104638-2
* group[0].element[7].display = "Glucose standard deviation/Glucose mean in Reporting Period Interstitial fluid by calculation"
* group[0].element[7].target[0].code = #0
* group[0].element[7].target[0].display = "No OMOP concept available"
* group[0].element[7].target[0].equivalence = #unmatched
* group[0].element[7].target[0].comment = "LOINC Phase 3. CV target: <36%. Replaces custom #cv."

* group[0].element[8].code = #97507-8
* group[0].element[8].display = "Average glucose [Mass/volume] in Interstitial fluid during Reporting Period"
* group[0].element[8].target[0].code = #0
* group[0].element[8].target[0].display = "No OMOP concept for mean glucose"
* group[0].element[8].target[0].equivalence = #unmatched
* group[0].element[8].target[0].comment = "LOINC Phase 3. Mean glucose over CGM period. Replaces custom #mean."

* group[0].element[9].code = #104637-4
* group[0].element[9].display = "Percentage of time continuous glucose monitor device worn Reporting Period Calculated"
* group[0].element[9].target[0].code = #0
* group[0].element[9].target[0].display = "No OMOP concept available"
* group[0].element[9].target[0].equivalence = #unmatched
* group[0].element[9].target[0].comment = "LOINC Phase 3. Sensor active time %. Replaces custom #cgm-active-time (improved from 97504-5)."

* group[0].element[10].code = #104636-6
* group[0].element[10].display = "Days continuous glucose monitor device worn [#] Reporting Period Estimated"
* group[0].element[10].target[0].code = #0
* group[0].element[10].target[0].display = "No OMOP concept available"
* group[0].element[10].target[0].equivalence = #unmatched
* group[0].element[10].target[0].comment = "LOINC Phase 3. Days since sensor insertion. Replaces custom #sensor-days."

// ============================================================================
// GROUP 2: Custom CGM Metrics → OMOP (remaining Time in Range metrics without LOINC)
// ============================================================================
* group[1].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[1].target = "http://athena.ohdsi.org/search-terms/terms"
* group[1].unmapped.mode = #fixed
* group[1].unmapped.code = #0
* group[1].unmapped.display = "No OMOP concept - International Consensus 2019 metrics not yet in OMOP"

// TIR - Time in Range (70-180 mg/dL) — still custom, no LOINC
* group[1].element[0].code = #tir
* group[1].element[0].display = "Time in Range"
* group[1].element[0].target[0].code = #0
* group[1].element[0].target[0].display = "No OMOP concept available"
* group[1].element[0].target[0].equivalence = #unmatched
* group[1].element[0].target[0].comment = """
CRITICAL GAP: TIR (Time in Range) has NO OMOP concept.
- Target: >70% per International Consensus 2019
- Unit: percentage (%)
- Most important CGM metric for clinical outcomes
Workaround: Store in measurement_source_value = 'TIR:{value}%'
"""

// TBR-L1 - Time Below Range Level 1 (54-69 mg/dL) — still custom, no LOINC for L1 specifically
* group[1].element[1].code = #tbr-l1
* group[1].element[1].display = "Time Below Range Level 1"
* group[1].element[1].target[0].code = #0
* group[1].element[1].target[0].display = "No OMOP concept available"
* group[1].element[1].target[0].equivalence = #unmatched
* group[1].element[1].target[0].comment = "Target: <4% per International Consensus. Hypoglycemia Level 1. Note: LOINC 104641-6 covers total TBR, not L1 specifically."

// Note: #tbr-l2 moved to Group 1 as LOINC 104642-4 (Phase 3, 2026-03-10)

// TAR-L1 - Time Above Range Level 1 (181-250 mg/dL) — still custom, no LOINC for L1 specifically
* group[1].element[2].code = #tar-l1
* group[1].element[2].display = "Time Above Range Level 1"
* group[1].element[2].target[0].code = #0
* group[1].element[2].target[0].display = "No OMOP concept available"
* group[1].element[2].target[0].equivalence = #unmatched
* group[1].element[2].target[0].comment = "Target: <25% per International Consensus. Hyperglycemia Level 1. Note: LOINC 104640-8 covers total TAR, not L1 specifically."

// Note: #tar-l2 moved to Group 1 as LOINC 104639-0 (Phase 3, 2026-03-10)
// Note: #cv moved to Group 1 as LOINC 104638-2 (Phase 3, 2026-03-10)

// Standard Deviation — still custom, LOINC 97505-2 exists but profile still uses custom #sd
* group[1].element[3].code = #sd
* group[1].element[3].display = "Standard Deviation"
* group[1].element[3].target[0].code = #0
* group[1].element[3].target[0].display = "No OMOP concept for glucose SD"
* group[1].element[3].target[0].equivalence = #unmatched
* group[1].element[3].target[0].comment = "Glucose standard deviation. Unit: mg/dL or mmol/L."

// ============================================================================
// OMOP UNIT CONCEPTS REFERENCE for CGM
// ============================================================================
// For use in MEASUREMENT.unit_concept_id:
// - 8840: milligram per deciliter (mg/dL) - US standard
// - 8753: millimole per liter (mmol/L) - International standard
// - 8554: percent (%) - for TIR, TBR, TAR, CV
// - 8587: millisecond (ms) - for trend rate
//
// Conversion: mg/dL × 0.0555 = mmol/L
// Conversion: mmol/L × 18.02 = mg/dL
//
// For MEASUREMENT.measurement_type_concept_id:
// - 44818707: Patient self-reported (for CGM wearable data)
// - 32817: EHR (if imported from clinical system)
