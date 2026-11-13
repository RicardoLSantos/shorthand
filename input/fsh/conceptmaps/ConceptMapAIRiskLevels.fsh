// ============================================================================
// ConceptMap: AI Risk Levels — CFM 2.454 <-> EU AI Act
// ============================================================================
// Date: 2026-03-05
// Purpose: Maps risk classification levels between Brazilian (CFM 2.454/2026)
//          and European (EU AI Act 2024/1689) regulatory frameworks
// Note: Uses sourceUri (not sourceCanonical) to avoid
//       tx.fhir.org expansion issues with local CodeSystems
// Checked 2026-11-13: the article references in the comments were checked
//       against Regulation (EU) 2024/1689 (OJ L, 12.7.2024) and CFM
//       Resolution 2.454/2026 (DOU of 27 Feb 2026)
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

* version = "1.0.0"
* name = "ConceptMapAIRiskLevels"
* status = #draft
* experimental = true
* date = "2026-11-13"
* publisher = "iOS Lifestyle Medicine HEADS FHIR IG"
* description = "Bidirectional mapping between CFM 2.454/2026 and EU AI Act risk classification levels"

// Group: Internal risk levels mapped to regulatory interpretation
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs"
* group[0].target = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/agent-decision-support-cs"

// Low Risk
* group[0].element[0].code = #ai-risk-baixo
* group[0].element[0].display = "Baixo Risco (Low Risk)"
* group[0].element[0].target[0].code = #ai-risk-baixo
* group[0].element[0].target[0].display = "Baixo Risco (Low Risk)"
* group[0].element[0].target[0].equivalence = #equal
* group[0].element[0].target[0].comment = "CFM 2.454/2026 Art. 13 and Annex II, item I (baixo risco): no direct decision-making influence on individual diagnoses or treatments. EU AI Act: not in Annex III (minimal obligations). Both frameworks: minimal regulatory requirements, basic transparency."

// Medium Risk
* group[0].element[1].code = #ai-risk-medio
* group[0].element[1].display = "Medio Risco (Medium Risk)"
* group[0].element[1].target[0].code = #ai-risk-medio
* group[0].element[1].target[0].display = "Medio Risco (Medium Risk)"
* group[0].element[1].target[0].equivalence = #equal
* group[0].element[1].target[0].comment = "CFM 2.454/2026 Art. 13 and Annex II, item II (medio risco): systems that support clinical or operational decisions but do not carry them out autonomously. EU AI Act Art. 50: transparency obligations for providers and deployers of certain AI systems. Both: logging required, user notification of AI involvement."

// High Risk
* group[0].element[2].code = #ai-risk-alto
* group[0].element[2].display = "Alto Risco (High Risk)"
* group[0].element[2].target[0].code = #ai-risk-alto
* group[0].element[2].target[0].display = "Alto Risco (High Risk)"
* group[0].element[2].target[0].equivalence = #equal
* group[0].element[2].target[0].comment = "CFM 2.454/2026 Art. 13 and Annex II, item III (alto risco): systems that directly influence critical medical decisions or carry out automated actions with relevant clinical consequences. EU AI Act Art. 6(1) and Annex I: an AI system that is a medical device, or a safety component of one, under Regulation (EU) 2017/745 or 2017/746, when a third-party conformity assessment is required. Both: full compliance required — risk management, data governance, human oversight, technical documentation."

// Unacceptable Risk
* group[0].element[3].code = #ai-risk-inaceitavel
* group[0].element[3].display = "Risco Inaceitavel (Unacceptable Risk)"
* group[0].element[3].target[0].code = #ai-risk-inaceitavel
* group[0].element[3].target[0].display = "Risco Inaceitavel (Unacceptable Risk)"
* group[0].element[3].target[0].equivalence = #equal
* group[0].element[3].target[0].comment = "CFM 2.454/2026 Art. 13 names an 'inaceitavel' (unacceptable) level, but Annex II defines only the low, medium and high levels. EU AI Act Art. 5: prohibited practices (social scoring, real-time biometric identification). Mapping approximate: the CFM gives no definition for the unacceptable level."
