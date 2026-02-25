// ConceptMap: Physical Activity LOINC → OMOP CDM
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
// Purpose: Enable physical activity transformation from FHIR to OMOP CDM
// Context: PhD Thesis - Physical Activity as lifestyle medicine pillar

Instance: ConceptMapActivityToOMOP
InstanceOf: ConceptMap
Title: "Physical Activity to OMOP CDM Mapping"
Description: "Maps physical activity metrics from LOINC codes and wearable-derived metrics to OMOP CDM concept_ids for ETL transformation pipelines. Supports consumer fitness trackers and clinical activity monitors."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapActivityToOMOP"
* version = "0.1.0"
* name = "ConceptMapActivityToOMOP"
* title = "Physical Activity to OMOP CDM Mapping"
* status = #active
* experimental = false
* date = "2025-11-28"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "ricardolourencosantos@gmail.com"
* description = """
Maps physical activity metrics from wearables to OMOP CDM concepts for federated analytics.

Physical Activity Guidelines (WHO 2020, ACSM):
- 150-300 min/week moderate-intensity OR 75-150 min/week vigorous
- Muscle-strengthening activities 2+ days/week
- Sedentary time should be minimized
- Any amount of activity is better than none

Key Metrics:
- Steps: 7,000-10,000 steps/day associated with health benefits
- Active calories: Energy expenditure from activity
- Exercise minutes: Zone-based activity time
- MET-minutes: Metabolic equivalent of task

Supported Devices:
- Apple Watch, iPhone (Apple HealthKit)
- Fitbit (all models)
- Garmin (Connect IQ)
- Samsung Galaxy Watch
- Google Pixel Watch
"""
* purpose = "Enable ETL transformation of physical activity data from FHIR to OMOP CDM for population health studies, exercise intervention research, and lifestyle medicine analytics."

// Note: sourceUri/targetUri omitted to avoid validation errors

// ============================================================================
// GROUP 1: LOINC Activity Codes → OMOP MEASUREMENT Concepts
// ============================================================================
* group[0].source = "http://loinc.org"
* group[0].target = "http://athena.ohdsi.org/search-terms/terms"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #0
* group[0].unmapped.display = "No OMOP concept - requires custom vocabulary extension"

// ============================================================================
// Steps - VERIFIED OMOP MAPPING
// ============================================================================
* group[0].element[0].code = #55423-8
* group[0].element[0].display = "Number of steps in 24 hour Measured"
* group[0].element[0].target[0].code = #40771089
* group[0].element[0].target[0].display = "Number of steps"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = """
VERIFIED OMOP mapping for daily steps.
- OMOP concept_id: 40771089
- Domain: Measurement
- Unit_concept_id: 9529 (count) or unitless
- Guidelines: 7,000-10,000 steps/day for health benefits
"""

// ============================================================================
// Exercise Duration
// ============================================================================
* group[0].element[1].code = #55411-3
* group[0].element[1].display = "Exercise duration"
* group[0].element[1].target[0].code = #4272025
* group[0].element[1].target[0].display = "Duration of procedure"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = """
Maps to general duration concept.
- OMOP concept_id: 4272025
- Unit_concept_id: 8550 (minute)
- Target: 150-300 min/week moderate or 75-150 min/week vigorous
Context should indicate exercise vs general activity.
"""

// ============================================================================
// Exercise Intensity
// ============================================================================
* group[0].element[2].code = #82290-8
* group[0].element[2].display = "Frequency of moderate to vigorous aerobic physical activity"
* group[0].element[2].target[0].code = #4090484
* group[0].element[2].target[0].display = "Physical activity"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[2].target[0].comment = """
Maps to general physical activity concept.
- OMOP concept_id: 4090484
- Domain: Observation
- Use observation_source_value for intensity context
"""

// ============================================================================
// Calories Burned / Energy Expenditure
// ============================================================================
* group[0].element[3].code = #41981-2
* group[0].element[3].display = "Calories burned"
* group[0].element[3].target[0].code = #0
* group[0].element[3].target[0].display = "No direct OMOP concept"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = """
GAP: Active calories has no OMOP concept.
Represents energy expenditure from activity.
Unit_concept_id: 8692 (kilocalorie) or 8674 (kilojoule)
Critical for weight management research.
"""

// ============================================================================
// Distance Traveled
// ============================================================================
* group[0].element[4].code = #55430-3
* group[0].element[4].display = "Walking distance"
* group[0].element[4].target[0].code = #0
* group[0].element[4].target[0].display = "No OMOP concept available"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = """
GAP: Distance traveled has no OMOP concept.
Unit_concept_id: 8582 (meter) or 9314 (kilometer) or 9282 (mile)
Context-dependent (walking, running, cycling).
"""

// ============================================================================
// GROUP 2: Custom Activity Metrics → OMOP
// ============================================================================
* group[1].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[1].target = "http://athena.ohdsi.org/search-terms/terms"
* group[1].unmapped.mode = #fixed
* group[1].unmapped.code = #0
* group[1].unmapped.display = "No OMOP concept - wearable metrics not in standard vocabulary"

// Active Minutes
* group[1].element[0].code = #active-minutes
* group[1].element[0].display = "Active Minutes"
* group[1].element[0].target[0].code = #0
* group[1].element[0].target[0].display = "No OMOP concept available"
* group[1].element[0].target[0].equivalence = #unmatched
* group[1].element[0].target[0].comment = """
Vendor-specific active minutes (zone-based).
Apple: Exercise Ring minutes
Fitbit: Active Zone Minutes
Garmin: Intensity Minutes
Not standardized but clinically relevant.
"""

// MET-Minutes
* group[1].element[1].code = #met-minutes
* group[1].element[1].display = "MET-Minutes"
* group[1].element[1].target[0].code = #0
* group[1].element[1].target[0].display = "No OMOP concept available"
* group[1].element[1].target[0].equivalence = #unmatched
* group[1].element[1].target[0].comment = """
Metabolic Equivalent of Task × Duration.
Standard measure for physical activity dose.
1 MET = 1 kcal/kg/hour (resting)
Target: 500-1000 MET-min/week per guidelines.
"""

// Sedentary Time
* group[1].element[2].code = #sedentary-time
* group[1].element[2].display = "Sedentary Time"
* group[1].element[2].target[0].code = #0
* group[1].element[2].target[0].display = "No OMOP concept available"
* group[1].element[2].target[0].equivalence = #unmatched
* group[1].element[2].target[0].comment = """
Time spent in sedentary activities (<1.5 METs).
Target: Reduce prolonged sitting, break every 30-60 min.
Independent risk factor for mortality.
"""

// Floors Climbed
* group[1].element[3].code = #floors-climbed
* group[1].element[3].display = "Floors Climbed"
* group[1].element[3].target[0].code = #0
* group[1].element[3].target[0].display = "No OMOP concept available"
* group[1].element[3].target[0].equivalence = #unmatched
* group[1].element[3].target[0].comment = """
Number of floors/flights of stairs climbed.
Indicates vertical displacement activity.
Typically measured via barometric altimeter.
"""

// Stand Hours
* group[1].element[4].code = #stand-hours
* group[1].element[4].display = "Stand Hours"
* group[1].element[4].target[0].code = #0
* group[1].element[4].target[0].display = "No OMOP concept available"
* group[1].element[4].target[0].equivalence = #unmatched
* group[1].element[4].target[0].comment = """
Apple Watch specific: Hours with at least 1 min standing.
Target: 12 stand hours/day.
Proxy for sedentary behavior interruption.
"""

// ============================================================================
// OMOP UNIT CONCEPTS REFERENCE for Physical Activity
// ============================================================================
// For use in MEASUREMENT.unit_concept_id:
// - 9529: count - for steps
// - 8550: minute (min) - for duration
// - 8505: hour (h) - for extended durations
// - 8692: kilocalorie (kcal) - for calories
// - 8674: kilojoule (kJ) - for energy
// - 8582: meter (m) - for distance
// - 9314: kilometer (km) - for distance
// - 9282: mile (mi) - for distance
//
// For MEASUREMENT.measurement_type_concept_id:
// - 44818707: Patient self-reported (for wearable data)
// - 32817: EHR (if from clinical assessment)
