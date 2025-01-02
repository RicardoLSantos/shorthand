ValueSet: CervicalMucusValueSet
Id: cervical-mucus-valueset
Title: "Cervical Mucus Value Set"
Description: "Value set for cervical mucus observations"
* ^url = "http://example.org/fhir/ValueSet/cervical-mucus-valueset"
* ^status = #active
* include codes from system http://example.org/fhir/CodeSystem/cervical-mucus-codesystem

CodeSystem: CervicalMucusCodeSystem
Id: cervical-mucus-codesystem
Title: "Cervical Mucus Code System"
* ^url = "http://example.org/fhir/CodeSystem/cervical-mucus-codesystem"
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
* ^url = "http://example.org/fhir/ValueSet/ovulation-test-valueset"
* ^status = #active
* include codes from system http://example.org/fhir/CodeSystem/ovulation-test-codesystem

CodeSystem: OvulationTestCodeSystem
Id: ovulation-test-codesystem
Title: "Ovulation Test Code System"
* ^url = "http://example.org/fhir/CodeSystem/ovulation-test-codesystem"
* ^status = #active
* ^caseSensitive = true
* #negative "Negative"
* #positive "Positive"
* #invalid "Invalid Test"

ValueSet: FertilityStatusValueSet
Id: fertility-status-valueset
Title: "Fertility Status Value Set"
Description: "Value set for fertility status"
* ^url = "http://example.org/fhir/ValueSet/fertility-status-valueset"
* ^status = #active
* include codes from system http://example.org/fhir/CodeSystem/fertility-status-codesystem

CodeSystem: FertilityStatusCodeSystem
Id: fertility-status-codesystem
Title: "Fertility Status Code System"
* ^url = "http://example.org/fhir/CodeSystem/fertility-status-codesystem"
* ^status = #active
* ^caseSensitive = true
* #fertile "Fertile"
* #notFertile "Not Fertile"
* #uncertain "Uncertain"
