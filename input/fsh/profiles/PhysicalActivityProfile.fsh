// =============================================================================
// Physical Activity Observation Profile - Lifestyle Medicine Pillar
// =============================================================================
// Updated: 2026-01-12
// Added: Comprehensive bibliographic references
//
// PHYSICAL ACTIVITY GUIDELINES & REFERENCES:
// -----------------------------------------------------------------------------
// International Guidelines:
// - WHO (2020). WHO guidelines on physical activity and sedentary behaviour.
//   World Health Organization. ISBN: 978-92-4-001512-8
//   [Adults: 150-300 min/week moderate OR 75-150 min/week vigorous]
// - Bull FC et al. (2020). World Health Organization 2020 guidelines on physical
//   activity and sedentary behaviour. Br J Sports Med 54(24):1451-1462.
//   DOI:10.1136/bjsports-2020-102955
//
// US Guidelines:
// - Piercy KL et al. (2018). The Physical Activity Guidelines for Americans.
//   JAMA 320(19):2020-2028. DOI:10.1001/jama.2018.14854
// - 2018 Physical Activity Guidelines Advisory Committee. (2018). 2018 Physical
//   Activity Guidelines Advisory Committee Scientific Report. US DHHS.
//
// Measurement & Assessment:
// - Bassett DR et al. (2017). Step counting: a review of measurement
//   considerations and health-related applications. Sports Med 47(7):1303-1315.
//   DOI:10.1007/s40279-016-0663-1 [10,000 steps/day target evidence]
// - Tudor-Locke C et al. (2011). How many steps/day are enough? For adults.
//   Int J Behav Nutr Phys Act 8:79. DOI:10.1186/1479-5868-8-79
//
// Energy Expenditure:
// - Ainsworth BE et al. (2011). 2011 Compendium of Physical Activities: a second
//   update of codes and MET values. Med Sci Sports Exerc 43(8):1575-1581.
//   DOI:10.1249/MSS.0b013e31821ece12 [MET values reference]
// - Schofield WN. (1985). Predicting basal metabolic rate. Hum Nutr Clin Nutr
//   39(Suppl 1):5-41. [BMR equations for TDEE calculation]
//
// Wearable Activity Tracking:
// - Evenson KR et al. (2015). Systematic review of the validity and reliability
//   of consumer-wearable activity trackers. Int J Behav Nutr Phys Act 12:159.
//   DOI:10.1186/s12966-015-0314-1
// - Fuller D et al. (2020). Reliability and validity of commercially available
//   wearable devices for measuring steps, energy expenditure, and heart rate.
//   JMIR Mhealth Uhealth 8(9):e18694. DOI:10.2196/18694
//
// LOINC Codes:
// - 55423-8: Number of steps in unspecified time Pedometer
// - 55430-3: Walking distance unspecified time Pedometer
// - 55411-3: Exercise duration
// - 55424-6: Calories burned in unspecified time Pedometer
// - 82290-8: Physical activity guidelines met [Boolean]
// =============================================================================

Alias: $LOINC = http://loinc.org
Alias: $SNOMED = http://snomed.info/sct
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ActivityCodes = https://2rdoc.pt/ig/ios-lifestyle-medicine/activity-codes

Profile: PhysicalActivityObservation
Parent: Observation
Id: physical-activity-observation
Title: "Physical Activity Observation Profile"
Description: """
Profile for recording physical activity data from iOS Health App and wearables.

**WHO 2020 Guidelines** (Bull et al. 2020):
- Adults 18-64: 150-300 min/week moderate OR 75-150 min/week vigorous
- Muscle-strengthening activities ≥2 days/week
- Reduce sedentary time; replace with any intensity activity

**Step Count Evidence** (Tudor-Locke et al. 2011):
- <5,000 steps/day: Sedentary
- 5,000-7,499: Low active
- 7,500-9,999: Somewhat active
- ≥10,000: Active
- ≥12,500: Highly active

**MET Reference**: Compendium of Physical Activities (Ainsworth et al. 2011)

References:
- WHO (2020). WHO guidelines on physical activity. ISBN: 978-92-4-001512-8
- Bull FC et al. (2020). Br J Sports Med 54(24):1451-1462
- Tudor-Locke C et al. (2011). Int J Behav Nutr Phys Act 8:79
- Ainsworth BE et al. (2011). Med Sci Sports Exerc 43(8):1575-1581
"""

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code 1..1 MS
* code from PhysicalActivityTypeVS (required)
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* device 0..1 MS
* value[x] only Quantity
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    steps 0..1 MS and
    distance 0..1 MS and
    duration 0..1 MS and
    energy 0..1 MS

* component[steps].code = $LOINC#55423-8 "Number of steps in unspecified time Pedometer"
* component[steps].valueQuantity only Quantity
* component[steps].valueQuantity.system = $UCUM
* component[steps].valueQuantity.code = #1 "count"

* component[distance].code = $LOINC#55430-3 "Walking distance unspecified time Pedometer"
* component[distance].valueQuantity only Quantity
* component[distance].valueQuantity.system = $UCUM
* component[distance].valueQuantity.code = #km "kilometer"

* component[duration].code = $LOINC#55411-3 "Exercise duration"
* component[duration].valueQuantity only Quantity
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min "minute"

* component[energy].code = $LOINC#55424-6 "Calories burned in unspecified time Pedometer"
* component[energy].valueQuantity only Quantity
* component[energy].valueQuantity.system = $UCUM
* component[energy].valueQuantity.code = #kcal "kilocalorie"
