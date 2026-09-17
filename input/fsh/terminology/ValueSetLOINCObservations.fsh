// ValueSet: LOINC Observation Codes for Lifestyle Medicine
// Created: 2024-11-21
// Purpose: Comprehensive LOINC codes for ConceptMap target mappings
// Scope: Heart rate variability, vital signs, anthropometrics, activity

ValueSet: LOINCObservationsVS
Id: loinc-observations-vs
Title: "LOINC Observation Codes for Lifestyle Medicine"
Description: "LOINC codes relevant for lifestyle medicine observations including HRV, vital signs, anthropometrics, and physical activity metrics. Used as target ValueSet in ConceptMaps for semantic interoperability."
* ^status = #active
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-09-17"

// ============================================================================
// HEART RATE VARIABILITY
// ============================================================================
* http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)" // SDNN - Only HRV code

// ============================================================================
// HEART RATE (BASIC)
// ============================================================================
* http://loinc.org#8867-4 "Heart rate"
* http://loinc.org#8889-8 "Heart rate by Pulse oximetry"  // CORRECTED 2026-02-11 (was 8893-0)
* http://loinc.org#40443-4 "Heart rate --resting"
* http://loinc.org#40442-6 "Heart rate --post exercise"
* http://loinc.org#8873-2 "Heart rate 24 hour maximum"    // CORRECTED 2026-02-11 (was 8889-8)
* http://loinc.org#41924-2 "Heart rate 24 hour mean"      // CORRECTED 2026-02-11 (was 8890-6)
* http://loinc.org#8883-1 "Heart rate 24 hour minimum"    // CORRECTED 2026-02-11 (was 8891-4)

// ============================================================================
// ECG/RHYTHM
// ============================================================================
// 2026-09-15: 8636-3 is Q-T interval corrected; the R-R interval code is 8637-1. Both kept, each under its own name.
* http://loinc.org#8637-1 "R-R interval by EKG"
* http://loinc.org#8636-3 "Q-T interval corrected"
// 2026-09-15: 8625-6 is P-R Interval; the Q-T interval code is 8634-8. Both kept, each under its own name.
* http://loinc.org#8634-8 "Q-T interval"
* http://loinc.org#8625-6 "P-R Interval"
* http://loinc.org#8633-0 "QRS duration in EKG"

// ============================================================================
// RESPIRATORY
// ============================================================================
* http://loinc.org#9279-1 "Respiratory rate"

// ============================================================================
// OXYGEN SATURATION
// ============================================================================
* http://loinc.org#2708-6 "Oxygen saturation in Arterial blood"
* http://loinc.org#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"

// ============================================================================
// PANELS
// ============================================================================
* http://loinc.org#85353-1 "Vital signs, weight, height, head circumference, oxygen saturation and BMI panel"

// ============================================================================
// ANTHROPOMETRICS
// ============================================================================
* http://loinc.org#29463-7 "Body weight"
* http://loinc.org#8302-2 "Body height"
* http://loinc.org#39156-5 "Body mass index (BMI) [Ratio]"
* http://loinc.org#8287-5 "Head Occipital-frontal circumference by Tape measure"

// ============================================================================
// PHYSICAL ACTIVITY
// ============================================================================
// 2026-09-15: the two step-count displays had been crossed; each code now carries its own name.
* http://loinc.org#55423-8 "Number of steps in unspecified time Pedometer"
* http://loinc.org#41950-7 "Number of steps in 24 hour Measured"

// ============================================================================
// SLEEP
// ============================================================================
// 2026-09-15: 93832-4 is Sleep duration, not sleep efficiency; sleep efficiency has no LOINC code (see Known Gaps).
* http://loinc.org#93832-4 "Sleep duration"
// 2026-09-15: the other sleep codes the sleep profile and ConceptMapSleepToLOINC use (this ValueSet is that map's target scope)
* http://loinc.org#103213-5 "Duration in bed"
* http://loinc.org#93831-6 "Deep sleep duration"
* http://loinc.org#93830-8 "Light sleep duration"
* http://loinc.org#103211-9 "Number of awakenings"
* http://loinc.org#90568-7 "Polysomnography panel"

// ============================================================================
// NUTRITION AND DIETARY INTAKE
// ============================================================================
* http://loinc.org#9052-2 "Caloric intake total"
// 2026-09-15: 9059-7 (Carbohydrate intake Estimated), 9057-1 (Calorie intake total 24 hour) and 9060-5
// (Carbohydrate intake Measured) had been listed as protein, carbohydrate and fat intake; replaced by the
// codes that carry those names. 9059-7 is kept under its own name (it is a vendor-map target).
* http://loinc.org#9085-2 "Protein intake 24 hour"
* http://loinc.org#9065-4 "Carbohydrate intake 24 hour"
* http://loinc.org#9072-0 "Fat intake 24 hour"
* http://loinc.org#9059-7 "Carbohydrate intake Estimated"
* http://loinc.org#9060-5 "Carbohydrate intake Measured" // 2026-09-17: Measured variant of 9059-7; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81133-1 "Fiber intake 24 hour Estimated" // 2026-09-16: replaces 9055-5 (Calorie intake total 10 hour); the Estimated variant is the one this IG already uses for caffeine (80489-8 in SubstanceUseProfile)
* http://loinc.org#81057-2 "Fiber intake 24 hour Measured" // 2026-09-17: Measured variant of 81133-1; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81033-3 "Saturated fat intake 24 hour Estimated" // 2026-09-16: replaces 9061-3 (Carbohydrate intake 1 hour); the Estimated variant is the one this IG already uses for caffeine (80489-8 in SubstanceUseProfile)
* http://loinc.org#81136-4 "Saturated fat intake 24 hour Measured" // 2026-09-17: Measured variant of 81033-3; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
// 2026-09-15: 9053-0 (Calorie intake total 1 hour) had been listed as fluid intake; replaced by 8990-4.
* http://loinc.org#8990-4 "Fluid intake 24 hour"
* http://loinc.org#80489-8 "Caffeine intake 24 hour Estimated" // 2026-09-16: replaces 9056-3 (Calorie intake total 12 hour); the Estimated variant is the one this IG already uses for caffeine (80489-8 in SubstanceUseProfile)
* http://loinc.org#80490-6 "Caffeine intake 24 hour Measured" // 2026-09-17: Measured variant of 80489-8; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)

// ============================================================================
// VITAMINS (24 hour Estimated)
// ============================================================================
* http://loinc.org#81929-2 "Vitamin D intake 24 hour Estimated"
* http://loinc.org#81930-0 "Vitamin D intake 24 hour Measured" // 2026-09-17: Measured variant of 81929-2; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81074-7 "Vitamin C intake 24 hour Estimated"
* http://loinc.org#81075-4 "Vitamin C intake 24 hour Measured" // 2026-09-17: Measured variant of 81074-7; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81072-1 "Vitamin A intake 24 hour Estimated"
* http://loinc.org#81073-9 "Vitamin A intake 24 hour Measured" // 2026-09-17: Measured variant of 81072-1; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81076-2 "Vitamin E intake 24 hour Estimated"
* http://loinc.org#81077-0 "Vitamin E intake 24 hour Measured" // 2026-09-17: Measured variant of 81076-2; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81062-2 "Vitamin B12 intake 24 hour Estimated"
* http://loinc.org#81063-0 "Vitamin B12 intake 24 hour Measured" // 2026-09-17: Measured variant of 81062-2; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81066-3 "Vitamin B9 (Folate) intake 24 hour Estimated"
* http://loinc.org#81134-9 "Vitamin B9 (Folate) intake 24 hour Measured" // 2026-09-17: Measured variant of 81066-3; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)

// ============================================================================
// MINERALS (24 hour Estimated)
// ============================================================================
* http://loinc.org#81137-2 "Calcium intake 24 hour Estimated"
* http://loinc.org#80975-6 "Calcium intake 24 hour Measured" // 2026-09-17: Measured variant of 81137-2; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81082-0 "Iron intake 24 hour Estimated"
* http://loinc.org#81083-8 "Iron intake 24 hour Measured" // 2026-09-17: Measured variant of 81082-0; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81011-9 "Sodium intake 24 hour Estimated"
* http://loinc.org#81012-7 "Sodium intake 24 hour Measured" // 2026-09-17: Measured variant of 81011-9; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81010-1 "Potassium intake 24 hour Estimated"
* http://loinc.org#81009-3 "Potassium intake 24 hour Measured" // 2026-09-17: Measured variant of 81010-1; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81005-1 "Magnesium intake 24 hour Estimated"
* http://loinc.org#81006-9 "Magnesium intake 24 hour Measured" // 2026-09-17: Measured variant of 81005-1; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)
* http://loinc.org#81089-5 "Zinc intake 24 hour Estimated"
* http://loinc.org#81088-7 "Zinc intake 24 hour Measured" // 2026-09-17: Measured variant of 81089-5; the code identifies the method (Athena LOINC snapshot + tx.fhir.org LOINC 2.82)

// ============================================================================
// SOCIAL CONNECTION AND LONELINESS (UCLA Scale, MOS-SSS)
// ============================================================================
* http://loinc.org#66855-8 "How often do you feel that you lack companionship"
* http://loinc.org#66857-4 "How often do you feel alone"
* http://loinc.org#66867-3 "How often do you feel isolated from others"
* http://loinc.org#91642-9 "Medical Outcomes Study Social Support Survey panel"
* http://loinc.org#91663-5 "Social support index [MOS Social Support Survey]"
* http://loinc.org#91645-2 "Affectionate support [MOS Social Support Survey]"
* http://loinc.org#63512-8 "How many people are living or staying at this address [#]"

// ============================================================================
// PANELS (for reference)
// ============================================================================
* http://loinc.org#82611-5 "Wearable device external physiologic monitoring panel"
