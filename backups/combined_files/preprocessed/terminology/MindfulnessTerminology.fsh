// Originally defined on lines 1 - 12
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

// Originally defined on lines 14 - 22
ValueSet: MindfulnessOutcomeVS
Id: mindfulness-outcome-vs
Title: "Mindfulness Outcomes Value Set"
Description: "Value set for mindfulness practice outcomes"
* ^experimental = false
* include codes from system MindfulnessOutcomeCS
* http://snomed.info/sct#365949003 "Finding of level of stress"
* http://snomed.info/sct#373931001 "Mood finding"

// Originally defined on lines 24 - 34
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

// Originally defined on lines 36 - 46
ValueSet: MindfulnessQualifierVS
Id: mindfulness-qualifier-vs
Title: "Mindfulness Practice Qualifiers Value Set"
Description: "Value set for mindfulness practice qualifiers"
* ^experimental = false
* include codes from system MindfulnessQualifierCS
* http://snomed.info/sct#410534003 "During exercise"
* http://snomed.info/sct#225386006 "Exercise therapy"
* ^copyright = "This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO)"

