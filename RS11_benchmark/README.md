# RS11 Benchmark: Database-First Medical Vocabulary Validation with Small Language Models

Reproducibility package for the empirical evaluation reported in the supplementary materials of:

> Santos RL, Cruz-Correia RJ. **A Database-First Architecture for Trustworthy Medical Vocabulary Validation: An AI-Assisted Evidence Synthesis with a Supplementary Benchmark of Small Language Models**. Submitted to the International Journal of Medical Informatics (submission reference IJMEDI-S-26-09137).

## Overview

This benchmark evaluates whether small language models (SLMs) combined with Retrieval-Augmented Generation (RAG) can accurately validate medical terminology codes (LOINC, SNOMED CT, ICD-10-CM) on consumer hardware (Apple M1, 16GB RAM).

**Key Result**: a pipeline of vocabulary-specific database lookup, LLM synonym expansion and a clinical abbreviation dictionary reached **14/14** on a focused 14-case test set (Configuration J, in two runs) and **30/42 (71.4%)** on an extended 42-case set (Configuration M); without retrieval (phase 0 of those two runs), the same model scored 6/14 (42.9%) and 5/14. These are figures for the pipeline as a whole. In the run of 20 March 2026, 8 of the 14 focused cases were resolved by the confidence-gated database path and 6 by model-mediated paths: 3 were scored on the answer without code re-validation, and in 3 the model emitted an ICD-10-CM code from memory, which a code-existence check then confirmed for two; the third, a SNOMED CT-to-ICD-10-CM cross-mapping, was counted by a string match, with no database confirmation. One of the 14 focused cases and two of the 42 extended cases are scored by a response-length threshold, and two further extended cases on a placeholder answer (manuscript supplement, S11.1 and S17.5).

In `benchmark_3phase_rag.py`, ChromaDB is used only in `verify_code`, which looks up ICD-10-CM, ICD-10-PCS and ICD-10 codes in the collection `icd10cm_terminology` before falling back to the Vocab2 concept table. Phase 4 can also query `tx.fhir.org` (see Prerequisites).

## Contents

| File | Description |
|------|-------------|
| `benchmark_3phase_rag.py` | Benchmark script: phases 0–4 of the pipeline on the 14 focused or the 42 extended cases (see the note under Quick Start) |
| `terminology_rag.py` | RAG engine for terminology suggestion |
| `test_cases_14.json` | The 14 focused test cases, as in the script (Configuration J: 14/14), with the LOINC name of each LOINC code (`loinc_names`) |
| `results_summary.json` | Archived results (the five phases of the two 14-case runs whose phase 4 is Configuration J; phase 4 of Configurations K, L and M) and the authors' local ChromaDB collections |
| `requirements.txt` | Python dependencies |
| `loinc_codes.tsv` | Every code of LOINC form in this folder: its LOINC 2.80 long common name, or the mark that it is not in LOINC 2.80, and the files that hold it |
| `per_case_results/` | Copies of the per-case result files of the archived runs and of the routing measurements of 19 November 2026, with their README |
| `measurement_scripts/` | The scripts, tests and protocols of the routing measurements of 19 November 2026, with their README |
| `service_manifest/` | The SHA-256 of each file of the terminology router service as measured, with its README |
| `LICENSE` | The MIT License, for the code of this folder (see License) |

## Prerequisites

1. **Python 3.9+**
2. **Ollama** with `qwen3.5:4b` model:
   ```bash
   # Install Ollama: https://ollama.ai
   ollama pull qwen3.5:4b
   ```
3. **Local vocabulary files and index** (not included: vocabulary licences), at the paths `benchmark_3phase_rag.py` expects, relative to the parent of this folder:
   - `etl/data/athena/CONCEPT.csv`: an Athena OHDSI download with LOINC and UCUM
   - `knowledge_base/Vocabulario/vocabulary_download_v5_*/CONCEPT.csv`: an Athena OHDSI download with SNOMED CT
   - `data/icd11/ICD11_CONCEPT.csv`: optional, for ICD-11 lookups
   - `knowledge_base/chromadb`: a ChromaDB store with the collection `icd10cm_terminology`, used only by `verify_code` for ICD-10-CM, ICD-10-PCS and ICD-10 codes (the Vocab2 concept table is the fallback)
   - Source data: [LOINC](https://loinc.org), [SNOMED CT](https://www.snomed.org), [Athena OHDSI](https://athena.ohdsi.org)
4. **Network access to `tx.fhir.org`** (optional): for low-confidence cases, phase 4 runs an ensemble vote in which one of the three methods (`_txfhir_search`) sends a `CodeSystem/$lookup` request there. The call is best-effort: without network access that method casts no vote, and phase 4 results may differ.

## Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Phases 0-4 on the 14 focused cases
python benchmark_3phase_rag.py --14

# Phases 0-4 on the 42 extended cases (see the note below)
python benchmark_3phase_rag.py
```

The script in this folder is the version committed after the Configuration M runs (24 March 2026: 94-entry abbreviation dictionary, cross-encoder disabled), with a security patch of 11 August 2026 that passes codes and search terms to `awk` and `grep` as data rather than as program text. Configurations H, J, K and L were run with earlier versions of the script, which are not in this folder (the committed versions nearest to each run are available on request). The two phase-4 runs of Configuration M were made with a harness that is not archived: their result files hold phase 4 only, with the keys `config` (`M`) and `dict_size` (94), and no committed version of the script writes `dict_size`. Configuration I used a separate script that is not archived (manuscript supplement, S11). A re-run need not reproduce the archived figures: the two runs of Configuration J agree in phases 3 and 4 and differ in phases 0–2, and the nine archived runs of the script on the 14 focused cases, made between 19 and 22 March 2026 while it was under development, recorded phase 3 at 57.1–78.6%; no invariance is claimed (S11.1).

## Results from the archived runs

Configuration letters follow the manuscript supplement (Table S11 and S11.1), which is authoritative for configuration letters, case counts and mechanisms. Each figure below comes from an archived result file, listed under the table. Copies of these files are in `per_case_results/`, except the run without the re-ranker (`benchmark_3phase_rag_20260323_154902.json`), which is available on request (S11).

| Phase or configuration | What runs | 14 cases (20 Mar · 22 Mar 2026) | 42 cases |
|---|---|:---:|:---:|
| Phase 0 | No retrieval | 6/14 (42.9%) · 5/14 | — |
| Phase 1 | Database candidates in the prompt | 10/14 · 9/14 | — |
| Phase 2 | + verification of the answer against the database | 10/14 · 9/14 | — |
| Phase 3 | + vocabulary routing | 10/14 · 10/14 | — |
| **Phase 4 = Configuration J** | **The six approaches of S11, including the abbreviation dictionary** | **14/14 · 14/14** | — |
| Configuration K | Expanded dictionary; ICD-10-PCS routed to Vocab2; ICD-11 import | — | 29/42 (69.0%) |
| Configuration L | Cross-encoder re-ranker, in the run that preceded K on the same day | — | 26/42 (61.9%), from 28/42 without it |
| **Configuration M** | **94-entry dictionary, in a harness that is not archived (note under Quick Start)** | — | **30/42 (71.4%)** |

Result files: the two runs of Configuration J, `benchmark_3phase_rag_20260320_130612.json` and `benchmark_3phase_rag_20260322_104655.json`; K, `benchmark_3phase_rag_20260323_184147.json`; L, `benchmark_3phase_rag_20260323_173515.json`, and the run without the re-ranker, `benchmark_3phase_rag_20260323_154902.json`; M, `benchmark_3phase_rag_20260324_114358.json` and `benchmark_3phase_rag_20260324_121448.json`, which hold phase 4 only. For K, L and M the table gives phase 4. Table S11 reports Configuration H as phase 3 of an earlier run on 20 March (`benchmark_3phase_rag_20260320_110529.json`, 10/14).

Until 6 October 2026 this README listed a package series of configurations A–M. Its stages B–I are not reproduced by any archived run, and the series was replaced by the table above.

## Vocabulary Licences and Indexes

The vocabulary files and the ChromaDB store are not included. `terminology_rag.py` can index Athena concepts into its own collections (`athena_<vocabulary>`); the `icd10cm_terminology` collection read by the benchmark script is not built by this package. The authors' local store (eight collections, 2,394,686 embeddings, counted on 6 October 2026) is listed in `results_summary.json`. Source vocabularies require separate licensing agreements:

- **LOINC**: Free registration at [loinc.org](https://loinc.org). This folder holds LOINC codes and their LOINC long common names, from LOINC version 2.80 as given by the authors' Athena download: in `loinc_codes.tsv`, in `test_cases_14.json`, in the fixtures of the tests in `measurement_scripts/`, and next to each LOINC code in the result files of `per_case_results/` (key `loinc_names`). Codes of LOINC form that are not in LOINC 2.80 carry no LOINC name: in the JSON files they are listed under the key `not_in_loinc_2_80`, and `loinc_codes.tsv` marks them. They are codes that a model wrote, and codes written on purpose: the invented codes of path A, and near-miss codes of the routing questions and of the test fixtures. This material contains content from LOINC (http://loinc.org). LOINC is copyright © Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at http://loinc.org/license. LOINC® is a registered United States trademark of Regenstrief Institute, Inc.
- **SNOMED CT**: SNOMED CT is a registered trademark of SNOMED International. The result files hold SNOMED CT codes without names, and in the fixtures of the tests the names next to SNOMED CT codes are placeholder words of the authors, not SNOMED CT descriptions.
- **ICD-10-CM**: Public domain (US CDC). The fixtures of the tests carry ICD-10-CM descriptions of the FY2026 release.
- **ICD-10-PCS** (US Centers for Medicare & Medicaid Services), **ICD-10** and **ICD-11** (World Health Organization): a few of their codes appear without their titles in the scripts or in model answers: an ICD-10-PCS code (0FT44ZZ), three ICD-10 codes that are not in ICD-10-CM (K35.0, K35.1 and K35.9) and an ICD-11 code (QE12); a case sentence of the scripts holds one ICD-10-PCS title. ICD-11 is licensed by the World Health Organization under CC BY-ND 3.0 IGO.
- **Athena OHDSI**: Free registration at [athena.ohdsi.org](https://athena.ohdsi.org)

## Citation

```bibtex
@unpublished{santos2026llmrag,
  author = {Santos, Ricardo Louren{\c{c}}o and Cruz-Correia, Ricardo Jo{\~a}o},
  title  = {A Database-First Architecture for Trustworthy Medical Vocabulary Validation: An {AI}-Assisted Evidence Synthesis with a Supplementary Benchmark of Small Language Models},
  note   = {Submitted to the International Journal of Medical Informatics; submission reference IJMEDI-S-26-09137},
  year   = {2026}
}
```

## License

Code (the Python scripts and tests, in this folder and in `measurement_scripts/`): MIT License, in `LICENSE`. Data (the 14 test cases, `test_cases_14.json`; the per-case results, in `per_case_results/`; the summary of the archived results, `results_summary.json`): Creative Commons Attribution 4.0 International (CC BY 4.0), the licence of the rest of this repository (`../LICENSE`), which also covers the documentation of this folder. Terminology data (the LOINC names in these files and in `loinc_codes.tsv`, and the ICD-10-CM descriptions) remain subject to the respective licensing agreements (see Vocabulary Licences and Indexes).

## Changes from the tag benchmark-2026-11-19c

- `LICENSE` is new: the text of the MIT License, which this README has given for the code since 6 October 2026.
- `loinc_codes.tsv` is new: every code of LOINC form in this folder, with its LOINC 2.80 long common name or the mark that it is not in LOINC 2.80.
- LOINC names: `test_cases_14.json` and the result files of `per_case_results/` carry the LOINC name next to each LOINC code (keys `loinc_names` and `not_in_loinc_2_80`, added to the object that holds the code; no other value changed, and the files without LOINC codes are unchanged). The fixtures of the tests in `measurement_scripts/` carry LOINC names and ICD-10-CM descriptions in place of the placeholder words of the earlier tag, and the 35 tests pass again (`measurement_scripts/README.md`).
- `benchmark_3phase_rag.py` and `measurement_scripts/benchmark_3level_terminology.py`: the Author line names the first author and the assistance of Claude Code, as the manuscript declares; in the first, two internal labels of the docstring are replaced (lines 4 and 10). No other line changed. The path A run read the version of the tags benchmark-2026-11-18 to benchmark-2026-11-19c (SHA-256 `3d0a657176eabe0eb98cef0c93d2d6e9f94de41c1f1f5d75de833d2fa0256e0c`).
- `results_summary.json`: the field `status` gives the status of the manuscript as this README does. No other field changed.
- This README: the status of the manuscript, the author's name as in the manuscript, the contents, the place of the result files, the vocabulary notices and the licences.

## Contact

Author: Ricardo Lourenço Santos
Institution: Faculty of Medicine, University of Porto (FMUP)
Research Groups: RISE-Health, MEDCIDS
Email: ricardolourencosantos@gmail.com
ORCID: [0000-0001-6017-8255](https://orcid.org/0000-0001-6017-8255)
Last updated: 2026-11-25 (see Changes from the tag benchmark-2026-11-19c). Previous updates: 2026-11-18 (the authors and the title of the manuscript as it then stood); 2026-10-07 (the harness of Configuration M and the runs of Configuration J described as in the manuscript supplement); 2026-10-06 (title, authors and status of the manuscript to be submitted; results table rebuilt from the archived result files; prerequisites as read by the benchmark script)
