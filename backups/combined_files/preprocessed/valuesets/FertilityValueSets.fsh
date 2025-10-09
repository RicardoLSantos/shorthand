// Originally defined on lines 1 - 8
ValueSet: CervicalMucusValueSet
Id: cervical-mucus-valueset
Title: "Cervical Mucus Value Set"
Description: "Value set for cervical mucus observations"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/cervical-mucus-vs"
* ^status = #active
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cervical-mucus-cs

// Originally defined on lines 10 - 20
CodeSystem: CervicalMucusCodeSystem
Id: cervical-mucus-cs
Title: "Cervical Mucus Code System"
Description: "Code system for cervical mucus classification"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/cervical-mucus-cs"
* ^status = #active
* ^caseSensitive = true
* #dry "Dry"
* #sticky "Sticky"
* #creamy "Creamy"
* #watery "Watery"
* #eggWhite "Egg White"

// Originally defined on lines 22 - 29
ValueSet: OvulationTestValueSet
Id: ovulation-test-valueset
Title: "Ovulation Test Value Set"
Description: "Value set for ovulation test results"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/ovulation-test-vs"
* ^status = #active
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/ovulation-test-cs

// Originally defined on lines 31 - 39
CodeSystem: OvulationTestCodeSystem
Id: ovulation-test-cs
Title: "Ovulation Test Code System"
Description: "Code system for ovulation test results"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/ovulation-test-cs"
* ^status = #active
* ^caseSensitive = true
* #negative "Negative"
* #positive "Positive"
* #invalid "Invalid Test"

// Originally defined on lines 41 - 48
ValueSet: FertilityStatusValueSet
Id: fertility-status-valueset
Title: "Fertility Status Value Set"
Description: "Value set for fertility status"
* ^experimental = false
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/fertility-status-vs"
* ^status = #active
* include codes from system https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fertility-status-cs
   

// Originally defined on lines 50 - 58
CodeSystem: FertilityStatusCodeSystem
Id: fertility-status-cs
Title: "Fertility Status Code System"
Description: "Code system for fertility status indicators"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/fertility-status-cs"
* ^status = #active
* ^caseSensitive = true
* #fertile "Fertile"
* #notFertile "Not Fertile"
* #uncertain "Uncertain"

