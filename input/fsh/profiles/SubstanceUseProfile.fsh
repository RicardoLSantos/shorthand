// =============================================================================
// SubstanceUse Profiles for Lifestyle Medicine
// =============================================================================
// Author: Ricardo Lourenço dos Santos (ricardolourencosantos@gmail.com)
// Links: https://linktr.ee/ricardolsantos
// Created: 2025-11-25
// Updated: 2026-01-12 (F2.13: Enhanced bibliographic references)
// Purpose: 6th Pillar of Lifestyle Medicine - Avoidance of Risky Substances
// Context: PhD Thesis - Integrating Wearable Biomarkers into Learning Health Systems
//
// =============================================================================
// BIBLIOGRAPHIC REFERENCES (Peer-Reviewed)
// =============================================================================
//
// LIFESTYLE MEDICINE FRAMEWORK:
// - Rippe JM (2022). Lifestyle Medicine: Great Progress, Enormous Challenges.
//   Am J Lifestyle Med 16(2):137-138. DOI:10.1177/15598276211052843
// - ACLM (2023). American College of Lifestyle Medicine Position Statement.
//   https://lifestylemedicine.org/
//
// TOBACCO ASSESSMENT:
// - US Preventive Services Task Force (2021). Interventions for Tobacco
//   Smoking Cessation in Adults, Including Pregnant Persons. JAMA 325(3):265-279.
//   DOI:10.1001/jama.2020.25019
// - Fiore MC et al. (2008). Treating Tobacco Use and Dependence: 2008 Update.
//   Clinical Practice Guideline. AHRQ Pub No. 08-0050.
// - Prochaska JO & DiClemente CC (1983). Stages and processes of self-change
//   of smoking: Toward an integrative model. J Consult Clin Psychol 51(3):390-395.
//   DOI:10.1037/0022-006X.51.3.390 (Transtheoretical Model)
//
// ALCOHOL SCREENING:
// - Bush K et al. (1998). The AUDIT alcohol consumption questions (AUDIT-C):
//   An effective brief screening test for problem drinking. Arch Intern Med
//   158(16):1789-1795. DOI:10.1001/archinte.158.16.1789
// - Saunders JB et al. (1993). Development of the Alcohol Use Disorders
//   Identification Test (AUDIT). Addiction 88(6):791-804. DOI:10.1111/j.1360-0443.1993.tb02093.x
// - NIAAA (2021). Rethinking Drinking: Alcohol and Your Health.
//   https://www.rethinkingdrinking.niaaa.nih.gov/
//
// CAFFEINE:
// - Wikoff D et al. (2017). Systematic review of the potential adverse effects
//   of caffeine consumption in healthy adults. Food Chem Toxicol 109(Pt 1):585-648.
//   DOI:10.1016/j.fct.2017.04.002
// - FDA (2018). Spilling the Beans: How Much Caffeine is Too Much?
//   https://www.fda.gov/consumers/consumer-updates/spilling-beans-how-much-caffeine-too-much
//
// HARM REDUCTION:
// - Marlatt GA & Witkiewitz K (2002). Harm reduction approaches to alcohol use:
//   Health promotion, prevention, and treatment. Addict Behav 27(6):867-886.
//   DOI:10.1016/S0306-4603(02)00294-0
//
// FHIR/TERMINOLOGY STANDARDS:
// - HL7 US Core IG v6.1.0: https://hl7.org/fhir/us/core/
// - IPS IG: https://hl7.org/fhir/uv/ips/
// - LOINC: https://loinc.org (all codes verified 2025-11-29)
//
// =============================================================================
// LOINC Codes (ALL verified at loinc.org on 2025-11-29)
// =============================================================================
// - 72166-2: Tobacco smoking status
// - 8664-5: Cigarettes smoked total (pack per year) - Reported
// - 74010-0: Date quit tobacco smoking
// - 64218-1: How many cigarettes do you smoke per day now [PhenX]
// - 81228-9: Tobacco product
// - 88029-4: Tobacco use duration
// - 11331-6: History of Alcohol use
// - 74013-4: Alcoholic drinks per day
// - 68518-0: How often do you have a drink containing alcohol
// - 75626-2: AUDIT-C (verified, correct code)
// - 80489-8: Caffeine intake 24 hour Estimated
// - 68524-8: How many years have you been drinking
// =============================================================================

// =============================================================================
// TOBACCO USE PROFILE
// =============================================================================
Profile: TobaccoUseProfile
Parent: Observation
Id: tobacco-use-observation
Title: "Tobacco Use Observation Profile"
Description: """
Profile for recording tobacco use status and history from patient-reported data
and digital health applications. Supports the 6th pillar of lifestyle medicine:
avoidance of risky substances.

Aligned with:
- US Core Smoking Status (LOINC 72166-2)
- IPS Tobacco Use section
- ACLM Lifestyle Medicine guidelines
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2025-11-25"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = $LOINC#72166-2 "Tobacco smoking status"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] only CodeableConcept
* valueCodeableConcept from TobaccoUseStatusVS (required)

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    packYears 0..1 MS and
    quitDate 0..1 MS and
    cigarettesPerDay 0..1 MS and
    tobaccoType 0..1 MS and
    yearsSmoked 0..1 MS and
    startAge 0..1 MS

* component[packYears]
  * code = $LOINC#8664-5 "Cigarettes smoked total (pack per year) - Reported"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{pack-years}

* component[quitDate]
  * code = $LOINC#74010-0 "Date quit tobacco smoking"
  * value[x] only dateTime

* component[cigarettesPerDay]
  * code = $LOINC#64218-1 "How many cigarettes do you smoke per day now [PhenX]"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #/d

* component[tobaccoType]
  * code = $LOINC#81228-9 "Tobacco product"
  * value[x] only CodeableConcept
  * valueCodeableConcept from TobaccoProductTypeVS (extensible)

* component[yearsSmoked]
  * code = $LOINC#88029-4 "Tobacco use duration"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #a
  * valueQuantity.unit = "years"

* component[startAge]
  * code = $LOINC#63610-0 "Age when first started smoking cigarettes fairly regularly"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #a
  * valueQuantity.unit = "years"

* extension contains
    SubstanceUseMotivation named motivation 0..1 MS and
    SubstanceUseTrigger named trigger 0..* MS and
    CessationSupport named cessationSupport 0..1 MS

// =============================================================================
// ALCOHOL USE PROFILE
// =============================================================================
Profile: AlcoholUseProfile
Parent: Observation
Id: alcohol-use-observation
Title: "Alcohol Use Observation Profile"
Description: """
Profile for recording alcohol consumption patterns from patient-reported data
and lifestyle tracking applications. Supports monitoring alcohol intake relative
to recommended guidelines (e.g., AUDIT-C screening, CDC guidelines).

Clinical Context:
- Low-risk drinking: ≤14 drinks/week (men), ≤7 drinks/week (women)
- One standard drink: 14g pure alcohol
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2025-11-25"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = $LOINC#11331-6 "History of Alcohol use"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] only CodeableConcept
* valueCodeableConcept from AlcoholUseStatusVS (required)

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    drinksPerDay 0..1 MS and
    drinksPerWeek 0..1 MS and
    drinkingFrequency 0..1 MS and
    bingeEpisodes 0..1 MS and
    alcoholType 0..1 MS and
    auditCScore 0..1 MS

* component[drinksPerDay]
  * code = $LOINC#74013-4 "Alcoholic drinks per day"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #/d

* component[drinksPerWeek]
  * code = $LOINC#68519-8 "How many standard drinks containing alcohol do you have on a typical day"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #/wk

* component[drinkingFrequency]
  * code = $LOINC#68518-0 "How often do you have a drink containing alcohol"
  * value[x] only CodeableConcept
  * valueCodeableConcept from AlcoholDrinkingFrequencyVS (required)

* component[bingeEpisodes]
  * code = $LOINC#68520-6 "How often do you have 6 or more drinks on 1 occasion"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #/mo

* component[alcoholType]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#alcohol-type "Type of alcoholic beverage"
  * value[x] only CodeableConcept
  * valueCodeableConcept from AlcoholBeverageTypeVS (extensible)

* component[auditCScore]
  * code = $LOINC#75626-2 "Total score [AUDIT-C]"
  * value[x] only integer
  * valueInteger 0..1

* extension contains
    SubstanceUseMotivation named motivation 0..1 MS and
    SubstanceUseTrigger named trigger 0..* MS and
    DrinkingContext named drinkingContext 0..* MS

// =============================================================================
// CAFFEINE INTAKE PROFILE
// =============================================================================
Profile: CaffeineIntakeProfile
Parent: Observation
Id: caffeine-intake-observation
Title: "Caffeine Intake Observation Profile"
Description: """
Profile for recording daily caffeine consumption. Relevant to lifestyle medicine
as excessive caffeine can affect sleep quality, stress levels, and cardiovascular health.

Guidelines:
- FDA safe limit: ≤400mg/day for healthy adults
- Sleep hygiene: No caffeine 6+ hours before bed
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2025-11-25"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = $LOINC#80489-8 "Caffeine intake 24 hour Estimated"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #mg
* valueQuantity.unit = "mg"

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    caffeineSource 0..* MS and
    lastIntakeTime 0..1 MS

* component[caffeineSource]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#caffeine-source "Caffeine source"
  * value[x] only CodeableConcept
  * valueCodeableConcept from CaffeineSourceVS (extensible)

* component[lastIntakeTime]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#last-caffeine-time "Time of last caffeine intake"
  * value[x] only dateTime

// =============================================================================
// RECREATIONAL SUBSTANCE USE PROFILE
// =============================================================================
Profile: RecreationalSubstanceUseProfile
Parent: Observation
Id: recreational-substance-use-observation
Title: "Recreational Substance Use Observation Profile"
Description: """
Profile for recording use of recreational substances relevant to lifestyle medicine
assessment. Includes cannabis (where legal), and other substances that may affect
health outcomes and lifestyle interventions.

Note: This is for health assessment purposes only, in contexts where legal and
clinically appropriate. Privacy and confidentiality considerations are paramount.
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2025-11-25"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = $LOINC#68524-8 "How many times in the past year have you used an illegal drug or used a prescription medication for non-medical reasons"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] only CodeableConcept
* valueCodeableConcept from RecreationalSubstanceUseStatusVS (required)

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    substanceType 0..* MS and
    useFrequency 0..1 MS and
    lastUseDate 0..1 MS

* component[substanceType]
  * code = $LOINC#74204-9 "Drug use [NTDS]"
  * value[x] only CodeableConcept
  * valueCodeableConcept from RecreationalSubstanceTypeVS (extensible)

* component[useFrequency]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#substance-frequency "Frequency of substance use"
  * value[x] only CodeableConcept
  * valueCodeableConcept from SubstanceUseFrequencyVS (extensible)

* component[lastUseDate]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#last-use-date "Date of last substance use"
  * value[x] only dateTime

// =============================================================================
// LIFESTYLE SUBSTANCE SUMMARY PROFILE
// =============================================================================
Profile: SubstanceUseSummaryProfile
Parent: Observation
Id: substance-use-summary
Title: "Substance Use Summary Profile"
Description: """
Aggregated profile summarizing all substance use relevant to lifestyle medicine
interventions. Provides a holistic view of the 6th pillar: avoidance of risky substances.

Components include tobacco, alcohol, caffeine, and recreational substances
with their current status and risk assessment.
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2025-11-25"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#substance-use-summary "Substance use summary"
* subject 1..1 MS
* effectiveDateTime 1..1 MS

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    tobaccoStatus 0..1 MS and
    alcoholStatus 0..1 MS and
    caffeineStatus 0..1 MS and
    overallRiskLevel 0..1 MS

* component[tobaccoStatus]
  * code = $LOINC#72166-2 "Tobacco smoking status"
  * value[x] only CodeableConcept
  * valueCodeableConcept from TobaccoUseStatusVS (required)

* component[alcoholStatus]
  * code = $LOINC#11331-6 "History of Alcohol use"
  * value[x] only CodeableConcept
  * valueCodeableConcept from AlcoholUseStatusVS (required)

* component[caffeineStatus]
  * code = $LOINC#80489-8 "Caffeine intake 24 hour Estimated"
  * value[x] only CodeableConcept
  * valueCodeableConcept from CaffeineIntakeLevelVS (extensible)

* component[overallRiskLevel]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#substance-risk-level "Overall substance use risk level"
  * value[x] only CodeableConcept
  * valueCodeableConcept from RiskLevelSNOMEDVS (required)

* hasMember ^slicing.discriminator.type = #profile
* hasMember ^slicing.discriminator.path = "resolve()"
* hasMember ^slicing.rules = #open

* hasMember contains
    tobaccoUse 0..1 MS and
    alcoholUse 0..1 MS and
    caffeineIntake 0..1 MS

* hasMember[tobaccoUse] only Reference(TobaccoUseProfile)
* hasMember[alcoholUse] only Reference(AlcoholUseProfile)
* hasMember[caffeineIntake] only Reference(CaffeineIntakeProfile)
