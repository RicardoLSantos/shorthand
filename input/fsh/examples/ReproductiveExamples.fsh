Instance: ExampleReproductiveActivity
InstanceOf: CarePlan
Usage: #example
* status = #active
* intent = #plan
* subject = Reference(Patient/example)
* activity.detail.kind = #ServiceRequest
* activity.detail.code = ReproductiveActivityCS#cycle-tracking
* activity.detail.status = #scheduled
