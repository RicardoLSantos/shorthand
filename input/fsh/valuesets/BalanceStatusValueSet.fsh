ValueSet: BalanceStatusValueSet
Id: balance-status
Title: "Balance Status Value Set"
Description: "Value set for walking steadiness balance status"
* ^url = "https://2rdoc.pt/fhir/ValueSet/balance-status"
* ^status = #active
* include codes from system https://2rdoc.pt/fhir/CodeSystem/balance-status

CodeSystem: BalanceStatusCodeSystem
Id: balance-status
Title: "Balance Status Code System"
Description: "Code system for balance status types"
* ^url = "https://2rdoc.pt/fhir/CodeSystem/balance-status"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #veryStable "Very Stable"
* #stable "Stable"
* #slightlyUnstable "Slightly Unstable"
* #unstable "Unstable"
* #veryUnstable "Very Unstable"
