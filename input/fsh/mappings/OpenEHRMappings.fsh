// openEHR archetype mappings for the wearable-derived profiles.
//
// Each block maps the elements of one FHIR profile to the paths of one openEHR
// archetype (ADL 1.4). Paths and node identifiers (at000N) are read from the
// archetype definitions; they are not written from memory. The Mapping only
// records structural correspondence: it does not change any binding, slice or
// cardinality of the profiles.
//
// Archetype path conventions: /data[at0001]/events[at0002]/data[at0003]/items[...]
// is the event data tree of an OBSERVATION; /data[...]/events[...]/state[...] the
// event state; /protocol[...] the observation protocol. An ELEMENT's value sits
// under /value. RM attributes without a node id (for example EVENT.time) are
// given by attribute name.

// ---------------------------------------------------------------------------
// Heart rate variability: one FHIR Observation carries one metric (selected by
// code); the archetype groups every metric of a recording under one OBSERVATION.
// Observation.referenceRange (personal baseline range) has no archetype node.
// ---------------------------------------------------------------------------
Mapping: HRVToOpenEHR
Id: hrv-to-openehr
Title: "Mapping to openEHR archetype heart_rate_variability"
Source: HeartRateVariabilityObservation
Target: "openEHR-EHR-OBSERVATION.heart_rate_variability.v0"
Description: "Element-level mapping to openEHR-EHR-OBSERVATION.heart_rate_variability.v0 (ADL 1.4). One Observation maps to one ELEMENT of the archetype's event data tree, selected by Observation.code; the OBSERVATION groups all metrics of one recording. Observation.referenceRange has no archetype counterpart."

* -> "openEHR-EHR-OBSERVATION.heart_rate_variability.v0" "OBSERVATION[at0000] Heart rate variability"
* code -> "/data[at0001]/events[at0002]/data[at0003]/items[at0004]" "LOINC 80404-7 or hrv-sdnn: SDNN"
* code -> "/data[at0001]/events[at0002]/data[at0003]/items[at0005]" "hrv-rmssd: RMSSD"
* code -> "/data[at0001]/events[at0002]/data[at0003]/items[at0006]" "hrv-pnn50: pNN50"
* code -> "/data[at0001]/events[at0002]/data[at0003]/items[at0009]/items[at0010]" "hrv-lf-power: LF Power (Spectral analysis cluster)"
* code -> "/data[at0001]/events[at0002]/data[at0003]/items[at0009]/items[at0011]" "hrv-hf-power: HF Power (Spectral analysis cluster)"
* code -> "/data[at0001]/events[at0002]/data[at0003]/items[at0009]/items[at0012]" "hrv-lf-hf-ratio: LF/HF Ratio (Spectral analysis cluster)"
* valueQuantity -> "/data[at0001]/events[at0002]/data[at0003]/items[at0004|at0005]/value" "DV_QUANTITY of SDNN or RMSSD (ms); pNN50 is a DV_PROPORTION at items[at0006]/value"
* valueQuantity -> "/data[at0001]/events[at0002]/data[at0003]/items[at0009]/items[at0010|at0011|at0012]/value" "DV_QUANTITY of LF Power, HF Power (ms2) or LF/HF Ratio (1) in the Spectral analysis cluster"
* effective[x] -> "/data[at0001]/events[at0002]/time" "EVENT.time (RM attribute); the length of an effectivePeriod also populates Recording duration at /data[at0001]/events[at0002]/data[at0003]/items[at0031]"
* method -> "/data[at0001]/events[at0002]/data[at0003]/items[at0009]/items[at0015]" "Spectral method (FFT, autoregressive, Welch periodogram, Lomb-Scargle); frequency-domain metrics only"
* device -> "/protocol[at0049]/items[at0050]" "Device type"
* device -> "/protocol[at0049]/items[at0056]" "Device details: slot for openEHR-EHR-CLUSTER.device"
* interpretation -> "/data[at0001]/events[at0002]/data[at0003]/items[at0032]" "Clinical interpretation (free text in the archetype; coded deviation from the personal baseline in FHIR)"
* note -> "/data[at0001]/events[at0002]/data[at0003]/items[at0033]" "Comment"
* extension[measurementContext] -> "/data[at0001]/events[at0002]/state[at0039]/items[at0040]" "Physiological state (resting sitting or supine, active, sleep, post-exercise recovery)"

// ---------------------------------------------------------------------------
// VO2max estimation: the profile's value and components map one-to-one onto
// the archetype's data, state and protocol trees. The confidence-interval
// bounds (confidenceLower, confidenceUpper), the reference standard, the
// cardiovascular-risk category and the MET capacity have no archetype node.
// ---------------------------------------------------------------------------
Mapping: VO2MaxToOpenEHR
Id: vo2max-to-openehr
Title: "Mapping to openEHR archetype vo2max_estimation"
Source: VO2MaxEstimationObservation
Target: "openEHR-EHR-OBSERVATION.vo2max_estimation.v0"
Description: "Element-level mapping to openEHR-EHR-OBSERVATION.vo2max_estimation.v0 (ADL 1.4). Components without an archetype node: confidenceLower, confidenceUpper, classificationStandard, cvRiskCategory, metCapacity."

* -> "openEHR-EHR-OBSERVATION.vo2max_estimation.v0" "OBSERVATION[at0000] VO2max estimation"
* valueQuantity -> "/data[at0001]/events[at0002]/data[at0003]/items[at0004]/value" "VO2max estimate"
* component[crfCategory] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0005]" "Fitness level classification"
* component[percentileRank] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0006]" "Age-adjusted percentile"
* component[fitnessAge] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0007]" "Fitness age"
* component[methodType] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0008]" "Estimation method"
* component[estimationAccuracy] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0009]" "Confidence level"
* component[changeFromBaseline] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0010]" "Change from baseline"
* component[vo2maxTrend] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0011]" "Trend"
* note -> "/data[at0001]/events[at0002]/data[at0003]/items[at0012]" "Comment"
* component[specificProtocol] -> "/data[at0001]/events[at0002]/state[at0020]/items[at0021]" "Test activity type"
* component[restingHRUsed] -> "/protocol[at0030]/items[at0033]" "Inputs used"
* component[maxHRUsed] -> "/protocol[at0030]/items[at0033]" "Inputs used"
* component[dataSource] -> "/protocol[at0030]/items[at0033]" "Inputs used"
* device -> "/protocol[at0030]/items[at0034]" "Device details: slot for openEHR-EHR-CLUSTER.device"
* effective[x] -> "/data[at0001]/events[at0002]/time" "EVENT.time (RM attribute)"

// ---------------------------------------------------------------------------
// Sleep: the profile is a panel of components; the archetype is one nightly
// INTERVAL_EVENT with a stage cluster and a physiology cluster.
// ---------------------------------------------------------------------------
Mapping: SleepToOpenEHR
Id: sleep-to-openehr
Title: "Mapping to openEHR archetype sleep_architecture"
Source: SleepObservation
Target: "openEHR-EHR-OBSERVATION.sleep_architecture.v0"
Description: "Element-level mapping to openEHR-EHR-OBSERVATION.sleep_architecture.v0 (ADL 1.4). The heartRateVariability component is fixed to LOINC 80404-7 (SDNN) while the archetype node at0052 records the average RMSSD: the correspondence is by role (sleep HRV), not by metric, and is recorded as such."

* -> "openEHR-EHR-OBSERVATION.sleep_architecture.v0" "OBSERVATION[at0000] Sleep architecture"
* effectivePeriod -> "/data[at0001]/events[at0079]" "INTERVAL_EVENT Nightly sleep (time and width); start and end also populate Bedtime /data[at0001]/events[at0002]/data[at0003]/items[at0009] and Wake time items[at0010]"
* component[timeInBed] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0011]" "Time in bed"
* component[totalSleepTime] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0012]" "Total sleep time"
* component[lightSleep] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0019]/items[at0021]" "Light sleep duration (Sleep stages cluster)"
* component[deepSleep] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0019]/items[at0022]" "Deep sleep duration (Sleep stages cluster)"
* component[remSleep] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0019]/items[at0023]" "REM sleep duration (Sleep stages cluster)"
* component[interruptions] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0030]" "Number of awakenings"
* component[heartRateVariability] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0049]/items[at0052]" "Average HRV (RMSSD) in the Sleep physiology cluster; the FHIR component carries SDNN (LOINC 80404-7): same role, different metric"
* component[respiratoryRate] -> "/data[at0001]/events[at0002]/data[at0003]/items[at0049]/items[at0054]" "Respiratory rate (Sleep physiology cluster)"
* device -> "/protocol[at0089]/items[at0091]" "Wearable device: slot for openEHR-EHR-CLUSTER.wearable_device"

// ---------------------------------------------------------------------------
// Wearable devices: the physical sensor maps to the identity elements of the
// wearable_device CLUSTER; the software data source maps to its platform and
// version elements. Sensors-available, wearing location, sync and data-quality
// elements have no counterpart in the FHIR Device profiles.
// ---------------------------------------------------------------------------
Mapping: WearableSensorDeviceToOpenEHR
Id: wearable-sensor-device-to-openehr
Title: "Mapping to openEHR archetype wearable_device"
Source: WearableSensorDevice
Target: "openEHR-EHR-CLUSTER.wearable_device.v0"
Description: "Element-level mapping of the physical sensor device to openEHR-EHR-CLUSTER.wearable_device.v0 (ADL 1.4)."

* -> "openEHR-EHR-CLUSTER.wearable_device.v0" "CLUSTER[at0000] Wearable device"
* type -> "/items[at0003]" "Device category (the MDC device specialisation is more granular than the archetype's category)"
* manufacturer -> "/items[at0001]" "Device platform"
* modelNumber -> "/items[at0002]" "Device model"
* serialNumber -> "/items[at0022]" "Serial number"
* version -> "/items[at0019]" "Firmware version"

Mapping: WearableDataSourceToOpenEHR
Id: wearable-data-source-to-openehr
Title: "Mapping to openEHR archetype wearable_device"
Source: WearableDataSource
Target: "openEHR-EHR-CLUSTER.wearable_device.v0"
Description: "Element-level mapping of the software data source (application or platform) to the platform, application-version and export elements of openEHR-EHR-CLUSTER.wearable_device.v0 (ADL 1.4). The physical device it read from is the parent Device, mapped by WearableSensorDeviceToOpenEHR."

* -> "openEHR-EHR-CLUSTER.wearable_device.v0" "CLUSTER[at0000] Wearable device (software facet)"
* deviceName -> "/items[at0001]" "Device platform"
* version -> "/items[at0020]" "App version"
* version -> "/items[at0021]" "API version, when the version names the platform API"
* parent -> "/items[at0002]" "Device model of the physical sensor (via the parent Device)"
