Extension: MobilityAlertLevel
Id: mobility-alert-level
Title: "Mobility Alert Level Extension"
Description: "Extension for mobility measurements alert levels to indicate the severity or concern level of mobility changes detected by the device"
* ^status = #active
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* . ^short = "Mobility alert level indicator"
* . ^definition = "Indicates the severity level of mobility changes or concerns based on device measurements"
* value[x] only CodeableConcept
* valueCodeableConcept from MobilityAlertLevelVS (required)
* valueCodeableConcept ^short = "Alert level code"
* valueCodeableConcept ^definition = "The specific alert level code indicating the severity of mobility changes"

ValueSet: MobilityAlertLevelVS
Id: mobility-alert-level-vs
Title: "Mobility Alert Level Value Set"
Description: "Value set for mobility measurement alert levels used to categorize the severity of mobility changes or concerns"
* ^status = #active
* ^experimental = false
* ^purpose = "To provide standardized alert levels for mobility measurements"
* codes from system MobilityAlertLevelCS

CodeSystem: MobilityAlertLevelCS
Id: mobility-alert-level-cs
Title: "Mobility Alert Level Code System"
Description: "Code system defining alert levels for mobility measurements, indicating the severity of changes in mobility patterns"
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #green "Normal - No concern" "Mobility measurements are within normal range and show no concerning patterns"
* #yellow "Caution - Monitor closely" "Mobility measurements show slight deviations that warrant closer monitoring"
* #red "Alert - Significant change" "Mobility measurements indicate significant changes that require immediate attention"
* ^property[0].code = #status
* ^property[0].type = #code
* ^property[0].description = "The status of the alert level"
* ^property[1].code = #severity
* ^property[1].type = #integer
* ^property[1].description = "Numeric value indicating severity (1=low, 3=high)"
