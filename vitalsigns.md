
## Supported Operations

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

## Supported Operations

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
Copy
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
