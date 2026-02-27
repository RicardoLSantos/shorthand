// =============================================================================
// F2.12.2: Social Support Assessment Profile
// =============================================================================
// Based on validated instruments:
// - MSPSS: Multidimensional Scale of Perceived Social Support (Zimet et al., 1988)
// - Duke-UNC FSSQ: Functional Social Support Questionnaire (Broadhead et al., 1988)
// - MOS-SSS: Medical Outcomes Study Social Support Survey (Sherbourne & Stewart, 1991)
//
// References:
// - Zimet GD et al. (1988). J Personality Assessment 52(1):30-41. DOI:10.1207/s15327752jpa5201_2
// - Broadhead WE et al. (1988). Medical Care 26(7):709-723
// - Sherbourne CD & Stewart AL (1991). Social Science & Medicine 32(6):705-714
// =============================================================================

Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct
Alias: $UCUM = http://unitsofmeasure.org
Alias: $ObsInt = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0

Profile: SocialSupportAssessmentProfile
Parent: Observation
Id: social-support-assessment
Title: "Social Support Assessment Profile"
Description: """
Profile for social support assessment using validated instruments.

**Primary Instrument**: MSPSS - Multidimensional Scale of Perceived Social Support (Zimet et al., 1988)
- 12-item scale measuring perceived support from family, friends, and significant other
- Three subscales: Family (4 items), Friends (4 items), Significant Other (4 items)
- Score range: 12-84 (each item 1-7); subscale range: 4-28
- Psychometric properties: Cronbach's alpha = 0.88, test-retest r = 0.85

**Alternative**: Duke-UNC Functional Social Support Questionnaire (Broadhead et al., 1988)
- 8-item scale for primary care settings
- Two factors: Confidant support, Affective support
- Score range: 8-40

**Clinical Relevance**: Strong social support associated with 50% reduced mortality risk
(Holt-Lunstad et al., 2010, PLoS Medicine). Low support linked to depression, CVD, poor recovery.

**LOINC**: 91642-9 |Medical Outcomes Study Social Support Survey panel [MOS Social Support Survey]|
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2026-01-12"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = $LOINC#91642-9 "Medical Outcomes Study Social Support Survey panel [MOS Social Support Survey]"
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* value[x] only CodeableConcept or Quantity
* valueCodeableConcept from SocialSupportLevelVS (extensible)
* valueQuantity ^short = "MSPSS total score (12-84) or Duke-UNC score (8-40)"
* valueQuantity.system = $UCUM
* valueQuantity.code = #{score}

* method 0..1 MS
* method from SocialSupportAssessmentMethodVS (extensible)

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "MSPSS subscales: Family, Friends, Significant Other"

* component contains
    totalScore 0..1 MS and
    familySupport 0..1 MS and
    friendSupport 0..1 MS and
    significantOtherSupport 0..1 MS and
    confidantSupport 0..1 MS and
    affectiveSupport 0..1 MS

* component[totalScore]
  * ^short = "Total social support score"
  * code = LifestyleMedicineTemporaryCS#total-score "Total support score"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{score}

* component[familySupport]
  * ^short = "MSPSS Family subscale (4 items, range 4-28)"
  * code = LifestyleMedicineTemporaryCS#family-support "Family support subscale"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{score}

* component[friendSupport]
  * ^short = "MSPSS Friends subscale (4 items, range 4-28)"
  * code = LifestyleMedicineTemporaryCS#friend-support "Friends support subscale"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{score}

* component[significantOtherSupport]
  * ^short = "MSPSS Significant Other subscale (4 items, range 4-28)"
  * code = LifestyleMedicineTemporaryCS#significant-other-support "Significant other support subscale"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{score}

* component[confidantSupport]
  * ^short = "Duke-UNC Confidant support factor"
  * code = LifestyleMedicineTemporaryCS#confidant-support "Confidant support"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{score}

* component[affectiveSupport]
  * ^short = "Duke-UNC Affective support factor"
  * code = LifestyleMedicineTemporaryCS#affective-support "Affective support"
  * value[x] only Quantity
  * valueQuantity.system = $UCUM
  * valueQuantity.code = #{score}

* interpretation 0..1 MS
* interpretation from SocialSupportInterpretationVS (extensible)
* interpretation ^short = "Low/Medium/High social support interpretation"

* derivedFrom 0..* MS
* derivedFrom only Reference(QuestionnaireResponse)
* derivedFrom ^short = "Reference to completed MSPSS or Duke-UNC questionnaire"

// =============================================================================
// Value Sets
// =============================================================================

ValueSet: SocialSupportLevelVS
Id: social-support-level-vs
Title: "Social Support Level Value Set"
Description: "Levels of perceived social support"
* ^experimental = false
* AppLogicCS#social-support-level-high "High Support"
* AppLogicCS#social-support-level-moderate "Moderate Support"
* AppLogicCS#social-support-level-low "Low Support"
* AppLogicCS#social-support-level-very-low "Very Low Support"

ValueSet: SocialSupportAssessmentMethodVS
Id: social-support-assessment-method-vs
Title: "Social Support Assessment Method Value Set"
Description: "Validated instruments for social support assessment"
* ^experimental = false
* LifestyleMedicineTemporaryCS#mspss "MSPSS"
* LifestyleMedicineTemporaryCS#duke-unc "Duke-UNC FSSQ"
* LifestyleMedicineTemporaryCS#mos-sss "MOS-SSS"
* LifestyleMedicineTemporaryCS#ssq6 "SSQ6"
* LifestyleMedicineTemporaryCS#isel "ISEL"
* LifestyleMedicineTemporaryCS#social-support-assessment-method-clinical "Clinical Assessment"

ValueSet: SocialSupportInterpretationVS
Id: social-support-interpretation-vs
Title: "Social Support Interpretation Value Set"
Description: "Clinical interpretation of social support scores"
* ^experimental = false
* $ObsInt#H "High"
* $ObsInt#N "Normal"
* $ObsInt#L "Low"
* $ObsInt#LL "Critical Low"
