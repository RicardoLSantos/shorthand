# Changelog - iOS Lifestyle Medicine FHIR Implementation Guide

## [0.2.0] - 2025-11-28

### Added

#### New Profiles (6 profiles)
1. **CyclingDynamicsObservation** (`SportSpecificProfiles.fsh`)
   - Power metrics (instantaneous, average, normalized, max)
   - FTP, TSS, Intensity Factor
   - Cadence and left/right balance
   - Coggan power zones (1-7)
   - Based on openEHR archetype `cycling_dynamics.v0`

2. **RunningDynamicsObservation** (`SportSpecificProfiles.fsh`)
   - Ground contact time and balance
   - Vertical oscillation and ratio
   - Running power (Stryd/Garmin compatible)
   - Stride length, cadence, pace
   - Footstrike type classification
   - Injury risk indicator
   - Based on openEHR archetype `running_dynamics.v0`

3. **SwimmingMetricsObservation** (`SportSpecificProfiles.fsh`)
   - SWOLF score (Swimming Golf)
   - Stroke metrics (type, rate, distance per stroke)
   - Lap counting and pace
   - Swimming environment (pool/open water)
   - Aerobic/Anaerobic Training Effect
   - Based on openEHR archetype `swimming_metrics.v0`

4. **StrengthTrainingObservation** (`SportSpecificProfiles.fsh`)
   - Sets, reps, load tracking
   - Velocity-based training metrics (VBT)
   - 1RM testing and estimation
   - Volume load calculation
   - Session RPE and training load
   - Based on openEHR archetype `strength_training.v0`

5. **CGMObservation** (`CGMProfile.fsh`)
   - Continuous glucose monitoring specific
   - Time in Range (TIR) per International Consensus 2019
   - Glycemic variability (CV, GMI)
   - Trend arrows and rate of change
   - Supports Dexcom, Libre, consumer CGM (Levels, Stelo)
   - Based on openEHR archetype `blood_glucose_cgm.v0`

6. **RecoveryReadinessObservation** (`RecoveryVO2maxProfiles.fsh`)
   - Vendor readiness scores (Oura, WHOOP, Garmin, Fitbit)
   - Contributing factors (sleep, HRV, resting HR)
   - Strain-recovery balance
   - Training status classification
   - Based on openEHR archetype `recovery_readiness.v0`

7. **VO2MaxEstimationObservation** (`RecoveryVO2maxProfiles.fsh`)
   - Estimated VO2max from wearables
   - CRF category (ACSM classification)
   - Fitness age estimation
   - Multiple estimation methods supported
   - Cardiovascular risk classification
   - Based on openEHR archetype `vo2max_estimation.v0`

#### New Questionnaires (4 questionnaires)
1. **Sleep Quality (PSQI-Based)** (`SleepQuestionnaires.fsh`)
   - Pittsburgh Sleep Quality Index adaptation
   - 7 component scores
   - Sleep latency, duration, efficiency
   - Daytime dysfunction assessment

2. **Stress Assessment (PSS-10)** (`StressQuestionnaires.fsh`)
   - Perceived Stress Scale
   - 10 validated items
   - Reverse-scored items indicated
   - Score interpretation guide

3. **Physical Activity (IPAQ-Short)** (`PhysicalActivityQuestionnaires.fsh`)
   - International Physical Activity Questionnaire
   - Vigorous, moderate, walking assessment
   - Sitting time tracking
   - MET-minutes calculation support

4. **Fatigue Assessment (FSS)** (`FatigueQuestionnaires.fsh`)
   - Fatigue Severity Scale
   - 9-item validated scale
   - Clinical interpretation threshold (≥4)
   - Impact on daily functioning

#### New CodeSystems (18 CodeSystems)
- CyclingMetricsCS, CyclingTrainingZoneCS, CyclingActivityTypeCS
- RunningMetricsCS, FootstrikeTypeCS, InjuryRiskLevelCS
- SwimmingMetricsCS, SwimmingStrokeTypeCS, SwimmingEnvironmentCS
- StrengthTrainingCS, ExerciseCategoryCS, MuscleGroupCS
- StrengthEquipmentCS, SetTypeCS, StrengthTrainingTypeCS
- CGMMetricsCS, RecoveryMetricsCS, VO2maxMetricsCS

#### New ValueSets (17 ValueSets)
- CyclingTrainingZoneVS, CyclingActivityTypeVS
- FootstrikeTypeVS, InjuryRiskLevelVS
- SwimmingStrokeTypeVS, SwimmingEnvironmentVS
- ExerciseCategoryVS, MuscleGroupVS, StrengthEquipmentVS
- SetTypeVS, StrengthTrainingTypeVS
- CGMTrendArrowVS, CGMSystemVS, CGMInsertionSiteVS
- ReadinessCategoryVS, TrainingStatusVS, CRFCategoryVS

#### New ConceptMap
- **ConceptMapHRVToOMOP** (`ConceptMapHRVToOMOP.fsh`)
  - LOINC 80404-7 → OMOP concept_id 37547368 (VERIFIED)
  - Documents RMSSD, pNN50, LF/HF gaps (concept_id = 0)
  - ETL implementation guidance
  - Unit concept_id references

### Changed
- Updated IG statistics:
  - Profiles: 54 → 56 (+2)
  - CodeSystems: 82 → 100 (+18)
  - ValueSets: 94 → 111 (+17)
  - Instances: 111 → 116 (+5)
  - Total resources: 384 → 426 (+42)

### Alignment with Thesis
- RS4 finding integrated: ZERO HRV-OMOP transformations documented in 354 papers
- Verified OMOP concept_id 37547368 for SDNN via Athena
- Addressed 29-profile gap between openEHR archetypes (57) and FHIR profiles

### Technical Notes
- All new resources validated with SUSHI: 0 Errors, 0 Warnings
- Compatible with FHIR R4 (4.0.1)
- Compatible with IPS (2.0.0)
- UCUM units properly referenced throughout

### References
- Buysse DJ et al. The Pittsburgh Sleep Quality Index. Psychiatry Research 1989
- Cohen S et al. A global measure of perceived stress. J Health Soc Behav 1983
- Craig CL et al. International Physical Activity Questionnaire. Med Sci Sports Exerc 2003
- Krupp LB et al. The Fatigue Severity Scale. Arch Neurol 1989
- Battelino T et al. Clinical Targets for CGM Data Interpretation. Diabetes Care 2019
