// AgentPlanDefinitionProfile.fsh
// Created: 2026-01-25
// Purpose: PlanDefinition profile for LLM agent decision logic
// Based on: MedAgentBench framework (Saha et al. 2026)
//
// Captures the decision logic that agents use to generate recommendations.
// Supports explainability requirements (EU AI Act, FDA AI/ML guidance).

Profile: AgentPlanDefinition
Parent: PlanDefinition
Id: agent-plan-definition
Title: "Agent Plan Definition Profile"
Description: "Profile for plan definitions that encode LLM agent decision logic. Supports documentation of clinical decision rules, trigger conditions, and recommended actions for regulatory compliance and transparency."

* ^experimental = false

// URL for canonical reference
* url 1..1 MS
  * ^short = "Canonical URL for this plan definition"

// Identifiers
* identifier 0..* MS

// Version
* version 1..1 MS
  * ^short = "Business version"

// Name (machine-friendly)
* name 1..1 MS
  * ^short = "Machine-friendly name"

// Title (human-friendly)
* title 1..1 MS
  * ^short = "Human-friendly title"

// Subtitle
* subtitle 0..1 MS
  * ^short = "Additional descriptive subtitle"

// Type - must be clinical-protocol or eca-rule
* type 1..1 MS
* type from AgentPlanDefinitionTypeVS (required)
  * ^short = "clinical-protocol | eca-rule | workflow-definition"

// Status
* status 1..1 MS
  * ^short = "draft | active | retired | unknown"

// Experimental flag
* experimental 0..1 MS
  * ^short = "For testing purposes only"

// Subject - patient or group
* subject[x] 0..1 MS

// Date
* date 1..1 MS
  * ^short = "Last revision date"

// Publisher - organization maintaining the logic
* publisher 0..1 MS
  * ^short = "Organization maintaining this logic"

// Contact
* contact 0..* MS

// Description - full description of the decision logic
* description 1..1 MS
  * ^short = "Full description of decision logic"

// Use context - clinical context where applicable
* useContext 0..* MS
  * ^short = "Clinical contexts where this applies"

// Jurisdiction
* jurisdiction 0..* MS

// Purpose - clinical/regulatory purpose
* purpose 0..1 MS
  * ^short = "Why this logic was defined"

// Usage - how to use
* usage 0..1 MS
  * ^short = "How to use this plan definition"

// Copyright
* copyright 0..1 MS

// Approval/review dates
* approvalDate 0..1 MS
* lastReviewDate 0..1 MS

// Effective period
* effectivePeriod 0..1 MS

// Topic - categorization
* topic 0..* MS
* topic from AgentDecisionTopicVS (preferred)
  * ^short = "Categories of decision logic"

// Author
* author 0..* MS
  * ^short = "Authors of the decision logic"

// Editor
* editor 0..* MS

// Reviewer
* reviewer 0..* MS

// Endorser
* endorser 0..* MS

// Related artifacts - evidence, guidelines
* relatedArtifact 0..* MS
  * ^short = "Supporting evidence and guidelines"

// Library - reference to CQL or other logic
* library 0..* MS
  * ^short = "Logic library references"

// Goal - clinical goals
* goal 0..* MS
  * ^short = "Clinical goals this plan addresses"

// Action - the decision actions
* action 1..* MS
  * ^short = "Decision actions and conditions"

  // Action prefix
  * prefix 0..1 MS

  // Action title
  * title 1..1 MS
    * ^short = "Action title"

  // Action description
  * description 0..1 MS
    * ^short = "Action description"

  // Text equivalent
  * textEquivalent 0..1 MS
    * ^short = "Human-readable action description"

  // Priority
  * priority 0..1 MS
    * ^short = "Action priority"

  // Code - what type of action
  * code 0..* MS
    * ^short = "Action type codes"

  // Reason
  * reason 0..* MS
    * ^short = "Clinical reasons for action"

  // Documentation
  * documentation 0..* MS
    * ^short = "Supporting documentation"

  // Goal ID reference
  * goalId 0..* MS

  // Subject
  * subject[x] 0..1 MS

  // Trigger - when to invoke
  * trigger 0..* MS
    * ^short = "Trigger conditions"

  // Condition - applicability conditions
  * condition 0..* MS
    * ^short = "Applicability conditions"
    * kind MS
    * expression MS

  // Input - required data
  * input 0..* MS
    * ^short = "Required input data"

  // Output - produced data
  * output 0..* MS
    * ^short = "Output data definitions"

  // Related action
  * relatedAction 0..* MS

  // Timing
  * timing[x] 0..1 MS

  // Participant - who performs
  * participant 0..* MS

  // Type - create | update | remove | fire-event
  * type 0..1 MS

  // Grouping behavior
  * groupingBehavior 0..1 MS

  // Selection behavior
  * selectionBehavior 0..1 MS

  // Required behavior
  * requiredBehavior 0..1 MS

  // Precheck behavior
  * precheckBehavior 0..1 MS

  // Cardinality behavior
  * cardinalityBehavior 0..1 MS

  // Definition - reference to ActivityDefinition
  * definition[x] 0..1 MS

  // Transform - structure map
  * transform 0..1 MS

  // Dynamic values
  * dynamicValue 0..* MS
    * ^short = "Dynamic values for the action"

  // Nested actions
  * action 0..* MS

// ============================================================================
// ValueSets
// ============================================================================

ValueSet: AgentPlanDefinitionTypeVS
Id: agent-plan-definition-type-vs
Title: "Agent Plan Definition Type ValueSet"
Description: "Types of plan definitions for agent decision logic"
* ^experimental = false
* http://terminology.hl7.org/CodeSystem/plan-definition-type#clinical-protocol "Clinical Protocol"
* http://terminology.hl7.org/CodeSystem/plan-definition-type#eca-rule "ECA Rule"
* http://terminology.hl7.org/CodeSystem/plan-definition-type#workflow-definition "Workflow Definition"

// ============================================================================
// CodeSystems
// ============================================================================

CodeSystem: AgentDecisionTopicCS
Id: agent-decision-topic-cs
Title: "Agent Decision Topic CodeSystem"
Description: "Topics/categories for agent decision logic"
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
// Risk assessment topics
* #cardiovascular-risk "Cardiovascular Risk" "Cardiovascular risk assessment logic"
* #metabolic-risk "Metabolic Risk" "Metabolic/diabetes risk assessment"
* #mental-health-risk "Mental Health Risk" "Mental health risk assessment"
* #fall-risk "Fall Risk" "Fall risk assessment"
// Monitoring topics
* #vital-signs-monitoring "Vital Signs Monitoring" "Vital signs monitoring logic"
* #activity-monitoring "Activity Monitoring" "Physical activity monitoring"
* #sleep-monitoring "Sleep Monitoring" "Sleep pattern monitoring"
* #hrv-monitoring "HRV Monitoring" "Heart rate variability monitoring"
// Intervention topics
* #lifestyle-intervention "Lifestyle Intervention" "Lifestyle modification recommendations"
* #medication-optimization "Medication Optimization" "Medication optimization logic"
* #preventive-care "Preventive Care" "Preventive care recommendations"
// Alert topics
* #abnormal-value-alert "Abnormal Value Alert" "Alerting on abnormal values"
* #trend-alert "Trend Alert" "Alerting on concerning trends"
* #threshold-alert "Threshold Alert" "Threshold-based alerting"

ValueSet: AgentDecisionTopicVS
Id: agent-decision-topic-vs
Title: "Agent Decision Topic ValueSet"
* ^experimental = false
* include codes from system AgentDecisionTopicCS

// ============================================================================
// Example Instance
// ============================================================================

Instance: AgentHRVRiskAssessmentPlan
InstanceOf: AgentPlanDefinition
Usage: #example
Title: "Agent HRV Risk Assessment Plan Definition"
Description: "Example plan definition for agent-based HRV risk assessment"

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/PlanDefinition/agent-hrv-risk-assessment"
* version = "1.0.0"
* name = "AgentHRVRiskAssessment"
* title = "Agent HRV Risk Assessment Decision Logic"
* type = http://terminology.hl7.org/CodeSystem/plan-definition-type#eca-rule
* status = #draft
* experimental = true
* date = "2026-01-25"
* publisher = "FMUP HEADS2 Project"
* description = "Decision logic for LLM agent assessment of HRV data for cardiovascular risk stratification. Uses RMSSD thresholds from Shaffer & Ginsberg 2017."

* topic[0] = AgentDecisionTopicCS#hrv-monitoring "HRV Monitoring"
* topic[1] = AgentDecisionTopicCS#cardiovascular-risk "Cardiovascular Risk"

* action[0]
  * title = "Evaluate HRV RMSSD Value"
  * description = "Assess RMSSD value against clinical thresholds"
  * condition[0]
    * kind = #applicability
    * expression
      * language = #text/cql
      * expression = "RMSSD observation is available"
  * action[0]
    * title = "Low RMSSD Alert"
    * description = "Generate alert if RMSSD < 20ms"
    * condition[0]
      * kind = #applicability
      * expression
        * language = #text/cql
        * expression = "RMSSD < 20"
  * action[1]
    * title = "Normal RMSSD"
    * description = "No action if RMSSD 20-50ms"
    * condition[0]
      * kind = #applicability
      * expression
        * language = #text/cql
        * expression = "RMSSD >= 20 and RMSSD <= 50"
