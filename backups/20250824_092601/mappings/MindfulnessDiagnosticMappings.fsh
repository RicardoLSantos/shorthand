Instance: MindfulnessDiagnosticMap
InstanceOf: ConceptMap
Usage: #definition
Title: "Mindfulness Diagnostic Mappings"
Description: "Mapping of mindfulness outcomes to diagnostic codes"

* status = #draft
* experimental = false
* purpose = "Map mindfulness outcomes to standard diagnostic codes"
<<<<<<<< HEAD:backups/20250824_092601/mappings/MindfulnessDiagnosticMappings.fsh
* sourceUri = "https://2rdoc.pt/fhir/ValueSet/mindfulness-outcome-vs"
* targetUri = "http://snomed.info/sct"

* group[0].source = "https://2rdoc.pt/fhir/CodeSystem/mindfulness-outcome-cs"
========
* sourceUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-outcome-vs"
* targetUri = "http://snomed.info/sct"

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-outcome-cs"
>>>>>>>> 3873710f90bfe03355f425d99c1c517f95832978:backups/fsh_backups/by_phase/MindfulnessDiagnosticMappings.fsh
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

<<<<<<<< HEAD:backups/20250824_092601/mappings/MindfulnessDiagnosticMappings.fsh
* method from https://2rdoc.pt/fhir/ValueSet/mindfulness-diagnostic-method-vs (required)
* code from https://2rdoc.pt/fhir/ValueSet/mindfulness-diagnostic-code-vs (required)
========
* method from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-diagnostic-method-vs (required)
* code from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-diagnostic-code-vs (required)
>>>>>>>> 3873710f90bfe03355f425d99c1c517f95832978:backups/fsh_backups/by_phase/MindfulnessDiagnosticMappings.fsh

* extension contains 
    diagnosticCertainty 0..1 MS and
    diagnosticTiming 0..1 MS
