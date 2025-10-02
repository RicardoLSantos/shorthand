// Originally defined on lines 1 - 11
CodeSystem: MindfulnessTypeCS
Id: mindfulness-type-cs
Title: "Mindfulness Practice Types"
Description: "Types of mindfulness practices and techniques"
* ^experimental = false
* ^caseSensitive = true
* #meditation "Meditation" "Focused meditation practice"
* #breathing "Breathing Exercise" "Conscious breathing techniques"
* #bodyScan "Body Scan" "Progressive body awareness practice"
* #walking "Mindful Walking" "Walking meditation practice"
* #movement "Mindful Movement" "Conscious movement practice"

// Originally defined on lines 13 - 22
CodeSystem: EnvironmentTypeCS
Id: environment-type-cs
Title: "Practice Environment Types"
Description: "Types of environments for mindfulness practice"
* ^experimental = false
* ^caseSensitive = true
* #indoor "Indoor" "Indoor environment"
* #outdoor "Outdoor" "Outdoor environment"
* #quiet "Quiet Space" "Quiet or silent environment"
* #group "Group Setting" "Group practice environment"

// Originally defined on lines 24 - 29
ValueSet: MindfulnessTypeVS
Id: mindfulness-type-vs
Title: "Mindfulness Practice Types Value Set"
Description: "Value set of mindfulness practice types"
* ^experimental = false
* include codes from system MindfulnessTypeCS

// Originally defined on lines 31 - 36
ValueSet: EnvironmentTypeVS
Id: environment-type-vs
Title: "Practice Environment Types Value Set"
Description: "Value set of practice environment types"
* ^experimental = false
* include codes from system EnvironmentTypeCS

// Originally defined on lines 38 - 59
Instance: MindfulnessSettingCS
InstanceOf: CodeSystem
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/mindfulness-setting"
* version = "1.0.0"
* name = "MindfulnessSettingCS"
* title = "Mindfulness Setting CodeSystem"
* status = #active
* experimental = false
* caseSensitive = true
* content = #complete
* count = 5
* concept[0].code = #home
* concept[0].display = "Home Practice"
* concept[1].code = #clinic
* concept[1].display = "Clinical Setting"
* concept[2].code = #group
* concept[2].display = "Group Setting"
* concept[3].code = #retreat
* concept[3].display = "Retreat Setting"
* concept[4].code = #workplace
* concept[4].display = "Workplace Setting"

