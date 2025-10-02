Alias: $UCUM = http://unitsofmeasure.org

Extension: PhysiologicalStressIndex
Id: physiological-stress-index
Title: "Physiological Stress Index Extension"
Description: "Index representing overall physiological stress based on multiple parameters"

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^context[+].type = #element
* ^context[=].expression = "Observation"

* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #1
* valueQuantity ^short = "Physiological stress index value"
* valueQuantity ^definition = "Normalized index value representing overall physiological stress"

Extension: HomeostasisIndex
Id: homeostasis-index
Title: "Homeostasis Index Extension"
Description: "Composite measure of physiological balance and adaptation"

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^context[+].type = #element
* ^context[=].expression = "Observation"

* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #{ratio}
* valueQuantity ^short = "Homeostasis index value"
* valueQuantity ^definition = "Normalized ratio representing physiological balance"

Extension: RecoveryEfficiency
Id: recovery-efficiency
Title: "Recovery Efficiency Extension"
Description: "Measure of how efficiently the body recovers from stress or exertion"

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^context[+].type = #element
* ^context[=].expression = "Observation"

* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #%
* valueQuantity ^short = "Recovery efficiency percentage"
* valueQuantity ^definition = "Percentage indicating recovery efficiency"

Extension: AllostaticLoad
Id: allostatic-load
Title: "Allostatic Load Extension"
Description: "Measure of cumulative physiological burden over time"

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^context[+].type = #element
* ^context[=].expression = "Observation"

* value[x] only Quantity
* valueQuantity.system = $UCUM
* valueQuantity.code = #1
* valueQuantity ^short = "Allostatic load score"
* valueQuantity ^definition = "Score representing cumulative physiological burden"

Extension: CircadianPhase
Id: circadian-phase
Title: "Circadian Phase Extension"
Description: "Indicator of position in circadian rhythm cycle"

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^context[+].type = #element
* ^context[=].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from CircadianPhaseVS (required)

ValueSet: CircadianPhaseVS
Id: circadian-phase-vs
Title: "Circadian Phase Value Set"
Description: "Value set for circadian rhythm phases"

* ^experimental = true
* codes from system CircadianPhaseCS

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

Extension: MeasurementQuality
Id: measurement-quality
Title: "Measurement Quality Extension"
Description: "Indicator of the quality and reliability of the measurement"

* ^version = "0.1.0"
* ^status = #draft
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false
* ^publisher = "2RDoc FMUP"
* ^contact.name = "2RDoc Technical Team"
* ^contact.telecom.system = #email
* ^contact.telecom.value = "fhir@2rdoc.pt"
* ^jurisdiction = http://unstats.un.org/unsd/methods/m49/m49.htm#150 "Europe"
* ^useContext.code = http://terminology.hl7.org/CodeSystem/usage-context-type#program
* ^useContext.valueCodeableConcept.text = "iOS Lifestyle Medicine"
* ^context[+].type = #element
* ^context[=].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from MeasurementQualityVS (required)

ValueSet: MeasurementQualityVS
Id: measurement-quality-vs
Title: "Measurement Quality Value Set"
Description: "Value set for measurement quality indicators"

* ^experimental = true
* codes from system MeasurementQualityCS

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
