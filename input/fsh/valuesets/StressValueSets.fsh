ValueSet: StressChronicityVS
Id: stress-chronicity-vs
Title: "Stress Chronicity Value Set"
Description: "Value set for classifying stress chronicity"
* codes from system StressChronicityCS

ValueSet: StressImpactVS
Id: stress-impact-vs
Title: "Stress Impact Value Set"
Description: "Value set for describing stress impact levels"
* codes from system StressImpactCS

CodeSystem: StressChronicityCS
Id: stress-chronicity-cs
Title: "Stress Chronicity Code System"
Description: "Code system for stress chronicity classification"
* #acute "Acute" "Short-term stress response"
* #subacute "Subacute" "Medium-term stress response"
* #chronic "Chronic" "Long-term stress response"
* #episodic "Episodic" "Recurring stress episodes"
* #persistent "Persistent" "Continuous stress state"

CodeSystem: StressImpactCS
Id: stress-impact-cs
Title: "Stress Impact Code System"
Description: "Code system for stress impact levels"
* #minimal "Minimal Impact" "Little to no interference with daily activities"
* #mild "Mild Impact" "Some interference with daily activities"
* #moderate "Moderate Impact" "Significant interference with daily activities"
* #severe "Severe Impact" "Major interference with daily activities"
* #extreme "Extreme Impact" "Unable to perform daily activities"
