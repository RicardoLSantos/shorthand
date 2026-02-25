// ConceptMap: FHIR → openEHR Archetype Elements (REVERSE MAPPING)
// Created: 2025-11-25
// Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
// Links: https://linktr.ee/ricardolsantos
// Purpose: Enable FHIR to openEHR transformation for wearable data
// Context: PhD Thesis - Integrating Wearable Biomarkers into Learning Health Systems

Instance: ConceptMapFHIRToOpenEHR
InstanceOf: ConceptMap
Title: "FHIR Resource to openEHR Archetype Mapping"
Description: "Maps FHIR R4 resources to custom openEHR archetypes for wearable lifestyle medicine data. Enables data flow from FHIR servers to openEHR CDRs."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapFHIRToOpenEHR"
* version = "0.1.0"
* name = "ConceptMapFHIRToOpenEHR"
* title = "FHIR Resource to openEHR Archetype Mapping"
* status = #active
* experimental = false
* date = "2025-11-25"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "ricardolourencosantos@gmail.com"
* description = """
Reverse mapping from FHIR R4 resources to custom openEHR archetypes for wearable lifestyle medicine data.

Supported FHIR → openEHR mappings:
- Observation (HRV profile) → OBSERVATION.heart_rate_variability.v0
- Observation (activity profile) → OBSERVATION.physical_activity_detailed.v0
- Observation (sleep profile) → OBSERVATION.sleep_architecture.v0
- Device → CLUSTER.wearable_device.v0

Architecture:
- Complements ConceptMapOpenEHRToFHIR for bidirectional transformation
- Compatible with NUM-FHIR-Bridge Apache Camel routes
- Supports EHRbase CDR as target system
"""
* purpose = "Enable data transformation from FHIR servers to openEHR Clinical Data Repositories (CDRs) for wearable health data in Learning Health Systems."

// ARCHITECTURE NOTE (2025-11-25):
// sourceUri/targetUri removed - http://hl7.org/fhir is a conceptual namespace,
// not a resolvable terminology for tx.fhir.org validation.
// Source/target defined at group level using StructureDefinition/Archetype IDs.

// ============================================================================
// GROUP 1: FHIR Observation (HRV) → openEHR HRV Archetype
// ============================================================================
* group[0].source = "http://hl7.org/fhir/StructureDefinition/Observation"
* group[0].target = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #other
* group[0].unmapped.display = "Unmapped FHIR HRV element"

// SDNN component (LOINC 80404-7) → id5
* group[0].element[0].code = #"Observation.component:sdnn"
* group[0].element[0].display = "SDNN component with LOINC 80404-7"
* group[0].element[0].target[0].code = #id5
* group[0].element[0].target[0].display = "SDNN - Standard deviation of NN intervals"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "Map from Observation.component with code LOINC 80404-7. Unit: ms"

// RMSSD component → id6
* group[0].element[1].code = #"Observation.component:rmssd"
* group[0].element[1].display = "RMSSD component with LifestyleMedicineTemporaryCS#hrv-rmssd"
* group[0].element[1].target[0].code = #id6
* group[0].element[1].target[0].display = "RMSSD - Root mean square of successive differences"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[1].target[0].comment = "Map from component with LifestyleMedicineTemporaryCS#hrv-rmssd. No LOINC code. Unit: ms"

// pNN50 component → id7
* group[0].element[2].code = #"Observation.component:pnn50"
* group[0].element[2].display = "pNN50 component with LifestyleMedicineTemporaryCS#hrv-pnn50"
* group[0].element[2].target[0].code = #id7
* group[0].element[2].target[0].display = "pNN50 - Percentage of NN intervals >50ms"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[2].target[0].comment = "Map from component with LifestyleMedicineTemporaryCS#hrv-pnn50. Unit: %"

// LF/HF Ratio component → id13
* group[0].element[3].code = #"Observation.component:lf-hf-ratio"
* group[0].element[3].display = "LF/HF ratio component"
* group[0].element[3].target[0].code = #id13
* group[0].element[3].target[0].display = "LF/HF Ratio"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[3].target[0].comment = "Map from component with LifestyleMedicineTemporaryCS#hrv-lf-hf-ratio. Dimensionless ratio"

// effectivePeriod → id32
* group[0].element[4].code = #Observation.effectivePeriod
* group[0].element[4].display = "Observation.effectivePeriod (start/end)"
* group[0].element[4].target[0].code = #id32
* group[0].element[4].target[0].display = "Recording duration"
* group[0].element[4].target[0].equivalence = #relatedto
* group[0].element[4].target[0].comment = "Calculate duration from effectivePeriod.end - effectivePeriod.start"

// State component → id41
* group[0].element[5].code = #"Observation.component:state"
* group[0].element[5].display = "Physiological state component"
* group[0].element[5].target[0].code = #id41
* group[0].element[5].target[0].display = "Physiological state"
* group[0].element[5].target[0].equivalence = #equivalent
* group[0].element[5].target[0].comment = "Map resting/active/sleep states from component"

// Device reference → id51
* group[0].element[6].code = #Observation.device
* group[0].element[6].display = "Observation.device reference"
* group[0].element[6].target[0].code = #id51
* group[0].element[6].target[0].display = "Device type"
* group[0].element[6].target[0].equivalence = #relatedto
* group[0].element[6].target[0].comment = "Resolve Device reference and map to CLUSTER.wearable_device"

// ============================================================================
// GROUP 2: FHIR Observation (Activity) → openEHR Physical Activity Archetype
// ============================================================================
* group[1].source = "http://hl7.org/fhir/StructureDefinition/Observation"
* group[1].target = "openEHR-EHR-OBSERVATION.physical_activity_detailed.v0"

// Step count → id10
* group[1].element[0].code = #Observation.valueQuantity
* group[1].element[0].display = "Observation.valueQuantity (steps)"
* group[1].element[0].target[0].code = #id10
* group[1].element[0].target[0].display = "Step count"
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "When Observation.code is LOINC 55423-8 (Number of steps). Unit: steps"

// Distance component → id11
* group[1].element[1].code = #"Observation.component:distance"
* group[1].element[1].display = "Distance component with LOINC 55430-3"
* group[1].element[1].target[0].code = #id11
* group[1].element[1].target[0].display = "Distance"
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = "Map from component with LOINC 55430-3. Unit: km or m"

// Active calories component → id20
* group[1].element[2].code = #"Observation.component:active-calories"
* group[1].element[2].display = "Active calories component with LOINC 41979-6"
* group[1].element[2].target[0].code = #id20
* group[1].element[2].target[0].display = "Active calories"
* group[1].element[2].target[0].equivalence = #equivalent
* group[1].element[2].target[0].comment = "Map from component with LOINC 41979-6. Unit: kcal"

// Moderate minutes component → id32
* group[1].element[3].code = #"Observation.component:moderate-minutes"
* group[1].element[3].display = "Moderate activity minutes with LOINC 77592-4"
* group[1].element[3].target[0].code = #id32
* group[1].element[3].target[0].display = "Moderately active minutes"
* group[1].element[3].target[0].equivalence = #equivalent
* group[1].element[3].target[0].comment = "Map from component with LOINC 77592-4. Unit: min"

// Vigorous minutes component → id33
* group[1].element[4].code = #"Observation.component:vigorous-minutes"
* group[1].element[4].display = "Vigorous activity minutes with LOINC 77593-2"
* group[1].element[4].target[0].code = #id33
* group[1].element[4].target[0].display = "Vigorously active minutes"
* group[1].element[4].target[0].equivalence = #equivalent
* group[1].element[4].target[0].comment = "Map from component with LOINC 77593-2. Unit: min"

// ============================================================================
// GROUP 3: FHIR Observation (Sleep) → openEHR Sleep Architecture Archetype
// ============================================================================
* group[2].source = "http://hl7.org/fhir/StructureDefinition/Observation"
* group[2].target = "openEHR-EHR-OBSERVATION.sleep_architecture.v0"

// Total sleep time → id13
* group[2].element[0].code = #Observation.valueQuantity
* group[2].element[0].display = "Observation.valueQuantity (sleep duration)"
* group[2].element[0].target[0].code = #id13
* group[2].element[0].target[0].display = "Total sleep time"
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "When Observation.code is LOINC 93832-4 (Sleep duration). Unit: h or min"

// Deep sleep component → id23
* group[2].element[1].code = #"Observation.component:deep-sleep"
* group[2].element[1].display = "Deep sleep duration component"
* group[2].element[1].target[0].code = #id23
* group[2].element[1].target[0].display = "Deep sleep duration"
* group[2].element[1].target[0].equivalence = #equivalent
* group[2].element[1].target[0].comment = "N3/SWS stage duration. Custom code - no LOINC"

// REM sleep component → id24
* group[2].element[2].code = #"Observation.component:rem-sleep"
* group[2].element[2].display = "REM sleep duration component"
* group[2].element[2].target[0].code = #id24
* group[2].element[2].target[0].display = "REM sleep duration"
* group[2].element[2].target[0].equivalence = #equivalent
* group[2].element[2].target[0].comment = "REM stage duration. Custom code - no LOINC"

// Sleep efficiency component → id30
* group[2].element[3].code = #"Observation.component:efficiency"
* group[2].element[3].display = "Sleep efficiency component"
* group[2].element[3].target[0].code = #id30
* group[2].element[3].target[0].display = "Sleep efficiency"
* group[2].element[3].target[0].equivalence = #equivalent
* group[2].element[3].target[0].comment = "TST/TIB ratio as percentage. Custom code - no LOINC"

// Sleep score component → id40
* group[2].element[4].code = #"Observation.component:score"
* group[2].element[4].display = "Sleep score component"
* group[2].element[4].target[0].code = #id40
* group[2].element[4].target[0].display = "Sleep score"
* group[2].element[4].target[0].equivalence = #equivalent
* group[2].element[4].target[0].comment = "Vendor-specific composite score (0-100). Proprietary algorithm"

// Sleep HRV component → id53
* group[2].element[5].code = #"Observation.component:sleep-hrv"
* group[2].element[5].display = "Average HRV during sleep component"
* group[2].element[5].target[0].code = #id53
* group[2].element[5].target[0].display = "Average HRV (RMSSD) during sleep"
* group[2].element[5].target[0].equivalence = #equivalent
* group[2].element[5].target[0].comment = "Use LifestyleMedicineTemporaryCS#hrv-rmssd with context. Unit: ms"

// ============================================================================
// GROUP 4: FHIR Device → openEHR Wearable Device Cluster
// ============================================================================
* group[3].source = "http://hl7.org/fhir/StructureDefinition/Device"
* group[3].target = "openEHR-EHR-CLUSTER.wearable_device.v0"

// Device.manufacturer → id2
* group[3].element[0].code = #Device.manufacturer
* group[3].element[0].display = "Device.manufacturer"
* group[3].element[0].target[0].code = #id2
* group[3].element[0].target[0].display = "Device platform"
* group[3].element[0].target[0].equivalence = #equivalent
* group[3].element[0].target[0].comment = "Map manufacturer string to vendor code (Apple, Fitbit, Garmin, etc.)"

// Device.modelNumber → id3
* group[3].element[1].code = #Device.modelNumber
* group[3].element[1].display = "Device.modelNumber"
* group[3].element[1].target[0].code = #id3
* group[3].element[1].target[0].display = "Device model"
* group[3].element[1].target[0].equivalence = #equivalent
* group[3].element[1].target[0].comment = "Specific model name"

// Device.type → id4
* group[3].element[2].code = #Device.type
* group[3].element[2].display = "Device.type"
* group[3].element[2].target[0].code = #id4
* group[3].element[2].target[0].display = "Device category"
* group[3].element[2].target[0].equivalence = #equivalent
* group[3].element[2].target[0].comment = "Map from SNOMED CT device type codes where available"

// Device.serialNumber → id23
* group[3].element[3].code = #Device.serialNumber
* group[3].element[3].display = "Device.serialNumber"
* group[3].element[3].target[0].code = #id23
* group[3].element[3].target[0].display = "Serial number"
* group[3].element[3].target[0].equivalence = #equivalent

// Device.version[firmware] → id20
* group[3].element[4].code = #"Device.version:firmware"
* group[3].element[4].display = "Device.version[firmware]"
* group[3].element[4].target[0].code = #id20
* group[3].element[4].target[0].display = "Firmware version"
* group[3].element[4].target[0].equivalence = #equivalent
* group[3].element[4].target[0].comment = "Filter by version.type = firmware"
