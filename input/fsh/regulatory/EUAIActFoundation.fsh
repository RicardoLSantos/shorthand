// =============================================================================
// EU AI ACT (Regulation 2024/1689) — Foundation Profiles, Extensions, ValueSets
// Created: 2026-04-16 T2 S15
// Reference: Regulation (EU) 2024/1689 of the European Parliament and of the
//            Council of 13 June 2024 (Official Journal L, 2024/1689, 12.7.2024)
// Gaps covered: EUAI-GAP-01 (Art. 9), EUAI-GAP-02 (Art. 10), EUAI-GAP-03 (Art. 11),
//               EUAI-GAP-04 (Art. 15)
// Dependencies: AgentDecisionSupportCS (risk classification + new codes),
//               AppLogicCS, DeviceDefinitionSLM, AIInferenceMetadata
// Cross-jurisdictional: CFM 2.454 (Brazil), LGPD (Brazil), GDPR (EU), HIPAA (US)
// =============================================================================

// =============================================================================
// VALUE SETS
// =============================================================================

ValueSet: AITechnicalDocumentTypeVS
Id: ai-technical-document-type-vs
Title: "AI Technical Document Type ValueSet"
Description: """
Types of technical documentation required for high-risk AI systems under
EU AI Act Art. 11 and Annex IV.

Cross-jurisdictional applicability:
- CFM 2.454 Art. 6: Traceability and audit trail documentation
- LGPD Art. 6-VI: Transparency principle
- GDPR Art. 13-14: Information to be provided to data subjects
"""
* ^status = #active
* ^experimental = false
* AgentDecisionSupportCS#ai-technical-doc-model-card
* AgentDecisionSupportCS#ai-technical-doc-impact-assessment

ValueSet: AIPerformanceMetricTypeVS
Id: ai-performance-metric-type-vs
Title: "AI Performance Metric Type ValueSet"
Description: """
Types of performance metrics for AI system validation and monitoring under
EU AI Act Art. 15 (accuracy, robustness, cybersecurity).

Cross-jurisdictional applicability:
- CFM 2.454 Art. 5: Patient safety requirements for AI systems
- LGPD Art. 6-IV: Non-discrimination principle (bias metrics)
"""
* ^status = #active
* ^experimental = false
* AgentDecisionSupportCS#ai-performance-validated
* AgentDecisionSupportCS#ai-performance-monitoring

ValueSet: AITrainingDataStatusVS
Id: ai-training-data-status-vs
Title: "AI Training Data Governance Status ValueSet"
Description: """
Certification status of AI training datasets under EU AI Act Art. 10
data governance requirements.

Art. 10 requires: relevant, representative, free of errors, complete datasets.
Bias assessment against protected characteristics is mandatory.
"""
* ^status = #active
* ^experimental = false
* AgentDecisionSupportCS#ai-training-data-certified
* AgentDecisionSupportCS#ai-training-data-uncertified

ValueSet: AIRiskAssessmentStatusVS
Id: ai-risk-assessment-status-vs
Title: "AI Risk Assessment Status ValueSet"
Description: """
Status of risk management assessments for AI systems under EU AI Act Art. 9.
"""
* ^status = #active
* ^experimental = false
* AgentDecisionSupportCS#ai-risk-assessment-complete
* AgentDecisionSupportCS#ai-risk-assessment-pending

// =============================================================================
// EXTENSIONS
// =============================================================================

// ============================================================================
// Extension: AIPerformanceMetrics
// EU AI Act Art. 15: Accuracy, robustness and cybersecurity
// Cross-jurisdictional: CFM 2.454 Art. 5 (safety), LGPD Art. 6-IV (non-discrimination)
// Gap: EUAI-GAP-04
// ============================================================================
Extension: AIPerformanceMetrics
Id: ai-performance-metrics
Title: "AI Performance Metrics"
Description: """
Structured performance metrics for AI/ML models used in clinical decision support.

EU AI Act Art. 15 requires high-risk AI systems to achieve appropriate levels of
accuracy, robustness, and cybersecurity. This extension captures quantitative
performance benchmarks used during validation and continuous monitoring.

Cross-jurisdictional applicability:
- CFM 2.454 Art. 5: AI systems must demonstrate safety for patient care
- LGPD Art. 6-IV: Bias metrics ensure non-discriminatory processing
- HIPAA: Performance documentation supports meaningful use attestation
"""
Context: DeviceDefinition, ClinicalImpression, RiskAssessment
* extension contains
    accuracy 0..1 and
    precision 0..1 and
    recall 0..1 and
    f1Score 0..1 and
    areaUnderCurve 0..1 and
    calibrationScore 0..1 and
    validationDate 0..1 MS and
    validationDatasetSize 0..1
* extension[accuracy].value[x] only decimal
* extension[accuracy] ^short = "Overall accuracy (0.0-1.0)"
* extension[precision].value[x] only decimal
* extension[precision] ^short = "Precision/positive predictive value (0.0-1.0)"
* extension[recall].value[x] only decimal
* extension[recall] ^short = "Recall/sensitivity (0.0-1.0)"
* extension[f1Score].value[x] only decimal
* extension[f1Score] ^short = "F1 score — harmonic mean of precision and recall (0.0-1.0)"
* extension[areaUnderCurve].value[x] only decimal
* extension[areaUnderCurve] ^short = "AUC-ROC for binary classifiers (0.0-1.0)"
* extension[calibrationScore].value[x] only decimal
* extension[calibrationScore] ^short = "Calibration score (Brier score, 0.0-1.0, lower is better)"
* extension[validationDate].value[x] only dateTime
* extension[validationDate] ^short = "Date of last performance validation"
* extension[validationDatasetSize].value[x] only integer
* extension[validationDatasetSize] ^short = "Number of samples in validation dataset"

// ============================================================================
// Extension: AITrainingDataGovernance
// EU AI Act Art. 10: Data and data governance
// Cross-jurisdictional: LGPD Art. 6-IV (non-discrimination), GDPR Art. 22
// Gap: EUAI-GAP-02
// ============================================================================
Extension: AITrainingDataGovernance
Id: ai-training-data-governance
Title: "AI Training Data Governance"
Description: """
Metadata about AI model training data to support EU AI Act Art. 10 compliance.

Art. 10 requires that training, validation, and testing datasets are relevant,
sufficiently representative, and to the best extent possible free of errors and
complete. Providers must examine datasets for possible biases.

Cross-jurisdictional applicability:
- LGPD Art. 6-IV: Non-discrimination — training data bias assessment mandatory
- LGPD Art. 20: Right to review automated decisions requires explainability
- GDPR Art. 22: Automated decision-making safeguards
- CFM 2.454 Art. 5: Safety requirements include data quality assurance
"""
Context: DeviceDefinition
* extension contains
    datasetSize 0..1 and
    dataQualityScore 0..1 and
    biasAssessmentDate 0..1 MS and
    demographicCoverage 0..1 and
    certificationStatus 1..1 MS
* extension[datasetSize].value[x] only integer
* extension[datasetSize] ^short = "Total samples in training dataset"
* extension[dataQualityScore].value[x] only decimal
* extension[dataQualityScore] ^short = "Data quality metric (0.0-1.0, provider-defined)"
* extension[biasAssessmentDate].value[x] only dateTime
* extension[biasAssessmentDate] ^short = "Date of last bias assessment (Art. 10(2)(f))"
* extension[demographicCoverage].value[x] only string
* extension[demographicCoverage] ^short = "Description of demographic representation in dataset"
* extension[certificationStatus].value[x] only CodeableConcept
* extension[certificationStatus].valueCodeableConcept from AITrainingDataStatusVS (required)
* extension[certificationStatus] ^short = "Training data governance certification status"

// =============================================================================
// PROFILES
// =============================================================================

// ============================================================================
// Profile: RiskAssessmentAISystem
// EU AI Act Art. 9: Risk management system
// Cross-jurisdictional: CFM 2.454 Art. 3 (risk classification), LGPD Art. 6-IV
// Gap: EUAI-GAP-01
// ============================================================================
Profile: RiskAssessmentAISystem
Parent: RiskAssessment
Id: risk-assessment-ai-system
Title: "AI System Risk Assessment"
Description: """
Risk assessment for AI systems used in clinical decision support, structured to
support EU AI Act Art. 9 risk management requirements.

Art. 9 requires a risk management system that:
(a) identifies and analyses known and reasonably foreseeable risks
(b) estimates and evaluates risks during intended use and misuse
(c) evaluates risks from data analysis (Art. 10)
(d) adopts suitable risk management measures

This profile captures the assessment outcome, risk level classification,
mitigation measures, and regulatory review status.

Cross-jurisdictional applicability:
- CFM 2.454 Art. 3: Risk classification (4-tier) maps to prediction.qualitativeRisk
- LGPD Art. 38: Data Protection Impact Assessment (DPIA) for high-risk processing
- GDPR Art. 35: DPIA required for automated processing with legal effects
"""
* status MS
* subject 1..1 MS
* subject ^short = "The AI system (Device/DeviceDefinition) being assessed"
* code 1..1 MS
* code ^short = "Type of risk assessment (e.g., initial, periodic, post-incident)"
* occurrence[x] MS
* occurrence[x] ^short = "When the assessment was performed"
* prediction 1..* MS
* prediction ^short = "Risk predictions with probability and mitigation"
* prediction.outcome MS
* prediction.outcome ^short = "Identified risk outcome"
* prediction.qualitativeRisk MS
* prediction.qualitativeRisk from AIRiskClassificationVS (extensible)
* prediction.qualitativeRisk ^short = "Risk level: baixo/medio/alto/inaceitavel (EU AI Act Art. 6)"
* mitigation MS
* mitigation ^short = "Risk management measures adopted (Art. 9(4))"
* extension contains
    AIPerformanceMetrics named performanceMetrics 0..1 and
    AIRiskAssessmentStatus named assessmentStatus 1..1 MS

Extension: AIRiskAssessmentStatus
Id: ai-risk-assessment-status
Title: "AI Risk Assessment Status"
Description: "Status of the AI risk management assessment per EU AI Act Art. 9."
Context: RiskAssessment
* value[x] only CodeableConcept
* valueCodeableConcept from AIRiskAssessmentStatusVS (required)

// ============================================================================
// Profile: DocumentReferenceAITechnicalDoc
// EU AI Act Art. 11: Technical documentation + Annex IV
// Cross-jurisdictional: CFM 2.454 Art. 6 (traceability), LGPD Art. 6-VI (transparency)
// Gap: EUAI-GAP-03
// ============================================================================
Profile: DocumentReferenceAITechnicalDoc
Parent: DocumentReference
Id: document-reference-ai-technical-doc
Title: "AI Technical Documentation Reference"
Description: """
Reference to technical documentation for high-risk AI systems as required by
EU AI Act Art. 11 and detailed in Annex IV.

Annex IV requires documentation covering:
1. General description of the AI system
2. Detailed description of development process and elements
3. Monitoring, functioning, and control of the AI system
4. Description of the risk management system (Art. 9)
5. Description of data governance (Art. 10)
6. Performance metrics and testing methodology

This profile represents a pointer to such documentation, enabling FHIR-based
tracking of which AI systems have complete technical documentation.

Cross-jurisdictional applicability:
- CFM 2.454 Art. 6: Audit trail and traceability requirements
- LGPD Art. 6-VI: Transparency principle — processing logic documentation
- GDPR Art. 13(2)(f): Logic involved in automated decision-making
"""
* status MS
* type 1..1 MS
* type ^short = "Document type: model-card or impact-assessment"
* type from AITechnicalDocumentTypeVS (extensible)
* category 1..* MS
* category ^short = "Regulatory framework (e.g., eu-ai-act, cfm-2454)"
* subject 0..1 MS
* subject ^short = "The AI system (Device/DeviceDefinition) documented"
* date 1..1 MS
* date ^short = "Document creation or last update date"
* description MS
* description ^short = "Summary of what the technical documentation covers"
* content 1..* MS
* content ^short = "Attachment or URL to the actual documentation"
* content.attachment MS
* content.attachment.contentType MS
* content.attachment.url MS
