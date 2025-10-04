Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

Profile: EnvironmentalObservation
Parent: Observation
Id: environmental-observation
Title: "Environmental Observation Profile"
Description: "Base profile for environmental measurements from iOS Health App"

* ^version = "0.1.0"
* ^status = #draft
* ^publisher = "HL7 International"
* ^contact.name = "Environmental Health Working Group"

* status MS
* category 1..1 MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#survey
* subject 1..1 MS
* effectiveDateTime 1..1 MS
* device 0..1 MS
* method 0..1 MS
* note 0..* MS

Profile: NoiseExposureObservation
Parent: EnvironmentalObservation
Id: noise-exposure-observation
Title: "Noise Exposure Observation Profile"
Description: "Profile for noise exposure measurements from iOS Health App"

* code = $LIFESTYLEOBS#noise-duration "Environmental noise exposure duration"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "Noise exposure components"
* component ^definition = "Components of noise exposure measurement"

* component contains
    level 1..1 MS and
    duration 1..1 MS and
    peakLevel 0..1 MS and
    backgroundNoise 0..1 MS

* component[level].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-avg "Environmental noise average level"
* component[level].valueQuantity.system = $UCUM
* component[level].valueQuantity.code = #dB
* component[level].valueQuantity ^short = "Noise level in decibels"

* component[duration].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-duration "Environmental noise exposure duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min
* component[duration].valueQuantity ^short = "Duration of exposure"

* component[peakLevel].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-peak "Peak environmental sound level"
* component[peakLevel].valueQuantity.system = $UCUM
* component[peakLevel].valueQuantity.code = #dB
* component[peakLevel].valueQuantity ^short = "Peak noise level"

* component[backgroundNoise].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#noise-background "Background environmental noise level"
* component[backgroundNoise].valueQuantity.system = $UCUM
* component[backgroundNoise].valueQuantity.code = #dB
* component[backgroundNoise].valueQuantity ^short = "Background noise level"

Profile: UVExposureObservation
Parent: EnvironmentalObservation
Id: uv-exposure-observation
Title: "UV Exposure Observation Profile"
Description: "Profile for UV exposure measurements from iOS Health App"

* code = $LIFESTYLEOBS#uv-duration "UV exposure duration"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "UV exposure components"
* component ^definition = "Components of UV exposure measurement"

* component contains
    index 1..1 MS and
    duration 1..1 MS and
    timeOfDay 0..1 MS and
    intensity 0..1 MS

* component[index].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-index "UV index"
* component[index].valueQuantity.system = $UCUM
* component[index].valueQuantity.code = #1
* component[index].valueQuantity ^short = "UV index value"

* component[duration].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-duration "UV exposure duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min
* component[duration].valueQuantity ^short = "Duration of UV exposure"

* component[timeOfDay].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#exposure-time "Time of environmental exposure"
* component[timeOfDay].valueDateTime 1..1
* component[timeOfDay].valueDateTime ^short = "Time of UV exposure"

* component[intensity].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs#uv-intensity "UV intensity"
* component[intensity].valueQuantity.system = $UCUM
* component[intensity].valueQuantity.code = #W/m2
* component[intensity].valueQuantity ^short = "UV radiation intensity"

Extension: EnvironmentalContext
Id: environmental-context
Title: "Environmental Context Extension"
Description: "Additional context about environmental measurements"

* ^context[0].type = #element
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/environmental-context-vs (required)
