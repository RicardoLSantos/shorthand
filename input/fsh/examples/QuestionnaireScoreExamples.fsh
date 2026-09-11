// Score observations for the coded questionnaires (PSS-10, IPAQ short form).
// The questionnaire code is on the Questionnaire resource; the derived score is an Observation
// with the LOINC score code, so that scores are queryable without parsing responses.

Alias: $LOINC = http://loinc.org
Alias: $ObsCat = http://terminology.hl7.org/CodeSystem/observation-category

Instance: PSS10TotalScoreExample
InstanceOf: Observation
Usage: #example
Title: "PSS-10 Total Score Example"
Description: "Perceived Stress Scale-10 total score (0–40) derived from a completed PSS-10 questionnaire"
* status = #final
* category = $ObsCat#survey
* code = $LOINC#106860-0 "Perceived stress scale-10 total score [PSS-10]"
* subject = Reference(PatientExample)
* effectiveDateTime = "2026-09-11T09:00:00Z"
* valueInteger = 18
* note.text = "Scored from the stress-assessment-pss10 questionnaire (items 4, 5, 7 and 8 reverse-scored)."

Instance: IPAQTotalPhysicalActivityExample
InstanceOf: Observation
Usage: #example
Title: "IPAQ Total Physical Activity Example"
Description: "Total physical activity in MET-minutes per week derived from the IPAQ short form (walking + moderate + vigorous)"
* status = #final
* category = $ObsCat#survey
* code = $LOINC#77594-0 "Total physical activity [IPAQ]"
* subject = Reference(PatientExample)
* effectiveDateTime = "2026-09-11T09:00:00Z"
* valueQuantity = 1386 '{MET-min}/wk' "MET-minutes per week"
* note.text = "Scored from the physical-activity-ipaq-short questionnaire following the IPAQ scoring protocol (walking 3.3 MET, moderate 4.0 MET, vigorous 8.0 MET)."
