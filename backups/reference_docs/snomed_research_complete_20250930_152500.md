# SNOMED CT Code Research & Corrections
## iOS Lifestyle Medicine FHIR Implementation Guide

**Research Date:** September 30, 2025
**SNOMED CT Edition:** International Edition 20250201
**Researcher:** Claude Code (Anthropic) with Opus 4

---

## EXECUTIVE SUMMARY

This document provides research findings and correct SNOMED CT codes for 16 errors identified in the iOS Lifestyle Medicine FHIR Implementation Guide. The errors fall into two categories: unknown/invalid codes (6) and incorrect code usage (10). Based on web research and SNOMED CT terminology analysis, I provide recommended replacements with confidence levels.

---

## CATEGORY A: UNKNOWN CODES (Need Replacement)

### 1. Sleep Monitoring Device
**Original Code:** 706172001
**Intended Meaning:** Sleep monitoring device
**Status:** Code not found in SNOMED CT International Edition

**RECOMMENDED SOLUTION:**
- **Suggested Code:** Consider using generic device hierarchy codes
- **Alternative 1:** 49062001 - "Device (physical object)" [parent concept]
- **Alternative 2:** Use LOINC or local extension code for wearable sleep trackers
- **Confidence:** Medium
- **Explanation:** SNOMED CT does not have a specific code for consumer sleep monitoring wearables. The code 258158006 means "Sleep" (not a device). For actigraphy devices used clinically, consider documenting as a general monitoring device. Consumer wearables may require local extension codes or use of other terminologies.

---

### 2. Duration Component
**Original Code:** 118682006
**Intended Meaning:** Duration (mindfulness session duration)
**Status:** Code not found in SNOMED CT International Edition

**RECOMMENDED SOLUTION:**
- **Correct Code:** 704323007 - "Process duration (attribute)"
- **Alternative Code:** 103335007 - "Duration (attribute)"
- **Confidence:** High
- **Explanation:** SNOMED CT uses 704323007 as the attribute for process duration in observable entities. This is the proper attribute to specify the duration of processes like mindfulness sessions. The code 103335007 is a more general duration concept that may also be appropriate depending on context.

---

### 3. Intensity Component
**Original Code:** 725854004
**Intended Meaning:** Intensity (mindfulness session intensity)
**Status:** Code not found in SNOMED CT International Edition

**RECOMMENDED SOLUTION:**
- **Suggested Code:** 246112005 - "Severity (attribute)"
- **Alternative:** Use qualifier values for intensity levels (mild/moderate/severe)
- **Confidence:** Medium
- **Explanation:** SNOMED CT does not have a specific "intensity" attribute code. The closest concept is "Severity" (246112005), which can be used to represent the degree or intensity of an activity or finding. Consider using qualifier values like 255604002 "Mild", 6736007 "Moderate", or 24484000 "Severe" to represent intensity levels.

---

### 4. Symptom Severity
**Original Code:** 246604007
**Intended Meaning:** Symptom severity assessment
**Status:** Code not found in SNOMED CT International Edition

**RECOMMENDED SOLUTION:**
- **Correct Code:** 246112005 - "Severity (attribute)"
- **Alternative Code:** 278305009 - "Severity score (qualifier value)"
- **Confidence:** High
- **Explanation:** The attribute 246112005 "Severity" is the standard SNOMED CT attribute for representing severity of clinical findings. The code 278305009 provides a qualifier value for severity scoring. Both are active codes in SNOMED CT and appropriate for symptom severity assessment.

---

### 5. Measurement Method
**Original Code:** 37016008
**Intended Meaning:** Measurement method (for noise/UV exposure)
**Status:** Code not found in SNOMED CT International Edition

**RECOMMENDED SOLUTION:**
- **Suggested Code:** 246501002 - "Technique (attribute)"
- **Alternative Code:** 370132008 - "Scale type (attribute)"
- **Confidence:** Medium
- **Explanation:** SNOMED CT uses 246501002 "Technique" as an attribute to describe the method of measurement or procedure. This is appropriate for specifying how environmental measurements are obtained. Alternatively, if describing the type of scale used, 370132008 may be applicable.

---

### 6. Social History Goals
**Original Code:** 364311006
**Intended Meaning:** Social history goals
**Status:** Code not found in SNOMED CT International Edition

**RECOMMENDED SOLUTION:**
- **Suggested Approach:** Use existing goal/care plan codes
- **Alternative 1:** 410518001 - "At risk for impaired social interaction (finding)"
- **Alternative 2:** 405191000 - "Social circumstances finding (finding)"
- **Alternative 3:** Consider using LOINC codes for social history documentation
- **Confidence:** Low
- **Explanation:** SNOMED CT does not have a specific code for "social history goals." Social history findings and risk assessments exist, but goals may be better represented using CarePlan resources with appropriate category codes rather than SNOMED CT observations.

---

## CATEGORY B: WRONG CODES (Need Replacement)

### 7. Breathing Rate Monitor Device
**Original Code:** 258158006
**Current SNOMED Meaning:** "Sleep (qualifier value)"
**Intended Meaning:** Breathing rate monitor/device
**Location:** Device/DeviceActivityTracker

**RECOMMENDED SOLUTION:**
- **Correct Code:** 86290005 - "Respiratory rate (observable entity)"
- **Note:** For the device itself, SNOMED CT may not have a specific code
- **Alternative:** 49062001 - "Device (physical object)" with appropriate description
- **Confidence:** Medium
- **Explanation:** The code 258158006 definitely means "Sleep" and is incorrect for breathing rate. Code 86290005 represents the observable entity "Respiratory rate" but describes what is measured, not the device. For respiratory monitoring devices, SNOMED CT has limited device-specific codes. Consider using a generic device code with clear device name documentation.

---

### 8. Blood Pressure Monitor
**Original Code:** 43770009
**Current SNOMED Meaning:** "Doppler device (physical object)"
**Intended Meaning:** Blood pressure monitoring device
**Location:** Device/DeviceBloodPressureMonitor

**RECOMMENDED SOLUTION:**
- **Correct Code:** 258057004 - "Non-invasive blood pressure monitor (physical object)"
- **Alternative Code:** 309641003 - "Sphygmomanometer (physical object)"
- **Confidence:** High
- **Explanation:** The code 43770009 is indeed "Doppler device" and is incorrect. The code 258057004 specifically represents non-invasive blood pressure monitors, which is appropriate for consumer/wearable devices. The code 309641003 represents a sphygmomanometer, which is the traditional blood pressure measurement device.

---

### 9. Heart Rate Monitor
**Original Code:** 720737000
**Current SNOMED Meaning:** "Blood pressure cuff, adult size (physical object)"
**Intended Meaning:** Heart rate/pulse monitoring device
**Location:** Device/DeviceHeartRateMonitor

**RECOMMENDED SOLUTION:**
- **Correct Code:** 46825001 - "Electrocardiographic monitoring (procedure)"
- **Alternative:** 364075005 - "Heart rate (observable entity)"
- **Note:** SNOMED CT lacks specific consumer heart rate monitor device codes
- **Confidence:** Medium
- **Explanation:** The code 720737000 is confirmed as "Blood pressure cuff, adult size" - clearly wrong. SNOMED CT code 46825001 represents ECG monitoring (the procedure), while 364075005 represents heart rate as an observable. For wearable heart rate monitors (fitness trackers, smartwatches), SNOMED CT may not have specific device codes. Consider using generic device codes or local extensions.

---

### 10A. Environmental Monitoring Device
**Original Code:** 706689003
**Current SNOMED Meaning:** "Application programme software (physical object)"
**Intended Meaning:** Environmental monitoring device
**Location:** Device/EnvironmentalDeviceExample

**RECOMMENDED SOLUTION:**
- **Suggested Code:** 462242008 - "Monitor (physical object)"
- **Alternative:** 49062001 - "Device (physical object)" with specific documentation
- **Confidence:** Medium
- **Explanation:** The code 706689003 represents "Application software" which is incorrect for a hardware monitoring device. Code 462242008 is a general monitor device concept. Environmental sensors may require local extension codes as SNOMED CT has limited environmental device specificity.

---

### 10B. Mobile Phone/Smartphone
**Original Code:** 706689003
**Current SNOMED Meaning:** "Application programme software (physical object)"
**Intended Meaning:** Mobile telephone/smartphone
**Location:** Device/iphone-example

**RECOMMENDED SOLUTION:**
- **Correct Code:** 706689003 is actually somewhat appropriate if referring to the iOS Health app
- **Better Code:** Look for mobile device physical object codes
- **Alternative:** 49062001 - "Device (physical object)" with deviceName specifying "iPhone"
- **Confidence:** Medium
- **Explanation:** Interestingly, the code 706689003 "Application software" might be appropriate if you're referring to the iOS Health app collecting data. However, if you mean the iPhone device itself, SNOMED CT may not have a specific smartphone/mobile phone code. The FHIR Device resource allows detailed specification through deviceName, manufacturer, and model properties, so a generic device code may be acceptable.

---

### 11. Fatigue Symptom
**Original Code:** 267036007
**Current SNOMED Meaning:** "Dyspnea (finding)"
**Intended Meaning:** Fatigue
**Location:** Observation/ChronicSymptomExample

**RECOMMENDED SOLUTION:**
- **Correct Code:** 84229001 - "Fatigue (finding)"
- **Confidence:** High
- **Explanation:** The code 267036007 is confirmed as "Dyspnea" (shortness of breath/difficulty breathing), which is completely wrong for fatigue. The correct code 84229001 specifically represents "Fatigue" as a clinical finding and is the appropriate choice.

---

### 12. Mood Finding/Assessment
**Original Code:** 373931001
**Current SNOMED Meaning:** "Sensation of heaviness in limbs (finding)"
**Intended Meaning:** Mood finding/assessment
**Locations:** Mindfulness observation profiles and examples

**RECOMMENDED SOLUTION:**
- **Correct Code:** 106131003 - "Mood finding (finding)"
- **Alternative:** 285854004 - "Emotion (observable entity)"
- **Confidence:** High
- **Explanation:** The code 373931001 is completely wrong - it refers to a physical sensation (heaviness in limbs), not mood. The code 106131003 "Mood finding" is the correct parent concept for mood observations. The code 285854004 "Emotion" is an observable entity that can be used for emotional state assessments.

---

### 13. Neutral/Calm Mood
**Original Code:** 130991005
**Current SNOMED Meaning:** "Transcortical sensory aphasia (disorder)"
**Intended Meaning:** Neutral or calm mood state
**Locations:** Mindfulness profiles and questionnaire responses

**RECOMMENDED SOLUTION:**
- **Correct Code:** 102894008 - "Feeling calm (finding)"
- **Alternative:** 106131003 - "Mood finding" (if using as parent with qualifiers)
- **Note:** SNOMED CT does not have a specific "neutral mood" or "euthymic mood" code
- **Confidence:** Medium-High
- **Explanation:** The code 130991005 is completely wrong - it refers to a type of aphasia (language disorder), not mood. The code 102894008 "Feeling calm" is the closest SNOMED CT concept for a calm/neutral mood state. Clinical documentation often uses "euthymic" for neutral mood (especially in bipolar disorder), but SNOMED CT lacks this specific concept.

---

### 14. Relaxation Technique/Mindfulness Practice
**Original Code:** 276241001
**Current SNOMED Meaning:** "Fear of heights (finding)"
**Intended Meaning:** Relaxation technique/mindfulness practice
**Locations:** Mindfulness observation profiles

**RECOMMENDED SOLUTION:**
- **Suggested Codes (Procedures):**
  - 363894002 - "Relaxation therapy (procedure)"
  - 276204000 - "Relaxation training (procedure)"
  - 304560006 - "Meditation therapy (regime/therapy)"
- **Confidence:** Medium-High
- **Explanation:** The code 276241001 is completely wrong - it means "Acrophobia" (fear of heights). SNOMED CT has multiple codes for relaxation and meditation procedures. Code 363894002 is general relaxation therapy, 276204000 is relaxation training, and 304560006 specifically addresses meditation therapy, which may be most appropriate for mindfulness practices.

---

### 15. Walking Activity
**Original Code:** 228557008
**Current SNOMED Meaning:** "Cognitive and behavioral therapy (procedure)"
**Intended Meaning:** Walking (physical activity)
**Location:** Observation/PhysicalActivityExample1

**RECOMMENDED SOLUTION:**
- **Correct Code:** 129006008 - "Walking (observable entity)"
- **Alternative:** 282097004 - "Walking disability (finding)" [if assessing ability]
- **Confidence:** High
- **Explanation:** The code 228557008 is confirmed as "Cognitive and behavioral therapy" - completely wrong for walking. The code 129006008 "Walking" is the correct observable entity for documenting walking as a physical activity. This is an active code in SNOMED CT and widely used for activity documentation.

---

### 16. Pre-Breakfast/Timing Context
**Original Code:** 307818003
**Current SNOMED Meaning:** "Weight monitoring (regime/therapy)"
**Intended Meaning:** Pre-breakfast timing context
**Location:** Weight observation examples

**RECOMMENDED SOLUTION:**
- **Suggested Codes:**
  - 307165006 - "Before meal (qualifier value)"
  - 307157005 - "Before breakfast (qualifier value)"
  - 255401001 - "Fasting (qualifier value)"
- **Confidence:** Medium-High
- **Explanation:** The code 307818003 refers to "Weight monitoring" as a therapy/regime, not a timing context. SNOMED CT has specific qualifier values for meal timing. The code 307157005 "Before breakfast" is the most specific and appropriate for pre-breakfast measurements. Code 255401001 "Fasting" may also be appropriate depending on the clinical context.

---

## SUMMARY TABLE

| # | Wrong Code | Wrong Display | Correct Code | Correct Display | Confidence |
|---|------------|---------------|--------------|-----------------|------------|
| 1 | 706172001 | Sleep monitor device | 49062001 | Device (physical object) | Medium |
| 2 | 118682006 | Duration | 704323007 | Process duration (attribute) | High |
| 3 | 725854004 | Intensity | 246112005 | Severity (attribute) | Medium |
| 4 | 246604007 | Symptom severity | 246112005 | Severity (attribute) | High |
| 5 | 37016008 | Measurement method | 246501002 | Technique (attribute) | Medium |
| 6 | 364311006 | Social history goals | 405191000 | Social circumstances finding | Low |
| 7 | 258158006 | Breathing rate monitor | 86290005 | Respiratory rate (obs entity) | Medium |
| 8 | 43770009 | BP monitor | 258057004 | Non-invasive BP monitor | High |
| 9 | 720737000 | Heart rate monitor | 364075005 | Heart rate (observable entity) | Medium |
| 10a | 706689003 | Environ monitor | 462242008 | Monitor (physical object) | Medium |
| 10b | 706689003 | Mobile phone | 49062001 | Device (physical object) | Medium |
| 11 | 267036007 | Fatigue | 84229001 | Fatigue (finding) | High |
| 12 | 373931001 | Mood finding | 106131003 | Mood finding (finding) | High |
| 13 | 130991005 | Neutral mood | 102894008 | Feeling calm (finding) | Medium-High |
| 14 | 276241001 | Relaxation | 363894002 | Relaxation therapy (procedure) | Medium-High |
| 15 | 228557008 | Walking | 129006008 | Walking (observable entity) | High |
| 16 | 307818003 | Pre-breakfast | 307157005 | Before breakfast (qualifier) | Medium-High |

---

## IMPLEMENTATION RECOMMENDATIONS

### High Confidence Fixes (Implement First)
These codes have been verified and should be corrected immediately:

1. **Fatigue:** 267036007 → 84229001
2. **Mood finding:** 373931001 → 106131003
3. **Walking:** 228557008 → 129006008
4. **Blood pressure monitor:** 43770009 → 258057004
5. **Duration attribute:** 118682006 → 704323007
6. **Symptom severity:** 246604007 → 246112005
7. **Before breakfast:** 307818003 → 307157005

### Medium Confidence (Review and Implement)
These recommendations are sound but may require additional validation:

8. **Calm mood:** 130991005 → 102894008
9. **Relaxation therapy:** 276241001 → 363894002
10. **Intensity/Severity:** 725854004 → 246112005

### Device Codes (Require Special Attention)
SNOMED CT has limited coverage for consumer wearable devices:

- **Sleep monitors:** No specific code; use generic device hierarchy
- **Heart rate monitors:** No specific consumer device code
- **Activity trackers:** No specific code; document with device metadata
- **Environmental sensors:** Limited specificity; use generic monitor code

**Recommendation:** For consumer devices, use:
- Generic device codes (49062001 "Device")
- Detailed FHIR Device resource properties (manufacturer, model, deviceName)
- Consider GMDN (Global Medical Device Nomenclature) for device classification
- Use LOINC codes for what devices measure (observations)

---

## NEXT STEPS

1. **Locate FSH Files:** Find all files containing incorrect codes
2. **Create Fix Script:** Develop automated script to replace codes
3. **Validate Changes:** Run SUSHI compilation after changes
4. **Update Examples:** Ensure all example instances use correct codes
5. **Documentation:** Update IG narrative pages to reflect correct terminology
6. **Testing:** Validate against FHIR validator with terminology service

---

**Document Status:** Ready for Implementation
**Implementation Priority:** High (addresses 16 terminology errors)