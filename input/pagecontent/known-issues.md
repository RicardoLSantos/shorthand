# Known Issues

This page documents known issues that affect the iOS Lifestyle Medicine Implementation Guide build validation but do not impact functionality.

**Build Summary (2026-01-29):** 28 errors, ~146 warnings (after quick fixes)

---

## Errors (28 total — all upstream IPS 2.0.0)

All 28 errors originate from the IPS 2.0.0 dependency (`hl7.fhir.uv.ips#2.0.0-ballot`). None are caused by this IG's profiles, extensions, or examples.

### 1. Extension Reference Error (19 occurrences)

**Error Message:**
```
Cannot find a definition for the canonical URL
'http://hl7.org/fhir/StructureDefinition/note|5.3.0-ballot-tc1'
```

**Cause:** The IPS 2.0.0 dependency references a ballot Technical Correction version of the `note` extension (`5.3.0-ballot-tc1`) that was never published as an independent package on the HL7 terminology server (`tx.fhir.org`).

**Impact:** Cosmetic only. Does not affect profile functionality or validation of actual patient data.

**Resolution:** Awaiting IPS IG update from HL7. This will be resolved when IPS publishes a corrected version referencing a released extension version.

**Tracking:** HL7 IPS Working Group

---

### 2. Broken Links — pkp-2 Constraint (8 occurrences)

**Error Message:**
```
The link 'unknown.html' for "?pkp-2?" cannot be resolved
```

**Cause:** Internal documentation reference in IPS 2.0.0 profiles that cannot be resolved by the IG Publisher.

**Impact:** Cosmetic only. Affects generated HTML documentation but not profile validity.

**Resolution:** Upstream fix required in IPS IG.

---

### 3. patternCodeableConcept Inheritance (1 occurrence)

**Error Message:**
```
The base element has a pattern type 'CodeableConcept', so this element must have a fixed value, but it does not
```

**Cause:** Structural inheritance constraint from the IPS Composition base profile. The `sectionLifestyleMedicine` slice inherits a pattern that the IG Publisher interprets as requiring a fixed value.

**Impact:** Cosmetic only. The section code binding works correctly at runtime.

**Resolution:** Upstream structural fix in IPS IG, or explicit pattern override in a future version of this IG.

---

## Warnings (148 total — by category)

### Category 1: IPS Upstream `note|5.3.0-ballot-tc1` (42 warnings)

Same root cause as the errors above. The IPS profile generates both errors and warnings for each snapshot element referencing the unresolved extension.

**OCL/ETL mitigation:** None — structural, not terminological.

---

### Category 2: ConceptMap openEHR Archetype URLs (24 warnings)

**Warning Messages:**
```
Cannot find a definition for the URL 'openEHR-EHR-OBSERVATION.heart_rate_variability.v0'
Source/Target Code System is not fully defined and populated
```

**Affected ConceptMaps:**
- ConceptMapFHIRToOpenEHR (8 warnings)
- ConceptMapOpenEHRToFHIR (8 warnings)
- ConceptMapOpenEHRToOMOP (8 warnings)

**Cause:** openEHR archetype identifiers are not FHIR CodeSystems. The IG Publisher cannot resolve these URLs because they exist in the openEHR CKM namespace, not in FHIR terminology infrastructure.

**Impact:** Expected behavior. The ConceptMaps correctly document the semantic mappings between FHIR and openEHR archetypes.

**OCL mitigation:** Create a FHIR CodeSystem in OCL representing the openEHR archetype identifiers used in these mappings. This would allow the IG Publisher to validate the codes. Estimated elimination: **24 warnings**.

---

### Category 3: UCUM Annotation Warnings (14 warnings)

**Warning Message:**
```
UCUM codes containing human-readable annotations like {score} may be misleading
```

**Affected codes:** `{score}`, `{rpm}`, `{spm}`, `{pack-years}`

**Cause:** UCUM annotations (curly-brace codes) are valid UCUM but the IG Publisher flags them as best-practice warnings because annotations are ignored in unit comparisons.

**Impact:** Cosmetic. These are the correct UCUM representations for dimensionless scores and custom units. Using `1` (dimensionless) would lose semantic meaning.

**OCL/ETL mitigation:** None — UCUM validation issue, not terminology.

---

### Category 4: ConceptMap OHDSI/Athena (12 warnings)

**Warning Messages:**
```
Target CodeSystem http://athena.ohdsi.org/search-terms/terms does not have all content
(content = not-present), so target codes cannot be checked
```

**Affected ConceptMaps:**
- ConceptMapActivityToOMOP, ConceptMapCGMToOMOP, ConceptMapHRVToOMOP
- ConceptMapSleepToOMOP, ConceptMapNutritionToOMOP

**Cause:** The OHDSI Athena CodeSystem is declared with `content = not-present` because the full OMOP vocabulary (~5M concepts) cannot be included in the IG. Only the specific Concept IDs used in mappings are referenced.

**Impact:** Expected behavior. The ConceptMaps correctly reference OHDSI Concept IDs validated against the Athena vocabulary browser.

**OCL mitigation:** Import the subset of OHDSI Concept IDs used in ConceptMaps into OCL as a CodeSystem with `content = complete`. OCL has native OHDSI/OMOP integration. Estimated elimination: **12 warnings**.

**ETL contribution:** The HEADS ETL pipeline (FHIR→OMOP step) validates these Concept IDs against the actual OMOP CDM, providing runtime verification.

---

### Category 5: ConceptMap Vendor API URLs (10 warnings)

**Warning Messages:**
```
Cannot find a definition for the URL 'https://developer.garmin.com/health-api'
Source CodeSystem does not have all content (content = not-present)
```

**Affected vendors:** Apple HealthKit, Fitbit, Garmin, Polar, Oura

**Cause:** Vendor API CodeSystems are declared as stub CodeSystems (content = not-present) because these are proprietary systems whose full code lists cannot be published.

**Impact:** Expected behavior. The ConceptMaps correctly map vendor-specific codes to LOINC/SNOMED standard terminologies.

**OCL mitigation:** Host the vendor stub CodeSystems in OCL with the specific codes used in mappings (content = fragment). Estimated elimination: **10 warnings**.

**ETL contribution:** The HEADS ETL pipeline extracts data from HealthKit, validating that all vendor codes in ConceptMaps correspond to real API identifiers. This provides runtime evidence that the mappings are correct.

---

### Category 6: Other Warnings (46 warnings)

| Sub-category | Count | Description | Fixable |
|-------------|-------|-------------|---------|
| Bundle fullUrl mismatches | 5 | Reference resolution in Bundle example | Fixed (2026-01-27) |
| OID/URN identifiers | 4 | Example identifier systems (urn:oid) | Expected |
| Consent policy URLs | 3 | Legislative URLs (GDPR, HIPAA, LGPD) | Expected |
| CQL language | 2 | CQL expressions not validated by IG Publisher | Expected |
| Display name mismatch | 1 | diet-quality-score display text | **Fixed (2026-01-29)** |
| pin-canonicals | 1 | plan-definition-type version ambiguity | **Fixed (2026-01-29)** |
| ICD-10 content | 1 | ICD-10-CM not fully populated | Expected |
| VendorToOpenEHR URIs | 8 | Vendor + CKM source/target URIs | OCL mitigable |
| task-output-type CodeSystem | 1 | Non-standard CodeSystem URL | Fixed (2026-01-27) |

---

## OCL and ETL Mitigation Strategy

### What OCL (Open Concept Lab) can resolve

| Warning Category | Current | After OCL | Eliminated |
|-----------------|---------|-----------|------------|
| openEHR archetype URLs | 24 | 0 | **24** |
| OHDSI/Athena content | 12 | 0 | **12** |
| Vendor API URLs | 10 | 0 | **10** |
| **Total** | **46** | **0** | **46 (31%)** |

**How:** Configure OCL as an additional terminology server (`tx` parameter in `sushi-config.yaml`), hosting:
- openEHR archetype identifier CodeSystem
- OHDSI Concept ID subset CodeSystem (using OCL's native OMOP integration)
- Vendor API stub CodeSystems with mapped codes

### What the HEADS ETL pipeline validates

The ETL pipeline provides **runtime verification** (not build-time elimination) for:
- Vendor code mappings (HealthKit → LOINC): confirms ConceptMap accuracy
- OHDSI Concept ID validity: confirms OMOP CDM compatibility
- End-to-end data flow: iPhone/Watch → FHIR → OMOP CDM

### What neither can resolve

| Category | Count | Reason |
|----------|-------|--------|
| IPS upstream errors | 28 | Bug in `hl7.fhir.uv.ips#2.0.0-ballot` |
| IPS upstream warnings | 42 | Same root cause as errors |
| UCUM annotations | 14 | Valid UCUM, best-practice warning |
| OID/URN/Policy URLs | 7 | Expected for example identifiers |
| CQL validation | 2 | IG Publisher limitation |
| **Total irreducible** | **93** | |

---

## Summary

| Issue Category | Errors | Warnings | Total | Status |
|---------------|--------|----------|-------|--------|
| IPS 2.0.0 upstream (note, pkp-2) | 28 | 42 | 70 | Awaiting HL7 update |
| ConceptMap external systems | 0 | 46 | 46 | **OCL mitigable (31%)** |
| UCUM annotations | 0 | 14 | 14 | Expected (valid UCUM) |
| Other expected warnings | 0 | 7 | 7 | Expected behavior |
| Fixable locally | 0 | 8 | 8 | **Fixed (2026-01-27)** |
| CQL validation | 0 | 2 | 2 | IG Publisher limitation |
| Pin-canonicals | 0 | 1 | 1 | Low priority |
| **Total** | **28** | **148** | **176** | |

**Projected after OCL integration:** 28 errors, ~102 warnings (~31% reduction)

These issues do not prevent the IG from being used in production. All FHIR profiles, extensions, and examples validate correctly against their defined constraints.

---

## Upstream Contribution Strategy

### Version Testing (2026-02-07)

| Version | Errors | Warnings | Result |
|---------|--------|----------|--------|
| IG Publisher 2.0.28 + SUSHI 3.16.5 | 28 | 153 | Baseline |
| IG Publisher 2.1.0 + SUSHI 3.17.0 | 28 | **145** | -8 warnings |

**Conclusion**: Updating tools reduces warnings but does not fix IPS upstream errors.

### GitHub Issues Prepared

1. **HL7/fhir-ips**: Build errors when deriving from Composition-uv-ips
   - `note|5.3.0-ballot-tc1` extension not published
   - `pkp-2` constraint broken links

2. **HL7/fhir-ig-publisher**: Constraint links render as `?pkp-2?` pointing to unknown.html

### Resolution Timeline

| Date | Action |
|------|--------|
| 2026-02-07 | Issues prepared, version testing complete |
| 2026-02-08 | Submit issues to GitHub |
| 2026-02-15 | Follow-up if no response |
| 2026-02-28 | PhD defense (use workaround if not resolved) |

---

*Last updated: 2026-02-07*
*Build: IG Publisher 2.1.0, SUSHI 3.17.0*
*iOS Lifestyle Medicine IG v0.1.0*
*OCL Integration: Prepared in sushi-config.yaml (pending account setup)*
*Upstream Issues: Prepared for submission to HL7/fhir-ips and HL7/fhir-ig-publisher*
