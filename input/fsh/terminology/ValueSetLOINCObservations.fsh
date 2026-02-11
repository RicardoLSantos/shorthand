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
* ^date = "2024-11-21"

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
* http://loinc.org#8636-3 "R-R interval in EKG"
* http://loinc.org#8625-6 "QT interval in EKG"
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
// ANTHROPOMETRICS
// ============================================================================
* http://loinc.org#29463-7 "Body weight"
* http://loinc.org#8302-2 "Body height"
* http://loinc.org#39156-5 "Body mass index (BMI) [Ratio]"
* http://loinc.org#8287-5 "Head Occipital-frontal circumference by Tape measure"

// ============================================================================
// PHYSICAL ACTIVITY
// ============================================================================
* http://loinc.org#55423-8 "Number of steps in 24 hour Measured"
* http://loinc.org#41950-7 "Number of steps"

// ============================================================================
// SLEEP
// ============================================================================
* http://loinc.org#93832-4 "Sleep efficiency"

// ============================================================================
// NUTRITION AND DIETARY INTAKE
// ============================================================================
* http://loinc.org#9052-2 "Caloric intake total"
* http://loinc.org#9059-7 "Protein intake 24 hour"
* http://loinc.org#9057-1 "Carbohydrate intake 24 hour"
* http://loinc.org#9060-5 "Fat intake 24 hour"
* http://loinc.org#9055-5 "Fiber intake 24 hour"
* http://loinc.org#9061-3 "Saturated fat intake 24 hour"
* http://loinc.org#9053-0 "Fluid intake 24 hour"
* http://loinc.org#9056-3 "Caffeine intake 24 hour"
* http://loinc.org#75282-4 "Diet"
* http://loinc.org#65968-0 "Eating habits"

// ============================================================================
// VITAMINS (24 hour Estimated)
// ============================================================================
* http://loinc.org#81929-2 "Vitamin D intake 24 hour Estimated"
* http://loinc.org#81074-7 "Vitamin C intake 24 hour Estimated"
* http://loinc.org#81072-1 "Vitamin A intake 24 hour Estimated"
* http://loinc.org#81076-2 "Vitamin E intake 24 hour Estimated"
* http://loinc.org#81062-2 "Vitamin B12 intake 24 hour Estimated"
* http://loinc.org#81066-3 "Vitamin B9 (Folate) intake 24 hour Estimated"

// ============================================================================
// MINERALS (24 hour Estimated)
// ============================================================================
* http://loinc.org#81137-2 "Calcium intake 24 hour Estimated"
* http://loinc.org#81082-0 "Iron intake 24 hour Estimated"
* http://loinc.org#81011-9 "Sodium intake 24 hour Estimated"
* http://loinc.org#81010-1 "Potassium intake 24 hour Estimated"
* http://loinc.org#81005-1 "Magnesium intake 24 hour Estimated"
* http://loinc.org#81089-5 "Zinc intake 24 hour Estimated"

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
* http://loinc.org#63503-7 "Number of family members in household"

// ============================================================================
// PANELS (for reference)
// ============================================================================
* http://loinc.org#82611-5 "Wearable device external physiologic monitoring panel"
