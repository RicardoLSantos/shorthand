// Standalone example of the CarePlanLifestyleMedicine profile (2026-09-17). Until 0.5.0 the profile had only
// inline instances inside the AI workflow bundles, so its examples page read "No examples"; this instance gives
// the profile a standalone example that the build lists. Content mirrors the accepted plan of the workflow bundle.

Instance: CarePlanLifestyleMedicineExample
InstanceOf: CarePlanLifestyleMedicine
Usage: #example
Title: "Lifestyle Medicine Care Plan Example"
Description: "A clinician-authored physical-activity plan for a patient with a sedentary lifestyle: three 30-minute brisk walks per week for twelve weeks, reviewed against the patient's wearable step counts."
* status = #active
* intent = #plan
* title = "Progressive walking programme"
* description = "Three 30-minute brisk walks per week for twelve weeks, progressing to five; adherence reviewed monthly against the wearable step counts (LOINC 55423-8) shared by the patient."
* category = AgentDecisionSupportCS#lifestyle-exercise "Exercise Intervention"
* subject = Reference(Patient/PatientExample)
* period.start = "2026-09-01"
* period.end = "2026-11-24"
* created = "2026-09-01"
* author = Reference(Practitioner/PractitionerExample)
* activity[0].detail.kind = #ServiceRequest
* activity[0].detail.code.text = "Brisk walking, 30 minutes, three times a week"
* activity[0].detail.status = #in-progress
* activity[0].detail.description = "Moderate intensity (able to talk but not sing); progress to five sessions a week from week 5 if adherence is above 80%"
* note[0].text = "Plan agreed with the patient on 2026-09-01; first review 2026-10-01."
