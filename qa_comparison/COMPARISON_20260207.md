# QA Comparison: Pre-OCL vs With-OCL

**Date**: 2026-02-07
**Analysis**: T4 (glistening-wishing-emerson)

## Summary Comparison

| Metric | Baseline | With OCL | Delta | Impact |
|--------|----------|----------|-------|--------|
| **Errors** | 29 | 28 | **-1** | ✅ Improved |
| **Warnings** | 148 | 153 | **+5** | ⚠️ Increased |
| **Broken Links** | 8 | 8 | 0 | No change |
| **Info** | 10951 | 11068 | +117 | More info messages |

## Analysis

### Error Reduction (-1)
- Likely due to incremental fixes in the codebase
- Not directly related to OCL (OCL adds terminology, doesn't fix errors)

### Warning Increase (+5)

**Root cause identified**: OCL localhost:8000 was configured as tx-server but doesn't have SNOMED/LOINC:

| New Warning | Count |
|-------------|-------|
| `localhost:8000/fhir` doesn't support batch validation for SNOMED | 5 |
| `localhost:8000/fhir` doesn't support batch validation for LOINC | 3 |

**Interpretation**:
- T1 configured `_genonce.sh -tx http://localhost:8000/fhir`
- OCL has custom HRV codes, but NOT SNOMED/LOINC
- IG Publisher tried OCL first, got "tx version Not Known", generated warning
- Validation likely fell back to tx.fhir.org (or failed silently)

**Solution options**:
1. **Hybrid approach**: Use tx.fhir.org for standard terminologies, OCL only for custom codes
2. **Import SNOMED/LOINC to OCL**: Very large (~100GB disk required)
3. **Suppress warnings**: Add SNOMED/LOINC to `special-url` in sushi-config.yaml
4. **Don't use OCL as tx-server**: Export CodeSystem to input/vocabulary/ instead

## Next Steps

1. [ ] Identify the 5 new warnings specifically
2. [ ] Determine if warnings are OCL-related or coincidental
3. [ ] Test with OCL CodeSystem exported to input/vocabulary/
4. [ ] Re-run _genonce and compare again

## Files

```
qa_comparison/
├── baseline_pre_ocl/
│   ├── qa.html (9.0 MB)
│   └── SUMMARY.md
├── with_ocl_20260207/
│   ├── qa.html (9.1 MB)
│   ├── qa-tx.html
│   ├── qa-dep.html
│   ├── qa-ipreview.html
│   └── SUMMARY.md
└── COMPARISON_20260207.md (this file)
```
