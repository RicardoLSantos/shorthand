// =============================================================================
// ValueSets for SubstanceUse Profiles
// =============================================================================
// Created: 2025-11-25
// Updated: 2026-01-12 - SNOMED code verification and corrections
//
// Verification Sources:
// - IPS Current Smoking Status: https://hl7.org/fhir/uv/ips/ValueSet-current-smoking-status-uv-ips.html
// - SNOMED CT Browser: https://browser.ihtsdotools.org
// - FindACode: https://www.findacode.com/snomed/
//
// References:
// - IPS IG v2.0.0: https://build.fhir.org/ig/HL7/fhir-ips/
// - FHIR IG for ABDM v6.5.0 (Tobacco hierarchy 365981007)
// =============================================================================

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org

// =============================================================================
// TOBACCO VALUE SETS
// =============================================================================

ValueSet: TobaccoUseStatusVS
Id: tobacco-use-status-vs
Title: "Tobacco Use Status ValueSet"
Description: """
Status categories for tobacco use aligned with IPS (International Patient Summary).

All codes verified from IPS Current Smoking Status ValueSet (hl7.fhir.uv.ips#2.0.0).
Uses SNOMED CT hierarchy: 365981007 (Tobacco smoking behavior - finding).
"""
* ^experimental = false
* ^version = "0.1.0"
// IPS-verified codes (Jan 2026)
* $SCT#266919005 "Never smoked tobacco (finding)"
* $SCT#8517006 "Ex-smoker (finding)"
* $SCT#77176002 "Smoker (finding)"
* $SCT#449868002 "Smokes tobacco daily (finding)"
* $SCT#428041000124106 "Occasional tobacco smoker (finding)"
* $SCT#266927001 "Tobacco smoking consumption unknown (finding)"
* $SCT#230063004 "Heavy cigarette smoker (finding)"
* $SCT#230060001 "Light cigarette smoker (finding)"

ValueSet: TobaccoProductTypeVS
Id: tobacco-product-type-vs
Title: "Tobacco Product Type ValueSet"
Description: """
Types of tobacco products using SNOMED CT substance codes where available,
with custom codes for products lacking standard equivalents.
Cat B Tier 2 remediation (2026-02-27): replaced bulk include with enumerated codes.
"""
* ^experimental = false
* ^version = "0.2.0"
// SNOMED CT - Verified via local SNOMED database (2026-02-27)
* $SCT#66562002 "Cigarette smoking tobacco"
* $SCT#26663004 "Cigar smoking tobacco"
* $SCT#84498003 "Pipe smoking tobacco"
* $SCT#722495000 "Hookah pipe"
* $SCT#722498003 "Electronic cigarette"
// Custom codes - SNOMED gap (no standard equivalent)
* LifestyleMedicineTemporaryCS#chewing-tobacco "Chewing tobacco"
* LifestyleMedicineTemporaryCS#snuff "Snuff"
* LifestyleMedicineTemporaryCS#heated-tobacco "Heated tobacco"
ValueSet: AlcoholUseStatusVS
Id: alcohol-use-status-vs
Title: "Alcohol Use Status ValueSet"
Description: "Status categories for alcohol consumption"
* ^experimental = false
* ^version = "0.1.0"
* $SCT#105542008 "Non-drinker of alcohol (finding)"
* $SCT#82581004 "Former drinker (finding)"
* $SCT#219006 "Current drinker of alcohol (finding)"
* $SCT#228276006 "Occasional drinker (finding)"
* $SCT#228277002 "Light drinker (finding)"
* $SCT#43783005 "Moderate drinker (finding)"
* $SCT#228279004 "Heavy drinker (finding)"
* $SCT#228281002 "Problem drinker (finding)"
// FIX 2026-01-12: Replaced inactive 160573003 with active 261665006
* $SCT#261665006 "Unknown (qualifier value)"

ValueSet: AlcoholDrinkingFrequencyVS
Id: alcohol-drinking-frequency-vs
Title: "Alcohol Drinking Frequency ValueSet"
Description: "AUDIT-C frequency categories for alcohol consumption using standard LOINC Answer codes. Replaces custom codes per Cat B remediation (2026-02-27)."
* ^experimental = false
* ^version = "0.2.0"
* http://loinc.org#LA6270-8 "Never"
* http://loinc.org#LA18926-8 "Monthly or less"
* http://loinc.org#LA18927-6 "2-4 times a month"
* http://loinc.org#LA18928-4 "2-3 times a week"
* http://loinc.org#LA18929-2 "4 or more times a week"
* http://loinc.org#LA14435-4 "Daily"
ValueSet: AlcoholBeverageTypeVS
Id: alcohol-beverage-type-vs
Title: "Alcohol Beverage Type ValueSet"
Description: "Types of alcoholic beverages using SNOMED CT substance codes where available. Cat B Tier 2 remediation (2026-02-27)."
* ^experimental = false
* ^version = "0.2.0"
// SNOMED CT - Verified via local SNOMED database (2026-02-27)
* $SCT#53410008 "Beer"
* $SCT#35748005 "Wine"
* $SCT#226025006 "Hard cider"
* $SCT#228982004 "Fortified wine"
// Custom codes - SNOMED gap (no standard equivalent for mixed/distilled categories)
* LifestyleMedicineTemporaryCS#spirits "Spirits"
* LifestyleMedicineTemporaryCS#cocktails "Cocktails"
ValueSet: CaffeineSourceVS
Id: caffeine-source-vs
Title: "Caffeine Source ValueSet"
Description: "Common sources of dietary caffeine"
* ^experimental = false
* ^version = "0.1.0"
* LifestyleMedicineTemporaryCS#coffee "Coffee"
* LifestyleMedicineTemporaryCS#espresso "Espresso"
* LifestyleMedicineTemporaryCS#tea "Tea"
* LifestyleMedicineTemporaryCS#energy-drink "Energy drink"
* LifestyleMedicineTemporaryCS#soft-drink "Soft drink"
* LifestyleMedicineTemporaryCS#chocolate "Chocolate"
* LifestyleMedicineTemporaryCS#supplement "Supplement"
* LifestyleMedicineTemporaryCS#pre-workout "Pre-workout"
ValueSet: CaffeineIntakeLevelVS
Id: caffeine-intake-level-vs
Title: "Caffeine Intake Level ValueSet"
Description: "Categorical assessment of daily caffeine intake"
* ^experimental = false
* ^version = "0.1.0"
* AppLogicCS#caffeine-level-none "None"
* AppLogicCS#caffeine-level-low "Low"
* AppLogicCS#caffeine-level-moderate "Moderate"
* AppLogicCS#caffeine-level-high "High"
* AppLogicCS#excessive "Excessive"
ValueSet: RecreationalSubstanceUseStatusVS
Id: recreational-substance-use-status-vs
Title: "Recreational Substance Use Status ValueSet"
Description: """
Status categories for recreational substance use.

**SNOMED CT Verification Notes (2026-01-12)**:
Previous codes were incorrectly mapped. Corrections:
- 44870007: Actual = "Ex-drug user" (finding) - kept, display corrected
- 707848009: Actual = "Patient denies drug use (finding)" - kept, display corrected
- 228368007: Actual = "Has never misused drugs" - kept, display corrected

These codes are semantically appropriate for substance use status.
"""
* ^experimental = false
* ^version = "0.1.0"
* $SCT#228366006 "Finding relating to drug misuse behavior (finding)"
* $SCT#44870007 "Ex-drug user (finding)"
* $SCT#707848009 "Patient denies drug use (finding)"
* $SCT#228368007 "Has never misused drugs"
* $SCT#424848002 "Recreational drug user (finding)"

ValueSet: RecreationalSubstanceTypeVS
Id: recreational-substance-type-vs
Title: "Recreational Substance Type ValueSet"
Description: """
Types of recreational substances for clinical documentation.

**SNOMED CT Verification Notes (2026-01-12)**:
SNOMED CT codes verified at tx.fhir.org:
- 398705004: "Cannabis (substance)" - VERIFIED
- 387085005: "Cocaine (substance)" - VERIFIED
- 387499002: "Methamphetamine (substance)" - VERIFIED (status=inactive, but valid)
- 75672003: "Amphetamine (substance)" - VERIFIED active alternative
- 288459003: "MDMA (substance)" - VERIFIED for ecstasy/MDMA

**SNOMED CT Gap (2026-01-12)**:
The following substance CLASS codes were hallucinated and do NOT exist in SNOMED:
- 373492002: Actual = "Fentanyl (substance)" NOT "Sedative class"
- 372588000: Actual = "Naproxen (substance)" NOT "Opioid class"
- 372584003: Actual = "Dexamethasone (substance)" NOT "Benzodiazepine class"
- 229006003: Does NOT exist in SNOMED CT

Using custom CodeSystem for substance categories where SNOMED lacks class-level codes.
"""
* ^experimental = false
* ^version = "0.1.0"
// SNOMED CT - Verified specific substance codes
* $SCT#398705004 "Cannabis (substance)"
* $SCT#387085005 "Cocaine (substance)"
* $SCT#75672003 "Amphetamine (substance)"
* $SCT#288459003 "MDMA (substance)"
// Custom codes for substance CLASS categories (SNOMED gap - no class-level codes)
* LifestyleMedicineTemporaryCS#opioids "Opioids"
* LifestyleMedicineTemporaryCS#benzodiazepines "Benzodiazepines"
* LifestyleMedicineTemporaryCS#hallucinogens "Hallucinogens"
* LifestyleMedicineTemporaryCS#sedatives "Sedatives"
* LifestyleMedicineTemporaryCS#inhalants "Inhalants"
* LifestyleMedicineTemporaryCS#synthetic-cannabinoids "Synthetic cannabinoids"
* LifestyleMedicineTemporaryCS#new-psychoactive "New psychoactive substances"
ValueSet: SubstanceUseFrequencyVS
Id: substance-use-frequency-vs
Title: "Substance Use Frequency ValueSet"
Description: "Frequency categories for substance use"
* ^experimental = false
* ^version = "0.1.0"
* LifestyleMedicineTemporaryCS#substance-freq-never "Never"
* LifestyleMedicineTemporaryCS#tried-once "Tried once"
* LifestyleMedicineTemporaryCS#rarely "Rarely"
* LifestyleMedicineTemporaryCS#monthly "Monthly"
* LifestyleMedicineTemporaryCS#weekly "Weekly"
* LifestyleMedicineTemporaryCS#several-times-weekly "Several times weekly"
* LifestyleMedicineTemporaryCS#substance-freq-daily "Daily"
ValueSet: SubstanceUseRiskLevelVS
Id: substance-use-risk-level-vs
Title: "Substance Use Risk Level ValueSet"
Description: "Overall risk assessment for substance use patterns"
* ^experimental = false
* ^version = "0.1.0"
* AppLogicCS#substance-risk-minimal "Minimal risk"
* AppLogicCS#substance-risk-low "Low risk"
* AppLogicCS#substance-risk-moderate "Moderate risk"
* AppLogicCS#substance-risk-high "High risk"
* AppLogicCS#substance-risk-severe "Severe risk"
