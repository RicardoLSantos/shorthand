// Extensions for SubstanceUse Profiles
// Created: 2025-11-25
// Complementing SubstanceUseProfile.fsh

// =============================================================================
// MOTIVATION EXTENSION
// =============================================================================

Extension: SubstanceUseMotivation
Id: substance-use-motivation
Title: "Substance Use Motivation"
Description: "Patient's motivation level for changing substance use behavior (readiness to change)"
Context: Observation

* value[x] only CodeableConcept
* valueCodeableConcept from SubstanceUseMotivationVS (required)

ValueSet: SubstanceUseMotivationVS
Id: substance-use-motivation-vs
Title: "Substance Use Motivation ValueSet"
Description: "Stages of change (Prochaska Transtheoretical Model) using standard SNOMED CT qualifier values. Replaces custom codes per Cat B remediation (2026-02-27)."
* ^experimental = false
* ^version = "0.2.0"
* http://snomed.info/sct#134414000 "Precontemplation stage"
* http://snomed.info/sct#134413006 "Contemplation stage"
* http://snomed.info/sct#134412001 "Preparation stage"
* http://snomed.info/sct#134411008 "Action stage"
* http://snomed.info/sct#134410009 "Maintenance stage"
* http://snomed.info/sct#134409004 "Relapse stage"
Extension: SubstanceUseTrigger
Id: substance-use-trigger
Title: "Substance Use Trigger"
Description: "Identified triggers that prompt substance use behavior"
Context: Observation

* value[x] only CodeableConcept
* valueCodeableConcept from SubstanceUseTriggerVS (extensible)

ValueSet: SubstanceUseTriggerVS
Id: substance-use-trigger-vs
Title: "Substance Use Trigger ValueSet"
Description: "Common triggers for substance use"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system LifestyleMedicineTemporaryCS
Extension: CessationSupport
Id: cessation-support
Title: "Cessation Support"
Description: "Support methods being used or considered for substance cessation"
Context: Observation

* extension contains
    method 1..1 MS and
    status 0..1 MS and
    startDate 0..1 MS

* extension[method].value[x] only CodeableConcept
* extension[method].valueCodeableConcept from CessationSupportMethodVS (extensible)

* extension[status].value[x] only CodeableConcept
* extension[status].valueCodeableConcept from CessationSupportStatusVS (required)

* extension[startDate].value[x] only date

ValueSet: CessationSupportMethodVS
Id: cessation-support-method-vs
Title: "Cessation Support Method ValueSet"
Description: "Methods of support for substance use cessation"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system LifestyleMedicineTemporaryCS
ValueSet: CessationSupportStatusVS
Id: cessation-support-status-vs
Title: "Cessation Support Status ValueSet"
Description: "Status of cessation support engagement. Cat B Tier 2 remediation (2026-02-27): replaced bulk include with enumerated clinical cessation status codes."
* ^experimental = false
* ^version = "0.2.0"
// All codes are cessation-specific clinical states (not generic task-status)
* LifestyleMedicineTemporaryCS#considering "Considering"
* LifestyleMedicineTemporaryCS#scheduled "Scheduled"
* LifestyleMedicineTemporaryCS#cessation-status-active "Active"
* LifestyleMedicineTemporaryCS#cessation-status-completed "Completed"
* LifestyleMedicineTemporaryCS#discontinued "Discontinued"
* LifestyleMedicineTemporaryCS#not-interested "Not interested"
Extension: DrinkingContext
Id: drinking-context
Title: "Drinking Context"
Description: "Context or setting in which alcohol consumption typically occurs"
Context: Observation

* value[x] only CodeableConcept
* valueCodeableConcept from DrinkingContextVS (extensible)

ValueSet: DrinkingContextVS
Id: drinking-context-vs
Title: "Drinking Context ValueSet"
Description: "Contexts where alcohol consumption typically occurs"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system LifestyleMedicineTemporaryCS
