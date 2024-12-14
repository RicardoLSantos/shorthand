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
- Weight measurements use the [body-weight](StructureDefinition-body-weight.html) profile
- Height uses the [body-height](StructureDefinition-body-height.html) profile
- BMI calculations use the [bmi](StructureDefinition-bmi.html) profile

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
