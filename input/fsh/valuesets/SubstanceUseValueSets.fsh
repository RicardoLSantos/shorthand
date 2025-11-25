// ValueSets for SubstanceUse Profiles
// Created: 2025-11-25
// Complementing SubstanceUseProfile.fsh

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org

// =============================================================================
// TOBACCO VALUE SETS
// =============================================================================

ValueSet: TobaccoUseStatusVS
Id: tobacco-use-status-vs
Title: "Tobacco Use Status ValueSet"
Description: "Status categories for tobacco use aligned with US Core and IPS"
* ^experimental = false
* ^version = "0.1.0"
* $SCT#266919005 "Never smoked tobacco (finding)"
* $SCT#8517006 "Ex-smoker (finding)"
* $SCT#77176002 "Smoker (finding)"
* $SCT#449868002 "Smokes tobacco daily (finding)"
* $SCT#428041000124106 "Occasional tobacco smoker (finding)"
* $SCT#266927001 "Tobacco smoking consumption unknown (finding)"
* $SCT#405746006 "Current some day smoker"

ValueSet: TobaccoProductTypeVS
Id: tobacco-product-type-vs
Title: "Tobacco Product Type ValueSet"
Description: "Types of tobacco products"
* ^experimental = false
* ^version = "0.1.0"
* $SCT#722496004 "Cigarette (physical object)"
* $SCT#722498003 "Cigar (physical object)"
* $SCT#722499006 "Pipe (physical object)"
* $SCT#159882006 "Chewing tobacco user (finding)"
* $SCT#228494002 "Snuff taker (finding)"

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
* $SCT#160573003 "Alcohol intake unknown"

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
Description: "Risk levels for caffeine intake"
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
Description: "Status categories for recreational substance use"
* ^experimental = false
* ^version = "0.1.0"
* $SCT#228366006 "Finding relating to drug misuse behavior (finding)"
* $SCT#44870007 "Substance misuse (finding)"
* $SCT#707848009 "Never used recreational drugs (finding)"
* $SCT#228368007 "Former drug user (finding)"
* $SCT#228369004 "Current drug user (finding)"

ValueSet: RecreationalSubstanceTypeVS
Id: recreational-substance-type-vs
Title: "Recreational Substance Type ValueSet"
Description: "Types of recreational substances (where legal and clinically appropriate)"
* ^experimental = false
* ^version = "0.1.0"
* $SCT#398705004 "Cannabis (substance)"
* $SCT#387173000 "Opioid analgesic (substance)"
* $SCT#387286002 "Benzodiazepine (substance)"
* $SCT#387085005 "Cocaine (substance)"
* $SCT#387499002 "Amphetamine (substance)"
* $SCT#229003004 "Hallucinogenic drug (substance)"

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
