# RS11 Benchmark: LLMs and RAG for Medical Vocabulary Validation

Reproducibility package for the empirical benchmark described in:

> Santos RL, Cruz-Correia RJ. **LLMs and RAG for Medical Vocabulary Validation: A Systematic Review and Empirical Benchmark**. International Journal of Medical Informatics (under review). Manuscript ID: IJMEDI-D-26-01592.

## Overview

This benchmark evaluates whether small language models (SLMs) combined with Retrieval-Augmented Generation (RAG) can accurately validate medical terminology codes (LOINC, SNOMED CT, ICD-10-CM) on consumer hardware (Apple M1, 8GB RAM).

**Key Result**: Baseline LLM accuracy of 42.9% improved to **100%** on a focused 14-case test set (Config J) and **71.4%** on an extended 42-case set (Config M) using ChromaDB RAG + clinical abbreviation dictionary.

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
3. **ChromaDB** collections (not included due to size — 2.5M embeddings, ~4GB):
   - `loinc_full` (103,511 codes)
   - `snomed_terminology` (349,211 codes)
   - `icd10cm` (47,361 codes)
   - `synonym_terminology` (1,862,419 entries)
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
| L | Config K + cross-encoder | — | 61.9% |
| **M** | **Config K + 94-entry dictionary** | — | **71.4%** |

## ChromaDB Collection Setup

The benchmark requires pre-indexed ChromaDB collections. Indexing scripts are available in the main thesis repository. Source vocabularies require separate licensing agreements:

- **LOINC**: Free registration at [loinc.org](https://loinc.org)
- **SNOMED CT**: Via [IHTSDO](https://www.snomed.org) member country license
- **ICD-10-CM**: Public domain (US CDC)
- **Athena OHDSI**: Free registration at [athena.ohdsi.org](https://athena.ohdsi.org)

## Citation

```bibtex
@article{santos2026llmrag,
  author  = {Santos, Ricardo Louren{\c{c}}o dos and Cruz-Correia, Ricardo Jo{\~a}o},
  title   = {{LLMs} and {RAG} for Medical Vocabulary Validation: A Systematic Review and Empirical Benchmark},
  journal = {International Journal of Medical Informatics},
  year    = {2026},
  note    = {Under review. Manuscript ID: IJMEDI-D-26-01592}
}
```

## License

Code: MIT License. Terminology data subject to respective licensing agreements.

## Contact

Ricardo Lourenco dos Santos — ricardolourencosantos@gmail.com
ORCID: [0000-0001-6017-8255](https://orcid.org/0000-0001-6017-8255)
Faculty of Medicine, University of Porto (FMUP) / CINTESIS@RISE
