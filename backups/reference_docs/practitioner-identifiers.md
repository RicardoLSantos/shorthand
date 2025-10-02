---
title: Practitioner Identifiers
---

# International Practitioner Identification

## Supported Identifier Systems

### United States
- **NPI (National Provider Identifier)**: `http://hl7.org/fhir/sid/us-npi`

### European Union
- **EUDAMED**: European database for medical devices practitioners
- National systems per member state

### Brazil  
- **CRM (Conselho Regional de Medicina)**: Medical council registration
- **CPF**: For general practitioner identification

## Usage Example

```json
{
  "identifier": [{
    "system": "http://hl7.org/fhir/sid/us-npi",
    "value": "1234567890"
  }]
}
