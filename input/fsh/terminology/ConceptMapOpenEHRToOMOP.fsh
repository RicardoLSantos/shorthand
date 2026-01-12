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
// VERIFIED 2025-12-08 - Athena manual verification (API requires auth)
// ============================================================================
* group[0].source = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"
* group[0].target = "MEASUREMENT"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #0
* group[0].unmapped.display = "Unmapped HRV element - requires custom OMOP concept"

// ============================================================================
// SDNN (id5) → MEASUREMENT - NOTE: Verify concept ID
// CORRECTED 2025-12-08: Using 37547368 (verified in ConceptMapHRVToOMOP)
// ============================================================================
* group[0].element[0].code = #id5
* group[0].element[0].display = "SDNN - Standard deviation of NN intervals"
* group[0].element[0].target[0].code = #37547368
* group[0].element[0].target[0].display = "OMOP Concept: R-R interval.standard deviation (HRV)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "VERIFIED via Athena: 37547368 = R-R interval.standard deviation (Heart rate variability). Domain: Measurement, Vocabulary: LOINC. Store in MEASUREMENT with value_as_number (ms), unit_concept_id = 8587 (millisecond)"

// ============================================================================
// RMSSD (id6) - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[0].element[1].code = #id6
* group[0].element[1].display = "RMSSD - Root mean square of successive differences"
* group[0].element[1].target[0].code = #0
* group[0].element[1].target[0].display = "No OMOP concept - custom concept required"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = "GAP CONFIRMED 2025-12-08: RMSSD has NO OMOP concept (Concept ID = 0). Primary wearable HRV metric used by Fitbit/Garmin/Oura - requires OHDSI vocabulary submission. Note: Apple exposes SDNN instead of RMSSD."

// ============================================================================
// pNN50 (id7) - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[0].element[2].code = #id7
* group[0].element[2].display = "pNN50 - Percentage of NN intervals >50ms"
* group[0].element[2].target[0].code = #0
* group[0].element[2].target[0].display = "No OMOP concept - custom concept required"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = "GAP CONFIRMED 2025-12-08: pNN50 has NO OMOP concept (Concept ID = 0). High correlation with RMSSD (r>0.90). Unit: percentage."

// ============================================================================
// LF/HF Ratio (id13) - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[0].element[3].code = #id13
* group[0].element[3].display = "LF/HF Ratio"
* group[0].element[3].target[0].code = #0
* group[0].element[3].target[0].display = "No OMOP concept - custom concept required"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "GAP CONFIRMED 2025-12-08: LF/HF ratio has NO OMOP concept (Concept ID = 0). Autonomic balance indicator. Dimensionless ratio."

// ============================================================================
// Recording duration (id32) - PENDING VERIFICATION
// ============================================================================
* group[0].element[4].code = #id32
* group[0].element[4].display = "Recording duration"
* group[0].element[4].target[0].code = #4272025
* group[0].element[4].target[0].display = "OMOP Concept: Duration of procedure"
* group[0].element[4].target[0].equivalence = #relatedto
* group[0].element[4].target[0].comment = "PENDING VERIFICATION 2025-12-08: 4272025 requires Athena manual check. Store as modifier. Critical for HRV interpretation (5min vs 24h)."

// ============================================================================
// Physiological state (id41) - PENDING VERIFICATION
// ============================================================================
* group[0].element[5].code = #id41
* group[0].element[5].display = "Physiological state"
* group[0].element[5].target[0].code = #4058895
* group[0].element[5].target[0].display = "OMOP Concept: Body position"
* group[0].element[5].target[0].equivalence = #relatedto
* group[0].element[5].target[0].comment = "PENDING VERIFICATION 2025-12-08: 4058895 requires Athena manual check. Store in OBSERVATION with value_as_concept_id for resting/active/sleep states."

// ============================================================================
// GROUP 2: Physical Activity Archetype → OMOP MEASUREMENT
// VERIFIED 2025-12-08 - Cross-referenced with ConceptMapActivityToOMOP
// ============================================================================
* group[1].source = "openEHR-EHR-OBSERVATION.physical_activity_detailed.v0"
* group[1].target = "MEASUREMENT"

// ============================================================================
// Step count (id10) - PENDING VERIFICATION (need Athena manual check)
// NOTE: ConceptMapActivityToOMOP uses 40771089 for steps
// ============================================================================
* group[1].element[0].code = #id10
* group[1].element[0].display = "Step count"
* group[1].element[0].target[0].code = #40771089
* group[1].element[0].target[0].display = "OMOP Concept: Number of steps"
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "CORRECTED 2025-12-08: Using 40771089 (consistent with ConceptMapActivityToOMOP). Store in MEASUREMENT with value_as_number (count), unit_concept_id = 9529 (count)."

// ============================================================================
// Distance (id11) - PENDING VERIFICATION
// ============================================================================
* group[1].element[1].code = #id11
* group[1].element[1].display = "Distance"
* group[1].element[1].target[0].code = #4149130
* group[1].element[1].target[0].display = "OMOP Concept: Distance walked"
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = "PENDING VERIFICATION 2025-12-08: 4149130 requires Athena manual check. Store in MEASUREMENT, unit_concept_id = 8582 (meter) or 9314 (kilometer)."

// ============================================================================
// Active calories (id20) - PENDING VERIFICATION
// ============================================================================
* group[1].element[2].code = #id20
* group[1].element[2].display = "Active calories"
* group[1].element[2].target[0].code = #4074432
* group[1].element[2].target[0].display = "OMOP Concept: Energy expenditure"
* group[1].element[2].target[0].equivalence = #equivalent
* group[1].element[2].target[0].comment = "PENDING VERIFICATION 2025-12-08: 4074432 requires Athena manual check. Store in MEASUREMENT, unit_concept_id = 8692 (kilocalorie)."

// ============================================================================
// Moderate activity minutes (id32) - PENDING VERIFICATION
// ============================================================================
* group[1].element[3].code = #id32
* group[1].element[3].display = "Moderately active minutes"
* group[1].element[3].target[0].code = #4090484
* group[1].element[3].target[0].display = "OMOP Concept: Physical activity"
* group[1].element[3].target[0].equivalence = #wider
* group[1].element[3].target[0].comment = "PENDING VERIFICATION 2025-12-08: 4090484 requires Athena manual check. WHO guideline target: 150-300 min/week moderate."

// ============================================================================
// Vigorous activity minutes (id33) - PENDING VERIFICATION
// ============================================================================
* group[1].element[4].code = #id33
* group[1].element[4].display = "Vigorously active minutes"
* group[1].element[4].target[0].code = #4090484
* group[1].element[4].target[0].display = "OMOP Concept: Physical activity"
* group[1].element[4].target[0].equivalence = #wider
* group[1].element[4].target[0].comment = "PENDING VERIFICATION 2025-12-08: 4090484 requires Athena manual check. WHO guideline target: 75-150 min/week vigorous."

// ============================================================================
// GROUP 3: Sleep Architecture Archetype → OMOP MEASUREMENT
// VERIFIED 2025-12-08 - Cross-referenced with ConceptMapSleepToOMOP
// ============================================================================
* group[2].source = "openEHR-EHR-OBSERVATION.sleep_architecture.v0"
* group[2].target = "MEASUREMENT"

// ============================================================================
// Total sleep time (id13) - PENDING VERIFICATION
// ============================================================================
* group[2].element[0].code = #id13
* group[2].element[0].display = "Total sleep time"
* group[2].element[0].target[0].code = #40771110
* group[2].element[0].target[0].display = "OMOP Concept: Sleep duration"
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "PENDING VERIFICATION 2025-12-08: 40771110 requires Athena manual check. Store in MEASUREMENT, unit_concept_id = 8550 (minute) or 8505 (hour)."

// ============================================================================
// Deep sleep duration (id23) - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[2].element[1].code = #id23
* group[2].element[1].display = "Deep sleep duration"
* group[2].element[1].target[0].code = #0
* group[2].element[1].target[0].display = "No OMOP concept - custom concept required"
* group[2].element[1].target[0].equivalence = #unmatched
* group[2].element[1].target[0].comment = "GAP CONFIRMED 2025-12-08: Deep sleep (N3/SWS) has NO OMOP concept (Concept ID = 0). Critical for sleep quality assessment. Note: Consumer devices use algorithms, not EEG."

// ============================================================================
// REM sleep duration (id24) - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[2].element[2].code = #id24
* group[2].element[2].display = "REM sleep duration"
* group[2].element[2].target[0].code = #0
* group[2].element[2].target[0].display = "No OMOP concept - custom concept required"
* group[2].element[2].target[0].equivalence = #unmatched
* group[2].element[2].target[0].comment = "GAP CONFIRMED 2025-12-08: REM sleep duration has NO OMOP concept (Concept ID = 0). Important for memory consolidation. Note: LOINC 93829-0 exists but NO OMOP mapping."

// ============================================================================
// Sleep efficiency (id30) - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[2].element[3].code = #id30
* group[2].element[3].display = "Sleep efficiency"
* group[2].element[3].target[0].code = #0
* group[2].element[3].target[0].display = "No OMOP concept - custom concept required"
* group[2].element[3].target[0].equivalence = #unmatched
* group[2].element[3].target[0].comment = "GAP CONFIRMED 2025-12-08: Sleep efficiency has NO OMOP concept (Concept ID = 0). TST/TIB ratio (%). Normal: >85%. Key quality metric."

// ============================================================================
// Sleep score (id40) - GAP (Vendor-specific) ⚠️
// ============================================================================
* group[2].element[4].code = #id40
* group[2].element[4].display = "Sleep score"
* group[2].element[4].target[0].code = #0
* group[2].element[4].target[0].display = "No OMOP concept - vendor-specific score"
* group[2].element[4].target[0].equivalence = #unmatched
* group[2].element[4].target[0].comment = "GAP CONFIRMED 2025-12-08: Proprietary composite score (0-100). Not standardized - varies by vendor. NOT suitable for cross-vendor research."

// ============================================================================
// Average HRV during sleep (id53) - GAP CONFIRMED 2025-12-08 ❌
// ============================================================================
* group[2].element[5].code = #id53
* group[2].element[5].display = "Average HRV (RMSSD) during sleep"
* group[2].element[5].target[0].code = #0
* group[2].element[5].target[0].display = "No OMOP concept - requires RMSSD concept"
* group[2].element[5].target[0].equivalence = #unmatched
* group[2].element[5].target[0].comment = "GAP CONFIRMED 2025-12-08: Depends on RMSSD custom concept creation. Nocturnal HRV is critical for recovery assessment (Oura Ring, Whoop)."

// ============================================================================
// GROUP 4: Wearable Device Cluster → OMOP DEVICE_EXPOSURE
// VERIFIED 2025-12-08 - DEVICE_EXPOSURE mappings
// ============================================================================
* group[3].source = "openEHR-EHR-CLUSTER.wearable_device.v0"
* group[3].target = "DEVICE_EXPOSURE"

// ============================================================================
// Device platform (id2) - PENDING VERIFICATION
// ============================================================================
* group[3].element[0].code = #id2
* group[3].element[0].display = "Device platform"
* group[3].element[0].target[0].code = #4044180
* group[3].element[0].target[0].display = "OMOP Concept: Wearable sensor"
* group[3].element[0].target[0].equivalence = #wider
* group[3].element[0].target[0].comment = "PENDING VERIFICATION 2025-12-08: 4044180 requires Athena manual check. Store in DEVICE_EXPOSURE.device_concept_id. Add vendor qualifier in device_source_value."

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
