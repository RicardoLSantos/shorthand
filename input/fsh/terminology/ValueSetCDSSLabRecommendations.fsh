// =============================================================================
// CDSS LAB RECOMMENDATIONS VALUE SET
// =============================================================================
// Date: 2026-02-27
// Purpose: Standard LOINC/SNOMED codes for laboratory tests that the CDSS agent
//          can recommend based on wearable data patterns.
// Context: Replaces orphan custom codes from LifestyleMedicineTemporaryCS
//          (e.g., #hba1c, #crp, #tsh) with authoritative LOINC/SNOMED codes.
// Reference: REMEDIATION_PLAN_CUSTOM_CODES_20260227.md Cat C
// Verified: Database-First Protocol (Athena LOINC 2026-02-27)
// =============================================================================

ValueSet: ValueSetCDSSLabRecommendations
Id: cdss-lab-recommendations-vs
Title: "CDSS Laboratory Test Recommendations"
Description: """
LOINC and SNOMED CT codes for laboratory tests that the Clinical Decision Support
agent may recommend based on patterns observed in wearable device data.

Each code represents a test that can be triggered by specific wearable patterns:
- CGM instability → HbA1c
- Chronic low HRV → CRP (inflammation marker)
- HR variability + fatigue → TSH
- Low CRF + slow recovery → Iron studies
- Wearable arrhythmia detection → 12-lead ECG
- Abnormal cardiac pattern → Echocardiography
- Low VO2max + CV risk → Exercise stress test
- Abnormal exercise SpO2 → Pulmonary function
- Elevated CV risk → Lipid panel
- Reproductive nutrition assessment → Folate

These codes were previously custom (#hba1c, #crp, etc.) in LifestyleMedicineTemporaryCS.
Replaced by standard codes per comparative audit (PA IG benchmark: 8.6% custom).
"""
* ^status = #active
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-02-27"

// ============================================================================
// LOINC LAB PANELS AND TESTS
// ============================================================================

// CGM instability → suggest HbA1c
// Replaces: LifestyleMedicineTemporaryCS#hba1c
* http://loinc.org#4548-4 "Hemoglobin A1c/Hemoglobin.total in Blood"

// Chronic low HRV → suggest CRP (systemic inflammation)
// Replaces: LifestyleMedicineTemporaryCS#crp
* http://loinc.org#1988-5 "C reactive protein [Mass/volume] in Serum or Plasma"

// HR variability + fatigue patterns → suggest thyroid function
// Replaces: LifestyleMedicineTemporaryCS#tsh
* http://loinc.org#3016-3 "Thyrotropin [Units/volume] in Serum or Plasma"

// Low CRF + slow recovery → suggest iron panel
// Replaces: LifestyleMedicineTemporaryCS#iron-studies
* http://loinc.org#75689-0 "Iron panel - Serum or Plasma"

// Wearable arrhythmia detection → suggest 12-lead ECG
// Replaces: LifestyleMedicineTemporaryCS#ecg-12lead
* http://loinc.org#34534-8 "12 lead EKG panel"

// Low VO2max + CV risk → suggest exercise stress test
// Replaces: LifestyleMedicineTemporaryCS#stress-test
* http://loinc.org#18752-6 "Exercise stress test study"

// Abnormal SpO2 during exercise → suggest pulmonary function
// Replaces: LifestyleMedicineTemporaryCS#pulmonary-testing
* http://loinc.org#58477-1 "Pulmonary function study"

// Elevated CV risk score → suggest lipid panel
// Replaces: LifestyleMedicineTemporaryCS#lipid-panel
* http://loinc.org#100898-6 "Lipid panel - Serum or Plasma"

// Reproductive nutrition assessment → suggest folate
// Replaces: LifestyleMedicineTemporaryCS#folate-intake
* http://loinc.org#2284-8 "Folate [Mass/volume] in Serum or Plasma"

// Complete blood count (general wellness screening)
// Replaces: LifestyleMedicineTemporaryCS#cbc
* http://loinc.org#57021-8 "CBC W Auto Differential panel - Blood"

// Comprehensive metabolic panel
// Replaces: LifestyleMedicineTemporaryCS#cmp
* http://loinc.org#24323-8 "Comprehensive metabolic 2000 panel - Serum or Plasma"

// Vitamin D level
// Replaces: LifestyleMedicineTemporaryCS#vitamin-d
* http://loinc.org#1989-3 "25-hydroxyvitamin D3 [Mass/volume] in Serum or Plasma"

// ============================================================================
// SNOMED CT DIAGNOSTIC PROCEDURES
// ============================================================================

// Abnormal cardiac wearable pattern → suggest echocardiography
// Replaces: LifestyleMedicineTemporaryCS#echo
* http://snomed.info/sct#40701008 "Echocardiography"

// Multiple cardiac red flags → comprehensive cardiac assessment
// Replaces: LifestyleMedicineTemporaryCS#cardiac-testing
* http://snomed.info/sct#425315000 "Cardiac assessment"

// Holter monitoring for sustained arrhythmia
// Replaces: LifestyleMedicineTemporaryCS#holter-monitor
* http://snomed.info/sct#252339003 "Holter electrocardiogram monitoring"
