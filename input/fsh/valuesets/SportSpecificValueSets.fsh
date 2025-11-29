// Sport-Specific ValueSets for iOS Lifestyle Medicine IG
// Supporting cycling, running, swimming, and strength training profiles
// Created: 2025-11-28
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
* include codes from system CyclingTrainingZoneCS


ValueSet: CyclingActivityTypeVS
Id: cycling-activity-type-vs
Title: "Cycling Activity Type ValueSet"
Description: "Types of cycling activities"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cycling-activity-type-vs"
* ^status = #active
* ^experimental = false
* include codes from system CyclingActivityTypeCS


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
* include codes from system FootstrikeTypeCS


ValueSet: InjuryRiskLevelVS
Id: injury-risk-level-vs
Title: "Injury Risk Level ValueSet"
Description: "Running injury risk levels based on biomechanics"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/injury-risk-level-vs"
* ^status = #active
* ^experimental = false
* include codes from system InjuryRiskLevelCS


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
* include codes from system SwimmingStrokeTypeCS


ValueSet: SwimmingEnvironmentVS
Id: swimming-environment-vs
Title: "Swimming Environment ValueSet"
Description: "Swimming venue types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/swimming-environment-vs"
* ^status = #active
* ^experimental = false
* include codes from system SwimmingEnvironmentCS


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
* include codes from system ExerciseCategoryCS


ValueSet: MuscleGroupVS
Id: muscle-group-vs
Title: "Muscle Group ValueSet"
Description: "Primary muscle groups for strength training"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/muscle-group-vs"
* ^status = #active
* ^experimental = false
* include codes from system MuscleGroupCS


ValueSet: StrengthEquipmentVS
Id: strength-equipment-vs
Title: "Strength Equipment ValueSet"
Description: "Strength training equipment types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/strength-equipment-vs"
* ^status = #active
* ^experimental = false
* include codes from system StrengthEquipmentCS


ValueSet: SetTypeVS
Id: set-type-vs
Title: "Set Type ValueSet"
Description: "Strength training set types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/set-type-vs"
* ^status = #active
* ^experimental = false
* include codes from system SetTypeCS


ValueSet: StrengthTrainingTypeVS
Id: strength-training-type-vs
Title: "Strength Training Type ValueSet"
Description: "Strength training goal types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/strength-training-type-vs"
* ^status = #active
* ^experimental = false
* include codes from system StrengthTrainingTypeCS


// ============================================================================
// SUPPORTING CODE SYSTEMS FOR VALUE SETS
// ============================================================================

CodeSystem: CyclingTrainingZoneCS
Id: cycling-training-zone-cs
Title: "Cycling Training Zone CodeSystem"
Description: "Coggan power-based training zones"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cycling-training-zone-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #zone1 "Zone 1 - Active Recovery" "<55% FTP - Active recovery, very easy"
* #zone2 "Zone 2 - Endurance" "55-75% FTP - Endurance/base training"
* #zone3 "Zone 3 - Tempo" "76-90% FTP - Moderate aerobic intensity"
* #zone4 "Zone 4 - Threshold" "91-105% FTP - Lactate threshold, race pace"
* #zone5 "Zone 5 - VO2max" "106-120% FTP - VO2max intervals"
* #zone6 "Zone 6 - Anaerobic" "121-150% FTP - Anaerobic capacity"
* #zone7 "Zone 7 - Neuromuscular" ">150% FTP - Neuromuscular power, sprints"


CodeSystem: CyclingActivityTypeCS
Id: cycling-activity-type-cs
Title: "Cycling Activity Type CodeSystem"
Description: "Types of cycling activities"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cycling-activity-type-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #road "Road Cycling" "Road bike riding"
* #mtb "Mountain Biking" "Off-road mountain biking"
* #gravel "Gravel Riding" "Mixed surface gravel riding"
* #tt "Time Trial" "Individual time trial"
* #indoor "Indoor Training" "Stationary trainer indoors"
* #virtual "Virtual Cycling" "Virtual cycling platform (Zwift, TrainerRoad)"
* #commute "Commuting" "Cycling commute"
* #cx "Cyclocross" "Cyclocross racing/training"


CodeSystem: FootstrikeTypeCS
Id: footstrike-type-cs
Title: "Footstrike Type CodeSystem"
Description: "Running footstrike patterns"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/footstrike-type-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #forefoot "Forefoot Strike" "Initial contact with forefoot"
* #midfoot "Midfoot Strike" "Initial contact with midfoot"
* #rearfoot "Rearfoot Strike" "Initial contact with heel (heel strike)"
* #mixed "Mixed/Variable" "Variable footstrike pattern"


CodeSystem: InjuryRiskLevelCS
Id: injury-risk-level-cs
Title: "Injury Risk Level CodeSystem"
Description: "Running injury risk levels"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/injury-risk-level-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #low "Low Risk" "Low injury risk based on biomechanics"
* #moderate "Moderate Risk" "Moderate injury risk"
* #elevated "Elevated Risk" "Elevated injury risk"
* #high "High Risk" "High injury risk - recommend gait analysis"


CodeSystem: SwimmingStrokeTypeCS
Id: swimming-stroke-type-cs
Title: "Swimming Stroke Type CodeSystem"
Description: "Swimming stroke types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/swimming-stroke-type-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #freestyle "Freestyle" "Front crawl stroke"
* #backstroke "Backstroke" "Back crawl stroke"
* #breaststroke "Breaststroke" "Breaststroke technique"
* #butterfly "Butterfly" "Butterfly stroke"
* #im "Individual Medley" "All four strokes in sequence"
* #mixed "Mixed/Drill" "Mixed strokes or drill work"
* #unknown "Unknown" "Stroke type not detected"


CodeSystem: SwimmingEnvironmentCS
Id: swimming-environment-cs
Title: "Swimming Environment CodeSystem"
Description: "Swimming venue types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/swimming-environment-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #pool-25 "Pool (Short Course 25m)" "25 meter pool"
* #pool-50 "Pool (Long Course 50m)" "50 meter Olympic pool"
* #pool-other "Pool (Other Length)" "Pool of non-standard length"
* #ow-lake "Open Water (Lake)" "Lake swimming"
* #ow-ocean "Open Water (Ocean)" "Ocean swimming"
* #ow-river "Open Water (River)" "River swimming"
* #endless "Endless Pool" "Swim-in-place endless pool"


CodeSystem: ExerciseCategoryCS
Id: exercise-category-cs
Title: "Exercise Category CodeSystem"
Description: "Strength exercise categories"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/exercise-category-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #compound-lower "Compound - Lower Body" "Multi-joint lower body (squat, deadlift)"
* #compound-push "Compound - Upper Body Push" "Multi-joint pushing (bench, OHP)"
* #compound-pull "Compound - Upper Body Pull" "Multi-joint pulling (row, pull-up)"
* #compound-full "Compound - Full Body" "Full body movement (clean, snatch)"
* #isolation-lower "Isolation - Lower Body" "Single-joint lower body"
* #isolation-upper "Isolation - Upper Body" "Single-joint upper body"
* #core "Core/Abdominal" "Core-focused exercise"
* #olympic "Olympic Lift" "Olympic weightlifting movement"
* #plyometric "Plyometric" "Explosive jumping/bounding"


CodeSystem: MuscleGroupCS
Id: muscle-group-cs
Title: "Muscle Group CodeSystem"
Description: "Primary muscle groups"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/muscle-group-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #quadriceps "Quadriceps" "Front of thigh"
* #hamstrings "Hamstrings" "Back of thigh"
* #glutes "Glutes" "Gluteal muscles"
* #calves "Calves" "Lower leg muscles"
* #chest "Chest" "Pectoralis muscles"
* #back "Back" "Latissimus dorsi and back muscles"
* #shoulders "Shoulders" "Deltoid muscles"
* #biceps "Biceps" "Front of upper arm"
* #triceps "Triceps" "Back of upper arm"
* #core "Core" "Abdominal and core muscles"
* #erector "Erector Spinae" "Lower back muscles"
* #traps "Trapezius" "Upper back/neck muscles"
* #forearms "Forearms" "Forearm muscles"
* #hip-flexors "Hip Flexors" "Hip flexor muscles"


CodeSystem: StrengthEquipmentCS
Id: strength-equipment-cs
Title: "Strength Equipment CodeSystem"
Description: "Strength training equipment types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/strength-equipment-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #barbell "Barbell" "Olympic or standard barbell"
* #dumbbell "Dumbbell" "Free weight dumbbells"
* #kettlebell "Kettlebell" "Kettlebell weights"
* #cable "Cable Machine" "Cable/pulley machine"
* #plate-loaded "Plate-Loaded Machine" "Machine with plate loading"
* #selectorized "Selectorized Machine" "Pin-select weight stack machine"
* #bands "Resistance Bands" "Elastic resistance bands"
* #bodyweight "Bodyweight" "No external load"
* #smith "Smith Machine" "Guided barbell machine"
* #suspension "TRX/Suspension" "Suspension training straps"
* #smart-gym "Smart Gym" "Digital resistance smart gym (Tonal, Tempo)"


CodeSystem: SetTypeCS
Id: set-type-cs
Title: "Set Type CodeSystem"
Description: "Strength training set types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/set-type-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #warmup "Warm-up" "Warm-up set at reduced intensity"
* #working "Working Set" "Standard working set at target intensity"
* #top "Top Set" "Heaviest set of the day"
* #backoff "Back-off Set" "Reduced load set after top set"
* #drop "Drop Set" "Immediate continuation with reduced weight"
* #rest-pause "Rest-Pause" "Brief rest within set to extend reps"
* #cluster "Cluster Set" "Intra-set rest between mini-sets"
* #amrap "AMRAP" "As Many Reps As Possible"
* #failure "Failure Set" "Set taken to muscular failure"


CodeSystem: StrengthTrainingTypeCS
Id: strength-training-type-cs
Title: "Strength Training Type CodeSystem"
Description: "Strength training goal types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/strength-training-type-cs"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #hypertrophy "Hypertrophy" "Muscle growth focus (moderate load, higher volume)"
* #strength "Strength" "Maximal strength focus (high load, lower volume)"
* #power "Power" "Explosive power focus (moderate load, high velocity)"
* #endurance "Muscular Endurance" "Endurance focus (lower load, high reps)"
* #fitness "General Fitness" "General conditioning"
* #rehab "Rehabilitation" "Injury rehabilitation or prehab"
* #functional "Functional Training" "Movement-pattern focused training"
