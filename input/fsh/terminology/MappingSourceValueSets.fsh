// =============================================================================
// ValueSets for ConceptMap Source Scope
// =============================================================================
// Created: 2026-01-15
// Purpose: Wrapper ValueSets for ConceptMap sourceCanonical compliance
// Background: FHIR R4 IG Publisher (2025-12-31+) validates ConceptMap.source
//             must reference a ValueSet, not a CodeSystem directly.
// =============================================================================

// -----------------------------------------------------------------------------
// Nutrition Mapping Source ValueSet (nutrition-cs only)
// -----------------------------------------------------------------------------
// Pattern: Explicit code enumeration (HL7 Physical Activity IG pattern)
ValueSet: NutritionMappingSourceVS
Id: nutrition-mapping-source-vs
Title: "Nutrition Mapping Source ValueSet"
Description: """
Wrapper ValueSet including all nutrition concepts for ConceptMap source scope.

**Pattern Used**: Explicit code enumeration per HL7 Physical Activity IG.
"""
* ^experimental = false
* ^version = "0.1.0"
// NutritionCS - Macronutrients (6 codes)
* NutritionCS#caloric-intake "Caloric intake"
* NutritionCS#protein-intake "Protein intake"
* NutritionCS#carbohydrate-intake "Carbohydrate intake"
* NutritionCS#fat-intake "Fat intake"
* NutritionCS#fiber-intake "Fiber intake"
* NutritionCS#saturated-fat "Saturated fat intake"
// NutritionCS - Hydration (2 codes)
* NutritionCS#fluid-intake "Fluid intake"
* NutritionCS#water-intake "Water intake"
// NutritionCS - Specific nutrients (1 code)
* NutritionCS#sodium-intake "Sodium intake"
// NutritionCS - Dietary patterns (4 codes)
* NutritionCS#diet-quality-score "Diet quality score"
* NutritionCS#meal-frequency "Meal frequency"
* NutritionCS#caffeine-intake "Caffeine intake"
* NutritionCS#intermittent-fasting "Intermittent fasting pattern"

// -----------------------------------------------------------------------------
// Nutrition Complete Mapping Source ValueSet (nutrition-cs + micronutrient-cs)
// -----------------------------------------------------------------------------
// Pattern: Explicit code enumeration (HL7 Physical Activity IG pattern)
ValueSet: NutritionCompleteMappingSourceVS
Id: nutrition-complete-mapping-source-vs
Title: "Nutrition Complete Mapping Source ValueSet"
Description: """
Combined ValueSet including both nutrition and micronutrient concepts.

**Pattern Used**: Explicit code enumeration per HL7 Physical Activity IG.
"""
* ^experimental = false
* ^version = "0.1.0"
// NutritionCS (13 codes)
* NutritionCS#caloric-intake "Caloric intake"
* NutritionCS#protein-intake "Protein intake"
* NutritionCS#carbohydrate-intake "Carbohydrate intake"
* NutritionCS#fat-intake "Fat intake"
* NutritionCS#fiber-intake "Fiber intake"
* NutritionCS#saturated-fat "Saturated fat intake"
* NutritionCS#fluid-intake "Fluid intake"
* NutritionCS#water-intake "Water intake"
* NutritionCS#sodium-intake "Sodium intake"
* NutritionCS#diet-quality-score "Diet quality score"
* NutritionCS#meal-frequency "Meal frequency"
* NutritionCS#caffeine-intake "Caffeine intake"
* NutritionCS#intermittent-fasting "Intermittent fasting pattern"
// MicronutrientCS - Vitamins (6 codes)
* MicronutrientCS#vitamin-d-intake "Vitamin D intake"
* MicronutrientCS#vitamin-c-intake "Vitamin C intake"
* MicronutrientCS#vitamin-a-intake "Vitamin A intake"
* MicronutrientCS#vitamin-e-intake "Vitamin E intake"
* MicronutrientCS#vitamin-b12-intake "Vitamin B12 intake"
* MicronutrientCS#folate-intake "Folate intake"
// MicronutrientCS - Minerals (6 codes)
* MicronutrientCS#calcium-intake "Calcium intake"
* MicronutrientCS#iron-intake "Iron intake"
* MicronutrientCS#sodium-intake "Sodium intake"
* MicronutrientCS#potassium-intake "Potassium intake"
* MicronutrientCS#magnesium-intake "Magnesium intake"
* MicronutrientCS#zinc-intake "Zinc intake"

// -----------------------------------------------------------------------------
// Micronutrient Mapping Source ValueSet
// -----------------------------------------------------------------------------
// Pattern: Explicit code enumeration (HL7 Physical Activity IG pattern)
ValueSet: MicronutrientMappingSourceVS
Id: micronutrient-mapping-source-vs
Title: "Micronutrient Mapping Source ValueSet"
Description: """
Wrapper ValueSet including all micronutrient concepts for ConceptMap source scope.

**Pattern Used**: Explicit code enumeration per HL7 Physical Activity IG.
"""
* ^experimental = false
* ^version = "0.1.0"
// Vitamins (6 codes)
* MicronutrientCS#vitamin-d-intake "Vitamin D intake"
* MicronutrientCS#vitamin-c-intake "Vitamin C intake"
* MicronutrientCS#vitamin-a-intake "Vitamin A intake"
* MicronutrientCS#vitamin-e-intake "Vitamin E intake"
* MicronutrientCS#vitamin-b12-intake "Vitamin B12 intake"
* MicronutrientCS#folate-intake "Folate intake"
// Minerals (6 codes)
* MicronutrientCS#calcium-intake "Calcium intake"
* MicronutrientCS#iron-intake "Iron intake"
* MicronutrientCS#sodium-intake "Sodium intake"
* MicronutrientCS#potassium-intake "Potassium intake"
* MicronutrientCS#magnesium-intake "Magnesium intake"
* MicronutrientCS#zinc-intake "Zinc intake"

// -----------------------------------------------------------------------------
// Social Connection Mapping Source ValueSet - REMOVED (2026-01-16)
// -----------------------------------------------------------------------------
// REMOVAL REASON:
// 1. Orphan ValueSet - not referenced by any ConceptMap
// 2. Caused tx.fhir.org error: "CodeSystem not found" for local CodeSystems
// 3. ConceptMapSocialToLOINC now uses group.source/target pattern instead
// 4. LOINC codes exist for UCLA/MOS-SSS - use directly
//
// PLAN: After web search for terminologies, decide if local CodeSystems needed
// for MSPSS subscales (potential GAPs: family-support, friend-support, significant-other-support)
// -----------------------------------------------------------------------------
