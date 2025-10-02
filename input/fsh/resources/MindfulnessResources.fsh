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

ValueSet: MindfulnessTypeVS
Id: mindfulness-type-vs
Title: "Mindfulness Practice Types Value Set"
Description: "Value set of mindfulness practice types"
* ^experimental = false
* include codes from system MindfulnessTypeCS

ValueSet: EnvironmentTypeVS
Id: environment-type-vs
Title: "Practice Environment Types Value Set"
Description: "Value set of practice environment types"
* ^experimental = false
* include codes from system EnvironmentTypeCS

Instance: MindfulnessSettingCS
InstanceOf: CodeSystem
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/MindfulnessSettingCS"
* version = "1.0.0"
* name = "MindfulnessSettingCS"
* title = "Mindfulness Setting CodeSystem"
* description = "CodeSystem defining different settings where mindfulness practice can occur"
* status = #active
* experimental = false
* caseSensitive = true
* content = #complete
* count = 5
* concept[+].code = #home
* concept[=].display = "Home Practice"
* concept[+].code = #clinic
* concept[=].display = "Clinical Setting"
* concept[+].code = #group
* concept[=].display = "Group Setting"
* concept[+].code = #retreat
* concept[=].display = "Retreat Setting"
* concept[+].code = #workplace
* concept[=].display = "Workplace Setting"
