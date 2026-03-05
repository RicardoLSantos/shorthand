// ============================================================================
// AI Risk Classification ValueSet
// ============================================================================
// Date: 2026-03-05
// Purpose: Risk classification levels for AI systems per CFM 2.454/2026 and
//          EU AI Act (Regulation 2024/1689)
// ============================================================================

ValueSet: AIRiskClassificationVS
Id: ai-risk-classification-vs
Title: "AI Risk Classification Value Set"
Description: "Risk classification levels for AI systems in healthcare, aligned with CFM Resolution 2.454/2026 (Brazil) and EU AI Act Regulation 2024/1689 (EU)."
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-03-05"
* AgentDecisionSupportCS#ai-risk-baixo "Baixo Risco (Low Risk)"
* AgentDecisionSupportCS#ai-risk-medio "Medio Risco (Medium Risk)"
* AgentDecisionSupportCS#ai-risk-alto "Alto Risco (High Risk)"
* AgentDecisionSupportCS#ai-risk-inaceitavel "Risco Inaceitavel (Unacceptable Risk)"
