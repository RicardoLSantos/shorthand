CodeSystem: MindfulnessOutcomeCS
Id: mindfulness-outcome-cs
Title: "Mindfulness Outcomes"
Description: "Outcomes and effects of mindfulness practice"

* ^experimental = false
* ^caseSensitive = true
* #increasedAwareness "Increased Awareness" "Greater awareness of thoughts and sensations"
* #improvedFocus "Improved Focus" "Enhanced ability to concentrate"
* #stressReduction "Stress Reduction" "Decreased levels of stress and tension"
* #emotionalBalance "Emotional Balance" "Better emotional regulation"
* #improvedSleep "Improved Sleep" "Enhanced activity quality"

ValueSet: MindfulnessOutcomeVS
Id: mindfulness-outcome-vs
Title: "Mindfulness Outcomes Value Set"
Description: "Value set for mindfulness practice outcomes"

* ^experimental = false
* include codes from system MindfulnessOutcomeCS
* include $SCT#365949003 "Finding of level of stress"
* include $SCT#106131003 "Mood finding"

CodeSystem: MindfulnessQualifierCS
Id: mindfulness-qualifier-cs
Title: "Mindfulness Practice Qualifiers"
Description: "Qualifiers for mindfulness practice characteristics"

* ^experimental = false
* ^caseSensitive = true
* #guided "Guided Practice" "Practice with guidance or instruction"
* #selfDirected "Self-Directed" "Independent practice"
* #group "Group Practice" "Practice in group setting"
* #individual "Individual Practice" "Solo practice session"

ValueSet: MindfulnessQualifierVS
Id: mindfulness-qualifier-vs
Title: "Mindfulness Practice Qualifiers Value Set"
Description: """
Value set for mindfulness practice qualifiers.

**SNOMED CT Verification Notes (2026-01-12)**:
Previous codes were INCORRECT:
- 410534003: Actual = "Not indicated (qualifier value)" NOT "During exercise"
- 225386006: Actual = "Evaluating patient status for discharge" NOT "Exercise therapy"

These codes were removed. The custom MindfulnessQualifierCS provides
appropriate qualifiers for mindfulness practice settings.
"""

* ^experimental = false
* include codes from system MindfulnessQualifierCS
