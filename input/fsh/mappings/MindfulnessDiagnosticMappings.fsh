Instance: MindfulnessDiagnosticMap
InstanceOf: ConceptMap
Usage: #definition
Title: "Mindfulness Diagnostic Mappings"
Description: "Mapping of mindfulness outcomes to diagnostic codes"
* name = "MindfulnessDiagnosticMap"
* status = #draft
* date = "2026-09-23"
* experimental = false
* purpose = "Map mindfulness outcomes to standard diagnostic codes"
* sourceUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-outcome-vs"
* targetUri = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-snomed-vs"

* group[0].source = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
* group[0].target = "http://snomed.info/sct"
* group[0].element[0]
  * code = #stressReduction
  * target[0]
    * code = #79365001
    * display = "Decreased stress"
    * equivalence = #equivalent
    * comment = "The source is defined as decreased levels of stress and tension; Decreased stress is that finding. Until 0.5.1 the target was 73595000 Stress, mapped as narrower, although Stress subsumes Decreased stress. Verified 2026-09-23 in the Vocab2 snapshot (SNOMED CT International Edition 2025-02-01) and on tx.fhir.org (International 20250201)."

* group[0].element[1]
  * code = #improvedSleep
  * target[0]
    * code = #314939008
    * display = "Good sleep pattern"
    * equivalence = #relatedto
    * comment = "The source is an improvement (enhanced sleep quality) and the target a state (a good sleep pattern): they overlap but neither subsumes the other, so the relation is relatedto. Until 0.5.1 this target was 248234008, which is Mentally alert. Verified 2026-09-23 in the Vocab2 snapshot (SNOMED CT International Edition 2025-02-01) and on tx.fhir.org (International 20250201)."

* group[0].element[2]
  * code = #emotionalBalance
  * target[0]
    * code = #285850008
    * display = "Able to control emotions"
    * equivalence = #relatedto
    * comment = "The source is an improvement (better emotional regulation) and the target a state (able to control emotions): they overlap but neither subsumes the other, so the relation is relatedto. Until 0.5.1 this target was 285854004, which is Emotion (observable entity). Verified 2026-09-23 in the Vocab2 snapshot (SNOMED CT International Edition 2025-02-01) and on tx.fhir.org (International 20250201)."

* group[0].element[3]
  * code = #increasedAwareness
  * target[0]
    * code = #365929007
    * display = "Consciousness and/or awareness finding"
    * equivalence = #wider
    * comment = "The target groups the findings about consciousness and awareness, and none of them is increased awareness, so the target is wider than the source. Until 0.5.1 this target was 736253002, which is Mental health crisis plan (record artifact). Verified 2026-09-23 in the Vocab2 snapshot (SNOMED CT International Edition 2025-02-01) and on tx.fhir.org (International 20250201)."

RuleSet: MindfulnessDiagnosticRules
* status MS
* code MS
* subject MS
* effective[x] MS
* value[x] MS
* method MS

* method from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-diagnostic-method-vs (extensible)
* code from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/mindfulness-diagnostic-code-vs (required)

* extension contains 
    diagnosticCertainty 0..1 MS and
    diagnosticTiming 0..1 MS
