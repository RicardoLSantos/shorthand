// =============================================================================
// F2.12.3: Family Structure Profile
// =============================================================================
// Based on social determinants of health frameworks:
// - Holt-Lunstad J et al. (2010). PLoS Medicine 7(7):e1000316. DOI:10.1371/journal.pmed.1000316
// - Umberson D & Montez JK (2010). J Health Soc Behav 51(Suppl):S54-S66
// - Berkman LF et al. (2000). Social Science & Medicine 51(6):843-857
//
// Family structure impacts health through:
// - Social support availability
// - Caregiving capacity
// - Economic resources
// - Health behavior modeling
// =============================================================================

Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct

Profile: FamilyStructureProfile
Parent: Observation
Id: family-structure
Title: "Family Structure Profile"
Description: """
Profile for documenting family structure and living situation as social determinants of health.

**Evidence Base**: Meta-analysis (Holt-Lunstad et al., 2010) demonstrates that individuals
with adequate social relationships have 50% greater survival compared to those with poor
or insufficient relationships (OR = 1.50, 95% CI: 1.42-1.59).

**Components Assessed**:
- Household composition (living alone, with partner, multigenerational)
- Marital/partnership status
- Number of dependents
- Presence of caregiver or care recipient role
- Quality of family relationships

**Clinical Utility**:
- Identifies patients at risk due to social isolation
- Informs discharge planning and care coordination
- Supports holistic lifestyle medicine interventions
- Enables population health management

**LOINC**: 63512-8 |How many people are living or staying at this address [#]|

References:
- Holt-Lunstad J et al. (2010). PLoS Medicine 7(7):e1000316
- Umberson D & Montez JK (2010). J Health Soc Behav 51(Suppl):S54-S66
- Berkman LF et al. (2000). Soc Sci Med 51(6):843-857
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2026-01-12"
* ^publisher = "FMUP HEADS2"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history
* code 1..1 MS
* code = $LOINC#63512-8 "How many people are living or staying at this address [#]"
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* value[x] only CodeableConcept
* valueCodeableConcept from LivingSituationVS (required)

* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    householdSize 0..1 MS and
    maritalStatus 0..1 MS and
    dependentCount 0..1 MS and
    caregiverRole 0..1 MS and
    familyRelationshipQuality 0..1 MS and
    householdType 0..1 MS

* component[householdSize]
  * ^short = "Number of people in household"
  * code = LifestyleMedicineTemporaryCS#household-size "Household size"
  * value[x] only integer
  * valueInteger ^short = "Total number of household members including patient"

* component[maritalStatus]
  * ^short = "Marital or partnership status"
  * code = $LOINC#45404-1 "Marital status"
  * value[x] only CodeableConcept
  * valueCodeableConcept from MaritalStatusVS (required)

* component[dependentCount]
  * ^short = "Number of dependents (children, elderly relatives)"
  * code = LifestyleMedicineTemporaryCS#dependent-count "Number of dependents"
  * value[x] only integer

* component[caregiverRole]
  * ^short = "Patient's role as caregiver or care recipient"
  * code = LifestyleMedicineTemporaryCS#caregiver-role "Caregiver role"
  * value[x] only CodeableConcept
  * valueCodeableConcept from CaregiverRoleVS (required)

* component[familyRelationshipQuality]
  * ^short = "Quality of family relationships"
  * code = LifestyleMedicineTemporaryCS#relationship-quality "Family relationship quality"
  * value[x] only CodeableConcept
  * valueCodeableConcept from RelationshipQualityVS (required)

* component[householdType]
  * ^short = "Type of household composition"
  * code = LifestyleMedicineTemporaryCS#household-type "Household type"
  * value[x] only CodeableConcept
  * valueCodeableConcept from HouseholdTypeVS (required)

* note 0..* MS
* note ^short = "Additional notes on family dynamics or circumstances"

// =============================================================================
// Value Sets
// =============================================================================

ValueSet: LivingSituationVS
Id: living-situation-vs
Title: "Living Situation Value Set"
Description: "Living situation categories using SNOMED CT where available. Cat B Tier 2 remediation (2026-02-27)."
* ^experimental = false
* ^version = "0.2.0"
// SNOMED CT - Verified via local SNOMED database (2026-02-27)
* $SCT#105529008 "Lives alone"
* $SCT#447051007 "Lives with spouse"
* $SCT#224133007 "Lives with family"
* $SCT#160734000 "Lives in nursing home"
* $SCT#160700001 "Homeless single person"
// Custom codes - SNOMED gap (no standard equivalent)
* LifestyleMedicineTemporaryCS#living-multigenerational "Multigenerational"
* LifestyleMedicineTemporaryCS#with-roommates "With Roommates"
* LifestyleMedicineTemporaryCS#assisted-living "Assisted Living"
* LifestyleMedicineTemporaryCS#temporary "Temporary Housing"

ValueSet: HouseholdTypeVS
Id: household-type-vs
Title: "Household Type Value Set"
Description: "Types of household composition"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS

ValueSet: MaritalStatusVS
Id: marital-status-vs
Title: "Marital Status Value Set"
Description: "Marital or partnership status"
* ^experimental = false
* $SCT#87915002 "Married"
* $SCT#125681006 "Single person"
* $SCT#33553000 "Widowed"
* $SCT#20295000 "Divorced"
* $SCT#13184001 "Separated"
// Note: 442751008 "Civil partnership" is UK SNOMED extension, not in International Edition
// For UK implementations, add: * $SCT#442751008 "Civil partnership"
* $SCT#14012001 "Cohabiting"

ValueSet: CaregiverRoleVS
Id: caregiver-role-vs
Title: "Caregiver Role Value Set"
Description: "Caregiving role categories"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS

ValueSet: RelationshipQualityVS
Id: relationship-quality-vs
Title: "Relationship Quality Value Set"
Description: "Quality of family relationships"
* ^experimental = false
* codes from system LifestyleMedicineTemporaryCS
