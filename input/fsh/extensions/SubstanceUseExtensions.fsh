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
Description: "Stages of change / motivation levels based on Transtheoretical Model"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system SubstanceUseMotivationCS

CodeSystem: SubstanceUseMotivationCS
Id: substance-use-motivation-cs
Title: "Substance Use Motivation CodeSystem"
Description: "Motivation stages based on Transtheoretical Model (Prochaska)"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #precontemplation "Precontemplation" "Not considering change in the next 6 months"
* #contemplation "Contemplation" "Considering change in the next 6 months"
* #preparation "Preparation" "Planning to change in the next 30 days"
* #action "Action" "Actively making changes (0-6 months)"
* #maintenance "Maintenance" "Sustaining change (>6 months)"
* #relapse "Relapse" "Has returned to previous behavior after attempt to change"

// =============================================================================
// TRIGGER EXTENSION
// =============================================================================

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
* include codes from system SubstanceUseTriggerCS

CodeSystem: SubstanceUseTriggerCS
Id: substance-use-trigger-cs
Title: "Substance Use Trigger CodeSystem"
Description: "Common triggers for substance use behavior"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #stress "Stress" "Work or life stress"
* #social "Social situations" "Social gatherings or peer pressure"
* #emotional "Emotional distress" "Anxiety, depression, or emotional pain"
* #boredom "Boredom" "Lack of stimulation or engagement"
* #habit "Habit/routine" "Habitual or routine behavior"
* #celebration "Celebration" "Celebratory occasions"
* #cravings "Physical cravings" "Physical dependency cravings"
* #meals "With meals" "Associated with eating"
* #morning "Morning routine" "Part of morning routine"
* #sleep "Sleep issues" "Difficulty sleeping"
* #pain "Pain" "Physical pain or discomfort"

// =============================================================================
// CESSATION SUPPORT EXTENSION
// =============================================================================

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
* include codes from system CessationSupportMethodCS

CodeSystem: CessationSupportMethodCS
Id: cessation-support-method-cs
Title: "Cessation Support Method CodeSystem"
Description: "Methods used to support cessation of substance use"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #nrt-patch "NRT - Patch" "Nicotine replacement therapy - transdermal patch"
* #nrt-gum "NRT - Gum" "Nicotine replacement therapy - gum"
* #nrt-lozenge "NRT - Lozenge" "Nicotine replacement therapy - lozenge"
* #nrt-inhaler "NRT - Inhaler" "Nicotine replacement therapy - inhaler"
* #varenicline "Varenicline" "Varenicline (Chantix/Champix)"
* #bupropion "Bupropion" "Bupropion (Zyban/Wellbutrin)"
* #counseling "Counseling" "Individual or group counseling"
* #quitline "Quitline" "Telephone quitline support"
* #app "Mobile app" "Cessation support mobile application"
* #support-group "Support group" "In-person or online support group"
* #acupuncture "Acupuncture" "Acupuncture therapy"
* #hypnotherapy "Hypnotherapy" "Hypnotherapy for cessation"
* #cold-turkey "Cold turkey" "Abrupt cessation without aids"
* #gradual-reduction "Gradual reduction" "Gradual reduction of use"

ValueSet: CessationSupportStatusVS
Id: cessation-support-status-vs
Title: "Cessation Support Status ValueSet"
Description: "Status of cessation support engagement"
* ^experimental = false
* ^version = "0.1.0"
* include codes from system CessationSupportStatusCS

CodeSystem: CessationSupportStatusCS
Id: cessation-support-status-cs
Title: "Cessation Support Status CodeSystem"
Description: "Status of cessation support"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #considering "Considering" "Considering using this method"
* #scheduled "Scheduled" "Scheduled to start"
* #active "Active" "Currently using this method"
* #completed "Completed" "Completed this method"
* #discontinued "Discontinued" "Stopped using this method"
* #not-interested "Not interested" "Not interested in this method"

// =============================================================================
// DRINKING CONTEXT EXTENSION
// =============================================================================

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
* include codes from system DrinkingContextCS

CodeSystem: DrinkingContextCS
Id: drinking-context-cs
Title: "Drinking Context CodeSystem"
Description: "Settings and contexts for alcohol consumption"
* ^experimental = false
* ^caseSensitive = true
* ^version = "0.1.0"
* #home-alone "Home alone" "Drinking alone at home"
* #home-social "Home with others" "Drinking at home with family or friends"
* #restaurant "Restaurant/dining" "Drinking with meals at restaurants"
* #bar-club "Bar or club" "Drinking at bars, pubs, or nightclubs"
* #party "Party/celebration" "Drinking at parties or celebrations"
* #work-event "Work event" "Drinking at work-related events"
* #outdoor "Outdoor activity" "Drinking during outdoor activities"
* #sporting-event "Sporting event" "Drinking at sporting events"
