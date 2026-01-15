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
Types of tobacco products.

**SNOMED CT Gap**: SNOMED CT International Edition lacks specific codes for
individual tobacco product types (cigarette, cigar, pipe) as physical objects.
The codes 722498003, 722499006 are actually electronic cigarette-related.

This ValueSet uses a custom CodeSystem with clinically relevant product types.
"""
* ^experimental = false
* ^version = "0.1.0"
* include codes from system TobaccoProductTypeCS

CodeSystem: TobaccoProductTypeCS
Id: tobacco-product-type-cs
Title: "Tobacco Product Type CodeSystem"
Description: """
Custom CodeSystem for tobacco product types.

**SNOMED CT Gap Documentation**:
- 722496004: "Cigarette (physical object)" - VERIFIED correct
- 722498003: Actual = "Electronic cigarette (physical object)" NOT cigar
- 722499006: Actual = "Electronic cigarette user (finding)" NOT pipe
- 159882006: Actual = "Tobacco processor" NOT chewing tobacco user

This custom CodeSystem provides unambiguous codes for tobacco products
until SNOMED CT International provides specific concepts.
"""
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/tobacco-product-type-cs"
* #cigarette "Cigarette" "Manufactured cigarette"
* #cigar "Cigar" "Cigar including cigarillos"
* #pipe "Pipe" "Tobacco pipe"
* #chewing-tobacco "Chewing tobacco" "Smokeless tobacco for chewing"
* #snuff "Snuff" "Nasal snuff"
* #hookah "Hookah" "Water pipe/hookah"
* #electronic-cigarette "Electronic cigarette" "E-cigarette/vape device"
* #heated-tobacco "Heated tobacco" "Heat-not-burn tobacco products"

// =============================================================================
// ALCOHOL VALUE SETS
// =============================================================================

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
Description: "AUDIT-style frequency categories for alcohol consumption"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system AlcoholDrinkingFrequencyCS

CodeSystem: AlcoholDrinkingFrequencyCS
Id: alcohol-drinking-frequency-cs
Title: "Alcohol Drinking Frequency CodeSystem"
Description: "AUDIT-C style frequency categories"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #never "Never" "Never drinks alcohol"
* #monthly-or-less "Monthly or less" "Drinks alcohol monthly or less frequently"
* #2-4-per-month "2-4 times per month" "Drinks alcohol 2-4 times per month"
* #2-3-per-week "2-3 times per week" "Drinks alcohol 2-3 times per week"
* #4-plus-per-week "4+ times per week" "Drinks alcohol 4 or more times per week"
* #daily "Daily" "Drinks alcohol daily"

ValueSet: AlcoholBeverageTypeVS
Id: alcohol-beverage-type-vs
Title: "Alcohol Beverage Type ValueSet"
Description: "Types of alcoholic beverages"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system AlcoholBeverageTypeCS

CodeSystem: AlcoholBeverageTypeCS
Id: alcohol-beverage-type-cs
Title: "Alcohol Beverage Type CodeSystem"
Description: "Common alcoholic beverage types"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #beer "Beer" "Beer and malt beverages"
* #wine "Wine" "Wine including red, white, and sparkling"
* #spirits "Spirits" "Distilled spirits (whiskey, vodka, gin, etc.)"
* #cocktails "Cocktails" "Mixed drinks and cocktails"
* #cider "Cider" "Alcoholic cider"
* #fortified-wine "Fortified wine" "Port, sherry, vermouth"

// =============================================================================
// CAFFEINE VALUE SETS
// =============================================================================

ValueSet: CaffeineSourceVS
Id: caffeine-source-vs
Title: "Caffeine Source ValueSet"
Description: "Common sources of dietary caffeine"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system CaffeineSourceCS

CodeSystem: CaffeineSourceCS
Id: caffeine-source-cs
Title: "Caffeine Source CodeSystem"
Description: "Sources of caffeine in diet"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #coffee "Coffee" "Brewed coffee (~95mg per 8oz)"
* #espresso "Espresso" "Espresso (~63mg per shot)"
* #tea "Tea" "Black or green tea (~47mg per 8oz)"
* #energy-drink "Energy drink" "Energy drinks (~80-150mg per can)"
* #soft-drink "Soft drink" "Caffeinated soft drinks (~35mg per 12oz)"
* #chocolate "Chocolate" "Dark chocolate (~23mg per oz)"
* #supplement "Supplement" "Caffeine supplements or pills"
* #pre-workout "Pre-workout" "Pre-workout supplements"

ValueSet: CaffeineIntakeLevelVS
Id: caffeine-intake-level-vs
Title: "Caffeine Intake Level ValueSet"
Description: "Categorical assessment of daily caffeine intake"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system CaffeineIntakeLevelCS

CodeSystem: CaffeineIntakeLevelCS
Id: caffeine-intake-level-cs
Title: "Caffeine Intake Level CodeSystem"
Description: "Risk levels for caffeine intake based on FDA guidelines (<400mg/day moderate)"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #none "None" "No caffeine intake (0mg/day)"
* #low "Low" "Low caffeine intake (<100mg/day)"
* #moderate "Moderate" "Moderate caffeine intake (100-400mg/day)"
* #high "High" "High caffeine intake (>400mg/day)"
* #excessive "Excessive" "Excessive caffeine intake (>600mg/day)"

// =============================================================================
// RECREATIONAL SUBSTANCE VALUE SETS
// =============================================================================

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
* $SCT#228368007 "Has never misused drugs (finding)"
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
// Custom codes for substance categories (SNOMED gap)
* include codes from system RecreationalSubstanceTypeCS

CodeSystem: RecreationalSubstanceTypeCS
Id: recreational-substance-type-cs
Title: "Recreational Substance Type CodeSystem"
Description: """
Custom CodeSystem for recreational substance categories.

**SNOMED CT Gap Documentation**:
SNOMED CT International Edition does not have simple substance class codes that
match clinical terminology expectations. Individual substances exist but class-level
concepts like "opioids" or "benzodiazepines" as substance categories are not available
as expected by clinicians.

This CodeSystem provides clinically relevant categories until SNOMED CT provides
appropriate class-level substance codes.
"""
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/recreational-substance-type-cs"
* #opioids "Opioids" "Opioid class substances (heroin, fentanyl, prescription opioids)"
* #benzodiazepines "Benzodiazepines" "Benzodiazepine class (alprazolam, diazepam, etc.)"
* #hallucinogens "Hallucinogens" "Hallucinogenic substances (LSD, psilocybin, etc.)"
* #sedatives "Sedatives" "Sedative/hypnotic class substances"
* #inhalants "Inhalants" "Volatile substances inhaled for effect"
* #synthetic-cannabinoids "Synthetic cannabinoids" "Synthetic cannabinoid receptor agonists"
* #new-psychoactive "New psychoactive substances" "Novel psychoactive substances (NPS)"

ValueSet: SubstanceUseFrequencyVS
Id: substance-use-frequency-vs
Title: "Substance Use Frequency ValueSet"
Description: "Frequency categories for substance use"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system SubstanceUseFrequencyCS

CodeSystem: SubstanceUseFrequencyCS
Id: substance-use-frequency-cs
Title: "Substance Use Frequency CodeSystem"
Description: "Frequency categories for substance use reporting"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #never "Never" "Never uses this substance"
* #tried-once "Tried once" "Has tried once but does not use"
* #rarely "Rarely" "Less than once per month"
* #monthly "Monthly" "About once per month"
* #weekly "Weekly" "About once per week"
* #several-times-weekly "Several times weekly" "2-6 times per week"
* #daily "Daily" "Daily use"

// =============================================================================
// RISK LEVEL VALUE SET
// =============================================================================

ValueSet: SubstanceUseRiskLevelVS
Id: substance-use-risk-level-vs
Title: "Substance Use Risk Level ValueSet"
Description: "Overall risk assessment for substance use patterns"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system SubstanceUseRiskLevelCS

CodeSystem: SubstanceUseRiskLevelCS
Id: substance-use-risk-level-cs
Title: "Substance Use Risk Level CodeSystem"
Description: "Risk levels for substance use assessment in lifestyle medicine"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #minimal "Minimal risk" "No or minimal substance use concerns"
* #low "Low risk" "Low risk - within recommended guidelines"
* #moderate "Moderate risk" "Moderate risk - exceeds some guidelines"
* #high "High risk" "High risk - significant health concerns"
* #severe "Severe risk" "Severe risk - requires intervention"
