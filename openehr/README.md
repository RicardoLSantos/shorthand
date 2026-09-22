# openEHR artefacts distributed with this IG

This folder holds the **12 ADL 1.4 archetypes** that the [openEHR Archetype Catalog](../input/pagecontent/openehr-archetypes-catalog.md) lists as the genuinely original set (§2.1: 9 OBSERVATION + 3 CLUSTER). All are at lifecycle state `in_development`, none has been submitted to the openEHR CKM, and each file carries its own author, date and licence metadata (Creative Commons Attribution-ShareAlike 4.0, as declared in every file; the licence of the archetypes is theirs, not the IG's CC-BY-4.0). The **6 composition templates** the catalog lists in §3 are **not distributed** in this release: they do not validate against the openEHR Operational Template schema (see *Validation status*), so they are withheld until they do.

## Archetypes (`archetypes/`)

| File | RM type | Concept | sha256 (12) |
|---|---|---|---|
| `openEHR-EHR-OBSERVATION.circadian_rhythm.v0.adl` | OBSERVATION | Circadian rhythm | ca0a669aa21f |
| `openEHR-EHR-OBSERVATION.heart_rate_variability.v0.adl` | OBSERVATION | Heart Rate Variability | fadcbe27dc3b |
| `openEHR-EHR-OBSERVATION.lactate_threshold.v0.adl` | OBSERVATION | Lactate threshold | c1ab8b9d43c2 |
| `openEHR-EHR-OBSERVATION.recovery_readiness.v0.adl` | OBSERVATION | Recovery readiness | 24461196dd4f |
| `openEHR-EHR-OBSERVATION.screen_time.v0.adl` | OBSERVATION | Screen time | 6638281ddac5 |
| `openEHR-EHR-OBSERVATION.skin_temperature_wearable.v0.adl` | OBSERVATION | Skin Temperature Wearable | 7f79b3073d0a |
| `openEHR-EHR-OBSERVATION.sleep_architecture.v0.adl` | OBSERVATION | Sleep Architecture | 15614bdd6638 |
| `openEHR-EHR-OBSERVATION.stress_assessment.v0.adl` | OBSERVATION | Stress Assessment | 43920f1f7534 |
| `openEHR-EHR-OBSERVATION.vo2max_estimation.v0.adl` | OBSERVATION | VO2max estimation | b279ea3d65b1 |
| `openEHR-EHR-CLUSTER.data_quality_indicator.v0.adl` | CLUSTER | Data Quality Indicator | 795f5e7ca8a3 |
| `openEHR-EHR-CLUSTER.vendor_data_provenance.v0.adl` | CLUSTER | Vendor Data Provenance | 5ee4122ea173 |
| `openEHR-EHR-CLUSTER.wearable_device.v0.adl` | CLUSTER | Wearable Device | 1a8cf5dd8486 |

## Templates (withheld)

The six composition templates, listed here so that the catalog's references can be followed, are not part of this release:

* `lifestyle_medicine_activity.v0.oet` — references `CLUSTER.wearable_device.v0`, `OBSERVATION.physical_activity_detailed.v0`
* `lifestyle_medicine_encounter.v0.oet` — references `CLUSTER.wearable_device.v0`, `OBSERVATION.heart_rate_variability.v0`, `OBSERVATION.physical_activity_detailed.v0`, `OBSERVATION.sleep_architecture.v0`
* `lifestyle_medicine_hrv.v0.oet` — references `CLUSTER.wearable_device.v0`, `OBSERVATION.heart_rate_variability.v0`
* `lifestyle_medicine_sleep.v0.oet` — references `CLUSTER.wearable_device.v0`, `OBSERVATION.sleep_architecture.v0`
* `lifestyle_medicine_stress.v0.oet` — references `CLUSTER.wearable_device.v0`, `OBSERVATION.heart_rate_variability.v0`, `OBSERVATION.physical_activity_detailed.v0`, `OBSERVATION.sleep_architecture.v0`
* `Lifestyle_Medicine_Wearable_Summary.v0.oet` — references `CLUSTER.wearable_device.v0`, `OBSERVATION.heart_rate_variability.v0`, `OBSERVATION.physical_activity_detailed.v0`, `OBSERVATION.sleep_architecture.v0`

## Provenance and what differs from the working copies

These files are copies of the working archetype corpus taken on 2026-09-17. Internal working comments and labels were removed from the copies before distribution; **no node, constraint, occurrence, ontology term or terminology binding was changed.** This was verified with Archie 3.15.0 (Nedap's openEHR reference implementation; the build shipped with the openEHR ADL language server 0.6.1 gives the same result): both versions of each of the 12 archetypes were parsed with the ADL 1.4 parser, converted to ADL 2 and validated (0 parser errors, 0 validation errors in all 24 parses), and the serialised ADL 2 output of each pair was compared. Six pairs are identical (`data_quality_indicator`, `vendor_data_provenance`, `wearable_device`, `lactate_threshold`, `skin_temperature_wearable`, `sleep_architecture`); in the other six the differences are description strings only: the `other_contributors` line of `circadian_rhythm`, `recovery_readiness`, `screen_time` and `vo2max_estimation` (now the institution), one sentence of the `heart_rate_variability` purpose text, and three element descriptions of `stress_assessment` (a requirement label and an adoption figure that had no public source were removed). 

## Validation status

* **Archetypes:** 12/12 parse, convert and validate with Archie 3.15.0 as above.
* **Templates (withheld):** the six files are well-formed XML in the openEHR v1 namespace (`xmllint --noout`), shaped like operational templates, but they are **not valid Operational Templates**: validated against the openEHR Template XML schema (`Template.xsd`, schema version 1.0.1 by Ocean Informatics, taken from the openEHR specifications-ITS-XML repository at tag Release-1.0.2v2, commit f7a9377, `components/ALL/`) every file is rejected at its first element (`id` where the schema requires `language`), and they reference archetypes by identifier instead of inlining them as an OPT does. They are not in the Ocean Template Designer `.oet` format either (namespace `openEHR/v1/Template`), despite the extension. No openEHR tool available to this project accepts them as templates, so they remain **unvalidated as operational templates**: read them as the composition designs the catalog describes, not as deployable OPTs.
* **References:** the templates reference four archetypes. Three are in this folder; the fourth, `openEHR-EHR-OBSERVATION.physical_activity_detailed.v0` (referenced by `activity`, `encounter`, `stress` and `Wearable_Summary`), is not distributed either — it duplicates the published CKM `physical_activity` archetype and is not claimed as original. None of the six references a published CKM archetype, and none of the twelve archetypes carries a `specialise` clause.

## Known limitations found in use (2026-09-22)

A trial mapping of an Apple Health export (`export.xml`, the file the Health app produces) onto these archetypes surfaced four limitations of the ADL as distributed. They are declared here; **no archetype was changed** — changes are decided by the archetypes' authors, not in this IG — and each is paired with the change that would resolve it.

1. **Step counts have no home in the twelve archetypes.** None of them models a step count (the only "step" in the folder is the word in a transformation-history label of `CLUSTER.vendor_data_provenance.v0`). The CKM `OBSERVATION.physical_activity` models physical-activity level and category only; the corpus archetype that carries a step count, `OBSERVATION.physical_activity_detailed.v0`, is not distributed (see *Templates*). Until an archetype is chosen, step counts stay on the FHIR side (`Observation`, LOINC 55423-8). *Proposed change:* decide whether `physical_activity_detailed.v0` joins the distributed set or whether step counts are recorded through a CKM archetype.
2. **"Data export method" has no value for a manual XML export.** `CLUSTER.wearable_device.v0` at0023 offers seven values (Native API · HealthKit sync · Google Fit sync · Manual export (JSON) · Manual export (CSV) · FHIR export · Bluetooth direct) and `CLUSTER.vendor_data_provenance.v0` at0010 nine (the same plus Third-party aggregator · Research study export) — none is the XML export the Health app produces, so the element is left empty for such data. *Proposed change:* add "Manual export (XML)" to both value sets.
3. **The device slots are not designed alike.** `OBSERVATION.heart_rate_variability.v0` "Device details" (at0056) admits only `openEHR-EHR-CLUSTER.device.v*` — the CKM device cluster — so the IG's own `CLUSTER.wearable_device.v0` can enter that archetype only through its open "Extension" slot (at0057, any archetype). `OBSERVATION.sleep_architecture.v0` "Wearable device" (at0091) admits `wearable_device.v*`, and `OBSERVATION.vo2max_estimation.v0` "Device details" (at0034) admits either cluster. *Proposed change:* align the HRV slot with the VO2max pattern (`wearable_device.v0` or `device.v1`).
4. **The "Nightly sleep" interval event (at0079) of `OBSERVATION.sleep_architecture.v0` constrains only its `math_function` (mean) and `width` (PT12H), not its `data` tree** — the sleep elements are defined under the point event (at0002), so a path through at0079 cannot be validated against the archetype and queries have to use the point event. *Proposed change:* constrain at0079's `data` to the same item tree as at0002.

## Not a CKM submission

Distribution here is not a submission to the openEHR Clinical Knowledge Manager and implies no review by it. Comments and corrections are welcome through the repository's issue tracker.
