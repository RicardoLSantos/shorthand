ValueSet: BalanceStatusValueSet
Id: balance-status-valueset
Title: "Balance Status Value Set"
Description: "Value set for walking steadiness balance status"
* ^url = "http://example.org/fhir/ValueSet/balance-status-valueset"
* ^status = #active
* include codes from system http://example.org/fhir/CodeSystem/balance-status-codesystem

CodeSystem: BalanceStatusCodeSystem
Id: balance-status-codesystem
Title: "Balance Status Code System"
Description: "Code system for balance status types"
* ^url = "http://example.org/fhir/CodeSystem/balance-status-codesystem"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* #veryStable "Very Stable"
* #stable "Stable"
* #slightlyUnstable "Slightly Unstable"
* #unstable "Unstable"
* #veryUnstable "Very Unstable"
