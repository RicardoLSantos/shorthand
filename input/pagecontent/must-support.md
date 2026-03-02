# Must Support Definitions

This page defines the meaning of Must Support (MS) flags in this Implementation Guide, following HL7 FHIR conformance language.

## Definition

In this IG, **Must Support** means:

### For Data Senders (Wearable App / FHIR Client)

- **SHALL** be capable of populating the element if data is available from the source device
- **SHALL** include the element in the resource when sending to a FHIR server
- If data is not available (e.g., device does not measure that metric), the element MAY be omitted

### For Data Receivers (FHIR Server / EHR)

- **SHALL** be capable of storing and returning the element
- **SHALL NOT** reject a resource solely because an MS element is present
- **SHOULD** be capable of displaying the element to end users

### For Application Developers

- **SHALL** handle the element in application logic (even if only to store/display)
- **SHALL NOT** ignore MS elements in clinical decision support or analytics

## Cardinality and Must Support

| Cardinality | MS | Meaning |
|:-----------:|:--:|---------|
| 1..1 | MS | Required. Must always be present and populated. |
| 1..* | MS | At least one value must be present. |
| 0..1 | MS | Optional but must be supported if present. |
| 0..* | MS | Optional but must be supported if present. |
| 0..1 | — | Truly optional. May be ignored by receivers. |

## Example: SleepObservation Profile

```
SleepObservation
├── status          1..1 MS  → Always required (FHIR base)
├── category        1..1 MS  → Always "activity"
├── code            1..1 MS  → Always sleep-panel
├── subject         1..1 MS  → Patient reference required
├── effectivePeriod 0..1 MS  → Include if sleep period known
├── device          0..1 MS  → Include device info if available
└── component
    ├── timeInBed         1..1 MS  → Required (LOINC 103213-5)
    ├── totalSleepTime    1..1 MS  → Required (LOINC 93832-4)
    ├── deepSleep         0..1 MS  → Include if device reports stages
    ├── remSleep          0..1 MS  → Include if device reports stages
    ├── lightSleep        0..1 MS  → Include if device reports stages
    ├── respiratoryRate   0..1 MS  → Include if measured during sleep
    ├── heartRateVariability 0..1 MS → Include if measured during sleep
    └── interruptions     0..1 MS  → Include if device reports awakenings
```

## Consumer Wearable Considerations

Consumer devices vary in measurement capabilities. Not all devices report all metrics:

| Metric | Apple Watch | Fitbit | Oura Ring | Garmin | Polar |
|--------|:-----------:|:------:|:---------:|:------:|:-----:|
| Heart Rate | Yes | Yes | Yes | Yes | Yes |
| HRV (SDNN) | Yes | Limited | Yes | Yes | Yes |
| Sleep Stages | Yes | Yes | Yes | Yes | Limited |
| SpO2 | Yes | Yes | Yes | Yes | No |
| ECG | Yes | No | No | No | No |
| Skin Temp | No | Yes | Yes | No | No |

When a device does not support a particular measurement, the corresponding 0..1 MS element should simply be omitted rather than populated with a null or zero value.

## Binding Strength Interpretation

| Strength | Meaning for Implementers |
|----------|--------------------------|
| **Required** (30%) | Must use a code from the specified ValueSet. No exceptions. |
| **Extensible** (65%) | Should use a code from the ValueSet. May use an alternative code if the ValueSet does not cover the concept. |
| **Preferred** (5%) | Encouraged to use the ValueSet but may freely use alternatives. |

Most bindings in this IG use **extensible** strength, allowing local implementations to extend terminology while maintaining interoperability.
