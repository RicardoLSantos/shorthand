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
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = $SCT#8517006 "Ex-smoker (finding)"
* component[packYears].code = $LOINC#8664-5 "Cigarettes smoked total (pack per year) - Reported"
* component[packYears].valueQuantity = 15 '{pack-years}' "{pack-years}"
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
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = $SCT#449868002 "Smokes tobacco daily (finding)"
* component[cigarettesPerDay].code = $LOINC#64218-1 "How many cigarettes do you smoke per day now [PhenX]"
* component[cigarettesPerDay].valueQuantity = 20 '/d' "per day"
* component[tobaccoType].code = $LOINC#81228-9 "Tobacco product"
* component[tobaccoType].valueCodeableConcept = $SCT#722496004 "Cigarette"
* extension[motivation].valueCodeableConcept = LifestyleMedicineTemporaryCS#contemplation "Contemplation"
* extension[trigger][0].valueCodeableConcept = LifestyleMedicineTemporaryCS#substance-trigger-stress "Stress"
* extension[trigger][1].valueCodeableConcept = LifestyleMedicineTemporaryCS#morning "Morning routine"

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
* performer = Reference(Practitioner/PractitionerExample)
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
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = $SCT#43783005 "Moderate drinker (finding)"
* component[drinksPerWeek].code = $LOINC#68519-8 "How many standard drinks containing alcohol do you have on a typical day"
* component[drinksPerWeek].valueQuantity = 7 '/wk' "per week"
* component[drinkingFrequency].code = $LOINC#68518-0 "How often do you have a drink containing alcohol"
* component[drinkingFrequency].valueCodeableConcept = LifestyleMedicineTemporaryCS#2-3-per-week "2-3 times per week"
* component[auditCScore].code = $LOINC#75626-2 "Total score [AUDIT-C]"
* component[auditCScore].valueInteger = 4
* component[alcoholType].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#alcohol-type "Type of alcoholic beverage"
* component[alcoholType].valueCodeableConcept = LifestyleMedicineTemporaryCS#wine "Wine"
* extension[drinkingContext].valueCodeableConcept = LifestyleMedicineTemporaryCS#restaurant "Restaurant/dining"

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
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = $SCT#105542008 "Non-drinker of alcohol (finding)"
* component[drinkingFrequency].code = $LOINC#68518-0 "How often do you have a drink containing alcohol"
* component[drinkingFrequency].valueCodeableConcept = LifestyleMedicineTemporaryCS#alcohol-freq-never "Never"
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
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = $SCT#228279004 "Heavy drinker (finding)"
* component[drinksPerWeek].code = $LOINC#68519-8 "How many standard drinks containing alcohol do you have on a typical day"
* component[drinksPerWeek].valueQuantity = 21 '/wk' "per week"
* component[drinkingFrequency].code = $LOINC#68518-0 "How often do you have a drink containing alcohol"
* component[drinkingFrequency].valueCodeableConcept = LifestyleMedicineTemporaryCS#alcohol-freq-daily "Daily"
* component[bingeEpisodes].code = $LOINC#68520-6 "How often do you have 6 or more drinks on 1 occasion"
* component[bingeEpisodes].valueQuantity = 4 '/mo' "per month"
* component[auditCScore].code = $LOINC#75626-2 "Total score [AUDIT-C]"
* component[auditCScore].valueInteger = 9
* extension[motivation].valueCodeableConcept = LifestyleMedicineTemporaryCS#precontemplation "Precontemplation"
* extension[trigger][0].valueCodeableConcept = LifestyleMedicineTemporaryCS#substance-trigger-stress "Stress"

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
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity = 300 'mg' "mg"
* component[caffeineSource][0].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#caffeine-source "Caffeine source"
* component[caffeineSource][0].valueCodeableConcept = LifestyleMedicineTemporaryCS#coffee "Coffee"
* component[caffeineSource][1].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#caffeine-source "Caffeine source"
* component[caffeineSource][1].valueCodeableConcept = LifestyleMedicineTemporaryCS#tea "Tea"
* component[lastIntakeTime].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#last-caffeine-time "Time of last caffeine intake"
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
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity = 600 'mg' "mg"
* component[caffeineSource][0].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#caffeine-source "Caffeine source"
* component[caffeineSource][0].valueCodeableConcept = LifestyleMedicineTemporaryCS#energy-drink "Energy drink"
* component[caffeineSource][1].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#caffeine-source "Caffeine source"
* component[caffeineSource][1].valueCodeableConcept = LifestyleMedicineTemporaryCS#coffee "Coffee"

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
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#substance-use-summary "Substance use summary"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-25T10:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* component[tobaccoStatus].code = $LOINC#72166-2 "Tobacco smoking status"
* component[tobaccoStatus].valueCodeableConcept = $SCT#8517006 "Ex-smoker (finding)"
* component[alcoholStatus].code = $LOINC#11331-6 "History of Alcohol use"
* component[alcoholStatus].valueCodeableConcept = $SCT#43783005 "Moderate drinker (finding)"
* component[caffeineStatus].code = $LOINC#80489-8 "Caffeine intake 24 hour Estimated"
* component[caffeineStatus].valueCodeableConcept = LifestyleMedicineTemporaryCS#caffeine-level-moderate "Moderate"
* component[overallRiskLevel].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#substance-risk-level "Overall substance use risk level"
* component[overallRiskLevel].valueCodeableConcept = LifestyleMedicineTemporaryCS#substance-risk-low "Low risk"
* hasMember[tobaccoUse] = Reference(TobaccoUseExSmokerExample)
* hasMember[alcoholUse] = Reference(AlcoholUseModerateExample)
* hasMember[caffeineIntake] = Reference(CaffeineIntakeModerateExample)


// =============================================================================
// RECREATIONAL SUBSTANCE USE EXAMPLE
// =============================================================================

Instance: RecreationalSubstanceUseExample
InstanceOf: RecreationalSubstanceUseProfile
Usage: #example
Title: "Recreational Substance Use Screening"
Description: "Example of recreational substance use screening as part of lifestyle medicine assessment, with cessation-support extension"

* status = #final
* category = $ObsCat#social-history "Social History"
* code = $LOINC#68524-8 "How many times in the past year have you used an illegal drug or used a prescription medication for non-medical reasons"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-27T10:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

// Status: former user
* valueCodeableConcept = $SCT#44870007 "Ex-drug user (finding)"

// Substance type: cannabis
* component[substanceType].code = $LOINC#74204-9 "Drug use [NTDS]"
* component[substanceType].valueCodeableConcept = $SCT#398705004 "Cannabis (substance)"

// Frequency: rarely
* component[useFrequency].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#substance-frequency "Frequency of substance use"
* component[useFrequency].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#substance-freq-never "Never"

// Last use date
* component[lastUseDate].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#last-use-date "Date of last substance use"
* component[lastUseDate].valueDateTime = "2024-06-15T00:00:00Z"

// Cessation Support extension (not a named slice in RecreationalSubstanceUseProfile)
* extension[0].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/cessation-support"
* extension[0].extension[0].url = "method"
* extension[0].extension[0].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#counseling "Counseling"
* extension[0].extension[1].url = "status"
* extension[0].extension[1].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#cessation-status-completed "Completed"
* extension[0].extension[2].url = "startDate"
* extension[0].extension[2].valueDate = "2024-01-10"

* note.text = "Former cannabis user. Ceased use in June 2024 with counseling support. No current substance use concerns."
