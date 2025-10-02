# Physical Activity

## General Description
This module describes how physical activity data from the iOS Health App is mapped to FHIR resources.

## Data Source
The iOS Health App collects physical activity data in the following ways:
- iPhone sensors (step counter, GPS)
- Apple Watch (when available)
- Integrated third-party apps

## Types of Data Collected

### Steps
- Total step count
- Start and end timestamp
- Data source

### Distance
- Total distance covered
- Unit of measurement (meters/kilometers)
- Type of movement (walking/running)

### Workouts
- Type of exercise
- Duration
- Calories burned
- Distance (when applicable)
- Heart rate (when available)

### Energy
- Active calories
- Resting calories
- Total calories

## Collection Frequency
- Steps: Continuous when in motion
- Distance: Continuous during activity
- Workouts: Per session
- Energy: Daily calculation

## Supported Operations

### Search
- patient + date
- patient + activity-type
- patient + date + activity-type

### Search Parameters
- patient: Patient identifier
- date: Activity date
- activity-type: Type of physical activity

### Search Examples
GET [base]/Observation?category=activity&patient=[id]&date=[date]
GET [base]/Observation?category=activity&patient=[id]&code=[activity-type]
## Conformance

### Must Support
Elements marked with MS must be supported by the implementing system:
- status
- category
- code
- subject
- effectiveDateTime
- component.steps
- component.distance
- component.duration
- component.energy
