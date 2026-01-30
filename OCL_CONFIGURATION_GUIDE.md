# OCL (Open Concept Lab) Integration Guide

**Date**: 2026-01-30
**Status**: Configuration Prepared (pending account setup)
**Expected Impact**: Reduce IG warnings from 148 to ~102 (-31%)

---

## Overview

OCL (Open Concept Lab) provides **free** (MPL-2.0 license) terminology services for custom CodeSystems. This integration eliminates 46 IG build warnings by hosting:

| Source | Warnings Eliminated | Purpose |
|--------|---------------------|---------|
| `openehr-archetypes` | 24 | openEHR archetype identifiers |
| `ohdsi-omop` | 12 | OHDSI/OMOP Concept ID subset |
| `vendor-healthkit` | ~3 | Apple HealthKit codes |
| `vendor-fitbit` | ~2 | Fitbit API codes |
| `vendor-garmin` | ~2 | Garmin API codes |
| `vendor-polar` | ~2 | Polar API codes |
| `vendor-oura` | ~1 | Oura API codes |
| **TOTAL** | **46** | **31% reduction** |

---

## Setup Steps

### Step 1: Create OCL Account (5 min)

1. Go to https://openconceptlab.org
2. Click "Sign Up" (free)
3. Verify email

### Step 2: Create Organization (5 min)

1. Log in to https://app.openconceptlab.org
2. Click "New Organization"
3. Organization ID: `fmup-heads`
4. Name: `FMUP HEADS PhD Project`
5. Public access: View

### Step 3: Generate API Token (2 min)

1. Go to Profile → Settings → API Tokens
2. Generate new token
3. Save securely (environment variable recommended):
   ```bash
   export OCL_TOKEN="your-token-here"
   ```

### Step 4: Create Sources (30 min)

Use the OCL API to create each Source:

```bash
# Example: Create openehr-archetypes Source
curl -X POST \
  -H "Authorization: Token $OCL_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "openehr-archetypes",
    "name": "openEHR Archetypes for Lifestyle Medicine",
    "full_name": "openEHR Archetype Identifiers",
    "source_type": "Dictionary",
    "public_access": "View",
    "default_locale": "en",
    "supported_locales": ["en", "pt"],
    "website": "https://ckm.openehr.org/ckm/archetypes"
  }' \
  https://api.openconceptlab.org/orgs/fmup-heads/sources/
```

Repeat for: `ohdsi-omop`, `vendor-healthkit`, `vendor-fitbit`, `vendor-garmin`, `vendor-polar`, `vendor-oura`

### Step 5: Configure sushi-config.yaml

Add the following to your local `sushi-config.yaml`:

```yaml
parameters:
  # Terminology servers (OCL first for custom CodeSystems)
  tx:
    - https://fhir.openconceptlab.org/orgs/fmup-heads/
    - https://tx.fhir.org

  special-url:
    # ... existing entries ...

    # OCL Sources
    - https://fhir.openconceptlab.org/orgs/fmup-heads/sources/openehr-archetypes/
    - https://fhir.openconceptlab.org/orgs/fmup-heads/sources/ohdsi-omop/
    - https://fhir.openconceptlab.org/orgs/fmup-heads/sources/vendor-healthkit/
    - https://fhir.openconceptlab.org/orgs/fmup-heads/sources/vendor-fitbit/
    - https://fhir.openconceptlab.org/orgs/fmup-heads/sources/vendor-garmin/
    - https://fhir.openconceptlab.org/orgs/fmup-heads/sources/vendor-polar/
    - https://fhir.openconceptlab.org/orgs/fmup-heads/sources/vendor-oura/
```

### Step 6: Rebuild and Validate

```bash
cd /Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP
./_genonce.sh

# Verify warning reduction
grep -c "WARNING" output/qa.txt
# Expected: ~102 (before: 148)

# Verify OCL-related warnings resolved
grep "openehr" output/qa.txt | wc -l
# Expected: 0 (before: 24)
```

---

## Verification Checklist

- [ ] OCL account created
- [ ] Organization `fmup-heads` exists
- [ ] API token generated and stored
- [ ] 7 Sources created
- [ ] sushi-config.yaml updated
- [ ] IG build succeeds with reduced warnings
- [ ] known-issues.md updated with final counts

---

## Related Documentation

- [OCL_IMPLEMENTATION_PLAN_20260130.md](../../../knowledge_base/plans/OCL_IMPLEMENTATION_PLAN_20260130.md) - Detailed plan from Terminal 1
- [VRF-TECH-017](../../../knowledge_base/verifications/TECHNICAL/VRF-TECH-017_IPS_NOTE_EXTENSION_ERROR_RESEARCH_20260130.md) - IPS error research
- [OCL Documentation](https://docs.openconceptlab.org/en/latest/)
- [OCL FHIR API](https://docs.openconceptlab.org/en/latest/oclfhir/overview.html)

---

*Created: 2026-01-30 by Claude Code (Terminal 2)*
*Note: sushi-config.yaml is in .gitignore - changes must be made locally*
