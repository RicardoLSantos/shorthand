// Sleep Quality Questionnaire based on PSQI (Pittsburgh Sleep Quality Index)
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos, FMUP
// Reference: Buysse DJ et al. The Pittsburgh Sleep Quality Index. Psychiatry Research 1989;28(2):193-213.

Instance: sleep-quality-psqi
InstanceOf: Questionnaire
Usage: #definition
Title: "Sleep Quality Questionnaire (PSQI-Based)"
Description: "Questionnaire for assessing sleep quality based on the Pittsburgh Sleep Quality Index. Measures subjective sleep quality, sleep latency, sleep duration, habitual sleep efficiency, sleep disturbances, use of sleeping medication, and daytime dysfunction over the past month."

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/sleep-quality-psqi"
* status = #active
* title = "Sleep Quality Assessment (PSQI-Based)"
* subjectType = #Patient
* version = "1.0.0"
* name = "SleepQualityPSQI"
* date = "2025-11-28"
* publisher = "FMUP HEADS Lab"
* description = "A validated questionnaire for measuring sleep quality over the past month. Based on the Pittsburgh Sleep Quality Index (PSQI) by Buysse et al. Global scores >5 indicate poor sleep quality."

// Component 1: Subjective Sleep Quality
* item[0]
  * linkId = "subjective_quality"
  * text = "Subjective Sleep Quality"
  * type = #group

  * item[0]
    * linkId = "psqi_q9"
    * text = "During the past month, how would you rate your sleep quality overall?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Very good"
    * answerOption[0].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
    * answerOption[0].extension[0].valueDecimal = 0
    * answerOption[1].valueString = "Fairly good"
    * answerOption[1].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
    * answerOption[1].extension[0].valueDecimal = 1
    * answerOption[2].valueString = "Fairly bad"
    * answerOption[2].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
    * answerOption[2].extension[0].valueDecimal = 2
    * answerOption[3].valueString = "Very bad"
    * answerOption[3].extension[0].url = "http://hl7.org/fhir/StructureDefinition/ordinalValue"
    * answerOption[3].extension[0].valueDecimal = 3

// Component 2: Sleep Latency
* item[1]
  * linkId = "sleep_latency"
  * text = "Sleep Latency"
  * type = #group

  * item[0]
    * linkId = "psqi_q2"
    * text = "During the past month, how long (in minutes) has it usually taken you to fall asleep each night?"
    * type = #integer
    * required = true
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueInteger = 0

  * item[1]
    * linkId = "psqi_q5a"
    * text = "During the past month, how often have you had trouble sleeping because you cannot get to sleep within 30 minutes?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

// Component 3: Sleep Duration
* item[2]
  * linkId = "sleep_duration"
  * text = "Sleep Duration"
  * type = #group

  * item[0]
    * linkId = "psqi_q4"
    * text = "During the past month, how many hours of actual sleep did you get at night? (This may be different than the number of hours you spend in bed.)"
    * type = #decimal
    * required = true
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueDecimal = 0

// Component 4: Habitual Sleep Efficiency
* item[3]
  * linkId = "sleep_efficiency"
  * text = "Sleep Efficiency"
  * type = #group

  * item[0]
    * linkId = "psqi_q1"
    * text = "During the past month, what time have you usually gone to bed at night?"
    * type = #time
    * required = true

  * item[1]
    * linkId = "psqi_q3"
    * text = "During the past month, what time have you usually gotten up in the morning?"
    * type = #time
    * required = true

// Component 5: Sleep Disturbances
* item[4]
  * linkId = "sleep_disturbances"
  * text = "Sleep Disturbances"
  * type = #group

  * item[0]
    * linkId = "psqi_q5b"
    * text = "How often have you had trouble sleeping because you wake up in the middle of the night or early morning?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

  * item[1]
    * linkId = "psqi_q5c"
    * text = "How often have you had trouble sleeping because you have to get up to use the bathroom?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

  * item[2]
    * linkId = "psqi_q5d"
    * text = "How often have you had trouble sleeping because you cannot breathe comfortably?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

  * item[3]
    * linkId = "psqi_q5e"
    * text = "How often have you had trouble sleeping because you cough or snore loudly?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

  * item[4]
    * linkId = "psqi_q5f"
    * text = "How often have you had trouble sleeping because you feel too cold?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

  * item[5]
    * linkId = "psqi_q5g"
    * text = "How often have you had trouble sleeping because you feel too hot?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

  * item[6]
    * linkId = "psqi_q5h"
    * text = "How often have you had trouble sleeping because you had bad dreams?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

  * item[7]
    * linkId = "psqi_q5i"
    * text = "How often have you had trouble sleeping because you have pain?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

// Component 6: Use of Sleep Medication
* item[5]
  * linkId = "sleep_medication"
  * text = "Sleep Medication Use"
  * type = #group

  * item[0]
    * linkId = "psqi_q6"
    * text = "During the past month, how often have you taken medicine (prescribed or over the counter) to help you sleep?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

// Component 7: Daytime Dysfunction
* item[6]
  * linkId = "daytime_dysfunction"
  * text = "Daytime Dysfunction"
  * type = #group

  * item[0]
    * linkId = "psqi_q7"
    * text = "During the past month, how often have you had trouble staying awake while driving, eating meals, or engaging in social activity?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "Not during the past month"
    * answerOption[1].valueString = "Less than once a week"
    * answerOption[2].valueString = "Once or twice a week"
    * answerOption[3].valueString = "Three or more times a week"

  * item[1]
    * linkId = "psqi_q8"
    * text = "During the past month, how much of a problem has it been for you to keep up enough enthusiasm to get things done?"
    * type = #choice
    * required = true
    * answerOption[0].valueString = "No problem at all"
    * answerOption[1].valueString = "Only a very slight problem"
    * answerOption[2].valueString = "Somewhat of a problem"
    * answerOption[3].valueString = "A very big problem"
