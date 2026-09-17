# openEHR artefacts distributed with this IG

This folder holds the **12 ADL 1.4 archetypes** that the [openEHR Archetype Catalog](../input/pagecontent/openehr-archetypes-catalog.md) lists as the genuinely original set (§2.1: 9 OBSERVATION + 3 CLUSTER), and the **6 composition templates** it lists in §3. All are at lifecycle state `in_development`, none has been submitted to the openEHR CKM, and each file carries its own author, date and licence metadata (Creative Commons Attribution-ShareAlike 4.0, as declared in every file; the licence of the archetypes and templates is theirs, not the IG's CC-BY-4.0).

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

## Templates (`templates/`)

| File | Archetypes referenced | sha256 (12) |
|---|---|---|
| `lifestyle_medicine_activity.v0.oet` | `CLUSTER.wearable_device.v0`, `OBSERVATION.physical_activity_detailed.v0` | 0581583b9069 |
| `lifestyle_medicine_encounter.v0.oet` | `CLUSTER.wearable_device.v0`, `OBSERVATION.heart_rate_variability.v0`, `OBSERVATION.physical_activity_detailed.v0`, `OBSERVATION.sleep_architecture.v0` | 020c3aaf2bc2 |
| `lifestyle_medicine_hrv.v0.oet` | `CLUSTER.wearable_device.v0`, `OBSERVATION.heart_rate_variability.v0` | 055e41f31237 |
| `lifestyle_medicine_sleep.v0.oet` | `CLUSTER.wearable_device.v0`, `OBSERVATION.sleep_architecture.v0` | abf06223c567 |
| `lifestyle_medicine_stress.v0.oet` | `CLUSTER.wearable_device.v0`, `OBSERVATION.heart_rate_variability.v0`, `OBSERVATION.physical_activity_detailed.v0`, `OBSERVATION.sleep_architecture.v0` | 0972b3f78777 |
| `Lifestyle_Medicine_Wearable_Summary.v0.oet` | `CLUSTER.wearable_device.v0`, `OBSERVATION.heart_rate_variability.v0`, `OBSERVATION.physical_activity_detailed.v0`, `OBSERVATION.sleep_architecture.v0` | 9c9bd4888d75 |

## Provenance and what differs from the working copies

These files are copies of the working archetype corpus taken on 2026-09-17. Internal working comments and labels were removed from the copies before distribution; **no node, constraint, occurrence, ontology term or terminology binding was changed.** This was verified with Archie 3.15.0 (Nedap's openEHR reference implementation; the build shipped with the openEHR ADL language server 0.6.1 gives the same result): both versions of each of the 12 archetypes were parsed with the ADL 1.4 parser, converted to ADL 2 and validated (0 parser errors, 0 validation errors in all 24 parses), and the serialised ADL 2 output of each pair was compared. Six pairs are identical (`data_quality_indicator`, `vendor_data_provenance`, `wearable_device`, `lactate_threshold`, `skin_temperature_wearable`, `sleep_architecture`); in the other six the differences are description strings only: the `other_contributors` line of `circadian_rhythm`, `recovery_readiness`, `screen_time` and `vo2max_estimation` (now the institution), one sentence of the `heart_rate_variability` purpose text, and three element descriptions of `stress_assessment` (a requirement label and an adoption figure that had no public source were removed). The six templates differ from the working copies by one removed metadata item each.

## Validation status

* **Archetypes:** 12/12 parse, convert and validate with Archie 3.15.0 as above.
* **Templates:** the six files are well-formed XML in the openEHR v1 namespace (`xmllint --noout`), shaped like operational templates, but they are **not valid Operational Templates**: validated against the openEHR `Template.xsd` (specifications-ITS-XML, Release-1.0.2) every file is rejected at its first element (`id` where the schema requires `language`), and they reference archetypes by identifier instead of inlining them as an OPT does. They are not in the Ocean Template Designer `.oet` format either (namespace `openEHR/v1/Template`), despite the extension. No openEHR tool available to this project accepts them as templates, so they remain **unvalidated as operational templates**: read them as the composition designs the catalog describes, not as deployable OPTs.
* **References:** the templates reference four archetypes. Three are in this folder; the fourth, `openEHR-EHR-OBSERVATION.physical_activity_detailed.v0` (referenced by `activity`, `encounter`, `stress` and `Wearable_Summary`), is **not distributed** — it duplicates the published CKM `physical_activity` archetype and is not claimed as original — so those four templates cannot be resolved from this folder alone. None of the six references a published CKM archetype, and none of the twelve archetypes carries a `specialise` clause.

## Not a CKM submission

Distribution here is not a submission to the openEHR Clinical Knowledge Manager and implies no review by it. Comments and corrections are welcome through the repository's issue tracker.
