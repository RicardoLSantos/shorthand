# RS11 Benchmark: Database-First Medical Vocabulary Validation with Small Language Models

Reproducibility package for the empirical evaluation reported in the supplementary materials of:

> Santos RL, Almeida J, Cruz-Correia RJ. **A Database-First Architecture for Trustworthy Medical Vocabulary Validation with Small Language Models: An AI-Assisted Evidence Synthesis with Supplementary Empirical Evaluation**. International Journal of Medical Informatics, new submission (prior submission reference: IJMEDI-D-26-01592).

## Overview

This benchmark evaluates whether small language models (SLMs) combined with Retrieval-Augmented Generation (RAG) can accurately validate medical terminology codes (LOINC, SNOMED CT, ICD-10-CM) on consumer hardware (Apple M1, 16GB RAM).

**Key Result**: from a no-retrieval baseline of 42.9% (6/14, Config A), a pipeline of vocabulary-specific database lookup, LLM synonym expansion and a clinical abbreviation dictionary reached **100%** (14/14) on a focused 14-case test set (Config J) and **71.4%** (30/42) on an extended 42-case set (Config M). In `benchmark_3phase_rag.py`, ChromaDB is used only to verify ICD-10-CM codes (`verify_code`). These are figures for the pipeline as a whole; one of the 14 focused cases and two of the 42 extended cases are scored by a response-length threshold, and two further extended cases on a placeholder answer (manuscript supplement, S11.1 and S17.5).

> **Note on configuration labels:** the accuracy figures below (`Config A–M`) enumerate the finer-grained 14-case pipeline stages of *this package*; the manuscript supplement (Table S11) is authoritative for configuration letters, case counts, and mechanisms. The 42.9% here is the package baseline (the no-retrieval stage of the 14-case set), **not** the paper's 36-case Configuration G baseline. See [Configuration Labels — Scope Note](#configuration-labels--scope-note).

## Contents

| File | Description |
|------|-------------|
| `benchmark_3phase_rag.py` | Main benchmark script (13 configurations, A-M) |
| `terminology_rag.py` | RAG engine for terminology suggestion |
| `test_cases_14.json` | 14 focused test cases (100% accuracy achieved) |
| `results_summary.json` | All configuration results (A-M) |
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
   - `knowledge_base/chromadb`: a ChromaDB store with the collection `icd10cm_terminology`, used only to verify ICD-10-CM codes
   - Source data: [LOINC](https://loinc.org), [SNOMED CT](https://www.snomed.org), [Athena OHDSI](https://athena.ohdsi.org)

## Quick Start

```bash
# Install dependencies
pip install -r requirements.txt

# Run 14-case focused benchmark (Config J = 100%)
python benchmark_3phase_rag.py --14

# Run full 42-case benchmark (Config M = 71.4%)
python benchmark_3phase_rag.py
```

## Configurations Tested

| Config | Method | 14-case | 42-case |
|:------:|--------|:-------:|:-------:|
| A | Baseline (no RAG) | 42.9% | — |
| B | ChromaDB RAG | 78.6% | — |
| C-H | RAG + various enhancements | 85.7% | — |
| I | RAG + 55-entry dictionary | 92.9% | — |
| **J** | **RAG + 80-entry dictionary** | **100%** | — |
| K | Config J on 42 cases | — | 69.0% |
| L | Cross-encoder re-ranker added to the preceding 42-case run (same day, before K), which scored 28/42 without it | — | 61.9% (26/42) |
| **M** | **Config K + 94-entry dictionary** | — | **71.4%** |

## Configuration Labels — Scope Note

The manuscript supplement (**Table S11** and note **S11.1**) is authoritative for configuration letters, case counts, and mechanisms. The `A`–`M` labels in **this package** enumerate successive pipeline stages of the 14-case run at a finer granularity, so the package's `A`–`J` do **not** correspond to Configurations A–J reported in the paper.

In particular, the baseline here (`A`, 42.9%, 6/14) is the **no-retrieval stage of the 14-case set**; it is **not** the paper's 36-case Configuration G baseline, which the paper reports as **24.2% (8/33)** merit-scored / **30.6% (11/36)** as-run. The `A`–`M` accuracy values in this package are unchanged; a full relabel to the manuscript's scheme awaits the editorial decision. (For the paper's per-configuration definitions and case counts, see the supplement, Table S11 and S11.1.)

## Vocabulary Licences and Indexes

The vocabulary files and the ChromaDB store are not included. `terminology_rag.py` can index Athena concepts into its own collections (`athena_<vocabulary>`); the `icd10cm_terminology` collection read by the benchmark script is not built by this package. The authors' local index (eight collections, about 2.4 million embeddings) is listed in `results_summary.json`. Source vocabularies require separate licensing agreements:

- **LOINC**: Free registration at [loinc.org](https://loinc.org)
- **SNOMED CT**: Via [IHTSDO](https://www.snomed.org) member country license
- **ICD-10-CM**: Public domain (US CDC)
- **Athena OHDSI**: Free registration at [athena.ohdsi.org](https://athena.ohdsi.org)

## Citation

```bibtex
@article{santos2026llmrag,
  author  = {Santos, Ricardo Louren{\c{c}}o dos and Almeida, Jo{\~a}o and Cruz-Correia, Ricardo Jo{\~a}o},
  title   = {A Database-First Architecture for Trustworthy Medical Vocabulary Validation with Small Language Models: An {AI}-Assisted Evidence Synthesis with Supplementary Empirical Evaluation},
  journal = {International Journal of Medical Informatics},
  year    = {2026},
  note    = {New submission; prior submission reference IJMEDI-D-26-01592}
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
Last updated: 2026-10-06 (title, authors and status of the October 2026 manuscript; key result attributed as in its supplement, S17.5; prerequisites as read by the benchmark script)
