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

**LOINC**: 63512-8 |Are you currently living with someone|

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
* code = $LOINC#63512-8 "Are you currently living with someone"
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
  * code = FamilyStructureCS#household-size "Household size"
  * value[x] only integer
  * valueInteger ^short = "Total number of household members including patient"

* component[maritalStatus]
  * ^short = "Marital or partnership status"
  * code = $LOINC#45404-1 "Marital status"
  * value[x] only CodeableConcept
  * valueCodeableConcept from MaritalStatusVS (required)

* component[dependentCount]
  * ^short = "Number of dependents (children, elderly relatives)"
  * code = FamilyStructureCS#dependent-count "Number of dependents"
  * value[x] only integer

* component[caregiverRole]
  * ^short = "Patient's role as caregiver or care recipient"
  * code = FamilyStructureCS#caregiver-role "Caregiver role"
  * value[x] only CodeableConcept
  * valueCodeableConcept from CaregiverRoleVS (required)

* component[familyRelationshipQuality]
  * ^short = "Quality of family relationships"
  * code = FamilyStructureCS#relationship-quality "Family relationship quality"
  * value[x] only CodeableConcept
  * valueCodeableConcept from RelationshipQualityVS (required)

* component[householdType]
  * ^short = "Type of household composition"
  * code = FamilyStructureCS#household-type "Household type"
  * value[x] only CodeableConcept
  * valueCodeableConcept from HouseholdTypeVS (required)

* note 0..* MS
* note ^short = "Additional notes on family dynamics or circumstances"

// =============================================================================
// Code Systems
// =============================================================================

CodeSystem: FamilyStructureCS
Id: family-structure-cs
Title: "Family Structure Code System"
Description: "Codes for family structure assessment components"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #household-size "Household size" "Total number of people living in household"
* #dependent-count "Number of dependents" "Number of dependent children or adults"
* #caregiver-role "Caregiver role" "Patient's caregiving responsibilities"
* #relationship-quality "Family relationship quality" "Quality of family relationships"
* #household-type "Household type" "Composition type of household"

CodeSystem: LivingSituationCS
Id: living-situation-cs
Title: "Living Situation Code System"
Description: "Living situation categories"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #alone "Living Alone" "Single-person household"
* #with-spouse "With Spouse/Partner" "Living with spouse or domestic partner"
* #with-family "With Family" "Living with family members (parents, children, siblings)"
* #multigenerational "Multigenerational" "Three or more generations in household"
* #with-roommates "With Roommates" "Non-family cohabitants"
* #assisted-living "Assisted Living" "Assisted living facility"
* #nursing-home "Nursing Home" "Skilled nursing facility"
* #homeless "Homeless" "No fixed address"
* #temporary "Temporary Housing" "Transitional or temporary living situation"

CodeSystem: HouseholdTypeCS
Id: household-type-cs
Title: "Household Type Code System"
Description: "Types of household composition"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #single-person "Single Person" "One adult, no children"
* #couple-no-children "Couple Without Children" "Two adults, no children"
* #nuclear-family "Nuclear Family" "Two parents with children"
* #single-parent "Single Parent" "One parent with children"
* #extended-family "Extended Family" "Nuclear family plus other relatives"
* #blended-family "Blended Family" "Step-parents or step-children"
* #multigenerational "Multigenerational" "Three or more generations"
* #shared-housing "Shared Housing" "Unrelated adults sharing residence"
* #group-home "Group Home" "Supervised group living facility"

CodeSystem: CaregiverRoleCS
Id: caregiver-role-cs
Title: "Caregiver Role Code System"
Description: "Caregiving role categories"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #not-applicable "Not Applicable" "No caregiving role"
* #primary-caregiver "Primary Caregiver" "Main caregiver for dependent"
* #secondary-caregiver "Secondary Caregiver" "Shares caregiving responsibilities"
* #care-recipient "Care Recipient" "Receives care from others"
* #mutual-care "Mutual Care" "Both gives and receives care"
* #paid-caregiver "Paid Caregiver" "Professional caregiver"

CodeSystem: RelationshipQualityCS
Id: relationship-quality-cs
Title: "Relationship Quality Code System"
Description: "Quality of family relationships"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #very-supportive "Very Supportive" "Strong, supportive family relationships"
* #generally-positive "Generally Positive" "Mostly positive relationships with occasional conflict"
* #mixed "Mixed" "Some positive and some strained relationships"
* #strained "Strained" "Predominantly difficult relationships"
* #estranged "Estranged" "No contact with family"
* #not-applicable "Not Applicable" "No family relationships to assess"

// =============================================================================
// Value Sets
// =============================================================================

ValueSet: LivingSituationVS
Id: living-situation-vs
Title: "Living Situation Value Set"
Description: "Living situation categories"
* ^experimental = false
* codes from system LivingSituationCS

ValueSet: HouseholdTypeVS
Id: household-type-vs
Title: "Household Type Value Set"
Description: "Types of household composition"
* ^experimental = false
* codes from system HouseholdTypeCS

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
* $SCT#442751008 "Civil partnership"
* $SCT#14012001 "Cohabiting"

ValueSet: CaregiverRoleVS
Id: caregiver-role-vs
Title: "Caregiver Role Value Set"
Description: "Caregiving role categories"
* ^experimental = false
* codes from system CaregiverRoleCS

ValueSet: RelationshipQualityVS
Id: relationship-quality-vs
Title: "Relationship Quality Value Set"
Description: "Quality of family relationships"
* ^experimental = false
* codes from system RelationshipQualityCS
