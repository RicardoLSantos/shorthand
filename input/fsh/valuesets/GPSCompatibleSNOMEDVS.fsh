// =============================================================================
// GPS-Compatible SNOMED CT Codes ValueSet
// =============================================================================
// Created: 2026-01-19
//
// Purpose: Documents which SNOMED CT codes used in this IG are available in
// the SNOMED International Global Patient Set (GPS), enabling use without
// full SNOMED CT affiliate licensing.
//
// GPS License: CC-BY-4.0 (100% FREE)
// GPS Concepts: ~26,158 codes
// GPS Purpose: IPS implementations without SNOMED affiliate license
//
// References:
// - SNOMED International GPS: https://www.snomed.org/gps
// - HL7 THO GPS ValueSet: http://terminology.hl7.org/ValueSet/snomed-intl-gps
// - IPS IG (uses GPS via HL7 THO): https://hl7.org/fhir/uv/ips/
// =============================================================================

Alias: $SCT = http://snomed.info/sct

ValueSet: GPSCompatibleSNOMEDVS
Id: gps-compatible-snomed-vs
Title: "GPS-Compatible SNOMED CT Codes ValueSet"
Description: """
SNOMED CT codes used in this Implementation Guide that are included in the
SNOMED International Global Patient Set (GPS), available under CC-BY-4.0
without SNOMED CT affiliate licensing.

## GPS Coverage Analysis

| Domain | IG Metrics | GPS Compatible | Coverage |
|--------|------------|----------------|----------|
| Substance Use | 7 | 7 | 100% |
| Physical Activity | 25 | 1 | ~4% |
| Sleep | 5 | 0 | 0% |
| Nutrition | 6 | 0 | 0% |
| Mindfulness | 3 | 0 | 0% |
| Mobility | 5 | 0 | 0% |
| HRV | 6 | 0 | 0% |
| **TOTAL** | **57** | **8** | **~14%** |

## Implications

Organizations using GPS-only (without full SNOMED CT license) can exchange:
- Tobacco and alcohol status data
- Basic physical activity type (walking)

Advanced lifestyle metrics require either:
- Full SNOMED CT licensing through national affiliate programs
- Custom CodeSystems defined in this IG
"""
* ^status = #active
* ^experimental = false
* ^version = "0.1.0"
* ^publisher = "FMUP/2RDoc"
* ^copyright = "This ValueSet references codes from SNOMED CT GPS (CC-BY-4.0). Attribution to SNOMED International required."

// =============================================================================
// TOBACCO USE STATUS (IPS-aligned, GPS-compatible)
// =============================================================================
// These codes are part of the IPS Current Smoking Status ValueSet
// and verified to be in the GPS subset.
* $SCT#266919005 "Never smoked tobacco (finding)"
* $SCT#8517006 "Ex-smoker (finding)"
* $SCT#77176002 "Smoker (finding)"
* $SCT#449868002 "Smokes tobacco daily (finding)"
* $SCT#428041000124106 "Occasional tobacco smoker (finding)"
* $SCT#230063004 "Heavy cigarette smoker (finding)"
* $SCT#230060001 "Light cigarette smoker (finding)"

// =============================================================================
// PHYSICAL ACTIVITY (Verified in GPS)
// =============================================================================
// Walking verified GPS-compatible from the 84 activity types defined in this IG.
// Note: 129011009 "Running" removed - code invalid in SNOMED CT International 2025
* $SCT#129006008 "Walking (observable entity)"

// =============================================================================
// CODES NOT IN GPS (Documented for reference)
// =============================================================================
// The following domains have ZERO GPS-compatible codes:
// - Sleep stages (N1, N2, N3, REM, Awake)
// - Nutrition tracking metrics
// - Mindfulness practices
// - Mobility assessment (TUG, 6MWT, etc.)
// - HRV metrics (SDNN has LOINC but no GPS SNOMED mapping)
//
// Organizations requiring these metrics must either:
// 1. Obtain full SNOMED CT license through national membership
// 2. Use the custom CodeSystems defined in this IG
// =============================================================================
