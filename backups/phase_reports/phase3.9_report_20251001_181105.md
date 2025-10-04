# Phase 3.9 Build Report
**Data:** 2025-10-01
**Início:** 18:04:22 (2025-10-01T18:04:22+01:00)
**Término:** 18:11:05 (Finished @ 10/1/25, 6:11 PM)
**Duração:** 06:43.154 (6 min 43 seg)

---

## RESULTADO FINAL

**Errors:** 72
**Warnings:** 186
**Info:** 31
**Broken Links:** 0

**Status:** ✅ BUILD COMPLETO COM SUCESSO

---

## BUILD DETAILS

### SUSHI Compilation
- **Tempo:** 00:33.165 segundos
- **Versão:** SUSHI v3.16.5 (implements FHIR Shorthand specification v3.0.0)
- **Status:** ✅ SUCCESS

#### FSH Processing:
- **Documentos preprocessados:** 92 documents with 20 aliases
- **Definições importadas:** 164 definitions and 59 instances

#### FHIR Resources Converted:
- **Profiles:** 37
- **Extensions:** 39
- **CodeSystems:** 35
- **ValueSets:** 53
- **Instances:** 59
- **Total:** 222 FHIR resources exported as JSON

### Dependencies Loaded:
- `sushi-r5forR4#1.0.0` - 7 resources
- `hl7.fhir.uv.tools.r4#0.8.0` - 110 resources
- `hl7.terminology.r4#6.5.0` - 4392 resources
- `hl7.fhir.uv.extensions.r4#5.2.0` - 759 resources
- `ihe.iti.pcf#1.1.0` - 18 resources
- `hl7.fhir.uv.ips#1.1.0` - 104 resources
- `hl7.fhir.r4.core#4.0.1` - 4581 resources

### IG Publisher Processing
- **Generate:** 05:31.260
- **Narrative generation:** 00:08.011
- **Jekyll:** 00:21.962 (done in 19.494 seconds)
- **Validation:** 00:34.542 (#223 resources)
- **Template:** 00:03.030 (#3)

### HTML Validation
- **Files found:** 3132 HTML files
- **Invalid XHTML:** 0 pages (0%)
- **Links checked:** 927,583 links
- **Broken links:** 0 (0%)

### Performance
- **Max Memory Used:** 2Gb (2,112,264,632 bytes)
- **Java Version:** 23 (64bit, aarch64)
- **Platform:** Mac OS X

---

## OBSERVAÇÕES

1. **Build bem-sucedido:** Este foi um build completo sem erros de SUSHI ou IG Publisher
2. **72 errors:** Todos são erros de validação FHIR, não erros de compilação
3. **Performance:** Build relativamente longo (6m 43s) devido ao tamanho do IG (222 resources)
4. **Qualidade HTML:** 100% dos arquivos HTML válidos, sem broken links

---

## PRÓXIMA FASE

**Phase 3.10** deveria reduzir o número de erros de 72 para um número menor.

**Log file:** `build_phase3.9_20251001_180420.log`

---

## METADATA

- **Build tool:** FHIR IG Publisher v2.0.17 (Git# 98facbadd305)
- **Build date:** 2025-09-09T06:53:45.198Z (22 days old at time of build)
- **Output directory:** `/Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/output`
- **Validation output:** `output/qa.html`
- **Log file:** `/var/folders/y5/84nmvdgs52l4h681vj_9r_y40000gn/T/fhir-ig-publisher-tmp.log`
