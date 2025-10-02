Instance: MindfulnessType
InstanceOf: SearchParameter
Description: "Example instance of MindfulnessType"Usage: #definition
* status = #active
* code = #mindfulness-type
* name = "MindfulnessType"
* description = "Search for mindfulness observations by practice type"
* base = #Observation
* type = #token
* expression = "Observation.component.where(code.coding.where(system='http://snomed.info/sct' and code='711415009')).value.as(CodeableConcept)"
* xpath = "f:Observation/f:component[f:code/f:coding[f:system/@value='http://snomed.info/sct' and f:code/f:coding/f:code/@value='711415009']]/f:valueCodeableConcept"
* xpathUsage = #normal
