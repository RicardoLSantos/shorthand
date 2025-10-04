// Originally defined on lines 1 - 10
Instance: ExampleReproductiveActivity
InstanceOf: CarePlan
Description: "Reproductive health care plan example"
Usage: #example
* status = #active
* intent = #plan
* subject = Reference(Patient/PatientExample)
* activity.detail.kind = #ServiceRequest
* activity.detail.code = ReproductiveActivityCS#cycle-tracking
* activity.detail.status = #scheduled

