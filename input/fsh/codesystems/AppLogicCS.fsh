// =============================================================================
// APP LOGIC CODE SYSTEM
// =============================================================================
// Date: 2026-02-27
// Purpose: Application-level codes for the iOS Lifestyle Medicine app that are
//          NOT clinical terminology. These represent UI/UX choices, equipment
//          catalogues, training methodologies, and device form factors.
// Context: Relocated from LifestyleMedicineTemporaryCS orphan analysis.
//          These codes are permanent app-level concepts, not "temporary pending
//          LOINC/SNOMED". Naming them correctly avoids the false implication
//          that they will be proposed to standards organisations.
// Reference: ORPHAN_TRACK_A_STANDARD_EQUIVALENTS.md
// Note: Where SNOMED equivalents exist (e.g., muscle groups), ConceptMaps
//       should be created to link these app codes to standard body structures.
// =============================================================================

CodeSystem: AppLogicCS
Id: app-logic-cs
Title: "Application Logic Codes"
Description: """
Application-level codes for the iOS Lifestyle Medicine app covering:
- Exercise equipment types
- Wearable device form factors
- CGM device models/brands
- Muscle group targets (with SNOMED Body Structure equivalents)
- Exercise classification categories
- Training set types
- Cycling disciplines and training zones
- Swimming environments
- Training periodisation status
- Running gait analysis (footstrike)

These are operational codes for app functionality, not clinical terminology.
Standard equivalents are noted in comments where they exist (e.g., SNOMED
Body Structure codes for muscle groups). ConceptMaps link these to standards.
"""
* ^status = #active
* ^experimental = false
* ^content = #complete
* ^version = "1.0.0"
* ^date = "2026-02-27"
* ^caseSensitive = true

// ============================================================================
// EXERCISE EQUIPMENT (11 codes)
// SNOMED coverage: 1/11 exact (Smith Machine = 467891002)
// ============================================================================
* #barbell "Barbell" "Free weight barbell for compound exercises"
  // Closest SNOMED: 462529009 "Hand-held free weight exerciser" (broader)
* #dumbbell "Dumbbell" "Free weight dumbbell for unilateral exercises"
  // Closest SNOMED: 462529009 "Hand-held free weight exerciser" (broader)
* #kettlebell "Kettlebell" "Cast-iron weight for ballistic exercises"
* #bands "Resistance Bands" "Elastic resistance bands for variable resistance"
* #cable "Cable Machine" "Pulley-cable weight machine"
  // Closest SNOMED: 464252006 "Upper-limb mechanical weight exerciser, lever/pulley-cable"
* #bodyweight "Bodyweight" "Bodyweight-only exercises (no equipment)"
* #plate-loaded "Plate-Loaded Machine" "Machine loaded with weight plates"
* #selectorized "Selectorized Machine" "Machine with pin-selectable weight stack"
* #smart-gym "Smart Gym" "Connected smart gym equipment with digital tracking"
* #smith "Smith Machine" "Fixed barbell on vertical guide rails"
  // SNOMED EXACT: 467891002 "Constrained-barbell exerciser"
* #suspension "TRX/Suspension" "Suspension training system (bodyweight on straps)"

// ============================================================================
// WEARABLE DEVICE FORM FACTORS (10 codes)
// SNOMED coverage: 1/10 exact (pulse-oximeter = 448703006)
// ============================================================================
* #smartwatch "Smartwatch" "Wrist-worn smartwatch with health sensors"
* #fitness-tracker "Fitness Tracker" "Activity tracking band or wristband"
* #chest-strap "Chest Strap" "Chest-mounted heart rate monitor strap"
* #smart-ring "Smart Ring" "Ring-form wearable with health sensors"
* #smart-patch "Smart Patch" "Adhesive skin-mounted health sensor patch"
* #smart-clothing "Smart Clothing" "Garments with integrated health sensors"
* #cgm-device "CGM Device" "Continuous glucose monitoring device"
* #ecg-accessory "ECG Accessory" "External ECG recording accessory"
  // Closest SNOMED: 1141657005 "Electrocardiographic electrode"
* #pulse-oximeter "Pulse Oximeter" "Standalone pulse oximetry device"
  // SNOMED EXACT: 448703006 "Pulse oximeter"
* #mobile-app-sensor "Mobile App Sensor" "Smartphone-based sensor (camera PPG, microphone)"

// ============================================================================
// CGM DEVICE MODELS (14 codes)
// SNOMED coverage: 0/14 (brand names — use UDI for device identification)
// ============================================================================
* #dexcom-g6 "Dexcom G6" "Dexcom G6 CGM system"
* #dexcom-g7 "Dexcom G7" "Dexcom G7 CGM system"
* #dexcom-one "Dexcom ONE" "Dexcom ONE CGM system"
* #libre-2 "FreeStyle Libre 2" "Abbott FreeStyle Libre 2 CGM"
* #libre-3 "FreeStyle Libre 3" "Abbott FreeStyle Libre 3 CGM"
* #guardian-4 "Medtronic Guardian 4" "Medtronic Guardian Sensor 4"
* #eversense "Eversense" "Senseonics Eversense implantable CGM"
* #stelo "Stelo" "Dexcom Stelo over-the-counter CGM"
* #lingo "Lingo" "Abbott Lingo biosensor"
* #levels "Levels" "Levels Health CGM programme"
* #nutrisense "Nutrisense" "Nutrisense CGM wellness programme"
* #supersapiens "Supersapiens" "Supersapiens athletic glucose platform"
* #veri "Veri" "Veri metabolic health CGM"
* #cgm-system-other "Other" "Other CGM system not listed"

// ============================================================================
// MUSCLE GROUPS (14 codes)
// SNOMED coverage: 13/14 exact (Body Structure domain)
// ConceptMap recommended: AppLogicToSNOMEDBodyStructure
// ============================================================================
* #quadriceps "Quadriceps" "Quadriceps femoris muscle group"
  // SNOMED EXACT: 21989003 "Structure of quadriceps femoris muscle"
* #hamstrings "Hamstrings" "Hamstring muscle group (posterior thigh)"
  // SNOMED EXACT: 699984008 "Hamstring muscle and/or tendon structure"
* #glutes "Glutes" "Gluteal muscle group"
  // SNOMED EXACT: 206007 "Structure of gluteus maximus muscle"
* #calves "Calves" "Calf muscle group (gastrocnemius + soleus)"
  // SNOMED EXACT: 53840002 "Structure of calf of leg"
* #chest "Chest" "Pectoral muscle group"
  // SNOMED EXACT: 372074006 "Skeletal muscle structure of chest wall"
* #back "Back" "Back musculature (latissimus dorsi, rhomboids)"
  // SNOMED EXACT: 77568009 "Structure of back of trunk"
* #shoulders "Shoulders" "Deltoid and rotator cuff muscles"
  // SNOMED EXACT: 102288007 "Structure of skeletal muscle of shoulder"
* #biceps "Biceps" "Biceps brachii"
  // SNOMED EXACT: 265802004 "Entire biceps brachii"
* #triceps "Triceps" "Triceps brachii"
  // SNOMED EXACT: 181623009 "Entire triceps brachii"
* #forearms "Forearms" "Forearm musculature"
  // SNOMED EXACT: 423313009 "Structure of muscle of forearm"
* #traps "Trapezius" "Trapezius muscle"
  // SNOMED EXACT: 31764008 "Structure of trapezius muscle"
* #erector "Erector Spinae" "Erector spinae muscle group"
  // SNOMED EXACT: 44947003 "Structure of erector spinae muscle"
* #hip-flexors "Hip Flexors" "Iliopsoas and hip flexor complex"
  // SNOMED EXACT: 68455001 "Structure of iliopsoas muscle"
* #muscle-group-core "Core" "Core musculature (abs, obliques, lower back, pelvic floor)"
  // NO SNOMED: Composite fitness concept — no single anatomy code

// ============================================================================
// EXERCISE CLASSIFICATION (9 codes)
// SNOMED coverage: 0/9 (sport science classification)
// ============================================================================
* #compound-full "Compound - Full Body" "Multi-joint exercise engaging full body"
* #compound-lower "Compound - Lower Body" "Multi-joint exercise for lower body"
* #compound-pull "Compound - Upper Body Pull" "Multi-joint pulling exercise"
* #compound-push "Compound - Upper Body Push" "Multi-joint pushing exercise"
* #exercise-core "Core/Abdominal" "Core-focused exercise"
* #isolation-lower "Isolation - Lower Body" "Single-joint lower body exercise"
* #isolation-upper "Isolation - Upper Body" "Single-joint upper body exercise"
* #olympic "Olympic Lift" "Olympic weightlifting movement (snatch, clean & jerk)"
* #plyometric "Plyometric" "Explosive jump/bound exercise"

// ============================================================================
// TRAINING SET TYPES (9 codes)
// SNOMED coverage: 0/9 (strength training methodology)
// ============================================================================
* #working "Working Set" "Primary working set at prescribed intensity"
* #warmup "Warm-up" "Warm-up set at reduced intensity"
* #top "Top Set" "Heaviest set in a session"
* #backoff "Back-off Set" "Reduced-weight set after top set"
* #drop "Drop Set" "Consecutive sets with decreasing weight, no rest"
* #rest-pause "Rest-Pause" "Brief rest (10-20s) within a set"
* #cluster "Cluster Set" "Set broken into mini-sets with intra-set rest"
* #failure "Failure Set" "Set performed to muscular failure"
* #amrap "AMRAP" "As Many Reps As Possible within time or until failure"

// ============================================================================
// CYCLING DISCIPLINES (8 codes)
// SNOMED coverage: 0/8 (only generic 54391000087108 "Cycling")
// ============================================================================
* #road "Road Cycling" "Road cycling on paved surfaces"
* #mtb "Mountain Biking" "Off-road mountain biking"
* #gravel "Gravel Riding" "Mixed-surface gravel cycling"
* #tt "Time Trial" "Individual time trial discipline"
* #cx "Cyclocross" "Cyclocross racing"
* #commute "Commuting" "Bicycle commuting"
* #cycling-type-indoor "Indoor Training" "Indoor cycling (trainer/rollers)"
* #virtual "Virtual Cycling" "Virtual cycling platform (Zwift, etc.)"

// ============================================================================
// CYCLING TRAINING ZONES (7 codes)
// Related LOINC: 74008-4 "Exercise intensity" (broader — 3 levels vs 7 zones)
// ============================================================================
* #zone1 "Zone 1 - Active Recovery" "Very low intensity (< 55% FTP)"
* #zone2 "Zone 2 - Endurance" "Low intensity (56-75% FTP)"
* #zone3 "Zone 3 - Tempo" "Moderate intensity (76-90% FTP)"
* #zone4 "Zone 4 - Threshold" "High intensity (91-105% FTP)"
* #zone5 "Zone 5 - VO2max" "Very high intensity (106-120% FTP)"
* #zone6 "Zone 6 - Anaerobic" "Anaerobic capacity (> 120% FTP)"
* #zone7 "Zone 7 - Neuromuscular" "Maximal sprint efforts"

// ============================================================================
// SWIMMING ENVIRONMENTS (7 codes)
// SNOMED coverage: 0/7 (only generic 20461001 "Swimming")
// ============================================================================
* #pool-25 "Pool (Short Course 25m)" "25-metre indoor swimming pool"
* #pool-50 "Pool (Long Course 50m)" "50-metre indoor swimming pool"
* #pool-other "Pool (Other Length)" "Swimming pool of non-standard length"
* #endless "Endless Pool" "Stationary counter-current pool"
* #ow-lake "Open Water (Lake)" "Open water swimming in lake"
* #ow-ocean "Open Water (Ocean)" "Open water swimming in ocean"
* #ow-river "Open Water (River)" "Open water swimming in river"

// ============================================================================
// TRAINING PERIODISATION STATUS (7 codes)
// SNOMED coverage: 0/7 (sport science periodisation)
// ============================================================================
* #detraining "Detraining" "Loss of fitness from training cessation"
* #maintaining "Maintaining" "Maintenance phase — fitness stable"
* #productive "Productive" "Building phase — positive adaptations"
* #overreaching "Overreaching" "Short-term excessive training load"
* #peaking "Peaking" "Tapering toward competition peak"
* #training-status-recovery "Recovery" "Recovery phase between training blocks"
* #unproductive "Unproductive" "Training without positive adaptation"

// ============================================================================
// FOOTSTRIKE PATTERN (4 codes)
// SNOMED coverage: 0/4 (running gait analysis)
// ============================================================================
* #forefoot "Forefoot Strike" "Initial contact on forefoot (ball of foot)"
* #midfoot "Midfoot Strike" "Initial contact on midfoot"
* #heel "Heel Strike" "Initial contact on heel (rearfoot)"
* #variable "Variable Strike" "Inconsistent or alternating footstrike pattern"

// ============================================================================
// CATEGORY C: APP METADATA — Data Quality & Capture (relocated 2026-02-27)
// ============================================================================

// --- Assignment Status (5 codes) ---
// Terminology governance metadata
* #mapped "Mapped" "This concept has been mapped to an equivalent code in a standard terminology (LOINC, SNOMED CT, etc.)"
* #pending-loinc "Pending LOINC Assignment" "This concept is awaiting assignment of a LOINC code. A submission may be in progress or planned."
* #pending-snomed "Pending SNOMED CT Assignment" "This concept is awaiting assignment of a SNOMED CT concept identifier."
* #local-only "Local Only" "This concept is intentionally local and no standard terminology equivalent is expected or needed."
* #deprecated "Deprecated" "This concept has been deprecated. A replacement concept may be available in the standard terminology."

// --- Data Capture Method (5 codes) ---
// FHIR alternative: Observation.method or Provenance resource
* #automatic "Automatic" "Data captured automatically by device"
* #manual-entry "Manual Entry" "Data manually entered by user"
* #derived "Derived" "Data calculated/derived from other measurements"
* #synchronized "Synchronized" "Data synchronized from another system"
* #imported "Imported" "Data imported from external source"

// --- Data Quality (4 codes) ---
// FHIR alternative: Observation.dataAbsentReason or quality extensions
* #data-quality-high "High Confidence" "High confidence in data accuracy and completeness"
  // Renamed from DataQualityConfidenceCS#high (collision resolution)
* #data-quality-medium "Medium Confidence" "Medium confidence with minor data gaps"
  // Renamed from DataQualityConfidenceCS#medium (collision resolution)
* #data-quality-low "Low Confidence" "Low confidence due to significant data gaps"
  // Renamed from DataQualityConfidenceCS#low (collision resolution)
* #data-quality-unreliable "Unreliable" "Data unreliable due to sensor issues or artifacts"
  // Renamed from DataQualityConfidenceCS#unreliable (collision resolution)

// --- Measurement Quality (5 codes) ---
* #measurement-quality-excellent "Excellent Quality" "Signal quality excellent, all parameters within optimal ranges"
  // Renamed from MeasurementQualityCS#excellent (collision resolution)
* #measurement-quality-good "Good Quality" "Signal quality good, minor artifacts present"
  // Renamed from MeasurementQualityCS#good (collision resolution)
* #measurement-quality-fair "Fair Quality" "Signal quality fair, some data segments may be unreliable"
  // Renamed from MeasurementQualityCS#fair (collision resolution)
* #measurement-quality-poor "Poor Quality" "Signal quality poor, significant artifacts"
  // Renamed from MeasurementQualityCS#poor (collision resolution)
* #measurement-quality-unreliable "Unreliable" "Signal quality unreliable, data should not be used clinically"
  // Renamed from MeasurementQualityCS#unreliable (collision resolution)

// --- Validation Status (5 codes) ---
* #validation-clinical "Clinically Validated" "Algorithm validated in clinical studies"
  // Renamed from ValidationStatusCS#clinical (collision resolution)
* #research "Research Validated" "Algorithm validated in research settings"
* #manufacturer "Manufacturer Validated" "Algorithm validated by manufacturer only"
* #not-validated "Not Validated" "Algorithm not independently validated"
* #validation-unknown "Unknown" "Validation status unknown"
  // Renamed from ValidationStatusCS#unknown (collision resolution)

// --- Audit Formats (3 codes) ---
* #audit-formats-text "Text Format"
  // Renamed from AuditFormatsCodeSystem#text (collision resolution)
* #structured "Structured Format"
* #audit-formats-mixed "Mixed Format"
  // Renamed from AuditFormatsCodeSystem#mixed (collision resolution)

// --- Audit Levels (3 codes) ---
* #audit-levels-low "Low Level"
  // Renamed from AuditLevelsCodeSystem#low (collision resolution)
* #audit-levels-medium "Medium Level"
  // Renamed from AuditLevelsCodeSystem#medium (collision resolution)
* #audit-levels-high "High Level"
  // Renamed from AuditLevelsCodeSystem#high (collision resolution)

// --- Baseline Comparison (3 codes) ---
* #above "Above Baseline" "Currently above personal baseline"
* #at "At Baseline" "Currently at personal baseline"
* #below "Below Baseline" "Currently below personal baseline"

// --- Nutrition Data Source (4 codes) ---
* #manual "Manual Entry" "Data entered manually by user"
* #nutrition-source-app "App Integration" "Data imported from connected nutrition app"
  // Renamed from NutritionDataSourceCS#app (collision resolution)
* #nutrition-source-device "Connected Device" "Data from connected smart scale or device"
  // Renamed from NutritionDataSourceCS#device (collision resolution)
* #questionnaire "Questionnaire Response" "Data from structured questionnaire"

// --- Time of Day (2 codes) ---
// FHIR alternative: http://hl7.org/fhir/event-timing (AFT, EVE, NIGHT)
* #time-of-day-evening "Evening" "Evening time period"
  // Renamed from TimeOfDayCS#evening (collision resolution)
* #time-of-day-afternoon "Afternoon" "Afternoon time period"
  // Renamed from TimeOfDayCS#afternoon (collision resolution)

// --- Symptom Progression (1 code) ---
// Closest SNOMED: 255299009 "Fluctuating course"
* #fluctuating "Fluctuating" "Symptom severity varies over time"

// ============================================================================
// CATEGORY C: APP METADATA — Environmental Context (relocated 2026-02-27)
// ============================================================================

// --- Environment Type (4 codes) ---
* #environment-type-indoor "Indoor" "Indoor environment"
  // Renamed from EnvironmentTypeCS#indoor (collision resolution)
* #environment-type-outdoor "Outdoor" "Outdoor environment"
  // Renamed from EnvironmentTypeCS#outdoor (collision resolution)
* #quiet "Quiet Space" "Quiet or silent environment"
* #environment-type-group "Group Setting" "Group practice environment"
  // Renamed from EnvironmentTypeCS#group (collision resolution)

// --- Environmental Context (8 codes) ---
// Closest SNOMED: 272133006 "Home environment"
* #environment-indoor "Indoor" "Indoor controlled environment"
  // Renamed from EnvironmentalContextCS#indoor (collision resolution)
* #environment-outdoor "Outdoor" "Outdoor environment"
  // Renamed from EnvironmentalContextCS#outdoor (collision resolution)
* #environment-urban "Urban" "Urban environment"
  // Renamed from EnvironmentalContextCS#urban (collision resolution)
* #environment-rural "Rural" "Rural environment"
  // Renamed from EnvironmentalContextCS#rural (collision resolution)
* #environment-workplace "Workplace" "Workplace environment"
  // Renamed from EnvironmentalContextCS#workplace (collision resolution)
* #environment-home "Home" "Home environment"
  // Renamed from EnvironmentalContextCS#home (collision resolution)
* #healthcare-facility "Healthcare Facility" "Hospital, clinic, or healthcare setting"
* #environment-recreational "Recreational" "Park, gym, or recreational setting"
  // Renamed from EnvironmentalContextCS#recreational (collision resolution)

// --- Exposure Location (7 codes) ---
* #exposure-location-indoor "Indoor environment" "Exposure occurred indoors"
  // Renamed from ExposureLocationCS#indoor (collision resolution)
* #exposure-location-outdoor "Outdoor environment" "Exposure occurred outdoors"
  // Renamed from ExposureLocationCS#outdoor (collision resolution)
* #exposure-location-workplace "Workplace" "Exposure at workplace"
  // Renamed from ExposureLocationCS#workplace (collision resolution)
* #transit "In transit" "Exposure during commute or travel"
* #exposure-location-recreational "Recreational area" "Exposure in recreational setting"
  // Renamed from ExposureLocationCS#recreational (collision resolution)
* #exposure-location-urban "Urban area" "Exposure in urban environment"
  // Renamed from ExposureLocationCS#urban (collision resolution)
* #exposure-location-rural "Rural area" "Exposure in rural environment"
  // Renamed from ExposureLocationCS#rural (collision resolution)

// --- Exposure Conditions (4 codes) ---
* #exposure-conditions-normal "Normal conditions" "Normal environmental conditions"
  // Renamed from ExposureConditionsCS#normal (collision resolution)
* #exposure-conditions-extreme "Extreme conditions" "Extreme environmental conditions"
  // Renamed from ExposureConditionsCS#extreme (collision resolution)
* #controlled "Controlled environment" "Controlled/laboratory environment"
* #app-logic-variable "Variable conditions" "Variable environmental conditions"

// --- Vitals Context (5 codes) ---
// FHIR alternative: Observation.category or component qualifiers
* #resting "Resting state" "Measurement taken during rest"
* #vitals-context-active "Active state" "Measurement taken during physical activity"
  // Renamed from AdvancedVitalSignsContextCS#active (collision resolution)
* #vitals-context-recovery "Recovery state" "Measurement taken during post-exercise recovery"
  // Renamed from AdvancedVitalSignsContextCS#recovery (collision resolution)
* #activity "Sleep state" "Measurement taken during activity"
* #vitals-context-stress "Stress state" "Measurement taken during stress conditions"
  // Renamed from AdvancedVitalSignsContextCS#stress (collision resolution)

// ============================================================================
// CATEGORY D: QUALIFICATION SCALES (relocated 2026-02-27)
// Repeating ordinal patterns — domain-specific clinical scales
// FHIR alternative: ObservationInterpretation (N/L/H/HH/LL) for some
// ============================================================================

// --- Caffeine Level (5 codes) ---
* #caffeine-level-none "None" "No caffeine intake (0mg/day)"
  // Renamed from CaffeineIntakeLevelCS#none (collision resolution)
* #caffeine-level-low "Low" "Low caffeine intake (<100mg/day)"
  // Renamed from CaffeineIntakeLevelCS#low (collision resolution)
* #caffeine-level-moderate "Moderate" "Moderate caffeine intake (100-400mg/day)"
  // Renamed from CaffeineIntakeLevelCS#moderate (collision resolution)
* #caffeine-level-high "High" "High caffeine intake (>400mg/day)"
  // Renamed from CaffeineIntakeLevelCS#high (collision resolution)
* #excessive "Excessive" "Excessive caffeine intake (>600mg/day)"

// --- CV Risk Category (4 codes) ---
// FHIR alternative: ObservationInterpretation (N/A/H/HH)
* #cv-risk-low "Low Risk" "Low cardiovascular risk"
  // Renamed from CVRiskCategoryCS#low (collision resolution)
* #cv-risk-moderate "Moderate Risk" "Moderate cardiovascular risk"
  // Renamed from CVRiskCategoryCS#moderate (collision resolution)
* #cv-risk-high "High Risk" "High cardiovascular risk"
  // Renamed from CVRiskCategoryCS#high (collision resolution)
* #cv-risk-very-high "Very High Risk" "Very high cardiovascular risk"
  // Renamed from CVRiskCategoryCS#very-high (collision resolution)

// --- Injury Risk (4 codes) ---
* #injury-risk-low "Low Risk" "Low risk of exercise-related injury"
  // Renamed from InjuryRiskLevelCS#low (collision resolution)
* #injury-risk-moderate "Moderate Risk" "Moderate risk of injury"
  // Renamed from InjuryRiskLevelCS#moderate (collision resolution)
* #injury-risk-elevated "Elevated Risk" "Elevated risk of injury"
  // Renamed from InjuryRiskLevelCS#elevated (collision resolution)
* #injury-risk-high "High Risk" "High risk of injury"
  // Renamed from InjuryRiskLevelCS#high (collision resolution)

// --- Isolation Level (5 codes) ---
* #negligible "Negligible Risk" "Negligible social isolation risk"
* #isolation-level-low "Low Risk" "Low social isolation risk"
  // Renamed from IsolationRiskLevelCS#low (collision resolution)
* #isolation-level-moderate "Moderate Risk" "Moderate social isolation risk"
  // Renamed from IsolationRiskLevelCS#moderate (collision resolution)
* #isolation-level-high "High Risk" "High social isolation risk"
  // Renamed from IsolationRiskLevelCS#high (collision resolution)
* #isolation-level-critical "Critical Risk" "Critical social isolation risk"
  // Renamed from IsolationRiskLevelCS#critical (collision resolution)

// --- Risk Level Generic (6 codes) ---
// FHIR alternative: ObservationInterpretation for most
* #risk-level-none "None" "No identified risk"
  // Renamed from RiskLevel#none (collision resolution)
* #risk-level-low "Low" "Low risk"
  // Renamed from RiskLevel#low (collision resolution)
* #risk-level-moderate "Moderate" "Moderate risk"
  // Renamed from RiskLevel#moderate (collision resolution)
* #risk-level-high "High" "High risk"
  // Renamed from RiskLevel#high (collision resolution)
* #risk-level-critical "Critical" "Critical risk"
  // Renamed from RiskLevel#critical (collision resolution)
* #risk-level-unknown "Unknown" "Risk level unknown"
  // Renamed from RiskLevel#unknown (collision resolution)

// --- Social Support (5 codes) ---
* #strong "Strong Support" "Strong social support network"
* #adequate "Adequate Support" "Adequate social support"
* #limited "Limited Support" "Limited social support"
* #social-support-minimal "Minimal Support" "Minimal social support"
  // Renamed from SocialSupportCS#minimal (collision resolution)
* #social-support-none "No Support" "No social support identified"
  // Renamed from SocialSupportCS#none (collision resolution)

// --- Social Support Level - MSPSS (5 codes) ---
* #social-support-level-very-high "Very High Support" "MSPSS mean 6.0-7.0"
  // Renamed from SocialSupportLevelCS#very-high (collision resolution)
* #social-support-level-high "High Support" "MSPSS mean 5.0-5.99"
  // Renamed from SocialSupportLevelCS#high (collision resolution)
* #social-support-level-moderate "Moderate Support" "MSPSS mean 4.0-4.99"
  // Renamed from SocialSupportLevelCS#moderate (collision resolution)
* #social-support-level-low "Low Support" "MSPSS mean 3.0-3.99"
  // Renamed from SocialSupportLevelCS#low (collision resolution)
* #social-support-level-very-low "Very Low Support" "MSPSS mean 1.0-2.99"
  // Renamed from SocialSupportLevelCS#very-low (collision resolution)

// --- Social Interaction Quality (5 codes) ---
* #social-interaction-quality-meaningful "Meaningful" "Deep, meaningful interaction"
  // Renamed from SocialInteractionQualityCS#meaningful (collision resolution)
* #supportive "Supportive" "Supportive, helpful interaction"
* #social-interaction-quality-neutral "Neutral" "Neutral, routine interaction"
  // Renamed from SocialInteractionQualityCS#neutral (collision resolution)
* #superficial "Superficial" "Superficial, surface-level interaction"
* #stressful "Stressful" "Stressful, negative interaction"

// --- Substance Risk (5 codes) ---
* #substance-risk-minimal "Minimal risk" "Minimal substance use risk"
  // Renamed from SubstanceUseRiskLevelCS#minimal (collision resolution)
* #substance-risk-low "Low risk" "Low substance use risk"
  // Renamed from SubstanceUseRiskLevelCS#low (collision resolution)
* #substance-risk-moderate "Moderate risk" "Moderate substance use risk"
  // Renamed from SubstanceUseRiskLevelCS#moderate (collision resolution)
* #substance-risk-high "High risk" "High substance use risk"
  // Renamed from SubstanceUseRiskLevelCS#high (collision resolution)
* #substance-risk-severe "Severe risk" "Severe substance use risk"
  // Renamed from SubstanceUseRiskLevelCS#severe (collision resolution)

// --- Stress Impact (5 codes) ---
* #stress-impact-minimal "Minimal Impact" "Stress has minimal impact on daily functioning"
  // Renamed from StressImpactCS#minimal (collision resolution)
* #stress-impact-mild "Mild Impact" "Stress has mild impact"
  // Renamed from StressImpactCS#mild (collision resolution)
* #stress-impact-moderate "Moderate Impact" "Stress moderately impacts daily activities"
  // Renamed from StressImpactCS#moderate (collision resolution)
* #stress-impact-severe "Severe Impact" "Stress severely impacts functioning"
  // Renamed from StressImpactCS#severe (collision resolution)
* #stress-impact-extreme "Extreme Impact" "Stress causes extreme impairment"
  // Renamed from StressImpactCS#extreme (collision resolution)

// --- Assistance Level (5 codes) ---
// Related: FIM (Functional Independence Measure) scale
* #independent "Independent" "Patient can perform activity independently without any assistance"
* #minimal-assist "Minimal Assistance" "Patient requires minimal assistance (supervision or verbal cueing only)"
* #moderate-assist "Moderate Assistance" "Patient requires moderate assistance (physical support for 25-50% of effort)"
* #maximal-assist "Maximal Assistance" "Patient requires maximal assistance (physical support for >50% of effort)"
* #dependent "Dependent" "Patient is fully dependent on others for the activity"
