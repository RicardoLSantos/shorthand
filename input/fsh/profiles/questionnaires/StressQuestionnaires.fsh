// Stress Assessment Questionnaire based on PSS-10 (Perceived Stress Scale)
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos, FMUP
// Reference: Cohen S, Kamarck T, Mermelstein R. A global measure of perceived stress. J Health Soc Behav. 1983;24(4):385-396.

Instance: stress-assessment-pss10
InstanceOf: Questionnaire
Usage: #definition
Title: "Stress Assessment Questionnaire (PSS-10)"
Description: "The Perceived Stress Scale (PSS-10) is the most widely used psychological instrument for measuring perception of stress. It measures the degree to which situations in life are appraised as stressful during the past month."

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/stress-assessment-pss10"
* status = #active
* title = "Perceived Stress Scale (PSS-10)"
* subjectType = #Patient
* version = "1.0.0"
* name = "StressAssessmentPSS10"
* date = "2025-11-28"
* publisher = "FMUP HEADS Lab"
* description = "The PSS-10 is a validated 10-item questionnaire measuring perceived stress over the past month. Items marked with (R) are reverse scored. Scores range from 0-40, with higher scores indicating greater perceived stress. Score interpretation: 0-13 low stress, 14-26 moderate stress, 27-40 high perceived stress."

* item[0]
  * linkId = "pss_instructions"
  * text = "The questions ask about your feelings and thoughts during the last month. For each question, indicate how often you felt or thought a certain way."
  * type = #display

* item[1]
  * linkId = "pss_q1"
  * text = "In the last month, how often have you been upset because of something that happened unexpectedly?"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[0].extension[0].valueDecimal = 0
  * answerOption[1].valueString = "Almost never"
  * answerOption[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[1].extension[0].valueDecimal = 1
  * answerOption[2].valueString = "Sometimes"
  * answerOption[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[2].extension[0].valueDecimal = 2
  * answerOption[3].valueString = "Fairly often"
  * answerOption[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[3].extension[0].valueDecimal = 3
  * answerOption[4].valueString = "Very often"
  * answerOption[4].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
  * answerOption[4].extension[0].valueDecimal = 4

* item[2]
  * linkId = "pss_q2"
  * text = "In the last month, how often have you felt that you were unable to control the important things in your life?"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"

* item[3]
  * linkId = "pss_q3"
  * text = "In the last month, how often have you felt nervous and stressed?"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"

* item[4]
  * linkId = "pss_q4_r"
  * text = "In the last month, how often have you felt confident about your ability to handle your personal problems? (R)"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"

* item[5]
  * linkId = "pss_q5_r"
  * text = "In the last month, how often have you felt that things were going your way? (R)"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"

* item[6]
  * linkId = "pss_q6"
  * text = "In the last month, how often have you found that you could not cope with all the things that you had to do?"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"

* item[7]
  * linkId = "pss_q7_r"
  * text = "In the last month, how often have you been able to control irritations in your life? (R)"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"

* item[8]
  * linkId = "pss_q8_r"
  * text = "In the last month, how often have you felt that you were on top of things? (R)"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"

* item[9]
  * linkId = "pss_q9"
  * text = "In the last month, how often have you been angered because of things that happened that were outside of your control?"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"

* item[10]
  * linkId = "pss_q10"
  * text = "In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?"
  * type = #choice
  * required = true
  * answerOption[0].valueString = "Never"
  * answerOption[1].valueString = "Almost never"
  * answerOption[2].valueString = "Sometimes"
  * answerOption[3].valueString = "Fairly often"
  * answerOption[4].valueString = "Very often"
