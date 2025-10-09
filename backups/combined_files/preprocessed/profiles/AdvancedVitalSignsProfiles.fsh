Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

// Originally defined on lines 5 - 98
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
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#vital-signs
* code 1..1
* code MS
* subject 1..1
* subject MS
* effectiveDateTime 1..1
* effectiveDateTime MS
* device 0..1
* device MS
* method 0..1
* method MS
* note 0..*
* note MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "Advanced vital signs components"
* component ^definition = "Components of advanced vital sign measurements"
* component contains
    hrvSpectral 0.. and
    hrvEntropy 0.. and
    meanArterialPressure 0.. and
    pulseWaveAnalysis 0.. and
    respiratoryVariability 0.. and
    oxygenationIndex 0.. and
    stressIndex 0.. and
    thermalGradient 0.. and
    autonomicBalance 0.. and
    recoveryRate 0.. and
    allostaticLoad 0..
* component[hrvSpectral] 0..1
* component[hrvSpectral] MS
* component[hrvEntropy] 0..1
* component[hrvEntropy] MS
* component[meanArterialPressure] 0..1
* component[meanArterialPressure] MS
* component[pulseWaveAnalysis] 0..1
* component[pulseWaveAnalysis] MS
* component[respiratoryVariability] 0..1
* component[respiratoryVariability] MS
* component[oxygenationIndex] 0..1
* component[oxygenationIndex] MS
* component[stressIndex] 0..1
* component[stressIndex] MS
* component[thermalGradient] 0..1
* component[thermalGradient] MS
* component[autonomicBalance] 0..1
* component[autonomicBalance] MS
* component[recoveryRate] 0..1
* component[recoveryRate] MS
* component[allostaticLoad] 0..1
* component[allostaticLoad] MS
* component[hrvSpectral].code = http://loinc.org#87834-8 "Heart rate variability [Frequency band]"
* component[hrvSpectral].valueQuantity.system = "http://unitsofmeasure.org"
* component[hrvSpectral].valueQuantity.code = #ms
* component[hrvSpectral] ^short = "Spectral analysis of heart rate variability"
* component[hrvEntropy].code = http://loinc.org#87835-5 "Heart rate variability entropy"
* component[hrvEntropy].valueQuantity.system = "http://unitsofmeasure.org"
* component[hrvEntropy].valueQuantity.code = #{entropy}
* component[hrvEntropy] ^short = "Sample entropy of heart rate variability"
* component[meanArterialPressure].code = http://loinc.org#8478-0 "Mean blood pressure"
* component[meanArterialPressure].valueQuantity.system = "http://unitsofmeasure.org"
* component[meanArterialPressure].valueQuantity.code = #mmHg
* component[meanArterialPressure] ^short = "Mean arterial blood pressure"
* component[pulseWaveAnalysis].code = http://loinc.org#87836-3 "Pulse wave analysis"
* component[pulseWaveAnalysis].valueQuantity.system = "http://unitsofmeasure.org"
* component[pulseWaveAnalysis].valueQuantity.code = #{index}
* component[pulseWaveAnalysis] ^short = "Analysis of arterial pulse wave"
* component[respiratoryVariability].code = http://loinc.org#87837-1 "Respiratory rate variability"
* component[respiratoryVariability].valueQuantity.system = "http://unitsofmeasure.org"
* component[respiratoryVariability].valueQuantity.code = #{coefficient}
* component[respiratoryVariability] ^short = "Variability in respiratory rate"
* component[oxygenationIndex].code = http://loinc.org#87838-9 "Oxygenation index"
* component[oxygenationIndex].valueQuantity.system = "http://unitsofmeasure.org"
* component[oxygenationIndex].valueQuantity.code = #{ratio}
* component[oxygenationIndex] ^short = "Index of blood oxygenation"
* component[stressIndex].code = http://loinc.org#87839-7 "Physiological stress index"
* component[stressIndex].valueQuantity.system = "http://unitsofmeasure.org"
* component[stressIndex].valueQuantity.code = #{index}
* component[stressIndex] ^short = "Index of physiological stress"
* component[thermalGradient].code = http://loinc.org#87840-5 "Temperature gradient"
* component[thermalGradient].valueQuantity.system = "http://unitsofmeasure.org"
* component[thermalGradient].valueQuantity.code = #Cel
* component[thermalGradient] ^short = "Gradient of body temperature"
* component[autonomicBalance].code = http://loinc.org#87841-3 "Autonomic balance index"
* component[autonomicBalance].valueQuantity.system = "http://unitsofmeasure.org"
* component[autonomicBalance].valueQuantity.code = #{ratio}
* component[autonomicBalance] ^short = "Balance of autonomic nervous system"
* component[recoveryRate].code = http://loinc.org#87842-1 "Recovery rate index"
* component[recoveryRate].valueQuantity.system = "http://unitsofmeasure.org"
* component[recoveryRate].valueQuantity.code = #{rate}
* component[recoveryRate] ^short = "Rate of physiological recovery"
* component[allostaticLoad].code = http://loinc.org#87843-9 "Allostatic load index"
* component[allostaticLoad].valueQuantity.system = "http://unitsofmeasure.org"
* component[allostaticLoad].valueQuantity.code = #{score}
* component[allostaticLoad] ^short = "Measure of cumulative physiological burden"

// Originally defined on lines 100 - 106
Extension: AdvancedVitalSignsContext
Parent: Extension
Id: advanced-vital-signs-context
Title: "Advanced Vital Signs Context Extension"
Description: "Additional context about advanced vital sign measurements"
* value[x] only CodeableConcept
* valueCodeableConcept from AdvancedVitalSignsContextVS (required)
* extension 0..0

// Originally defined on lines 108 - 114
ValueSet: AdvancedVitalSignsContextVS
Id: advanced-vital-signs-context-vs
Title: "Advanced Vital Signs Context Value Set"
Description: "Context codes for advanced vital sign measurements"
* ^experimental = true
* include codes from system AdvancedVitalSignsContextCS

// Originally defined on lines 116 - 128
CodeSystem: AdvancedVitalSignsContextCS
Id: advanced-vital-signs-context-cs
Title: "Advanced Vital Signs Context Code System"
Description: "Codes for advanced vital signs measurement context"
* ^experimental = true
* ^caseSensitive = true
* #resting "Resting state" "Measurement taken during rest"
* #active "Active state" "Measurement taken during activity"
* #recovery "Recovery state" "Measurement taken during recovery"
* #activity "Sleep state" "Measurement taken during activity"
* #stress "Stress state" "Measurement taken during stress"

