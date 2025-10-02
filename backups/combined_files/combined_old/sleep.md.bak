# Sleep

## General Description
This module describes how sleep data collected from the iOS Health App is mapped to FHIR resources. Sleep monitoring is a critical component of lifestyle medicine, providing insights into sleep quality and quantity.

## Data Source
The iOS Health App collects sleep data from the following sources:
- Apple Watch
- Integrated third-party apps
- Manual records

## Types of Collected Data

### Key Metrics
1. Time in Bed
   - Start time
   - End time
   - Total duration

2. Sleep Time
   - Total time sleeping
   - Sleep efficiency (percentage of time in bed actually sleeping)

3. Sleep Stages
   - Deep Sleep
   - REM Sleep
   - Light Sleep
   - Awake Time

4. Physiological Data During Sleep
   - Respiratory rate
   - Heart rate variability
   - Average heart rate

5. Sleep Quality
   - Sleep interruptions
   - Time to fall asleep
   - Sleep consistency

## Collection Frequency
- Continuous data during sleep period
- Daily metrics aggregation
- Weekly trend analysis

## Supported Operations

### Search
- patient + date
- patient + date-range
- patient + category

### Search Parameters
- patient: Patient identifier
- date: Sleep record date
- category: Observation category (always "sleep")

### Search Examples
GET [base]/Observation?category=sleep&patient=[id]&date=[date]
GET [base]/Observation?category=sleep&patient=[id]&date=ge[start]&date=le[end]

## Conformance

### Must Support
Elements marked with MS must be supported:
- status
- category
- code
- subject
- effectiveDateTime/effectivePeriod
- component.timeInBed
- component.totalSleepTime
- component.deepSleep
- component.remSleep
- component.lightSleep
- component.respiratoryRate
- component.heartRateVariability
- component.interruptions

### Cardinality
- Time in bed and total sleep time are mandatory (1..1)
- Other components are optional (0..1)

### Validation
- Total sleep time must be less than or equal to time in bed
- The sum of sleep stages must equal the total sleep time

## iOS Health App to FHIR Mapping

### Main Fields
| iOS Health App | FHIR Path |
|----------------|-----------|
| Time in Bed | component[timeInBed].valueQuantity |
| Sleep Time | component[totalSleepTime].valueQuantity |
| Deep Sleep | component[deepSleep].valueQuantity |
| REM Sleep | component[remSleep].valueQuantity |
| Light Sleep | component[lightSleep].valueQuantity |
| Respiratory Rate | component[respiratoryRate].valueQuantity |
| HRV | component[heartRateVariability].valueQuantity |
| Interruptions | component[interruptions].valueQuantity |

### Implementation Considerations
1. Data Aggregation
   - Data is collected continuously during sleep
   - Nightly aggregation is done automatically
   - Metrics are calculated per night of sleep

2. Data Quality
   - Temporal overlap validation
   - Consistency check between metrics
   - Outlier detection

3. Privacy and Security
   - Sensitive data requiring protection
   - User consent required
   - Anonymization for research use
