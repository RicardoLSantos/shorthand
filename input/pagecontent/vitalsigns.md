# Vital Signs

## General Description
This module describes how vital signs data collected from the iOS Health App are mapped to FHIR resources. Vital signs are fundamental physiological measurements that reflect essential body functions and health states.

## Data Source
The iOS Health App collects vital signs from the following sources:
- Apple Watch
- Bluetooth-connected medical devices
- Integrated third-party apps
- Manual records

## Types of Data Collected

### 1. Heart Rate
- Continuous measurement (Apple Watch)
- Resting heart rate
- Exercise heart rate
- Recovery heart rate
- Heart rate variability (HRV)
- Anomaly recording

### 2. Blood Pressure
- Systolic pressure
- Diastolic pressure
- Date and time of measurement
- Body position during measurement
- Device used

### 3. Oxygen Saturation (SpO2)
- Saturation percentage
- Trends over time
- Sleep measurements
- Activity measurements

### 4. Body Temperature
- Temperature in Celsius/Fahrenheit
- Measurement location
- Measurement method

### 5. Respiratory Rate
- Breaths per minute
- Resting measurements
- Sleep measurements
- Exercise measurements

### 6. ECG (Electrocardiogram)
- Trace recording
- Rhythm classification
- Beat interval
- Anomaly analysis

## Collection Frequency
- Heart Rate: Continuous (when using Apple Watch)
- Blood Pressure: Per measurement
- SpO2: Continuous or on-demand
- Temperature: Per measurement
- Respiratory Rate: Continuous during sleep/exercise
- ECG: On-demand/recording

## Operations Supported

### Search
- patient + date
- patient + code
- patient + category
- patient + code + date-range

### Search Parameters
- patient: Patient identifier
- date: Measurement date
- code: Vital sign type
- category: Category (vital-signs)

### Search Examples
GET [base]/Observation?category=vital-signs&patient=[id]&code=8867-4
GET [base]/Observation?category=vital-signs&patient=[id]&date=ge2024-03-19

## Conformance

### Must Support
Elements marked with MS must be supported:
- status
- category
- code
- subject
- effectiveDateTime
- valueQuantity
- component (when applicable)

### Cardinality
- Blood pressure requires systolic and diastolic components
- Other vital signs require at least one value

## iOS Health App to FHIR Mapping

### Main Fields
| iOS Health App | FHIR Path | LOINC Code |
|----------------|-----------|-------------|
| Heart Rate | valueQuantity | 8867-4 |
| HRV | component[heartRateVariability] | 80404-7 |
| Blood Pressure Systolic | component[systolic] | 8480-6 |
| Blood Pressure Diastolic | component[diastolic] | 8462-4 |
| SpO2 | valueQuantity | 2708-6 |
| Body Temperature | valueQuantity | 8310-5 |
| Respiratory Rate | valueQuantity | 9279-1 |

### Implementation Considerations

1. Source Prioritization
- Apple Watch has priority for continuous measurements
- Validated medical devices for specific measurements
- Manual entries as last resort

2. Data Validation
- Verification of values within physiological ranges
- Outlier detection
- Temporal consistency of measurements

3. Data Aggregation
- Continuous measurements aggregated in intervals
- Calculation of averages, minimums and maximums
- Trends over time

4. Accuracy and Reliability
- Indication of measurement source/device
- Measurement confidence level
- Device calibration and validation

5. Alert Management
- Definition of normal limits
- Notification of abnormal values
- Critical alert escalation

6. Storage and Retention
- Data retention policy
- Historical data compression
- Backup and recovery
