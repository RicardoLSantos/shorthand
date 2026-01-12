// =============================================================================
// F2.12.4: Social Isolation Risk Assessment Profile
// =============================================================================
// Based on epidemiological evidence:
// - Leigh-Hunt N et al. (2017). Public Health 152:157-171. DOI:10.1016/j.puhe.2017.07.035
// - Valtorta NK et al. (2016). Heart 102(13):1009-1016. DOI:10.1136/heartjnl-2015-308790
// - Cacioppo JT et al. (2014). Annual Review of Psychology 66:733-767
//
// Risk factors for social isolation include:
// - Living alone, geographic isolation
// - Recent bereavement, retirement, health decline
// - Sensory impairment, mobility limitations
// - Mental health conditions, substance use
// =============================================================================

Alias: $LOINC = http://loinc.org
Alias: $SCT = http://snomed.info/sct

Profile: SocialIsolationRiskProfile
Parent: RiskAssessment
Id: social-isolation-risk
Title: "Social Isolation Risk Assessment Profile"
Description: """
Risk assessment for social isolation and loneliness.

**Evidence Base**: Umbrella review (Leigh-Hunt et al., 2017) demonstrates social isolation
and loneliness associated with increased risk of:
- Cardiovascular disease: RR = 1.29 (95% CI: 1.04-1.59)
- Stroke: RR = 1.32 (95% CI: 1.04-1.68)
- All-cause mortality: OR = 1.26 (95% CI: 1.04-1.53)
- Depression: significantly elevated risk
- Cognitive decline and dementia: elevated risk

**Risk Factors Assessed**:
- Living situation (alone vs. with others)
- Social network size and quality
- Recent life transitions (bereavement, retirement, relocation)
- Functional limitations (mobility, sensory, cognitive)
- Mental health status

**Intervention Triggers**:
- High risk: Immediate referral to social services
- Moderate risk: Enhanced monitoring, befriending services
- Low risk: Community engagement promotion

References:
- Leigh-Hunt N et al. (2017). Public Health 152:157-171
- Valtorta NK et al. (2016). Heart 102(13):1009-1016
- Holt-Lunstad J et al. (2015). Perspect Psychol Sci 10(2):227-237
"""

* ^version = "0.1.0"
* ^status = #active
* ^date = "2026-01-12"
* ^publisher = "FMUP HEADS2"

* status MS
* subject 1..1 MS
* subject only Reference(Patient)
* encounter 0..1 MS
* occurrenceDateTime 1..1 MS
* condition 0..1 MS
* condition only Reference(Condition)
* condition ^short = "Existing condition increasing isolation risk (e.g., depression, dementia)"

* performer 0..1 MS
* performer only Reference(Practitioner or PractitionerRole or Device)

* method 0..1 MS
* method from IsolationRiskMethodVS (extensible)
* method ^short = "Assessment method or screening tool used"

* prediction 1..* MS
* prediction ^short = "Risk predictions for social isolation outcomes"

* prediction.outcome 1..1 MS
* prediction.outcome from IsolationRiskOutcomeVS (extensible)
* prediction.outcome ^short = "Predicted outcome (isolation, loneliness, health decline)"

* prediction.probability[x] only decimal
* prediction.probabilityDecimal ^short = "Probability 0.0-1.0"

* prediction.qualitativeRisk 0..1 MS
* prediction.qualitativeRisk from IsolationRiskLevelVS (required)
* prediction.qualitativeRisk ^short = "Low/Moderate/High/Critical risk level"

* prediction.relativeRisk 0..1 MS
* prediction.relativeRisk ^short = "Relative risk compared to age-matched population"

* prediction.whenPeriod 0..1 MS
* prediction.whenPeriod ^short = "Time frame for risk prediction (e.g., 6 months, 1 year)"

* basis 0..* MS
* basis only Reference(Observation or QuestionnaireResponse or Condition)
* basis ^short = "Evidence supporting risk assessment (loneliness scores, living situation, etc.)"

* mitigation 0..1 MS
* mitigation ^short = "Recommended interventions to reduce isolation risk"

* note 0..* MS
* note ^short = "Additional clinical notes on social context"

// =============================================================================
// Code Systems
// =============================================================================

CodeSystem: IsolationRiskLevelCS
Id: isolation-risk-level-cs
Title: "Social Isolation Risk Level Code System"
Description: "Risk levels for social isolation assessment"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #negligible "Negligible Risk" "Minimal risk factors; strong social network"
* #low "Low Risk" "Few risk factors; adequate social connections"
* #moderate "Moderate Risk" "Multiple risk factors; some protective factors present"
* #high "High Risk" "Significant risk factors; limited protective factors"
* #critical "Critical Risk" "Severe risk; immediate intervention required"

CodeSystem: IsolationRiskOutcomeCS
Id: isolation-risk-outcome-cs
Title: "Social Isolation Risk Outcome Code System"
Description: "Potential outcomes related to social isolation"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #chronic-isolation "Chronic Social Isolation" "Persistent lack of social contact"
* #severe-loneliness "Severe Loneliness" "Persistent subjective loneliness despite social contact"
* #depression-onset "Depression Onset" "Development of major depressive disorder"
* #cognitive-decline "Cognitive Decline" "Accelerated cognitive deterioration"
* #cardiovascular-event "Cardiovascular Event" "MI, stroke, or other CV event"
* #mortality "All-cause Mortality" "Death from any cause"
* #functional-decline "Functional Decline" "Loss of independent living capacity"
* #institutionalization "Institutionalization" "Admission to care facility"

CodeSystem: IsolationRiskMethodCS
Id: isolation-risk-method-cs
Title: "Social Isolation Risk Method Code System"
Description: "Methods for assessing social isolation risk"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #lubben-6 "LSNS-6" "Lubben Social Network Scale 6-item (Lubben et al., 2006)"
* #lubben-18 "LSNS-18" "Lubben Social Network Scale 18-item"
* #berkman-sni "Berkman-SNI" "Berkman-Syme Social Network Index"
* #clinical-risk "Clinical Risk Assessment" "Comprehensive clinical assessment of social risk factors"
* #algorithmic "Algorithmic Risk Score" "Computed risk score from multiple data sources"
* #community-screening "Community Screening" "Population-level screening tool"

CodeSystem: IsolationRiskFactorCS
Id: isolation-risk-factor-cs
Title: "Social Isolation Risk Factor Code System"
Description: "Risk factors contributing to social isolation"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #living-alone "Living Alone" "Single-person household"
* #recent-bereavement "Recent Bereavement" "Death of spouse/partner within 2 years"
* #geographic-isolation "Geographic Isolation" "Rural or remote location, limited transport"
* #mobility-impairment "Mobility Impairment" "Physical limitations affecting social participation"
* #sensory-impairment "Sensory Impairment" "Hearing or vision loss affecting communication"
* #cognitive-impairment "Cognitive Impairment" "Dementia or significant cognitive decline"
* #recent-retirement "Recent Retirement" "Retirement within past year"
* #recent-relocation "Recent Relocation" "Moved residence within past year"
* #chronic-illness "Chronic Illness" "Condition limiting social activities"
* #mental-health "Mental Health Condition" "Depression, anxiety, or other mental disorder"
* #language-barrier "Language Barrier" "Communication difficulties due to language"
* #financial-constraint "Financial Constraint" "Limited resources for social activities"
* #caregiving-burden "Caregiving Burden" "Primary caregiver responsibilities limiting social time"

// =============================================================================
// Value Sets
// =============================================================================

ValueSet: IsolationRiskLevelVS
Id: isolation-risk-level-vs
Title: "Social Isolation Risk Level Value Set"
Description: "Risk levels for social isolation"
* ^experimental = false
* codes from system IsolationRiskLevelCS

ValueSet: IsolationRiskOutcomeVS
Id: isolation-risk-outcome-vs
Title: "Social Isolation Risk Outcome Value Set"
Description: "Potential outcomes from social isolation"
* ^experimental = false
* codes from system IsolationRiskOutcomeCS

ValueSet: IsolationRiskMethodVS
Id: isolation-risk-method-vs
Title: "Social Isolation Risk Method Value Set"
Description: "Methods for assessing social isolation risk"
* ^experimental = false
* codes from system IsolationRiskMethodCS

ValueSet: IsolationRiskFactorVS
Id: isolation-risk-factor-vs
Title: "Social Isolation Risk Factor Value Set"
Description: "Risk factors for social isolation"
* ^experimental = false
* codes from system IsolationRiskFactorCS
