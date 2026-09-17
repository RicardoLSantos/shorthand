# Known Issues

This page states what the current build reports, what is deliberately suppressed and why, what the IG knowingly leaves open, and what was resolved in earlier releases. Numbers below are taken from the release build's `qa.txt`; the same build can be reproduced with the commands in the README's Quick Start.

## Build status — v0.5.0 (2026-09-16)

| Metric | Value |
|---|---|
| Errors | **0** (zero since v0.4.1, 2026-06-01) |
| Warnings | **223** — a single advisory class, see below |
| Information | 13,221 |
| Broken links | 0 |
| Toolchain | IG Publisher 2.2.10 · SUSHI 3.18.1 · FHIR 4.0.1 (the CI builds with the latest IG Publisher release) |

## The 223 warnings: one advisory class, not suppressed

Every one of the 223 warnings is the same message: *"The resource … should have an OID assigned to cater for possible use with OID based terminology systems"* — one per CodeSystem (19) and one per ValueSet (204), which is why the count equals the number of terminology resources. OIDs are optional identifiers in FHIR; assigning 223 of them requires an OID arc registered to the publisher, which is a governance decision outside a release. The warning is therefore left visible rather than suppressed, and the count is expected to move only when terminology resources are added or removed.

## Suppressed warnings (`input/ignoreWarnings.txt`, 169 non-comment lines — the first is the file header, so 168 rules: 99 written against the messages of the local builds (twelve of them already in English) and 70 in the block of English twins for the CI runner)

Suppressions are reserved for messages the IG Publisher emits about things that are correct by design; genuine defects are fixed at the FSH source. Each block in the file carries its justification. Summary by block:

| Block | What is suppressed | Why it is correct by design |
|---|---|---|
| Upstream IPS 2.0.x references | profile/type resolution, `pkp-2` hyperlink and reference messages inherited from the IPS dependency | historical (see *Resolved*); the entries are kept so that older builds remain reproducible |
| Example-instance OIDs | "OID not found" for the national OIDs used in example identifiers | the OIDs are real national identifiers used on purpose in examples; replacing them would reintroduce four "resource not found" errors |
| Cross-paradigm ConceptMaps (openEHR, OMOP) | "no definition found for URL" for archetype identifiers and Athena concept targets; group source/target scope messages | openEHR archetype identifiers and OMOP concept identifiers are not FHIR CodeSystems; these maps document element-path and concept correspondences |
| UCUM annotations | annotated units such as `{score}`, `{rpm}`, `{spm}`, `{pack-years}`, `{MET-min}` | annotations are the UCUM-recommended way to carry unitless or composite lifestyle metrics |
| Vendor API CodeSystems | reverse-DNS identifiers and REST endpoints used as CodeSystem URIs; "not-present" content of vendor stubs | vendor APIs are not FHIR terminology servers; the stubs exist so that vendor codes can be mapped, not expanded |
| Legal and regulatory URLs | ANPD, CFM and other legal-framework URLs referenced by regulatory profiles | these are citations of legal texts, not FHIR endpoints |
| SMART OAuth, pipeline and namespace URIs | endpoint URIs in capability statements, error-reporting endpoints, `identifier.system` namespaces | endpoints and namespaces are identifiers, not resolvable definitions |
| CQL expression language | `text/cql-identifier` not supported for validation | valid CQL media type; the libraries are external documentation pointers (see *Open limitations*) |
| ICD-10-CM on the terminology server | incomplete content on `tx.fhir.org` | external-system limitation; ICD-10-CM codes are used as references only |
| Observation performer best practice | "no performer" advisories on wearable observations | the data source is a device, recorded in `device`, not a practitioner |
| ObservationInterpretation version mismatch | HL7 Terminology v7.1.0 packages v4.0.0 while values reference v3.0.0 | upstream inconsistency in the terminology package |
| Advisories accepted as-is | inactive SNOMED concepts used intentionally in examples; a `Reference(PractitionerRole)` extension type; fixed-value CodeableConcepts in consent examples; pinned dependency versions; extensions demonstrated only inside composite bundles; a batch-bundle `PUT`-by-id resolution heuristic | each is an intentional modelling or example choice, documented in the file next to the suppression |

## Continuous integration and the IG Publisher version

The release builds are made locally with the IG Publisher version recorded in the changelog (2.2.10 for 0.5.0 and 0.5.1); the CI workflow downloads the latest IG Publisher release at build time, so it can run a newer validator than the release did. Measured on 2026-09-17: the CI build of v0.5.0 (and of the commits that followed it) ran IG Publisher **2.3.4** and **failed** its error gate with 4 errors, all `MEASURE_M_CRITERIA_CQL_NO_LIB` on the `MindfulnessProgressReport` Measure — its four criteria were declared as `text/cql-identifier` without a CQL Library, which 2.2.10 only warned about. 0.5.1 corrects the Measure (the criteria are FHIRPath and are now declared as such; the weekly stratifier expression, which was not valid FHIRPath, is now the observation's effective date) — reproduced with the standalone FHIR validator 6.10.4, the same core as 2.3.4: 4 errors → 0. The 2.3.4 run also reported 361 warnings instead of 223: the runner emits its messages in English and the suppressions were written in the locale of the local builds, so 0.5.1 adds the English twin of every suppression the runner reported (68 lines, full text copied from the run). Every one of the 138 non-OID warnings of that run has a suppression in the local locale, so each now has its English twin (68 lines, written as the whole message: the publisher matches a suppression only against the full text) and none is expected to remain visible on the runner; the 223 OID advisories stay visible by design. The local publisher is not upgraded on a release day; an upgrade to 2.3.4 with a trial build is planned for the next release.

## Open limitations (known, not defects of the build)

- **No hosted site yet.** The canonical URL `https://2rdoc.pt/ig/ios-lifestyle-medicine` is the IG's identifier; the rendered site is not deployed there. The versioned GitHub releases (`package.tgz`) are the distribution; see the [roadmap](implementation-scope-and-roadmap.html).
- **CQL libraries are external and not executed.** `ClinicalImpression.protocol` references `urn:cql:library:` URIs registered as thin `Library` resources; no CQL engine runs in this project. Likewise the GDL2 bridge is documented without an engine.
- **One profile has no standalone example, by design.** `ConsumerECGObservation` is the abstract parent of the ECG profiles (each of its four child profiles has one). `CarePlanLifestyleMedicine`, instantiated only inline inside the compliance and workflow bundles until 0.5.0, has a standalone example since 0.5.1.
- **Several bindings are annotated as pending review in the FSH** — two components of `ReproductiveObservation`, a distance→steps element in the vendor-to-LOINC ConceptMap, and three ConceptMap elements declared unmatched pending a replacement (two in the nutrition map, one in the social-history map); each carries an inline note rather than a silent approximation. See the [terminology verification page](terminology-verification.html).
- **ICD-11 codes are republished under the IG namespace by design** (a complete, verified fragment) so that the build never depends on the availability of an external terminology server; the ledger records the owner-source verification of each code.
- **An external terminology router is specification only.** The interfaces, extensions and CodeSystems that would carry an agent's outputs are specified; no implementation is distributed or required by this IG.

## Resolved in earlier releases

| Issue | Releases affected | Resolution |
|---|---|---|
| 23 errors inherited from the IPS 2.0.0 dependency (`note\|5.3.0-ballot-tc1` referenced an unpublished extensions package) | v0.2.x – v0.3.x (March–May 2026) | resolved upstream when HL7 published `hl7.fhir.uv.extensions.r4` 5.3.0; the IG's suppressions for that era remain for reproducibility |
| 21 errors from openEHR/OMOP ConceptMaps declaring non-FHIR systems as `group.source`/`group.target` | v0.2.0 (fixed in March 2026, before v0.2.1) | structural maps now carry the identifiers as documented targets without CodeSystem semantics |
| 5 residual errors (Consent terminology resolved locally; two thin CQL `Library` resources for unresolved protocol references) | v0.4.1 (June 2026) | fixed at source; errors have been 0 since |
| 34-code ICD-11 fragment in which a substantial share of the codes were absent from the WHO MMS linearization or carried another concept's title | v0.2.0 – v0.4.8 (twelve releases) | rebuilt in v0.5.0 as a 46-concept fragment verified against the WHO linearization and `tx.fhir.org` (see the 0.5.0 change log) |
| Bindings pointing at valid codes with the wrong meaning (nutrition, social-history, sleep-quality value sets) | up to v0.4.8 | corrected or retired in v0.5.0 with the terminology ledger as the record |

## Reporting

Open an issue on the [GitHub repository](https://github.com/RicardoLSantos/shorthand/issues). Please quote the IG version and the exact `qa.txt` line.
