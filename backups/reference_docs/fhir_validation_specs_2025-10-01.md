# FHIR Validation Specifications Reference
**Last Updated:** 2025-10-01
**FHIR Version:** R4 (4.0.1)
**IG Publisher:** 2.0.17
**SUSHI:** 3.16.5

## Table of Contents
1. [ValueSet Bindings](#valueset-bindings)
2. [Component Slicing](#component-slicing)
3. [FHIR Constraints](#fhir-constraints)
4. [Terminology Validation](#terminology-validation)
5. [Questionnaire Validation](#questionnaire-validation)
6. [Common Error Patterns](#common-error-patterns)

---

## ValueSet Bindings

### Specification
When a profile constrains an element with a ValueSet binding, all instances must use codes from that ValueSet.

### FSH Syntax
```fsh
// In Profile
* component[example].valueCodeableConcept from ExampleVS (required)

// In ValueSet
ValueSet: ExampleVS
* include codes from system https://example.org/CodeSystem/example-cs

// In Instance
* component[example].valueCodeableConcept = https://example.org/CodeSystem/example-cs#code-1 "Display"
```

### Common Errors
1. **Using codes not in ValueSet**
   - Error: "Nenhuma das codificações fornecidas faz parte do conjunto de valores"
   - Fix: Use codes from the bound ValueSet only

2. **Incorrect CodeSystem URL**
   - Error: ValueSet includes from wrong CodeSystem
   - Fix: Ensure ValueSet `include codes from system` matches actual CodeSystem URL

3. **Missing `include` statement**
   - Error: ValueSet is empty
   - Fix: Add `* include codes from system` to ValueSet

### Phase 3.14 Example
**Problem:**
```fsh
// ValueSet didn't include codes
ValueSet: MoodValueSet
* ^url = "https://2rdoc.pt/ig/.../ValueSet/mood"
// Missing: * include codes from system
```

**Solution:**
```fsh
ValueSet: MoodValueSet
* ^url = "https://2rdoc.pt/ig/.../ValueSet/mood"
* include codes from system https://2rdoc.pt/ig/.../CodeSystem/mood
```

---

## Component Slicing

### Specification
Component slicing requires discriminators to identify which slice an element matches. The most common discriminator is `code` with type `value`.

### Requirements for Slicing by Code
1. **Profile must define fixed codes for each slice**
2. **Each slice must have unique code value**
3. **Discriminator path must be "code"**
4. **Discriminator type must be "value"**

### FSH Syntax
```fsh
Profile: ExampleObservation
Parent: Observation

* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open

* component contains
    slice1 0..1 MS and
    slice2 0..1 MS

* component[slice1].code = $LOINC#12345-6 "Slice 1"
* component[slice2].code = $LOINC#67890-1 "Slice 2"
```

### Common Errors
1. **Missing code definition**
   - Error: "Could not match discriminator (code) for slice - the discriminator does not have fixed value"
   - Fix: Define `.code` for every slice

2. **Duplicate codes**
   - Error: "o elemento corresponde a mais do que uma fatia"
   - Fix: Ensure each slice has unique code value

3. **Using pattern instead of fixed**
   - Error: Discriminator can't match
   - Fix: Use `* component[slice].code = CODE` (not pattern)

### Phase 3.14 Example
**Problem:**
```fsh
* component contains
    restingHeartRate 0..1 MS and
    heartRateVariability 0..1 MS

// Missing code for restingHeartRate!
* component[heartRateVariability].code = $LOINC#80404-7
```

**Solution:**
```fsh
* component contains
    restingHeartRate 0..1 MS and
    heartRateVariability 0..1 MS

* component[restingHeartRate].code = $LOINC#40443-4 "Heart rate --resting"
* component[heartRateVariability].code = $LOINC#80404-7 "R-R interval.standard deviation"
```

---

## FHIR Constraints

### obs-7 Constraint
**Rule:** "If Observation.code is the same as an Observation.component.code then the value element associated with the code SHALL NOT be present"

**Explanation:** When an Observation has a component with the same code as the main Observation, you cannot have both `value[x]` and that component.

**Example - WRONG:**
```fsh
Instance: BadExample
InstanceOf: Observation

* code = $LOINC#12345-6 "Balance"
* valueQuantity = 85 '%'  // ❌ ERROR!
* component[balance].code = $LOINC#12345-6 "Balance"  // Same code!
* component[balance].valueQuantity = 85 '%'
```

**Example - CORRECT:**
```fsh
Instance: GoodExample
InstanceOf: Observation

* code = $LOINC#12345-6 "Balance panel"  // Different code
// No valueQuantity at root level ✓
* component[balanceScore].code = $LOINC#67890-1 "Balance score"
* component[balanceScore].valueQuantity = 85 '%'
```

### vs-2 Constraint
**Rule:** "A value set with concepts from more than one code system should specify at minimum one of the code systems"

**Fix:** Add system to `include` statements in ValueSet

---

## Terminology Validation

### Display Name Rules
1. **Must match terminology server exactly**
2. **Case-sensitive**
3. **Preferred term takes precedence**

### SNOMED CT Display Names
The IG Publisher validates against SNOMED International Edition. Common issues:

| Code | Wrong Display | Correct Display |
|------|--------------|-----------------|
| 112080002 | "Relaxed mood" | "Happiness" |
| 373068000 | "Meditation" | "Undetermined" (invalid code) |
| 365949003 | "Finding of level of stress" | "Health-related behavior finding" |
| 162465004 | "Symptom present" | "Symptom severity" |
| 255214003 | "After fasting" | "After exercise" |

### Invalid Codes
If a code doesn't exist in the terminology server:
1. **Remove the code** (if not needed)
2. **Replace with valid code** (if similar exists)
3. **Create local code** (if concept needed but doesn't exist in standard)

### Local CodeSystems
Use local codes when:
- Concept doesn't exist in LOINC/SNOMED
- Consumer health device data
- App-specific measurements
- Wellness tracking

**Example:**
```fsh
CodeSystem: LifestyleObservationCS
* #water-intake "Water intake volume"
  "Daily water consumption measured in milliliters"
```

---

## Questionnaire Validation

### Answer Validation Rules
1. **type=choice:** Answer must match one of `answerOption`
2. **type=string:** Free text allowed unless `answerOption` provided
3. **type=integer:** Must be integer, respects `minValue`/`maxValue`
4. **repeats=true:** Can have multiple answers

### Common Errors

#### 1. Answer Not in Options
**Error:** "A cadeia 'X' não faz parte do conjunto de valores permitidos"

**Problem:**
```fsh
// Questionnaire
* item[0]
  * type = #choice
  * answerOption[0].valueString = "Option A"
  * answerOption[1].valueString = "Option B"

// Response - WRONG
* item[0].answer.valueString = "Option C"  // ❌
```

**Fix:**
```fsh
// Response - CORRECT
* item[0].answer.valueString = "Option A"  // ✓
```

#### 2. ID/URL Mismatch
**Error:** "Resource id/url mismatch: ID/URL"

**Rule:** For Questionnaire, `id` must match last part of `url`

**Problem:**
```fsh
Instance: MyQuestionnaire
InstanceOf: Questionnaire
* url = "https://example.org/Questionnaire/different-id"  // ❌
```

**Fix:**
```fsh
Instance: MyQuestionnaire
InstanceOf: Questionnaire
* url = "https://example.org/Questionnaire/MyQuestionnaire"  // ✓
```

---

## Common Error Patterns

### Pattern 1: Null System
**Error:** Using `null#code` for coding

**Problem:**
```fsh
* valueCodeableConcept = null#quiet "Quiet"
```

**Fix:**
```fsh
* valueCodeableConcept = https://example.org/CodeSystem/example#quiet "Quiet"
```

### Pattern 2: Missing Unit Text
**Error:** "minimum required = 1, but only found 0" for unit

**Problem:**
```fsh
* valueQuantity = 70.5 'kg'
```

**Fix:**
```fsh
* valueQuantity = 70.5 'kg' "kilogram"
```

### Pattern 3: Extension Not Found
**Error:** "Não foi possível encontrar a extensão http://..."

**Cause:** Extension doesn't exist in FHIR R4 base

**Common Invalid Extensions:**
- `elementdefinition-minValueInteger` ❌
- `elementdefinition-maxValueInteger` ❌

**Alternative:** Use standard `minValue[x]` and `maxValue[x]` elements

### Pattern 4: StructureMap Unknown Types
**Error:** "O tipo X não é conhecido, pelo que os caminhos não podem ser validados"

**Cause:** StructureMap references undefined logical model

**Fix Options:**
1. Define the logical model
2. Remove StructureMap if not needed
3. Use standard FHIR resources as source/target

---

## Validation Workflow

### Step-by-Step Process
1. **SUSHI Compilation**
   - Converts FSH to JSON
   - Validates FSH syntax
   - Reports: Syntax errors, missing references

2. **IG Publisher Validation**
   - Validates FHIR resources
   - Checks profiles and constraints
   - Validates terminology bindings
   - Reports: Errors, Warnings, Info

3. **Terminology Server Validation**
   - Checks codes exist in CodeSystems
   - Validates display names
   - Verifies ValueSet expansions

4. **Profile Conformance**
   - Validates instances against profiles
   - Checks cardinality
   - Validates slicing
   - Checks constraints (FHIRPath)

### Prioritization Strategy
1. **Fix SUSHI errors first** (blocks build)
2. **Fix terminology errors** (invalid codes)
3. **Fix structural errors** (slicing, cardinality)
4. **Fix constraint violations** (obs-7, etc.)
5. **Fix display name mismatches**
6. **Address warnings**

---

## Best Practices

### 1. Code Organization
```
input/fsh/
├── terminology/          # CodeSystems, ValueSets
├── profiles/            # Profile definitions
├── extensions/          # Extension definitions
├── examples/            # Instance examples
└── valuesets/          # Additional ValueSets
```

### 2. Naming Conventions
- **IDs:** lowercase-with-hyphens
- **Names:** PascalCase
- **Titles:** "Human Readable Title"
- **URLs:** Match directory structure

### 3. Documentation
- Add `Description:` to all artifacts
- Use comments for complex logic
- Maintain changelog
- Document custom codes

### 4. Version Control
- Tag each phase
- Keep fix scripts
- Maintain phase reports
- Back up before major changes

---

## Error Resolution Examples

### Example 1: Component Slicing
**Before:**
```fsh
* component contains movement 0..1
// Missing code!
```

**After:**
```fsh
* component contains movement 0..1
* component[movement].code = $LOINC#12345-6 "Movement assessment"
```

### Example 2: ValueSet Binding
**Before:**
```fsh
* component[mood].valueCodeableConcept = $SCT#112080002 "Happy"
// But MoodVS doesn't include SNOMED codes!
```

**After:**
```fsh
// Option 1: Add SNOMED to ValueSet
ValueSet: MoodVS
* include codes from system http://snomed.info/sct
* $SCT#112080002 "Happiness"

// Option 2: Use local code
* component[mood].valueCodeableConcept = LocalCS#happy "Happy"
```

### Example 3: obs-7 Violation
**Before:**
```fsh
* code = $LOINC#12345-6 "Balance"
* valueQuantity = 85 '%'
* component[balance].code = $LOINC#12345-6 "Balance"
* component[balance].valueQuantity = 85 '%'
```

**After:**
```fsh
* code = $LOINC#12345-0 "Balance panel"
// Remove root valueQuantity
* component[balanceScore].code = $LOINC#12345-6 "Balance score"
* component[balanceScore].valueQuantity = 85 '%'
```

---

## References

### Official Documentation
- [FHIR R4 Specification](http://hl7.org/fhir/R4/)
- [FHIR Shorthand](https://build.fhir.org/ig/HL7/fhir-shorthand/)
- [IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation)

### Terminology
- [SNOMED CT Browser](https://browser.ihtsdotools.org/)
- [LOINC Search](https://loinc.org/)
- [UCUM Validator](https://ucum.nlm.nih.gov/ucum-lhc/demo.html)

### Tools
- SUSHI: FSH → FHIR JSON compiler
- IG Publisher: Builds and validates IGs
- Jekyll: Generates HTML output

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2025-10-01 | 1.0 | Initial comprehensive reference |
| 2025-01-14 | 0.9 | Added component slicing patterns |
| 2025-01-09 | 0.8 | Added terminology validation rules |

---

*Last updated during Phase 3.14 error reduction work*
