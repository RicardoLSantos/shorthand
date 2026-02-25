// Environmental Profiles for iOS Lifestyle Medicine FHIR IG
// Updated: 2026-01-20 - Added headphone audio exposure and dBASPL units
// Reference: Apple HealthKit HKQuantityTypeIdentifier environmental metrics

Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org
Alias: $LIFESTYLEOBS = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs

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

* component[level].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#noise-avg "Environmental noise average level"
* component[level].valueQuantity.system = $UCUM
* component[level].valueQuantity.code = #dB
* component[level].valueQuantity ^short = "Noise level in decibels"

* component[duration].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#noise-duration "Environmental noise exposure duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min
* component[duration].valueQuantity ^short = "Duration of exposure"

* component[peakLevel].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#noise-peak "Peak environmental sound level"
* component[peakLevel].valueQuantity.system = $UCUM
* component[peakLevel].valueQuantity.code = #dB
* component[peakLevel].valueQuantity ^short = "Peak noise level"

* component[backgroundNoise].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#noise-background "Background environmental noise level"
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

* component[index].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#uv-index "UV index"
* component[index].valueQuantity.system = $UCUM
* component[index].valueQuantity.code = #1
* component[index].valueQuantity ^short = "UV index value"

* component[duration].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#uv-duration "UV exposure duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min
* component[duration].valueQuantity ^short = "Duration of UV exposure"

* component[timeOfDay].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#exposure-time "Time of environmental exposure"
* component[timeOfDay].valueDateTime 1..1
* component[timeOfDay].valueDateTime ^short = "Time of UV exposure"

* component[intensity].code = https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs#uv-intensity "UV intensity"
* component[intensity].valueQuantity.system = $UCUM
* component[intensity].valueQuantity.code = #W/m2
* component[intensity].valueQuantity ^short = "UV radiation intensity"

// Audio Exposure Profiles (iOS 13+/14+) - Added 2026-01-20
// These profiles support Apple HealthKit audio exposure metrics

Profile: EnvironmentalAudioExposureObservation
Parent: EnvironmentalObservation
Id: environmental-audio-exposure-observation
Title: "Environmental Audio Exposure Observation Profile"
Description: "Profile for environmental audio exposure measurements from iOS Health App. Maps to HKQuantityTypeIdentifier.environmentalAudioExposure (iOS 13+). Uses A-weighted decibels (dBASPL)."

* code = $LIFESTYLEOBS#environmental-audio-exposure "Environmental audio exposure level"
* valueQuantity 1..1 MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #dB
* valueQuantity ^short = "Environmental audio level in dB(A)"
* valueQuantity ^definition = "Environmental sound exposure level in A-weighted decibels. WHO recommends <70 dB average over 24h to prevent hearing damage"

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    duration 0..1 MS and
    peakLevel 0..1 MS

* component[duration].code = $LIFESTYLEOBS#noise-duration "Environmental noise exposure duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min
* component[duration] ^short = "Exposure duration in minutes"

* component[peakLevel].code = $LIFESTYLEOBS#noise-peak "Peak environmental sound level"
* component[peakLevel].valueQuantity.system = $UCUM
* component[peakLevel].valueQuantity.code = #dB
* component[peakLevel] ^short = "Peak audio level in dB(A)"


Profile: HeadphoneAudioExposureObservation
Parent: EnvironmentalObservation
Id: headphone-audio-exposure-observation
Title: "Headphone Audio Exposure Observation Profile"
Description: "Profile for headphone audio exposure measurements from iOS Health App. Maps to HKQuantityTypeIdentifier.headphoneAudioExposure (iOS 14+). Uses A-weighted decibels (dBASPL)."

* code = $LIFESTYLEOBS#headphone-audio-exposure "Headphone audio exposure level"
* valueQuantity 1..1 MS
* valueQuantity.system = $UCUM
* valueQuantity.code = #dB
* valueQuantity ^short = "Headphone audio level in dB(A)"
* valueQuantity ^definition = "Headphone audio exposure level in A-weighted decibels. WHO recommends <80 dB for max 40 hours/week. Apple notifies at 80 dB for 40h/week or 100 dB for 7 min/day"

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    duration 0..1 MS and
    sevenDayAverage 0..1 MS

* component[duration].code = $LIFESTYLEOBS#noise-duration "Environmental noise exposure duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min
* component[duration] ^short = "Listening duration in minutes"

* component[sevenDayAverage].code = $LIFESTYLEOBS#noise-avg "Environmental noise average level"
* component[sevenDayAverage].valueQuantity.system = $UCUM
* component[sevenDayAverage].valueQuantity.code = #dB
* component[sevenDayAverage] ^short = "7-day average headphone audio level"


// ValueSet for audio exposure metrics
ValueSet: AudioExposureMetricsVS
Id: audio-exposure-metrics-vs
Title: "Audio Exposure Metrics Value Set"
Description: "Value set for audio exposure metrics from Apple HealthKit"
* ^url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/audio-exposure-metrics-vs"
* ^version = "0.1.0"
* ^status = #active
* ^experimental = false

* $LIFESTYLEOBS#environmental-audio-exposure "Environmental audio exposure level"
* $LIFESTYLEOBS#headphone-audio-exposure "Headphone audio exposure level"
* $LIFESTYLEOBS#noise-avg "Environmental noise average level"
* $LIFESTYLEOBS#noise-duration "Environmental noise exposure duration"
* $LIFESTYLEOBS#noise-peak "Peak environmental sound level"
* $LIFESTYLEOBS#noise-background "Background environmental noise level"


Extension: EnvironmentalContext
Id: environmental-context
Title: "Environmental Context Extension"
Description: "Additional context about environmental measurements"

* ^context[0].type = #element
* ^context[0].expression = "Observation"

* value[x] only CodeableConcept
* valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/environmental-context-vs (required)
