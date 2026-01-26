# Known Issues

This page documents known issues that affect the iOS Lifestyle Medicine Implementation Guide build validation but do not impact functionality.

## IPS 2.0.0 Upstream Issues

### Extension Reference Error (21 occurrences)

**Error Message:**
```
Não foi possível encontrar uma definição para o URL canónico
'http://hl7.org/fhir/StructureDefinition/note|5.3.0-ballot-tc1'
```

**Cause:** The IPS 2.0.0 dependency references a ballot version of the `note` extension (5.3.0-ballot-tc1) that is not published in the HL7 terminology server (tx.fhir.org).

**Impact:** Cosmetic only. Does not affect profile functionality or validation of actual patient data.

**Resolution:** Awaiting IPS IG update from HL7. This will be resolved when IPS publishes a corrected version referencing a released extension version.

**Tracking:** HL7 IPS Working Group

---

### Broken Links - pkp-2 Constraint (8 occurrences)

**Error Message:**
```
The link '?pkp-2?' for "Constraint failed: pkp-2" cannot be resolved
```

**Cause:** Internal documentation reference in IPS 2.0.0 profiles that cannot be resolved by the IG Publisher.

**Impact:** Cosmetic only. Affects generated documentation but not profile validity.

**Resolution:** Upstream fix required in IPS IG.

---

## ConceptMap Target System Warnings

### External Terminology Systems (~80 warnings)

**Warning Type:** "A]El sistema de referencia X no está representado en el mapa conceptual"

**Affected Systems:**
- OMOP (http://athena.ohdsi.org/search-terms/terms)
- openEHR CKM (https://ckm.openehr.org/ckm/archetypes)
- Apple HealthKit
- Fitbit API
- Polar API
- Garmin API
- Oura API

**Cause:** These are stub CodeSystems declared in `sushi-config.yaml` as `special-url` to enable references to external/proprietary systems. They are intentionally minimal since the actual terminologies are maintained externally.

**Impact:** Expected behavior. The ConceptMaps correctly map from standard terminologies (LOINC, SNOMED CT, ICD-10/11) to these external systems.

**Resolution:** No action needed. These warnings are expected for cross-system ConceptMaps that reference external/proprietary terminologies.

---

## Summary

| Issue Category | Count | Fixable | Status |
|---------------|-------|---------|--------|
| IPS 2.0.0 note extension | ~21 | No | Awaiting upstream |
| IPS 2.0.0 broken links | 8 | No | Awaiting upstream |
| External system ConceptMap warnings | ~80 | No | Expected behavior |

**Total unfixable issues:** ~109

These issues do not prevent the IG from being used in production. All FHIR profiles, extensions, and examples validate correctly against their defined constraints.

---

*Last updated: 2026-01-26*
*iOS Lifestyle Medicine IG v0.1.0*
