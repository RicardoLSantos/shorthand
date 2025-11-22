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

// CORRECTED STRUCTURE per HL7 spec and validated ConceptMap pattern:
// - sourceCanonical/targetCanonical → ValueSets (business context, implementation scope)
// - group.source/group.target → CodeSystems (actual concept definitions)
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/physical-activity-type-vs"
* targetCanonical = "http://hl7.org/fhir/ValueSet/all-snomed-ct"

// Group 1: iOS Physical Activity CodeSystem → SNOMED CT
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/ios-physical-activity-cs"
* group[0].target = "http://snomed.info/sct"

// WALKING - HAS SNOMED CODE ✅
* group[0].element[0].code = #walking
* group[0].element[0].display = "Walking"
* group[0].element[0].target[0].code = #129006008
* group[0].element[0].target[0].display = "Walking (observable entity)"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "Direct mapping from HKWorkoutActivityType.walking to SNOMED CT. Includes both indoor and outdoor walking activities."

// RUNNING - HAS SNOMED CODE ✅
* group[0].element[1].code = #running
* group[0].element[1].display = "Running"
* group[0].element[1].target[0].code = #229065009
* group[0].element[1].target[0].display = "Running (observable entity)"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[1].target[0].comment = "Direct mapping from HKWorkoutActivityType.running to SNOMED CT. Includes both indoor and outdoor running activities."

// CYCLING - HAS SNOMED CODE ✅
* group[0].element[2].code = #cycling
* group[0].element[2].display = "Cycling"
* group[0].element[2].target[0].code = #266940006
* group[0].element[2].target[0].display = "Cycling (regime/therapy)"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[2].target[0].comment = "Direct mapping from HKWorkoutActivityType.cycling to SNOMED CT. Includes outdoor cycling and stationary cycling."

// SWIMMING - HAS SNOMED CODE ✅
* group[0].element[3].code = #swimming
* group[0].element[3].display = "Swimming"
* group[0].element[3].target[0].code = #266938001
* group[0].element[3].target[0].display = "Swimming (regime/therapy)"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[3].target[0].comment = "Direct mapping from HKWorkoutActivityType.swimming to SNOMED CT. Includes pool and open water swimming."

// HIKING - SNOMED CODE NEEDS VERIFICATION ⚠️
* group[0].element[4].code = #hiking
* group[0].element[4].display = "Hiking"
* group[0].element[4].target[0].code = #71537002
* group[0].element[4].target[0].display = "Hiking (physical activity)"
* group[0].element[4].target[0].equivalence = #equivalent
* group[0].element[4].target[0].comment = "Mapping from HKWorkoutActivityType.hiking to SNOMED CT code 71537002. Note: SNOMED code should be verified via official SNOMED CT Browser before clinical use."

// YOGA - BROADER MAPPING ⚠️
* group[0].element[5].code = #yoga
* group[0].element[5].display = "Yoga"
* group[0].element[5].target[0].code = #48761009
* group[0].element[5].target[0].display = "Regular exercise (regime/therapy)"
* group[0].element[5].target[0].equivalence = #wider
* group[0].element[5].target[0].comment = "HKWorkoutActivityType.yoga maps to broader SNOMED concept 'Regular exercise'. Specific SNOMED code for yoga may exist but requires verification. Equivalence marked as 'wider' because target concept is less specific than source."

// DANCING - NEEDS SPECIFIC SNOMED CODE ⚠️
* group[0].element[6].code = #dancing
* group[0].element[6].display = "Dancing"
* group[0].element[6].target[0].code = #48761009
* group[0].element[6].target[0].display = "Regular exercise (regime/therapy)"
* group[0].element[6].target[0].equivalence = #wider
* group[0].element[6].target[0].comment = "HKWorkoutActivityType.dance/socialDance maps to broader SNOMED concept 'Regular exercise'. Specific SNOMED code for dancing may exist (search: 'dancing' in SNOMED CT Browser)."

// STRENGTH TRAINING - NEEDS SPECIFIC SNOMED CODE ⚠️
* group[0].element[7].code = #strength-training
* group[0].element[7].display = "Strength Training"
* group[0].element[7].target[0].code = #229070001
* group[0].element[7].target[0].display = "Exercise training (regime/therapy)"
* group[0].element[7].target[0].equivalence = #narrower
* group[0].element[7].target[0].comment = "HKWorkoutActivityType.traditionalStrengthTraining maps to broader SNOMED concept 'Exercise training'. Target is less specific than source (which specifies strength/resistance training)."

// TENNIS - NEEDS VERIFICATION ⚠️
* group[0].element[8].code = #tennis
* group[0].element[8].display = "Tennis"
* group[0].element[8].target[0].code = #85098004
* group[0].element[8].target[0].display = "Tennis (physical activity)"
* group[0].element[8].target[0].equivalence = #equivalent
* group[0].element[8].target[0].comment = "Mapping from HKWorkoutActivityType.tennis to SNOMED CT code 85098004. Note: SNOMED code should be verified via official SNOMED CT Browser."

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

// SOCCER - NEEDS VERIFICATION ⚠️
* group[0].element[12].code = #soccer
* group[0].element[12].display = "Soccer"
* group[0].element[12].target[0].code = #81598007
* group[0].element[12].target[0].display = "Football (physical activity)"
* group[0].element[12].target[0].equivalence = #equivalent
* group[0].element[12].target[0].comment = "Mapping from HKWorkoutActivityType.soccer to SNOMED CT code 81598007 (Football). Note: SNOMED code should be verified. Regional terminology note: 'Football' in SNOMED may refer to soccer/association football."

// BASKETBALL - NEEDS VERIFICATION ⚠️
* group[0].element[13].code = #basketball
* group[0].element[13].display = "Basketball"
* group[0].element[13].target[0].code = #25999001
* group[0].element[13].target[0].display = "Basketball (physical activity)"
* group[0].element[13].target[0].equivalence = #equivalent
* group[0].element[13].target[0].comment = "Mapping from HKWorkoutActivityType.basketball to SNOMED CT code 25999001. Note: SNOMED code should be verified via official SNOMED CT Browser."

// VOLLEYBALL - NEEDS VERIFICATION ⚠️
* group[0].element[14].code = #volleyball
* group[0].element[14].display = "Volleyball"
* group[0].element[14].target[0].equivalence = #unmatched
* group[0].element[14].target[0].comment = "No verified SNOMED CT code available for volleyball as of 2025-11-22. Recommend searching SNOMED CT Browser or mapping to broader concept 'Team sports'."

// TAI CHI - NEEDS VERIFICATION ⚠️
* group[0].element[15].code = #tai-chi
* group[0].element[15].display = "Tai Chi"
* group[0].element[15].target[0].code = #418818004
* group[0].element[15].target[0].display = "Tai chi (regime/therapy)"
* group[0].element[15].target[0].equivalence = #equivalent
* group[0].element[15].target[0].comment = "Mapping from HKWorkoutActivityType.taiChi to SNOMED CT code 418818004. Note: SNOMED code should be verified."

// PILATES - NEEDS VERIFICATION ⚠️
* group[0].element[16].code = #pilates
* group[0].element[16].display = "Pilates"
* group[0].element[16].target[0].equivalence = #unmatched
* group[0].element[16].target[0].comment = "No verified SNOMED CT code available for Pilates as of 2025-11-22. May map to broader concept 'Exercise training' or 'Mind-body therapy'."

// ROWING - NEEDS VERIFICATION ⚠️
* group[0].element[17].code = #rowing
* group[0].element[17].display = "Rowing"
* group[0].element[17].target[0].code = #10335005
* group[0].element[17].target[0].display = "Rowing (physical activity)"
* group[0].element[17].target[0].equivalence = #equivalent
* group[0].element[17].target[0].comment = "Mapping from HKWorkoutActivityType.rowing to SNOMED CT code 10335005. Note: SNOMED code should be verified."

// PADDLE SPORTS - BROADER MAPPING ⚠️
* group[0].element[18].code = #paddle-sports
* group[0].element[18].display = "Paddle Sports"
* group[0].element[18].target[0].code = #48761009
* group[0].element[18].target[0].display = "Regular exercise (regime/therapy)"
* group[0].element[18].target[0].equivalence = #wider
* group[0].element[18].target[0].comment = "HKWorkoutActivityType.paddleSports (kayaking, canoeing) maps to broader SNOMED concept 'Regular exercise'. Specific codes for paddle sports may exist."

// SKIING - NEEDS VERIFICATION ⚠️
* group[0].element[19].code = #skiing
* group[0].element[19].display = "Skiing"
* group[0].element[19].target[0].code = #71537001
* group[0].element[19].target[0].display = "Skiing (physical activity)"
* group[0].element[19].target[0].equivalence = #equivalent
* group[0].element[19].target[0].comment = "Mapping from HKWorkoutActivityType.downhillSkiing/crossCountrySkiing to SNOMED CT code 71537001. Note: SNOMED code should be verified. May need separate codes for downhill vs cross-country."

// SNOWBOARDING - NEEDS VERIFICATION ⚠️
* group[0].element[20].code = #snowboarding
* group[0].element[20].display = "Snowboarding"
* group[0].element[20].target[0].equivalence = #unmatched
* group[0].element[20].target[0].comment = "No verified SNOMED CT code available for snowboarding as of 2025-11-22. Recommend searching SNOMED CT Browser or mapping to broader concept 'Winter sports'."

// CLIMBING - NEEDS VERIFICATION ⚠️
* group[0].element[21].code = #climbing
* group[0].element[21].display = "Climbing"
* group[0].element[21].target[0].code = #15128009
* group[0].element[21].target[0].display = "Climbing (physical activity)"
* group[0].element[21].target[0].equivalence = #equivalent
* group[0].element[21].target[0].comment = "Mapping from HKWorkoutActivityType.climbing to SNOMED CT code 15128009. Note: SNOMED code should be verified."

// GOLF - NEEDS VERIFICATION ⚠️
* group[0].element[22].code = #golf
* group[0].element[22].display = "Golf"
* group[0].element[22].target[0].code = #49774004
* group[0].element[22].target[0].display = "Golf (physical activity)"
* group[0].element[22].target[0].equivalence = #equivalent
* group[0].element[22].target[0].comment = "Mapping from HKWorkoutActivityType.golf to SNOMED CT code 49774004. Note: SNOMED code should be verified."

// ELLIPTICAL - BROADER MAPPING ⚠️
* group[0].element[23].code = #elliptical
* group[0].element[23].display = "Elliptical"
* group[0].element[23].target[0].code = #229070001
* group[0].element[23].target[0].display = "Exercise training (regime/therapy)"
* group[0].element[23].target[0].equivalence = #narrower
* group[0].element[23].target[0].comment = "HKWorkoutActivityType.elliptical maps to broader SNOMED concept 'Exercise training'. Specific SNOMED code for elliptical trainer may not exist."

// STAIRS - BROADER MAPPING ⚠️
* group[0].element[24].code = #stairs
* group[0].element[24].display = "Stairs"
* group[0].element[24].target[0].code = #15128009
* group[0].element[24].target[0].display = "Climbing (physical activity)"
* group[0].element[24].target[0].equivalence = #narrower
* group[0].element[24].target[0].comment = "HKWorkoutActivityType.stairs/stairStepper maps to SNOMED concept 'Climbing'. Target is broader than source (stairs is a specific type of climbing activity)."
