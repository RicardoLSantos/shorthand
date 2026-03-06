// ============================================================================
// CapabilityStatement: iOS Lifestyle Medicine FHIR IG
// ============================================================================
// Date: 2026-03-06
// Purpose: Declares full server capabilities for the IG across 11 domains
// Covers: Observation (all domains), Device, Composition, Bundle,
//         ClinicalImpression, CarePlan, AuditEvent, Consent, Provenance
// ============================================================================

Instance: LifestyleMedicineCapabilityStatement
InstanceOf: CapabilityStatement
Usage: #definition
Title: "iOS Lifestyle Medicine FHIR IG Server Capabilities"
Description: "CapabilityStatement declaring the full server capabilities for the iOS Lifestyle Medicine FHIR Implementation Guide. Covers wearable data capture across 11 lifestyle medicine domains, AI/CDSS compliance profiles, and IPS integration."

* status = #active
* date = "2026-03-06"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[1] = #xml
* implementationGuide = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ImplementationGuide/iOS-Lifestyle-Medicine"

* rest[0]
  * mode = #server
  * documentation = "RESTful server supporting wearable-to-FHIR data transformation across 11 lifestyle medicine domains with AI/CDSS compliance and IPS integration."

  // ========================================================================
  // Observation — Core wearable data resource (majority of profiles)
  // ========================================================================
  * resource[0]
    * type = #Observation
    * documentation = "Supports all wearable observation profiles across 11 domains: Physical Activity, Sleep, Nutrition, Stress/Mental Wellness, Substance Use, Social Connection, HRV, Vital Signs, Body Metrics, Environmental Context, Reproductive Health."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/PhysicalActivityObservation"
    * supportedProfile[1] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/SleepObservation"
    * supportedProfile[2] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/HeartRateObservation"
    * supportedProfile[3] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/BloodPressureObservation"
    * supportedProfile[4] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/OxygenSaturationObservation"
    * supportedProfile[5] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/RespiratoryRateObservation"
    * supportedProfile[6] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/BodyTemperatureObservation"
    * supportedProfile[7] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/WeightObservation"
    * supportedProfile[8] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/HeightObservation"
    * supportedProfile[9] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/BMIObservation"
    * supportedProfile[10] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/VO2MaxEstimationObservation"
    * supportedProfile[11] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/CGMObservation"
    * supportedProfile[12] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/BodyCompositionObservation"
    * supportedProfile[13] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/NutritionIntakeObservation"
    * supportedProfile[14] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/CalorieIntakeObservation"
    * supportedProfile[15] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/WaterIntakeObservation"
    * supportedProfile[16] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/StressLevelProfile"
    * supportedProfile[17] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/EnvironmentalObservation"
    * supportedProfile[18] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/NoiseExposureObservation"
    * supportedProfile[19] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/UVExposureObservation"
    * supportedProfile[20] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/FertilityObservation"
    * supportedProfile[21] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/RecoveryReadinessObservation"
    * supportedProfile[22] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/CRPObservation"
    * supportedProfile[23] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/HsCRPObservation"
    * supportedProfile[24] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/IL6Observation"
    * supportedProfile[25] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/TNFAlphaObservation"
    * supportedProfile[26] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/HRVInflammationCorrelationObservation"
    * supportedProfile[27] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/RunningDynamicsObservation"
    * supportedProfile[28] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/CyclingDynamicsObservation"
    * supportedProfile[29] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/SwimmingMetricsObservation"
    * supportedProfile[30] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/StrengthTrainingObservation"
    * supportedProfile[31] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/MobilityMeasurement"
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #update
    * interaction[3].code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
      * documentation = "Search observations by patient"
    * searchParam[1]
      * name = "date"
      * type = #date
      * documentation = "Search observations by date or date range"
    * searchParam[2]
      * name = "code"
      * type = #token
      * documentation = "Search observations by LOINC/SNOMED/custom code"
    * searchParam[3]
      * name = "category"
      * type = #token
      * documentation = "Search observations by category (vital-signs, activity, laboratory)"
    * searchParam[4]
      * name = "device"
      * type = #reference
      * documentation = "Search observations by source device (vendor filtering)"
    * searchParam[5]
      * name = "value-quantity"
      * type = #quantity
      * documentation = "Search observations by numeric value and unit"
    * searchParam[6]
      * name = "combo-code-value-quantity"
      * type = #composite
      * documentation = "Search observations by code and value together"

  // ========================================================================
  // Device — Wearable device provenance
  // ========================================================================
  * resource[1]
    * type = #Device
    * documentation = "Wearable device instances (Apple Watch, Fitbit, Garmin, Oura, Withings, Polar). Used as Observation.device reference for data provenance."
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #search-type
    * searchParam[0]
      * name = "type"
      * type = #token
      * documentation = "Search devices by SNOMED type code"
    * searchParam[1]
      * name = "manufacturer"
      * type = #string
      * documentation = "Search devices by manufacturer name"

  // ========================================================================
  // Composition — IPS Lifestyle Medicine document
  // ========================================================================
  * resource[2]
    * type = #Composition
    * documentation = "IPS-derived Lifestyle Medicine Composition with 21 sections covering ACLM pillars and wearable-specific domains."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/ips-lifestyle-medicine-composition"
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
    * searchParam[1]
      * name = "date"
      * type = #date
    * searchParam[2]
      * name = "type"
      * type = #token

  // ========================================================================
  // Bundle — IPS document + round-trip validation
  // ========================================================================
  * resource[3]
    * type = #Bundle
    * documentation = "IPS Lifestyle Medicine document Bundle and vendor round-trip validation Bundles."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/ips-lifestyle-medicine-bundle"
    * interaction[0].code = #read
    * interaction[1].code = #create

  // ========================================================================
  // ClinicalImpression — AI/CDSS risk assessment
  // ========================================================================
  * resource[4]
    * type = #ClinicalImpression
    * documentation = "AI-generated clinical impressions with risk assessment, confidence scores, and reasoning narratives. Supports CFM 2.454 and EU AI Act compliance."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/ClinicalImpressionAIAssessment"
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
    * searchParam[1]
      * name = "date"
      * type = #date
    * searchParam[2]
      * name = "status"
      * type = #token

  // ========================================================================
  // CarePlan — Lifestyle medicine intervention plans
  // ========================================================================
  * resource[5]
    * type = #CarePlan
    * documentation = "Lifestyle medicine care plans (AI-generated or physician-created) covering stress management, exercise, nutrition, and sleep interventions."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/CarePlanLifestyleMedicine"
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #update
    * interaction[3].code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
    * searchParam[1]
      * name = "status"
      * type = #token
    * searchParam[2]
      * name = "category"
      * type = #token
    * searchParam[3]
      * name = "date"
      * type = #date

  // ========================================================================
  // AuditEvent — AI inference audit trail
  // ========================================================================
  * resource[6]
    * type = #AuditEvent
    * documentation = "Audit trail for AI/CDSS interactions: inference execution, recommendation generation, physician overrides. Required for EU AI Act Art. 12 and CFM 2.454."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/AuditEventAIInteraction"
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #search-type
    * searchParam[0]
      * name = "date"
      * type = #date
    * searchParam[1]
      * name = "agent"
      * type = #reference
    * searchParam[2]
      * name = "type"
      * type = #token
    * searchParam[3]
      * name = "subtype"
      * type = #token

  // ========================================================================
  // Consent — Multi-jurisdictional data protection
  // ========================================================================
  * resource[7]
    * type = #Consent
    * documentation = "Patient consent records supporting multi-jurisdictional compliance (GDPR, LGPD, HIPAA). Includes AI-assisted care consent per CFM 2.454."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/MultiJurisdictionalConsent"
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #update
    * interaction[3].code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
    * searchParam[1]
      * name = "status"
      * type = #token

  // ========================================================================
  // Provenance — PGHD data provenance
  // ========================================================================
  * resource[8]
    * type = #Provenance
    * documentation = "Patient-Generated Health Data provenance tracking: wearable device source, transformation pipeline, and AI processing chain."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/PGHDProvenance"
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #search-type
    * searchParam[0]
      * name = "target"
      * type = #reference
    * searchParam[1]
      * name = "recorded"
      * type = #date
    * searchParam[2]
      * name = "agent"
      * type = #reference

  // ========================================================================
  // DeviceDefinition — SLM model registry
  // ========================================================================
  * resource[9]
    * type = #DeviceDefinition
    * documentation = "Small Language Model (SLM) device definitions for on-device AI inference registration and EU AI Act model registry compliance."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/DeviceDefinitionSLM"
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0]
      * name = "type"
      * type = #token
    * searchParam[1]
      * name = "manufacturer"
      * type = #string

  // ========================================================================
  // RiskAssessment — Mobility and clinical risk
  // ========================================================================
  * resource[10]
    * type = #RiskAssessment
    * documentation = "Mobility and fall risk assessments derived from wearable gait analysis data."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/MobilityRiskAssessment"
    * interaction[0].code = #read
    * interaction[1].code = #create
    * interaction[2].code = #search-type
    * searchParam[0]
      * name = "patient"
      * type = #reference
    * searchParam[1]
      * name = "date"
      * type = #date

  // ========================================================================
  // Questionnaire — Symptom and lifestyle assessment
  // ========================================================================
  * resource[11]
    * type = #Questionnaire
    * documentation = "Structured questionnaires for symptom tracking and lifestyle assessment (mindfulness, social connection, substance use)."
    * supportedProfile[0] = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/SymptomQuestionnaire"
    * interaction[0].code = #read
    * interaction[1].code = #search-type
    * searchParam[0]
      * name = "title"
      * type = #string
    * searchParam[1]
      * name = "status"
      * type = #token
