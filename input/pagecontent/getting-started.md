# Getting Started

This guide helps implementers integrate iOS Health App and wearable device data using this FHIR Implementation Guide.

## Prerequisites

- FHIR R4 (4.0.1) server or client
- Familiarity with FHIR Observation, Patient, and Device resources
- Access to consumer health data (iOS HealthKit, Fitbit API, Garmin Connect, etc.)

## Quick Start: Your First Observation

### Step 1: Choose a Domain Profile

This IG covers 11 lifestyle medicine domains. Start with the domain most relevant to your use case:

| Domain | Primary Profile | LOINC Panel |
|--------|----------------|-------------|
| **Vital Signs** | VitalSignsObservation | Heart rate, BP, SpO2 |
| **Physical Activity** | PhysicalActivityObservation | Steps, calories, workouts |
| **Sleep** | SleepObservation | Sleep stages, duration, quality |
| **Body Metrics** | BodyMetricsObservation | Weight, BMI, body composition |
| **Nutrition** | NutritionIntakeObservation | Macronutrients, hydration |
| **Mindfulness** | MindfulnessObservation | Meditation, breathing exercises |
| **Environmental** | EnvironmentalObservation | Noise, UV exposure |
| **HRV** | HRVObservation | SDNN, RMSSD, frequency domain |
| **ECG** | ConsumerECGObservation | Consumer ECG recordings |
| **Social** | SocialInteractionObservation | Social contacts, support networks |
| **Reproductive** | ReproductiveHealthObservation | Cycle tracking, symptoms |

### Step 2: Map Your Data

Each profile uses standard LOINC codes where available, with custom codes from `LifestyleMedicineTemporaryCS` for concepts not yet in LOINC (e.g., HRV RMSSD, sleep quality scores).

**Example**: Sleep data from Apple Watch

```json
{
  "resourceType": "Observation",
  "meta": {
    "profile": ["https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/activity-observation"]
  },
  "status": "final",
  "category": [{
    "coding": [{"system": "http://terminology.hl7.org/CodeSystem/observation-category", "code": "activity"}]
  }],
  "code": {
    "coding": [{"system": "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs", "code": "sleep-panel"}]
  },
  "subject": {"reference": "Patient/example"},
  "effectivePeriod": {
    "start": "2024-03-19T22:00:00Z",
    "end": "2024-03-20T06:30:00Z"
  },
  "component": [
    {
      "code": {"coding": [{"system": "http://loinc.org", "code": "103213-5", "display": "Duration in bed"}]},
      "valueQuantity": {"value": 510, "unit": "minute", "system": "http://unitsofmeasure.org", "code": "min"}
    },
    {
      "code": {"coding": [{"system": "http://loinc.org", "code": "93832-4", "display": "Sleep duration"}]},
      "valueQuantity": {"value": 472, "unit": "minute", "system": "http://unitsofmeasure.org", "code": "min"}
    },
    {
      "code": {"coding": [{"system": "http://loinc.org", "code": "93831-6", "display": "Deep sleep duration"}]},
      "valueQuantity": {"value": 95, "unit": "minute", "system": "http://unitsofmeasure.org", "code": "min"}
    }
  ]
}
```

### Step 3: Include Device Information

Consumer wearable data SHOULD include a Device resource identifying the source:

```json
{
  "resourceType": "Device",
  "deviceName": [{"name": "Apple Watch Series 9", "type": "user-friendly-name"}],
  "manufacturer": "Apple Inc.",
  "type": {
    "coding": [{"system": "https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs", "code": "sleep-monitoring-device"}]
  }
}
```

### Step 4: Use ConceptMaps for Terminology Translation

This IG provides 28 ConceptMaps for translating between vendor-specific codes and standard terminologies. Use the FHIR `$translate` operation:

```
GET [base]/ConceptMap/$translate?system=https://2rdoc.pt/ig/ios-lifestyle-medicine/CodeSystem/lifestyle-medicine-temporary-cs&code=sleep-deep&target=http://loinc.org
```

## Architecture Overview

```
Consumer Device (Apple/Fitbit/Garmin/Oura/Polar)
       │
       ▼
  HealthKit / Vendor API
       │
       ▼
  FHIR Client (this IG's profiles)
       │
       ├── Observation (domain-specific profile)
       ├── Device (wearable metadata)
       └── Patient (subject)
       │
       ▼
  FHIR Server / EHR
```

## Dual-Coding Strategy

For concepts with LOINC/SNOMED equivalents, use standard codes. For concepts in the 86% terminology gap (no standard code exists), use `LifestyleMedicineTemporaryCS` with the understanding that these codes will migrate to LOINC/SNOMED as standards evolve.

See [Terminology Verification Protocol](terminology-verification.html) for details on the 4-level verification process used to validate all code assignments.

## Dependencies

This IG depends on:
- [HL7 IPS](http://hl7.org/fhir/uv/ips) v2.0.0 — International Patient Summary
- [HL7 Physical Activity IG](http://hl7.org/fhir/us/physical-activity) v1.0.0 — Steps, calories, EVS
- [HL7 PHD IG](http://hl7.org/fhir/uv/phd) v1.1.0 — Device metadata patterns
- [IHE PCF](https://profiles.ihe.net/ITI/PCF) v1.1.0 — Consent management

## Next Steps

- Review the [Must Support](must-support.html) page for obligation definitions
- Check [Conformance Requirements](conformance.html) for compliance criteria
- Browse the [Artifacts](artifacts.html) page for complete profile listings
- See [Known Issues](known-issues.html) for current limitations
