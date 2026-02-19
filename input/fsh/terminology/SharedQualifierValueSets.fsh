// =============================================================================
// SHARED QUALIFIER VALUE SETS - SNOMED CT References
// =============================================================================
// Date: 2026-02-19
// Reference: VRF-TECH-027 Session 3, INTERVENTION_SNOMED_CODE_REPLACEMENT_20260219.md
// Purpose: Replace duplicated custom qualifier codes with standard SNOMED CT codes
//
// DESIGN RATIONALE:
// - FSH Quickstart (lines 823-825): "Avoid creating new CodeSystem if possible"
// - RS11 Database-First Protocol: Use tx.fhir.org verified SNOMED codes
// - Reduces CodeSystem fragmentation (102 qualifier codes across 16 keywords)
// - Improves interoperability with any SNOMED-compatible system
//
// SNOMED CODES VERIFIED: tx.fhir.org 2026-02-19
// =============================================================================


// -----------------------------------------------------------------------------
// RISK LEVEL VALUE SET
// Replaces: RiskLevel CodeSystem, FallRiskOutcomes CodeSystem
// Usage: Fall risk, cardiovascular risk, any clinical risk assessment
// -----------------------------------------------------------------------------
ValueSet: RiskLevelSNOMEDVS
Id: risk-level-snomed-vs
Title: "Risk Level Value Set (SNOMED CT)"
Description: """
Standard SNOMED CT codes for clinical risk level assessment.
Replaces custom RiskLevel and FallRiskOutcomes CodeSystems.
Verified against tx.fhir.org 2026-02-19.
"""
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/risk-level-snomed-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-02-19"
* ^publisher = "FMUP/2RDoc"
* ^copyright = "SNOMED CT codes are copyright SNOMED International. Used under affiliate license."

* http://snomed.info/sct#260413007 "None (qualifier value)"
* http://snomed.info/sct#723505004 "Low risk (qualifier value)"
* http://snomed.info/sct#25594002 "Moderate risk of (qualifier value)"
* http://snomed.info/sct#723509005 "High risk (qualifier value)"
* http://snomed.info/sct#261665006 "Unknown (qualifier value)"


// -----------------------------------------------------------------------------
// SEVERITY QUALIFIER VALUE SET
// Replaces: Severity codes in MobilityDeclineOutcomes, SymptomImpactCS, StressImpactCS
// Usage: Any clinical severity assessment (mild/moderate/severe)
// -----------------------------------------------------------------------------
ValueSet: SeverityQualifierSNOMEDVS
Id: severity-qualifier-snomed-vs
Title: "Severity Qualifier Value Set (SNOMED CT)"
Description: """
Standard SNOMED CT severity qualifiers for clinical assessments.
Replaces custom severity codes across multiple CodeSystems.
Verified against tx.fhir.org 2026-02-19.
"""
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/severity-qualifier-snomed-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-02-19"
* ^publisher = "FMUP/2RDoc"

* http://snomed.info/sct#260413007 "None (qualifier value)"
* http://snomed.info/sct#255604002 "Mild (qualifier value)"
* http://snomed.info/sct#6736007 "Moderate (severity modifier)"
* http://snomed.info/sct#24484000 "Severe (severity modifier)"


// -----------------------------------------------------------------------------
// QUALITY GRADE VALUE SET
// Replaces: SleepQualityCS, MeasurementQualityCS quality grades
// Usage: Sleep quality, measurement quality, any subjective quality rating
// -----------------------------------------------------------------------------
ValueSet: QualityGradeSNOMEDVS
Id: quality-grade-snomed-vs
Title: "Quality Grade Value Set (SNOMED CT)"
Description: """
Standard SNOMED CT quality grade qualifiers.
Replaces custom quality codes in SleepQualityCS, MeasurementQualityCS.
Verified against tx.fhir.org 2026-02-19.
"""
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/quality-grade-snomed-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-02-19"
* ^publisher = "FMUP/2RDoc"

* http://snomed.info/sct#425405005 "Excellent (qualifier value)"
* http://snomed.info/sct#20572008 "Good (qualifier value)"
* http://snomed.info/sct#260347006 "Fair (qualifier value)"
* http://snomed.info/sct#255351007 "Poor (qualifier value)"


// -----------------------------------------------------------------------------
// TREND DIRECTION VALUE SET
// Replaces: TrendDirectionCS, VO2maxTrendCS trend codes
// Usage: Clinical trend assessment (improving/stable/worsening)
// -----------------------------------------------------------------------------
ValueSet: TrendDirectionSNOMEDVS
Id: trend-direction-snomed-vs
Title: "Trend Direction Value Set (SNOMED CT)"
Description: """
Standard SNOMED CT codes for clinical trend/progression assessment.
Replaces custom TrendDirectionCS and similar CodeSystems.
Verified against tx.fhir.org 2026-02-19.
"""
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/trend-direction-snomed-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-02-19"
* ^publisher = "FMUP/2RDoc"

* http://snomed.info/sct#385633008 "Improving (qualifier value)"
* http://snomed.info/sct#58158008 "Stable (qualifier value)"
* http://snomed.info/sct#271299001 "Worsening (qualifier value)"
* http://snomed.info/sct#261665006 "Unknown (qualifier value)"


// -----------------------------------------------------------------------------
// ASSISTANCE LEVEL VALUE SET
// Replaces: AssistanceLevelOutcomes CodeSystem
// Usage: Functional independence assessment, rehabilitation
// -----------------------------------------------------------------------------
ValueSet: AssistanceLevelSNOMEDVS
Id: assistance-level-snomed-vs
Title: "Assistance Level Value Set (SNOMED CT)"
Description: """
Standard SNOMED CT codes for functional assistance level assessment.
Replaces custom AssistanceLevelOutcomes CodeSystem.
Verified against tx.fhir.org 2026-02-19.
"""
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/assistance-level-snomed-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-02-19"
* ^publisher = "FMUP/2RDoc"

* http://snomed.info/sct#371153006 "Independent (qualifier value)"
* http://snomed.info/sct#255605001 "Minimal (qualifier value)"
* http://snomed.info/sct#6736007 "Moderate (severity modifier)"
* http://snomed.info/sct#56851009 "Maximum (qualifier value)"
* http://snomed.info/sct#182891003 "Dependent (qualifier value)"


// -----------------------------------------------------------------------------
// CONFIDENCE LEVEL VALUE SET
// Replaces: AgentConfidenceLevelCS, DataQualityConfidenceCS
// Usage: AI/Agent confidence, data quality confidence
// -----------------------------------------------------------------------------
ValueSet: ConfidenceLevelSNOMEDVS
Id: confidence-level-snomed-vs
Title: "Confidence Level Value Set (SNOMED CT)"
Description: """
Standard SNOMED CT codes for confidence/certainty levels.
Replaces custom AgentConfidenceLevelCS, DataQualityConfidenceCS.
Verified against tx.fhir.org 2026-02-19.
"""
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/confidence-level-snomed-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-02-19"
* ^publisher = "FMUP/2RDoc"

* http://snomed.info/sct#410592001 "Definitely (qualifier value)"
* http://snomed.info/sct#75540009 "High (qualifier value)"
* http://snomed.info/sct#6736007 "Moderate (severity modifier)"
* http://snomed.info/sct#62482003 "Low (qualifier value)"
* http://snomed.info/sct#261665006 "Unknown (qualifier value)"


// -----------------------------------------------------------------------------
// NORMAL/ABNORMAL VALUE SET
// Replaces: Various normal/abnormal codes across CodeSystems
// Usage: Clinical findings, test results interpretation
// -----------------------------------------------------------------------------
ValueSet: NormalAbnormalSNOMEDVS
Id: normal-abnormal-snomed-vs
Title: "Normal/Abnormal Value Set (SNOMED CT)"
Description: """
Standard SNOMED CT codes for normal/abnormal classification.
Verified against tx.fhir.org 2026-02-19.
"""
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/normal-abnormal-snomed-vs"
* ^version = "0.2.0"
* ^status = #active
* ^experimental = false
* ^date = "2026-02-19"
* ^publisher = "FMUP/2RDoc"

* http://snomed.info/sct#17621005 "Normal (qualifier value)"
* http://snomed.info/sct#263654008 "Abnormal (qualifier value)"
* http://snomed.info/sct#442096005 "Borderline normal (qualifier value)"
* http://snomed.info/sct#261665006 "Unknown (qualifier value)"


// =============================================================================
// USAGE NOTES
// =============================================================================
//
// These ValueSets should be used instead of defining custom qualifier codes.
//
// Example binding in Profile:
//   * component[riskLevel].value[x] only CodeableConcept
//   * component[riskLevel].valueCodeableConcept from RiskLevelSNOMEDVS (required)
//
// Migration path for existing custom codes:
//   #low -> http://snomed.info/sct#723505004 "Low risk"
//   #moderate -> http://snomed.info/sct#25594002 "Moderate risk"
//   #high -> http://snomed.info/sct#723509005 "High risk"
//
// =============================================================================
