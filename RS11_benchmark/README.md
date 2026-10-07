# RS11 Benchmark: Database-First Medical Vocabulary Validation with Small Language Models

Reproducibility package for the empirical evaluation reported in the supplementary materials of:

> Santos RL, Coutinho-Almeida J, Cruz-Correia RJ. **A Database-First Architecture for Trustworthy Medical Vocabulary Validation with Small Language Models: An AI-Assisted Evidence Synthesis with Supplementary Empirical Evaluation**. Manuscript to be submitted to the International Journal of Medical Informatics (prior submission reference: IJMEDI-D-26-01592).

## Overview

This benchmark evaluates whether small language models (SLMs) combined with Retrieval-Augmented Generation (RAG) can accurately validate medical terminology codes (LOINC, SNOMED CT, ICD-10-CM) on consumer hardware (Apple M1, 16GB RAM).

**Key Result**: a pipeline of vocabulary-specific database lookup, LLM synonym expansion and a clinical abbreviation dictionary reached **14/14** on a focused 14-case test set (Configuration J, in two runs) and **30/42 (71.4%)** on an extended 42-case set (Configuration M); without retrieval (phase 0 of those two runs), the same model scored 6/14 (42.9%) and 5/14. These are figures for the pipeline as a whole. In the run of 20 March 2026, 8 of the 14 focused cases were resolved by the confidence-gated database path and 6 by model-mediated paths: 3 were scored on the answer without code re-validation, and in 3 the model emitted an ICD-10-CM code from memory, which a code-existence check then confirmed for two; the third, a SNOMED CT-to-ICD-10-CM cross-mapping, was counted by a string match, with no database confirmation. One of the 14 focused cases and two of the 42 extended cases are scored by a response-length threshold, and two further extended cases on a placeholder answer (manuscript supplement, S11.1 and S17.5).

In `benchmark_3phase_rag.py`, ChromaDB is used only in `verify_code`, which looks up ICD-10-CM, ICD-10-PCS and ICD-10 codes in the collection `icd10cm_terminology` before falling back to the Vocab2 concept table. Phase 4 can also query `tx.fhir.org` (see Prerequisites).

## Contents

| File | Description |
|------|-------------|
| `benchmark_3phase_rag.py` | Benchmark script: phases 0–4 of the pipeline on the 14 focused or the 42 extended cases (see the note under Quick Start) |
| `terminology_rag.py` | RAG engine for terminology suggestion |
| `test_cases_14.json` | The 14 focused test cases, as in the script (Configuration J: 14/14) |
| `results_summary.json` | Archived results (the five phases of the two 14-case runs whose phase 4 is Configuration J; phase 4 of Configurations K, L and M) and the authors' local ChromaDB collections |
| `requirements.txt` | Python dependencies |

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

Configuration letters follow the manuscript supplement (Table S11 and S11.1), which is authoritative for configuration letters, case counts and mechanisms. Each figure below comes from an archived result file, listed under the table; the result files are available on request (S11).

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

- **LOINC**: Free registration at [loinc.org](https://loinc.org)
- **SNOMED CT**: Via [IHTSDO](https://www.snomed.org) member country license
- **ICD-10-CM**: Public domain (US CDC)
- **Athena OHDSI**: Free registration at [athena.ohdsi.org](https://athena.ohdsi.org)

## Citation

```bibtex
@unpublished{santos2026llmrag,
  author = {Santos, Ricardo Louren{\c{c}}o dos and Coutinho-Almeida, Jo{\~a}o and Cruz-Correia, Ricardo Jo{\~a}o},
  title  = {A Database-First Architecture for Trustworthy Medical Vocabulary Validation with Small Language Models: An {AI}-Assisted Evidence Synthesis with Supplementary Empirical Evaluation},
  note   = {Manuscript to be submitted to the International Journal of Medical Informatics; prior submission reference IJMEDI-D-26-01592},
  year   = {2026}
}
```

## License

Code: MIT License. Terminology data subject to respective licensing agreements.

## Contact

Author: Ricardo Lourenço dos Santos
Institution: Faculty of Medicine, University of Porto (FMUP)
Research Groups: RISE-Health, MEDCIDS
Email: ricardolourencosantos@gmail.com
ORCID: [0000-0001-6017-8255](https://orcid.org/0000-0001-6017-8255)
Last updated: 2026-10-07 (the harness of Configuration M and the runs of Configuration J described as in the manuscript supplement). Previous update: 2026-10-06 (title, authors and status of the manuscript to be submitted; results table rebuilt from the archived result files; prerequisites as read by the benchmark script)
