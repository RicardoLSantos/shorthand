ValueSet: MoodStateVS
Id: mood-state-vs
Title: "Mood State Value Set"
Description: "Comprehensive value set capturing various mood states for holistic health assessment"
* ^experimental = false
* #285854004 "Emotion (observable entity)"
* #130987000 "Depressed mood"
* #130988005 "Anxious mood"
* #130989002 "Elevated mood"
* #130990006 "Irritable mood"
* #130991005 "Neutral mood"

ValueSet: StressLevelVS
Id: stress-level-vs
Title: "Stress Level Value Set"
Description: "Standardized value set for quantifying and assessing stress levels in lifestyle medicine"
* ^experimental = false
* include codes from system StressLevelCS

CodeSystem: StressLevelCS
Id: stress-level-cs
Title: "Stress Level Code System"
Description: "Granular code system for representing different stress intensities"
* ^experimental = false
* #0 "No stress"
* #1-3 "Low stress"
* #4-6 "Moderate stress"
* #7-9 "High stress"
* #10 "Extreme stress"
