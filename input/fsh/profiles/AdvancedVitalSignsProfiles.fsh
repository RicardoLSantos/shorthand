Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

Profile: AdvancedVitalSigns
Parent: Observation
Id: advanced-vital-signs
Title: "Advanced Vital Signs Profile"
Description: "Profile for advanced vital signs data from iOS Health App"

* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "HL7 International"
* ^contact.name = "Advanced Vital Signs Working Group"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code 1..1 MS
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* device 0..1 MS
* method 0..1 MS
* note 0..* MS

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "Advanced vital signs components"
* component ^definition = "Components of advanced vital sign measurements"

* component contains
    hrvSpectral 0..1 MS and
    hrvEntropy 0..1 MS and
    meanArterialPressure 0..1 MS and
    pulseWaveAnalysis 0..1 MS and
    respiratoryVariability 0..1 MS and
    oxygenationIndex 0..1 MS and
    stressIndex 0..1 MS and
    thermalGradient 0..1 MS and
    autonomicBalance 0..1 MS and
    recoveryRate 0..1 MS and
    allostaticLoad 0..1 MS

* component[hrvSpectral].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#hrv-frequency "Heart rate variability frequency band"
* component[hrvSpectral].valueQuantity.system = $UCUM
* component[hrvSpectral].valueQuantity.code = #ms
* component[hrvSpectral] ^short = "Spectral analysis of heart rate variability"

* component[hrvEntropy].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#hrv-entropy "Heart rate variability entropy"
* component[hrvEntropy].valueQuantity.system = $UCUM
* component[hrvEntropy].valueQuantity.code = #{entropy}
* component[hrvEntropy] ^short = "Sample entropy of heart rate variability"

* component[meanArterialPressure].code = $LOINC#8478-0 "Mean blood pressure"
* component[meanArterialPressure].valueQuantity.system = $UCUM
* component[meanArterialPressure].valueQuantity.code = #mm[Hg]
* component[meanArterialPressure] ^short = "Mean arterial blood pressure"

* component[pulseWaveAnalysis].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#pulse-wave "Pulse wave analysis"
* component[pulseWaveAnalysis].valueQuantity.system = $UCUM
* component[pulseWaveAnalysis].valueQuantity.code = #1
* component[pulseWaveAnalysis] ^short = "Analysis of arterial pulse wave"

* component[respiratoryVariability].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#respiratory-variability "Respiratory rate variability"
* component[respiratoryVariability].valueQuantity.system = $UCUM
* component[respiratoryVariability].valueQuantity.code = #{coefficient}
* component[respiratoryVariability] ^short = "Variability in respiratory rate"

* component[oxygenationIndex].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#oxygenation-index "Oxygenation index"
* component[oxygenationIndex].valueQuantity.system = $UCUM
* component[oxygenationIndex].valueQuantity.code = #1
* component[oxygenationIndex] ^short = "Index of blood oxygenation"

* component[stressIndex].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#physiological-stress "Physiological stress index"
* component[stressIndex].valueQuantity.system = $UCUM
* component[stressIndex].valueQuantity.code = #1
* component[stressIndex] ^short = "Index of physiological stress"

* component[thermalGradient].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#temperature-gradient "Temperature gradient"
* component[thermalGradient].valueQuantity.system = $UCUM
* component[thermalGradient].valueQuantity.code = #Cel
* component[thermalGradient] ^short = "Gradient of body temperature"

* component[autonomicBalance].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#autonomic-balance "Autonomic balance index"
* component[autonomicBalance].valueQuantity.system = $UCUM
* component[autonomicBalance].valueQuantity.code = #1
* component[autonomicBalance] ^short = "Balance of autonomic nervous system"

* component[recoveryRate].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#recovery-rate "Recovery rate index"
* component[recoveryRate].valueQuantity.system = $UCUM
* component[recoveryRate].valueQuantity.code = #{rate}
* component[recoveryRate] ^short = "Rate of physiological recovery"

* component[allostaticLoad].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#allostatic-load "Allostatic load index"
* component[allostaticLoad].valueQuantity.system = $UCUM
* component[allostaticLoad].valueQuantity.code = #1
* component[allostaticLoad] ^short = "Measure of cumulative physiological burden"

Extension: AdvancedVitalSignsContext
Id: advanced-vital-signs-context
Title: "Advanced Vital Signs Context Extension"
Description: "Additional context about advanced vital sign measurements"

* ^context[0].type = #element
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from AdvancedVitalSignsContextVS (extensible)

ValueSet: AdvancedVitalSignsContextVS
Id: advanced-vital-signs-context-vs
Title: "Advanced Vital Signs Context Value Set"
Description: "Context codes for advanced vital sign measurements"

* ^experimental = false
* AppLogicCS#resting "Resting state"
* AppLogicCS#vitals-context-active "Active state"
* AppLogicCS#vitals-context-recovery "Recovery state"
* AppLogicCS#activity "Sleep state"
* AppLogicCS#vitals-context-stress "Stress state"
