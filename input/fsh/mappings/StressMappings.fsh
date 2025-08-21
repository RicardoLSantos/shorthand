Mapping: StressToHealthKit
Id: stress-to-healthkit
Description: "Definition for stress-to-healthkit resource"Title: "Mapping to Apple HealthKit"
Source: StressLevelProfile
Target: "http://developer.apple.com/documentation/healthkit"

* -> "HKCategoryTypeIdentifierStressLevel" "Root mapping"
* valueQuantity -> "stressLevel" "Overall stress score"
* component[physiologicalStress] -> "physiologicalStress" "Physical stress indicators"
* component[psychologicalStress] -> "mentalStress" "Mental stress indicators"

Mapping: StressToLOINC
Id: stress-to-loinc
Title: "Mapping to LOINC codes"
Source: StressLevelProfile
Target: "http://loinc.org"

* -> "89592-0" "Stress Level Panel"
* component[physiologicalStress] -> "89593-8" "Physical stress score"
* component[psychologicalStress] -> "89594-6" "Mental stress score"
