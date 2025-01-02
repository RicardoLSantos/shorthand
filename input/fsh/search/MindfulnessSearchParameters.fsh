Instance: MindfulnessType
InstanceOf: SearchParameter
Usage: #definition
Title: "Search by mindfulness practice type"

* status = #active
* code = #mindfulness-type
* name = "MindfulnessType"
* description = "Search for mindfulness observations by practice type"
* base = #Observation
* type = #token
* expression = "Observation.component.where(code.coding.exists(system='http://snomed.info/sct' and code='711020003')).value.ofType(CodeableConcept)"
* xpath = "f:Observation/f:component[f:code/f:coding/f:system/@value='http://snomed.info/sct' and f:code/f:coding/f:code/@value='711020003']/f:valueCodeableConcept"
* xpathUsage = #normal

Instance: StressLevel
InstanceOf: SearchParameter
Usage: #definition
Title: "Search by stress level"

* status = #active
* code = #stress-level
* name = "StressLevel"
* description = "Search for mindfulness observations by stress level"
* base = #Observation
* type = #number
* expression = "Observation.component.where(code.coding.exists(system='http://snomed.info/sct' and code='725854004')).value.ofType(integer)"
* xpath = "f:Observation/f:component[f:code/f:coding/f:system/@value='http://snomed.info/sct' and f:code/f:coding/f:code/@value='725854004']/f:valueInteger"
* xpathUsage = #normal

Instance: SessionDuration
InstanceOf: SearchParameter
Usage: #definition
Title: "Search by session duration"

* status = #active
* code = #session-duration
* name = "SessionDuration"
* description = "Search for mindfulness observations by session duration"
* base = #Observation
* type = #quantity
* expression = "Observation.component.where(code.coding.exists(system='http://snomed.info/sct' and code='118682006')).value.ofType(Quantity)"
* xpath = "f:Observation/f:component[f:code/f:coding/f:system/@value='http://snomed.info/sct' and f:code/f:coding/f:code/@value='118682006']/f:valueQuantity"
* xpathUsage = #normal
