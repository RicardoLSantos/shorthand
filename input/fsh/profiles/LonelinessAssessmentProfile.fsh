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
* code = $LOINC#67233-9 "How often do you feel lonely"
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
  * code = $LOINC#71956-6 "UCLA Loneliness Scale score"
  * value[x] only integer
  * valueInteger ^short = "Total score: 20-80 (full) or 3-9 (short)"

* component[companionshipLack]
  * ^short = "How often do you feel that you lack companionship?"
  * code = LonelinessComponentCS#companionship-lack "Lack of companionship"
  * value[x] only CodeableConcept
  * valueCodeableConcept from LonelinessItemResponseVS (required)

* component[leftOutFeeling]
  * ^short = "How often do you feel left out?"
  * code = LonelinessComponentCS#left-out "Feeling left out"
  * value[x] only CodeableConcept
  * valueCodeableConcept from LonelinessItemResponseVS (required)

* component[isolationFeeling]
  * ^short = "How often do you feel isolated from others?"
  * code = LonelinessComponentCS#isolation "Feeling isolated"
  * value[x] only CodeableConcept
  * valueCodeableConcept from LonelinessItemResponseVS (required)

* component[frequencyLonely]
  * ^short = "How often do you feel lonely?"
  * code = $LOINC#67233-9 "How often do you feel lonely"
  * value[x] only CodeableConcept
  * valueCodeableConcept from LonelinessFrequencyVS (required)

* derivedFrom 0..* MS
* derivedFrom only Reference(QuestionnaireResponse)
* derivedFrom ^short = "Reference to completed UCLA questionnaire response"

// =============================================================================
// Code Systems
// =============================================================================

CodeSystem: LonelinessComponentCS
Id: loneliness-component-cs
Title: "Loneliness Assessment Component Code System"
Description: "Components for UCLA Loneliness Scale items"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #companionship-lack "Lack of companionship" "How often do you feel that you lack companionship? (UCLA item)"
* #left-out "Feeling left out" "How often do you feel left out? (UCLA item)"
* #isolation "Feeling isolated" "How often do you feel isolated from others? (UCLA item)"
* #no-one-to-talk "No one to talk to" "How often do you feel that there is no one you can turn to? (UCLA item)"
* #not-close-to-anyone "Not close to anyone" "How often do you feel that you are no longer close to anyone? (UCLA item)"

CodeSystem: LonelinessFrequencyCS
Id: loneliness-frequency-cs
Title: "Loneliness Frequency Code System"
Description: "Frequency responses for loneliness assessment items (UCLA scale)"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #hardly-ever "Hardly ever" "Rarely or never (score: 1)"
* #some-of-time "Some of the time" "Occasionally (score: 2)"
* #often "Often" "Frequently (score: 3)"

CodeSystem: LonelinessAssessmentMethodCS
Id: loneliness-assessment-method-cs
Title: "Loneliness Assessment Method Code System"
Description: "Methods and instruments for loneliness assessment"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #ucla-20 "UCLA Loneliness Scale (20-item)" "Full UCLA Loneliness Scale Version 3 (Russell, 1996)"
* #ucla-3 "UCLA Loneliness Scale (3-item)" "Short form UCLA scale (Hughes et al., 2004)"
* #de-jong "De Jong Gierveld Scale" "De Jong Gierveld Loneliness Scale (11-item)"
* #de-jong-6 "De Jong Gierveld Scale (6-item)" "Short form De Jong Gierveld scale"
* #clinical-interview "Clinical Interview" "Clinical assessment of loneliness"

// =============================================================================
// Value Sets
// =============================================================================

ValueSet: LonelinessFrequencyVS
Id: loneliness-frequency-vs
Title: "Loneliness Frequency Value Set"
Description: "Frequency responses for loneliness assessment"
* ^experimental = false
* codes from system LonelinessFrequencyCS

ValueSet: LonelinessItemResponseVS
Id: loneliness-item-response-vs
Title: "Loneliness Item Response Value Set"
Description: "Response options for individual UCLA loneliness items"
* ^experimental = false
* codes from system LonelinessFrequencyCS

ValueSet: LonelinessAssessmentMethodVS
Id: loneliness-assessment-method-vs
Title: "Loneliness Assessment Method Value Set"
Description: "Validated instruments for loneliness assessment"
* ^experimental = false
* codes from system LonelinessAssessmentMethodCS
