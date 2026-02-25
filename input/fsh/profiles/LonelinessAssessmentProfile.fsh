// =============================================================================
// F2.12.1: Loneliness Assessment Profile
// =============================================================================
// Based on validated instruments:
// - UCLA Loneliness Scale Version 3 (Russell, 1996)
// - 3-Item UCLA Loneliness Scale (Hughes et al., 2004)
//
// References:
// - Russell DW (1996). J Personality Assessment 66(1):20-40. DOI:10.1207/s15327752jpa6601_2
// - Hughes ME et al. (2004). Research on Aging 26(6):655-672. DOI:10.1177/0164027504268574
// - Holt-Lunstad J et al. (2015). Perspectives on Psychological Science 10(2):227-237
// =============================================================================

Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct
Alias: $UCUM = http://unitsofmeasure.org

Profile: LonelinessAssessmentProfile
Parent: Observation
Id: loneliness-assessment
Title: "Loneliness Assessment Profile"
Description: """
Profile for loneliness assessment using validated instruments.

**Primary Instrument**: UCLA Loneliness Scale Version 3 (Russell, 1996)
- 20-item scale measuring subjective feelings of loneliness
- Psychometric properties: Cronbach's alpha = 0.89-0.94, test-retest r = 0.73
- Score range: 20-80 (higher = more loneliness)

**Alternative**: 3-Item UCLA Loneliness Scale (Hughes et al., 2004)
- Suitable for large population surveys and clinical screening
- Items: companionship lack, left out feeling, isolation feeling
- Score range: 3-9 (higher = more loneliness)

**Clinical Relevance**: Meta-analysis (Holt-Lunstad et al., 2015) demonstrates
loneliness associated with 26% increased mortality risk (OR=1.26, 95% CI: 1.04-1.53).

**SNOMED CT**: 267076002 |Feeling lonely (finding)|
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2026-01-12"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = $LOINC#62933-7 "PhenX - social isolation protocol 181001"
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* value[x] only CodeableConcept or integer
* valueCodeableConcept from LonelinessFrequencyVS (required)
* valueInteger ^short = "UCLA Loneliness Scale total score (20-80 or 3-9 for short form)"

* method 0..1 MS
* method from LonelinessAssessmentMethodVS (extensible)

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "UCLA 3-item subscales or full scale components"

* component contains
    uclaTotal 0..1 MS and
    companionshipLack 0..1 MS and
    leftOutFeeling 0..1 MS and
    isolationFeeling 0..1 MS and
    frequencyLonely 0..1 MS

* component[uclaTotal]
  * ^short = "UCLA Loneliness Scale total score"
  * code = $LOINC#66857-4 "How often do you feel alone [UCLA Loneliness v3]"
  * value[x] only integer
  * valueInteger ^short = "Total score: 20-80 (full) or 3-9 (short)"

* component[companionshipLack]
  * ^short = "How often do you feel that you lack companionship?"
  * code = LifestyleMedicineTemporaryCS#companionship-lack "Lack of companionship"
  * value[x] only CodeableConcept
  * valueCodeableConcept from LonelinessItemResponseVS (required)

* component[leftOutFeeling]
  * ^short = "How often do you feel left out?"
  * code = LifestyleMedicineTemporaryCS#left-out "Feeling left out"
  * value[x] only CodeableConcept
  * valueCodeableConcept from LonelinessItemResponseVS (required)

* component[isolationFeeling]
  * ^short = "How often do you feel isolated from others?"
  * code = LifestyleMedicineTemporaryCS#isolation "Feeling isolated"
  * value[x] only CodeableConcept
  * valueCodeableConcept from LonelinessItemResponseVS (required)

* component[frequencyLonely]
  * ^short = "How often do you feel isolated from others?"
  * code = $LOINC#66867-3 "How often do you feel isolated from others"
  * value[x] only CodeableConcept
  * valueCodeableConcept from LonelinessFrequencyVS (required)

* derivedFrom 0..* MS
* derivedFrom only Reference(QuestionnaireResponse)
* derivedFrom ^short = "Reference to completed UCLA questionnaire response"

// =============================================================================
// Value Sets
// =============================================================================

ValueSet: LonelinessFrequencyVS
Id: loneliness-frequency-vs
Title: "Loneliness Frequency Value Set"
Description: "Frequency responses for loneliness assessment"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS

ValueSet: LonelinessItemResponseVS
Id: loneliness-item-response-vs
Title: "Loneliness Item Response Value Set"
Description: "Response options for individual UCLA loneliness items"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS

ValueSet: LonelinessAssessmentMethodVS
Id: loneliness-assessment-method-vs
Title: "Loneliness Assessment Method Value Set"
Description: "Validated instruments for loneliness assessment"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS
