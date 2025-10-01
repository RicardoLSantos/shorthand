# Body Measurements

## Overview
This module describes how anthropometric and body composition data collected from the iOS Health App are mapped to FHIR resources. These measurements are fundamental for assessing nutritional status and monitoring lifestyle medicine interventions.

## Data Sources
The iOS Health App collects body measurements from the following sources:
- Connected smart scales
- Bioimpedance devices 
- Manual measurements
- Integrated third-party apps

## Types of Collected Data

### 1. Basic Measurements
- Body weight
- Height
- BMI (automatically calculated)
- Waist circumference

### 2. Body Composition
- Body fat percentage
- Lean mass
- Body water
- Muscle mass 
- Bone mass

### 3. Segmental Analysis
- Body fat distribution
- Muscle mass distribution
- Body symmetry

### 4. Trends and Analysis
- Weight variation
- BMI history
- Body composition progression
- Goals and objectives

## Collection Frequency
- Weight: Recommended daily
- Height: Periodically 
- Body composition: Weekly
- Circumference: Monthly

## FHIR Resources
The body measurements are mapped to FHIR Observation resources with specific profiles for each type of measurement.

### Examples
- Weight measurements use the [body-weight](StructureDefinition-weight-observation.html) profile
- Height uses the [body-height](StructureDefinition-height-observation.html) profile
- BMI calculations use the [bmi](StructureDefinition-bmi-observation.html) profile

## Supported Operations

### Search
- patient + date
- patient + code
- patient + date-range + code
- patient + category

### Search Parameters
- patient: Patient identifier
- date: Measurement date
- code: Type of body measurement
- category: Category (vital-signs)

### Search Examples
GET [base]/Observation?category=vital-signs&patient=[id]&code=29463-7
GET [base]/Observation?category=vital-signs&patient=[id]&date=ge2024-03-19
GET [base]/Observation?category=vital-signs&patient=[id]&code=88365-2&date=ge2024-01-01&date=le2024-12-31
Copy
## Conformance

### Must Support
Elements marked with MS must be supported:
- status: Measurement status
- category: Vital signs category
- code: Type of measurement (LOINC code)
- subject: Reference to patient
- effectiveDateTime: When measurement was taken
- valueQuantity: The measurement value and unit
- component: Body composition components (for composition measurements)

### Device Support
The following device types are supported for data capture:
- Smart scales
- Bioimpedance analyzers
- Manual entry
- Third-party apps via HealthKit

### Security Requirements
- Patient access control
- Device authentication
- Data validation rules

## iOS Health App to FHIR Mapping

### Core Fields
| iOS Health App | FHIR Path | LOINC Code | Description |
|----------------|-----------|-------------|-------------|
| Weight | WeightObservation.valueQuantity | 29463-7 | Body weight measurement |
| Height | HeightObservation.valueQuantity | 8302-2 | Body height measurement |
| BMI | BMIObservation.valueQuantity | 39156-5 | Body Mass Index calculation |
| Body Fat % | BodyCompositionObservation.component[bodyFat] | 41982-0 | Percentage of body fat |
| Lean Mass | BodyCompositionObservation.component[leanMass] | 291-7 | Lean body mass |
| Body Water | BodyCompositionObservation.component[bodyWater] | 73708-0 | Total body water |
| Muscle Mass | BodyCompositionObservation.component[muscleMass] | 73713-0 | Skeletal muscle mass |
| Bone Mass | BodyCompositionObservation.component[boneMass] | 73711-4 | Bone mass measurement |

### Implementation Considerations

1. Data Validation
- Physiological range validation
- Sudden variation detection
- Cross-validation between related measurements
- Unit conversion and standardization

2. Automatic Calculations
- BMI calculation from weight and height
- Cross-validation of composition measurements
- Percentage changes and trends
- Statistical analysis of measurements

3. Frequency and Timing
- Measurement frequency recommendations
- Preferred measurement timing
- Minimum intervals between measurements
- Time zone handling for measurements

4. Data Quality
- Measurement source (device/manual)
- Device calibration status
- Measurement conditions
- Data completeness checks

5. Goal Integration
- Goal setting and tracking
- Progress monitoring
- Significant deviation alerts
- Personalized target ranges

6. Reports and Visualizations
- Trend charts and graphs
- Reference comparisons
- Body composition analysis
- Progress reports and summaries

### Device Integration

1. Smart Scale Integration
- Bluetooth connectivity
- Data synchronization
- Error handling
- Battery status monitoring

2. Bioimpedance Analysis
- Device calibration requirements
- Measurement protocol
- Environmental conditions
- Quality control checks

3. Manual Entry
- Data validation rules
- Required fields
- Unit conversion support
- Entry confirmation

### Error Handling

1. Device Errors
- Connection failures
- Calibration errors
- Battery warnings
- Invalid measurements

2. Data Validation Errors
- Out of range values
- Inconsistent measurements
- Missing required data
- Invalid units

3. Synchronization Errors
- Network connectivity issues
- Data transfer failures
- Version conflicts
- Retry mechanisms

