ValueSet: EnvironmentalContextVS
Id: environmental-context-vs
Title: "Environmental Context Value Set"
Description: "Valid contexts for environmental measurements"

* ^status = #active
* ^experimental = false
* ^date = "2024-03-19"

* codes from system EnvironmentalContextCS

CodeSystem: EnvironmentalContextCS
Id: environmental-context-cs
Title: "Environmental Context Code System"
Description: "Code system for environmental measurement contexts"

* ^status = #active
* ^experimental = false
* ^caseSensitive = true

* #indoor "Indoor" "Measurement taken indoors"
* #outdoor "Outdoor" "Measurement taken outdoors"
* #home "Home" "Measurement taken at home"
* #work "Work" "Measurement taken at workplace"
* #urban "Urban Area" "Measurement taken in urban environment"
* #rural "Rural Area" "Measurement taken in rural environment"
* #transit "In Transit" "Measurement taken while in transit"
* #exercise "During Exercise" "Measurement taken during physical activity"
* #rest "At Rest" "Measurement taken during rest"
* #sleep "During Sleep" "Measurement taken during sleep"

Instance: ExampleEnvironmentalContext
InstanceOf: Observation
Usage: #example
Title: "Example Environmental Context"
Description: "Example showing use of environmental context"

* status = #final
* code = $LOINC#89020-2 "Environmental noise average"
* effectiveDateTime = "2024-03-19"
* extension[environmental-context].url = "http://example.org/fhir/StructureDefinition/environmental-context"
* extension[environmental-context].valueCodeableConcept = EnvironmentalContextCS#indoor "Indoor"
