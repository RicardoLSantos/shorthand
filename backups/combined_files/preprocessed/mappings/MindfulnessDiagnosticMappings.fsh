// Originally defined on lines 1 - 45
Instance: MindfulnessDiagnosticMap
InstanceOf: ConceptMap
Title: "Mindfulness Diagnostic Mappings"
Description: "Mapping of mindfulness outcomes to diagnostic codes"
Usage: #definition
* status = #draft
* experimental = false
* purpose = "Map mindfulness outcomes to standard diagnostic codes"
* sourceUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-outcome-vs"
* targetUri = "http://snomed.info/sct"
* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-outcome-cs"
* group[0].target = "http://snomed.info/sct"
* group[0].element[0]
* group[0].element[0].code = #stressReduction
* group[0].element[0].target[0]
* group[0].element[0].target[0].code = #73595000
* group[0].element[0].target[0].display = "Stress"
* group[0].element[0].target[0].equivalence = #narrower
* group[0].element[0].target[0].comment = "Indicates reduction in stress levels"
* group[0].element[1]
* group[0].element[1].code = #improvedSleep
* group[0].element[1].target[0]
* group[0].element[1].target[0].code = #248234008
* group[0].element[1].target[0].display = "Sleep pattern"
* group[0].element[1].target[0].equivalence = #narrower
* group[0].element[1].target[0].comment = "Indicates improvement in activity quality"
* group[0].element[2]
* group[0].element[2].code = #emotionalBalance
* group[0].element[2].target[0]
* group[0].element[2].target[0].code = #285854004
* group[0].element[2].target[0].display = "Emotional state"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[2].target[0].comment = "Maps to emotional state finding"
* group[0].element[3]
* group[0].element[3].code = #increasedAwareness
* group[0].element[3].target[0]
* group[0].element[3].target[0].code = #736253002
* group[0].element[3].target[0].display = "Mental state, behavior and/or psychosocial functioning"
* group[0].element[3].target[0].equivalence = #relatedto
* group[0].element[3].target[0].comment = "General improvement in mental state"

