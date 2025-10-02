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
