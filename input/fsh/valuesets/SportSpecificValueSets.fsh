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
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: CyclingActivityTypeVS
Id: cycling-activity-type-vs
Title: "Cycling Activity Type ValueSet"
Description: "Types of cycling activities"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cycling-activity-type-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


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
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: InjuryRiskLevelVS
Id: injury-risk-level-vs
Title: "Injury Risk Level ValueSet"
Description: "Running injury risk levels based on biomechanics"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/injury-risk-level-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


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
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: SwimmingEnvironmentVS
Id: swimming-environment-vs
Title: "Swimming Environment ValueSet"
Description: "Swimming venue types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/swimming-environment-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


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
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: MuscleGroupVS
Id: muscle-group-vs
Title: "Muscle Group ValueSet"
Description: "Primary muscle groups for strength training"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/muscle-group-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: StrengthEquipmentVS
Id: strength-equipment-vs
Title: "Strength Equipment ValueSet"
Description: "Strength training equipment types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/strength-equipment-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: SetTypeVS
Id: set-type-vs
Title: "Set Type ValueSet"
Description: "Strength training set types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/set-type-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS


ValueSet: StrengthTrainingTypeVS
Id: strength-training-type-vs
Title: "Strength Training Type ValueSet"
Description: "Strength training goal types"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/strength-training-type-vs"
* ^status = #active
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS
