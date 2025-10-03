Instance: ExampleReproductiveActivity
InstanceOf: CarePlan
Usage: #example
Description: "Reproductive health care plan example"
* status = #active
* intent = #plan
* subject = Reference(Patient/PatientExample)
* activity.detail.kind = #ServiceRequest
* activity.detail.code = ReproductiveActivityCS#cycle-tracking
* activity.detail.status = #scheduled

Instance: FertilityObservationExample
InstanceOf: FertilityObservation
Usage: #example
Description: "Fertility observation with cervical mucus and ovulation test"
Title: "Fertility Observation Example"
* status = #final
* subject = Reference(Patient/PatientExample)
* effectiveDateTime = "2024-03-19T08:00:00Z"
* performer = Reference(Practitioner/PractitionerExample)
* component[cervicalMucus].code = $SCT#289567002 "Cervical mucus"
* component[cervicalMucus].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cervical-mucus-cs#eggWhite "Egg White"
* component[ovulationTest].code = $SCT#252366009 "Ovulation test"
* component[ovulationTest].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/ovulation-test-cs#positive "Positive"
* component[fertilityStatus].code = $SCT#87527008 "Fertility status"
* component[fertilityStatus].valueCodeableConcept = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fertility-status-cs#fertile "Fertile"
