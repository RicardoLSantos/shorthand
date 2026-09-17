Instance: SocialHistoryObservationExample
InstanceOf: ReproductiveObservation
Usage: #example
Description: "Social history observation example"
Title: "Social History Observation Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T10:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#social-history "Social History"
* code = $LOINC#29762-2 "Social history note"
* valueString = "Patient reports active social life with regular community engagement"
// 2026-09-17: the former frequency component ("Number of menstrual periods per year" = Daily) was removed — this instance is a social-history note and carries no reproductive component; the profile now offers a regularity component (SNOMED 364307006) instead
* note.text = "Patient demonstrates good social support network"
