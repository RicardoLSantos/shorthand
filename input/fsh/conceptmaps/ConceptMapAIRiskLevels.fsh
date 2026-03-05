// ============================================================================
// ConceptMap: AI Risk Levels — CFM 2.454 <-> EU AI Act
// ============================================================================
// Date: 2026-03-05
// Purpose: Maps risk classification levels between Brazilian (CFM 2.454/2026)
//          and European (EU AI Act 2024/1689) regulatory frameworks
// Note: Uses sourceUri (not sourceCanonical) per VRF-TECH-005 to avoid
//       tx.fhir.org expansion issues with local CodeSystems
// ============================================================================

Instance: ConceptMapAIRiskLevels
InstanceOf: ConceptMap
Usage: #definition
Title: "ConceptMap: AI Risk Levels (CFM 2.454 <-> EU AI Act)"
Description: """
Maps AI risk classification levels between CFM Resolution 2.454/2026
(Brazilian Federal Council of Medicine) and EU AI Act Regulation 2024/1689.
Both frameworks use tiered risk classification but with different
nomenclature and regulatory implications.
"""

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ai-risk-levels"
* version = "1.0.0"
* name = "ConceptMapAIRiskLevels"
* status = #active
* experimental = false
* date = "2026-03-05"
* publisher = "iOS Lifestyle Medicine HEADS FHIR IG"
* description = "Bidirectional mapping between CFM 2.454/2026 and EU AI Act risk classification levels"

// Source and target are the same CodeSystem (different code groups represent each framework)
* sourceUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs"
* targetUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs"

// Group: Internal risk levels mapped to regulatory interpretation
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs"
* group[0].target = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs"

// Low Risk
* group[0].element[0].code = #ai-risk-baixo
* group[0].element[0].display = "Baixo Risco (Low Risk)"
* group[0].element[0].target[0].code = #ai-risk-baixo
* group[0].element[0].target[0].display = "Baixo Risco (Low Risk)"
* group[0].element[0].target[0].equivalence = #equal
* group[0].element[0].target[0].comment = "CFM Art. 3: sistemas sem autonomia decisoria. EU AI Act: not in Annex III (minimal obligations). Both frameworks: minimal regulatory requirements, basic transparency."

// Medium Risk
* group[0].element[1].code = #ai-risk-medio
* group[0].element[1].display = "Medio Risco (Medium Risk)"
* group[0].element[1].target[0].code = #ai-risk-medio
* group[0].element[1].target[0].display = "Medio Risco (Medium Risk)"
* group[0].element[1].target[0].equivalence = #equal
* group[0].element[1].target[0].comment = "CFM Art. 4: sistemas com sugestoes clinicas. EU AI Act Art. 52: limited risk with transparency obligations. Both: logging required, user notification of AI involvement."

// High Risk
* group[0].element[2].code = #ai-risk-alto
* group[0].element[2].display = "Alto Risco (High Risk)"
* group[0].element[2].target[0].code = #ai-risk-alto
* group[0].element[2].target[0].display = "Alto Risco (High Risk)"
* group[0].element[2].target[0].equivalence = #equal
* group[0].element[2].target[0].comment = "CFM Art. 5: sistemas com impacto em decisao clinica. EU AI Act Art. 6 + Annex III section 5(b): AI for health/safety. Both: full compliance required — risk management, data governance, human oversight, technical documentation."

// Unacceptable Risk
* group[0].element[3].code = #ai-risk-inaceitavel
* group[0].element[3].display = "Risco Inaceitavel (Unacceptable Risk)"
* group[0].element[3].target[0].code = #ai-risk-inaceitavel
* group[0].element[3].target[0].display = "Risco Inaceitavel (Unacceptable Risk)"
* group[0].element[3].target[0].equivalence = #equal
* group[0].element[3].target[0].comment = "CFM: not explicitly defined (autonomous AI = alto risco maximum). EU AI Act Art. 5: prohibited practices (social scoring, real-time biometric identification). Mapping approximate — CFM does not have explicit 'unacceptable' tier."
