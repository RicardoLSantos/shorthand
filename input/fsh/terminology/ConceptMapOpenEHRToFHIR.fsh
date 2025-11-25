// ConceptMap: openEHR Archetype Elements → FHIR
// Created: 2025-11-25
// Author: Ricardo Lourenco dos Santos (ricardolourencosantos@gmail.com)
// Links: https://linktr.ee/ricardolsantos
// Purpose: Enable bidirectional mapping between openEHR archetypes and FHIR resources
// Context: PhD Thesis - Integrating Wearable Biomarkers into Learning Health Systems

Instance: ConceptMapOpenEHRToFHIR
InstanceOf: ConceptMap
Title: "openEHR Archetype to FHIR Resource Mapping"
Description: "Maps openEHR archetype elements for wearable lifestyle medicine data to FHIR resource elements. Enables semantic interoperability via NUM-FHIR-Bridge or similar transformation layers."
Usage: #definition

* url = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ConceptMap/ConceptMapOpenEHRToFHIR"
* version = "0.1.0"
* name = "ConceptMapOpenEHRToFHIR"
* title = "openEHR Archetype to FHIR Resource Mapping"
* status = #active
* experimental = false
* date = "2025-11-25"
* publisher = "Ricardo Lourenço dos Santos"
* contact.name = "Ricardo L. Santos"
* contact.telecom.system = #email
* contact.telecom.value = "ricardolourencosantos@gmail.com"
* description = """
Bidirectional mapping between custom openEHR archetypes for wearable lifestyle medicine data and FHIR R4 resources.

Supported openEHR Archetypes:
- OBSERVATION.heart_rate_variability.v0 → Observation (vital-signs)
- OBSERVATION.physical_activity_detailed.v0 → Observation (physical-activity)
- OBSERVATION.sleep_architecture.v0 → Observation (sleep-analysis)
- CLUSTER.wearable_device.v0 → Device

Architecture:
- Uses FHIRconnect triple-layer pattern (Kohler et al., 2025)
- Compatible with NUM-FHIR-Bridge Apache Camel routes
- Supports EHRbase CDR as source system
"""
* purpose = "Enable round-trip data transformation between openEHR Clinical Data Repositories (CDRs) and FHIR servers for wearable health data in Learning Health Systems."

// ARCHITECTURE NOTE (2025-11-25):
// sourceUri/targetUri removed - http://hl7.org/fhir is a conceptual namespace,
// not a resolvable terminology for tx.fhir.org validation.
// Source/target defined at group level using Archetype/StructureDefinition IDs.

// ============================================================================
// GROUP 1: HRV Archetype → FHIR Observation
// ============================================================================
* group[0].source = "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"
* group[0].target = "http://hl7.org/fhir/StructureDefinition/Observation"
* group[0].unmapped.mode = #fixed
* group[0].unmapped.code = #other
* group[0].unmapped.display = "Unmapped HRV element"

// SDNN (id5) → Observation.component (LOINC 80404-7)
* group[0].element[0].code = #id5
* group[0].element[0].display = "SDNN - Standard deviation of NN intervals"
* group[0].element[0].target[0].code = #Observation.component
* group[0].element[0].target[0].display = "Observation.component[sdnn].valueQuantity"
* group[0].element[0].target[0].equivalence = #equivalent
* group[0].element[0].target[0].comment = "Map to component with code LOINC 80404-7. Unit: ms"

// RMSSD (id6) → Observation.component (custom code)
* group[0].element[1].code = #id6
* group[0].element[1].display = "RMSSD - Root mean square of successive differences"
* group[0].element[1].target[0].code = #Observation.component
* group[0].element[1].target[0].display = "Observation.component[rmssd].valueQuantity"
* group[0].element[1].target[0].equivalence = #equivalent
* group[0].element[1].target[0].comment = "Map to component with HeartRateVariabilityCS#hrv-rmssd. No LOINC code available. Unit: ms"

// pNN50 (id7) → Observation.component
* group[0].element[2].code = #id7
* group[0].element[2].display = "pNN50 - Percentage of NN intervals >50ms"
* group[0].element[2].target[0].code = #Observation.component
* group[0].element[2].target[0].display = "Observation.component[pnn50].valueQuantity"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[2].target[0].comment = "Map to component with HeartRateVariabilityCS#hrv-pnn50. Unit: %"

// LF/HF Ratio (id13) → Observation.component
* group[0].element[3].code = #id13
* group[0].element[3].display = "LF/HF Ratio"
* group[0].element[3].target[0].code = #Observation.component
* group[0].element[3].target[0].display = "Observation.component[lf-hf-ratio].valueQuantity"
* group[0].element[3].target[0].equivalence = #equivalent
* group[0].element[3].target[0].comment = "Map to component with HeartRateVariabilityCS#hrv-lf-hf-ratio. Dimensionless ratio"

// Recording duration (id32) → Observation.component or effectivePeriod
* group[0].element[4].code = #id32
* group[0].element[4].display = "Recording duration"
* group[0].element[4].target[0].code = #Observation.effectivePeriod
* group[0].element[4].target[0].display = "Observation.effectivePeriod (start/end)"
* group[0].element[4].target[0].equivalence = #relatedto
* group[0].element[4].target[0].comment = "Duration derived from effectivePeriod.end - effectivePeriod.start"

// Physiological state (id41) → Observation.component (context)
* group[0].element[5].code = #id41
* group[0].element[5].display = "Physiological state"
* group[0].element[5].target[0].code = #Observation.component
* group[0].element[5].target[0].display = "Observation.component[state].valueCodeableConcept"
* group[0].element[5].target[0].equivalence = #equivalent
* group[0].element[5].target[0].comment = "Map resting/active/sleep states to component with custom code"

// Device type (id51) → Observation.device reference
* group[0].element[6].code = #id51
* group[0].element[6].display = "Device type"
* group[0].element[6].target[0].code = #Observation.device
* group[0].element[6].target[0].display = "Observation.device → Device reference"
* group[0].element[6].target[0].equivalence = #relatedto
* group[0].element[6].target[0].comment = "Reference to Device resource with wearable details"

// ============================================================================
// GROUP 2: Physical Activity Archetype → FHIR Observation
// ============================================================================
* group[1].source = "openEHR-EHR-OBSERVATION.physical_activity_detailed.v0"
* group[1].target = "http://hl7.org/fhir/StructureDefinition/Observation"

// Step count (id10) → Observation.valueQuantity
* group[1].element[0].code = #id10
* group[1].element[0].display = "Step count"
* group[1].element[0].target[0].code = #Observation.valueQuantity
* group[1].element[0].target[0].display = "Observation.valueQuantity"
* group[1].element[0].target[0].equivalence = #equivalent
* group[1].element[0].target[0].comment = "Primary value when code is LOINC 55423-8 (Number of steps). Unit: steps"

// Distance (id11) → Observation.component
* group[1].element[1].code = #id11
* group[1].element[1].display = "Distance"
* group[1].element[1].target[0].code = #Observation.component
* group[1].element[1].target[0].display = "Observation.component[distance].valueQuantity"
* group[1].element[1].target[0].equivalence = #equivalent
* group[1].element[1].target[0].comment = "Map to component with LOINC 55430-3. Unit: km or m"

// Active calories (id20) → Observation.component
* group[1].element[2].code = #id20
* group[1].element[2].display = "Active calories"
* group[1].element[2].target[0].code = #Observation.component
* group[1].element[2].target[0].display = "Observation.component[active-calories].valueQuantity"
* group[1].element[2].target[0].equivalence = #equivalent
* group[1].element[2].target[0].comment = "Map to component with LOINC 41979-6. Unit: kcal"

// Moderate activity minutes (id32) → Observation.component
* group[1].element[3].code = #id32
* group[1].element[3].display = "Moderately active minutes"
* group[1].element[3].target[0].code = #Observation.component
* group[1].element[3].target[0].display = "Observation.component[moderate-minutes].valueQuantity"
* group[1].element[3].target[0].equivalence = #equivalent
* group[1].element[3].target[0].comment = "Map to component with LOINC 77592-4. Unit: min"

// Vigorous activity minutes (id33) → Observation.component
* group[1].element[4].code = #id33
* group[1].element[4].display = "Vigorously active minutes"
* group[1].element[4].target[0].code = #Observation.component
* group[1].element[4].target[0].display = "Observation.component[vigorous-minutes].valueQuantity"
* group[1].element[4].target[0].equivalence = #equivalent
* group[1].element[4].target[0].comment = "Map to component with LOINC 77593-2. Unit: min"

// ============================================================================
// GROUP 3: Sleep Architecture Archetype → FHIR Observation
// ============================================================================
* group[2].source = "openEHR-EHR-OBSERVATION.sleep_architecture.v0"
* group[2].target = "http://hl7.org/fhir/StructureDefinition/Observation"

// Total sleep time (id13) → Observation.valueQuantity
* group[2].element[0].code = #id13
* group[2].element[0].display = "Total sleep time"
* group[2].element[0].target[0].code = #Observation.valueQuantity
* group[2].element[0].target[0].display = "Observation.valueQuantity"
* group[2].element[0].target[0].equivalence = #equivalent
* group[2].element[0].target[0].comment = "Primary value when code is LOINC 93832-4 (Sleep duration). Unit: h or min"

// Deep sleep duration (id23) → Observation.component
* group[2].element[1].code = #id23
* group[2].element[1].display = "Deep sleep duration"
* group[2].element[1].target[0].code = #Observation.component
* group[2].element[1].target[0].display = "Observation.component[deep-sleep].valueQuantity"
* group[2].element[1].target[0].equivalence = #equivalent
* group[2].element[1].target[0].comment = "N3/SWS stage duration. Custom code required - no LOINC"

// REM sleep duration (id24) → Observation.component
* group[2].element[2].code = #id24
* group[2].element[2].display = "REM sleep duration"
* group[2].element[2].target[0].code = #Observation.component
* group[2].element[2].target[0].display = "Observation.component[rem-sleep].valueQuantity"
* group[2].element[2].target[0].equivalence = #equivalent
* group[2].element[2].target[0].comment = "REM stage duration. Custom code required - no LOINC"

// Sleep efficiency (id30) → Observation.component
* group[2].element[3].code = #id30
* group[2].element[3].display = "Sleep efficiency"
* group[2].element[3].target[0].code = #Observation.component
* group[2].element[3].target[0].display = "Observation.component[efficiency].valueQuantity"
* group[2].element[3].target[0].equivalence = #equivalent
* group[2].element[3].target[0].comment = "TST/TIB ratio as percentage. Custom code required - no LOINC"

// Sleep score (id40) → Observation.component
* group[2].element[4].code = #id40
* group[2].element[4].display = "Sleep score"
* group[2].element[4].target[0].code = #Observation.component
* group[2].element[4].target[0].display = "Observation.component[score].valueInteger"
* group[2].element[4].target[0].equivalence = #equivalent
* group[2].element[4].target[0].comment = "Vendor-specific composite score (0-100). Proprietary algorithm"

// Average HRV during sleep (id53) → Observation.component
* group[2].element[5].code = #id53
* group[2].element[5].display = "Average HRV (RMSSD) during sleep"
* group[2].element[5].target[0].code = #Observation.component
* group[2].element[5].target[0].display = "Observation.component[sleep-hrv].valueQuantity"
* group[2].element[5].target[0].equivalence = #equivalent
* group[2].element[5].target[0].comment = "Use HeartRateVariabilityCS#hrv-rmssd with context. Unit: ms"

// ============================================================================
// GROUP 4: Wearable Device Cluster → FHIR Device
// ============================================================================
* group[3].source = "openEHR-EHR-CLUSTER.wearable_device.v0"
* group[3].target = "http://hl7.org/fhir/StructureDefinition/Device"

// Device platform (id2) → Device.manufacturer
* group[3].element[0].code = #id2
* group[3].element[0].display = "Device platform"
* group[3].element[0].target[0].code = #Device.manufacturer
* group[3].element[0].target[0].display = "Device.manufacturer"
* group[3].element[0].target[0].equivalence = #equivalent
* group[3].element[0].target[0].comment = "Map vendor code to manufacturer string (Apple, Fitbit, Garmin, etc.)"

// Device model (id3) → Device.modelNumber
* group[3].element[1].code = #id3
* group[3].element[1].display = "Device model"
* group[3].element[1].target[0].code = #Device.modelNumber
* group[3].element[1].target[0].display = "Device.modelNumber"
* group[3].element[1].target[0].equivalence = #equivalent
* group[3].element[1].target[0].comment = "Specific model name"

// Device category (id4) → Device.type
* group[3].element[2].code = #id4
* group[3].element[2].display = "Device category"
* group[3].element[2].target[0].code = #Device.type
* group[3].element[2].target[0].display = "Device.type"
* group[3].element[2].target[0].equivalence = #equivalent
* group[3].element[2].target[0].comment = "Map to SNOMED CT device type codes where available"

// Serial number (id23) → Device.serialNumber
* group[3].element[3].code = #id23
* group[3].element[3].display = "Serial number"
* group[3].element[3].target[0].code = #Device.serialNumber
* group[3].element[3].target[0].display = "Device.serialNumber"
* group[3].element[3].target[0].equivalence = #equivalent

// Firmware version (id20) → Device.version
* group[3].element[4].code = #id20
* group[3].element[4].display = "Firmware version"
* group[3].element[4].target[0].code = #Device.version
* group[3].element[4].target[0].display = "Device.version[firmware]"
* group[3].element[4].target[0].equivalence = #equivalent
* group[3].element[4].target[0].comment = "Use version.type = firmware"
