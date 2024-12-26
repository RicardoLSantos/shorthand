
## FHIR Resources

### Main Resources Used
- Observation: For recording mobility metrics
- RiskAssessment: For fall risk evaluations
- Goal: For mobility improvement targets
- CarePlan: For mobility enhancement plans

### Parameters
- patient: Patient identifier
- date: Assessment date
- category: mobility
- code: Specific mobility metric

### Search Examples
GET [base]/Observation?category=mobility&patient=[id]&date=[date]
GET [base]/Observation?code=walking-steadiness&patient=[id]

## Conformance

### Must Support
Elements marked with MS must be supported:
- status
- category
- code
- subject
- effectiveDateTime
- value[x]
- device
- component (for composite measurements)

### Implementation Notes
1. Data Processing
   - Raw sensor data filtering
   - Algorithmic analysis
   - Trend calculation
   - Alert generation

2. Data Quality
   - Measurement validation
   - Device calibration
   - Environmental factors
   - Movement context

3. Integration Requirements
   - HealthKit permissions
   - Data synchronization
   - Real-time processing
   - Historical data access

## iOS Health App to FHIR Mapping

### Core Fields
| iOS Health App | FHIR Path |
|---------------|-----------|
| Walking Steadiness | Observation.component[steadiness] |
| Walking Speed | Observation.component[speed] |
| Step Length | Observation.component[stepLength] |
| Double Support Time | Observation.component[supportTime] |
| Walking Asymmetry | Observation.component[asymmetry] |

### Implementation Considerations
1. Data Flow
   - Continuous monitoring
   - Batch processing
   - Event triggers
   - Alert handling

2. Privacy & Security
   - Data encryption
   - Access control
   - Audit trails
   - Consent management

3. Clinical Integration
   - Risk assessment
   - Treatment planning
   - Progress monitoring
   - Outcome evaluation

EOF
