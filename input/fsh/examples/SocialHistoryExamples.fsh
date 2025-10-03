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
* component[frequency].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/symptom-frequency-cs#daily "Daily"
* note.text = "Patient demonstrates good social support network"
