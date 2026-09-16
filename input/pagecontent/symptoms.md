
## FHIR Resources

### Main Resources Used
- Observation: For recording symptom details and measurements
- QuestionnaireResponse: For capturing structured symptom assessments
- Condition: For documenting ongoing symptoms
- ClinicalImpression: For clinical assessment of symptoms

### Parameters
- patient: Patient identifier
- date: Symptom record date
- category: symptom-assessment
- code: Specific symptom type

### Search Examples
GET [base]/Observation?category=symptom&patient=[id]&date=[date]
GET [base]/Observation?code=severity&patient=[id]

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

## iOS Health App to FHIR Mapping

### Core Fields
| iOS Health App | FHIR path (recommended shape) | Code |
|----------------|-------------------------------|------|
| Symptom Type | `Observation.code` | LOINC `75325-1` "Symptom" — or a SNOMED CT symptom concept as the code itself, as the shipped examples do (e.g. `84229001` "Fatigue") |
| Severity | `Observation.component[severity].valueInteger` (0–10) | LOINC `72514-3` "Pain severity - 0-10 verbal numeric rating [Score] - Reported" — an integer score, bound the same way in `ReproductiveObservation` |
| Duration | `Observation.component[duration].valueQuantity` (UCUM time unit) | LOINC `64748-7` "Symptoms duration" |
| Frequency | `Observation.component[frequency].valueCodeableConcept` | no generic LOINC code exists (LOINC carries only instrument-specific frequency scores, e.g. `72193-6` KCCQ, `88471-8` SAQ); the IG uses `SymptomFrequencyVS` (interim codes in `LifestyleMedicineTemporaryCS`) |

> **Scope note (0.5.0).** The IG does not define a dedicated Symptom *Observation* profile. Symptom observations use the base `Observation` resource — see `ExampleSymptomSeverity` and `ChronicSymptomExample` — together with the `SymptomQuestionnaire` profile and the `SymptomFrequencyVS`, `SymptomImpactVS` and `SymptomProgressionVS` ValueSets. The paths above are the recommended shape; the severity and duration components mirror the component slicing of `ReproductiveObservation`. Two codes previously listed here (`103333-2`, `103334-0`) do not exist in LOINC (not resolvable in LOINC 2.82) and were replaced on 2026-09-16 after verification against OHDSI Athena and `tx.fhir.org`.

### Implementation Considerations

1. Data Collection
   - Questionnaire design
   - User interface optimization
   - Data validation rules
   - Real-time feedback
   - Multi-language support
   - Accessibility features

2. Data Quality
   - Input validation
   - Consistency checks
   - Temporal validation
   - Cross-reference verification
   - Completeness assessment
   - Error detection

3. Clinical Integration
   - Care plan updates
   - Alert generation
   - Decision support
   - Provider notifications
   - Trend analysis
   - Risk assessment

4. Privacy & Security
   - Data encryption
   - Access control
   - Audit logging
   - Consent management
   - Data retention
   - Regulatory compliance

5. Performance Optimization
   - Response time
   - Data compression
   - Cache management
   - Network efficiency
   - Battery impact
   - Storage optimization

## Implementation Details

### Data Flow
1. Collection
   - Direct user input
   - Periodic questionnaires
   - Follow-up records
   - Automated data validation
   - Real-time processing
   - Data synchronization

2. Validation
   - Data consistency
   - Record completeness
   - Temporal coherence
   - Value ranges
   - Logical relationships
   - Cross-validation

3. Analysis
   - Temporal patterns
   - Correlations
   - Trends
   - Statistical analysis
   - Pattern recognition
   - Predictive modeling

### User Interface
1. Recording
   - Easy data entry
   - Predefined templates
   - Customizable options
   - Quick input methods
   - Offline capability
   - Multi-device support

2. Visualization
   - Timelines
   - Intensity graphs
   - Recurrence patterns
   - Interactive charts
   - Custom views
   - Export options

3. Alerts
   - Severe symptoms
   - Concerning patterns
   - Recording reminders
   - Smart notifications
   - Priority levels
   - Custom thresholds

### Clinical Integration
1. Reports
   - Professional summaries
   - Symptom history
   - Trend analysis
   - Clinical metrics
   - Custom formats
   - Export capabilities

2. Clinical Decision Support
   - Pattern identification
   - Intervention triggers
   - Progress monitoring
   - Risk assessment
   - Treatment recommendations
   - Outcome tracking

### Quality Assurance
1. Data Quality
   - Input validation
   - Completeness checks
   - Consistency verification
   - Anomaly detection
   - Error handling
   - Data correction

2. System Performance
   - Response time
   - Data processing
   - Storage optimization
   - Battery efficiency
   - Network usage
   - Cache management

3. Security Measures
   - Data encryption
   - Access control
   - Audit trails
   - Compliance checks
   - Privacy protection
   - Backup procedures

