// Physical Activity Questionnaire based on IPAQ-Short Form
// Created: 2025-11-28
// Author: Ricardo Lourenco dos Santos, FMUP
// Reference: Craig CL et al. International Physical Activity Questionnaire: 12-country reliability and validity. Med Sci Sports Exerc. 2003;35(8):1381-1395.

Instance: physical-activity-ipaq-short
InstanceOf: Questionnaire
Usage: #definition
Title: "Physical Activity Questionnaire (IPAQ-Short)"
Description: "The International Physical Activity Questionnaire (IPAQ) Short Form measures health-related physical activity over the last 7 days. It assesses vigorous and moderate physical activities, walking, and sitting time."

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/Questionnaire/physical-activity-ipaq-short"
* status = #active
* title = "International Physical Activity Questionnaire - Short Form"
* subjectType = #Patient
* version = "1.0.0"
* name = "PhysicalActivityIPAQShort"
* date = "2025-11-28"
* publisher = "FMUP HEADS Lab"
* description = "IPAQ-Short Form is a validated 7-item questionnaire measuring physical activity over the past 7 days. Results can be reported as categorical (low, moderate, high activity) or as MET-minutes/week. MET values: Walking=3.3, Moderate PA=4.0, Vigorous PA=8.0. Total MET-min/week = sum of Walking + Moderate + Vigorous MET-min/week."

* item[0]
  * linkId = "ipaq_instructions"
  * text = "We are interested in finding out about the kinds of physical activities that people do as part of their everyday lives. The questions will ask you about the time you spent being physically active in the last 7 days. Please think about the activities you do at work, as part of your house and yard work, to get from place to place, and in your spare time for recreation, exercise or sport."
  * type = #display

// Vigorous Physical Activity
* item[1]
  * linkId = "vigorous_activity"
  * text = "Vigorous Physical Activities"
  * type = #group

  * item[0]
    * linkId = "ipaq_vigorous_intro"
    * text = "Think about all the vigorous activities that you did in the last 7 days. Vigorous physical activities refer to activities that take hard physical effort and make you breathe much harder than normal. Think only about those physical activities that you did for at least 10 minutes at a time."
    * type = #display

  * item[1]
    * linkId = "ipaq_q1_days"
    * text = "During the last 7 days, on how many days did you do vigorous physical activities like heavy lifting, digging, aerobics, or fast bicycling?"
    * type = #integer
    * required = true
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueInteger = 0
    * extension[1].url = "http://hl7.org/fhir/StructureDefinition/maxValue"
    * extension[1].valueInteger = 7

  * item[2]
    * linkId = "ipaq_q2_time"
    * text = "How much time did you usually spend doing vigorous physical activities on one of those days? (minutes)"
    * type = #integer
    * required = false
    * enableWhen[0].question = "ipaq_q1_days"
    * enableWhen[0].operator = #>
    * enableWhen[0].answerInteger = 0
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueInteger = 0

// Moderate Physical Activity
* item[2]
  * linkId = "moderate_activity"
  * text = "Moderate Physical Activities"
  * type = #group

  * item[0]
    * linkId = "ipaq_moderate_intro"
    * text = "Think about all the moderate activities that you did in the last 7 days. Moderate activities refer to activities that take moderate physical effort and make you breathe somewhat harder than normal. Think only about those physical activities that you did for at least 10 minutes at a time."
    * type = #display

  * item[1]
    * linkId = "ipaq_q3_days"
    * text = "During the last 7 days, on how many days did you do moderate physical activities like carrying light loads, bicycling at a regular pace, or doubles tennis? Do not include walking."
    * type = #integer
    * required = true
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueInteger = 0
    * extension[1].url = "http://hl7.org/fhir/StructureDefinition/maxValue"
    * extension[1].valueInteger = 7

  * item[2]
    * linkId = "ipaq_q4_time"
    * text = "How much time did you usually spend doing moderate physical activities on one of those days? (minutes)"
    * type = #integer
    * required = false
    * enableWhen[0].question = "ipaq_q3_days"
    * enableWhen[0].operator = #>
    * enableWhen[0].answerInteger = 0
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueInteger = 0

// Walking
* item[3]
  * linkId = "walking_activity"
  * text = "Walking"
  * type = #group

  * item[0]
    * linkId = "ipaq_walking_intro"
    * text = "Think about the time you spent walking in the last 7 days. This includes at work and at home, walking to travel from place to place, and any other walking that you have done solely for recreation, sport, exercise, or leisure."
    * type = #display

  * item[1]
    * linkId = "ipaq_q5_days"
    * text = "During the last 7 days, on how many days did you walk for at least 10 minutes at a time?"
    * type = #integer
    * required = true
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueInteger = 0
    * extension[1].url = "http://hl7.org/fhir/StructureDefinition/maxValue"
    * extension[1].valueInteger = 7

  * item[2]
    * linkId = "ipaq_q6_time"
    * text = "How much time did you usually spend walking on one of those days? (minutes)"
    * type = #integer
    * required = false
    * enableWhen[0].question = "ipaq_q5_days"
    * enableWhen[0].operator = #>
    * enableWhen[0].answerInteger = 0
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueInteger = 0

// Sitting Time
* item[4]
  * linkId = "sitting_time"
  * text = "Sitting Time"
  * type = #group

  * item[0]
    * linkId = "ipaq_sitting_intro"
    * text = "The last question is about the time you spent sitting on weekdays during the last 7 days. Include time spent at work, at home, while doing course work and during leisure time. This may include time spent sitting at a desk, visiting friends, reading, or sitting or lying down to watch television."
    * type = #display

  * item[1]
    * linkId = "ipaq_q7_sitting"
    * text = "During the last 7 days, how much time did you spend sitting on a week day? (hours)"
    * type = #decimal
    * required = true
    * extension[0].url = "http://hl7.org/fhir/StructureDefinition/minValue"
    * extension[0].valueDecimal = 0

// Classification
* item[5]
  * linkId = "activity_classification"
  * text = "Physical Activity Classification"
  * type = #group

  * item[0]
    * linkId = "calculated_category"
    * text = "Calculated physical activity category (auto-populated based on responses)"
    * type = #choice
    * readOnly = true
    * answerOption[0].valueString = "Low - Inactive"
    * answerOption[1].valueString = "Moderate - Minimally active"
    * answerOption[2].valueString = "High - HEPA active"
