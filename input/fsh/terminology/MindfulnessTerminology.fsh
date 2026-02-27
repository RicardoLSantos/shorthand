ValueSet: MindfulnessOutcomeVS
Id: mindfulness-outcome-vs
Title: "Mindfulness Outcomes Value Set"
Description: "Value set for mindfulness practice outcomes"

* ^experimental = false
* LifestyleMedicineTemporaryCS#increasedAwareness "Increased Awareness"
* LifestyleMedicineTemporaryCS#improvedFocus "Improved Focus"
* LifestyleMedicineTemporaryCS#stressReduction "Stress Reduction"
* LifestyleMedicineTemporaryCS#emotionalBalance "Emotional Balance"
* LifestyleMedicineTemporaryCS#improvedSleep "Improved Sleep"
* include $SCT#365949003 "Finding of level of stress"
* include $SCT#106131003 "Mood finding"
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
* LifestyleMedicineTemporaryCS#guided "Guided Practice"
* LifestyleMedicineTemporaryCS#selfDirected "Self-Directed"
* LifestyleMedicineTemporaryCS#mindfulness-qualifier-group "Group Practice"
* LifestyleMedicineTemporaryCS#individual "Individual Practice"
