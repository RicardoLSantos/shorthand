// =============================================================================
// Social Interaction Examples - F2.12.5 Expansion
// =============================================================================
// Added: 2026-01-12
// References: Plan PLAN_FHIR_IG_PILLARS_BALANCE_20260112.md
// =============================================================================

Alias: $LOINC = http://loinc.org
Alias: $ObsInt = http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation|3.0.0

// -----------------------------------------------------------------------------
// Example 1: Basic Social Interaction (Original)
// -----------------------------------------------------------------------------
Instance: SocialInteractionExample
InstanceOf: SocialInteractionProfile
Usage: #example
Description: "Social interaction observation example - family meal gathering"
Title: "Social Interaction Example - Family Meal"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#76506-5 "Social connection and isolation panel"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-01-03T14:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = LifestyleMedicineTemporaryCS#family

* component[duration].valueQuantity = 120 'min' "minutes"
* component[quality].valueCodeableConcept = LifestyleMedicineTemporaryCS#social-interaction-quality-meaningful
* component[medium].valueCodeableConcept = LifestyleMedicineTemporaryCS#inPerson
* component[participants].valueInteger = 4

* extension[context].valueCodeableConcept = LifestyleMedicineTemporaryCS#social-context-home
* extension[support].valueCodeableConcept = LifestyleMedicineTemporaryCS#strong
* extension[activity].valueCodeableConcept = LifestyleMedicineTemporaryCS#meal

// -----------------------------------------------------------------------------
// Example 2: Loneliness Assessment - High Loneliness (UCLA 3-item)
// Reference: Hughes ME et al. (2004). Research on Aging 26(6):655-672
// -----------------------------------------------------------------------------
Instance: LonelinessAssessmentHighExample
InstanceOf: LonelinessAssessmentProfile
Usage: #example
Description: "Loneliness assessment example - elderly patient with high loneliness score"
Title: "Loneliness Assessment - High Score"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#62933-7 "PhenX - social isolation protocol 181001"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T10:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = LifestyleMedicineTemporaryCS#often "Often"
* method = LifestyleMedicineTemporaryCS#ucla-3 "UCLA Loneliness Scale (3-item)"

* component[uclaTotal].valueInteger = 8
* component[companionshipLack].valueCodeableConcept = LifestyleMedicineTemporaryCS#often
* component[leftOutFeeling].valueCodeableConcept = LifestyleMedicineTemporaryCS#often
* component[isolationFeeling].valueCodeableConcept = LifestyleMedicineTemporaryCS#some-of-time

// -----------------------------------------------------------------------------
// Example 3: Loneliness Assessment - Low Loneliness
// -----------------------------------------------------------------------------
Instance: LonelinessAssessmentLowExample
InstanceOf: LonelinessAssessmentProfile
Usage: #example
Description: "Loneliness assessment example - well-connected individual"
Title: "Loneliness Assessment - Low Score"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#62933-7 "PhenX - social isolation protocol 181001"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T10:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = LifestyleMedicineTemporaryCS#hardly-ever "Hardly ever"
* method = LifestyleMedicineTemporaryCS#ucla-3 "UCLA Loneliness Scale (3-item)"

* component[uclaTotal].valueInteger = 3
* component[companionshipLack].valueCodeableConcept = LifestyleMedicineTemporaryCS#hardly-ever
* component[leftOutFeeling].valueCodeableConcept = LifestyleMedicineTemporaryCS#hardly-ever
* component[isolationFeeling].valueCodeableConcept = LifestyleMedicineTemporaryCS#hardly-ever

// -----------------------------------------------------------------------------
// Example 4: Social Support Assessment - MSPSS High Support
// Reference: Zimet GD et al. (1988). J Personality Assessment 52(1):30-41
// -----------------------------------------------------------------------------
Instance: SocialSupportHighExample
InstanceOf: SocialSupportAssessmentProfile
Usage: #example
Description: "Social support assessment - high MSPSS scores across all subscales"
Title: "Social Support Assessment - High MSPSS"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#91642-9 "Medical Outcomes Study Social Support Survey panel [MOS Social Support Survey]"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T11:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = LifestyleMedicineTemporaryCS#social-support-level-high "High Support"
* method = LifestyleMedicineTemporaryCS#mspss "MSPSS"

* component[totalScore].valueQuantity = 72 '{score}' "{score}"
* component[familySupport].valueQuantity = 24 '{score}' "{score}"
* component[friendSupport].valueQuantity = 22 '{score}' "{score}"
* component[significantOtherSupport].valueQuantity = 26 '{score}' "{score}"

* interpretation = $ObsInt#H "High"

// -----------------------------------------------------------------------------
// Example 5: Social Support Assessment - Low Support
// -----------------------------------------------------------------------------
Instance: SocialSupportLowExample
InstanceOf: SocialSupportAssessmentProfile
Usage: #example
Description: "Social support assessment - low MSPSS scores indicating social vulnerability"
Title: "Social Support Assessment - Low MSPSS"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#91642-9 "Medical Outcomes Study Social Support Survey panel [MOS Social Support Survey]"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T11:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = LifestyleMedicineTemporaryCS#social-support-level-low "Low Support"
* method = LifestyleMedicineTemporaryCS#mspss "MSPSS"

* component[totalScore].valueQuantity = 28 '{score}' "{score}"
* component[familySupport].valueQuantity = 8 '{score}' "{score}"
* component[friendSupport].valueQuantity = 12 '{score}' "{score}"
* component[significantOtherSupport].valueQuantity = 8 '{score}' "{score}"

* interpretation = $ObsInt#L "Low"

// -----------------------------------------------------------------------------
// Example 6: Family Structure - Living Alone Elderly
// Reference: Holt-Lunstad J et al. (2010). PLoS Medicine 7(7):e1000316
// -----------------------------------------------------------------------------
Instance: FamilyStructureLivingAloneExample
InstanceOf: FamilyStructureProfile
Usage: #example
Description: "Family structure - widowed elderly patient living alone"
Title: "Family Structure - Living Alone"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#63512-8 "How many people are living or staying at this address [#]"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T09:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = LifestyleMedicineTemporaryCS#alone "Living Alone"

* component[householdSize].valueInteger = 1
* component[maritalStatus].valueCodeableConcept = $SCT#33553000 "Widowed"
* component[dependentCount].valueInteger = 0
* component[caregiverRole].valueCodeableConcept = LifestyleMedicineTemporaryCS#caregiver-not-applicable
* component[familyRelationshipQuality].valueCodeableConcept = LifestyleMedicineTemporaryCS#generally-positive
* component[householdType].valueCodeableConcept = LifestyleMedicineTemporaryCS#single-person

* note.text = "Patient widowed 18 months ago. Adult children live in different city but maintain regular contact."

// -----------------------------------------------------------------------------
// Example 7: Family Structure - Multigenerational Household
// -----------------------------------------------------------------------------
Instance: FamilyStructureMultigenerationalExample
InstanceOf: FamilyStructureProfile
Usage: #example
Description: "Family structure - multigenerational household with caregiving"
Title: "Family Structure - Multigenerational"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#63512-8 "How many people are living or staying at this address [#]"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-10T09:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = LifestyleMedicineTemporaryCS#living-multigenerational "Multigenerational"

* component[householdSize].valueInteger = 5
* component[maritalStatus].valueCodeableConcept = $SCT#87915002 "Married"
* component[dependentCount].valueInteger = 2
* component[caregiverRole].valueCodeableConcept = LifestyleMedicineTemporaryCS#primary-caregiver
* component[familyRelationshipQuality].valueCodeableConcept = LifestyleMedicineTemporaryCS#very-supportive
* component[householdType].valueCodeableConcept = LifestyleMedicineTemporaryCS#household-multigenerational

// -----------------------------------------------------------------------------
// Example 8: Social Isolation Risk - High Risk
// Reference: Leigh-Hunt N et al. (2017). Public Health 152:157-171
// -----------------------------------------------------------------------------
Instance: SocialIsolationRiskHighExample
InstanceOf: SocialIsolationRiskProfile
Usage: #example
Description: "Social isolation risk assessment - high risk elderly patient"
Title: "Social Isolation Risk - High Risk"

* status = #final
* subject = Reference(Patient/PatientExample)
* occurrenceDateTime = "2026-01-10T14:00:00Z"
* method = LifestyleMedicineTemporaryCS#clinical-risk "Clinical Risk Assessment"

* prediction[0].outcome = LifestyleMedicineTemporaryCS#chronic-isolation "Chronic Social Isolation"
* prediction[0].probabilityDecimal = 0.75
* prediction[0].qualitativeRisk = LifestyleMedicineTemporaryCS#isolation-level-high "High Risk"
* prediction[0].whenPeriod.start = "2026-01-10"
* prediction[0].whenPeriod.end = "2026-07-10"

* prediction[1].outcome = LifestyleMedicineTemporaryCS#depression-onset "Depression Onset"
* prediction[1].probabilityDecimal = 0.45
* prediction[1].qualitativeRisk = LifestyleMedicineTemporaryCS#isolation-level-moderate "Moderate Risk"

* mitigation = "Referral to community befriending service, social prescribing, weekly welfare check"
* note.text = "Multiple risk factors: recent bereavement, living alone, mobility limitations, recent retirement"

// -----------------------------------------------------------------------------
// Example 9: Social Isolation Risk - Low Risk
// -----------------------------------------------------------------------------
Instance: SocialIsolationRiskLowExample
InstanceOf: SocialIsolationRiskProfile
Usage: #example
Description: "Social isolation risk assessment - low risk with strong protective factors"
Title: "Social Isolation Risk - Low Risk"

* status = #final
* subject = Reference(Patient/PatientExample)
* occurrenceDateTime = "2026-01-10T14:00:00Z"
* method = LifestyleMedicineTemporaryCS#lubben-6 "LSNS-6"

* prediction[0].outcome = LifestyleMedicineTemporaryCS#chronic-isolation "Chronic Social Isolation"
* prediction[0].probabilityDecimal = 0.10
* prediction[0].qualitativeRisk = LifestyleMedicineTemporaryCS#isolation-level-low "Low Risk"

* note.text = "Strong social network, active in community groups, regular family contact"

// -----------------------------------------------------------------------------
// Example 10: Video Call Social Interaction
// -----------------------------------------------------------------------------
Instance: SocialInteractionVideoExample
InstanceOf: SocialInteractionProfile
Usage: #example
Description: "Social interaction via video call with distant family"
Title: "Social Interaction - Video Call"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code = $LOINC#76506-5 "Social connection and isolation panel"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2026-01-08T19:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueCodeableConcept = LifestyleMedicineTemporaryCS#family

* component[duration].valueQuantity = 45 'min' "minutes"
* component[quality].valueCodeableConcept = LifestyleMedicineTemporaryCS#social-interaction-quality-meaningful
* component[medium].valueCodeableConcept = LifestyleMedicineTemporaryCS#video
* component[participants].valueInteger = 6

* extension[context].valueCodeableConcept = LifestyleMedicineTemporaryCS#social-context-home
* extension[support].valueCodeableConcept = LifestyleMedicineTemporaryCS#adequate
