// Sport-Specific ValueSets for iOS Lifestyle Medicine IG
// Supporting cycling, running, swimming, and strength training profiles
// Created: 2025-11-28
// Updated: 2026-02-27 — Replaced bulk includes with enumerated codes
// Author: Ricardo Lourenco dos Santos, FMUP

Alias: $SNOMED = http://snomed.info/sct

// ============================================================================
// CYCLING VALUE SETS
// ============================================================================

ValueSet: CyclingTrainingZoneVS
Id: cycling-training-zone-vs
Title: "Cycling Training Zone ValueSet"
Description: "Coggan power-based training zones for cycling (7-zone model)"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cycling-training-zone-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#zone1 "Zone 1 - Active Recovery"
* AppLogicCS#zone2 "Zone 2 - Endurance"
* AppLogicCS#zone3 "Zone 3 - Tempo"
* AppLogicCS#zone4 "Zone 4 - Threshold"
* AppLogicCS#zone5 "Zone 5 - VO2max"
* AppLogicCS#zone6 "Zone 6 - Anaerobic"
* AppLogicCS#zone7 "Zone 7 - Neuromuscular"


ValueSet: CyclingActivityTypeVS
Id: cycling-activity-type-vs
Title: "Cycling Activity Type ValueSet"
Description: "Types of cycling activities"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cycling-activity-type-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#road "Road Cycling"
* AppLogicCS#mtb "Mountain Biking"
* AppLogicCS#gravel "Gravel Riding"
* AppLogicCS#tt "Time Trial"
* AppLogicCS#cx "Cyclocross"
* AppLogicCS#commute "Commuting"
* AppLogicCS#cycling-type-indoor "Indoor Training"
* AppLogicCS#virtual "Virtual Cycling"


// ============================================================================
// RUNNING VALUE SETS
// ============================================================================

ValueSet: FootstrikeTypeVS
Id: footstrike-type-vs
Title: "Footstrike Type ValueSet"
Description: "Running footstrike patterns"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/footstrike-type-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#forefoot "Forefoot Strike"
* AppLogicCS#midfoot "Midfoot Strike"
* AppLogicCS#heel "Heel Strike"
* AppLogicCS#variable "Variable Strike"


ValueSet: InjuryRiskLevelVS
Id: injury-risk-level-vs
Title: "Injury Risk Level ValueSet"
Description: "Running injury risk levels based on biomechanics"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/injury-risk-level-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#injury-risk-low "Low Risk"
* AppLogicCS#injury-risk-moderate "Moderate Risk"
* AppLogicCS#injury-risk-elevated "Elevated Risk"
* AppLogicCS#injury-risk-high "High Risk"


// ============================================================================
// SWIMMING VALUE SETS
// ============================================================================

ValueSet: SwimmingStrokeTypeVS
Id: swimming-stroke-type-vs
Title: "Swimming Stroke Type ValueSet"
Description: "Swimming stroke types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/swimming-stroke-type-vs"
* ^status = #active
* ^experimental = false
* LifestyleMedicineTemporaryCS#freestyle "Freestyle"
* LifestyleMedicineTemporaryCS#backstroke "Backstroke"
* LifestyleMedicineTemporaryCS#breaststroke "Breaststroke"
* LifestyleMedicineTemporaryCS#butterfly "Butterfly"
* LifestyleMedicineTemporaryCS#im "Individual Medley"
* LifestyleMedicineTemporaryCS#swimming-stroke-mixed "Mixed/Drill"
* LifestyleMedicineTemporaryCS#swimming-stroke-unknown "Unknown"


ValueSet: SwimmingEnvironmentVS
Id: swimming-environment-vs
Title: "Swimming Environment ValueSet"
Description: "Swimming venue types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/swimming-environment-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#pool-25 "Pool (Short Course 25m)"
* AppLogicCS#pool-50 "Pool (Long Course 50m)"
* AppLogicCS#pool-other "Pool (Other Length)"
* AppLogicCS#endless "Endless Pool"
* AppLogicCS#ow-lake "Open Water (Lake)"
* AppLogicCS#ow-ocean "Open Water (Ocean)"
* AppLogicCS#ow-river "Open Water (River)"


// ============================================================================
// STRENGTH TRAINING VALUE SETS
// ============================================================================

ValueSet: ExerciseCategoryVS
Id: exercise-category-vs
Title: "Exercise Category ValueSet"
Description: "Strength exercise categories"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/exercise-category-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#compound-full "Compound - Full Body"
* AppLogicCS#compound-lower "Compound - Lower Body"
* AppLogicCS#compound-pull "Compound - Upper Body Pull"
* AppLogicCS#compound-push "Compound - Upper Body Push"
* AppLogicCS#exercise-core "Core/Abdominal"
* AppLogicCS#isolation-lower "Isolation - Lower Body"
* AppLogicCS#isolation-upper "Isolation - Upper Body"
* AppLogicCS#olympic "Olympic Lift"
* AppLogicCS#plyometric "Plyometric"


ValueSet: MuscleGroupVS
Id: muscle-group-vs
Title: "Muscle Group ValueSet"
Description: "Primary muscle groups for strength training"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/muscle-group-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#quadriceps "Quadriceps"
* AppLogicCS#hamstrings "Hamstrings"
* AppLogicCS#glutes "Glutes"
* AppLogicCS#calves "Calves"
* AppLogicCS#chest "Chest"
* AppLogicCS#back "Back"
* AppLogicCS#shoulders "Shoulders"
* AppLogicCS#biceps "Biceps"
* AppLogicCS#triceps "Triceps"
* AppLogicCS#forearms "Forearms"
* AppLogicCS#traps "Trapezius"
* AppLogicCS#erector "Erector Spinae"
* AppLogicCS#hip-flexors "Hip Flexors"
* AppLogicCS#muscle-group-core "Core"


ValueSet: StrengthEquipmentVS
Id: strength-equipment-vs
Title: "Strength Equipment ValueSet"
Description: "Strength training equipment types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/strength-equipment-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#barbell "Barbell"
* AppLogicCS#dumbbell "Dumbbell"
* AppLogicCS#kettlebell "Kettlebell"
* AppLogicCS#bands "Resistance Bands"
* AppLogicCS#cable "Cable Machine"
* AppLogicCS#bodyweight "Bodyweight"
* AppLogicCS#plate-loaded "Plate-Loaded Machine"
* AppLogicCS#selectorized "Selectorized Machine"
* AppLogicCS#smart-gym "Smart Gym"
* AppLogicCS#smith "Smith Machine"
* AppLogicCS#suspension "TRX/Suspension"


ValueSet: SetTypeVS
Id: set-type-vs
Title: "Set Type ValueSet"
Description: "Strength training set types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/set-type-vs"
* ^status = #active
* ^experimental = false
* AppLogicCS#working "Working Set"
* AppLogicCS#warmup "Warm-up"
* AppLogicCS#top "Top Set"
* AppLogicCS#backoff "Back-off Set"
* AppLogicCS#drop "Drop Set"
* AppLogicCS#rest-pause "Rest-Pause"
* AppLogicCS#cluster "Cluster Set"
* AppLogicCS#failure "Failure Set"
* AppLogicCS#amrap "AMRAP"


ValueSet: StrengthTrainingTypeVS
Id: strength-training-type-vs
Title: "Strength Training Type ValueSet"
Description: "Strength training goal types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/strength-training-type-vs"
* ^status = #active
* ^experimental = false
* LifestyleMedicineTemporaryCS#hypertrophy "Hypertrophy"
* LifestyleMedicineTemporaryCS#strength "Strength"
* LifestyleMedicineTemporaryCS#strength-type-power "Power"
* LifestyleMedicineTemporaryCS#endurance "Muscular Endurance"
* LifestyleMedicineTemporaryCS#fitness "General Fitness"
* LifestyleMedicineTemporaryCS#rehab "Rehabilitation"
* LifestyleMedicineTemporaryCS#functional "Functional Training"
