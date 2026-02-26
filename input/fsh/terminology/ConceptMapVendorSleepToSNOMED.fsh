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
Description: "Oura Ring proprietary sleep stage classifications from Oura Cloud API v2. Reference: https://cloud.ouraring.com/docs/"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #awake "Awake" "Awake periods during sleep session"
* #light "Light Sleep" "Light NREM sleep (N1+N2)"
* #deep "Deep Sleep" "Deep NREM sleep (N3/slow-wave)"
* #rem "REM Sleep" "REM sleep phase"

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
// CORRECTED 2025-12-08: Original codes were WRONG (verified via Australian Ontoserver)
// - 258158006 = "Sleep" (NOT "Awake")
// - 248218005 = "Awake" (NOT "REM sleep")
// - 67233009 = "Middle insomnia" (NOT "Stage 2 sleep")
// - 26329005 = "Poor concentration" (NOT "Stage 3-4 sleep")
// - 248220008 = "Asleep" (NOT "NREM sleep")
// CONCLUSION: SNOMED CT does NOT have specific codes for sleep stages (N1, N2, N3, REM)
// Only generic concepts exist: Sleep (258158006), Asleep (248220008), Awake (248218005)
ValueSet: SNOMEDSleepStagesVS
Id: snomed-sleep-stages-vs
Title: "SNOMED CT Sleep Stages ValueSet"
Description: "SNOMED CT codes for clinical sleep states. NOTE: SNOMED CT lacks specific sleep stage codes (N1/N2/N3/REM). Only generic sleep/awake states available."
* ^experimental = false
* $SCT#248218005 "Awake" // VERIFIED 2025-12-08: Awake
* $SCT#248220008 "Asleep" // VERIFIED 2025-12-08: Asleep (generic)
* $SCT#258158006 "Sleep" // VERIFIED 2025-12-08: Sleep (generic)

// Vendor Sleep Stages ValueSets (for ConceptMap sourceCanonical)
ValueSet: FitbitSleepStagesVS
Id: fitbit-sleep-stages-vs
Title: "Fitbit Sleep Stages ValueSet"
Description: "ValueSet containing Fitbit proprietary sleep stage codes"
* ^experimental = false
* include codes from system FitbitSleepStagesCS

ValueSet: GarminSleepStagesVS
Id: garmin-sleep-stages-vs
Title: "Garmin Sleep Stages ValueSet"
Description: "ValueSet containing Garmin proprietary sleep stage codes"
* ^experimental = false
* include codes from system GarminSleepStagesCS

ValueSet: OuraSleepStagesVS
Id: oura-sleep-stages-vs
Title: "Oura Sleep Stages ValueSet"
Description: "ValueSet containing Oura Ring proprietary sleep stage codes"
* ^experimental = false
* include codes from system OuraSleepStagesCS

ValueSet: AppleSleepStagesVS
Id: apple-sleep-stages-vs
Title: "Apple Sleep Stages ValueSet"
Description: "ValueSet containing Apple HealthKit sleep stage codes"
* ^experimental = false
* include codes from system AppleSleepStagesCS

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
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fitbit-sleep-stages-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/snomed-sleep-stages-vs"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fitbit-sleep-stages-cs"
* group[0].target = "http://snomed.info/sct"
// CORRECTED 2025-12-08: Use verified SNOMED codes only
* group[0].element[0].code = #wake
* group[0].element[0].display = "Wake"
* group[0].element[0].target[0].code = #248218005
* group[0].element[0].target[0].display = "Awake"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "VERIFIED 2025-12-08 via Ontoserver: 248218005 = Awake"
* group[0].element[1].code = #light
* group[0].element[1].display = "Light Sleep"
* group[0].element[1].target[0].code = #248220008
* group[0].element[1].target[0].display = "Asleep"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "GAP: SNOMED CT has no Stage N1/N2 code. Using generic 'Asleep' (248220008). Fitbit 'light' = N1+N2."
* group[0].element[2].code = #deep
* group[0].element[2].display = "Deep Sleep"
* group[0].element[2].target[0].code = #248220008
* group[0].element[2].target[0].display = "Asleep"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[2].target[0].comment = "GAP: SNOMED CT has no Stage N3/SWS code. Using generic 'Asleep' (248220008). Deep = slow-wave sleep."
* group[0].element[3].code = #rem
* group[0].element[3].display = "REM Sleep"
* group[0].element[3].target[0].code = #248220008
* group[0].element[3].target[0].display = "Asleep"
* group[0].element[3].target[0].equivalence = #wider
* group[0].element[3].target[0].comment = "GAP: SNOMED CT has no REM sleep code. Using generic 'Asleep' (248220008). REM = Rapid Eye Movement sleep."

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
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/garmin-sleep-stages-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/snomed-sleep-stages-vs"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/garmin-sleep-stages-cs"
* group[0].target = "http://snomed.info/sct"
// CORRECTED 2025-12-08: Use verified SNOMED codes only
* group[0].element[0].code = #awake
* group[0].element[0].display = "Awake"
* group[0].element[0].target[0].code = #248218005
* group[0].element[0].target[0].display = "Awake"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "VERIFIED 2025-12-08 via Ontoserver: 248218005 = Awake"
* group[0].element[1].code = #light
* group[0].element[1].display = "Light"
* group[0].element[1].target[0].code = #248220008
* group[0].element[1].target[0].display = "Asleep"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "GAP: SNOMED CT has no Stage N1/N2 code. Using generic 'Asleep' (248220008)."
* group[0].element[2].code = #deep
* group[0].element[2].display = "Deep"
* group[0].element[2].target[0].code = #248220008
* group[0].element[2].target[0].display = "Asleep"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[2].target[0].comment = "GAP: SNOMED CT has no Stage N3/SWS code. Using generic 'Asleep' (248220008)."
* group[0].element[3].code = #rem
* group[0].element[3].display = "REM"
* group[0].element[3].target[0].code = #248220008
* group[0].element[3].target[0].display = "Asleep"
* group[0].element[3].target[0].equivalence = #wider
* group[0].element[3].target[0].comment = "GAP: SNOMED CT has no REM sleep code. Using generic 'Asleep' (248220008)."
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
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/oura-sleep-stages-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/snomed-sleep-stages-vs"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/oura-sleep-stages-cs"
* group[0].target = "http://snomed.info/sct"
// CORRECTED 2025-12-08: Use verified SNOMED codes only
// UPDATED 2026-02-26: Source changed from LifestyleMedicineTemporaryCS to OuraSleepStagesCS (vendor alignment)
* group[0].element[0].code = #awake
* group[0].element[0].display = "Awake"
* group[0].element[0].target[0].code = #248218005
* group[0].element[0].target[0].display = "Awake"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 248218005 = Awake"
* group[0].element[1].code = #light
* group[0].element[1].display = "Light Sleep"
* group[0].element[1].target[0].code = #248220008
* group[0].element[1].target[0].display = "Asleep"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "GAP: SNOMED CT has no N1/N2 code. Using generic 'Asleep' (248220008)."
* group[0].element[2].code = #deep
* group[0].element[2].display = "Deep Sleep"
* group[0].element[2].target[0].code = #248220008
* group[0].element[2].target[0].display = "Asleep"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[2].target[0].comment = "GAP: SNOMED CT has no N3/SWS code. Using generic 'Asleep' (248220008)."
* group[0].element[3].code = #rem
* group[0].element[3].display = "REM"
* group[0].element[3].target[0].code = #248220008
* group[0].element[3].target[0].display = "Asleep"
* group[0].element[3].target[0].equivalence = #wider
* group[0].element[3].target[0].comment = "GAP: SNOMED CT has no REM code. Using generic 'Asleep' (248220008)."

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
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/apple-sleep-stages-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/snomed-sleep-stages-vs"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/apple-sleep-stages-cs"
* group[0].target = "http://snomed.info/sct"
// CORRECTED 2025-12-08: Use verified SNOMED codes only
* group[0].element[0].code = #awake
* group[0].element[0].display = "Awake"
* group[0].element[0].target[0].code = #248218005
* group[0].element[0].target[0].display = "Awake"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "VERIFIED 2025-12-08 via tx.fhir.org: 248218005 = Awake"
* group[0].element[1].code = #asleepCore
* group[0].element[1].display = "Core Sleep"
* group[0].element[1].target[0].code = #248220008
* group[0].element[1].target[0].display = "Asleep"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "GAP: SNOMED CT has no N1/N2 code. Using generic 'Asleep' (248220008). Apple 'Core Sleep' = N1+N2."
* group[0].element[2].code = #asleepDeep
* group[0].element[2].display = "Deep Sleep"
* group[0].element[2].target[0].code = #248220008
* group[0].element[2].target[0].display = "Asleep"
* group[0].element[2].target[0].equivalence = #wider
* group[0].element[2].target[0].comment = "GAP: SNOMED CT has no N3/SWS code. Using generic 'Asleep' (248220008)."
* group[0].element[3].code = #asleepREM
* group[0].element[3].display = "REM Sleep"
* group[0].element[3].target[0].code = #248220008
* group[0].element[3].target[0].display = "Asleep"
* group[0].element[3].target[0].equivalence = #wider
* group[0].element[3].target[0].comment = "GAP: SNOMED CT has no REM code. Using generic 'Asleep' (248220008)."
* group[0].element[4].code = #inBed
* group[0].element[4].display = "In Bed"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "No SNOMED CT code for 'in bed' state; behavioral observation, not a sleep stage"
* group[0].element[5].code = #asleepUnspecified
* group[0].element[5].display = "Asleep (Unspecified)"
* group[0].element[5].target[0].code = #248220008
* group[0].element[5].target[0].display = "Asleep"
* group[0].element[5].target[0].equivalence = #equivalent
* group[0].element[5].target[0].comment = "VERIFIED 2025-12-08: 248220008 = Asleep (generic)"

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
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fitbit-sleep-stages-vs"
* targetCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/apple-sleep-stages-vs"
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
