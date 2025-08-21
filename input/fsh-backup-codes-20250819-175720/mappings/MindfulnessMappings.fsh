Mapping: MindfulnessToHealthKit
Id: mindfulness-to-healthkit
Title: "Mapping to Apple HealthKit"
Source: MindfulnessObservation
Target: "http://developer.apple.com/documentation/healthkit"

* -> "HKCategoryTypeIdentifierMindfulSession" "Root mapping"
* effectiveDateTime -> "startDate and endDate" "Session timing"
* component[sessionDuration].valueQuantity -> "duration" "Session duration"

Mapping: MindfulnessToLOINC
Id: mindfulness-to-loinc
Title: "Mapping to LOINC codes"
Source: MindfulnessObservation
Target: "http://loinc.org"

* -> "89555-7" "Mindfulness safety questionnaire"
* component[stressLevel] -> "89556-5" "Stress level score"
* component[sessionDuration] -> "89557-3" "Duration of mindfulness practice"
* component[moodState] -> "89558-1" "Mood pattern"

Mapping: MindfulnessToSNOMED
Id: mindfulness-to-snomed
Title: "Mapping to SNOMED CT"
Source: MindfulnessObservation
Target: "http://snomed.info/sct"

* -> "711020003" "Meditation"
* component[stressLevel] -> "725854004" "Assessment of stress level"
* component[moodState] -> "373931001" "Mood finding"
* component[relaxationResponse] -> "276241001" "Relaxation technique"

Extension: MindfulnessImportMap
Id: mindfulness-import-map
Title: "Mindfulness Import Mapping"
Description: "Mapping instructions for importing mindfulness data"

* ^url = "https://github.com/RicardoLSantos/shorthand/StructureDefinition/mindfulness-import-map"
* ^version = "1.0.0"
* ^status = #draft

* extension contains
    source 1..1 MS and
    target 1..1 MS and
    mapping 1..1 MS

* extension[source].value[x] only string
* extension[target].value[x] only string
* extension[mapping].value[x] only string

Instance: HealthKitMappingConfig
InstanceOf: MindfulnessImportMap
Usage: #inline

* extension[source].valueString = "HKCategoryTypeIdentifierMindfulSession"
* extension[target].valueString = "Observation"
* extension[mapping].valueString = "duration->component[sessionDuration].valueQuantity"
