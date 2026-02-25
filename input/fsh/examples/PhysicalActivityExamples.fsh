Instance: PhysicalActivityExample1
InstanceOf: PhysicalActivityObservation
Usage: #example
Description: "Physical activity observation example"
Title: "Example of Walking Activity"
* status = #final
* performer = Reference(Practitioner/PractitionerExample)
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* code = $SNOMED#129006008 "Walking"
* subject = Reference(PatientExample)
* effectiveDateTime = "2024-03-19T15:30:00Z"
* device = Reference(DeviceActivityTracker)
* component[steps].code = $LOINC#55423-8 "Number of steps in unspecified time Pedometer"
* component[steps].valueQuantity = 8546 '1' "count"
* component[steps].valueQuantity.system = $UCUM
* component[steps].valueQuantity.unit = "count"
* component[distance].code = $LOINC#55430-3 "Walking distance unspecified time Pedometer"
* component[distance].valueQuantity = 6.2 'km' "kilometer"
* component[distance].valueQuantity.system = $UCUM
* component[distance].valueQuantity.unit = "kilometer"
* component[duration].code = $LOINC#55411-3 "Exercise duration"
* component[duration].valueQuantity = 72 'min' "minute"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.unit = "minute"
* component[energy].code = $LOINC#55424-6 "Calories burned in unspecified time Pedometer"
* component[energy].valueQuantity = 320 'kcal' "kilocalorie"
* component[energy].valueQuantity.system = $UCUM
* component[energy].valueQuantity.unit = "kilocalorie"

Instance: DeviceActivityTracker
InstanceOf: Device
Usage: #example
Description: "Activity tracker device example"
Title: "Activity Tracking Device"
* deviceName.name = "Health Activity Tracker"
* deviceName.type = #user-friendly-name
* manufacturer = "HealthTech Devices"
* modelNumber = "HAT-2024"
* type = $SCT#86290005 "Respiratory rate"

// =============================================================================
// Semantic Anchoring Example - Walking with LOINC LA Answer Code
// =============================================================================
// LA11834-1 "Walking" is a LOINC Answer code (discrete option for exercise
// type questions). SNOMED 129006008 is the observable, but LA11834-1 provides
// an additional semantic anchor within the LOINC ecosystem.
// =============================================================================

Instance: WalkingDualCodingExample
InstanceOf: Observation
Usage: #example
Description: "Walking activity with dual semantic anchoring via SNOMED + LOINC LA code"
Title: "Walking Activity - Semantic Anchoring (LA Dual-Coding)"

* status = #final
* category = http://terminology.hl7.org/CodeSystem/observation-category#activity
* subject = Reference(PatientExample)
* effectiveDateTime = "2026-02-25T17:30:00Z"
* performer = Reference(Practitioner/PractitionerExample)

* code.coding[0] = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#physical-activity-walking "Walking"
* code.coding[1] = $LOINC#LA11834-1 "Walking"
* code.coding[2] = $SCT#129006008 "Walking (observable entity)"
* code.text = "Walking"

* valueQuantity = 45 'min' "minute"
* note.text = "Walking session tracked by wearable. Triple coding: custom (primary) + LOINC LA11834-1 (Answer code for exercise type) + SNOMED CT 129006008 (observable entity). LA codes are discrete answer options, not observation codes."
