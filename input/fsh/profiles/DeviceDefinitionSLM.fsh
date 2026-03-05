// ============================================================================
// DeviceDefinition SLM Profile
// ============================================================================
// Date: 2026-03-05
// Purpose: DeviceDefinition profile for Small Language Model (SLM) metadata
// Context: Describes AI model type/class (not instance) for regulatory
//          compliance and transparency
// Regulatory: EU AI Act Art. 13 (transparency), Art. 49 (registration)
//             CFM 2.454/2026 Art. 6 (identificacao do sistema de IA)
// ============================================================================

Profile: DeviceDefinitionSLM
Parent: DeviceDefinition
Id: device-definition-slm
Title: "Device Definition SLM Profile"
Description: """
Profile for DeviceDefinition resources describing Small Language Model (SLM)
systems used in the CDSS. Captures model architecture metadata including
runtime environment, quantization format, context window, and training
cutoff. Supports EU AI Act Art. 13 (transparency) and Art. 49 (EU database
registration) as well as CFM 2.454/2026 Art. 6 (system identification).
"""

* ^experimental = false

// Manufacturer
* manufacturerString 0..1 MS
  * ^short = "Model creator (e.g., Mistral AI, Meta, Google, Microsoft)"

// Device name - model name and type
* deviceName 1..* MS
* deviceName.name 1..1 MS
  * ^short = "Model name (e.g., BioMistral-7B-v0.2)"
* deviceName.type 1..1 MS
  * ^short = "udi-label-name | user-friendly-name | patient-reported-name | manufacturer-name | model-name | other"

// Model number - version identifier
* modelNumber 0..1 MS
  * ^short = "Model version (e.g., v0.2, Q4_K_M)"

// Type - device type classification
* type 0..1 MS
  * ^short = "Type of AI system"

// Version - software version
* version 0..* MS
  * ^short = "Software/framework version (e.g., llama.cpp b2415, MLX 0.12)"

// Safety characteristics
* safety 0..* MS
  * ^short = "Safety certifications or risk assessments"

// Online information
* onlineInformation 0..1 MS
  * ^short = "URL to model card or documentation (e.g., HuggingFace model page)"

// Note
* note 0..* MS
  * ^short = "Additional model description, capabilities, or limitations"

// Property - SLM-specific technical properties
* property 0..* MS
* property.type 1..1 MS
  * ^short = "Property type code"
* property.valueQuantity 0..* MS
* property.valueCode 0..* MS

// Physical characteristics reused for model specs
* physicalCharacteristics 0..1 MS
  * ^short = "Model size specifications (parameter count as weight in mg = millions)"

// Capability - what the model can do
* capability 0..* MS
  * ^short = "Model capabilities (text generation, classification, etc.)"

// Language of the model
* languageCode 0..* MS
  * ^short = "Languages supported by the model"
