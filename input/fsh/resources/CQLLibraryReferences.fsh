// ============================================================================
// CQL Library reference declarations (T1 S46 — G1 gate Fase 3)
// ============================================================================
// The IG's AI ClinicalImpression examples reference CQL decision logic via
// `urn:cql:library:` URIs in ClinicalImpression.protocol. These thin Library
// resources register those canonical URLs so the references resolve during
// validation, while documenting that the executable CQL is maintained
// EXTERNALLY in the HEADS-ETL repository (etl_poc/cql/) — NOT embedded or
// executed by this IG. This is the same adopted-pattern-not-embedded-engine
// stance used for GDL (see gdl-integration.html) and recorded in
// implementation-scope-and-roadmap.html (CQL libraries — decision recorded).
//
// Note: `url` embeds the version (`:v1.2`) to match the protocol[0] reference
// string exactly; no separate `version` element (which would append `|1.2`).
// Pitfall #33: no fabricated CQL content — these are documentation pointers.
// ============================================================================

Instance: LibraryCVR003HRVRisk
InstanceOf: Library
Usage: #definition
Title: "CVR-003 — HRV/Inflammation Cardiovascular Risk Logic (v1.2)"
Description: """
Reference declaration for the CQL logic library `urn:cql:library:CVR-003:v1.2`,
referenced by AI ClinicalImpression examples (ClinicalImpressionComplianceRT,
ClinicalImpressionHRVRiskExample). The executable CQL is maintained externally
in the HEADS-ETL repository (etl_poc/cql/) and is NOT embedded or executed by
this IG — consistent with the CDS Hooks execution model (decision logic lives
server-side; the IG references it as a documentation pointer).
"""
* url = "urn:cql:library:CVR-003:v1.2"
* name = "CVR003HRVRisk"
* status = #active
* experimental = false
* date = "2026-05-27"
* publisher = "Ricardo Lourenço dos Santos"
* type = http://terminology.hl7.org/CodeSystem/library-type#logic-library

Instance: LibraryMET002MetabolicOverride
InstanceOf: Library
Usage: #definition
Title: "MET-002 — Metabolic Override Workflow Logic (v1.0)"
Description: """
Reference declaration for the CQL logic library `urn:cql:library:MET-002:v1.0`,
referenced by the AI override workflow example (ClinicalImpressionOriginalWF).
The executable CQL is maintained externally in the HEADS-ETL repository
(etl_poc/cql/) and is NOT embedded or executed by this IG —
adopted-pattern-not-embedded-engine.
"""
* url = "urn:cql:library:MET-002:v1.0"
* name = "MET002MetabolicOverride"
* status = #active
* experimental = false
* date = "2026-05-27"
* publisher = "Ricardo Lourenço dos Santos"
* type = http://terminology.hl7.org/CodeSystem/library-type#logic-library
