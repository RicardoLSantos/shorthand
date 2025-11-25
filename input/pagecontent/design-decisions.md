
## ConceptMap Source Validation Strategy (2025-11-25)

### Decision
Removed `sourceCanonical` from ConceptMaps that map proprietary/local codes to standard terminologies.

### Context
ConceptMaps like `ConceptMapPhysicalActivityToSNOMED` map iOS HealthKit codes (#walking, #running) to SNOMED CT codes. The FHIR validator checks that source codes exist in the `sourceCanonical` ValueSet.

### Problem
The `physical-activity-type-vs` ValueSet contained SNOMED codes for semantic interoperability, but the ConceptMap needed iOS codes as source. This caused 26 validation errors.

### Options Considered
1. **Two ValueSets** - Separate iOS and SNOMED ValueSets
2. **Remove sourceCanonical** - Let ConceptMap validate only by CodeSystem (CHOSEN)
3. **Mixed ValueSet** - Include both iOS and SNOMED codes

### Rationale for Option 2
- Preserves SNOMED codes in ValueSets for semantic interoperability
- ConceptMap still validates source codes against the CodeSystem (`group.source`)
- Simpler architecture without duplicate ValueSets
- Profiles/Observations can bind to SNOMED ValueSets for clinical use

### Affected ConceptMaps
- ConceptMapPhysicalActivityToSNOMED
- ConceptMapEnvironmentalToSNOMED
- ConceptMapMindfulnessToSNOMED
- ConceptMapMobilityToSNOMED
- ConceptMapNutritionToSNOMED

### Reversal Instructions
To restore strict source validation, add back:
```fsh
* sourceCanonical = "https://2rdoc.pt/ig/ios-lifestyle-medicine/ValueSet/[ios-specific-valueset]"
```
And create iOS-specific ValueSets with codes from the local CodeSystems.

### Author
Claude Code (Terminal 1) - Session 2025-11-25
