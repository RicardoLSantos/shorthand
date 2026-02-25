ValueSet: MindfulnessTypeVS
Id: mindfulness-type-vs
Title: "Mindfulness Practice Types Value Set"
Description: "Value set of mindfulness practice types"
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

ValueSet: EnvironmentTypeVS
Id: environment-type-vs
Title: "Practice Environment Types Value Set"
Description: "Value set of practice environment types"
* ^experimental = false
* include codes from system LifestyleMedicineTemporaryCS

Instance: MindfulnessSettingCS
InstanceOf: CodeSystem
Usage: #definition
* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs"
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
