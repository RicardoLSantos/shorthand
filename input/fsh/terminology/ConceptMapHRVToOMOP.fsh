// ConceptMap: HRV LOINC → OMOP CDM
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
// Purpose: Enable HRV data transformation from FHIR (LOINC-coded) to OMOP CDM
// Context: PhD Thesis - RS4 FHIR-OMOP ETL systematic review finding
// Verified: SDNN OMOP concept_id 37547368 via Athena (https://athena.ohdsi.org/search-terms/terms/37547368)

Instance: ConceptMapHRVToOMOP
InstanceOf: ConceptMap
Title: "HRV LOINC to OMOP CDM Mapping"
Description: "Maps HRV metrics from LOINC codes to OMOP CDM concept_ids for ETL transformation pipelines. Verified against OHDSI Athena vocabulary. Critical finding from RS4 systematic review: ZERO documented implementations of HRV-OMOP transformation in 354 papers - this ConceptMap addresses that gap."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapHRVToOMOP"
* version = "0.1.0"
* name = "ConceptMapHRVToOMOP"
* title = "HRV LOINC to OMOP CDM Mapping"
* status = #active
* experimental = false
* date = "2025-11-28"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "ricardolourencosantos@gmail.com"
* description = """
Maps HRV (Heart Rate Variability) metrics from LOINC codes to OMOP CDM concepts for federated analytics.

Key Findings from RS4 Systematic Review (354 papers analyzed):
- ZERO documented HRV-OMOP transformations in peer-reviewed literature
- Only ONE OMOP concept available: 37547368 (SDNN via LOINC 80404-7)
- CRITICAL GAP: RMSSD, pNN50, LF/HF have NO OMOP concepts (concept_id = 0)

This ConceptMap enables:
- SpringBatch ETL pipelines (Peng et al. achieved 99% DQD compliance)
- Incremental loading patterns (Henke et al. achieved 87.5% time reduction)
- OHDSI network study participation for wearable HRV data

Target OMOP Table: MEASUREMENT
- measurement_concept_id: mapped OMOP concept
- value_as_number: HRV metric value
- unit_concept_id: 8587 (millisecond) for time-domain metrics
- measurement_type_concept_id: 44818707 (Patient self-reported/device)
"""
* purpose = "Enable ETL transformation of wearable HRV data from FHIR (LOINC-coded) to OMOP CDM for research analytics in OHDSI federated network."

// Note: sourceUri/targetUri removed - group.source and group.target define the code systems
// This avoids validation error requiring ValueSet reference

// ============================================================================
// GROUP 1: LOINC HRV Codes → OMOP MEASUREMENT Concepts
// ============================================================================
* group[0].source = "http://loinc.org"
* group[0].target = "http://athena.ohdsi.org/search-terms/terms"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #0
* group[0].unmapped.display = "No OMOP concept - requires custom vocabulary extension"

// ============================================================================
// SDNN - VERIFIED OMOP MAPPING ✅
// Verified: https://athena.ohdsi.org/search-terms/terms/37547368
// ============================================================================
* group[0].element[0].code = #80404-7
* group[0].element[0].display = "R-R interval.standard deviation (Heart rate variability) [LOINC]"
* group[0].element[0].target[0].code = #37547368
* group[0].element[0].target[0].display = "R-R interval.standard deviation (Heart rate variability)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = """
VERIFIED MAPPING via Athena (2025-11-28):
- OMOP concept_id: 37547368
- Domain: Measurement
- Concept Class: Lab Test
- Vocabulary: LOINC
- Valid dates: 2020-08-11 to 2099-12-31
- Standard concept: Standard

ETL Implementation:
- MEASUREMENT.measurement_concept_id = 37547368
- MEASUREMENT.value_as_number = SDNN value
- MEASUREMENT.unit_concept_id = 8587 (millisecond)
- MEASUREMENT.measurement_type_concept_id = 44818707 (Patient self-reported)
"""

// ============================================================================
// RMSSD - NO OMOP CONCEPT ⚠️ CRITICAL GAP
// ============================================================================
* group[0].element[1].code = #hrv-rmssd-local
* group[0].element[1].display = "RMSSD - Root Mean Square of Successive Differences [Custom]"
* group[0].element[1].target[0].code = #0
* group[0].element[1].target[0].display = "No OMOP concept available"
* group[0].element[1].target[0].equivalence = #unmatched
* group[0].element[1].target[0].comment = """
CRITICAL GAP: RMSSD has NO OMOP concept (concept_id = 0)

Clinical Importance:
- Primary parasympathetic marker (HRV Task Force 1996)
- Main HRV metric from consumer wearables (Apple, Oura, Garmin)
- Strongly associated with vagal tone and inflammation (RS1 finding)
- Mathematical relationship: RMSSD = SD1 × √2 (Poincaré plot)

Workaround:
1. Create local custom concept in OMOP vocabulary with concept_class_id = 'Observable Entity'
2. Map to general HRV concept 37547368 with qualifier (data loss)
3. Store in measurement_source_value field (non-standardized)

Recommendation: Submit new concept proposal to OHDSI Vocabulary team
"""

// ============================================================================
// pNN50 - NO OMOP CONCEPT ⚠️
// ============================================================================
* group[0].element[2].code = #hrv-pnn50-local
* group[0].element[2].display = "pNN50 - Percentage of NN intervals >50ms [Custom]"
* group[0].element[2].target[0].code = #0
* group[0].element[2].target[0].display = "No OMOP concept available"
* group[0].element[2].target[0].equivalence = #unmatched
* group[0].element[2].target[0].comment = """
GAP: pNN50 has no OMOP concept (concept_id = 0)

Clinical notes:
- High correlation with RMSSD (r > 0.90)
- Parasympathetic marker
- Unit: percentage (%)
- Normal range: typically 20-30% in healthy adults

ETL workaround: Store as measurement_source_value = 'pNN50:{value}%'
"""

// ============================================================================
// LF/HF RATIO - NO OMOP CONCEPT ⚠️
// ============================================================================
* group[0].element[3].code = #hrv-lf-hf-local
* group[0].element[3].display = "LF/HF Ratio - Low to High Frequency Power Ratio [Custom]"
* group[0].element[3].target[0].code = #0
* group[0].element[3].target[0].display = "No OMOP concept available"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = """
GAP: LF/HF ratio has no OMOP concept (concept_id = 0)

Clinical notes:
- Autonomic balance indicator (sympathovagal)
- Interpretation is debated in literature
- Dimensionless ratio
- Typically 1.5-2.0 in healthy adults at rest

ETL workaround: Store in measurement_source_value with qualifier
"""

// ============================================================================
// Heart Rate - VERIFIED OMOP MAPPING ✅
// ============================================================================
* group[0].element[4].code = #8867-4
* group[0].element[4].display = "Heart rate [LOINC]"
* group[0].element[4].target[0].code = #3027018
* group[0].element[4].target[0].display = "Heart rate"
* group[0].element[4].target[0].equivalence = #equivalent
* group[0].element[4].target[0].comment = """
Verified standard OMOP concept for heart rate.
- OMOP concept_id: 3027018
- Unit_concept_id: 8541 (per minute, {beats}/min)
- Critical contextual data for HRV interpretation
"""

// ============================================================================
// Resting Heart Rate - OMOP MAPPING
// ============================================================================
* group[0].element[5].code = #40443-4
* group[0].element[5].display = "Heart rate --resting [LOINC]"
* group[0].element[5].target[0].code = #3027018
* group[0].element[5].target[0].display = "Heart rate"
* group[0].element[5].target[0].equivalence = #wider
* group[0].element[5].target[0].comment = """
Maps to general heart rate concept.
Resting context can be captured in:
- visit_occurrence.visit_concept_id
- measurement qualifier
- observation_period context

Resting HR is critical for HRV baseline interpretation (Uth formula: VO2max = HRmax/HRrest × 15)
"""

// ============================================================================
// GROUP 2: Supporting Concepts for HRV Context
// ============================================================================
* group[1].source = "http://snomed.info/sct"
* group[1].target = "http://athena.ohdsi.org/search-terms/terms"

* group[1].element[0].code = #86290005
* group[1].element[0].display = "Respiratory rate [SNOMED]"
* group[1].element[0].target[0].code = #3024171
* group[1].element[0].target[0].display = "Respiratory rate"
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "Critical for HRV interpretation. RSA (respiratory sinus arrhythmia) affects HF power band."

// ============================================================================
// OMOP UNIT CONCEPTS REFERENCE
// ============================================================================
// For use in MEASUREMENT.unit_concept_id:
// - 8587: millisecond (ms) - for SDNN, RMSSD
// - 8554: percent (%) - for pNN50
// - 8541: per minute (/min) - for heart rate
// - 9085: milliseconds squared (ms²) - for spectral power
// - 8653: second (s) - for recording duration
//
// For MEASUREMENT.measurement_type_concept_id:
// - 44818707: Patient self-reported (for wearable data)
// - 32817: EHR (if imported from clinical system)
