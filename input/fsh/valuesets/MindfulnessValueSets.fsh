ValueSet: MoodStateVS
Id: mood-state-vs
Title: "Mood State Value Set"
Description: "Value set for mood states"
* SCT#285854004 "Emotion (observable entity)"
* SCT#130987000 "Depressed mood"
* SCT#130988005 "Anxious mood"
* SCT#130989002 "Elevated mood"
* SCT#130990006 "Irritable mood"
* SCT#130991005 "Neutral mood"

ValueSet: StressLevelVS
Id: stress-level-vs
Title: "Stress Level Value Set"
Description: "Value set for stress levels"
* include codes from system StressLevelCS

CodeSystem: StressLevelCS
Id: stress-level-cs
Title: "Stress Level Code System"
* #0 "No stress"
* #1-3 "Low stress"
* #4-6 "Moderate stress"
* #7-9 "High stress"
* #10 "Extreme stress"
