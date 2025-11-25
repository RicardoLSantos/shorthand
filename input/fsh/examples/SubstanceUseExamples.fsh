// Examples for SubstanceUse Profiles
// Created: 2025-11-25
// Complementing SubstanceUseProfile.fsh

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $UCUM = http://unitsofmeasure.org

// =============================================================================
// TOBACCO USE EXAMPLES
// =============================================================================

Instance: TobaccoUseExSmokerExample
InstanceOf: TobaccoUseProfile
Usage: #example
Title: "Ex-Smoker with Pack-Years History"
Description: "Example of a former smoker with documented pack-years and quit date"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#72166-2 "Tobacco smoking status"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* valueCodeableConcept = $SCT#8517006 "Ex-smoker (finding)"
* component[packYears].code = $LOINC#8664-5 "Cigarettes smoked total (pack per year) - Reported"
* component[packYears].valueQuantity = 15 '{pack-years}' "pack-years"
* component[quitDate].code = $LOINC#74010-0 "Date quit tobacco smoking"
* component[quitDate].valueDateTime = "2020-03-15"
* component[cigarettesPerDay].code = $LOINC#64218-1 "How many cigarettes do you smoke per day now [PhenX]"
* component[cigarettesPerDay].valueQuantity = 0 '/d' "per day"

Instance: TobaccoUseCurrentSmokerExample
InstanceOf: TobaccoUseProfile
Usage: #example
Title: "Current Daily Smoker"
Description: "Example of a current smoker with motivation assessment"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#72166-2 "Tobacco smoking status"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* valueCodeableConcept = $SCT#449868002 "Smokes tobacco daily (finding)"
* component[cigarettesPerDay].code = $LOINC#64218-1 "How many cigarettes do you smoke per day now [PhenX]"
* component[cigarettesPerDay].valueQuantity = 20 '/d' "per day"
* component[tobaccoType].code = $LOINC#81228-9 "Tobacco product"
* component[tobaccoType].valueCodeableConcept = $SCT#722496004 "Cigarette"
* extension[motivation].valueCodeableConcept = SubstanceUseMotivationCS#contemplation "Contemplation"
* extension[trigger][0].valueCodeableConcept = SubstanceUseTriggerCS#stress "Stress"
* extension[trigger][1].valueCodeableConcept = SubstanceUseTriggerCS#morning "Morning routine"

Instance: TobaccoUseNeverSmokerExample
InstanceOf: TobaccoUseProfile
Usage: #example
Title: "Never Smoker"
Description: "Example of a patient who has never smoked tobacco"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#72166-2 "Tobacco smoking status"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* valueCodeableConcept = $SCT#266919005 "Never smoked tobacco (finding)"

// =============================================================================
// ALCOHOL USE EXAMPLES
// =============================================================================

Instance: AlcoholUseModerateExample
InstanceOf: AlcoholUseProfile
Usage: #example
Title: "Moderate Social Drinker"
Description: "Example of moderate alcohol consumption with AUDIT-C score"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#11331-6 "History of Alcohol use"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* valueCodeableConcept = $SCT#43783005 "Moderate drinker (finding)"
* component[drinksPerWeek].code = $LOINC#68519-8 "How many standard drinks containing alcohol do you have on a typical day"
* component[drinksPerWeek].valueQuantity = 7 '/wk' "per week"
* component[drinkingFrequency].code = $LOINC#68518-0 "How often do you have a drink containing alcohol"
* component[drinkingFrequency].valueCodeableConcept = AlcoholDrinkingFrequencyCS#2-3-per-week "2-3 times per week"
* component[auditCScore].code = $LOINC#75626-2 "Total score [AUDIT-C]"
* component[auditCScore].valueInteger = 4
* component[alcoholType].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#alcohol-type "Type of alcoholic beverage"
* component[alcoholType].valueCodeableConcept = AlcoholBeverageTypeCS#wine "Wine"
* extension[drinkingContext].valueCodeableConcept = DrinkingContextCS#restaurant "Restaurant/dining"

Instance: AlcoholUseNonDrinkerExample
InstanceOf: AlcoholUseProfile
Usage: #example
Title: "Non-Drinker"
Description: "Example of a patient who does not consume alcohol"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#11331-6 "History of Alcohol use"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* valueCodeableConcept = $SCT#105542008 "Non-drinker of alcohol (finding)"
* component[drinkingFrequency].code = $LOINC#68518-0 "How often do you have a drink containing alcohol"
* component[drinkingFrequency].valueCodeableConcept = AlcoholDrinkingFrequencyCS#never "Never"
* component[auditCScore].code = $LOINC#75626-2 "Total score [AUDIT-C]"
* component[auditCScore].valueInteger = 0

Instance: AlcoholUseHighRiskExample
InstanceOf: AlcoholUseProfile
Usage: #example
Title: "High-Risk Drinker"
Description: "Example of high-risk alcohol consumption with binge episodes"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#11331-6 "History of Alcohol use"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* valueCodeableConcept = $SCT#228279004 "Heavy drinker (finding)"
* component[drinksPerWeek].code = $LOINC#68519-8 "How many standard drinks containing alcohol do you have on a typical day"
* component[drinksPerWeek].valueQuantity = 21 '/wk' "per week"
* component[drinkingFrequency].code = $LOINC#68518-0 "How often do you have a drink containing alcohol"
* component[drinkingFrequency].valueCodeableConcept = AlcoholDrinkingFrequencyCS#daily "Daily"
* component[bingeEpisodes].code = $LOINC#68520-6 "How often do you have 6 or more drinks on 1 occasion"
* component[bingeEpisodes].valueQuantity = 4 '/mo' "per month"
* component[auditCScore].code = $LOINC#75626-2 "Total score [AUDIT-C]"
* component[auditCScore].valueInteger = 9
* extension[motivation].valueCodeableConcept = SubstanceUseMotivationCS#precontemplation "Precontemplation"
* extension[trigger][0].valueCodeableConcept = SubstanceUseTriggerCS#stress "Stress"

// =============================================================================
// CAFFEINE INTAKE EXAMPLES
// =============================================================================

Instance: CaffeineIntakeModerateExample
InstanceOf: CaffeineIntakeProfile
Usage: #example
Title: "Moderate Caffeine Consumer"
Description: "Example of moderate daily caffeine intake from multiple sources"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#80489-8 "Caffeine intake 24 hour Estimated"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* valueQuantity = 300 'mg' "mg"
* component[caffeineSource][0].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#caffeine-source "Caffeine source"
* component[caffeineSource][0].valueCodeableConcept = CaffeineSourceCS#coffee "Coffee"
* component[caffeineSource][1].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#caffeine-source "Caffeine source"
* component[caffeineSource][1].valueCodeableConcept = CaffeineSourceCS#tea "Tea"
* component[lastIntakeTime].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#last-caffeine-time "Time of last caffeine intake"
* component[lastIntakeTime].valueDateTime = "2025-11-25T15:00:00Z"

Instance: CaffeineIntakeHighExample
InstanceOf: CaffeineIntakeProfile
Usage: #example
Title: "High Caffeine Consumer"
Description: "Example of excessive caffeine intake requiring intervention"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#80489-8 "Caffeine intake 24 hour Estimated"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* valueQuantity = 600 'mg' "mg"
* component[caffeineSource][0].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#caffeine-source "Caffeine source"
* component[caffeineSource][0].valueCodeableConcept = CaffeineSourceCS#energy-drink "Energy drink"
* component[caffeineSource][1].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#caffeine-source "Caffeine source"
* component[caffeineSource][1].valueCodeableConcept = CaffeineSourceCS#coffee "Coffee"

// =============================================================================
// SUBSTANCE USE SUMMARY EXAMPLE
// =============================================================================

Instance: SubstanceUseSummaryExample
InstanceOf: SubstanceUseSummaryProfile
Usage: #example
Title: "Substance Use Summary"
Description: "Comprehensive summary of patient's substance use patterns for lifestyle medicine assessment"
* status = #final
* category = $ObsCat#social-history "Social History"
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#substance-use-summary "Substance use summary"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* component[tobaccoStatus].code = $LOINC#72166-2 "Tobacco smoking status"
* component[tobaccoStatus].valueCodeableConcept = $SCT#8517006 "Ex-smoker (finding)"
* component[alcoholStatus].code = $LOINC#11331-6 "History of Alcohol use"
* component[alcoholStatus].valueCodeableConcept = $SCT#43783005 "Moderate drinker (finding)"
* component[caffeineStatus].code = $LOINC#80489-8 "Caffeine intake 24 hour Estimated"
* component[caffeineStatus].valueCodeableConcept = CaffeineIntakeLevelCS#moderate "Moderate"
* component[overallRiskLevel].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#substance-risk-level "Overall substance use risk level"
* component[overallRiskLevel].valueCodeableConcept = SubstanceUseRiskLevelCS#low "Low risk"
* hasMember[tobaccoUse] = Reference(TobaccoUseExSmokerExample)
* hasMember[alcoholUse] = Reference(AlcoholUseModerateExample)
* hasMember[caffeineIntake] = Reference(CaffeineIntakeModerateExample)
