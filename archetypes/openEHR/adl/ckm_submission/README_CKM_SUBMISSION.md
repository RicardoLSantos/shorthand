# CKM Submission Package - HEADS2 Wearable Archetypes

**Date Prepared**: 2025-11-27
**Target Submission**: December 1-7, 2025
**Author**: Ricardo Lourenco dos Santos
**Institution**: Faculty of Medicine, University of Porto (FMUP)

---

## Archetypes Included (Batch 1A)

| # | Archetype | Type | Size | Validation |
|---|-----------|------|------|------------|
| 1 | `openEHR-EHR-OBSERVATION.heart_rate_variability.v0.adl` | OBSERVATION | 38KB | Archie 3.15.0 VALID |
| 2 | `openEHR-EHR-OBSERVATION.physical_activity_detailed.v0.adl` | OBSERVATION | 23KB | Archie 3.15.0 VALID |
| 3 | `openEHR-EHR-OBSERVATION.sleep_architecture.v0.adl` | OBSERVATION | 25KB | Archie 3.15.0 VALID |
| 4 | `openEHR-EHR-CLUSTER.wearable_device.v0.adl` | CLUSTER | 18KB | Archie 3.15.0 VALID |

---

## Metadata Verification Checklist

All archetypes pass the following requirements:

- [x] `adl_version=1.4` (EHRbase/CKM compatible)
- [x] `lifecycle_state = <"in_development">`
- [x] `original_language = <[ISO_639-1::en]>`
- [x] No incomplete translations
- [x] `custodian_organisation = FMUP`
- [x] `licence = CC BY-SA 4.0`
- [x] Complete purpose/use/misuse statements
- [x] Keywords for discovery

---

## Project Context

### PhD Thesis
**Title**: Integrating Wearable Biomarkers into Learning Health Systems through Semantic Interoperability

**Key Findings Supporting These Archetypes**:
1. **85% gap** in openEHR coverage for advanced wearable metrics (RS0 systematic review)
2. **HRV-inflammation correlation** validated across 51 studies (RS1, Williams 2019)
3. **RMSSD paradox**: Primary wearable metric has no LOINC code (OHDSI Concept ID = 0)

### Clinical Use Cases
1. **Lifestyle Medicine**: HRV + Sleep + Activity for 6 pillars assessment
2. **Learning Health Systems**: Wearable data semantic interoperability
3. **Remote Patient Monitoring**: Consumer device integration
4. **Research**: Standardized data collection across devices

---

## Differentiation from Existing CKM Archetypes

| This Archetype | Similar CKM | Differentiation |
|----------------|-------------|-----------------|
| `heart_rate_variability.v0` | `pulse.v2` | HRV metrics (SDNN, RMSSD, LF/HF) vs. basic heart rate |
| `physical_activity_detailed.v0` | `physical_activity.v0` | Wearable-specific metrics, vendor mappings |
| `sleep_architecture.v0` | `sleep.v0` | Sleep stages (REM, NREM, Deep), wearable algorithms |
| `wearable_device.v0` | `device.v1` | Consumer wearable specialization (11 vendors) |

---

## Vendor Coverage

These archetypes include guidance for data transformation from:

| Vendor | API/Platform | Supported |
|--------|--------------|-----------|
| Apple | HealthKit | Yes |
| Fitbit | Web API | Yes |
| Google | Fit API | Yes |
| Garmin | Connect IQ | Yes |
| Polar | AccessLink | Yes |
| Oura | Cloud API | Yes |
| Samsung | Health | Yes |
| Withings | Health Mate | Yes |
| Whoop | API | Yes |
| Xiaomi | Mi Fit | Yes |
| Amazfit | Zepp | Yes |

---

## LOINC Bindings

| Metric | LOINC Code | Status |
|--------|------------|--------|
| SDNN | 80404-7 | Bound |
| RMSSD | - | No LOINC (documented) |
| pNN50 | - | No LOINC |
| Step Count | 55423-8 | Candidate binding |
| Total Sleep Time | 93832-4 | Candidate binding |

---

## Submission Instructions

### Step 1: Login to CKM
- URL: https://ckm.openehr.org/ckm/
- Create account if needed

### Step 2: Upload Each File
1. Navigate to "Upload" or "Contribute"
2. Upload `.adl` file
3. Confirm metadata
4. Submit as Draft

### Step 3: Monitor Review
- Check email for reviewer comments
- Respond within 2 weeks
- Expected timeline: 4-8 weeks for initial review

---

## Contact

**Primary Author**: Ricardo Lourenco dos Santos
**Email**: ricardolourencosantos@gmail.com
**Institution**: FMUP - Faculty of Medicine, University of Porto
**Project**: HEADS2 PhD Thesis

---

## Revision History

| Date | Version | Change |
|------|---------|--------|
| 2025-11-26 | 1.0 | Initial validation with Archie 3.15.0 |
| 2025-11-27 | 1.1 | Submission package prepared |

---

*Generated for CKM submission - HEADS2 Project*
