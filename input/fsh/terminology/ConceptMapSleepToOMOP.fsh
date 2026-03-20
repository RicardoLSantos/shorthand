// ConceptMap: Sleep LOINC → OMOP CDM
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
// Purpose: Enable sleep metrics transformation from FHIR to OMOP CDM
// Context: PhD Thesis - Sleep as lifestyle medicine pillar

Instance: ConceptMapSleepToOMOP
InstanceOf: ConceptMap
Title: "Sleep Metrics to OMOP CDM Mapping"
Description: "Maps sleep metrics from LOINC codes and wearable-derived metrics to OMOP CDM concept_ids for ETL transformation pipelines. Supports consumer sleep trackers (Oura, WHOOP, Apple Watch, Fitbit)."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapSleepToOMOP"
* version = "0.1.0"
* name = "ConceptMapSleepToOMOP"
* title = "Sleep Metrics to OMOP CDM Mapping"
* status = #active
* experimental = false
* date = "2025-11-28"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "ricardolourencosantos@gmail.com"
* description = """
Maps sleep metrics from wearables to OMOP CDM concepts for federated analytics.

Sleep as Lifestyle Medicine Pillar:
- Sleep duration: 7-9 hours recommended for adults (AASM)
- Sleep efficiency: >85% considered normal
- Sleep stages: Light, Deep (SWS), REM proportions
- Sleep quality: Validated via PSQI, ISI questionnaires

Target OMOP Table: MEASUREMENT
- measurement_concept_id: mapped OMOP concept
- value_as_number: sleep metric value
- unit_concept_id: varies by metric
- measurement_type_concept_id: 44818707 (Patient self-reported/device)

Supported Sleep Trackers:
- Oura Ring (Gen 3)
- WHOOP 4.0
- Apple Watch (watchOS sleep tracking)
- Fitbit (Sleep Score)
- Garmin (Advanced Sleep Monitoring)
- Polar (Sleep Plus Stages)
"""
* purpose = "Enable ETL transformation of sleep wearable data from FHIR to OMOP CDM for sleep research, circadian rhythm studies, and lifestyle medicine interventions."

// Note: sourceUri/targetUri omitted to avoid validation errors

// ============================================================================
// GROUP 1: LOINC Sleep Codes → OMOP MEASUREMENT Concepts
// ============================================================================
* group[0].source = "http://loinc.org"
* group[0].target = "http://athena.ohdsi.org/search-terms/terms"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #0
* group[0].unmapped.display = "No OMOP concept - requires custom vocabulary extension"

// ============================================================================
// Sleep Duration - VERIFIED via Athena LOINC lookup 2026-03-20 (VRF-TERM-017)
// Previous 40771110 was HALLUCINATED (actually = "have you used drugs other than medical reasons" SAMHSA)
// ============================================================================
* group[0].element[0].code = #93832-4
* group[0].element[0].display = "Sleep duration"
* group[0].element[0].target[0].code = #1002368
* group[0].element[0].target[0].display = "Sleep duration"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = """
VERIFIED via Athena CONCEPT.csv LOINC 93832-4 → concept_id 1002368 (2026-03-20)
- OMOP concept_id: 1002368
- Domain: Measurement
- Vocabulary: LOINC
- Unit_concept_id: 8505 (hour) or 8550 (minute)
- Recommended: 7-9 hours for adults (AASM guidelines)
"""

// ============================================================================
// Sleep Quality - LOINC available
// ============================================================================
* group[0].element[1].code = #28323-4
* group[0].element[1].display = "Sleep quality"
* group[0].element[1].target[0].code = #0
* group[0].element[1].target[0].display = "No direct OMOP concept"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = """
Sleep quality assessment. No direct OMOP concept.
Can be represented via:
- PSQI score (Pittsburgh Sleep Quality Index)
- Vendor-specific sleep scores (Oura, WHOOP)
Store in measurement_source_value with context.
"""

// ============================================================================
// Sleep Efficiency
// ============================================================================
* group[0].element[2].code = #93831-6
* group[0].element[2].display = "Sleep efficiency"
* group[0].element[2].target[0].code = #0
* group[0].element[2].target[0].display = "No OMOP concept available"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = """
GAP: Sleep efficiency has no OMOP concept.
Formula: (Total Sleep Time / Time in Bed) × 100
Normal: >85%
Unit: percentage (%)
Critical metric for insomnia assessment.
"""

// ============================================================================
// Sleep Onset Latency - CORRECTED 2025-12-08
// WRONG CODE FOUND: 93829-0 = "REM sleep duration" NOT "Sleep onset latency"
// Correct code: 103212-7 = "Duration of falling asleep" (Sleep Onset Latency)
// ============================================================================
* group[0].element[3].code = #103212-7
* group[0].element[3].display = "Duration of falling asleep"
* group[0].element[3].target[0].code = #3965451
* group[0].element[3].target[0].display = "Duration of falling asleep"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[3].target[0].comment = """
VERIFIED via Athena CONCEPT.csv LOINC 103212-7 → concept_id 3965451 (2026-03-20)
Previously marked as GAP (#0) — false negative, concept exists in Athena.
- OMOP concept_id: 3965451
- Domain: Measurement
- Vocabulary: LOINC
- Normal: <30 minutes. Prolonged latency indicates insomnia.
- Unit_concept_id: 8550 (minute)
"""

// ============================================================================
// REM Sleep Duration - NEW 2025-12-08
// LOINC 93829-0 = REM sleep duration (verified via loinc.org)
// ============================================================================
* group[0].element[4].code = #93829-0
* group[0].element[4].display = "REM sleep duration"
* group[0].element[4].target[0].code = #1001480
* group[0].element[4].target[0].display = "REM sleep duration"
* group[0].element[4].target[0].equivalence = #equivalent
* group[0].element[4].target[0].comment = """
VERIFIED via Athena CONCEPT.csv LOINC 93829-0 → concept_id 1001480 (2026-03-20)
Previously marked as GAP (#0) — false negative, concept exists in Athena.
- OMOP concept_id: 1001480
- Domain: Measurement
- Vocabulary: LOINC
- Normal: 20-25% of total sleep (1.5-2 hours)
- Unit_concept_id: 8550 (minute)
"""

// ============================================================================
// Number of Awakenings
// ============================================================================
* group[0].element[5].code = #93830-8
* group[0].element[5].display = "Number of awakenings during sleep"
* group[0].element[5].target[0].code = #0
* group[0].element[5].target[0].display = "No OMOP concept available"
* group[0].element[5].target[0].equivalence = #unmatched
* group[0].element[5].target[0].comment = "Number of wake episodes during sleep period. Normal: <5 brief awakenings."

// ============================================================================
// Wake Time After Sleep Onset (WASO) - NEW 2025-12-08
// LOINC 103215-0 = Wake time after sleep onset (verified via loinc.org)
// ============================================================================
* group[0].element[6].code = #103215-0
* group[0].element[6].display = "Wake time after sleep onset"
* group[0].element[6].target[0].code = #3966240
* group[0].element[6].target[0].display = "Wake time after sleep onset"
* group[0].element[6].target[0].equivalence = #equivalent
* group[0].element[6].target[0].comment = """
VERIFIED via Athena CONCEPT.csv LOINC 103215-0 → concept_id 3966240 (2026-03-20)
Previously marked as GAP (#0) — false negative, concept exists in Athena.
- OMOP concept_id: 3966240
- Domain: Measurement
- Vocabulary: LOINC
- Normal: <30 minutes
- Elevated WASO indicates sleep maintenance insomnia.
- Unit_concept_id: 8550 (minute)
"""

// ============================================================================
// GROUP 2: Custom Sleep Stage Metrics → OMOP
// ============================================================================
* group[1].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[1].target = "http://athena.ohdsi.org/search-terms/terms"
* group[1].unmapped.mode = #fixed
* group[1].unmapped.code = #0
* group[1].unmapped.display = "No OMOP concept - sleep stages not in OMOP vocabulary"

// Deep Sleep (SWS)
* group[1].element[0].code = #sleep-deep
* group[1].element[0].display = "Deep sleep duration"
* group[1].element[0].target[0].code = #0
* group[1].element[0].target[0].display = "No OMOP concept available"
* group[1].element[0].target[0].equivalence = #unmatched
* group[1].element[0].target[0].comment = """
Slow Wave Sleep (N3) duration.
Normal: 15-25% of total sleep (1-2 hours)
Critical for physical restoration, memory consolidation.
Most important sleep stage for recovery.
"""

// REM Sleep
* group[1].element[1].code = #rem-sleep
* group[1].element[1].display = "REM Sleep Duration"
* group[1].element[1].target[0].code = #0
* group[1].element[1].target[0].display = "No OMOP concept available"
* group[1].element[1].target[0].equivalence = #unmatched
* group[1].element[1].target[0].comment = """
Rapid Eye Movement sleep duration.
Normal: 20-25% of total sleep (1.5-2 hours)
Critical for cognitive function, emotional regulation.
Dreaming occurs primarily in REM.
"""

// Light Sleep
* group[1].element[2].code = #sleep-light
* group[1].element[2].display = "Light sleep duration"
* group[1].element[2].target[0].code = #0
* group[1].element[2].target[0].display = "No OMOP concept available"
* group[1].element[2].target[0].equivalence = #unmatched
* group[1].element[2].target[0].comment = """
Light sleep (N1 + N2) duration.
Normal: 50-60% of total sleep
Transition and lighter restorative sleep.
"""

// Sleep Score (Vendor)
* group[1].element[3].code = #sleep-score
* group[1].element[3].display = "Sleep score"
* group[1].element[3].target[0].code = #0
* group[1].element[3].target[0].display = "No OMOP concept available"
* group[1].element[3].target[0].equivalence = #unmatched
* group[1].element[3].target[0].comment = """
Vendor-specific composite sleep score (0-100).
Combines duration, efficiency, stages, HRV during sleep.
Examples: Oura Sleep Score, WHOOP Sleep Performance, Fitbit Sleep Score.
Non-standardized but clinically used.
"""

// WASO (Wake After Sleep Onset)
* group[1].element[4].code = #waso
* group[1].element[4].display = "Wake After Sleep Onset"
* group[1].element[4].target[0].code = #0
* group[1].element[4].target[0].display = "No OMOP concept available"
* group[1].element[4].target[0].equivalence = #unmatched
* group[1].element[4].target[0].comment = """
Total time awake after initial sleep onset.
Normal: <30 minutes
Elevated WASO indicates sleep maintenance insomnia.
Unit_concept_id: 8550 (minute)
"""

// ============================================================================
// OMOP UNIT CONCEPTS REFERENCE for Sleep
// ============================================================================
// For use in MEASUREMENT.unit_concept_id:
// - 8505: hour (h) - for total sleep duration
// - 8550: minute (min) - for latency, WASO, stage durations
// - 8554: percent (%) - for efficiency, stage percentages
// - 9529: count - for awakenings
//
// For MEASUREMENT.measurement_type_concept_id:
// - 44818707: Patient self-reported (for wearable data)
// - 32817: EHR (if from polysomnography)
