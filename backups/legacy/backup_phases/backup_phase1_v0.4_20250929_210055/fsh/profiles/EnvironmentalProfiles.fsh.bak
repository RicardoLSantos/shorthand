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
* category = http://terminology.hl7.org/CodeSystem/observation-category#environment
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

* code = $LOINC#28573-7 "Noise exposure time"
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

* component[level].code = $LOINC#89020-2 "Environmental noise average"
* component[level].valueQuantity.system = $UCUM
* component[level].valueQuantity.code = #dB
* component[level].valueQuantity ^short = "Noise level in decibels"

* component[duration].code = $LOINC#89021-0 "Environmental noise duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min
* component[duration].valueQuantity ^short = "Duration of exposure"

* component[peakLevel].code = $LOINC#89024-4 "Peak sound level"
* component[peakLevel].valueQuantity.system = $UCUM
* component[peakLevel].valueQuantity.code = #dB
* component[peakLevel].valueQuantity ^short = "Peak noise level"

* component[backgroundNoise].code = $LOINC#89025-1 "Background noise level"
* component[backgroundNoise].valueQuantity.system = $UCUM
* component[backgroundNoise].valueQuantity.code = #dB
* component[backgroundNoise].valueQuantity ^short = "Background noise level"

Profile: UVExposureObservation
Parent: EnvironmentalObservation
Id: uv-exposure-observation
Title: "UV Exposure Observation Profile"
Description: "Profile for UV exposure measurements from iOS Health App"

* code = $LOINC#28574-5 "UV exposure"
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

* component[index].code = $LOINC#89022-8 "UV index"
* component[index].valueQuantity.system = $UCUM
* component[index].valueQuantity.code = #{index}
* component[index].valueQuantity ^short = "UV index value"

* component[duration].code = $LOINC#89023-6 "UV exposure duration"
* component[duration].valueQuantity.system = $UCUM
* component[duration].valueQuantity.code = #min
* component[duration].valueQuantity ^short = "Duration of UV exposure"

* component[timeOfDay].code = $LOINC#89026-9 "Time of exposure"
* component[timeOfDay].valueDateTime 1..1
* component[timeOfDay].valueDateTime ^short = "Time of UV exposure"

* component[intensity].code = $LOINC#89027-7 "UV intensity"
* component[intensity].valueQuantity.system = $UCUM
* component[intensity].valueQuantity.code = #W/m2
* component[intensity].valueQuantity ^short = "UV radiation intensity"

Extension: EnvironmentalContext
Id: environmental-context
Title: "Environmental Context Extension"
Description: "Additional context about environmental measurements"

* value[x] only CodeableConcept
* valueCodeableConcept from https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/environmental-context (required)
