
## FHIR Resources

### Main Resources Used
- Observation: For cycle tracking and temperature measurements
- QuestionnaireResponse: For symptom reporting
- CarePlan: For fertility planning
- Goal: `ReproductiveHealthGoal` — what the person aims for (conception, avoiding an unwanted pregnancy, preconception health, regular cycles, normal weight; `ReproductiveGoalDescriptionVS`) with measurable targets (`ReproductiveGoalMeasureVS`); since 0.5.2 — until then the IG had only an unbound value set here

### Parameters
- patient: Patient identifier
- date: Record date
- category: reproductive-health
- code: Specific measurement type

### Search Examples
GET [base]/Observation?category=reproductive-health&patient=[id]&date=[date]
GET [base]/Observation?code=menstrual-cycle&patient=[id]

## Conformance

### Must Support Elements
Elements marked with MS must be supported:
- status
- category
- code
- subject
- effectiveDateTime
- value[x]
- component (for composite measurements)

## Implementation Considerations

### Data Collection
1. Automated Measurements
   - Temperature tracking
   - Activity patterns
   - Sleep quality
   - Heart rate variability

2. Manual Records
   - Symptom logging
   - Cycle tracking
   - Fertility signs
   - Medication use

### Data Analysis
1. Pattern Recognition
   - Cycle regularity
   - Temperature trends
   - Symptom correlations
   - Fertility windows

2. Alert Generation
   - Cycle predictions
   - Fertile days
   - Temperature changes
   - Symptom patterns

### Clinical Integration
1. Reports
   - Cycle summaries
   - Fertility tracking
   - Symptom patterns
   - Treatment responses

2. Decision Support
   - Fertility planning
   - Cycle abnormalities
   - Risk identification
   - Treatment monitoring

### Privacy & Security
1. Data Protection
   - Encryption
   - Access control
   - Consent management
   - Data sharing

2. User Control
   - Data visibility
   - Sharing preferences
   - Export options
   - Deletion rights

## iOS Health App to FHIR Mapping

### Core Fields
| iOS Health App | FHIR Path | Code |
|----------------|-----------|------|
| Cycle Start | Observation.effectiveDateTime (the start date itself) | — (LOINC 8665-2 "Last menstrual period start date" was listed until 0.5.1 in a value set that no profile bound; that value set was replaced in 0.5.2 by the goal value sets, and the code is no longer bound anywhere) |
| Cycle Frequency | ReproductiveObservation.component[frequency].valueQuantity (periods per year, UCUM `/a`) | LOINC 92656-8 "Number of menstrual periods per year" |
| Cycle Regularity | ReproductiveObservation.component[regularity].valueCodeableConcept (`MenstrualCycleRegularityVS`) | SNOMED CT 364307006 "Regularity of menstrual cycle" |
| Flow Duration | ReproductiveObservation.component[duration].valueQuantity | LOINC 3144-3 "Last menstrual period duration" |
| Basal Temperature | BodyTemperatureObservation (code LOINC 8310-5 "Body temperature") — component[basalBodyTemperature].valueQuantity | LOINC 8328-7 "Axillary temperature" |
| Cervical Mucus | FertilityObservation.component[cervicalMucus].valueCodeableConcept (`cervical-mucus-vs`) | LOINC 10570-0 "Consistency of Cervical mucus" |

The codes in this table are the ones the profiles bind (re-verified on 2026-09-21 in the Athena/Vocab2 snapshots and on tx.fhir.org, LOINC 2.82 / SNOMED CT International 20250201); iOS Health does not record a cycle-length quantity as such — the IG expresses cycle frequency and regularity as above.

### Goals
`ReproductiveHealthGoal` (since 0.5.2) profiles `Goal` for reproductive-health aims: `description` (required, extensible binding to `ReproductiveGoalDescriptionVS` — SNOMED CT 169449001 "Trying to conceive", 710973002 "Prevention of unwanted pregnancy", 429070000 "Preconception care", 302757007 "Regular periods", 43664005 "Normal weight"), `subject` (Patient), `expressedBy`, and zero or more `target`s whose `measure` is bound (extensible) to `ReproductiveGoalMeasureVS` (SNOMED CT 364307006 "Regularity of menstrual cycle", 161716008 "Usual length of menstrual cycle"; LOINC 92656-8 "Number of menstrual periods per year", 39156-5 "Body mass index (BMI) [Ratio]", 29463-7 "Body weight") and whose `detail[x]` is a coded state (for regularity, `MenstrualCycleRegularityVS`), a Quantity or a Range. The example `ReproductiveHealthGoalExample` states a regular-cycle goal with two targets. A `CarePlanLifestyleMedicine` may reference the goal through `CarePlan.goal`. Which goals suit a person is a clinical decision; the profile carries none. All ten codes were verified on 2026-09-22 in the Vocab2/Athena snapshots and on tx.fhir.org (SNOMED CT International 20250201, LOINC 2.82).

### Integration Requirements
1. HealthKit Access
   - Permissions setup
   - Data synchronization
   - Background updates
   - Error handling

2. Data Validation
   - Range checks
   - Pattern validation
   - Temporal consistency
   - Cross-reference verification

### Performance Considerations
1. Data Processing
   - Real-time updates
   - Batch processing
   - Historical data
   - Trend analysis

2. Resource Optimization
   - Battery usage
   - Storage efficiency
   - Network usage
   - Processing load

### User Interface Guidelines
1. Data Entry
   - Quick input methods
   - Template options
   - Reminder settings
   - Validation feedback

2. Visualization
   - Cycle calendar
   - Temperature charts
   - Symptom tracking
   - Fertility windows

3. Notifications
   - Cycle predictions
   - Fertile days
   - Temperature alerts
   - Medication reminders


## Detailed Implementation Considerations

### Data Management
1. Storage Strategy
   - Real-time data storage
   - Historical data archival
   - Data compression techniques
   - Backup procedures
   - Recovery mechanisms
   - Version control

2. Data Quality
   - Input validation rules
   - Data completeness checks
   - Cross-validation methods
   - Anomaly detection
   - Error correction procedures
   - Quality metrics

### Clinical Integration Details
1. Provider Integration
   - Clinical portal access
   - Data export formats
   - Integration APIs
   - Real-time notifications
   - Emergency alerts
   - Audit trails

2. Decision Support
   - Clinical guidelines integration
   - Risk assessment algorithms
   - Treatment recommendations
   - Follow-up protocols
   - Alert thresholds
   - Intervention triggers

### Advanced Analytics
1. Pattern Recognition
   - Cycle irregularity detection
   - Symptom correlation analysis
   - Fertility window prediction
   - Risk factor identification
   - Trend analysis
   - Outcome prediction

2. Machine Learning Integration
   - Prediction models
   - Pattern classification
   - Anomaly detection
   - Personalization
   - Model training
   - Performance monitoring

### System Integration
1. External Systems
   - EHR integration
   - Laboratory systems
   - Pharmacy systems
   - Insurance systems
   - Research databases
   - Public health reporting

2. Data Exchange
   - HL7 FHIR APIs
   - Standard terminologies
   - Data mapping
   - Transform rules
   - Validation checks
   - Error handling

### Performance Optimization
1. Resource Management
   - CPU usage
   - Memory allocation
   - Storage optimization
   - Network bandwidth
   - Battery consumption
   - Cache strategy

2. Scalability
   - Load balancing
   - Database sharding
   - Service distribution
   - Queue management
   - Batch processing
   - Real-time processing

### User Experience
1. Accessibility
   - Screen reader support
   - Color contrast
   - Font sizing
   - Touch targets
   - Keyboard navigation
   - Voice input

2. Localization
   - Multiple languages
   - Cultural considerations
   - Date formats
   - Unit preferences
   - Terminology adaptation
   - Regional compliance

### Security Details
1. Authentication
   - Multi-factor authentication
   - Biometric options
   - Session management
   - Token handling
   - Password policies
   - Account recovery

2. Authorization
   - Role-based access
   - Attribute-based control
   - Dynamic permissions
   - Temporary access
   - Emergency access
   - Audit logging

3. Compliance
   - HIPAA requirements
   - GDPR compliance
   - Local regulations
   - Industry standards
   - Security frameworks
   - Privacy policies

