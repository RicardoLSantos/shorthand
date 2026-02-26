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
* include codes from system MindfulnessSettingCS

CodeSystem: MindfulnessSettingCS
Id: MindfulnessSettingCS
Title: "Mindfulness Setting CodeSystem"
Description: "CodeSystem defining different settings where mindfulness practice can occur"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/MindfulnessSettingCS"
* ^version = "1.0.0"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* ^count = 5
* #home "Home Practice"
* #clinic "Clinical Setting"
* #group "Group Setting"
* #retreat "Retreat Setting"
* #workplace "Workplace Setting"
