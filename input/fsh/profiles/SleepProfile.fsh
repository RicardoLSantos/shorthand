// =============================================================================
// Sleep Observation Profile - Lifestyle Medicine Pillar
// =============================================================================
// Updated: 2026-01-12
// Added: Comprehensive bibliographic references
//
// SLEEP MEDICINE REFERENCES:
// -----------------------------------------------------------------------------
// Sleep Architecture & Staging:
// - Berry RB et al. (2020). The AASM Manual for the Scoring of Sleep and
//   Associated Events: Rules, Terminology and Technical Specifications v2.6.
//   American Academy of Sleep Medicine. [Gold standard for sleep staging]
// - Ohayon M et al. (2017). National Sleep Foundation's sleep quality
//   recommendations. Sleep Health 3(1):6-19. DOI:10.1016/j.sleh.2016.11.006
//
// Sleep Duration Guidelines:
// - Watson NF et al. (2015). Recommended Amount of Sleep for a Healthy Adult:
//   A Joint Consensus Statement. Sleep 38(6):843-844. DOI:10.5665/sleep.4716
//   [Adults: 7-9 hours; consensus from AASM and Sleep Research Society]
// - Hirshkowitz M et al. (2015). National Sleep Foundation's sleep time duration
//   recommendations. Sleep Health 1(1):40-43. DOI:10.1016/j.sleh.2014.12.010
//
// Sleep Quality Assessment:
// - Buysse DJ et al. (1989). The Pittsburgh Sleep Quality Index: a new instrument
//   for psychiatric practice and research. Psychiatry Res 28(2):193-213.
//   DOI:10.1016/0165-1781(89)90047-4 [PSQI - most cited sleep quality instrument]
// - Carney CE et al. (2012). The Consensus Sleep Diary: standardizing prospective
//   sleep self-monitoring. Sleep 35(2):287-302. DOI:10.5665/sleep.1642
//
// HRV During Sleep:
// - Brandenberger G et al. (2005). Variations in cardiac autonomic activity during
//   sleep. Sleep Med Rev 9(5):395-411. DOI:10.1016/j.smrv.2004.11.002
// - Stein PK & Pu Y. (2012). Heart rate variability, sleep and sleep disorders.
//   Sleep Med Rev 16(1):47-66. DOI:10.1016/j.smrv.2011.02.005
//
// Wearable Sleep Tracking:
// - de Zambotti M et al. (2019). Wearable sleep technology in clinical and
//   research settings. Med Sci Sports Exerc 51(7):1538-1557.
//   DOI:10.1249/MSS.0000000000001947
// - Menghini L et al. (2021). A standardized framework for testing the performance
//   of sleep-tracking technology. Sleep 44(6):zsab006. DOI:10.1093/sleep/zsab006
//
// LOINC Codes:
// - 93832-4: Sleep duration
// - 93829-0: REM sleep duration
// - 93831-6: Sleep efficiency
// - 9279-1: Respiratory rate (during sleep)
// - 80404-7: SDNN (HRV during sleep)
// =============================================================================

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

Profile: SleepObservation
Parent: Observation
Id: activity-observation
Title: "Sleep Observation Profile"
Description: """
Profile for recording sleep data from iOS Health App and wearable devices.

**Sleep Architecture Components**:
- Total Sleep Time (TST): LOINC 93832-4
- Time in Bed (TIB): Custom code
- Sleep stages: Deep, REM (LOINC 93829-0), Light
- Sleep efficiency: TST/TIB × 100%

**Normal Ranges** (Watson et al. 2015, Ohayon et al. 2017):
- Adults 18-64: 7-9 hours recommended
- Deep sleep: 13-23% of TST
- REM sleep: 20-25% of TST
- Sleep efficiency: >85% considered good

**Validated Assessment**: Pittsburgh Sleep Quality Index (Buysse et al. 1989)

References:
- Berry RB et al. (2020). AASM Manual v2.6. American Academy of Sleep Medicine
- Watson NF et al. (2015). Sleep 38(6):843-844. DOI:10.5665/sleep.4716
- Buysse DJ et al. (1989). Psychiatry Res 28(2):193-213
- de Zambotti M et al. (2019). Med Sci Sports Exerc 51(7):1538-1557
"""
 
* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1 MS
* code from LifestyleObservationVS (required)
* code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-panel "Sleep measurement panel"
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 0..1 MS
* effectivePeriod 0..1 MS
* device 0..1 MS
 
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
 
* component contains
    timeInBed 1..1 MS and
    totalSleepTime 1..1 MS and
    deepSleep 0..1 MS and
    remSleep 0..1 MS and
    lightSleep 0..1 MS and
    respiratoryRate 0..1 MS and
    heartRateVariability 0..1 MS and
    interruptions 0..1 MS
 
* component[timeInBed].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-time-bed "Time in bed"
* component[timeInBed].valueQuantity only Quantity
* component[timeInBed].valueQuantity.system = $UCUM
* component[timeInBed].valueQuantity.code = #min
 
* component[totalSleepTime].code = $LOINC#93832-4 "Sleep duration"
* component[totalSleepTime].valueQuantity only Quantity
* component[totalSleepTime].valueQuantity.system = $UCUM
* component[totalSleepTime].valueQuantity.code = #min
 
* component[deepSleep].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-deep "Deep sleep duration"
* component[deepSleep].valueQuantity only Quantity
* component[deepSleep].valueQuantity.system = $UCUM
* component[deepSleep].valueQuantity.code = #min
 
* component[remSleep].code = $LOINC#93829-0 "REM sleep duration"
* component[remSleep].valueQuantity only Quantity
* component[remSleep].valueQuantity.system = $UCUM
* component[remSleep].valueQuantity.code = #min
 
* component[lightSleep].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-light "Light sleep duration"
* component[lightSleep].valueQuantity only Quantity
* component[lightSleep].valueQuantity.system = $UCUM
* component[lightSleep].valueQuantity.code = #min
 
* component[respiratoryRate].code = $LOINC#9279-1 "Respiratory rate"
* component[respiratoryRate].valueQuantity only Quantity
* component[respiratoryRate].valueQuantity.system = $UCUM
* component[respiratoryRate].valueQuantity.code = #/min
 
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* component[heartRateVariability].valueQuantity only Quantity
* component[heartRateVariability].valueQuantity.system = $UCUM
* component[heartRateVariability].valueQuantity.code = #ms
 
* component[interruptions].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#sleep-awakenings "Number of sleep awakenings"
* component[interruptions].valueQuantity only Quantity
* component[interruptions].valueQuantity.system = $UCUM
* component[interruptions].valueQuantity.code = #1
* extension contains SleepQuality named quality 0..1
