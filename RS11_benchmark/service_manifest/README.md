# Service manifest (SHA-256 of the measured service)

This folder gives the SHA-256 of each file of the authors' terminology router service as it was when the three routing measurements of 19 November 2026 were run (Supplementary S18.1 of the article). The service is not published; it is available from the corresponding author on request. With a copy of it, `shasum -a 256 -c SHA256SUMS` (or `sha256sum -c SHA256SUMS`), run in the service's root folder, checks each file against the list in `SHA256SUMS`.

## Which state is listed

- The 24 files of `services/terminology-router` at commit `5b313864f181e935fe8ae51094e80249989fe641` of the authors' working repository (21 September 2026). It was the last commit of the service's folder when the three measurements were run: the result file of each run (path A in isolation, arm 1 and arm 2), in `../per_case_results/` (tag `benchmark-2026-11-19`), records it as `router_commit`.
- The result files of path A in isolation and of arm 2 also record `router_src_status` as empty: the service's `src/` folder had no uncommitted change when they ran. The result file of arm 1 does not record it.
- Paths are relative to the service's root folder; sizes are in bytes.

## A change after the measurements

`README.md` was rewritten on 19 November 2026 at 10:19 (Lisbon time, WET), after the three runs, to describe what `src/terminology_router/router.py` does; no other file of the service changed. A copy of the service made after that change has this `README.md` (SHA-256 `df3714569249d42dcd80f4d11be4f4fb86487f16b16e52b8e29a27aec9e6d646`, 13577 bytes) and the other 23 files as listed.

## Files

| File | Bytes | SHA-256 |
|---|---:|---|
| `.dockerignore` | 2658 | `47c5c88a139dc465ca20b86c5d7eadb13b672a597655eac70d27bdd0c7048656` |
| `.gitignore` | 384 | `01b97f36cd0b78af7431e2aa7470d82507d8cdf603d48a2b28fb30761cfc1acc` |
| `Dockerfile` | 2801 | `685528595033d0ddb6837be852f1d969730bfa1309b85edfab71e1cf996aee03` |
| `README.md` | 11404 | `ac2c263bb93601611631fec1fec24eb8e45c2ce7898b0c9e2a02ff83101303a4` |
| `docker-compose.yml` | 3019 | `ebe7ff523c15602908a2979f1c1627daddcd4fb7a5625eaead3ab2142fe85f15` |
| `docs/ARCHITECTURE.md` | 28310 | `c129a052a0b68813d331cd24ca2f03a2bec8046c9725d4b0ec8b9922c544a5e3` |
| `docs/CI_EVIDENCE.md` | 22683 | `d9a0e2974f6db403ae5ae37cc9b932658e776f9f2294287d236ebd2e09248141` |
| `docs/DEPLOY_LOCAL.md` | 18483 | `6b3e0b9d599f76a520f65cd188d5603c7ff0bc5eeffdbfa3ed7b93ba1e471ff8` |
| `docs/decisions/0000-project-card.md` | 11384 | `ccd26f8c632a95a7c746a6224cbe8830c142ac2ba07fe32b4fe1fe632c40fd3a` |
| `openapi.yaml` | 4876 | `f87d0866d8f35e553ac1f6c663bb9ce8b094aede80deae58f876e1c0c58c9bb0` |
| `pyproject.toml` | 1062 | `0c6fb6302416b3e34b013fd7685437612d2fab4007385f0568c8c65bf00998cb` |
| `scripts/smoke_refusals.sh` | 4230 | `12c61a46ed3880a123e7c34742f65cd67448dd01e59633f097aa60e000a5bf69` |
| `src/terminology_router/__init__.py` | 702 | `832ef63d3bbf92e65012a5a3813fb337b2e28263bea90695a8649268985f45fe` |
| `src/terminology_router/api.py` | 3022 | `c9b807cd9bf78443f9401cea109cd32febbc52411b055cd28570e96b1e9fbcc4` |
| `src/terminology_router/models.py` | 11945 | `a1a6b9fcd276d4e9e32785eabb50bf0e1af084d4084e0f9b144b2452f24f798d` |
| `src/terminology_router/router.py` | 37747 | `3e0473e0549ba8afe5c23dfe9a5e7384c45985525fe4c6e1b004c6adf08cab53` |
| `src/terminology_router/stores.py` | 17509 | `1901e24ce5a25b53a23f7ebcf6cdc4b7aa7ca71f47eb4523559196560c286330` |
| `tests/test_doc_anchors.py` | 11832 | `0d76963bc680f5154e09fc8b0d1d9fe25153e257629f6684f2ce2492bd835c19` |
| `tests/test_fitness.py` | 15989 | `e2cea8555661d62e80330b3ca2863322c9a5f210dac5bb6ec6159ff57e7fb81e` |
| `tests/test_golden_paths.py` | 10852 | `3ce7849d98c263cac56c207a55702bafc717bd9a16f2f9afb4ba0e8d792e3a71` |
| `tests/test_invariants.py` | 17955 | `af74641866bd567e465b0a3904dc999db1b9be47c5b8317c4595e6cfed5906d4` |
| `tests/test_routes.py` | 5073 | `b75e18d11f85e0e3aa42937ad354f8576842950f21f1c2af81fa1d8a52797fd0` |
| `tests/test_rs11_cases.py` | 16541 | `fc5e7ef14e0490e797dfa271091c1bc50ffa4f5d6325e016f7525e947643cb18` |
| `tests/test_validate_path.py` | 15207 | `50201c7a15b7c5a2ef90edcee52444708b3810365978da6499a6b1ec25f73fb8` |
