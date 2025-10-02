// Originally defined on lines 1 - 9
Mapping: MindfulnessToHealthKit
Id: mindfulness-to-healthkit
Title: "Mapping to Apple HealthKit"
Source: MindfulnessObservation
Target: "http://developer.apple.com/documentation/healthkit"
* -> "HKCategoryTypeIdentifierMindfulSession" "Root mapping"
* effectiveDateTime -> "startDate and endDate" "Session timing"
* component[sessionDuration].valueQuantity -> "duration" "Session duration"

// Originally defined on lines 11 - 20
Mapping: MindfulnessToLOINC
Id: mindfulness-to-loinc
Title: "Mapping to LOINC codes"
Source: MindfulnessObservation
Target: "http://loinc.org"
* -> "89555-7" "Mindfulness safety questionnaire"
* component[stressLevel] -> "89556-5" "Stress level score"
* component[sessionDuration] -> "89557-3" "Duration of mindfulness practice"
* component[moodState] -> "89558-1" "Mood pattern"

// Originally defined on lines 22 - 31
Mapping: MindfulnessToSNOMED
Id: mindfulness-to-snomed
Title: "Mapping to SNOMED CT"
Source: MindfulnessObservation
Target: "http://snomed.info/sct"
* -> "711415009" "Meditation"
* component[stressLevel] -> "725854004" "Assessment of stress level"
* component[moodState] -> "373931001" "Mood finding"
* component[relaxationResponse] -> "276241001" "Relaxation technique"

// Originally defined on lines 33 - 49
Extension: MindfulnessImportMap
Parent: Extension
Id: mindfulness-import-map
Title: "Mindfulness Import Mapping"
Description: "Mapping instructions for importing mindfulness data"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/mindfulness-import-map"
* ^version = "1.0.0"
* ^status = #draft
* extension contains
    source 0.. and
    target 0.. and
    mapping 0..
* extension[source] 1..1
* extension[source] MS
* extension[target] 1..1
* extension[target] MS
* extension[mapping] 1..1
* extension[mapping] MS
* extension[source].value[x] only string
* extension[target].value[x] only string
* extension[mapping].value[x] only string
* value[x] 0..0
* extension[source].extension 0..0
* extension[target].extension 0..0
* extension[mapping].extension 0..0

// Originally defined on lines 51 - 57
Instance: HealthKitMappingConfig
InstanceOf: MindfulnessImportMap
Usage: #inline
* extension[source].valueString = "HKCategoryTypeIdentifierMindfulSession"
* extension[target].valueString = "Observation"
* extension[mapping].valueString = "duration->component[sessionDuration].valueQuantity"

