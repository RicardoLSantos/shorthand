Instance: MindfulnessDiagnosticMap
InstanceOf: ConceptMap
Usage: #definition
Title: "Mindfulness Diagnostic Mappings"
Description: "Mapping of mindfulness outcomes to diagnostic codes"

* status = #draft
* experimental = false
* purpose = "Map mindfulness outcomes to standard diagnostic codes"
* sourceUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-outcome-vs"
* targetUri = "http://snomed.info/sct"

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-outcome-cs"
* group[0].target = "http://snomed.info/sct"
* group[0].element[0]
  * code = #stressReduction
  * target[0]
    * code = #73595000
    * display = "Stress"
    * equivalence = #narrower
    * comment = "Indicates reduction in stress levels"

* group[0].element[1]
  * code = #improvedSleep
  * target[0]
    * code = #248234008
    * display = "Sleep pattern"
    * equivalence = #narrower
    * comment = "Indicates improvement in activity quality"

* group[0].element[2]
  * code = #emotionalBalance
  * target[0]
    * code = #285854004
    * display = "Emotional state"
    * equivalence = #equivalent
    * comment = "Maps to emotional state finding"

* group[0].element[3]
  * code = #increasedAwareness
  * target[0]
    * code = #736253002
    * display = "Mental state, behavior and/or psychosocial functioning"
    * equivalence = #relatedto
    * comment = "General improvement in mental state"

RuleSet: MindfulnessDiagnosticRules
* status MS
* code MS
* subject MS
* effective[x] MS
* value[x] MS
* method MS

* method from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-diagnostic-method-vs (required)
* code from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-diagnostic-code-vs (required)

* extension contains 
    diagnosticCertainty 0..1 MS and
    diagnosticTiming 0..1 MS
