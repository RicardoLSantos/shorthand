// Fatigue Assessment Questionnaire based on FSS (Fatigue Severity Scale)
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos, FMUP
// Reference: Krupp LB et al. The Fatigue Severity Scale: Application to patients with multiple sclerosis and systemic lupus erythematosus. Arch Neurol. 1989;46(10):1121-1123.

Instance: fatigue-assessment-fss
InstanceOf: Questionnaire
Usage: #definition
Title: "Fatigue Assessment Questionnaire (FSS)"
Description: "The Fatigue Severity Scale (FSS) is a self-report scale that measures the severity of fatigue and its effect on activities and lifestyle. It is widely used in clinical research for various conditions including chronic fatigue syndrome, multiple sclerosis, and systemic lupus erythematosus."

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/fatigue-assessment-fss"
* status = #active
* title = "Fatigue Severity Scale (FSS)"
* subjectType = #Patient
* version = "1.0.0"
* name = "FatigueAssessmentFSS"
* date = "2025-11-28"
* publisher = "FMUP HEADS Lab"
* description = "The FSS is a 9-item validated questionnaire measuring the impact of fatigue. Each item is rated 1-7 where 1=strongly disagree and 7=strongly agree. The mean of all 9 items yields the FSS score. A score of 4 or higher generally indicates significant fatigue. For comparison: healthy controls typically score around 2.3, while patients with fatigue-related conditions score 4.7 or higher."

* item[0]
  * linkId = "fss_instructions"
  * text = "Choose a number from 1 to 7 that indicates your degree of agreement with each statement, where 1 = strongly disagree and 7 = strongly agree. Please answer these questions as they apply to the past week."
  * type = #display

* item[1]
  * linkId = "fss_q1"
  * text = "My motivation is lower when I am fatigued."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[0].extension[0].valueDecimal = 1
  * answerOption[1].valueString = "2"
  * answerOption[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[1].extension[0].valueDecimal = 2
  * answerOption[2].valueString = "3"
  * answerOption[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[2].extension[0].valueDecimal = 3
  * answerOption[3].valueString = "4"
  * answerOption[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[3].extension[0].valueDecimal = 4
  * answerOption[4].valueString = "5"
  * answerOption[4].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[4].extension[0].valueDecimal = 5
  * answerOption[5].valueString = "6"
  * answerOption[5].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[5].extension[0].valueDecimal = 6
  * answerOption[6].valueString = "7 - Strongly agree"
  * answerOption[6].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[6].extension[0].valueDecimal = 7

* item[2]
  * linkId = "fss_q2"
  * text = "Exercise brings on my fatigue."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[1].valueString = "2"
  * answerOption[2].valueString = "3"
  * answerOption[3].valueString = "4"
  * answerOption[4].valueString = "5"
  * answerOption[5].valueString = "6"
  * answerOption[6].valueString = "7 - Strongly agree"

* item[3]
  * linkId = "fss_q3"
  * text = "I am easily fatigued."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[1].valueString = "2"
  * answerOption[2].valueString = "3"
  * answerOption[3].valueString = "4"
  * answerOption[4].valueString = "5"
  * answerOption[5].valueString = "6"
  * answerOption[6].valueString = "7 - Strongly agree"

* item[4]
  * linkId = "fss_q4"
  * text = "Fatigue interferes with my physical functioning."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[1].valueString = "2"
  * answerOption[2].valueString = "3"
  * answerOption[3].valueString = "4"
  * answerOption[4].valueString = "5"
  * answerOption[5].valueString = "6"
  * answerOption[6].valueString = "7 - Strongly agree"

* item[5]
  * linkId = "fss_q5"
  * text = "Fatigue causes frequent problems for me."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[1].valueString = "2"
  * answerOption[2].valueString = "3"
  * answerOption[3].valueString = "4"
  * answerOption[4].valueString = "5"
  * answerOption[5].valueString = "6"
  * answerOption[6].valueString = "7 - Strongly agree"

* item[6]
  * linkId = "fss_q6"
  * text = "My fatigue prevents sustained physical functioning."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[1].valueString = "2"
  * answerOption[2].valueString = "3"
  * answerOption[3].valueString = "4"
  * answerOption[4].valueString = "5"
  * answerOption[5].valueString = "6"
  * answerOption[6].valueString = "7 - Strongly agree"

* item[7]
  * linkId = "fss_q7"
  * text = "Fatigue interferes with carrying out certain duties and responsibilities."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[1].valueString = "2"
  * answerOption[2].valueString = "3"
  * answerOption[3].valueString = "4"
  * answerOption[4].valueString = "5"
  * answerOption[5].valueString = "6"
  * answerOption[6].valueString = "7 - Strongly agree"

* item[8]
  * linkId = "fss_q8"
  * text = "Fatigue is among my three most disabling symptoms."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[1].valueString = "2"
  * answerOption[2].valueString = "3"
  * answerOption[3].valueString = "4"
  * answerOption[4].valueString = "5"
  * answerOption[5].valueString = "6"
  * answerOption[6].valueString = "7 - Strongly agree"

* item[9]
  * linkId = "fss_q9"
  * text = "Fatigue interferes with my work, family, or social life."
  * type = #choice
  * required = true
  * answerOption[0].valueString = "1 - Strongly disagree"
  * answerOption[1].valueString = "2"
  * answerOption[2].valueString = "3"
  * answerOption[3].valueString = "4"
  * answerOption[4].valueString = "5"
  * answerOption[5].valueString = "6"
  * answerOption[6].valueString = "7 - Strongly agree"

// Score interpretation
* item[10]
  * linkId = "fss_interpretation"
  * text = "FSS Score Interpretation"
  * type = #group

  * item[0]
    * linkId = "fss_mean_score"
    * text = "Mean FSS Score (auto-calculated)"
    * type = #decimal
    * readOnly = true

  * item[1]
    * linkId = "fss_interpretation_text"
    * text = "Interpretation: FSS score < 4 = Normal fatigue level; FSS score >= 4 = Significant fatigue requiring clinical attention"
    * type = #display
