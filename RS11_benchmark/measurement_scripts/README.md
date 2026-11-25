# Measurement scripts (cleaned copies)

This folder holds cleaned copies of the scripts and tests of the three routing measurements of 19 November 2026 (Supplementary S18.1 of the article): (a) path A in isolation; (b) arm 1, the conformance of the router with its written specification (the service's README, OpenAPI description and formal specification, which are not published); and (c) arm 2 with path C end to end, with a post-hoc re-read of (c). It also holds the protocol of each measurement, in Portuguese, as committed before its run, and the script of Configuration G (the 36-case baseline), whose case sentences path C reads. The per-case results that these scripts wrote are in `../per_case_results/` (tag `benchmark-2026-11-19`). The three-phase benchmark script in the parent folder, which the path A script reads, differs from the version that the path A run read only in its docstring (see the parent README); the version read, with the SHA-256 that the run recorded, is the one of the tags benchmark-2026-11-18 to benchmark-2026-11-19c. These copies were deposited after the per-case copies, whose README of the tag benchmark-2026-11-19 gave the scripts as available on request; the scripts in this folder are public.

## What the scripts need

- The authors' terminology router service, which the scripts import (`services/terminology-router`, at commit `5b313864f` of the authors' working repository). It is not published; it is available from the corresponding author on request.
- The vocabularies, which a reader obtains under each vocabulary's own licence: the Athena `CONCEPT.csv` (used for LOINC and UCUM) at `etl/data/athena/`, the Vocab2 `CONCEPT.csv` (used for SNOMED CT, ICD-10 and UCUM) at `knowledge_base/Vocabulario/`, and the CMS ICD-10-CM FY2026 tabular file at `data/icd10cm_fy2026/code_tables/Table and Index/icd10cm_tabular_2026.xml`.
- The original result files that they build on, in `results/llm_benchmarks/`. Copies are in `../per_case_results/`, with the LOINC name next to each LOINC code and without SNOMED CT names.
- For (b) and (c), the original set of 73 routing questions, with their wording, at `routing_question_set/routing_question_set_20261119_083359.json`, with its `.sha256` file beside it. It is available on request; its copy in `../per_case_results/` keeps each question's identifier, category, codes and expected route.
- For (c), the local model `qwen3.5:4b`, through Ollama on `127.0.0.1` only.

Paths are relative to the root of a working copy, with the scripts in `scripts/`. Each script writes its result to a new file in `results/llm_benchmarks/`.

## How the copies were checked

- The tests ran on the originals and on the copies, each set in a working copy with the service at `5b313864f`: 12 in `test_benchmark_path_a_isolated.py`; 5 in `test_benchmark_routing_conformance.py`; 18 in `test_benchmark_routing_arm2_path_c.py`, all passing in both. On 25 November 2026, after the fixtures took the LOINC names and the ICD-10-CM descriptions, the tests ran again in the same way, on the originals and on these copies: all 35 pass in both.
- In the copy of the arm 2 script, the two fixed texts sent to the model have the SHA-256 that the arm 2 run recorded.
- The SHA-256 that each result file records for a script is that of its original (the table below).
- A scripted sweep found in the copies no internal label of the authors' working sessions, no path of the authors' machine and no name of an internal file. gitleaks found no secret.

## What the copies keep

- The names in the fixtures of the tests. The LOINC rows carry the LOINC 2.80 long common name of their code, and the ICD-10-CM rows the FY2026 descriptions, as the originals did except where noted below. The SNOMED CT rows carry placeholder words of the authors (Delta disorder, Zeta, Zeta attack), not SNOMED CT descriptions. The row of 99990-1, which is not a LOINC code (its check digit is wrong), keeps the name of the original.
- The case sentences of the 36-case baseline, in `benchmark_3level_terminology.py`, as written: they are inputs of the benchmark, like the test cases of the three-phase script. One test checks one of these sentences.
- The asserted name of a trap case, in `protocol_path_a_isolated.md`, and `aspirin`, the RxNorm term of the control query of the path A script.
- Commit identifiers, which refer to the authors' working repository, and clock times, which are those of Lisbon (WET).
- Labels and messages in Portuguese, as in the per-case copies.
- The docstring of the post-hoc script says that the re-read was "declared in the report (section 3.1)": that is the authors' working report, which is not deposited; the re-read is described in Supplementary S18.1.
- The words "public specification" in the docstring of `benchmark_routing_conformance.py`, and "especificação pública" in `protocol_routing_two_arms.md`, as written before the runs: they name the service's written specification, which is not published. The SHA-256 of each file of the service as measured is in `../service_manifest/`.

## The protocols

The protocols are sections of the authors' working report, in Portuguese, as committed before each run. Their results sections (1.2, 2.1 and 3.1) are reported in Supplementary S18.1 and are not deposited.

| Protocol | Sections | Commits | Run |
|---|---|---|---|
| `protocol_path_a_isolated.md` | 1 and 1.1 | `5f5e0ea86` (08:26:24) and `14dfde4ad` (08:32:45) | 08:32:50 |
| `protocol_routing_two_arms.md` | 2 | `0d3642ff1` (08:42:29) | 08:42:37 |
| `protocol_routing_arm2_path_c.md` | 2.2 and 3 | `5f2b81e7b` (09:05:25) | 09:05:35 to 09:29:35 |

In the copies, each cut is marked «[…]», and a word in square brackets takes the place of an internal name: [primeiro autor], the first author; [coordenador], the AI session that coordinated the day's work and relayed the first author's decisions; [rotulador], the AI labeller that wrote and labelled the 73 routing questions; [revisor], an AI reviewer that had read the service's code.

## When each original was committed

- Each script and test of the three measurements was committed before its run, with its protocol (above). The post-hoc re-read script was not: the re-read ran at 09:31:43, and the script was committed at 09:34:14 (`4d5bd9c50`); the re-read's result records the SHA-256 of this original.
- The Configuration G script has one commit, `e74ebc3b6`, at 19:31:42 on 19 March 2026; its result file is stamped 19:30:30 that day. The arm 2 run recorded the SHA-256 of this original.

## Files

| File | What it is | Original | Bytes (original, copy) | SHA-256 of the copy | SHA-256 of the original |
|---|---|---|---|---|---|
| `benchmark_path_a_isolated.py` | measurement (a): path A in isolation | `14dfde4ad`, 2026-11-19 08:32:45, `scripts/benchmark_path_a_isolated.py` | 20776, 20617 | `0f3216c974cf69c5be22900968d3cdd5fa15841a3e5f73a49213110a8411d758` | `9799111c68b84a9a88f8fd4de0845b5b90dec29ef2e81311e0882f82b62579e7` |
| `test_benchmark_path_a_isolated.py` | test of measurement (a), written and run before it | `14dfde4ad`, 2026-11-19 08:32:45, `scripts/test_benchmark_path_a_isolated.py` | 10468, 10466 | `770f5b03b3783ac94b589224d83fd83a7ec2f034356bb8c54faf1705e2efe997` | `a6da2dc525d1184d5aa610624f11d1bd2ce97173acefed3193648f2a16366233` |
| `benchmark_routing_conformance.py` | measurement (b): routing, arm 1 | `0d3642ff1`, 2026-11-19 08:42:29, `scripts/benchmark_routing_conformance.py` | 6637, 6502 | `cbe10a66e439429f631141718c0508655bb65155bfe6433ba5b61807d5a2d4b0` | `55cb758ee9aa88c19a0bf50fb402158b4cf63a1c2600813081d2e4992bc936c8` |
| `test_benchmark_routing_conformance.py` | test of measurement (b), written and run before it | `0d3642ff1`, 2026-11-19 08:42:29, `scripts/test_benchmark_routing_conformance.py` | 4491, 4456 | `03527e3d3f27ce05dc72831613c09bd339354d9ef3bcd64ed801565a735a4c27` | `317fc6843489db861937c087c57782417ad91d6b3d9b92c068007f11d7c2ad18` |
| `benchmark_routing_arm2_path_c.py` | measurement (c): routing, arm 2, and path C end to end, with the local model | `5f2b81e7b`, 2026-11-19 09:05:25, `scripts/benchmark_routing_arm2_path_c.py` | 28536, 28557 | `0cd93e742b83af7f4da6468c4ebb53cca83066423bd10001d207e3be43528774` | `a768cffa823ff43550ce31c16e834e074ca2e6ae0cde0fefe546b5e6071c09cf` |
| `test_benchmark_routing_arm2_path_c.py` | test of measurement (c), written and run before it | `5f2b81e7b`, 2026-11-19 09:05:25, `scripts/test_benchmark_routing_arm2_path_c.py` | 14754, 14785 | `1cb0a8c9f12bd0232017ef0af910b526aa9120141d5148e814ec6e9b99a32e2d` | `36672873b247847eda328039029b342fcd2a8ed40b04532f0adf4eb146698325` |
| `posthoc_fence_reparse_arm2_path_c.py` | post-hoc re-read of measurement (c), committed after the re-read | `4d5bd9c50`, 2026-11-19 09:34:14, `scripts/posthoc_fence_reparse_arm2_path_c.py` | 6396, 6425 | `c5cab0f48dca262751aad79bc5ecc80855f0c2f4564a343e54f2b4edb19bc328` | `27310485eabcd4cb900a1bfccdf2dfbfcb5ddb188511a7e9388868f81abc0ff7` |
| `benchmark_3level_terminology.py` | Configuration G, the 36-case baseline (path C reads its case sentences) | `e74ebc3b6`, 2026-03-19 19:31:42, `scripts/benchmark_3level_terminology.py` | 13795, 13762 | `356472bf7bc371577107d735cd3cecdca408450640d6965a93e317740e63df60` | `9ccdbaa47f3893726d049c9a8c9886b6179c6a87f66e3f61c4073131f8790a42` |
| `protocol_path_a_isolated.md` | protocol of measurement (a): sections 1 and 1.1 of the working report | lines added to the working report by `5f5e0ea86` and `14dfde4ad` | 10394, 10049 | `a3451181d7a84a65e6e82d086a047038eb6761fb4ec52cb86d2fdde131f49d03` | `56f59567dc982f75bb656fed616c4032ba8184c8361f41e8d5ea9b94a85fbd5c` |
| `protocol_routing_two_arms.md` | protocol of measurement (b): section 2 of the working report | lines added to the working report by `0d3642ff1` | 6135, 6162 | `3c0e90aa00d45930c2184c048dc0f64a09354c210989cc45801f4f47ec471675` | `cf777fdd15e6d020d78b595638418f5d6aebcffa1346728533ffc881c211c063` |
| `protocol_routing_arm2_path_c.md` | protocol of measurement (c): sections 2.2 and 3 of the working report | lines added to the working report by `5f2b81e7b` | 9541, 9598 | `d9e1a8e0a65439b317251af498271e66ce8ee0a5a979fc80d82b14204177a00d` | `ab0c8c14f741e96a9ad7b20e8b354f384282a6f1b6d50cf7e5068b216bf6cf5a` |

## Changes, file by file

Line numbers are those of the copy. In the tag benchmark-2026-11-19c the fixtures of the tests also had placeholder words in place of the LOINC names and the ICD-10-CM descriptions; they now carry them (above).


### `benchmark_path_a_isolated.py`

- l.4: an internal label of the author is removed; the path of the authors' working report becomes the deposited protocol file.
- l.43: the download folder of the Vocab2 bundle is taken out of the path: its CONCEPT.csv goes in knowledge_base/Vocabulario/ (Supplementary S11).
- l.423: the path of the authors' working report becomes the deposited protocol file (in the result field).

### `test_benchmark_path_a_isolated.py`

- l.2: an internal label of the author is removed.
- l.5: the path of the authors' working report becomes the deposited protocol file.
- ll.31, 32: fixture rows LOINC 2339-0 and 2345-7: their shared name «Glucose», which is not a LOINC name of either code, becomes the LOINC 2.80 long common name of each.
- l.34: fixture row LOINC 80405-4: its name takes the capital letter of its LOINC 2.80 long common name («Provider Certification [Type]»).
- l.35: fixture row SNOMED CT 44054006: its name becomes «Delta disorder».
- ll.36, 37: fixture rows SNOMED CT 195967001 and 266364000: «Zeta» takes the place of the shared word of their names (2 places).
- l.48: an internal label is taken out of the prefix of the temporary folder.
- l.94: lower-case queries for the SNOMED CT rows become «zeta» and «delta» (2 places).
- l.149: a lower-case query for a SNOMED CT row becomes «zeta».

### `benchmark_routing_conformance.py`

- l.2: an internal label of the labeller becomes «the labeller»; an internal review-item label is taken out.
- l.4: an internal label of the author is removed; the path of the authors' working report becomes the deposited protocol file.
- l.29: the question set's folder in the working repository becomes routing_question_set/, and an internal review-item label is taken out of its file name (as in ../per_case_results/).
- l.95: an internal label of the labeller becomes labeller_ in a result key (as in the per-case copies).
- l.107: the path of the authors' working report becomes the deposited protocol file (in the result field).

### `test_benchmark_routing_conformance.py`

- l.2: an internal label of the author is removed.
- l.5: the path of the authors' working report becomes the deposited protocol file.

### `benchmark_routing_arm2_path_c.py`

- l.2: internal review-item labels are taken out.
- l.4: an internal label of the author is removed; the path of the authors' working report becomes the deposited protocol file.
- ll.7, 63, 192: an internal label of the labeller becomes «the labeller's» (comments) (3 places).
- ll.191, 363, 364, 402, 403, 406, 421, 423: an internal label of the labeller becomes labeller_ in a function name and in result keys (as in the per-case copies) (11 places).
- l.329: an internal label of the labeller is taken out of a comment (eight dashes less, same width).
- l.461: the path of the authors' working report becomes the deposited protocol file (in the result field).

### `test_benchmark_routing_arm2_path_c.py`

- l.2: an internal label of the author is removed.
- l.5: the path of the authors' working report becomes the deposited protocol file.
- ll.102, 104, 106, 244: an internal label of the labeller becomes labeller_ (as in the script), in a test name too (5 places).
- l.203: the expected candidate line carries the LOINC 2.80 long common name of 2345-7, which the fixture now gives (`test_benchmark_path_a_isolated.py`, l.32).

### `posthoc_fence_reparse_arm2_path_c.py`

- l.4: an internal label of the author is removed; the protocol file is named.

### `benchmark_3level_terminology.py`

- l.6: the Author line names the first author and the assistance of Claude Code (Anthropic; Claude Opus 4.6), as the manuscript declares.
- l.79: a note to the first author in a comment is cut ([...]).
- l.86: a note to the first author in a comment is cut ([...]).
- l.88: a note to the first author in a comment is cut ([...]).

### `protocol_path_a_isolated.md`

- l.1: the title and the opening line of the working report are cut.
- l.3: internal review-item labels are cut.
- l.5: two internal names become roles in brackets; the internal files and their places are cut.
- l.22: the download folder of the Vocab2 bundle is cut from the path.
- l.30: an internal review-item label is cut.
- l.69: an internal name becomes a role.
- l.84: an internal name becomes a role.
- l.88: an internal name becomes a role.

### `protocol_routing_two_arms.md`

- l.2: an internal review-item label is cut.
- ll.4, 49, 64: an internal name becomes a role (4 places).
- l.6: an internal name becomes a role; the folder in the working repository and an internal review-item label are cut from the file name.
- ll.10, 38, 40: an internal name becomes a role (3 places).
- ll.12, 43: an internal name becomes a role (2 places).
- l.39: an internal name becomes a role.
- l.51: an internal review-item label is cut.
- l.64: an internal name becomes a role; a mention of the working session is cut.

### `protocol_routing_arm2_path_c.md`

- ll.2, 43, 49, 53, 54, 56, 100: an internal name becomes a role (7 places).
- l.4: an internal name becomes a role; a pointer to the labeller's own report is cut.
- ll.5, 6, 43: an internal name becomes a role (3 places).
- l.11: an internal name becomes a role.
- l.13: internal review-item labels are cut.
- l.16: two internal names become roles; an internal commit and an internal file are cut.
- l.17: an internal name becomes a role; a mention of the working session is cut.
- l.19: an internal name becomes a role.
