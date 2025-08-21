Instance: ExampleReproductiveActivity
InstanceOf: CarePlan
Usage: #example
* status = #active
* intent = #plan
* subject = Reference(Patient/example)
* activity.detail.kind = #Observation
* activity.detail.code = ReproductiveActivityCS#cycle-tracking
* activity.detail.status = #scheduled
