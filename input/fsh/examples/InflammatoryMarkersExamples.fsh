// Inflammatory Markers Examples
// Created: 2025-11-27
// Task 2.2.7: Example instances for inflammatory marker profiles

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $observation-category = http://terminology.hl7.org/CodeSystem/observation-category

// =============================================================================
// Example 1: Normal CRP
// =============================================================================

Instance: CRPExample-Normal
InstanceOf: CRPObservation
Title: "CRP Example - Normal Value"
Description: "Example of normal C-Reactive Protein measurement"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#1988-5 "C reactive protein [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T08:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 1.2
* valueQuantity.unit = "mg/L"
* valueQuantity.system = $UCUM
* valueQuantity.code = #mg/L
* interpretation.coding.system = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* interpretation.coding.code = #crp-risk-low-risk
* interpretation.coding.display = "Low cardiovascular risk"
* note.text = "Normal CRP level consistent with low systemic inflammation. Patient has good HRV metrics (RMSSD 45ms)."

// =============================================================================
// Example 2: Elevated CRP
// =============================================================================

Instance: CRPExample-Elevated
InstanceOf: CRPObservation
Title: "CRP Example - Elevated Value"
Description: "Example of elevated C-Reactive Protein indicating inflammation"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#1988-5 "C reactive protein [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T08:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 8.5
* valueQuantity.unit = "mg/L"
* valueQuantity.system = $UCUM
* valueQuantity.code = #mg/L
* interpretation.coding.system = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* interpretation.coding.code = #crp-risk-high-risk
* interpretation.coding.display = "High cardiovascular risk"
* note.text = "Elevated CRP suggests systemic inflammation. Correlates with reduced HRV (RMSSD 22ms). Consider lifestyle intervention."

// =============================================================================
// Example 3: hs-CRP for Cardiovascular Risk
// =============================================================================

Instance: HsCRPExample-CardiovascularRisk
InstanceOf: HsCRPObservation
Title: "hs-CRP Example - Cardiovascular Risk Assessment"
Description: "High-sensitivity CRP for cardiovascular risk stratification"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#30522-7 "C reactive protein [Mass/volume] in Serum or Plasma by High sensitivity method"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T09:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 2.1
* valueQuantity.unit = "mg/L"
* valueQuantity.system = $UCUM
* valueQuantity.code = #mg/L
* interpretation.coding.system = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* interpretation.coding.code = #average-risk
* interpretation.coding.display = "Average cardiovascular risk"
* note.text = "Average cardiovascular risk based on hs-CRP. Combined with HRV assessment for comprehensive autonomic-inflammatory profiling."

// =============================================================================
// Example 4: IL-6 Measurement
// =============================================================================

Instance: IL6Example-Elevated
InstanceOf: IL6Observation
Title: "IL-6 Example - Elevated"
Description: "Example of elevated Interleukin-6"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#26881-3 "Interleukin 6 [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T09:15:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 12.5
* valueQuantity.unit = "pg/mL"
* valueQuantity.system = $UCUM
* valueQuantity.code = #pg/mL
* interpretation.text = "Elevated - suggests chronic low-grade inflammation"
* note.text = "IL-6 elevation correlates with reduced vagal tone. Patient shows RMSSD decline over past 4 weeks."

// =============================================================================
// Example 5: TNF-Alpha Measurement
// =============================================================================

Instance: TNFAlphaExample-Normal
InstanceOf: TNFAlphaObservation
Title: "TNF-α Example - Normal"
Description: "Example of normal Tumor Necrosis Factor Alpha"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#3074-2 "Tumor necrosis factor.alpha [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T09:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 5.2
* valueQuantity.unit = "pg/mL"
* valueQuantity.system = $UCUM
* valueQuantity.code = #pg/mL
* interpretation.text = "Within normal limits"
* note.text = "Normal TNF-α level. Consistent with adequate vagal anti-inflammatory regulation."

// =============================================================================
// Example 6: HRV-Inflammation Correlation Assessment
// =============================================================================

Instance: HRVInflammationCorrelationExample
InstanceOf: HRVInflammationCorrelationObservation
Title: "HRV-Inflammation Correlation Example"
Description: "Example of HRV-Inflammation correlation assessment showing inverse relationship"
Usage: #example

* status = #final
* category.coding.system = $observation-category
* category.coding.code = #exam
* category.coding.display = "Exam"
* code.text = "HRV-Inflammation Correlation Assessment"
* code.coding.system = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* code.coding.code = #hrv-inflammation-correlation
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T10:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* hasMember[0] = Reference(CRPExample-Elevated)
* hasMember[0].display = "CRP: 8.5 mg/L (elevated)"
* hasMember[1] = Reference(IL6Example-Elevated)
* hasMember[1].display = "IL-6: 12.5 pg/mL (elevated)"

* component[0].code.text = "Correlation coefficient"
* component[0].valueQuantity.value = -0.28
* component[0].valueQuantity.system = $UCUM
* component[0].valueQuantity.code = #1

* component[1].code.text = "Clinical interpretation"
* component[1].valueString = "Inverse correlation confirmed: Low HRV associated with elevated inflammatory markers (CRP 8.5, IL-6 12.5). Pattern consistent with reduced vagal anti-inflammatory regulation."

* component[2].code.text = "Trend direction"
* component[2].valueCodeableConcept.coding.system = $SCT
* component[2].valueCodeableConcept.coding.code = #271299001
* component[2].valueCodeableConcept.coding.display = "Patient's condition worsened"

* note.text = "This assessment demonstrates the cholinergic anti-inflammatory pathway dysfunction. Lifestyle medicine intervention initiated: daily walking, mindfulness practice, sleep hygiene protocol."

// =============================================================================
// Example 7: Comprehensive Inflammatory Panel
// =============================================================================
// Uses LOINC 82335-1 (Cytokines panel) + hasMember for CRP (not in cytokines panel)
// Based on RS1 systematic review markers: CRP, IL-6, TNF-α

Instance: InflammatoryPanelExample
InstanceOf: Observation
Title: "Inflammatory Panel Example"
Description: "Comprehensive inflammatory marker panel for lifestyle medicine assessment. Combines cytokines panel (IL-6, TNF-α) with CRP measurements per RS1 systematic review findings."
Usage: #example

* status = #final
* category.coding.system = $observation-category
* category.coding.code = #laboratory
* category.coding.display = "Laboratory"
* code.coding[0] = $LOINC#82335-1 "Cytokines panel - Serum or Plasma"
* code.text = "Lifestyle Medicine Inflammatory Panel"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T08:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)

// Panel groups individual marker observations via hasMember
// CRP is NOT part of cytokines panel (it's an acute phase protein, not a cytokine)
* hasMember[0] = Reference(Observation/CRPExample-Normal)
* hasMember[0].display = "CRP measurement"
* hasMember[1] = Reference(Observation/IL6Example-Elevated)
* hasMember[1].display = "IL-6 measurement"
* hasMember[2] = Reference(Observation/TNFAlphaExample-Normal)
* hasMember[2].display = "TNF-α measurement"

* note.text = "Baseline inflammatory panel for lifestyle medicine program enrollment. Combines LOINC cytokines panel (82335-1) with CRP per AHA/CDC guidelines. Results will be correlated with wearable HRV data for personalized intervention planning based on RS1 systematic review findings on HRV-inflammation inverse correlation."

// =============================================================================
// Examples 8-11: Castro-Marrero 2022 bridge cytokines (IL-1β, IL-8, IL-10) + Lactate
// =============================================================================

Instance: IL1BetaExample-Normal
InstanceOf: IL1BetaObservation
Title: "IL-1β Example - Within Reference Interval"
Description: "Example of Interleukin-1 beta measurement within reference interval"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#13629-1 "Interleukin 1 beta [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T09:20:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 2.1
* valueQuantity.unit = "pg/mL"
* valueQuantity.system = $UCUM
* valueQuantity.code = #pg/mL
* note.text = "IL-1β within reference interval. Member of the circulating cytokine panel (with IL-6/IL-8/IL-10/TNF-α) captured for the mito-inflammation axis per RS1 / Castro-Marrero 2022."

Instance: IL8Example-Elevated
InstanceOf: IL8Observation
Title: "IL-8 Example - Elevated"
Description: "Example of elevated Interleukin-8 (CXCL8)"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#33211-4 "Interleukin 8 [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T09:22:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 45.0
* valueQuantity.unit = "pg/mL"
* valueQuantity.system = $UCUM
* valueQuantity.code = #pg/mL
* note.text = "Elevated IL-8 (neutrophil chemoattractant) suggesting active pro-inflammatory signalling. Interpret against wearable HRV trend (autonomic-immune axis)."

Instance: IL10Example-Normal
InstanceOf: IL10Observation
Title: "IL-10 Example - Within Reference Interval"
Description: "Example of Interleukin-10 (regulatory/anti-inflammatory cytokine)"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#26848-2 "Interleukin 10 [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T09:24:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 4.5
* valueQuantity.unit = "pg/mL"
* valueQuantity.system = $UCUM
* valueQuantity.code = #pg/mL
* note.text = "IL-10 captured alongside pro-inflammatory markers to represent the pro-/anti-inflammatory balance modulated by mitochondrial-targeted intervention (Castro-Marrero 2022)."

Instance: LactateExample-Normal
InstanceOf: LactateObservation
Title: "Lactate Example - Within Reference Interval"
Description: "Example of blood lactate as a mitochondrial anaerobic-metabolism proxy"
Usage: #example

* status = #final
* category[laboratory].coding.system = $observation-category
* category[laboratory].coding.code = #laboratory
* category[laboratory].coding.display = "Laboratory"
* code = $LOINC#14118-4 "Lactate [Mass/volume] in Serum or Plasma"
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2025-11-27T09:26:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* valueQuantity.value = 12.0
* valueQuantity.unit = "mg/dL"
* valueQuantity.system = $UCUM
* valueQuantity.code = #mg/dL
* note.text = "Resting lactate within reference interval (approximately 1.3 mmol/L). Serial lactate can serve as an accessible proxy for anaerobic metabolism / mitochondrial oxidative capacity alongside VO2max in the mito-inflammation axis."
