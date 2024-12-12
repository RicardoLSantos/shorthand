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
