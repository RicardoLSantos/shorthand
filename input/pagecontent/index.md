# iOS Lifestyle Medicine Implementation Guide

## Purpose
This FHIR implementation guide defines how to represent consumer-wearable health and lifestyle data in FHIR R4 to support lifestyle-medicine interventions across vendor ecosystems. The iOS Health App export is the origin of the proof-of-concept adapter, not the scope of the IG: profiles are vendor-agnostic and vendor specifics are confined to ConceptMaps and stub CodeSystems. The IG adopts the FHIRconnect architectural pattern (Kohler et al., 2025) for integration between openEHR archetypes and FHIR resources, achieving 75% weighted mapping reuse through a triple-layered transformation architecture (published computation: [doi:10.1016/j.ijmedinf.2026.106465](https://doi.org/10.1016/j.ijmedinf.2026.106465)).

## Scope
The implementation guide covers the following consumer-wearable data domains (the iOS Health App export was the proof-of-concept source):

### Vital Signs
- Basic vital signs (heart rate, blood pressure, temperature, etc.)
- Advanced physiological metrics (HRV, respiratory patterns, etc.)
- Physiological stress biomarkers
- Thermoregulation metrics

### Physical Activity
- Steps and distance
- Workouts and exercise
- Energy expenditure
- Activity patterns
- Movement analysis

### Sleep
- Sleep duration and stages
- Sleep quality metrics
- Breathing during sleep
- Heart rate during sleep
- Sleep consistency

### Mindfulness & Mental Health
- Mindfulness sessions
- Stress levels
- Mood tracking
- Relaxation practices
- Mental well-being metrics

### Body Measurements
- Weight and height
- BMI calculations
- Body composition
- Anthropometric measurements

### Nutrition
- Food and water intake
- Macronutrients tracking
- Energy balance
- Meal patterns

### Environmental Factors
- Noise exposure
- UV exposure
- Environmental context
- Exposure patterns

### Reproductive Health
- Cycle tracking
- Fertility signs
- Symptoms tracking
- Health patterns

### Social & Behavioral
- Social interactions
- Support networks
- Behavioral patterns
- Activity context

## Use Cases
1. Automated health data collection and monitoring
2. Lifestyle pattern assessment and analysis
3. Intervention planning and tracking
4. Progress monitoring and outcomes assessment
5. Patient engagement and self-management
6. Clinical decision support
7. Research and population health

## Audience
- Healthcare software developers
- Healthcare professionals and providers
- Digital health platform developers
- Health researchers
- Lifestyle medicine specialists
- Health informaticians
- Digital health innovators

## Technical Framework
Built on FHIR R4 (4.0.1) with:
- Custom profiles for iOS Health data
- Extensions for contextual information
- Terminologies for standardized coding
- Search parameters for data access
- Operations for data processing
- Examples for implementation guidance

## Integration Architecture

This IG adopts the **FHIRconnect triple-layer architectural pattern** for interoperability:

### Model-Mappings Layer
- Generic transformations between data models (100% reusable)
- openEHR Reference Model ↔ FHIR base resources
- Vendor-agnostic data structures

### Extension-Mappings Layer
- Domain-specific extensions (67% reusable across vendors, per the published computation)
- Wearable device metadata
- Lifestyle medicine context

### Context-Mappings Layer
- Terminology bindings (the vendor-specific layer: ConceptMaps translate each vendor's API terminology)
- 29 ConceptMaps covering 120+ metrics (10 domain + 19 cross-paradigm)
- Dual-coding strategy for 86% terminology gap

### Key Achievements
- **75% weighted mapping reuse** across the layered architecture (the published computation, [doi:10.1016/j.ijmedinf.2026.106465](https://doi.org/10.1016/j.ijmedinf.2026.106465); an earlier 65.8% figure, computed in January 2026 on the v0.2.x map set, is superseded)
- **29 ConceptMaps** operationalize consumer health domains plus cross-paradigm interoperability
- **7+ vendor support** through unified architecture
- **Migration path** for evolving terminology standards

For detailed architecture documentation, see [FHIRconnect Architecture](fhirconnect-architecture.html).

## Related Implementation Guides

This IG aligns with and extends several HL7 FHIR Implementation Guides:

### Dependencies (Formal)

| IG | Version | Purpose |
|----|---------|---------|
| [HL7 Physical Activity IG](http://hl7.org/fhir/us/physical-activity) | 1.0.0 | Steps, calories, Exercise Vital Sign (EVS) profiles |
| [Personal Health Device IG](http://hl7.org/fhir/uv/phd) | 1.1.0 | Device metadata, IEEE 11073 mapping patterns |
| [International Patient Summary](http://hl7.org/fhir/uv/ips) | 2.0.1 | Cross-border patient summary interoperability |
| [Bulk Data Access IG](http://hl7.org/fhir/uv/bulkdata) | 2.0.0 | Population-level export (`Group/$export`, `BulkExportGroup`) |
| [IHE Privacy Consent on FHIR](https://profiles.ihe.net/ITI/PCF) | 1.1.0 | Consent management patterns |

### Related Standards (Informative)

| IG | Relevance |
|----|-----------|
| [CIMI Vital Signs](http://hl7.org/fhir/us/vitals) | Basic vital signs profiles (HR, BP, SpO2) |
| [CGM IG](http://hl7.org/fhir/uv/cgm) | Continuous monitoring patterns for glucose |
| [Personal Health Record Format](https://build.fhir.org/ig/HL7/personal-health-record-format-ig/) | Patient-owned data model |

### Novel Contributions

This IG addresses gaps NOT covered by existing HL7 standards:

- **Heart Rate Variability (HRV)**: Comprehensive profiles for SDNN, RMSSD, pNN50, LF/HF ratio - no existing HL7 IG covers these metrics. The six HRV gap codes were first published as `HeartRateVariabilityCS` (v0.1.0–v0.2.0) and have lived unchanged in `LifestyleMedicineTemporaryCS` since v0.2.1, bridged to LOINC by `ConceptMapHRVToLOINC` (see the [terminology catalog](terminology-vocabularies-catalog.html), §6)
- **Sleep Architecture**: Sleep stage profiles — deep and REM sleep bound to LOINC (93831-6, 93829-0), the remaining stages through the vendor stage CodeSystems (Apple, Fitbit, Garmin, Oura) with a cross-vendor ConceptMap
- **Consumer Wearable Integration**: Unified model for Apple HealthKit, Fitbit, Oura, Garmin, Polar
- **Lifestyle Medicine Context**: Integration of all six pillars in single implementation guide

## Value Proposition

### Quantified Benefits

| Metric | Value | Evidence |
|--------|:-----:|---------|
| **Domains covered** | 11 | Vital signs, sleep, activity, nutrition, mindfulness, stress, environmental, social, reproductive, ECG, body metrics |
| **Vendor support** | 7+ | Apple HealthKit, Fitbit, Garmin, Oura, Polar, Withings, generic |
| **Custom codes** | 1,211 | Interim codes for concepts with no LOINC/SNOMED CT equivalent; the ConceptMaps bridge those that have one. Per-concept migration properties (`assignment-status`, `loinc-equivalent`) are defined in `AppLogicCS` but not yet applied to the concepts |
| **Terminology gap documented** | 86% | Of consumer wearable metrics lack standard codes |
| **ConceptMaps** | 29 | Covering LOINC, SNOMED CT, OMOP CDM, openEHR |
| **Example instances** | 191 | 101 of 103 profiles have a standalone example — `ConsumerECGObservation` (the abstract ECG parent) has none, and `CarePlanLifestyleMedicine` is instantiated only inline inside bundle examples |
| **Regulatory frameworks** | 2 | LGPD (Brazil), CFM 2.454/2026 (AI in medicine) |
| **Estimated dev time saved** | 180h | Based on implementation effort analysis vs. building from scratch |

### Quick Start

- **Level 1 (single domain)**: 1-7 profiles, low effort — first Observation in <30 minutes
- **Level 2 (multi-domain)**: 10-25 profiles, medium effort
- **Level 3 (full compliance)**: 103 profiles, all ConceptMaps, regulatory profiles

See [Getting Started](getting-started.html) and [Conformance Requirements](conformance.html) for details.

### Comparison with Published IGs

| Feature | This IG | CGM IG | PA IG | PHD IG |
|---------|:-------:|:------:|:-----:|:------:|
| Domains | 11 | 1 (glucose) | 1 (activity) | Device metadata |
| Vendors | 7+ | CGM devices | Generic | IEEE 11073 |
| Custom codes | 1,211 | 0 | ~30 | 0 |
| ConceptMaps | 29 | 0 | 0 | 0 |
| Regulatory | LGPD + CFM | None | None | None |

## Implementation Notes
- Integration with HealthKit API
- Privacy and security considerations
- Data validation requirements
- Interoperability guidelines
- Best practices for implementation

## Dependencies

{% include dependency-table.xhtml %}

## Cross Version Analysis

{% include cross-version-analysis.xhtml %}

## Global Profiles

{% include globals-table.xhtml %}

## IP Statements

{% include ip-statements.xhtml %}
