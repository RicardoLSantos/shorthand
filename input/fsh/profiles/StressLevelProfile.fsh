// =============================================================================
// Stress Level Profile - Lifestyle Medicine Pillar
// =============================================================================
// Updated: 2026-01-12
// Added: Comprehensive bibliographic references
//
// STRESS ASSESSMENT REFERENCES:
// -----------------------------------------------------------------------------
// Perceived Stress Scale (PSS):
// - Cohen S, Kamarck T, Mermelstein R. (1983). A global measure of perceived
//   stress. J Health Soc Behav 24(4):385-396. DOI:10.2307/2136404
//   [PSS-14, PSS-10, PSS-4 versions; most widely used stress measure]
// - Lee EH. (2012). Review of the psychometric evidence of the perceived stress
//   scale. Asian Nurs Res 6(4):121-127. DOI:10.1016/j.anr.2012.08.004
//
// Stress Physiology & HRV:
// - Thayer JF et al. (2012). A meta-analysis of heart rate variability and
//   neuroimaging studies: implications for HRV as a marker of stress and health.
//   Neurosci Biobehav Rev 36(2):747-756. DOI:10.1016/j.neubiorev.2011.11.009
// - Kim HG et al. (2018). Stress and heart rate variability: a meta-analysis and
//   review of the literature. Psychiatry Investig 15(3):235-245.
//   DOI:10.30773/pi.2017.08.17
//
// Chronic Stress & Health:
// - McEwen BS. (2008). Central effects of stress hormones in health and disease:
//   Understanding the protective and damaging effects of stress and stress
//   mediators. Eur J Pharmacol 583(2-3):174-185. DOI:10.1016/j.ejphar.2007.11.071
//   [Allostatic load concept]
// - Steptoe A & Kivimäki M. (2012). Stress and cardiovascular disease. Nat Rev
//   Cardiol 9(6):360-370. DOI:10.1038/nrcardio.2012.45
//
// Workplace Stress:
// - Karasek R et al. (1998). The Job Content Questionnaire (JCQ): An instrument
//   for internationally comparative assessments of psychosocial job
//   characteristics. J Occup Health Psychol 3(4):322-355.
// - Siegrist J. (1996). Adverse health effects of high-effort/low-reward
//   conditions. J Occup Health Psychol 1(1):27-41. [Effort-Reward Imbalance]
//
// Wearable Stress Detection:
// - Can YS et al. (2019). Stress detection in daily life scenarios using smart
//   phones and wearable sensors: A survey. J Biomed Inform 92:103139.
//   DOI:10.1016/j.jbi.2019.103139
// - Gjoreski M et al. (2017). Monitoring stress with a wrist device using context.
//   J Biomed Inform 73:159-170. DOI:10.1016/j.jbi.2017.08.006
//
// LOINC Codes:
// - 64394-0: PhenX - perceived stress protocol 180801
// - 66534-9: PSS-10 total score
// - 44255-8: Feeling stressed assessment
// =============================================================================

Profile: StressLevelProfile
Parent: Observation
Id: stress-level
Title: "Stress Level Profile"
Description: """
Profile for recording stress level measurements from iOS Health App and wearables.

**Perceived Stress Scale (PSS)** (Cohen et al. 1983):
- PSS-10: 10 items, scores 0-40
  - Low stress: 0-13
  - Moderate stress: 14-26
  - High stress: 27-40
- LOINC 66534-9 for PSS-10 total score

**Physiological Stress Markers**:
- HRV: Reduced SDNN/RMSSD indicates stress (Thayer et al. 2012)
- Electrodermal activity (EDA): Increased with acute stress
- Cortisol awakening response (CAR)

**Chronic Stress Impact** (McEwen 2008, Steptoe & Kivimäki 2012):
- Allostatic load: cumulative physiological dysregulation
- CVD risk: OR 1.5-2.0 for high chronic stress
- Immune suppression and inflammation

References:
- Cohen S et al. (1983). J Health Soc Behav 24(4):385-396
- Thayer JF et al. (2012). Neurosci Biobehav Rev 36(2):747-756
- McEwen BS. (2008). Eur J Pharmacol 583(2-3):174-185
- Can YS et al. (2019). J Biomed Inform 92:103139
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2026-01-12"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code 1..1 MS
* code = $LOINC#64394-0 "PhenX - perceived stress protocol 180801"
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* value[x] only Quantity
* valueQuantity MS

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    physiologicalStress 0..1 MS and
    psychologicalStress 0..1 MS and
    chronicity 0..1 MS and 
    impact 0..1 MS

* component[physiologicalStress]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#stress-physiological "Physiological stress indicator"
  * valueQuantity only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #1

* component[psychologicalStress]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#stress-psychological "Psychological stress score"
  * valueQuantity only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #1

* component[chronicity]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#stress-chronicity "Stress chronicity assessment"
  * valueCodeableConcept from StressChronicityVS (required)

* component[impact]
  * code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#stress-impact "Stress impact assessment"
  * valueCodeableConcept from StressImpactVS (required)

* extension contains
    MeasurementContext named context 0..1 MS and
    StressTriggers named triggers 0..* MS and 
    StressCoping named coping 0..* MS
