// Originally defined on lines 1 - 44
Instance: MindfulnessHealthKitTransform
InstanceOf: StructureMap
Title: "HealthKit to FHIR Mindfulness Transform"
Usage: #definition
* status = #draft
* name = "MindfulnessHealthKitTransform"
* structure[0]
* structure[0].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/healthkit-mindfulness"
* structure[0].mode = #source
* structure[0].documentation = "HealthKit mindfulness session structure"
* structure[1]
* structure[1].url = "http://hl7.org/fhir/StructureDefinition/Observation"
* structure[1].mode = #target
* structure[1].documentation = "FHIR Observation resource"
* group[0]
* group[0].name = "MindfulnessSessionToObservation"
* group[0].typeMode = #none
* group[0].input[0]
* group[0].input[0].name = "source"
* group[0].input[0].type = "HealthKitMindfulness"
* group[0].input[0].mode = #source
* group[0].input[1]
* group[0].input[1].name = "target"
* group[0].input[1].type = "Observation"
* group[0].input[1].mode = #target
* group[0].rule[0]
* group[0].rule[0].name = "Session"
* group[0].rule[0].source[0]
* group[0].rule[0].source[0].context = "source"
* group[0].rule[0].source[0].element = "startDate"
* group[0].rule[0].target[0]
* group[0].rule[0].target[0].context = "target"
* group[0].rule[0].target[0].element = "effectiveDateTime"
* group[0].rule[1]
* group[0].rule[1].name = "Duration"
* group[0].rule[1].source[0]
* group[0].rule[1].source[0].context = "source"
* group[0].rule[1].source[0].element = "duration"
* group[0].rule[1].target[0]
* group[0].rule[1].target[0].context = "target"
* group[0].rule[1].target[0].element = "component.where(code.coding.code='118682006').valueQuantity"

// Originally defined on lines 46 - 77
Instance: MindfulnessCSVTransform
InstanceOf: StructureMap
Title: "CSV to FHIR Mindfulness Transform"
Usage: #definition
* status = #draft
* name = "MindfulnessCSVTransform"
* structure[0]
* structure[0].url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/csv-mindfulness"
* structure[0].mode = #source
* structure[0].documentation = "CSV mindfulness data structure"
* group[0]
* group[0].name = "CSVToMindfulnessObservation"
* group[0].typeMode = #none
* group[0].input[0]
* group[0].input[0].name = "source"
* group[0].input[0].type = "CSVMindfulness"
* group[0].input[0].mode = #source
* group[0].input[1]
* group[0].input[1].name = "target"
* group[0].input[1].type = "Observation"
* group[0].input[1].mode = #target
* group[0].rule[0]
* group[0].rule[0].name = "MapDatetime"
* group[0].rule[0].source[0]
* group[0].rule[0].source[0].context = "source"
* group[0].rule[0].source[0].element = "date,time"
* group[0].rule[0].target[0]
* group[0].rule[0].target[0].context = "target"
* group[0].rule[0].target[0].element = "effectiveDateTime"
* group[0].rule[0].target[0].transform = #append

