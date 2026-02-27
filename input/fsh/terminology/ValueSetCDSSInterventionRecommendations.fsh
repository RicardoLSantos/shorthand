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
* http://snomed.info/sct#182982001 "Exercise on prescription"

// Personalised exercise programme
// Replaces: LifestyleMedicineTemporaryCS#exercise-physiology
* http://snomed.info/sct#229065009 "Exercise therapy"

// ============================================================================
// NUTRITIONAL INTERVENTIONS
// ============================================================================

// Adverse nutritional pattern detected → modify diet
// Replaces: LifestyleMedicineTemporaryCS#dietary-modification
* http://snomed.info/sct#1098021000000108 "Diet modification"

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
* http://snomed.info/sct#285371000000106 "Smoking cessation therapy"

// Elevated AUDIT-C score → alcohol reduction
// Replaces: LifestyleMedicineTemporaryCS#alcohol-reduction
* http://snomed.info/sct#707166002 "Alcohol reduction program"

// ============================================================================
// MEDICATION MANAGEMENT
// ============================================================================

// Drug interactions detected → medication review
// Replaces: LifestyleMedicineTemporaryCS#medication-review
* http://snomed.info/sct#1099461000000101 "Medication review"

// Complex therapeutic management
// Replaces: LifestyleMedicineTemporaryCS#medication-management
* http://snomed.info/sct#409022004 "Dispensing medication management"

// Pharmacological optimisation
// Replaces: LifestyleMedicineTemporaryCS#medication-optimization
* http://snomed.info/sct#789741000000106 "Medication optimisation"

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
* http://snomed.info/sct#7396004 "Diagnostic imaging"

// ============================================================================
// REFERRALS
// ============================================================================

// Specialist referrals (using SNOMED procedure codes)
// Replaces: LifestyleMedicineTemporaryCS#cardiology-referral
* http://snomed.info/sct#183519002 "Referral to cardiology service"

// Replaces: LifestyleMedicineTemporaryCS#dietitian-referral
* http://snomed.info/sct#103699006 "Referral to dietitian"

// Replaces: LifestyleMedicineTemporaryCS#endocrinology-referral
* http://snomed.info/sct#183523005 "Referral to endocrine service"

// Replaces: LifestyleMedicineTemporaryCS#physiotherapy-referral
* http://snomed.info/sct#183524004 "Referral to physiotherapy service"

// Replaces: LifestyleMedicineTemporaryCS#psychology-referral
* http://snomed.info/sct#183583007 "Referral to psychologist"

// Replaces: LifestyleMedicineTemporaryCS#specialist-referral (generic)
* http://snomed.info/sct#183561008 "Referral to specialist"

// ============================================================================
// REMOTE MONITORING
// ============================================================================

// Replaces: LifestyleMedicineTemporaryCS#remote-monitoring
* http://snomed.info/sct#719858009 "Telehealth monitoring"

// Replaces: LifestyleMedicineTemporaryCS#wearable-monitoring
* http://snomed.info/sct#722172003 "Ambulatory monitoring"

// Replaces: LifestyleMedicineTemporaryCS#device-prescription
* http://snomed.info/sct#840534001 "Recommendation to use home monitoring device"
