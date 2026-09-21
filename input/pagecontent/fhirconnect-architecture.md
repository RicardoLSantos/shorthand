# FHIRconnect Architecture

## Overview

This Implementation Guide adopts the FHIRconnect architectural pattern (Kohler et al., 2025) for seamless integration between openEHR archetypes and FHIR resources. FHIRconnect provides a triple-layered transformation architecture that enables 65% mapping reuse across different clinical contexts, significantly reducing implementation complexity for wearable device data integration.

## Triple-Layer Architecture

The FHIRconnect approach implements three distinct mapping layers, each addressing specific interoperability challenges:

### 1. Model-Mappings Layer
**Purpose**: Transform between openEHR Reference Model and FHIR base resources
**Scope**: Generic, reusable across all clinical domains
**Example**:
- openEHR `OBSERVATION` → FHIR `Observation`
- openEHR `DV_QUANTITY` → FHIR `Quantity`
- openEHR `DV_CODED_TEXT` → FHIR `CodeableConcept`

### 2. Extension-Mappings Layer
**Purpose**: Handle openEHR archetype constraints that lack direct FHIR equivalents
**Scope**: Domain-specific but reusable within domain
**Example**:
- HRV archetype `protocol/device` → FHIR extension `DeviceMetadata`
- Sleep archetype `state/body_position` → FHIR extension `BodyPosition`
- Environmental `data/air_quality_index` → FHIR extension `AirQualityMetrics`

### 3. Context-Mappings Layer
**Purpose**: Apply local terminology bindings and organizational constraints
**Scope**: Implementation-specific
**Example**:
- LOINC `80404-7` for SDNN (where available)
- Custom codes for RMSSD, pNN50 (pending LOINC submission)
- Vendor-specific identifiers (Apple HealthKit, Fitbit, etc.)

## ConceptMap Implementation

This IG includes 29 ConceptMaps. The ten domain-level maps below implement the FHIRconnect principles directly; the remaining maps are the openEHR/OMOP cross-paradigm bridges and the vendor-terminology maps (see the [terminology catalog](terminology-vocabularies-catalog.html)):

### Core Vital Signs Mappings
1. **ConceptMapHRVToLOINC**: Maps HRV metrics to LOINC codes with migration path
   - Implements dual-coding strategy: LOINC where available, custom with migration metadata
   - Addresses the terminology gap for wearable HRV metrics (RMSSD, pNN50 and the frequency-domain measures have no LOINC code; SDNN has 80404-7)

2. **ConceptMapBodyMetricsToLOINC**: Body measurements to LOINC
   - Leverages existing LOINC coverage for standard anthropometric measures
   - 100% LOINC coverage achieved for basic body metrics

### Lifestyle Medicine Mappings
3. **ConceptMapPhysicalActivityToSNOMED**: Exercise and movement metrics
   - Maps consumer device activity types to SNOMED CT concepts
   - Enables semantic interoperability for fitness tracking

4. **ConceptMapSleepToLOINC**: Sleep architecture and quality metrics
   - Partial LOINC coverage (40%) with custom extensions
   - Aligns with polysomnography standards where applicable

5. **ConceptMapNutritionToSNOMED**: Dietary tracking and nutritional assessment
   - SNOMED CT food concepts and nutritional parameters
   - Supports lifestyle intervention monitoring

6. **ConceptMapMindfulnessToSNOMED**: Mental well-being and stress metrics
   - Maps meditation, breathing exercises to SNOMED interventions
   - Limited standard coverage (25%), primarily custom codes

### Environmental and Contextual Mappings
7. **ConceptMapEnvironmentalToSNOMED**: Environmental exposures
   - Air quality, noise, UV radiation to SNOMED observables
   - Critical for exposome research integration

8. **ConceptMapReproductiveToLOINC**: Reproductive health tracking
   - Menstrual cycle, fertility indicators to LOINC
   - High LOINC coverage (75%) for established metrics

9. **ConceptMapMobilityToSNOMED**: Movement and gait analysis
   - Gait parameters, balance metrics to SNOMED
   - Emerging area with limited standard coverage (30%)

### Vendor Integration Layer
10. **ConceptMapVendorToLOINC**: Multi-vendor device harmonization
    - Apple HealthKit → LOINC/Custom
    - Fitbit → LOINC/Custom
    - Garmin, Oura, Polar, Whoop, Samsung → LOINC/Custom
    - Implements vendor-agnostic data model per FHIRconnect principles

## Mapping Reuse Metrics

FHIRconnect (Kohler et al., 2025) reports an *expected* mapping-reuse rate of about 65%, derived from the roughly 35% extension share observed in FHIR implementation guides; its proof-of-concept mapped the German Core Dataset — whose data model standardises data from over 21 million patients across 38 university hospitals — on sample data. Those figures describe the pattern's expected economics, not a measurement of this IG.

### This IG (published computation)
Measured on the released map set and reported in [doi:10.1016/j.ijmedinf.2026.106465](https://doi.org/10.1016/j.ijmedinf.2026.106465):
- **Model layer**: 100% reusable (vendor-agnostic FHIR profiles)
- **Extension layer**: 67% reusable (domain extensions for HRV measurement methods, activity metrics and sleep staging)
- **Context layer**: vendor-specific (ConceptMaps translating vendor API terminology to the profiles)
- **Overall**: **75% weighted reuse** across the seven vendor ecosystems analysed in the article

An earlier overall figure of 65.8% (100% / 67.4% / 45% by layer), computed in January 2026 on the v0.2.x map set, is superseded by the published weighted computation and is kept here only as history.

### Comparison with FHIRconnect
- FHIRconnect: ~65% *expected* reuse (a derived expectation, not a measurement)
- This IG: 75% *weighted* reuse (measured on the published map set)

## Implementation Benefits

### 1. Reduced Development Effort
- 10 ConceptMaps cover 120+ consumer health metrics
- Average 12 metrics per ConceptMap through pattern reuse
- Estimated 65% reduction in mapping development time

### 2. Semantic Consistency
- Unified approach across all wearable vendors
- Consistent terminology migration path
- Preservation of clinical meaning through transformation

### 3. Scalability
- New devices can reuse existing model/extension mappings
- Only context layer needs customization for new vendors
- Supports rapid integration of emerging wearable technologies

## Migration Strategy

The FHIRconnect architecture enables gradual terminology standardization:

### Phase 1: Current State (2024)
- Dual-coding with custom codes and migration metadata
- LOINC coverage: 14% of wearable metrics
- SNOMED CT coverage: 35% of lifestyle interventions

### Phase 2: Near-term (2025-2026)
- Submit high-priority codes to LOINC (RMSSD, pNN50, LF/HF ratio)
- Expand SNOMED CT lifestyle medicine subset
- Target: 40% standard terminology coverage

### Phase 3: Long-term (2027+)
- Mature wearable device terminology in standards
- Automated mapping updates via ConceptMap versioning
- Target: 75% standard terminology coverage

## Technical Implementation

### ConceptMap Structure
```fsh
Instance: ConceptMapHRVToLOINC
InstanceOf: ConceptMap
* group[0].source = "CustomCodeSystem"
* group[0].target = "http://loinc.org"
* group[0].element[0].code = #hrv-sdnn
* group[0].element[0].target[0].code = #80404-7
* group[0].element[0].target[0].equivalence = #equivalent
```

### Triple-Layer Processing
1. **Extract** device-specific data (vendor layer)
2. **Transform** via ConceptMap (model + extension layers)
3. **Load** into FHIR server with appropriate bindings (context layer)

### Runtime Translation
```
GET [base]/ConceptMap/$translate?code=hrv-rmssd&system=CustomSystem
```

## Validation Against FHIRconnect Principles

This implementation fulfills all FHIRconnect requirements:

✅ **Model now, map later**: Archetypes designed before complete terminology
✅ **Triple-layer separation**: Clear distinction between mapping concerns
✅ **Reuse quantification**: 75% weighted mapping reuse (published computation)
✅ **Vendor neutrality**: Single model supports 7+ device vendors
✅ **Migration path**: Built-in terminology evolution support
✅ **Operational deployment**: ConceptMaps enable runtime $translate

## References

1. Kohler S, et al. FHIRconnect: Towards a seamless integration of openEHR and FHIR. arXiv:2511.14618v1 [cs.SE] 18 Nov 2025.

2. HiGHmed Consortium. Medical Informatics Initiative Germany. 2018-2024.

3. HL7 FHIR ConceptMap Resource. [https://www.hl7.org/fhir/conceptmap.html](https://www.hl7.org/fhir/conceptmap.html)

4. openEHR Foundation. Archetype Definition Language 2.0. 2024.

---

*Implementation Note: This IG represents the first application of FHIRconnect principles to consumer wearable devices and lifestyle medicine, extending the original clinical focus to preventive health domains.*