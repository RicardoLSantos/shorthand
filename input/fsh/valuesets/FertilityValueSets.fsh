ValueSet: CervicalMucusValueSet
Id: cervical-mucus-valueset
Title: "Cervical Mucus Value Set"
Description: "Value set for cervical mucus observations"
* ^url = "http://example.org/fhir/ValueSet/cervical-mucus-vs"
* ^status = #active
* include codes from system http://example.org/fhir/CodeSystem/cervical-mucus-cs

CodeSystem: CervicalMucusCodeSystem
Id: cervical-mucus-cs
Title: "Cervical Mucus Code System"
* ^url = "http://example.org/fhir/CodeSystem/cervical-mucus-cs"
* ^status = #active
* ^caseSensitive = true
* #dry "Dry"
* #sticky "Sticky"
* #creamy "Creamy"
* #watery "Watery"
* #eggWhite "Egg White"

ValueSet: OvulationTestValueSet
Id: ovulation-test-valueset
Title: "Ovulation Test Value Set"
Description: "Value set for ovulation test results"
* ^url = "http://example.org/fhir/ValueSet/ovulation-test-vs"
* ^status = #active
* include codes from system http://example.org/fhir/CodeSystem/ovulation-test-cs

CodeSystem: OvulationTestCodeSystem
Id: ovulation-test-cs
Title: "Ovulation Test Code System"
* ^url = "http://example.org/fhir/CodeSystem/ovulation-test-cs"
* ^status = #active
* ^caseSensitive = true
* #negative "Negative"
* #positive "Positive"
* #invalid "Invalid Test"

ValueSet: FertilityStatusValueSet
Id: fertility-status-valueset
Title: "Fertility Status Value Set"
Description: "Value set for fertility status"
* ^url = "http://example.org/fhir/ValueSet/fertility-status-vs"
* ^status = #active
* include codes from system http://example.org/fhir/CodeSystem/fertility-status-cs

CodeSystem: FertilityStatusCodeSystem
Id: fertility-status-cs
Title: "Fertility Status Code System"
* ^url = "http://example.org/fhir/CodeSystem/fertility-status-cs"
* ^status = #active
* ^caseSensitive = true
* #fertile "Fertile"
* #notFertile "Not Fertile"
* #uncertain "Uncertain"
