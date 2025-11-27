# Inflammatory Markers

This page documents the inflammatory biomarker profiles developed for the iOS Lifestyle Medicine Implementation Guide, based on findings from systematic review RS1 (Wearables and Inflammation).

## Clinical Background

Chronic low-grade inflammation is increasingly recognized as a key mechanism linking lifestyle factors to cardiovascular disease, metabolic disorders, and accelerated aging. Heart rate variability (HRV) metrics, particularly RMSSD, show consistent inverse correlations with inflammatory biomarkers such as C-reactive protein (CRP) and interleukin-6 (IL-6).

### Key Evidence

| Study | Finding | Sample |
|-------|---------|--------|
| Williams et al. 2019 | HRV inversely correlated with CRP (r = -0.15 to -0.20) | Meta-analysis, 26 studies |
| Pearson et al. 2003 | hs-CRP risk stratification for cardiovascular disease | AHA/CDC Scientific Statement |
| Ridker et al. 2002 | CRP superior to LDL for CV event prediction | 28,000 women, 8-year follow-up |

## Profiles

### Base Profile: InflammatoryMarkerObservation

The base profile for all inflammatory biomarker observations, constraining FHIR Observation for laboratory-measured inflammatory markers.

**Key Constraints:**
- Category: `laboratory`
- Status: `final` or `preliminary`
- Subject: Required (Patient reference)
- Effective[x]: Required (dateTime or Period)

### Specific Profiles

| Profile | LOINC Code | Description | Units |
|---------|------------|-------------|-------|
| [CRPObservation](StructureDefinition-CRPObservation.html) | 1988-5 | C-reactive protein | mg/L |
| [HsCRPObservation](StructureDefinition-HsCRPObservation.html) | 30522-7 | High-sensitivity CRP | mg/L |
| [IL6Observation](StructureDefinition-IL6Observation.html) | 26881-3 | Interleukin-6 | pg/mL |
| [TNFAlphaObservation](StructureDefinition-TNFAlphaObservation.html) | 3074-2 | Tumor necrosis factor alpha | pg/mL |

### Correlation Profile: HRVInflammationCorrelationObservation

A specialized profile for documenting the observed correlation between HRV metrics and inflammatory markers in individual patients.

**Key Elements:**
- `derivedFrom`: References to HRV and inflammatory marker observations
- `component`: Correlation coefficient, trend assessment
- `interpretation`: Clinical significance

## hs-CRP Cardiovascular Risk Classification

Based on AHA/CDC guidelines (Pearson 2003, Ridker 2002):

| Risk Category | hs-CRP Level | Clinical Action |
|---------------|--------------|-----------------|
| Low Risk | < 1.0 mg/L | Standard prevention |
| Moderate Risk | 1.0 - 3.0 mg/L | Lifestyle modification |
| High Risk | > 3.0 mg/L | Aggressive intervention |
| Acute Inflammation | > 10.0 mg/L | Investigate underlying cause |

## ValueSets

### InflammatoryMarkerVS

Contains LOINC codes for inflammatory biomarkers identified in RS1:

```
ValueSet: InflammatoryMarkerVS
* $LOINC#1988-5   "C reactive protein [Mass/volume] in Serum or Plasma"
* $LOINC#30522-7  "C reactive protein [Mass/volume] in Serum or Plasma by High sensitivity method"
* $LOINC#26881-3  "Interleukin 6 [Mass/volume] in Serum or Plasma"
* $LOINC#3074-2   "Fibrinogen [Mass/volume] in Platelet poor plasma by Coagulation assay"
```

### HsCRPRiskCategoryVS

Risk stratification categories per AHA/CDC guidelines:

```
ValueSet: HsCRPRiskCategoryVS
* HsCRPRiskCS#low-risk      "Low cardiovascular risk"
* HsCRPRiskCS#moderate-risk "Moderate cardiovascular risk"
* HsCRPRiskCS#high-risk     "High cardiovascular risk"
* HsCRPRiskCS#acute         "Acute inflammation - not for CV risk"
```

### HRVInflammationTrendVS

SNOMED CT codes from mCODE IG for trend assessment:

```
ValueSet: HRVInflammationTrendVS
* $SCT#268910001  "Patient's condition improved"
* $SCT#359746009  "Patient's condition stable"
* $SCT#271299001  "Patient's condition worsened"
```

## Usage Examples

### Example 1: Normal CRP Result

```json
{
  "resourceType": "Observation",
  "status": "final",
  "category": [{
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/observation-category",
      "code": "laboratory"
    }]
  }],
  "code": {
    "coding": [{
      "system": "http://loinc.org",
      "code": "1988-5",
      "display": "C reactive protein [Mass/volume] in Serum or Plasma"
    }]
  },
  "valueQuantity": {
    "value": 0.8,
    "unit": "mg/L",
    "system": "http://unitsofmeasure.org",
    "code": "mg/L"
  },
  "interpretation": [{
    "coding": [{
      "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
      "code": "N",
      "display": "Normal"
    }]
  }]
}
```

### Example 2: Elevated hs-CRP with Risk Category

```json
{
  "resourceType": "Observation",
  "status": "final",
  "code": {
    "coding": [{
      "system": "http://loinc.org",
      "code": "30522-7",
      "display": "C reactive protein [Mass/volume] by High sensitivity method"
    }]
  },
  "valueQuantity": {
    "value": 2.5,
    "unit": "mg/L"
  },
  "interpretation": [{
    "coding": [{
      "system": "https://fmup.up.pt/ios-lifestyle-medicine/CodeSystem/hscrp-risk-cs",
      "code": "moderate-risk",
      "display": "Moderate cardiovascular risk"
    }]
  }],
  "note": [{
    "text": "Recommend lifestyle modification per AHA/CDC guidelines"
  }]
}
```

### Example 3: HRV-Inflammation Correlation

```json
{
  "resourceType": "Observation",
  "status": "final",
  "code": {
    "coding": [{
      "system": "https://fmup.up.pt/ios-lifestyle-medicine/CodeSystem/lifestyle-observation-cs",
      "code": "hrv-inflammation-correlation",
      "display": "HRV-Inflammation correlation assessment"
    }]
  },
  "derivedFrom": [
    {"reference": "Observation/hrv-rmssd-example"},
    {"reference": "Observation/crp-example"}
  ],
  "component": [{
    "code": {
      "coding": [{
        "system": "http://snomed.info/sct",
        "code": "268910001",
        "display": "Patient's condition improved"
      }]
    },
    "valueString": "RMSSD increased 15% while CRP decreased 20% over 30 days"
  }]
}
```

## Clinical Integration

### Wearable + Laboratory Workflow

1. **Continuous HRV Monitoring**: Wearable devices capture daily RMSSD trends
2. **Periodic Laboratory Testing**: hs-CRP measured quarterly or as clinically indicated
3. **Correlation Analysis**: HRVInflammationCorrelationObservation documents relationship
4. **Clinical Decision Support**: Alerts when inverse correlation breaks down (rising CRP despite stable/rising HRV suggests acute process)

### Learning Health System Integration

This Implementation Guide supports the Learning Health System cycle by:

1. **Data Collection**: Standardized capture of both wearable HRV and laboratory inflammatory markers
2. **Knowledge Generation**: Correlation patterns identified across patient populations
3. **Evidence Application**: Risk stratification informs personalized lifestyle interventions
4. **Outcome Measurement**: Track inflammatory marker improvements following lifestyle changes

## References

1. Williams DP, et al. Heart rate variability and inflammation: A meta-analysis of human studies. Brain Behav Immun. 2019;80:219-226. doi:10.1016/j.bbi.2019.03.009

2. Pearson TA, et al. Markers of inflammation and cardiovascular disease. Circulation. 2003;107(3):499-511. doi:10.1161/01.CIR.0000052939.59093.45

3. Ridker PM, et al. Comparison of C-reactive protein and low-density lipoprotein cholesterol levels in the prediction of first cardiovascular events. N Engl J Med. 2002;347(20):1557-1565. doi:10.1056/NEJMoa021993

4. HL7 mCODE Implementation Guide v4.0.0. Available at: https://hl7.org/fhir/us/mcode/

---

*This documentation is part of the iOS Lifestyle Medicine FHIR Implementation Guide, developed at the Faculty of Medicine, University of Porto (FMUP).*
