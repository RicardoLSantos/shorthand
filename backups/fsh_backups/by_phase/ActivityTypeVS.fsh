ValueSet: PhysicalActivityTypeVS
Id: physical-activity-type-vs
Title: "Physical Activity Types Value Set"
Description: "Types of physical activities from iOS Health App"
* ^experimental = false

* ^status = #active
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"

* $SNOMED#255604002 "Physical activity (observable entity)"
* $SNOMED#228557008 "Walking"
* $SNOMED#229065009 "Running"
* $SNOMED#266938001 "Swimming"
* $SNOMED#266940006 "Cycling"
* $SNOMED#48761009 "Regular exercise"
