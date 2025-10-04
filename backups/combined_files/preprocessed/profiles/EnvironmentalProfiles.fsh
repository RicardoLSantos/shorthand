Alias: $SCT = http://snomed.info/sct
Alias: $LOINC = http://loinc.org
Alias: $UCUM = http://unitsofmeasure.org

// Originally defined on lines 5 - 23
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
* category 1..1
* category MS
* category = http://terminology.hl7.org/CodeSystem/observation-category#environment
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

// Originally defined on lines 25 - 62
Profile: NoiseExposureObservation
Parent: EnvironmentalObservation
Id: noise-exposure-observation
Title: "Noise Exposure Observation Profile"
Description: "Profile for noise exposure measurements from iOS Health App"
* code = http://loinc.org#28573-7 "Noise exposure time"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "Noise exposure components"
* component ^definition = "Components of noise exposure measurement"
* component contains
    level 0.. and
    duration 0.. and
    peakLevel 0.. and
    backgroundNoise 0..
* component[level] 1..1
* component[level] MS
* component[duration] 1..1
* component[duration] MS
* component[peakLevel] 0..1
* component[peakLevel] MS
* component[backgroundNoise] 0..1
* component[backgroundNoise] MS
* component[level].code = http://loinc.org#89020-2 "Environmental noise average"
* component[level].valueQuantity.system = "http://unitsofmeasure.org"
* component[level].valueQuantity.code = #dB
* component[level].valueQuantity ^short = "Noise level in decibels"
* component[duration].code = http://loinc.org#89021-0 "Environmental noise duration"
* component[duration].valueQuantity.system = "http://unitsofmeasure.org"
* component[duration].valueQuantity.code = #min
* component[duration].valueQuantity ^short = "Duration of exposure"
* component[peakLevel].code = http://loinc.org#89024-4 "Peak sound level"
* component[peakLevel].valueQuantity.system = "http://unitsofmeasure.org"
* component[peakLevel].valueQuantity.code = #dB
* component[peakLevel].valueQuantity ^short = "Peak noise level"
* component[backgroundNoise].code = http://loinc.org#89025-1 "Background noise level"
* component[backgroundNoise].valueQuantity.system = "http://unitsofmeasure.org"
* component[backgroundNoise].valueQuantity.code = #dB
* component[backgroundNoise].valueQuantity ^short = "Background noise level"

// Originally defined on lines 64 - 100
Profile: UVExposureObservation
Parent: EnvironmentalObservation
Id: uv-exposure-observation
Title: "UV Exposure Observation Profile"
Description: "Profile for UV exposure measurements from iOS Health App"
* code = http://loinc.org#28574-5 "UV exposure"
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "UV exposure components"
* component ^definition = "Components of UV exposure measurement"
* component contains
    index 0.. and
    duration 0.. and
    timeOfDay 0.. and
    intensity 0..
* component[index] 1..1
* component[index] MS
* component[duration] 1..1
* component[duration] MS
* component[timeOfDay] 0..1
* component[timeOfDay] MS
* component[intensity] 0..1
* component[intensity] MS
* component[index].code = http://loinc.org#89022-8 "UV index"
* component[index].valueQuantity.system = "http://unitsofmeasure.org"
* component[index].valueQuantity.code = #{index}
* component[index].valueQuantity ^short = "UV index value"
* component[duration].code = http://loinc.org#89023-6 "UV exposure duration"
* component[duration].valueQuantity.system = "http://unitsofmeasure.org"
* component[duration].valueQuantity.code = #min
* component[duration].valueQuantity ^short = "Duration of UV exposure"
* component[timeOfDay].code = http://loinc.org#89026-9 "Time of exposure"
* component[timeOfDay].valueDateTime 1..1
* component[timeOfDay].valueDateTime ^short = "Time of UV exposure"
* component[intensity].code = http://loinc.org#89027-7 "UV intensity"
* component[intensity].valueQuantity.system = "http://unitsofmeasure.org"
* component[intensity].valueQuantity.code = #W/m2
* component[intensity].valueQuantity ^short = "UV radiation intensity"

// Originally defined on lines 102 - 108
Extension: EnvironmentalContext
Parent: Extension
Id: environmental-context
Title: "Environmental Context Extension"
Description: "Additional context about environmental measurements"
* value[x] only CodeableConcept
* valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/environmental-context (required)
* extension 0..0

