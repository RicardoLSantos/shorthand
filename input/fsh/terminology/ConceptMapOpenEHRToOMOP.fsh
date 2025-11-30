// ConceptMap: openEHR Archetype Elements → OMOP CDM
// Created: 2025-11-25
// Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
// Links: https://linktr.ee/ricardolsantos
// Purpose: Enable openEHR to OMOP CDM transformation for research analytics
// Context: PhD Thesis - Integrating Wearable Biomarkers into Learning Health Systems

Instance: ConceptMapOpenEHRToOMOP
InstanceOf: ConceptMap
Title: "openEHR Archetype to OMOP CDM Mapping"
Description: "Maps openEHR archetype elements for wearable lifestyle medicine data to OMOP Common Data Model for federated research analytics via OHDSI network."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapOpenEHRToOMOP"
* version = "0.1.0"
* name = "ConceptMapOpenEHRToOMOP"
* title = "openEHR Archetype to OMOP CDM Mapping"
* status = #active
* experimental = false
* date = "2025-11-25"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "ricardolourencosantos@gmail.com"
* description = """
Mapping from custom openEHR archetypes for wearable lifestyle medicine data to OMOP CDM v5.4 concepts.

Target OMOP Tables:
- MEASUREMENT: HRV metrics, sleep metrics, activity metrics
- DEVICE_EXPOSURE: Wearable device usage periods
- OBSERVATION: Categorical lifestyle data

Key OMOP Concepts Used:
- 3034658: Heart rate variability
- 40771110: Sleep duration
- 4090484: Physical activity
- Custom concepts required for RMSSD, pNN50 (OHDSI Concept ID = 0)

Architecture:
- Compatible with ETL pipelines from EHRbase to OMOP
- Supports ATLAS cohort definitions
- Enables OHDSI network studies
"""
* purpose = "Enable transformation of wearable health data from openEHR CDRs to OMOP CDM for participation in OHDSI federated research networks."

// Note: sourceUri/targetUri omitted - each group defines its own source/target
// Source: openEHR archetype identifiers (e.g., openEHR-EHR-OBSERVATION.xxx.v0)
// Target: OMOP CDM table names (e.g., MEASUREMENT, OBSERVATION, DEVICE_EXPOSURE)

// ============================================================================
// GROUP 1: HRV Archetype → OMOP MEASUREMENT
// ============================================================================
* group[0].source = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"
* group[0].target = "MEASUREMENT"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #0
* group[0].unmapped.display = "Unmapped HRV element - requires custom OMOP concept"

// SDNN (id5) → MEASUREMENT with OMOP concept
* group[0].element[0].code = #id5
* group[0].element[0].display = "SDNN - Standard deviation of NN intervals"
* group[0].element[0].target[0].code = #3034658
* group[0].element[0].target[0].display = "OMOP Concept: Heart rate variability"
* group[0].element[0].target[0].equivalence = #wider
* group[0].element[0].target[0].comment = "OMOP 3034658 maps to general HRV. Store in MEASUREMENT with value_as_number (ms), unit_concept_id = 8587 (millisecond)"

// RMSSD (id6) → MEASUREMENT (custom concept needed)
* group[0].element[1].code = #id6
* group[0].element[1].display = "RMSSD - Root mean square of successive differences"
* group[0].element[1].target[0].code = #0
* group[0].element[1].target[0].display = "No OMOP concept - custom concept required"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = "CRITICAL GAP: RMSSD has NO OMOP concept (Concept ID = 0). Requires local custom concept creation. Most important wearable HRV metric."

// pNN50 (id7) → MEASUREMENT (custom concept needed)
* group[0].element[2].code = #id7
* group[0].element[2].display = "pNN50 - Percentage of NN intervals >50ms"
* group[0].element[2].target[0].code = #0
* group[0].element[2].target[0].display = "No OMOP concept - custom concept required"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "GAP: pNN50 has no OMOP concept. Requires local custom concept. Unit: percentage"

// LF/HF Ratio (id13) → MEASUREMENT (custom concept needed)
* group[0].element[3].code = #id13
* group[0].element[3].display = "LF/HF Ratio"
* group[0].element[3].target[0].code = #0
* group[0].element[3].target[0].display = "No OMOP concept - custom concept required"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "GAP: LF/HF ratio has no OMOP concept. Indicates sympathovagal balance. Dimensionless ratio."

// Recording duration (id32) → MEASUREMENT modifier
* group[0].element[4].code = #id32
* group[0].element[4].display = "Recording duration"
* group[0].element[4].target[0].code = #4272025
* group[0].element[4].target[0].display = "OMOP Concept: Duration of procedure"
* group[0].element[4].target[0].equivalence = #relatedto
* group[0].element[4].target[0].comment = "Store as modifier or in MEASUREMENT_TYPE_CONCEPT_ID context. Critical for HRV interpretation (5min vs 24h)"

// Physiological state (id41) → OBSERVATION
* group[0].element[5].code = #id41
* group[0].element[5].display = "Physiological state"
* group[0].element[5].target[0].code = #4058895
* group[0].element[5].target[0].display = "OMOP Concept: Body position"
* group[0].element[5].target[0].equivalence = #relatedto
* group[0].element[5].target[0].comment = "Store in OBSERVATION table with value_as_concept_id for resting/active/sleep states"

// ============================================================================
// GROUP 2: Physical Activity Archetype → OMOP MEASUREMENT
// ============================================================================
* group[1].source = "openEHR-EHR-OBSERVATION.physical_activity_detailed.v0"
* group[1].target = "MEASUREMENT"

// Step count (id10) → MEASUREMENT with OMOP concept
* group[1].element[0].code = #id10
* group[1].element[0].display = "Step count"
* group[1].element[0].target[0].code = #40770386
* group[1].element[0].target[0].display = "OMOP Concept: Number of steps"
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "Store in MEASUREMENT with value_as_number (count), unit_concept_id = 8554 (count)"

// Distance (id11) → MEASUREMENT
* group[1].element[1].code = #id11
* group[1].element[1].display = "Distance"
* group[1].element[1].target[0].code = #4149130
* group[1].element[1].target[0].display = "OMOP Concept: Distance walked"
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = "Store in MEASUREMENT with value_as_number, unit_concept_id = 8582 (kilometer) or 8504 (meter)"

// Active calories (id20) → MEASUREMENT
* group[1].element[2].code = #id20
* group[1].element[2].display = "Active calories"
* group[1].element[2].target[0].code = #4074432
* group[1].element[2].target[0].display = "OMOP Concept: Energy expenditure"
* group[1].element[2].target[0].equivalence = #equivalent
* group[1].element[2].target[0].comment = "Store in MEASUREMENT with value_as_number, unit_concept_id = 9526 (kilocalorie)"

// Moderate activity minutes (id32) → MEASUREMENT
* group[1].element[3].code = #id32
* group[1].element[3].display = "Moderately active minutes"
* group[1].element[3].target[0].code = #4090484
* group[1].element[3].target[0].display = "OMOP Concept: Physical activity"
* group[1].element[3].target[0].equivalence = #wider
* group[1].element[3].target[0].comment = "Store with qualifier concept for moderate intensity. Unit: minutes. WHO guideline target: 150-300 min/week"

// Vigorous activity minutes (id33) → MEASUREMENT
* group[1].element[4].code = #id33
* group[1].element[4].display = "Vigorously active minutes"
* group[1].element[4].target[0].code = #4090484
* group[1].element[4].target[0].display = "OMOP Concept: Physical activity"
* group[1].element[4].target[0].equivalence = #wider
* group[1].element[4].target[0].comment = "Store with qualifier concept for vigorous intensity. Unit: minutes. WHO guideline target: 75-150 min/week"

// ============================================================================
// GROUP 3: Sleep Architecture Archetype → OMOP MEASUREMENT
// ============================================================================
* group[2].source = "openEHR-EHR-OBSERVATION.sleep_architecture.v0"
* group[2].target = "MEASUREMENT"

// Total sleep time (id13) → MEASUREMENT with OMOP concept
* group[2].element[0].code = #id13
* group[2].element[0].display = "Total sleep time"
* group[2].element[0].target[0].code = #40771110
* group[2].element[0].target[0].display = "OMOP Concept: Sleep duration"
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "Store in MEASUREMENT with value_as_number, unit_concept_id = 8505 (hour) or 8550 (minute)"

// Deep sleep duration (id23) → MEASUREMENT (custom concept needed)
* group[2].element[1].code = #id23
* group[2].element[1].display = "Deep sleep duration"
* group[2].element[1].target[0].code = #0
* group[2].element[1].target[0].display = "No OMOP concept - custom concept required"
* group[2].element[1].target[0].equivalence = #unmatched
* group[2].element[1].target[0].comment = "GAP: N3/SWS stage duration has no OMOP concept. Critical for sleep quality assessment. Requires local custom concept."

// REM sleep duration (id24) → MEASUREMENT (custom concept needed)
* group[2].element[2].code = #id24
* group[2].element[2].display = "REM sleep duration"
* group[2].element[2].target[0].code = #0
* group[2].element[2].target[0].display = "No OMOP concept - custom concept required"
* group[2].element[2].target[0].equivalence = #unmatched
* group[2].element[2].target[0].comment = "GAP: REM stage duration has no OMOP concept. Important for memory consolidation assessment. Requires local custom concept."

// Sleep efficiency (id30) → MEASUREMENT (custom concept needed)
* group[2].element[3].code = #id30
* group[2].element[3].display = "Sleep efficiency"
* group[2].element[3].target[0].code = #0
* group[2].element[3].target[0].display = "No OMOP concept - custom concept required"
* group[2].element[3].target[0].equivalence = #unmatched
* group[2].element[3].target[0].comment = "GAP: TST/TIB ratio (%) has no OMOP concept. Key metric for sleep quality. Normal: >85%"

// Sleep score (id40) → MEASUREMENT (custom concept needed)
* group[2].element[4].code = #id40
* group[2].element[4].display = "Sleep score"
* group[2].element[4].target[0].code = #0
* group[2].element[4].target[0].display = "No OMOP concept - vendor-specific score"
* group[2].element[4].target[0].equivalence = #unmatched
* group[2].element[4].target[0].comment = "Proprietary composite score (0-100). Not suitable for cross-vendor research. Store with vendor qualifier."

// Average HRV during sleep (id53) → MEASUREMENT
* group[2].element[5].code = #id53
* group[2].element[5].display = "Average HRV (RMSSD) during sleep"
* group[2].element[5].target[0].code = #0
* group[2].element[5].target[0].display = "No OMOP concept - requires RMSSD concept"
* group[2].element[5].target[0].equivalence = #unmatched
* group[2].element[5].target[0].comment = "Depends on RMSSD custom concept creation. Critical for recovery assessment."

// ============================================================================
// GROUP 4: Wearable Device Cluster → OMOP DEVICE_EXPOSURE
// ============================================================================
* group[3].source = "openEHR-EHR-CLUSTER.wearable_device.v0"
* group[3].target = "DEVICE_EXPOSURE"

// Device platform (id2) → DEVICE_EXPOSURE with OMOP concept
* group[3].element[0].code = #id2
* group[3].element[0].display = "Device platform"
* group[3].element[0].target[0].code = #4044180
* group[3].element[0].target[0].display = "OMOP Concept: Wearable sensor"
* group[3].element[0].target[0].equivalence = #wider
* group[3].element[0].target[0].comment = "Store in DEVICE_EXPOSURE with device_concept_id = 4044180. Add vendor qualifier in device_source_value"

// Device model (id3) → DEVICE_EXPOSURE.device_source_value
* group[3].element[1].code = #id3
* group[3].element[1].display = "Device model"
* group[3].element[1].target[0].code = #4044180
* group[3].element[1].target[0].display = "Store in device_source_value"
* group[3].element[1].target[0].equivalence = #relatedto
* group[3].element[1].target[0].comment = "Store specific model name in device_source_value field (e.g., 'Apple Watch Series 9')"

// Device category (id4) → DEVICE_EXPOSURE.device_type_concept_id
* group[3].element[2].code = #id4
* group[3].element[2].display = "Device category"
* group[3].element[2].target[0].code = #44818707
* group[3].element[2].target[0].display = "OMOP Concept: Patient self-reported"
* group[3].element[2].target[0].equivalence = #relatedto
* group[3].element[2].target[0].comment = "Use device_type_concept_id = 44818707 for wearable-generated data provenance"

// Serial number (id23) → DEVICE_EXPOSURE.unique_device_id
* group[3].element[3].code = #id23
* group[3].element[3].display = "Serial number"
* group[3].element[3].target[0].code = #32882
* group[3].element[3].target[0].display = "Store in unique_device_id"
* group[3].element[3].target[0].equivalence = #equivalent
* group[3].element[3].target[0].comment = "Map to unique_device_id field in DEVICE_EXPOSURE"

// Firmware version (id20) → Not mapped (metadata only)
* group[3].element[4].code = #id20
* group[3].element[4].display = "Firmware version"
* group[3].element[4].target[0].code = #0
* group[3].element[4].target[0].display = "Not mapped - metadata only"
* group[3].element[4].target[0].equivalence = #disjoint
* group[3].element[4].target[0].comment = "Firmware version not typically stored in OMOP CDM. Consider NOTE table or custom extension."

// ============================================================================
// TERMINOLOGY GAP SUMMARY
// ============================================================================
// CRITICAL GAPS requiring custom OMOP concepts:
// 1. RMSSD (most used wearable HRV metric) - OHDSI Concept ID = 0
// 2. pNN50 - OHDSI Concept ID = 0
// 3. LF/HF ratio - OHDSI Concept ID = 0
// 4. Deep sleep duration - OHDSI Concept ID = 0
// 5. REM sleep duration - OHDSI Concept ID = 0
// 6. Sleep efficiency - OHDSI Concept ID = 0
//
// Recommendation: Create custom vocabulary in ATHENA with concept_class_id = 'Observable Entity'
// Reference: OHDSI Forums thread on wearable data vocabulary extension
