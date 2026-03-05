// ============================================================================
// AI Model Identifier ValueSet
// ============================================================================
// Date: 2026-03-05
// Purpose: Identifies SLM/LLM models used for edge inference in the CDSS
// Context: EU AI Act Art. 13 (transparency) requires model identification
// ============================================================================

ValueSet: AIModelIdentifierVS
Id: ai-model-identifier-vs
Title: "AI Model Identifier Value Set"
Description: "Identifiers for Small Language Models (SLMs) and Large Language Models (LLMs) used in the CDSS edge inference pipeline. Supports EU AI Act Art. 13 transparency requirements."
* ^experimental = false
* ^version = "1.0.0"
* ^date = "2026-03-05"
* AgentDecisionSupportCS#model-qwen35-4b "Qwen 3.5 4B"
* AgentDecisionSupportCS#model-biomistral-7b "BioMistral 7B"
* AgentDecisionSupportCS#model-llama3-8b "LLaMA 3 8B"
* AgentDecisionSupportCS#model-phi3-mini "Phi-3 Mini 3.8B"
* AgentDecisionSupportCS#model-gemma2-2b "Gemma 2 2B"
* AgentDecisionSupportCS#model-custom-slm "Custom Fine-tuned SLM"
