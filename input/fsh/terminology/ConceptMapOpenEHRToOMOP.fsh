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
- 21491502: R-R interval.standard deviation (LOINC 80404-7)
- 1002368: Sleep duration (LOINC 93832-4)
- 3964780/3965425: Duration of moderate/vigorous activity (LOINC 101689-8/101690-6)
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
// AUDITED 2026-03-19 (VRF-TERM-017): 37547368→21491502, 4272025→3004182, 4058895→4287468
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
* group[0].element[0].target[0].code = #21491502
* group[0].element[0].target[0].display = "R-R interval.standard deviation (Heart rate variability)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "VERIFIED via Athena CONCEPT.csv 2026-03-19: concept_id=21491502, LOINC 80404-7, Domain=Measurement, Standard. Store in MEASUREMENT with value_as_number (ms). Previous 37547368 NOT in local Athena/Vocab2."

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
// Recording duration (id32) - VERIFIED 2026-03-19 (was 4272025 HALLUCINATED)
// ============================================================================
* group[0].element[4].code = #id32
* group[0].element[4].display = "Recording duration"
* group[0].element[4].target[0].code = #3004182
* group[0].element[4].target[0].display = "Recording duration by EKG"
* group[0].element[4].target[0].equivalence = #relatedto
* group[0].element[4].target[0].comment = "VERIFIED via Athena 2026-03-19: concept_id=3004182, LOINC 8618-1, Domain=Measurement. Previous 4272025='Herpesvirus disease of turbot' (HALLUCINATED). Critical for HRV interpretation (5min vs 24h)."

// ============================================================================
// Physiological state (id41) - VERIFIED 2026-03-19 (was 4058895 HALLUCINATED)
// ============================================================================
* group[0].element[5].code = #id41
* group[0].element[5].display = "Physiological state"
* group[0].element[5].target[0].code = #4287468
* group[0].element[5].target[0].display = "Body position"
* group[0].element[5].target[0].equivalence = #relatedto
* group[0].element[5].target[0].comment = "VERIFIED via Vocab2 2026-03-19: concept_id=4287468, SNOMED 397155001, Domain=Observation, Standard. Previous 4058895='Plain X-ray lumbar/sacral' (HALLUCINATED). Store in OBSERVATION with value_as_concept_id."

// ============================================================================
// GROUP 2: Physical Activity Archetype → OMOP MEASUREMENT
// AUDITED 2026-03-19 (VRF-TERM-017): 40771089→40758552, 4149130→40758559, 4074432→21490772, 4090484→3964780/3965425
// ============================================================================
* group[1].source = "openEHR-EHR-OBSERVATION.physical_activity_detailed.v0"
* group[1].target = "MEASUREMENT"

// ============================================================================
// Step count (id10) - VERIFIED 2026-03-19 (was 40771089 HALLUCINATED)
// NOTE: ConceptMapActivityToOMOP also needs audit for 40771089
// ============================================================================
* group[1].element[0].code = #id10
* group[1].element[0].display = "Step count"
* group[1].element[0].target[0].code = #40758552
* group[1].element[0].target[0].display = "Number of steps in unspecified time Pedometer"
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "VERIFIED via Athena 2026-03-19: concept_id=40758552, LOINC 55423-8, Domain=Observation, Standard. Previous 40771089='What language do you feel comfortable speaking' (HALLUCINATED). Store in MEASUREMENT, unit_concept_id=9529 (count)."

// ============================================================================
// Distance (id11) - VERIFIED 2026-03-19 (was 4149130 HALLUCINATED)
// ============================================================================
* group[1].element[1].code = #id11
* group[1].element[1].display = "Distance"
* group[1].element[1].target[0].code = #40758559
* group[1].element[1].target[0].display = "Walking distance unspecified time Pedometer"
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = "VERIFIED via Athena 2026-03-19: concept_id=40758559, LOINC 55430-3, Domain=Measurement, Standard. Previous 4149130='Gastroenterology service' (HALLUCINATED). Unit: meter (8582) or kilometer (9314)."

// ============================================================================
// Active calories (id20) - VERIFIED 2026-03-19 (was 4074432 HALLUCINATED)
// ============================================================================
* group[1].element[2].code = #id20
* group[1].element[2].display = "Active calories"
* group[1].element[2].target[0].code = #21490772
* group[1].element[2].target[0].display = "Energy expended Reporting Period by Indirect calorimetry"
* group[1].element[2].target[0].equivalence = #equivalent
* group[1].element[2].target[0].comment = "VERIFIED via Athena 2026-03-19: concept_id=21490772, LOINC 75990-2, Domain=Measurement. Previous 4074432='Open freeing adhesions fallopian tube' (HALLUCINATED). Unit: kilocalorie (8692)."

// ============================================================================
// Moderate activity minutes (id32) - VERIFIED 2026-03-19 (was 4090484 HALLUCINATED+DUPLICATE)
// ============================================================================
* group[1].element[3].code = #id32
* group[1].element[3].display = "Moderately active minutes"
* group[1].element[3].target[0].code = #3964780
* group[1].element[3].target[0].display = "Duration of moderate activity"
* group[1].element[3].target[0].equivalence = #equivalent
* group[1].element[3].target[0].comment = "VERIFIED via Athena 2026-03-19: concept_id=3964780, LOINC 101689-8, Domain=Measurement, Standard. Previous 4090484='Laplace transform damping factor' (HALLUCINATED, also duplicated with vigorous). WHO target: 150-300 min/week."

// ============================================================================
// Vigorous activity minutes (id33) - VERIFIED 2026-03-19 (was 4090484 HALLUCINATED+DUPLICATE)
// ============================================================================
* group[1].element[4].code = #id33
* group[1].element[4].display = "Vigorously active minutes"
* group[1].element[4].target[0].code = #3965425
* group[1].element[4].target[0].display = "Duration of vigorous activity"
* group[1].element[4].target[0].equivalence = #equivalent
* group[1].element[4].target[0].comment = "VERIFIED via Athena 2026-03-19: concept_id=3965425, LOINC 101690-6, Domain=Measurement, Standard. Previous 4090484 was same hallucinated ID as moderate (DUPLICATE resolved). WHO target: 75-150 min/week."

// ============================================================================
// GROUP 3: Sleep Architecture Archetype → OMOP MEASUREMENT
// AUDITED 2026-03-19 (VRF-TERM-017): 40771110→1002368
// ============================================================================
* group[2].source = "openEHR-EHR-OBSERVATION.sleep_architecture.v0"
* group[2].target = "MEASUREMENT"

// ============================================================================
// Total sleep time (id13) - VERIFIED 2026-03-19 (was 40771110 HALLUCINATED)
// ============================================================================
* group[2].element[0].code = #id13
* group[2].element[0].display = "Total sleep time"
* group[2].element[0].target[0].code = #1002368
* group[2].element[0].target[0].display = "Sleep duration"
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "VERIFIED via Athena 2026-03-19: concept_id=1002368, LOINC 93832-4, Domain=Observation, Standard. Previous 40771110='Have you used drugs other than medical' (HALLUCINATED). Unit: minute (8550) or hour (8505)."

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
// AUDITED 2026-03-19 (VRF-TERM-017): 4044180→0(GAP), 44818707→44818706
// ============================================================================
* group[3].source = "openEHR-EHR-CLUSTER.wearable_device.v0"
* group[3].target = "DEVICE_EXPOSURE"

// ============================================================================
// Device platform (id2) - GAP CONFIRMED 2026-03-19 (was 4044180 HALLUCINATED)
// ============================================================================
* group[3].element[0].code = #id2
* group[3].element[0].display = "Device platform"
* group[3].element[0].target[0].code = #0
* group[3].element[0].target[0].display = "No standard wearable sensor concept"
* group[3].element[0].target[0].equivalence = #unmatched
* group[3].element[0].target[0].comment = "GAP CONFIRMED via Athena+Vocab2 2026-03-19: No standard 'wearable sensor' concept in OMOP. Previous 4044180='Administrative disposition - action' (HALLUCINATED). Store vendor name in device_source_value. Requires OHDSI vocabulary submission."

// Device model (id3) → DEVICE_EXPOSURE.device_source_value
* group[3].element[1].code = #id3
* group[3].element[1].display = "Device model"
* group[3].element[1].target[0].code = #0
* group[3].element[1].target[0].display = "Store in device_source_value"
* group[3].element[1].target[0].equivalence = #relatedto
* group[3].element[1].target[0].comment = "Store specific model name in device_source_value field (e.g., 'Apple Watch Series 9')"

// Device category (id4) → DEVICE_EXPOSURE.device_type_concept_id
* group[3].element[2].code = #id4
* group[3].element[2].display = "Device category"
* group[3].element[2].target[0].code = #44818706
* group[3].element[2].target[0].display = "Patient reported device"
* group[3].element[2].target[0].equivalence = #equivalent
* group[3].element[2].target[0].comment = "VERIFIED via Athena 2026-03-19: concept_id=44818706='Patient reported device' (Device Type). Previous 44818707='EHR Detail' (WRONG — wearable data is patient-reported, not EHR). Use as device_type_concept_id."

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
