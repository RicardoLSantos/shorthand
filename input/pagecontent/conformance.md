# Conformance Requirements

This page defines the conformance expectations for systems claiming compliance with the iOS Lifestyle Medicine IG.

## Conformance Levels

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

### Level 3: Full Compliance

A system claiming Level 3 conformance:

- **SHALL** support all 11 domain profiles
- **SHALL** implement all 28 ConceptMaps for terminology translation
- **SHALL** support Bundle creation for complete patient summaries
- **SHALL** comply with data protection profiles (GDPR, HIPAA as applicable)

## Terminology Requirements

### Standard Codes (LOINC)

Where a profile specifies a LOINC code, implementations:
- **SHALL** use the exact LOINC code specified
- **SHALL NOT** substitute with custom or vendor-specific codes
- **SHALL** include the LOINC display name

### Custom Codes (LifestyleMedicineTemporaryCS)

For metrics in the 86% terminology gap:
- **SHALL** use codes from `LifestyleMedicineTemporaryCS` as specified in profiles
- **SHOULD** include dual-coding with LOINC LP/LA part codes when available (148 codes have part-level matches)
- **SHALL** monitor LOINC/SNOMED releases for standard code availability and migrate when published

### Vendor-Specific Codes

When including raw vendor data:
- **SHOULD** include vendor-specific codes in `code.coding` alongside the profile-specified code
- **SHALL** use the appropriate vendor CodeSystem URI (e.g., `com.apple.health`, `com.fitbit.hrv`)

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

## Validation

Implementations can validate conformance using:

1. **FHIR Validator**: `java -jar validator_cli.jar [resource.json] -ig https://2rdoc.pt/ig/ios-lifestyle-medicine`
2. **SUSHI**: Build the IG locally and check for errors
3. **Profile validation**: Validate resources against specific StructureDefinitions

## Known Limitations

- **IPS upstream errors**: 35 errors originate from the IPS STU2 dependency (tracked in [Known Issues](known-issues.html))
- **tx.fhir.org**: Custom CodeSystems are not available on the public terminology server during development
- **Consumer device accuracy**: This IG does not validate clinical accuracy of consumer wearable measurements
