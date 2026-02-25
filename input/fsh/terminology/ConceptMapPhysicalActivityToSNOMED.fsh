// Operational ConceptMap: iOS Physical Activity Codes → SNOMED CT
// Created: 2025-11-22
// Purpose: Enable $translate operations for physical activity terminology interoperability
// Status: Addresses semantic gap between Apple HealthKit and clinical terminologies

Instance: ConceptMapPhysicalActivityToSNOMED
InstanceOf: ConceptMap
Title: "iOS Physical Activity to SNOMED CT Mapping"
Description: "Maps iOS/Apple HealthKit physical activity codes (HKWorkoutActivityType) to SNOMED CT codes. This is an operational ConceptMap that enables $translate operations for semantic interoperability between wearable device data and clinical systems."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapPhysicalActivityToSNOMED"
* version = "0.1.0"
* name = "ConceptMapPhysicalActivityToSNOMED"
* title = "iOS Physical Activity to SNOMED CT Mapping"
* status = #active
* experimental = false
* date = "2025-11-22"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "fhir@2rdoc.pt"
* description = "Operational ConceptMap for physical activity terminology translation. Enables runtime $translate operations for semantic interoperability between Apple HealthKit activity types and SNOMED CT standard terminology. Critical for iOS Health App data integration into EHR systems."
* purpose = "Provides semantic mappings from Apple HealthKit physical activity types (HKWorkoutActivityType) to standard SNOMED CT codes. Enables clinical decision support systems to interpret wearable device activity data using standardized terminology."

// ARCHITECTURE NOTE (2025-11-25):
// Removed sourceCanonical to preserve SNOMED codes in ValueSets for interoperability.
// Source validation is handled by group.source CodeSystem reference.
// See design-decisions.md for rationale and reversal instructions.
//
// Target uses SNOMED CT CodeSystem directly (no ValueSet constraint needed)
// as SNOMED CT is an external terminology validated by tx.fhir.org

// Group 1: iOS Physical Activity CodeSystem → SNOMED CT
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[0].target = "http://snomed.info/sct"

// WALKING - HAS SNOMED CODE ✅
* group[0].element[0].code = #walking
* group[0].element[0].display = "Walking"
* group[0].element[0].target[0].code = #129006008
* group[0].element[0].target[0].display = "Walking (observable entity)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "Direct mapping from HKWorkoutActivityType.walking to SNOMED CT. Includes both indoor and outdoor walking activities."

// RUNNING - CORRECTED 2025-12-08 ⚠️
// Note: 229065009 = "Exercise therapy" NOT "Running"
// Using verified 229166008 (Jogging training) as closer match
* group[0].element[1].code = #running
* group[0].element[1].display = "Running"
* group[0].element[1].target[0].code = #229166008
* group[0].element[1].target[0].display = "Jogging training (regime/therapy)"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "CORRECTED 2025-12-08: Running maps to 'Jogging training' (229166008). Code VERIFIED via Australian Ontoserver. Note: Original code 229065009 is 'Exercise therapy' (broader concept)."

// CYCLING - CORRECTED 2025-12-08 ⚠️
// WRONG CODE: 266940006 = "Lives in squat" NOT "Cycling"
// Using broader 68130003 (Physical activity) until correct cycling code verified
* group[0].element[2].code = #cycling
* group[0].element[2].display = "Cycling"
* group[0].element[2].target[0].code = #68130003
* group[0].element[2].target[0].display = "Physical activity (observable entity)"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[2].target[0].comment = "CORRECTED 2025-12-08: Original code 266940006 was WRONG - it means 'Lives in squat' NOT 'Cycling'. Using 68130003 (Physical activity) VERIFIED via Ontoserver. Specific cycling code requires manual verification via browser.ihtsdotools.org."

// SWIMMING - CORRECTED 2025-12-08 ⚠️
// WRONG CODE: 266938001 = "Hospital patient" NOT "Swimming"
// Using broader 68130003 (Physical activity) until correct swimming code verified
* group[0].element[3].code = #swimming
* group[0].element[3].display = "Swimming"
* group[0].element[3].target[0].code = #68130003
* group[0].element[3].target[0].display = "Physical activity (observable entity)"
* group[0].element[3].target[0].equivalence = #wider
* group[0].element[3].target[0].comment = "CORRECTED 2025-12-08: Original code 266938001 was WRONG - it means 'Hospital patient' NOT 'Swimming'. Using 68130003 (Physical activity) VERIFIED via Ontoserver. Specific swimming code requires manual verification via browser.ihtsdotools.org."

// HIKING - CORRECTED 2025-12-08 ⚠️
// Code 71537002 NOT FOUND in Australian Ontoserver
* group[0].element[4].code = #hiking
* group[0].element[4].display = "Hiking"
* group[0].element[4].target[0].code = #68130003
* group[0].element[4].target[0].display = "Physical activity (observable entity)"
* group[0].element[4].target[0].equivalence = #wider
* group[0].element[4].target[0].comment = "CORRECTED 2025-12-08: Original code 71537002 NOT FOUND in Australian Ontoserver. Using 68130003 (Physical activity) VERIFIED via Ontoserver. Specific hiking code requires manual verification via browser.ihtsdotools.org."

// YOGA - CORRECTED 2025-12-08 ⚠️
// 48761009 = "Motor behaviour" NOT "Regular exercise"
* group[0].element[5].code = #yoga
* group[0].element[5].display = "Yoga"
* group[0].element[5].target[0].code = #61686008
* group[0].element[5].target[0].display = "Physical exercise (regime/therapy)"
* group[0].element[5].target[0].equivalence = #wider
* group[0].element[5].target[0].comment = "CORRECTED 2025-12-08: Yoga maps to 'Physical exercise' (61686008) VERIFIED via Ontoserver. Note: Original 48761009 is 'Motor behaviour' not 'Regular exercise'. Specific yoga code requires manual verification."

// DANCING - CORRECTED 2025-12-08 ⚠️
// 48761009 = "Motor behaviour" NOT "Regular exercise"
* group[0].element[6].code = #dancing
* group[0].element[6].display = "Dancing"
* group[0].element[6].target[0].code = #61686008
* group[0].element[6].target[0].display = "Physical exercise (regime/therapy)"
* group[0].element[6].target[0].equivalence = #wider
* group[0].element[6].target[0].comment = "CORRECTED 2025-12-08: Dancing maps to 'Physical exercise' (61686008) VERIFIED via Ontoserver. Note: Original 48761009 is 'Motor behaviour'. Specific dancing code requires manual verification."

// STRENGTH TRAINING - CORRECTED 2025-12-08 ⚠️
// Code 229070001 NOT FOUND in Australian Ontoserver
* group[0].element[7].code = #strength-training
* group[0].element[7].display = "Strength Training"
* group[0].element[7].target[0].code = #229065009
* group[0].element[7].target[0].display = "Exercise therapy (regime/therapy)"
* group[0].element[7].target[0].equivalence = #wider
* group[0].element[7].target[0].comment = "CORRECTED 2025-12-08: Strength training maps to 'Exercise therapy' (229065009) VERIFIED via Ontoserver. Note: Original code 229070001 NOT FOUND. More specific strength training code requires manual verification."

// TENNIS - CORRECTED 2025-12-08 ⚠️
// Code 85098004 NOT FOUND in Australian Ontoserver
* group[0].element[8].code = #tennis
* group[0].element[8].display = "Tennis"
* group[0].element[8].target[0].code = #14468000
* group[0].element[8].target[0].display = "Sports activity (regime/therapy)"
* group[0].element[8].target[0].equivalence = #wider
* group[0].element[8].target[0].comment = "CORRECTED 2025-12-08: Original code 85098004 NOT FOUND in Australian Ontoserver. Using 14468000 (Sports activity) VERIFIED via Ontoserver. Specific tennis code requires manual verification."

// BADMINTON - NEEDS VERIFICATION ⚠️
* group[0].element[9].code = #badminton
* group[0].element[9].display = "Badminton"
* group[0].element[9].target[0].equivalence = #unmatched
* group[0].element[9].target[0].comment = "No verified SNOMED CT code available for badminton as of 2025-11-22. Recommend searching SNOMED CT Browser or mapping to broader concept 'Racket sports' if available."

// SQUASH - NEEDS VERIFICATION ⚠️
* group[0].element[10].code = #squash
* group[0].element[10].display = "Squash"
* group[0].element[10].target[0].equivalence = #unmatched
* group[0].element[10].target[0].comment = "No verified SNOMED CT code available for squash as of 2025-11-22. Recommend searching SNOMED CT Browser or mapping to broader concept 'Racket sports'."

// TABLE TENNIS - NEEDS VERIFICATION ⚠️
* group[0].element[11].code = #table-tennis
* group[0].element[11].display = "Table Tennis"
* group[0].element[11].target[0].equivalence = #unmatched
* group[0].element[11].target[0].comment = "No verified SNOMED CT code available for table tennis as of 2025-11-22. Recommend searching SNOMED CT Browser or mapping to broader concept 'Racket sports'."

// SOCCER - CORRECTED 2025-12-08 ⚠️
// Code 81598007 NOT FOUND in Australian Ontoserver
* group[0].element[12].code = #soccer
* group[0].element[12].display = "Soccer"
* group[0].element[12].target[0].code = #14468000
* group[0].element[12].target[0].display = "Sports activity (regime/therapy)"
* group[0].element[12].target[0].equivalence = #wider
* group[0].element[12].target[0].comment = "CORRECTED 2025-12-08: Original code 81598007 NOT FOUND in Australian Ontoserver. Using 14468000 (Sports activity) VERIFIED via Ontoserver. Specific soccer/football code requires manual verification."

// BASKETBALL - CORRECTED 2025-12-08 ⚠️
// WRONG CODE: 25999001 = "Atrophy of corpus cavernosum" NOT "Basketball"
* group[0].element[13].code = #basketball
* group[0].element[13].display = "Basketball"
* group[0].element[13].target[0].code = #14468000
* group[0].element[13].target[0].display = "Sports activity (regime/therapy)"
* group[0].element[13].target[0].equivalence = #wider
* group[0].element[13].target[0].comment = "CORRECTED 2025-12-08: Original code 25999001 was COMPLETELY WRONG - it means 'Atrophy of corpus cavernosum' NOT 'Basketball'. Using 14468000 (Sports activity) VERIFIED via Ontoserver. Specific basketball code requires manual verification."

// VOLLEYBALL - NEEDS VERIFICATION ⚠️
* group[0].element[14].code = #volleyball
* group[0].element[14].display = "Volleyball"
* group[0].element[14].target[0].equivalence = #unmatched
* group[0].element[14].target[0].comment = "No verified SNOMED CT code available for volleyball as of 2025-11-22. Recommend searching SNOMED CT Browser or mapping to broader concept 'Team sports'."

// TAI CHI - CORRECTED 2025-12-08 ⚠️
// Code 418818004 NOT FOUND in Australian Ontoserver
* group[0].element[15].code = #tai-chi
* group[0].element[15].display = "Tai Chi"
* group[0].element[15].target[0].code = #61686008
* group[0].element[15].target[0].display = "Physical exercise (regime/therapy)"
* group[0].element[15].target[0].equivalence = #wider
* group[0].element[15].target[0].comment = "CORRECTED 2025-12-08: Original code 418818004 NOT FOUND in Australian Ontoserver. Using 61686008 (Physical exercise) VERIFIED via Ontoserver. Specific Tai Chi code requires manual verification via browser.ihtsdotools.org."

// PILATES - NEEDS VERIFICATION ⚠️
* group[0].element[16].code = #pilates
* group[0].element[16].display = "Pilates"
* group[0].element[16].target[0].equivalence = #unmatched
* group[0].element[16].target[0].comment = "No verified SNOMED CT code available for Pilates as of 2025-11-22. May map to broader concept 'Exercise training' or 'Mind-body therapy'."

// ROWING - CORRECTED 2025-12-08 ⚠️
// Code 10335005 NOT FOUND in Australian Ontoserver
* group[0].element[17].code = #rowing
* group[0].element[17].display = "Rowing"
* group[0].element[17].target[0].code = #68130003
* group[0].element[17].target[0].display = "Physical activity (observable entity)"
* group[0].element[17].target[0].equivalence = #wider
* group[0].element[17].target[0].comment = "CORRECTED 2025-12-08: Original code 10335005 NOT FOUND in Australian Ontoserver. Using 68130003 (Physical activity) VERIFIED via Ontoserver. Specific rowing code requires manual verification."

// PADDLE SPORTS - CORRECTED 2025-12-08 ⚠️
// 48761009 = "Motor behaviour" NOT "Regular exercise"
* group[0].element[18].code = #paddle-sports
* group[0].element[18].display = "Paddle Sports"
* group[0].element[18].target[0].code = #68130003
* group[0].element[18].target[0].display = "Physical activity (observable entity)"
* group[0].element[18].target[0].equivalence = #wider
* group[0].element[18].target[0].comment = "CORRECTED 2025-12-08: Original code 48761009 is 'Motor behaviour' not 'Regular exercise'. Using 68130003 (Physical activity) VERIFIED via Ontoserver."

// SKIING - CORRECTED 2025-12-08 ⚠️
// Code 71537001 NOT FOUND (note: different from hiking code 71537002)
* group[0].element[19].code = #skiing
* group[0].element[19].display = "Skiing"
* group[0].element[19].target[0].code = #68130003
* group[0].element[19].target[0].display = "Physical activity (observable entity)"
* group[0].element[19].target[0].equivalence = #wider
* group[0].element[19].target[0].comment = "CORRECTED 2025-12-08: Original code 71537001 NOT FOUND in Australian Ontoserver. Using 68130003 (Physical activity) VERIFIED via Ontoserver. Specific skiing code requires manual verification."

// SNOWBOARDING - NEEDS VERIFICATION ⚠️
* group[0].element[20].code = #snowboarding
* group[0].element[20].display = "Snowboarding"
* group[0].element[20].target[0].equivalence = #unmatched
* group[0].element[20].target[0].comment = "No verified SNOMED CT code available for snowboarding as of 2025-11-22. Recommend searching SNOMED CT Browser or mapping to broader concept 'Winter sports'."

// CLIMBING - CORRECTED 2025-12-08 ⚠️
// Code 15128009 NOT FOUND in Australian Ontoserver
* group[0].element[21].code = #climbing
* group[0].element[21].display = "Climbing"
* group[0].element[21].target[0].code = #68130003
* group[0].element[21].target[0].display = "Physical activity (observable entity)"
* group[0].element[21].target[0].equivalence = #wider
* group[0].element[21].target[0].comment = "CORRECTED 2025-12-08: Original code 15128009 NOT FOUND in Australian Ontoserver. Using 68130003 (Physical activity) VERIFIED via Ontoserver. Specific climbing code requires manual verification."

// GOLF - CORRECTED 2025-12-08 ⚠️
// Code 49774004 NOT FOUND in Australian Ontoserver
* group[0].element[22].code = #golf
* group[0].element[22].display = "Golf"
* group[0].element[22].target[0].code = #14468000
* group[0].element[22].target[0].display = "Sports activity (regime/therapy)"
* group[0].element[22].target[0].equivalence = #wider
* group[0].element[22].target[0].comment = "CORRECTED 2025-12-08: Original code 49774004 NOT FOUND in Australian Ontoserver. Using 14468000 (Sports activity) VERIFIED via Ontoserver. Specific golf code requires manual verification."

// ELLIPTICAL - CORRECTED 2025-12-08 ⚠️
// Code 229070001 NOT FOUND in Australian Ontoserver
* group[0].element[23].code = #elliptical
* group[0].element[23].display = "Elliptical"
* group[0].element[23].target[0].code = #229065009
* group[0].element[23].target[0].display = "Exercise therapy (regime/therapy)"
* group[0].element[23].target[0].equivalence = #wider
* group[0].element[23].target[0].comment = "CORRECTED 2025-12-08: Original code 229070001 NOT FOUND in Australian Ontoserver. Using 229065009 (Exercise therapy) VERIFIED via Ontoserver."

// STAIRS - CORRECTED 2025-12-08 ⚠️
// Code 15128009 NOT FOUND in Australian Ontoserver
* group[0].element[24].code = #stairs
* group[0].element[24].display = "Stairs"
* group[0].element[24].target[0].code = #68130003
* group[0].element[24].target[0].display = "Physical activity (observable entity)"
* group[0].element[24].target[0].equivalence = #wider
* group[0].element[24].target[0].comment = "CORRECTED 2025-12-08: Original code 15128009 NOT FOUND in Australian Ontoserver. Using 68130003 (Physical activity) VERIFIED via Ontoserver."
