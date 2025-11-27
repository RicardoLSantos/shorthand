# Privacy and Security

This page documents the privacy and security considerations for the iOS Lifestyle Medicine Implementation Guide, addressing GDPR compliance and data protection requirements for Patient-Generated Health Data (PGHD).

## Regulatory Framework

### General Data Protection Regulation (GDPR)

This Implementation Guide is designed with GDPR compliance in mind, particularly for implementations within the European Union. Key principles addressed:

| GDPR Principle | Implementation Approach |
|----------------|------------------------|
| **Lawfulness, Fairness, Transparency** | Consent profiles with explicit purpose documentation |
| **Purpose Limitation** | Consent scopes limited to specific data categories |
| **Data Minimization** | Profile design restricts to clinically necessary elements |
| **Accuracy** | Provenance tracking ensures data quality verification |
| **Storage Limitation** | Consent expiration dates and retention policies |
| **Integrity and Confidentiality** | Security labels and encryption requirements |
| **Accountability** | Comprehensive audit trail via Provenance resources |

### Health Data Considerations

Under GDPR Article 9, health data is classified as a **special category of personal data** requiring additional protections:

1. **Explicit Consent**: Required for processing (implemented via MultiJurisdictionalConsent profile)
2. **Legal Basis**: Healthcare provision, research, or public health purposes
3. **Data Protection Impact Assessment**: Recommended for wearable data integration

## FHIR Resources for Privacy

### Consent Management

The [MultiJurisdictionalConsent](StructureDefinition-multi-jurisdictional-consent.html) profile enables:

- **Multi-jurisdiction support**: GDPR (EU), LGPD (Brazil), HIPAA (US)
- **Granular consent scopes**: Per data category and purpose
- **Consent lifecycle**: Creation, amendment, withdrawal tracking
- **Purpose codes**: Research, treatment, secondary use distinctions

### Provenance and Audit Trail

The [PGHDProvenance](StructureDefinition-pghd-provenance.html) profile provides:

- **Origin tracking**: Device and software that captured data
- **Transformation history**: Data processing and format conversions
- **Agent identification**: Patient, device, system involved
- **Timestamps**: Precise recording of all lifecycle events
- **Integrity verification**: Optional digital signatures

## Data Minimization Workflow

### Principle

Collect only data necessary for the specified healthcare purpose.

### Implementation Steps

```
1. Purpose Definition
   └── Define specific clinical/research objectives
       └── Map required data elements to objectives

2. Data Collection
   └── Configure wearable data sync to collect only necessary metrics
       └── HRV for stress/cardiovascular monitoring
       └── Sleep data for circadian health
       └── Activity for lifestyle assessment

3. Consent Verification
   └── Check active consent before data access
       └── Verify scope covers requested data category
       └── Confirm purpose matches consent provisions

4. Data Processing
   └── Apply aggregation where individual datapoints unnecessary
       └── Daily averages instead of per-second measurements
       └── Remove identifying device metadata when not required

5. Retention Management
   └── Delete data when consent expires or is withdrawn
       └── Archive for legal retention period only
       └── Pseudonymize for secondary research use
```

### Profile Support for Minimization

| Profile | Minimization Feature |
|---------|---------------------|
| HRVObservation | Supports aggregated metrics (daily RMSSD mean) |
| SleepObservation | Stage summaries vs. epoch-level data |
| PhysicalActivityObservation | Session totals vs. second-by-second |

## Security Considerations

### Authentication and Authorization

Implementations SHOULD support:

- **SMART on FHIR**: For patient-facing applications
- **OAuth 2.0**: For backend service authorization
- **Mutual TLS**: For high-security integrations

### Data in Transit

- **TLS 1.3**: Required for all FHIR API communications
- **Certificate Pinning**: Recommended for mobile applications

### Data at Rest

- **Encryption**: AES-256 recommended for stored PGHD
- **Key Management**: Healthcare-grade key management systems

## Cross-Border Data Transfers

### EU to Non-EU Transfers

For PGHD originating from EU residents:

1. **Adequacy Decision**: Check if destination country has EU adequacy
2. **Standard Contractual Clauses**: Required for non-adequate countries
3. **Supplementary Measures**: Technical measures for enhanced protection

### Implementation Support

The Consent profile supports jurisdiction specification:

```json
{
  "extension": [{
    "url": "https://fmup.up.pt/ios-lifestyle-medicine/StructureDefinition/consent-jurisdiction",
    "valueCodeableConcept": {
      "coding": [{
        "system": "urn:iso:std:iso:3166",
        "code": "PT",
        "display": "Portugal"
      }]
    }
  }]
}
```

## Patient Rights Implementation

### Right to Access

- FHIR `$everything` operation for patient data export
- Machine-readable format (JSON/XML) available
- Human-readable summary generation

### Right to Rectification

- Update operations on Observation resources
- Provenance tracking of corrections

### Right to Erasure ("Right to be Forgotten")

- Conditional delete operations supported
- Audit trail maintained for legal compliance
- Research data anonymization alternative

### Right to Data Portability

- FHIR Bulk Data export support
- IPS document generation for healthcare continuity
- Standard formats ensure interoperability

## Wearable Device Considerations

### Device Security

Wearable devices present unique privacy challenges:

| Challenge | Mitigation |
|-----------|------------|
| **Continuous monitoring** | User-controlled sync schedules |
| **Location inference** | GPS data collection opt-in |
| **Biometric sensitivity** | Enhanced consent for biometric data |
| **Third-party apps** | Data sharing consent verification |

### Vendor Data Handling

Per the [ConceptMaps](conceptmaps.html) documentation, vendor-specific data is normalized to standard terminologies:

- Raw vendor data transformed to LOINC codes
- Proprietary identifiers replaced with standard concepts
- Vendor-specific metadata preserved in extensions when clinically relevant

## Implementation Checklist

### For Implementers

- [ ] Implement MultiJurisdictionalConsent profile
- [ ] Configure PGHDProvenance for all data capture
- [ ] Enable SMART on FHIR authentication
- [ ] Apply data minimization in API design
- [ ] Document retention policies per jurisdiction
- [ ] Provide patient data export capability
- [ ] Support consent withdrawal workflow
- [ ] Implement audit logging

### For Deployers

- [ ] Complete Data Protection Impact Assessment
- [ ] Appoint Data Protection Officer (if required)
- [ ] Establish data processing agreements with vendors
- [ ] Configure backup and disaster recovery
- [ ] Train staff on privacy requirements
- [ ] Document cross-border transfer mechanisms

## References

1. Regulation (EU) 2016/679 (General Data Protection Regulation)
2. Article 29 Working Party Guidelines on Consent (WP259)
3. EDPB Guidelines on Health Data Processing
4. ISO 27701:2019 Privacy Information Management
5. HL7 FHIR Security and Privacy Module

---

*This documentation is part of the iOS Lifestyle Medicine FHIR Implementation Guide, developed at the Faculty of Medicine, University of Porto (FMUP).*
