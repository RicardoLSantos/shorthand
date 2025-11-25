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
* http://loinc.org#8893-0 "Heart rate by Pulse oximetry"
* http://loinc.org#40443-4 "Heart rate --resting"
* http://loinc.org#40442-6 "Heart rate --post exercise"
* http://loinc.org#8889-8 "Heart rate 24 hour maximum"
* http://loinc.org#8890-6 "Heart rate 24 hour mean"
* http://loinc.org#8891-4 "Heart rate 24 hour minimum"

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
// PANELS (for reference)
// ============================================================================
* http://loinc.org#82611-5 "Wearable device external physiologic monitoring panel"
