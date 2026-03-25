# Conformance Requirements

This page defines the conformance expectations for systems implementing this Implementation Guide (IG). It complements the [Must Support](must-support.html) definitions and the [CapabilityStatement](CapabilityStatement-LifestyleMedicineCapabilityStatement.html) for server requirements.

## Conformance Levels

This IG supports incremental adoption through three conformance levels:

| Level | Scope | Profiles Required | Effort Estimate |
|:-----:|-------|:-----------------:|:---------------:|
| **1 — Starter** | Single domain (e.g., Vital Signs or Sleep) | 1–7 profiles | Low |
| **2 — Multi-Domain** | 3+ domains with cross-domain data | 10–25 profiles | Medium |
| **3 — Full** | All 11 domains, ConceptMaps, AI/CDSS, Regulatory | 82 profiles | High |

Implementers **SHOULD** start at Level 1 and progressively adopt additional domains.

### Level 1: Basic Consumer Data (Minimum)

A system claiming Level 1 conformance:

- **SHALL** support at least one domain profile (e.g., SleepObservation or PhysicalActivityObservation)
- **SHALL** populate all Must Support elements with cardinality 1..1
- **SHALL** include a Device resource identifying the data source
- **SHALL** use LOINC codes where specified in profiles
- **SHALL** use UCUM for all quantity units

### Level 2: Multi-Domain Integration

A system claiming Level 2 conformance:

- **SHALL** support at least 3 domain profiles
- **SHALL** support the IPS Lifestyle Medicine Composition for cross-border data exchange
- **SHOULD** implement ConceptMaps for vendor-specific code translation
- **SHOULD** support the dual-coding strategy (custom + standard codes)
- **SHOULD** implement CarePlan for coordinated lifestyle interventions
- **SHOULD** include Provenance resources for data lineage

### Level 3: Full Compliance

A system claiming Level 3 conformance:

- **SHALL** support all 11 domain profiles
- **SHALL** implement all 29 ConceptMaps for terminology translation
- **SHALL** support Bundle creation for complete patient summaries
- **SHALL** comply with data protection profiles (LGPD, GDPR, HIPAA as applicable)
- **SHALL** integrate AI/CDSS profiles with audit trail (AuditEvent)
- **SHALL** support all 7 custom SearchParameters
- **SHALL** validate full round-trip data flow (Device → FHIR → EHR → IPS)

## Domain-Profile Matrix

The IG organizes 82 profiles across 11 lifestyle medicine domains plus regulatory compliance. The table below shows profile counts, MustSupport (MS) element ranges, and primary terminology per domain.

| # | Domain | Profiles | MS Range | Primary Terminology | Binding Strength |
|:-:|--------|:--------:|:--------:|---------------------|:----------------:|
| 1 | **Vital Signs** | 7 | 19–23 | LOINC (8867-4, 85354-9, 2708-6) | Required + Extensible |
| 2 | **Physical Activity** | 5 | 10–61 | LOINC (55423-8) + Custom | Extensible |
| 3 | **Sleep** | 1 | 15 | LOINC (93832-4, 93831-6) + Custom | Extensible |
| 4 | **Mindfulness & Mental Health** | 5 | 12–17 | Custom (stress, loneliness) | Extensible + Required |
| 5 | **Body Metrics** | 5 | 10 | LOINC (29463-7, 39156-5, 8302-2) | Extensible |
| 6 | **Nutrition** | 5 | 23 | Custom (macronutrients, hydration) | Extensible |
| 7 | **Environmental** | 5 | 21 | Custom (noise, UV, audio) | Extensible |
| 8 | **Reproductive Health** | 1 | 7 | Custom (fertility, ovulation) | Extensible |
| 9 | **Substance Use** | 5 | 55 | SNOMED (tobacco, alcohol) + Custom | Required + Extensible |
| 10 | **Advanced Metrics** | 18 | 12–30 | LOINC (80404-7, 97506-0) + Custom | Required + Extensible |
| 11 | **Infrastructure & Support** | 21 | 7–60 | Mixed (FHIR base + Custom) | Mixed |
| — | **Regulatory (LGPD/GDPR)** | 4 | 7–23 | Custom (AppLogicCS) | Required |

**Total**: 82 Profiles, 56 Extensions, 15 CodeSystems (1,103 custom codes + 34 ICD-11 fragment codes), 189 ValueSets, 29 ConceptMaps.

## Terminology Requirements

### Standard vs Custom Code Distribution

| Terminology | Profiles Using | Approximate Coverage | Role |
|-------------|:--------------:|:--------------------:|------|
| **LOINC** | 22 (28%) | ~14% of domain | Vital signs, sleep, activity, CGM, HRV |
| **SNOMED CT** | 18 (23%) | ~4% of domain | Risk levels, clinical interpretation, procedures |
| **Custom (TemporaryCS)** | 22 (27%) | ~82% of domain | 719 codes for unmapped lifestyle metrics |
| **Custom (AppLogicCS)** | 12 (15%) | App logic | 277 codes for equipment, governance, regulatory |
| **Custom (AgentCS)** | 3 (4%) | AI/CDSS | 107 codes for AI agent risk, model, override, events |
| **UCUM** | 19 (24%) | Units only | All quantity values |

### Standard Codes (LOINC)

Where a profile specifies a LOINC code, implementations:
- **SHALL** use the exact LOINC code specified
- **SHALL NOT** substitute with custom or vendor-specific codes
- **SHALL** include the LOINC display name

### Custom Codes (LifestyleMedicineTemporaryCS)

For metrics in the ~86% terminology gap:
- **SHALL** use codes from `LifestyleMedicineTemporaryCS` as specified in profiles
- **SHOULD** include dual-coding with LOINC LP/LA part codes when available
- **SHALL** monitor LOINC/SNOMED releases for standard code availability and migrate when published

### Vendor-Specific Codes

When including raw vendor data:
- **SHOULD** include vendor-specific codes in `code.coding` alongside the profile-specified code
- **SHALL** use the appropriate vendor CodeSystem URI (e.g., `com.apple.health`, `com.fitbit.hrv`)

### LOINC Substitutions (19 verified)

The IG includes 19 verified LOINC substitutions for concepts previously mapped to custom codes:

| Category | Count | Key Codes |
|----------|:-----:|-----------|
| CGM (9750x family) | 5 | GMI (97506-0), TIR (97510-2), Sensor Active Time (104637-4) |
| Sleep (9383x/1032x) | 5 | Deep sleep (93831-6), Awakenings (103211-9) |
| Phase 3 CGM (1046xx) | 8 | TBR (104641-6), TAR (104640-8), CV% (104638-2) |
| Sport | 1 | Max Heart Rate (73985-4) |

## Binding Strength Distribution

| Strength | Count | Percentage | Implementer Obligation |
|----------|:-----:|:----------:|------------------------|
| **Required** | 30 | 29.7% | **SHALL** use a code from the specified ValueSet |
| **Extensible** | 66 | 65.3% | **SHOULD** use the ValueSet; custom codes permitted if needed |
| **Preferred** | 5 | 5.0% | **MAY** use the ValueSet; alternatives freely permitted |

Most bindings are **extensible**, allowing local implementations to extend terminology while maintaining interoperability with the IG's standard codes.

### Required Bindings by Category

Required bindings enforce strict conformance in the following areas:

- **Clinical interpretation**: CGM glucose interpretation, HsCRP interpretation, QT interpretation
- **Status codes**: Alcohol/tobacco use status, agent task status
- **Measurement units**: CGM glucose units (mg/dL, mmol/L), VO2max units
- **Classification**: Risk levels (SNOMED), CGM trend arrows, QT correction formulas
- **Workflow**: Agent plan definition type, service request intent

## MustSupport Obligations by Resource Type

| Resource Base | Profile Count | MS Range | Notes |
|--------------|:------------:|:--------:|-------|
| Observation | 48 | 7–61 | Core clinical data; sport profiles have highest MS count |
| CarePlan | 1 | 24 | Lifestyle medicine care plans |
| Consent | 1 | 23 | Multi-jurisdictional consent (EU, US, BR) |
| Provenance | 1 | 22 | PGHD data provenance chain |
| Composition | 1 | 16 | IPS Lifestyle Medicine section |
| Bundle | 1 | 16 | IPS document bundle |
| AuditEvent | 1 | 23 | AI interaction audit trail |
| ClinicalImpression | 1 | 23 | AI clinical assessment |
| PlanDefinition | 1 | 60 | Agent workflow definitions |
| ServiceRequest | 1 | 27 | Agent service orchestration |
| Task | 1 | 23 | Agent task execution |
| DeviceDefinition | 1 | 17 | SLM device definitions |
| Questionnaire | 1 | 7 | Symptom questionnaires |

## Device Requirements

All consumer wearable observations:
- **SHALL** include `Observation.device` referencing a Device resource
- Device resources **SHALL** include `manufacturer` and `deviceName`
- Device resources **SHOULD** include `modelNumber` and firmware version when available

## Data Quality Requirements

### Temporal Precision

- Sleep observations: **SHALL** use `effectivePeriod` with start and end times
- Spot measurements (HR, SpO2): **SHALL** use `effectiveDateTime`
- 24-hour summaries: **SHOULD** use `effectivePeriod` covering the full day

### Units of Measure

All quantity values **SHALL** use UCUM codes:

| Measurement Type | UCUM Code | Display |
|-----------------|:---------:|---------|
| Duration | `min` | minute |
| Heart rate | `/min` | per minute |
| Temperature | `Cel` | degree Celsius |
| Distance | `m` or `km` | meter or kilometer |
| Weight | `kg` | kilogram |
| HRV (SDNN/RMSSD) | `ms` | millisecond |
| Percentage | `%` | percent |
| Score | `{score}` | score |

## ConceptMap Coverage

This IG provides **29 ConceptMaps** for terminology translation across five mapping categories:

| Category | Maps | Direction | Purpose |
|----------|:----:|-----------|---------|
| Vendor → SNOMED | 5 | Custom → Standard | Clinical integration |
| Vendor → LOINC | 3 | Custom → Standard | Laboratory integration |
| Vendor → OMOP | 5 | Custom → OMOP CDM | Observational research |
| FHIR ↔ openEHR | 2 | Bidirectional | Dual-model interoperability |
| ICD-10 → ICD-11 | 1 | ICD-10-CM → ICD-11 | Diagnostic code migration |
| AI/CDSS | 1 | Risk levels | AI risk classification |
| Other domain maps | 12 | Various | Domain-specific translations |

Use the FHIR `$translate` operation for runtime terminology translation:

```
GET [base]/ConceptMap/$translate?system=https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs&code=sleep-deep&target=http://loinc.org
```

## Server Conformance

The [CapabilityStatement](CapabilityStatement-LifestyleMedicineCapabilityStatement.html) defines server requirements including:

- **12 resource types** supported (Observation, Patient, Device, Practitioner, Composition, Bundle, Consent, Provenance, CarePlan, AuditEvent, ClinicalImpression, Questionnaire)
- **32 Observation `supportedProfiles`** across all domains
- **7 custom SearchParameters**: domain, vendor, value-range, AI-model, AI-confidence, careplan-category, consent-jurisdiction

Servers claiming conformance to this IG **SHALL** support at minimum Level 1 (single domain) and **SHOULD** declare which domains they support in their CapabilityStatement.

## Validation

### SUSHI Validation

```bash
sushi .
# Expected: 0 Errors, 0 Warnings
```

### IG Publisher Validation

```bash
./_genonce.sh
# Check output/qa.html for results
# Expected: 23 errors (all IPS upstream), 206 warnings (30 suppressed)
```

The 23 errors are inherited from IPS STU2 upstream (reference to unpublished `note|5.3.0-ballot-tc1` extension). These do not affect IG functionality. See [Known Issues](known-issues.html) for details.

### FHIR Validator

Individual resources can be validated against IG profiles:

```bash
java -jar validator_cli.jar resource.json \
  -ig ios-lifestyle-medicine#0.2.0 \
  -profile https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/sleep-observation
```

## Implementation Checklist

### Level 1 (Starter)

- [ ] Choose target domain from the Domain-Profile Matrix
- [ ] Map source data to profile elements (see [Getting Started](getting-started.html))
- [ ] Apply correct LOINC/SNOMED/custom codes per profile binding
- [ ] Include Device resource for wearable source identification
- [ ] Validate resources against profile using FHIR Validator
- [ ] Test `$validate` operation on target server

### Level 2 (Multi-Domain)

- [ ] All Level 1 requirements for 3+ domains
- [ ] Use ConceptMaps for cross-terminology translation
- [ ] Implement CarePlan for coordinated lifestyle interventions
- [ ] Include Provenance resources for data lineage
- [ ] Support IPS Lifestyle Medicine Composition

### Level 3 (Full Compliance)

- [ ] All Level 2 requirements across all 11 domains
- [ ] Implement IPS Lifestyle Medicine Composition and Bundle
- [ ] Deploy multi-jurisdictional Consent management
- [ ] Integrate AI/CDSS profiles with audit trail (AuditEvent)
- [ ] Support all 7 custom SearchParameters
- [ ] Validate full round-trip data flow (Device → FHIR → EHR → IPS)

## Known Limitations

- **IPS upstream errors**: 23 errors originate from the IPS STU2 dependency (tracked in ignoreWarnings.txt)
- **tx.fhir.org**: Custom CodeSystems are not available on the public terminology server during development
- **Consumer device accuracy**: This IG does not validate clinical accuracy of consumer wearable measurements
