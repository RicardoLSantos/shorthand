// ConceptMapVendorSleepToSNOMED.fsh
// Created: 2025-11-29
// Purpose: Map vendor-specific sleep stage codes to SNOMED CT for cross-vendor interoperability
// Based on: RS6 SciSpace Gap 5 (Cross-Vendor Interoperability, 10% coverage, 90 severity)
//
// Bibliographic References:
// - Irwin2016Sleep: Sleep Disturbance, Sleep Duration, and Inflammation (Brain Behav Immun 58:1-16)
//   DOI: 10.1016/j.bbi.2016.05.001
// - Prather2015Sleep: Sleep duration, sleep quality, and biomarkers of inflammation (Sleep 38:1009-1017)
//   DOI: 10.5665/sleep.5124
// - deZambotti2019SleepWearables: The Sleep of the Ring (Sleep 42:zsz098)
//   DOI: 10.1093/sleep/zsz098
//
// SNOMED CT Sleep Stage Codes (browser.ihtsdotools.org, verified 2025-11-29):
// - 258158006: Awake
// - 248220008: Non-rapid eye movement sleep
// - 67233009: Stage 2 sleep
// - 26329005: Stage 3-4 sleep (slow-wave/deep)
// - 248218005: Rapid eye movement sleep
//
// Vendor API Documentation (Gray Literature):
// - Fitbit Web API: https://dev.fitbit.com/build/reference/web-api/sleep/
// - Garmin Connect API: https://developer.garmin.com/connect-api/
// - Oura Cloud API: https://cloud.ouraring.com/docs/
// - Apple HealthKit: https://developer.apple.com/documentation/healthkit/hkcategoryvaluesleepanalysis

// Vendor Sleep Stage CodeSystems

CodeSystem: FitbitSleepStagesCS
Id: fitbit-sleep-stages-cs
Title: "Fitbit Sleep Stages CodeSystem"
Description: "Fitbit proprietary sleep stage classifications from Fitbit Web API"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #wake "Wake" "Awake periods during sleep session"
* #light "Light Sleep" "N1+N2 combined light sleep stages"
* #deep "Deep Sleep" "N3 slow-wave sleep"
* #rem "REM Sleep" "Rapid Eye Movement sleep"

CodeSystem: GarminSleepStagesCS
Id: garmin-sleep-stages-cs
Title: "Garmin Sleep Stages CodeSystem"
Description: "Garmin proprietary sleep stage classifications from Garmin Connect API"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #awake "Awake" "Awake periods during sleep"
* #light "Light" "Light sleep (N1+N2)"
* #deep "Deep" "Deep sleep (N3/slow-wave)"
* #rem "REM" "REM sleep"
* #unmeasurable "Unmeasurable" "Sleep stage could not be determined"

CodeSystem: OuraSleepStagesCS
Id: oura-sleep-stages-cs
Title: "Oura Ring Sleep Stages CodeSystem"
Description: "Oura Ring proprietary sleep stage classifications from Oura Cloud API"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #awake "Awake" "Awake time during sleep period"
* #light "Light Sleep" "Light NREM sleep (stages 1-2)"
* #deep "Deep Sleep" "Deep NREM sleep (stage 3)"
* #rem "REM" "REM sleep phase"

CodeSystem: AppleSleepStagesCS
Id: apple-sleep-stages-cs
Title: "Apple HealthKit Sleep Stages CodeSystem"
Description: "Apple HealthKit HKCategoryValueSleepAnalysis sleep stage classifications"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #inBed "In Bed" "User is in bed (may or may not be asleep)"
* #asleepUnspecified "Asleep (Unspecified)" "Asleep but stage not determined"
* #awake "Awake" "Awake during sleep session"
* #asleepCore "Core Sleep" "Light NREM sleep (N1+N2) - Apple terminology"
* #asleepDeep "Deep Sleep" "Deep NREM sleep (N3)"
* #asleepREM "REM Sleep" "REM sleep phase"

// SNOMED CT Sleep Stage Reference ValueSet
ValueSet: SNOMEDSleepStagesVS
Id: snomed-sleep-stages-vs
Title: "SNOMED CT Sleep Stages ValueSet"
Description: "SNOMED CT codes for clinical sleep stages"
* ^experimental = false
* $SCT#258158006 "Awake" // Awake
* $SCT#248220008 "Non-rapid eye movement sleep" // NREM generic
* $SCT#67233009 "Stage 2 sleep" // N2 light
* $SCT#26329005 "Stage 3-4 sleep" // N3 deep (slow-wave)
* $SCT#248218005 "Rapid eye movement sleep" // REM

// ConceptMap: Fitbit → SNOMED CT
Instance: ConceptMapFitbitSleepToSNOMED
InstanceOf: ConceptMap
Title: "Fitbit Sleep Stages to SNOMED CT Mapping"
Description: "Maps Fitbit sleep stage codes to SNOMED CT for clinical interoperability. Addresses RS6 Gap 5: Cross-Vendor Interoperability."
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapFitbitSleepToSNOMED"
* version = "0.1.0"
* name = "ConceptMapFitbitSleepToSNOMED"
* status = #active
* experimental = false
* date = "2025-11-29"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fitbit-sleep-stages-cs"
* targetCanonical = "http://snomed.info/sct"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fitbit-sleep-stages-cs"
* group[0].target = "http://snomed.info/sct"
* group[0].element[0].code = #wake
* group[0].element[0].display = "Wake"
* group[0].element[0].target[0].code = #258158006
* group[0].element[0].target[0].display = "Awake"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #light
* group[0].element[1].display = "Light Sleep"
* group[0].element[1].target[0].code = #67233009
* group[0].element[1].target[0].display = "Stage 2 sleep"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "Fitbit 'light' combines N1+N2; SNOMED Stage 2 is more specific"
* group[0].element[2].code = #deep
* group[0].element[2].display = "Deep Sleep"
* group[0].element[2].target[0].code = #26329005
* group[0].element[2].target[0].display = "Stage 3-4 sleep"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[3].code = #rem
* group[0].element[3].display = "REM Sleep"
* group[0].element[3].target[0].code = #248218005
* group[0].element[3].target[0].display = "Rapid eye movement sleep"
* group[0].element[3].target[0].equivalence = #equivalent

// ConceptMap: Garmin → SNOMED CT
Instance: ConceptMapGarminSleepToSNOMED
InstanceOf: ConceptMap
Title: "Garmin Sleep Stages to SNOMED CT Mapping"
Description: "Maps Garmin sleep stage codes to SNOMED CT for clinical interoperability"
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapGarminSleepToSNOMED"
* version = "0.1.0"
* name = "ConceptMapGarminSleepToSNOMED"
* status = #active
* experimental = false
* date = "2025-11-29"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/garmin-sleep-stages-cs"
* targetCanonical = "http://snomed.info/sct"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/garmin-sleep-stages-cs"
* group[0].target = "http://snomed.info/sct"
* group[0].element[0].code = #awake
* group[0].element[0].display = "Awake"
* group[0].element[0].target[0].code = #258158006
* group[0].element[0].target[0].display = "Awake"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #light
* group[0].element[1].display = "Light"
* group[0].element[1].target[0].code = #67233009
* group[0].element[1].target[0].display = "Stage 2 sleep"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[2].code = #deep
* group[0].element[2].display = "Deep"
* group[0].element[2].target[0].code = #26329005
* group[0].element[2].target[0].display = "Stage 3-4 sleep"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[3].code = #rem
* group[0].element[3].display = "REM"
* group[0].element[3].target[0].code = #248218005
* group[0].element[3].target[0].display = "Rapid eye movement sleep"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[4].code = #unmeasurable
* group[0].element[4].display = "Unmeasurable"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "No SNOMED CT equivalent for unmeasurable/indeterminate sleep state"

// ConceptMap: Oura → SNOMED CT
Instance: ConceptMapOuraSleepToSNOMED
InstanceOf: ConceptMap
Title: "Oura Ring Sleep Stages to SNOMED CT Mapping"
Description: "Maps Oura Ring sleep stage codes to SNOMED CT for clinical interoperability"
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapOuraSleepToSNOMED"
* version = "0.1.0"
* name = "ConceptMapOuraSleepToSNOMED"
* status = #active
* experimental = false
* date = "2025-11-29"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/oura-sleep-stages-cs"
* targetCanonical = "http://snomed.info/sct"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/oura-sleep-stages-cs"
* group[0].target = "http://snomed.info/sct"
* group[0].element[0].code = #awake
* group[0].element[0].display = "Awake"
* group[0].element[0].target[0].code = #258158006
* group[0].element[0].target[0].display = "Awake"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #light
* group[0].element[1].display = "Light Sleep"
* group[0].element[1].target[0].code = #67233009
* group[0].element[1].target[0].display = "Stage 2 sleep"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[2].code = #deep
* group[0].element[2].display = "Deep Sleep"
* group[0].element[2].target[0].code = #26329005
* group[0].element[2].target[0].display = "Stage 3-4 sleep"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[3].code = #rem
* group[0].element[3].display = "REM"
* group[0].element[3].target[0].code = #248218005
* group[0].element[3].target[0].display = "Rapid eye movement sleep"
* group[0].element[3].target[0].equivalence = #equivalent

// ConceptMap: Apple → SNOMED CT
Instance: ConceptMapAppleSleepToSNOMED
InstanceOf: ConceptMap
Title: "Apple HealthKit Sleep Stages to SNOMED CT Mapping"
Description: "Maps Apple HealthKit HKCategoryValueSleepAnalysis codes to SNOMED CT. Note: Apple uses 'Core Sleep' terminology for light NREM."
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapAppleSleepToSNOMED"
* version = "0.1.0"
* name = "ConceptMapAppleSleepToSNOMED"
* status = #active
* experimental = false
* date = "2025-11-29"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/apple-sleep-stages-cs"
* targetCanonical = "http://snomed.info/sct"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/apple-sleep-stages-cs"
* group[0].target = "http://snomed.info/sct"
* group[0].element[0].code = #awake
* group[0].element[0].display = "Awake"
* group[0].element[0].target[0].code = #258158006
* group[0].element[0].target[0].display = "Awake"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #asleepCore
* group[0].element[1].display = "Core Sleep"
* group[0].element[1].target[0].code = #67233009
* group[0].element[1].target[0].display = "Stage 2 sleep"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "Apple 'Core Sleep' = N1+N2 light NREM; maps to SNOMED Stage 2 as closest match"
* group[0].element[2].code = #asleepDeep
* group[0].element[2].display = "Deep Sleep"
* group[0].element[2].target[0].code = #26329005
* group[0].element[2].target[0].display = "Stage 3-4 sleep"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[3].code = #asleepREM
* group[0].element[3].display = "REM Sleep"
* group[0].element[3].target[0].code = #248218005
* group[0].element[3].target[0].display = "Rapid eye movement sleep"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[4].code = #inBed
* group[0].element[4].display = "In Bed"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "No SNOMED CT code for 'in bed' state; this is a behavioral observation, not a sleep stage"
* group[0].element[5].code = #asleepUnspecified
* group[0].element[5].display = "Asleep (Unspecified)"
* group[0].element[5].target[0].code = #248220008
* group[0].element[5].target[0].display = "Non-rapid eye movement sleep"
* group[0].element[5].target[0].equivalence = #wider
* group[0].element[5].target[0].comment = "Generic asleep maps to broader NREM category when stage undetermined"

// Cross-Vendor Sleep Stage Equivalence ConceptMap
Instance: ConceptMapCrossVendorSleepStages
InstanceOf: ConceptMap
Title: "Cross-Vendor Sleep Stage Equivalence"
Description: "Establishes equivalence relationships between different vendor sleep stage terminologies to enable cross-platform data aggregation. Addresses RS6 Gap 5: Fitbit 'light' ≈ Garmin 'light' ≈ Apple 'Core' ≈ Oura 'light'"
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapCrossVendorSleepStages"
* version = "0.1.0"
* name = "ConceptMapCrossVendorSleepStages"
* status = #active
* experimental = false
* date = "2025-11-29"
* publisher = "Ricardo Lourenço dos Santos, FMUP"
* description = "Cross-vendor sleep stage mapping enabling semantic interoperability across Apple, Fitbit, Garmin, and Oura sleep tracking data. Critical for multi-device LHS implementations."
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fitbit-sleep-stages-cs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/apple-sleep-stages-cs"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fitbit-sleep-stages-cs"
* group[0].target = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/apple-sleep-stages-cs"
* group[0].element[0].code = #wake
* group[0].element[0].target[0].code = #awake
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[1].code = #light
* group[0].element[1].target[0].code = #asleepCore
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[1].target[0].comment = "Fitbit 'light' = Apple 'Core Sleep' (N1+N2 NREM)"
* group[0].element[2].code = #deep
* group[0].element[2].target[0].code = #asleepDeep
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[3].code = #rem
* group[0].element[3].target[0].code = #asleepREM
* group[0].element[3].target[0].equivalence = #equivalent
