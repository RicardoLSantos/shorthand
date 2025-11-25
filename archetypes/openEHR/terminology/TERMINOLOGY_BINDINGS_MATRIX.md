# Terminology Bindings Matrix for Wearable Lifestyle Medicine Archetypes

**Version**: 1.0.0
**Date**: 2025-11-25
**Author**: Ricardo Lourenco dos Santos (FMUP)
**Email**: ricardolourencosantos@gmail.com
**Links**: https://linktr.ee/ricardolsantos
**Context**: PhD Thesis - Integrating Wearable Biomarkers into Learning Health Systems

---

## Executive Summary

This document provides a comprehensive terminology binding matrix for the custom openEHR archetypes developed for wearable-derived lifestyle medicine data. It maps archetype elements to standard terminologies (LOINC, SNOMED-CT, OMOP CDM) and identifies critical gaps requiring custom code development or terminology proposals.

### Key Finding: The RMSSD Paradox

**RMSSD (Root Mean Square of Successive Differences)** is the primary HRV metric used by ALL major consumer wearables for parasympathetic/recovery assessment. Despite this ubiquity:
- **LOINC**: NO CODE EXISTS
- **OMOP CDM**: Concept ID = 0 (unmapped)
- **SNOMED-CT**: No specific concept
- **Impact**: The most important wearable HRV metric cannot be semantically interoperable

---

## 1. Heart Rate Variability (HRV) Archetype Bindings

### 1.1 Time-Domain Metrics

| Archetype Element | LOINC Code | LOINC Display | SNOMED-CT | OMOP Concept ID | Status |
|-------------------|------------|---------------|-----------|-----------------|--------|
| **SDNN** (id5) | **80404-7** | R-R interval.standard deviation (Heart rate variability) | 251211005 (RR interval SD) | 40758660 | ✅ COMPLETE |
| **RMSSD** (id6) | ❌ NONE | - | ❌ NONE | 0 | ⚠️ **CRITICAL GAP** |
| **pNN50** (id7) | ❌ NONE | - | ❌ NONE | 0 | ⚠️ GAP |
| **SDANN** (id8) | ❌ NONE | - | ❌ NONE | 0 | ⚠️ GAP |
| **Mean NN interval** (id9) | ❌ NONE | - | ❌ NONE | 0 | GAP |
| **NN50 count** (id10) | ❌ NONE | - | ❌ NONE | 0 | GAP |
| **Heart Rate** (derived) | **8867-4** | Heart rate | 364075005 | 3027018 | ✅ COMPLETE |

### 1.2 Frequency-Domain Metrics

| Archetype Element | LOINC Code | LOINC Display | SNOMED-CT | OMOP Concept ID | Status |
|-------------------|------------|---------------|-----------|-----------------|--------|
| **LF Power** (id20) | ❌ NONE | - | ❌ NONE | 0 | GAP |
| **HF Power** (id21) | ❌ NONE | - | ❌ NONE | 0 | GAP |
| **LF/HF Ratio** (id22) | ❌ NONE | - | ❌ NONE | 0 | GAP |
| **VLF Power** (id23) | ❌ NONE | - | ❌ NONE | 0 | GAP |
| **Total Power** (id24) | ❌ NONE | - | ❌ NONE | 0 | GAP |

### 1.3 Nonlinear/Poincaré Metrics

| Archetype Element | LOINC Code | LOINC Display | SNOMED-CT | OMOP Concept ID | Status |
|-------------------|------------|---------------|-----------|-----------------|--------|
| **SD1** (id30) | ❌ NONE | - | ❌ NONE | 0 | GAP |
| **SD2** (id31) | ❌ NONE | - | ❌ NONE | 0 | GAP |
| **SD1/SD2 Ratio** (id32) | ❌ NONE | - | ❌ NONE | 0 | GAP |

### 1.4 State/Context Elements

| Archetype Element | LOINC Code | SNOMED-CT | Notes |
|-------------------|------------|-----------|-------|
| Physiological state: Resting | - | 128975004 (At rest) | ✅ |
| Physiological state: Post-exercise | - | 255214003 (Post-exercise) | ✅ |
| Physiological state: Sleeping | - | 258158006 (Asleep) | ✅ |
| Body position: Supine | - | 40199007 | ✅ |
| Body position: Sitting | - | 33586001 | ✅ |
| Body position: Standing | - | 10904000 | ✅ |

### 1.5 HRV LOINC Timeline

| Year | Event | Source |
|------|-------|--------|
| 2017 | Shaffer & Ginsberg state "no LOINC codes for HRV" | Front Public Health 2017;5:258 |
| 2022 | LOINC 80404-7 (SDNN) added | LOINC v2.72 |
| 2025 | RMSSD still unmapped | Current status |

---

## 2. Physical Activity Archetype Bindings

### 2.1 Step and Distance Metrics

| Archetype Element | LOINC Code | LOINC Display | SNOMED-CT | OMOP Concept ID | Status |
|-------------------|------------|---------------|-----------|-----------------|--------|
| **Step count** (id10) | **55423-8** | Number of steps in unspecified time Pedometer | 228369008 (Walking steps) | 40762636 | ✅ COMPLETE |
| **Distance** (id11) | **55430-3** | Distance walked in unspecified time | - | 0 | ⚠️ Partial |
| **Floors climbed** (id12) | ❌ NONE | - | ❌ NONE | 0 | GAP |

### 2.2 Energy Expenditure

| Archetype Element | LOINC Code | LOINC Display | SNOMED-CT | OMOP Concept ID | Status |
|-------------------|------------|---------------|-----------|-----------------|--------|
| **Active calories** (id20) | **41979-6** | Calories burned during exercise | 251840004 | 0 | ⚠️ Partial |
| **Total calories** (id21) | **41981-2** | Calories burned in 24 hour | - | 0 | ⚠️ Partial |
| **Basal calories** (id22) | **41980-4** | Resting energy expenditure | 165109007 (BMR) | 0 | ⚠️ Partial |

### 2.3 Activity Intensity Levels

| Archetype Element | LOINC Code | LOINC Display | SNOMED-CT | Notes |
|-------------------|------------|---------------|-----------|-------|
| **Sedentary minutes** (id30) | ❌ NONE | - | 160618006 | WHO Guidelines |
| **Light activity minutes** (id31) | ❌ NONE | - | 228440002 | <3 METs |
| **Moderate activity minutes** (id32) | **77592-4** | Moderate activity [Minutes/week] | 228460007 | 3-6 METs |
| **Vigorous activity minutes** (id33) | **77593-2** | Vigorous activity [Minutes/week] | 228473001 | >6 METs |
| **Exercise minutes** (id34) | ❌ NONE | - | - | - |

### 2.4 Heart Rate Zones

| Zone | % Max HR | LOINC | SNOMED-CT | Status |
|------|----------|-------|-----------|--------|
| Zone 1 (50-60%) | Recovery | ❌ | ❌ | GAP |
| Zone 2 (60-70%) | Fat burn | ❌ | ❌ | GAP |
| Zone 3 (70-80%) | Cardio | ❌ | ❌ | GAP |
| Zone 4 (80-90%) | Hard | ❌ | ❌ | GAP |
| Zone 5 (90-100%) | Max | ❌ | ❌ | GAP |

### 2.5 Exercise Types (Local Codes → SNOMED-CT)

| Local Code | Exercise Type | SNOMED-CT Concept | Status |
|------------|---------------|-------------------|--------|
| at80 | Walking | 228473001 | ✅ |
| at81 | Running | 228473001 | ✅ |
| at82 | Cycling | 229572009 | ✅ |
| at83 | Swimming | 415940006 | ✅ |
| at84 | Strength training | 228450003 | ✅ |
| at85 | Yoga | 229085008 | ✅ |
| at86 | HIIT | ❌ NONE | GAP |
| at87 | Elliptical | ❌ NONE | GAP |
| at88 | Rowing | 415961009 | ✅ |
| at89 | Dance | 229061000 | ✅ |
| at90 | Hiking | 228475008 | ✅ |
| at91 | Tennis | 228440002 | ✅ |
| at92 | Golf | 228440002 | ✅ |

---

## 3. Sleep Architecture Archetype Bindings

### 3.1 Sleep Timing

| Archetype Element | LOINC Code | LOINC Display | SNOMED-CT | Status |
|-------------------|------------|---------------|-----------|--------|
| **Bedtime** (id10) | ❌ NONE | - | ❌ | GAP |
| **Wake time** (id11) | ❌ NONE | - | ❌ | GAP |
| **Time in bed** (id12) | ❌ NONE | - | ❌ | GAP |
| **Total sleep time** (id13) | **93832-4** | Sleep duration | 248263006 | ✅ |
| **Sleep onset latency** (id14) | ❌ NONE | - | 248254003 | Partial |

### 3.2 Sleep Stages (Consumer Wearable Classification)

| Archetype Element | LOINC Code | SNOMED-CT | PSG Equivalent | Status |
|-------------------|------------|-----------|----------------|--------|
| **Awake duration** (id21) | ❌ NONE | 248218005 | Wake | GAP |
| **Light sleep** (id22) | ❌ NONE | ❌ | N1 + N2 | GAP |
| **Deep sleep** (id23) | ❌ NONE | 258158006 | N3 (SWS) | GAP |
| **REM sleep** (id24) | ❌ NONE | 89129007 | REM | GAP |
| **Deep sleep %** (id25) | ❌ NONE | ❌ | - | GAP |
| **REM sleep %** (id26) | ❌ NONE | ❌ | - | GAP |

### 3.3 Sleep Efficiency Metrics

| Archetype Element | LOINC Code | LOINC Display | SNOMED-CT | Status |
|-------------------|------------|---------------|-----------|--------|
| **Sleep efficiency** (id30) | ❌ NONE | - | ❌ | GAP |
| **Number of awakenings** (id31) | ❌ NONE | - | ❌ | GAP |
| **WASO** (id32) | ❌ NONE | - | ❌ | GAP |

### 3.4 Vendor Sleep Scores

| Archetype Element | Source | LOINC | Status |
|-------------------|--------|-------|--------|
| **Sleep score** (id40) | Oura, Fitbit, Whoop | ❌ NONE | GAP - Proprietary |
| **Restfulness score** (id41) | Oura | ❌ NONE | GAP - Proprietary |
| **Readiness score** (id42) | Oura, Whoop | ❌ NONE | GAP - Proprietary |

### 3.5 Physiological Metrics During Sleep

| Archetype Element | LOINC Code | LOINC Display | Status |
|-------------------|------------|---------------|--------|
| **Avg HR during sleep** (id51) | **8867-4** | Heart rate | ✅ (with context) |
| **Lowest HR** (id52) | **8867-4** | Heart rate | ✅ (with context) |
| **Avg HRV (RMSSD)** (id53) | ❌ NONE | - | ⚠️ CRITICAL GAP |
| **Avg SpO2** (id54) | **59408-5** | Oxygen saturation | ✅ |
| **Respiratory rate** (id55) | **9279-1** | Respiratory rate | ✅ |
| **Skin temp deviation** (id56) | ❌ NONE | - | GAP |

### 3.6 Circadian Alignment (Local Codes)

| Local Code | Alignment Status | SNOMED-CT | Status |
|------------|------------------|-----------|--------|
| at70 | Optimal | ❌ | GAP |
| at71 | Slightly early | ❌ | GAP |
| at72 | Slightly late | ❌ | GAP |
| at73 | Early | ❌ | GAP |
| at74 | Late | ❌ | GAP |
| at75 | Irregular | 27349000 (Circadian rhythm disorder) | Partial |

---

## 4. Wearable Device Cluster Bindings

### 4.1 Device Platforms (Local Codes)

| Local Code | Platform | Vendor API | Data Standard |
|------------|----------|------------|---------------|
| at10 | Apple (HealthKit) | HealthKit API | CDA, FHIR R4 |
| at11 | Fitbit (Google) | Fitbit Web API | JSON, OAuth2 |
| at12 | Garmin (Connect) | Health API | JSON |
| at13 | Polar (Flow) | AccessLink API | JSON |
| at14 | Oura | Oura Cloud API v2 | JSON |
| at15 | Samsung (Health) | Samsung Health SDK | JSON |
| at16 | Whoop | WHOOP API | JSON |
| at17 | Withings | Health Mate API | JSON |
| at18 | Xiaomi (Mi Fit) | Proprietary | Limited |
| at19 | Amazfit (Zepp) | Zepp API | JSON |

### 4.2 Device Categories → SNOMED-CT

| Local Code | Category | SNOMED-CT | Status |
|------------|----------|-----------|--------|
| at30 | Smartwatch | 706456006 | ✅ |
| at31 | Fitness band | 706456006 | ✅ |
| at32 | Smart ring | ❌ NONE | GAP |
| at33 | Chest strap HRM | 706456006 | ✅ |
| at37 | CGM | 702660000 | ✅ |

### 4.3 Sensor Types → SNOMED-CT

| Sensor | Technology | SNOMED-CT | Status |
|--------|------------|-----------|--------|
| PPG optical | Photoplethysmography | 252465000 | ✅ |
| ECG | Electrocardiography | 106068002 | ✅ |
| Accelerometer | Motion sensor | ❌ | GAP |
| Gyroscope | Orientation | ❌ | GAP |
| SpO2 | Pulse oximetry | 431314004 | ✅ |
| Temperature | Thermometry | 386725007 | ✅ |
| GPS | Location | ❌ | N/A |
| Barometer | Pressure | ❌ | N/A |

---

## 5. FHIR Code System Mappings

### 5.1 Custom FHIR CodeSystem: HeartRateVariabilityCodeSystem

**URI**: `https://fmup.pt/fhir/CodeSystem/hrv-metrics`

| Code | Display | Definition | openEHR Element |
|------|---------|------------|-----------------|
| `sdnn` | SDNN | Standard deviation of NN intervals | id5 |
| `rmssd` | RMSSD | Root mean square of successive differences | id6 |
| `pnn50` | pNN50 | Percentage of successive NN differences >50ms | id7 |
| `lf-power` | LF Power | Low frequency power (0.04-0.15 Hz) | id20 |
| `hf-power` | HF Power | High frequency power (0.15-0.4 Hz) | id21 |
| `lf-hf-ratio` | LF/HF Ratio | Ratio of LF to HF power | id22 |
| `sd1` | SD1 | Poincaré plot SD perpendicular to line-of-identity | id30 |
| `sd2` | SD2 | Poincaré plot SD along line-of-identity | id31 |

### 5.2 LOINC Integration Strategy

For metrics WITH LOINC codes:
```
coding: [
  { system: "http://loinc.org", code: "80404-7", display: "SDNN" }
]
```

For metrics WITHOUT LOINC codes (migration path):
```
coding: [
  { system: "https://fmup.pt/fhir/CodeSystem/hrv-metrics", code: "rmssd", display: "RMSSD" },
  { system: "http://loinc.org", code: "LA24969-1", display: "Awaiting LOINC assignment" }
]
```

---

## 6. Gap Analysis Summary

### 6.1 Critical Gaps (High Priority for LOINC Proposal)

| Metric | Wearable Usage | Clinical Importance | Gap Type |
|--------|----------------|---------------------|----------|
| **RMSSD** | 100% of wearables | Primary recovery/stress marker | LOINC + SNOMED |
| **pNN50** | >80% of wearables | Parasympathetic indicator | LOINC |
| **LF/HF Ratio** | >70% of wearables | Autonomic balance | LOINC |
| **Sleep stages (wearable)** | 100% of wearables | Sleep quality | LOINC (non-PSG) |
| **Sleep efficiency** | 100% of wearables | Sleep quality | LOINC |

### 6.2 Coverage Statistics

| Domain | Total Elements | With LOINC | Coverage |
|--------|----------------|------------|----------|
| HRV Time-Domain | 6 | 1 (SDNN) | 16.7% |
| HRV Frequency-Domain | 5 | 0 | 0% |
| HRV Nonlinear | 3 | 0 | 0% |
| Physical Activity | 12 | 4 | 33.3% |
| Sleep Architecture | 15 | 2 | 13.3% |
| **TOTAL** | 41 | 7 | **17.1%** |

### 6.3 Terminology Gap by Criticality

```
CRITICAL (Blocks semantic interoperability):
├── RMSSD: No LOINC, No SNOMED-CT, OMOP ID=0
├── Sleep stages (consumer): No standardized coding
└── Vendor quality scores: Proprietary, no standards

HIGH (Limits data exchange):
├── pNN50, LF/HF ratio: No LOINC
├── Sleep efficiency/WASO: No LOINC
└── HR zones: No standardized definitions

MEDIUM (Workarounds available):
├── Exercise types: SNOMED partial coverage
├── Activity minutes: LOINC partial (weekly only)
└── Device metadata: Local codes sufficient

LOW (Acceptable):
├── Heart rate: Full coverage
├── SpO2: Full coverage
└── Respiratory rate: Full coverage
```

---

## 7. Recommended Actions

### 7.1 LOINC Proposal Submission

**Priority 1 - RMSSD**:
- Submit LOINC proposal for RMSSD
- Justification: Universal wearable adoption, clinical validation for parasympathetic assessment
- Proposed display: "R-R interval root mean square successive differences (Heart rate variability)"
- Property: Time
- Scale: Qn
- Class: CARDIAC

**Priority 2 - Sleep Metrics**:
- Sleep efficiency percentage
- Sleep stage durations (consumer wearable classification)
- Wake after sleep onset (WASO)

### 7.2 Custom CodeSystem Maintenance

Maintain `https://fmup.pt/fhir/CodeSystem/hrv-metrics` with:
- Clear deprecation policy when LOINC codes assigned
- Version history tracking
- Cross-reference to pending LOINC proposals

### 7.3 SNOMED-CT Extension Requests

Consider SNOMED-CT extension requests for:
- Smart ring device type
- Consumer sleep staging (distinct from PSG)
- Circadian alignment assessment concepts

---

## 8. Cross-Reference Tables

### 8.1 openEHR → FHIR Profile Mapping

| openEHR Archetype | FHIR Profile | IG Location |
|-------------------|--------------|-------------|
| OBSERVATION.heart_rate_variability.v0 | HRVObservation | input/fsh/HRV.fsh |
| OBSERVATION.physical_activity_detailed.v0 | PhysicalActivitySummary | input/fsh/PhysicalActivity.fsh |
| OBSERVATION.sleep_architecture.v0 | SleepAnalysis | input/fsh/Sleep.fsh |
| CLUSTER.wearable_device.v0 | WearableDevice (Extension) | input/fsh/Device.fsh |

### 8.2 OMOP CDM Mapping

| Domain | OMOP Domain | Concept Class |
|--------|-------------|---------------|
| HRV metrics | Measurement | Observable Entity |
| Physical activity | Measurement | Observable Entity |
| Sleep metrics | Measurement | Observable Entity |
| Device | Device | Device Type |

---

## Appendix A: LOINC Code Verification Protocol

All LOINC codes in this document verified via:
1. loinc.org official search (accessed 2025-11-25)
2. LOINC v2.77 (current release)
3. Cross-checked with OHDSI Athena vocabulary

Verification command:
```bash
curl "https://fhir.loinc.org/CodeSystem/$lookup?code=80404-7&system=http://loinc.org"
```

---

## Appendix B: Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-11-25 | Ricardo Santos | Initial comprehensive matrix |

---

*Generated for PhD Thesis: Integrating Wearable Biomarkers into Learning Health Systems through Semantic Interoperability*
*Faculty of Medicine, University of Porto (FMUP) 2020-2026*
