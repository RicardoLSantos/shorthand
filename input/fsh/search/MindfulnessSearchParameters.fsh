Instance: MindfulnessType
InstanceOf: SearchParameter
Usage: #definition
* status = #active
* code = #mindfulness-type
* name = "MindfulnessType"
* description = "Search for mindfulness observations by practice type"
* base = #Observation
* type = #token
* expression = "Observation.component(code.coding.where(system='http://snomed.info/sct' and code='711020003')).value.as(CodeableConcept)"
* xpath = "f:Observation/f:component[f:code/f:coding[f:system/@value='http://snomed.info/sct' and f:code/f:coding/f:code/@value='711020003']]/f:valueCodeableConcept"
* xpathUsage = #normal
