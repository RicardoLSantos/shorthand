// =============================================================================
// CDSS INTERVENTION RECOMMENDATIONS VALUE SET
// =============================================================================
// Date: 2026-02-27
// Purpose: Standard SNOMED CT codes for clinical interventions that the CDSS
//          agent can recommend based on wearable data patterns.
// Context: Replaces orphan custom codes from LifestyleMedicineTemporaryCS
//          (e.g., #exercise-prescription, #smoking-cessation) with SNOMED codes.
// Reference: REMEDIATION_PLAN_CUSTOM_CODES_20260227.md Cat D
// Verified: Database-First Protocol (SNOMED CT local 2026-02-27)
// =============================================================================

ValueSet: ValueSetCDSSInterventionRecommendations
Id: cdss-intervention-recommendations-vs
Title: "CDSS Clinical Intervention Recommendations"
Description: """
SNOMED CT codes for lifestyle medicine interventions that the Clinical Decision
Support agent may recommend based on patterns observed in wearable device data.

Organised by intervention category:
- Exercise interventions (sedentarism detected)
- Nutritional interventions (adverse dietary patterns)
- Sleep interventions (chronic low sleep scores)
- Stress management (low HRV + high stress scores)
- Substance use interventions (active use detected)
- Medication management (interactions or optimisation needed)
- Referrals (specialist consultation required)

These codes were previously custom in LifestyleMedicineTemporaryCS.
Replaced by standard SNOMED codes per comparative audit (PA IG benchmark).
"""
* ^status = #active
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-02-27"

// ============================================================================
// EXERCISE INTERVENTIONS
// ============================================================================

// Sedentarism detected → prescribe exercise
// Replaces: LifestyleMedicineTemporaryCS#exercise-prescription
// SNOMED 182982001 deprecated -> 310882002 active (Database-First, 2026-05-23)
* http://snomed.info/sct#310882002 "Exercise on prescription"

// Personalised exercise programme
// Replaces: LifestyleMedicineTemporaryCS#exercise-physiology
* http://snomed.info/sct#229065009 "Exercise therapy"

// ============================================================================
// NUTRITIONAL INTERVENTIONS
// ============================================================================

// Adverse nutritional pattern detected → modify diet
// Replaces: LifestyleMedicineTemporaryCS#dietary-modification
* http://snomed.info/sct#386373004 "Nutrition therapy"

// Nutritional deficiencies detected → nutrition counselling
// Replaces: LifestyleMedicineTemporaryCS#nutrition-consult
* http://snomed.info/sct#441041000124100 "Nutrition counseling"

// ============================================================================
// SLEEP INTERVENTIONS
// ============================================================================

// Chronic low sleep score → sleep hygiene promotion
// Replaces: LifestyleMedicineTemporaryCS#sleep-hygiene
* http://snomed.info/sct#1172583004 "Promotion of sleep hygiene"

// ============================================================================
// STRESS MANAGEMENT
// ============================================================================

// Low HRV + high stress score → stress management programme
// Replaces: LifestyleMedicineTemporaryCS#stress-management
* http://snomed.info/sct#226060000 "Stress management"

// ============================================================================
// SUBSTANCE USE INTERVENTIONS
// ============================================================================

// Active tobacco use → cessation therapy
// Replaces: LifestyleMedicineTemporaryCS#smoking-cessation
* http://snomed.info/sct#710081004 "Smoking cessation therapy"

// Elevated AUDIT-C score → alcohol reduction
// Replaces: LifestyleMedicineTemporaryCS#alcohol-reduction
* http://snomed.info/sct#707166002 "Alcohol reduction program"

// ============================================================================
// MEDICATION MANAGEMENT
// ============================================================================

// Drug interactions detected → medication review
// Replaces: LifestyleMedicineTemporaryCS#medication-review
* http://snomed.info/sct#428911000124108 "Comprehensive medication therapy review"

// Complex therapeutic management
// Replaces: LifestyleMedicineTemporaryCS#medication-management
* http://snomed.info/sct#409022004 "Dispensing medication management"

// Pharmacological optimisation
// Replaces: LifestyleMedicineTemporaryCS#medication-optimization
* http://snomed.info/sct#395067002 "Optimization of drug dosage"

// ============================================================================
// SELF-MANAGEMENT SUPPORT
// ============================================================================

// Chronic disease self-management support
// Replaces: LifestyleMedicineTemporaryCS#self-management
* http://snomed.info/sct#733810001 "Support for self-management"

// ============================================================================
// GENERIC CATEGORIES
// ============================================================================

// Generic laboratory procedure category
// Replaces: LifestyleMedicineTemporaryCS#laboratory
* http://snomed.info/sct#108252007 "Laboratory procedure"

// Generic diagnostic imaging category
// Replaces: LifestyleMedicineTemporaryCS#imaging
// SNOMED 7396004 deprecated -> 363679005 active (Database-First, 2026-05-23)
* http://snomed.info/sct#363679005 "Imaging"

// ============================================================================
// REFERRALS
// ============================================================================

// Specialist referrals (using SNOMED procedure codes)
// Replaces: LifestyleMedicineTemporaryCS#cardiology-referral
* http://snomed.info/sct#183519002 "Referral to cardiology service"

// Replaces: LifestyleMedicineTemporaryCS#dietitian-referral
* http://snomed.info/sct#103699006 "Referral to dietitian"

// Replaces: LifestyleMedicineTemporaryCS#endocrinology-referral
* http://snomed.info/sct#306118006 "Referral to endocrinology service" // T2 S33 VRF-TERM-018: 183523005 was "Referral to gastroenterology service"

// Replaces: LifestyleMedicineTemporaryCS#physiotherapy-referral
* http://snomed.info/sct#306170007 "Referral to physiotherapy service" // T2 S33 VRF-TERM-018: 183524004 was "Psychiatric referral"

// Replaces: LifestyleMedicineTemporaryCS#psychology-referral
* http://snomed.info/sct#183583007 "Refer to mental health worker" // T2 S33 VRF-TERM-018: display corrected (183583007 = mental health worker, not "psychologist"; for psychology-specific consider IAPT 1363001000000106)

// Replaces: LifestyleMedicineTemporaryCS#specialist-referral (generic)
* http://snomed.info/sct#103696004 "Patient referral to specialist" // T2 S33 VRF-TERM-018: 183561008 was "Referral to general practitioner"

// ============================================================================
// REMOTE MONITORING
// ============================================================================

// Replaces: LifestyleMedicineTemporaryCS#remote-monitoring
* http://snomed.info/sct#719858009 "Telehealth monitoring"

// Replaces: LifestyleMedicineTemporaryCS#wearable-monitoring
* http://snomed.info/sct#722172003 "Ambulatory monitoring" // ⚠️ T2 S33 VRF-TERM-018: 722172003 actually = "Military health institution" — T1/clinical to resolve (cf. 719858009 Telehealth monitoring above; consider a wearable/remote-monitoring code or remove)

// Replaces: LifestyleMedicineTemporaryCS#device-prescription
* http://snomed.info/sct#840534001 "Recommendation to use home monitoring device" // ⚠️ T2 S33 VRF-TERM-018: 840534001 actually = "2019-nCoV antigen immunisation" — T1/clinical to resolve (alternative monitoring-recommendation code or remove)
