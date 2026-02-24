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
// GROUP 2: Custom CGM Metrics → OMOP (Time in Range metrics)
// ============================================================================
* group[1].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cgm-metrics-cs"
* group[1].target = "http://athena.ohdsi.org/search-terms/terms"
* group[1].unmapped.mode = #fixed
* group[1].unmapped.code = #0
* group[1].unmapped.display = "No OMOP concept - International Consensus 2019 metrics not yet in OMOP"

// TIR - Time in Range (70-180 mg/dL)
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

// TBR-L1 - Time Below Range Level 1 (54-69 mg/dL)
* group[1].element[1].code = #tbr-l1
* group[1].element[1].display = "Time Below Range Level 1"
* group[1].element[1].target[0].code = #0
* group[1].element[1].target[0].display = "No OMOP concept available"
* group[1].element[1].target[0].equivalence = #unmatched
* group[1].element[1].target[0].comment = "Target: <4% per International Consensus. Hypoglycemia Level 1."

// TBR-L2 - Time Below Range Level 2 (<54 mg/dL)
* group[1].element[2].code = #tbr-l2
* group[1].element[2].display = "Time Below Range Level 2"
* group[1].element[2].target[0].code = #0
* group[1].element[2].target[0].display = "No OMOP concept available"
* group[1].element[2].target[0].equivalence = #unmatched
* group[1].element[2].target[0].comment = "Target: <1% per International Consensus. Clinically significant hypoglycemia."

// TAR-L1 - Time Above Range Level 1 (181-250 mg/dL)
* group[1].element[3].code = #tar-l1
* group[1].element[3].display = "Time Above Range Level 1"
* group[1].element[3].target[0].code = #0
* group[1].element[3].target[0].display = "No OMOP concept available"
* group[1].element[3].target[0].equivalence = #unmatched
* group[1].element[3].target[0].comment = "Target: <25% per International Consensus. Hyperglycemia Level 1."

// TAR-L2 - Time Above Range Level 2 (>250 mg/dL)
* group[1].element[4].code = #tar-l2
* group[1].element[4].display = "Time Above Range Level 2"
* group[1].element[4].target[0].code = #0
* group[1].element[4].target[0].display = "No OMOP concept available"
* group[1].element[4].target[0].equivalence = #unmatched
* group[1].element[4].target[0].comment = "Target: <5% per International Consensus. Clinically significant hyperglycemia."

// CV - Coefficient of Variation
* group[1].element[5].code = #cv
* group[1].element[5].display = "Coefficient of Variation"
* group[1].element[5].target[0].code = #0
* group[1].element[5].target[0].display = "No OMOP concept available"
* group[1].element[5].target[0].equivalence = #unmatched
* group[1].element[5].target[0].comment = """
CV = (SD / Mean) × 100
Target: <36% indicates stable glycemia (Monnier et al.)
Critical for glycemic variability assessment.
"""

// Standard Deviation
* group[1].element[6].code = #sd
* group[1].element[6].display = "Standard Deviation"
* group[1].element[6].target[0].code = #0
* group[1].element[6].target[0].display = "No OMOP concept for glucose SD"
* group[1].element[6].target[0].equivalence = #unmatched
* group[1].element[6].target[0].comment = "Glucose standard deviation. Unit: mg/dL or mmol/L."

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
