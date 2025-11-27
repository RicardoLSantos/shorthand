# openEHR Archetypes for Lifestyle Medicine Wearables

This directory contains openEHR archetypes designed for wearable device health data, complementing the FHIR Implementation Guide.

## Directory Structure

```
archetypes/openEHR/
├── adl/                    # ADL 1.4 Archetype files
├── templates/              # Operational templates (.oet)
├── terminology/            # Terminology binding documentation
└── README.md               # This file
```

## Archetypes Included (36 Total)

### CLUSTER Archetypes (5)

| Archetype | Description | Lines | Status |
|-----------|-------------|-------|--------|
| `wearable_device.v0.adl` | Device metadata (vendor, model, firmware) | 364 | CKM Ready |
| `data_quality_indicator.v0.adl` | Signal quality, artifacts, coverage | ~420 | CKM Ready |
| `physiological_context.v0.adl` | Body position, activity, emotional state | ~570 | CKM Ready |
| `recording_context.v0.adl` | Recording duration, sampling, analysis window | ~520 | CKM Ready |
| `vendor_data_provenance.v0.adl` | Data source, export method, transformations | ~490 | CKM Ready |

### OBSERVATION Archetypes (31)

| Archetype | Description | Lines | Status |
|-----------|-------------|-------|--------|
| `heart_rate_variability.v0.adl` | HRV metrics (SDNN, RMSSD, frequency domain) | 781 | CKM Ready |
| `physical_activity_detailed.v0.adl` | Detailed physical activity tracking | 341 | CKM Ready |
| `sleep_architecture.v0.adl` | Sleep stages and quality metrics | 360 | CKM Ready |
| `spo2_wearable.v0.adl` | SpO2, ODI, sleep oximetry | ~700 | CKM Ready |
| `stress_assessment.v0.adl` | Stress scores, EDA, recovery metrics | ~990 | CKM Ready |
| `respiratory_rate_wearable.v0.adl` | PPG/accelerometer-derived RR, sleep breathing | ~580 | CKM Ready |
| `skin_temperature_wearable.v0.adl` | Skin temp, baseline deviation, menstrual context | ~550 | CKM Ready |
| `blood_glucose_cgm.v0.adl` | CGM data, TIR, glycemic variability, GMI | ~750 | CKM Ready |
| `body_composition_wearable.v0.adl` | BIA smart scale data, body fat, muscle mass | ~1100 | CKM Ready |
| `exercise_session.v0.adl` | Workout sessions, training load, TRIMP/TSS | ~1400 | CKM Ready |
| `nutrition_intake.v0.adl` | Macros, micros, meal tracking, diet patterns | ~1100 | CKM Ready |
| `hydration_tracking.v0.adl` | Fluid intake, beverages, hydration status | ~900 | CKM Ready |
| `environmental_exposure.v0.adl` | AQI, UV, noise, pollen, climate data | ~1100 | CKM Ready |
| `menstrual_cycle.v0.adl` | Cycle tracking, symptoms, flow patterns | ~1300 | CKM Ready |
| `fertility_indicators.v0.adl` | BBT, cervical mucus, LH surge, ovulation | ~1275 | CKM Ready |
| `pregnancy_tracking.v0.adl` | Gestational tracking, movements, symptoms | ~1130 | CKM Ready |
| `social_engagement.v0.adl` | Communication, loneliness, UCLA scale | ~1150 | CKM Ready |
| `mental_wellness.v0.adl` | Mood, PHQ-9, GAD-7, mindfulness, journaling | ~1350 | CKM Ready |
| `cognitive_assessment.v0.adl` | Brain training, reaction time, working memory | ~1250 | CKM Ready |
| `circadian_rhythm.v0.adl` | Light exposure, chronotype, MEQ, social jet lag | ~1150 | CKM Ready |
| `substance_use_tracking.v0.adl` | Alcohol (AUDIT), tobacco (Fagerstrom), caffeine | ~1250 | CKM Ready |
| `pain_assessment.v0.adl` | NRS/VAS pain, BPI interference, headache tracking | ~1380 | CKM Ready |
| `fatigue_assessment.v0.adl` | FSS/FACIT-F/CFQ scales, wearable recovery metrics | ~1190 | CKM Ready |
| `medication_adherence.v0.adl` | MMAS-8/ARMS/BMQ, smart pill bottles, refill tracking | ~1560 | CKM Ready |
| `symptom_diary.v0.adl` | Patient-reported symptoms, triggers, wearable correlates | ~1780 | CKM Ready |
| `recovery_readiness.v0.adl` | Oura/WHOOP/Garmin recovery scores, training status | ~1250 | CKM Ready |
| `blood_pressure_home.v0.adl` | Home BP monitoring, ABPM, cuffless devices | ~1240 | CKM Ready |
| `electrocardiogram_wearable.v0.adl` | Single-lead ECG, AFib detection, clinical review | ~1190 | CKM Ready |
| `fall_detection.v0.adl` | Fall events, emergency response, fall history, risk factors | ~1150 | CKM Ready |
| `gait_analysis.v0.adl` | Walking metrics, 6MWT, steadiness, cadence, stride variability | ~1150 | CKM Ready |
| `balance_assessment.v0.adl` | TUG test, single leg stance, ABC Scale confidence | ~1150 | CKM Ready |

## Terminology Bindings

- **LOINC 80404-7**: SDNN (Standard Deviation of NN intervals)
- **LOINC 59408-5**: SpO2 (Oxygen saturation by pulse oximetry)
- **SNOMED CT**: Activity types, sleep stages
- **Custom codes**: RMSSD, pNN50, LF/HF ratio, ODI (pending LOINC submission)

## Vendor Support (11 Platforms)

All archetypes support data from:
- Apple Watch / HealthKit
- Fitbit
- Garmin
- Polar
- Oura Ring
- Samsung Galaxy Watch
- Whoop
- Withings
- Xiaomi
- Amazfit
- Other (extensible)

## Cross-Standard Interoperability

These archetypes are designed to work with:
- **FHIR profiles** in this IG (ConceptMaps available in `input/fsh/terminology/`)
- **OMOP CDM** via MEASUREMENT table mapping

## Synchronization

This content is synchronized with:
- `Thesis_github/knowledge_base/openEHR/archetypes/new/` (documentation repository)

See: `Thesis_github/.claude/skills/code-documentation-locations.md` for sync procedures.

## Validation Status

All 36 archetypes validated with ADL 1.4 structural validator:
- **Errors**: 0
- **Warnings**: Minor (false positives on term_bindings detection)
- **Phase 1A-1B**: 7 archetypes validated 2025-11-27
- **Phase 2A**: 3 archetypes validated 2025-11-27
- **Phase 2B**: 3 archetypes validated 2025-11-27
- **Phase 3A**: 3 archetypes validated 2025-11-27
- **Phase 3B**: 3 archetypes validated 2025-11-27
- **Phase 4**: 3 archetypes validated 2025-11-27
- **Phase 5**: 3 archetypes validated 2025-11-27
- **Phase 6**: 3 archetypes validated 2025-11-27
- **Phase 7**: 3 archetypes validated 2025-11-27 (mobility/safety)

## Related Resources

- [openEHR CKM](https://ckm.openehr.org/) - Clinical Knowledge Manager
- [ADL 1.4 Specification](https://specifications.openehr.org/releases/AM/Release-1.4/)
- [HRV Knowledge Base](../../Thesis_github/knowledge_base/openEHR/hrv_knowledge_base_parts/)

---

*Part of iOS Lifestyle Medicine FHIR IG - HEADS#2 PhD Project*
*Last updated: 2025-11-27*
*Archetypes: 36 (5 CLUSTERs + 31 OBSERVATIONs)*
