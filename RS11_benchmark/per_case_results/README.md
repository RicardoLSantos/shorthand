# Per-case result files (copies without vocabulary names)

This folder holds copies of the per-case JSON result files of the terminology benchmark: Configurations A to M, the G′ variant, and the routing measurements of 19 November 2026 (path A in isolation, arm 1, arm 2 with path C, and a post-hoc re-read of arm 2 and path C), with the set of 73 routing questions. The three-phase benchmark script and its test cases are in the parent folder.

## What the copies keep and what they leave out

The copies keep the codes, the scores and the decisions of each case. They carry no LOINC or SNOMED CT names. Field by field:

- **Model responses** (`response`) and **retrieved context** (`context_used`) are replaced by the code-shaped tokens found in them, in order and without repeats (`response_codes`; `context_codes`, a list of rank, code and vocabulary).
- **Raw model answers in JSON** (`raw`, `choice_raw`) are replaced by their `task`, `system_hint`, `code` and `target_system` fields (`raw_fields`, `choice_raw_fields`). The `query` and `display` fields of the requests the model wrote are left out.
- **Reasons** written by the labeller or by the router (`reason`, `labeller_reason`, `decision_reason`) and the base facts of each question are replaced by the codes they cite (`*_codes`). An abstention keeps its kind, the label before its first colon (`abstention_kind`), and its codes (`abstention_codes`).
- **The words of the questions** (`text`, `term`, `display`, `query`) are left out. Each of the 73 routing questions keeps its identifier, category, codes and expected route.
- File paths of the authors' working copy are reduced to file names. Commit identifiers refer to the authors' working repository.
- Summary fields are as each run recorded them. The figures reported are those of the article and its supplement.

The check was scripted. No run of two or more words of any string equals the name of a LOINC term or of a SNOMED CT concept (concept names and synonyms). Qualifier values, attributes, linkage and metadata concepts and LOINC answers are left out of the check. No whole string value equals such a name, outside the fields of fixed labels. No single word of four letters or more that is such a name stands within three words of a code.

Some labels are in Portuguese: `acerto` (hit), `recusa_certa` (correct refusal), `erro` (error), `sem_resposta` (no answer), `escolha` (choice), `rota` (route), `json-invalido` (invalid JSON), `codigo` and `nome` (the form of the query: a code or a name).

## Files

| File | What it is | Cases | Bytes | SHA-256 of the copy | SHA-256 of the original |
|---|---|---|---:|---|---|
| `benchmark_v3_rag_20260222_101751.json` | Configuration A (Phase 1) | A: 18 | 13706 | `f857675823414318e68d4d462a4ff9b63eeee386f209982a5868a0914187f4fc` | `5260ad1f86db3ec098202b2f05d3fa2c8fd0e1318a75b3d2074cd755a5476981` |
| `benchmark_v3_rag_20260222_103125.json` | Configuration B (Phase 1) | B: 18 | 16826 | `413f650add31feb222a90be64e6fd874c998097d846f7c885b150fb86423e496` | `bfcbc52b7967f29bd5a8d81dd2e8d0fa4a682df4f071a418cef69b204bc08346` |
| `benchmark_v3_rag_20260222_112303.json` | Configurations C and D (Phase 1) | C: 18; D: 18 | 29812 | `feeb45ee9ddc6085d31a119bd689931bd545bc8fbb4f939dcab66e0d43d61531` | `959099e30e36ab72ae9ce2585a48dbb385e0fd03c0248fb4442ad885e8571d15` |
| `benchmark_v3_rag_20260222_125929.json` | Configurations E and F (Phase 1) | E: 18; F: 18 | 29953 | `75cc6d0f8b8417698e4c8521a6cca9ec82a2f0e3d6ac59f8a6dfe8cab4e2679b` | `9ff7e1dbbe54e8bfa3e497fd69e374147d8054d22f874875d4a0ca978741efaf` |
| `benchmark_v3_rag_20260319_164542.json` | archived run with a letter of its own (G); a failed execution, not Configuration G | G: 18 | 10599 | `eaba4bbe9c1722168d64fc326093573d6664f2d60e98dd2faa2bc335b98df622` | `097631ba417bb059645940415f2b65b70fa11db3021cd26be0179566816876b8` |
| `benchmark_v3_rag_20260319_173627.json` | archived runs with letters of their own (G and H); failed executions, not Configurations G and H | G: 18; H: 18 | 21141 | `84ca062ba057c089175eadc3e2e2d4ff5178793088ccef7eb8f29458faee1365` | `5b7eef074742eae5831ec614e8734c108b79c6dd9277426e6bdf9682772b2d1b` |
| `benchmark_3level_qwen3_5_4b_all_20260319_193030.json` | Configuration G (36-case baseline) | 36 | 9613 | `bbcb10f5fa306f1ef353791ccdd5e50cba6f058fb8956f9eefc23579c380082b` | `3a4091f8b9381c9cb645ebef9544bb2f570309893387cdd04f7d9b300ee24a52` |
| `benchmark_qwen35_norag_20260319_181347.json` | variant G' | 12 | 2304 | `6a2ea09b86012cf04bcc2e1406c0aedf15c101165a466f52cb645383b69229d8` | `524f481c3a908d17b5bdf7e37da375bc738a2cad9f49ef95b0850b94b8a4d08d` |
| `benchmark_3phase_rag_20260320_110529.json` | Configuration H | 14 per phase (phase0, phase1, phase2, phase3) | 5905 | `ca07cdcd2aa82e437440858ecba2af6b33db935a845b1a2dd5711c01ef9e8761` | `4f50c0ea429931c2e24164972b94d79b744e99ac4c1125773a4fcc980bb1aac7` |
| `benchmark_chromadb_rag_20260319_210935.json` | Configuration I | 14 | 1396 | `6ef3464154aa9378da505fee80acff3ff8aa3d44f9f229b63205dc746ecc84c1` | `ace06df0bc085edf7c5c1bc7570bb070205b970bfec6061ffee3fca6f2d3cabd` |
| `benchmark_3phase_rag_20260320_130612.json` | Configuration J | 14 per phase (phase0, phase1, phase2, phase3, phase4) | 8691 | `446463b5717fb09e72583c3f66c9e204c64d946b7ded1c288042aa86f3d3829c` | `8903e5cbd328fa31b68c994a8c487532aca43a60c81e0daa1bfd842c877c7483` |
| `benchmark_3phase_rag_20260322_104655.json` | Configuration J, second run | 14 per phase (phase0, phase1, phase2, phase3, phase4) | 8689 | `ca06ba5fbe36435a20153531c63d956edd4037b9a0b3e6193d000d8f5dab1a0e` | `cd00cfa4d6094cd111defef5b8b10129a869c8c984b5c184306d3261c5e35fc0` |
| `benchmark_3phase_rag_20260323_184147.json` | Configuration K | 42 per phase (phase0, phase1, phase2, phase3, phase4) | 25427 | `76494f005114bce48884cdd6af98c370805eeb05e29ee06d0d1cc790ddedc4f4` | `0fea52017532d258baf46d135b3ea181e340d7a0081a4c01eed5cbb0137981e6` |
| `benchmark_3phase_rag_20260323_173515.json` | Configuration L | 42 per phase (phase0, phase1, phase2, phase3, phase4) | 25411 | `31ab8143f5810f1204ac4e471b65324934ffb0bc59c81f64504accd89f0a0dd9` | `7bb4ea5cc437329c04e4701b83baf0665aaaae056345a5a908df5ea663e41b4b` |
| `benchmark_3phase_rag_20260324_114358.json` | Configuration M, phase-4 run | 42 per phase (phase4) | 5110 | `8c30c2d4cf5de2b64377b47e4de85af9edfdf4205ae9d42477845995fe5f82ef` | `385ee5be704d2e8d9db9d17e56c8f53875baf60c9fcf9bc8c88fe86aad334713` |
| `benchmark_3phase_rag_20260324_121448.json` | Configuration M, phase-4 run | 42 per phase (phase4) | 5110 | `3f369eb74c3957dadb230eebe343fa583a6ce80779f7a431ece65689d3096dcd` | `51a92fed2b407d51d95b9ef96bceb91d8441e3414301517418ae5bb40b659d49` |
| `routing_question_set_20261119_083359.json` | the 73 routing questions | 73 questions | 33753 | `99bb4a1c6059c8af5bf56915b5649f79e224bdc93da94ad0a1823a257e175698` | `d3388829e84e89fd9a3f2ab2778b348bca9d6e5e4dd7d6c0993a17bb881e60c0` |
| `benchmark_path_a_isolated_20261119_083250.json` | path A in isolation | 4250 rows | 1146904 | `02e822efff2a8d103bf78db16568fd37ee82b2534d0ef2ad8a7bb4e9988a5b54` | `fc6ab3aa47fa9c594f9d3fb2a76c781f17395ffa98dccb020f02a861ec535ca6` |
| `benchmark_routing_conformance_20261119_084237.json` | routing, arm 1 | 73 rows | 40176 | `f2d3a035521b46267d5a7b7758ca7f6e710e06e028b0e7717a9292dc84a57625` | `e85ef67368b09ec941a3655e7ec0433546a08a3eaa8d5dc685f389f6e99a9465` |
| `benchmark_routing_arm2_path_c_20261119_090535.json` | routing, arm 2, and path C | arm 2: 73; path C: 33 | 168482 | `4ca8bc7e13d106177e76c2db9e58f3e733aa4226307e8a1a3322b63083d661e6` | `00f1b16966d41f2159f4621211b6c4fdc68597ff51deb30faef2d0149121847b` |
| `benchmark_routing_arm2_path_c_posthoc_fence_20261119_093143.json` | post-hoc re-read of arm 2 and path C | arm 2: 73; path C: 33 | 158948 | `292ee1ece9dd726f46aae4db4a2e1bc98b37c4d77e4d88effa3316ebe169c103` | `180a52c35a15d9c98c8e1a0f31da0c5f41bb982697a64276bc7655fc07e82229` |

The two archived files of 19 March 2026 named `benchmark_v3_rag_*` carry configuration letters of their own (G, and G and H). They do not denote Configurations G and H: they are failed executions, kept for completeness.

## Left out

- The result file of a run of 22 May 2026 and an archived run of 22 February 2026 (`benchmark_v3_rag_20260222_124859`). Neither run is reported. Both are available on request.
- The vocabulary files and the authors' local vector store, under the vocabularies' licences. A reader obtains the vocabularies under each one's own licence.
- Files that are not per-case results, such as scripts and logs. They are available on request.
