// Inflammatory Markers Profiles for Lifestyle Medicine
// Created: 2025-11-27
// Purpose: Support RS1 findings on HRV-Inflammation inverse correlation
// Reference: Task Force ESC 1996, Shaffer 2017, Williams 2019

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $observation-category = http://terminology.hl7.org/CodeSystem/observation-category

// =============================================================================
// Task 2.2.1: Base Inflammatory Marker Profile
// =============================================================================

Profile: InflammatoryMarkerObservation
Parent: Observation
Id: inflammatory-marker-observation
Title: "Inflammatory Marker Observation Profile"
Description: """
Base profile for inflammatory biomarker measurements used in lifestyle medicine.
Supports integration with HRV data to assess autonomic-immune interactions.

Key inflammatory markers include:
- C-Reactive Protein (CRP) - acute phase reactant
- High-sensitivity CRP (hs-CRP) - cardiovascular risk marker
- Interleukin-6 (IL-6) - pro-inflammatory cytokine
- Tumor Necrosis Factor Alpha (TNF-α) - inflammatory mediator

Clinical context: Higher HRV (especially RMSSD) correlates with lower inflammation,
reflecting the cholinergic anti-inflammatory pathway (Tracey 2002).
"""

* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^date = "2025-11-27"
* ^publisher = "iOS Lifestyle Medicine HEADS FHIR IG"

* status MS
* category 1..* MS
* category ^slicing.discriminator.type = #value
* category ^slicing.discriminator.path = "coding.code"
* category ^slicing.rules = #open
* category contains laboratory 1..1 MS
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory

* code 1..1 MS
* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS
* value[x] 1..1 MS
* valueQuantity only Quantity
* valueQuantity MS
* specimen 0..1 MS
* method 0..1 MS
* device 0..1 MS
* interpretation 0..1 MS
* referenceRange 0..* MS

* note 0..* MS
* note ^short = "Clinical interpretation notes including HRV correlation context"

// =============================================================================
// Task 2.2.2: CRP Observation Profile
// =============================================================================

Profile: CRPObservation
Parent: InflammatoryMarkerObservation
Id: crp-observation
Title: "C-Reactive Protein (CRP) Observation Profile"
Description: """
Profile for C-Reactive Protein measurements.

LOINC: 1988-5 'C reactive protein [Mass/volume] in Serum or Plasma'

Clinical interpretation:
- Normal: < 3.0 mg/L
- Elevated: 3.0-10.0 mg/L (low-grade inflammation)
- High: > 10.0 mg/L (acute inflammation/infection)

HRV correlation: Inverse relationship with RMSSD (Williams 2019).
Higher vagal tone associated with lower CRP levels.
"""

* code = $LOINC#1988-5 "C reactive protein [Mass/volume] in Serum or Plasma"
* valueQuantity MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #mg/L
* valueQuantity.unit = "mg/L"

* referenceRange.low.value = 0
* referenceRange.low.unit = "mg/L"
* referenceRange.high.value = 3.0
* referenceRange.high.unit = "mg/L"
* referenceRange.text = "Normal: < 3.0 mg/L"

// =============================================================================
// Task 2.2.3: High-Sensitivity CRP Observation Profile
// =============================================================================

Profile: HsCRPObservation
Parent: InflammatoryMarkerObservation
Id: hscrp-observation
Title: "High-Sensitivity C-Reactive Protein (hs-CRP) Observation Profile"
Description: """
Profile for high-sensitivity C-Reactive Protein measurements.

LOINC: 30522-7 'C reactive protein [Mass/volume] in Serum or Plasma by High sensitivity method'

Cardiovascular risk stratification (AHA/CDC guidelines):
- Low risk: < 1.0 mg/L
- Average risk: 1.0-3.0 mg/L
- High risk: > 3.0 mg/L

Primary marker for subclinical inflammation and cardiovascular risk.
Strong inverse correlation with HRV in lifestyle medicine assessment.
"""

* code = $LOINC#30522-7 "C reactive protein [Mass/volume] in Serum or Plasma by High sensitivity method"
* valueQuantity MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #mg/L
* valueQuantity.unit = "mg/L"

* interpretation from HsCRPInterpretationVS (extensible)

* referenceRange ^slicing.discriminator.type = #value
* referenceRange ^slicing.discriminator.path = "text"
* referenceRange ^slicing.rules = #open

* referenceRange contains
    lowRisk 0..1 MS and
    averageRisk 0..1 MS and
    highRisk 0..1 MS

* referenceRange[lowRisk].high.value = 1.0
* referenceRange[lowRisk].high.unit = "mg/L"
* referenceRange[lowRisk].text = "Low cardiovascular risk"

* referenceRange[averageRisk].low.value = 1.0
* referenceRange[averageRisk].low.unit = "mg/L"
* referenceRange[averageRisk].high.value = 3.0
* referenceRange[averageRisk].high.unit = "mg/L"
* referenceRange[averageRisk].text = "Average cardiovascular risk"

* referenceRange[highRisk].low.value = 3.0
* referenceRange[highRisk].low.unit = "mg/L"
* referenceRange[highRisk].text = "High cardiovascular risk"

// =============================================================================
// Task 2.2.4: IL-6 Observation Profile
// =============================================================================

Profile: IL6Observation
Parent: InflammatoryMarkerObservation
Id: il6-observation
Title: "Interleukin-6 (IL-6) Observation Profile"
Description: """
Profile for Interleukin-6 measurements.

LOINC: 26881-3 'Interleukin 6 [Mass/volume] in Serum or Plasma'

Clinical interpretation:
- Normal: < 7 pg/mL (varies by assay)
- Elevated: Associated with chronic inflammation, aging, obesity

IL-6 is a key mediator of the acute phase response and stimulates CRP production.
Vagal nerve stimulation reduces IL-6 (cholinergic anti-inflammatory pathway).
"""

* code = $LOINC#26881-3 "Interleukin 6 [Mass/volume] in Serum or Plasma"
* valueQuantity MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #pg/mL
* valueQuantity.unit = "pg/mL"

* referenceRange.high.value = 7
* referenceRange.high.unit = "pg/mL"
* referenceRange.text = "Normal: < 7 pg/mL (assay-dependent)"

// =============================================================================
// Task 2.2.5: TNF-Alpha Observation Profile
// =============================================================================

Profile: TNFAlphaObservation
Parent: InflammatoryMarkerObservation
Id: tnf-alpha-observation
Title: "Tumor Necrosis Factor Alpha (TNF-α) Observation Profile"
Description: """
Profile for Tumor Necrosis Factor Alpha measurements.

LOINC: 3074-2 'Tumor necrosis factor.alpha [Mass/volume] in Serum or Plasma'

Clinical interpretation:
- Normal: < 8.1 pg/mL (varies by assay)
- Elevated: Chronic inflammation, autoimmune conditions, metabolic syndrome

TNF-α is suppressed by acetylcholine via the inflammatory reflex.
Higher vagal tone (HRV) associated with lower TNF-α levels.
"""

* code = $LOINC#3074-2 "Tumor necrosis factor.alpha [Mass/volume] in Serum or Plasma"
* valueQuantity MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #pg/mL
* valueQuantity.unit = "pg/mL"

* referenceRange.high.value = 8.1
* referenceRange.high.unit = "pg/mL"
* referenceRange.text = "Normal: < 8.1 pg/mL (assay-dependent)"

// =============================================================================
// Task 2.2.6: HRV-Inflammation Correlation Observation Profile
// =============================================================================

Profile: HRVInflammationCorrelationObservation
Parent: Observation
Id: hrv-inflammation-correlation
Title: "HRV-Inflammation Correlation Observation Profile"
Description: """
Profile to capture the correlation between Heart Rate Variability and inflammatory markers.

This profile supports the RS1 systematic review finding:
'Inverse correlation between HRV (especially RMSSD) and inflammatory biomarkers (CRP, IL-6)'

Key relationships documented in literature:
- RMSSD inversely correlates with CRP (r = -0.15 to -0.35)
- Higher vagal tone → Lower inflammation
- Mechanism: Cholinergic anti-inflammatory pathway (Tracey 2002)

Use case: Track changes in HRV alongside inflammatory markers to assess
autonomic-immune axis in lifestyle medicine interventions.
"""

* ^version = "1.0.0"
* ^status = #active
* ^experimental = false

* status MS
* category 1..* MS
* code.text = "HRV-Inflammation Correlation Assessment"
* code.coding.system = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* code.coding.code = #hrv-inflammation-correlation

* subject 1..1 MS
* subject only Reference(Patient)
* effectiveDateTime 1..1 MS

* hasMember 2..* MS
* hasMember ^short = "References to HRV and inflammatory marker observations"
* hasMember only Reference(Observation)

* component 0..* MS
* component ^short = "Correlation coefficient, interpretation, and trend"
* component.code 1..1 MS
* component.value[x] 1..1 MS

* note 0..* MS
* note ^short = "Additional clinical context about autonomic-immune interaction"

// =============================================================================
// ValueSets for Inflammatory Markers
// =============================================================================

ValueSet: HsCRPInterpretationVS
Id: hscrp-interpretation-vs
Title: "hs-CRP Interpretation ValueSet"
Description: "Cardiovascular risk interpretation for hs-CRP results (AHA/CDC guidelines)"
* ^status = #active
* ^experimental = false
* LifestyleMedicineTemporaryCS#crp-risk-low-risk "Low cardiovascular risk"
* LifestyleMedicineTemporaryCS#average-risk "Average cardiovascular risk"
* LifestyleMedicineTemporaryCS#crp-risk-high-risk "High cardiovascular risk"

ValueSet: HRVInflammationTrendVS
Id: hrv-inflammation-trend-vs
Title: "HRV-Inflammation Trend ValueSet"
Description: """
Trend direction for HRV-Inflammation correlation assessment.
Uses SNOMED-CT codes from mCODE (minimal Common Oncology Data Elements) IG.

Source: HL7 mCODE Implementation Guide v4.0.0
  - https://build.fhir.org/ig/HL7/fhir-mCODE-ig/ValueSet-mcode-condition-status-trend-vs.html

SNOMED-CT codes validated via mCODE IG (HL7 International / Clinical Interoperability Council).
"""
* ^status = #active
* ^experimental = false
* ^copyright = "This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO)"
* $SCT#268910001 "Patient's condition improved"
* $SCT#359746009 "Patient's condition stable"
* $SCT#271299001 "Patient's condition worsened"

ValueSet: InflammatoryMarkerVS
Id: inflammatory-marker-vs
Title: "Inflammatory Marker ValueSet"
Description: "LOINC codes for inflammatory biomarkers used in lifestyle medicine"
* ^status = #active
* ^experimental = false
* $LOINC#1988-5 "C reactive protein [Mass/volume] in Serum or Plasma"
* $LOINC#30522-7 "C reactive protein [Mass/volume] in Serum or Plasma by High sensitivity method"
* $LOINC#26881-3 "Interleukin 6 [Mass/volume] in Serum or Plasma"
* $LOINC#3074-2 "Tumor necrosis factor.alpha [Mass/volume] in Serum or Plasma"
* $LOINC#4537-7 "Erythrocyte sedimentation rate"
* $LOINC#33762-6 "Natriuretic peptide.B prohormone N-Terminal [Mass/volume] in Serum or Plasma"
