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
