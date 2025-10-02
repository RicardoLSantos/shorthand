Alias: $UCUM = http://unitsofmeasure.org

// Originally defined on lines 3 - 17
Extension: PhysiologicalStressIndex
Parent: Extension
Id: physiological-stress-index
Title: "Physiological Stress Index Extension"
Description: "Index representing overall physiological stress based on multiple parameters"
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #{index}
* valueQuantity ^short = "Physiological stress index value"
* valueQuantity ^definition = "Normalized index value representing overall physiological stress"
* extension 0..0

// Originally defined on lines 19 - 33
Extension: HomeostasisIndex
Parent: Extension
Id: homeostasis-index
Title: "Homeostasis Index Extension"
Description: "Composite measure of physiological balance and adaptation"
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #{ratio}
* valueQuantity ^short = "Homeostasis index value"
* valueQuantity ^definition = "Normalized ratio representing physiological balance"
* extension 0..0

// Originally defined on lines 35 - 49
Extension: RecoveryEfficiency
Parent: Extension
Id: recovery-efficiency
Title: "Recovery Efficiency Extension"
Description: "Measure of how efficiently the body recovers from stress or exertion"
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #%
* valueQuantity ^short = "Recovery efficiency percentage"
* valueQuantity ^definition = "Percentage indicating recovery efficiency"
* extension 0..0

// Originally defined on lines 51 - 65
Extension: AllostaticLoad
Parent: Extension
Id: allostatic-load
Title: "Allostatic Load Extension"
Description: "Measure of cumulative physiological burden over time"
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only Quantity
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #{score}
* valueQuantity ^short = "Allostatic load score"
* valueQuantity ^definition = "Score representing cumulative physiological burden"
* extension 0..0

// Originally defined on lines 67 - 78
Extension: CircadianPhase
Parent: Extension
Id: circadian-phase
Title: "Circadian Phase Extension"
Description: "Indicator of position in circadian rhythm cycle"
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from CircadianPhaseVS (required)
* extension 0..0

// Originally defined on lines 80 - 86
ValueSet: CircadianPhaseVS
Id: circadian-phase-vs
Title: "Circadian Phase Value Set"
Description: "Value set for circadian rhythm phases"
* ^experimental = true
* include codes from system CircadianPhaseCS

// Originally defined on lines 88 - 101
CodeSystem: CircadianPhaseCS
Id: circadian-phase-cs
Title: "Circadian Phase Code System"
Description: "Code system for circadian rhythm phases"
* ^experimental = true
* ^caseSensitive = true
* #early-morning "Early Morning Phase" "Period shortly after awakening"
* #mid-morning "Mid Morning Phase" "Mid-morning period"
* #afternoon "Afternoon Phase" "Afternoon period"
* #evening "Evening Phase" "Evening period"
* #night "Night Phase" "Nighttime period"
* #deep-night "Deep Night Phase" "Deep night period"

// Originally defined on lines 103 - 114
Extension: MeasurementQuality
Parent: Extension
Id: measurement-quality
Title: "Measurement Quality Extension"
Description: "Indicator of the quality and reliability of the measurement"
* ^version = "0.1.0"
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Observation"
* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementQualityVS (required)
* extension 0..0

// Originally defined on lines 116 - 122
ValueSet: MeasurementQualityVS
Id: measurement-quality-vs
Title: "Measurement Quality Value Set"
Description: "Value set for measurement quality indicators"
* ^experimental = true
* include codes from system MeasurementQualityCS

// Originally defined on lines 124 - 136
CodeSystem: MeasurementQualityCS
Id: measurement-quality-cs
Title: "Measurement Quality Code System"
Description: "Code system for measurement quality indicators"
* ^experimental = true
* ^caseSensitive = true
* #excellent "Excellent Quality" "High quality measurement with minimal noise"
* #good "Good Quality" "Good quality measurement with acceptable noise"
* #fair "Fair Quality" "Fair quality measurement with some interference"
* #poor "Poor Quality" "Poor quality measurement with significant interference"
* #unreliable "Unreliable" "Unreliable measurement requiring verification"

