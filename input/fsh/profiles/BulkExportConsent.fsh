// ============================================================================
// Bulk Export Consent Profile (Research-Specific)
// ============================================================================
// Date: 2026-05-07 (T2 S20 Caminho C — IG v0.3.0 sprint partial)
// Purpose: Profile Consent resource for research-specific bulk export
//          operations. Distinguishes patient consent for clinical care from
//          patient consent for research bulk export (which has different
//          regulatory bases under GDPR Art. 9.2.j research exemption,
//          LGPD Art. 11.II.c research exemption, HIPAA §164.512(i) research).
// Companion: Complementary to MultiJurisdictionalConsent (general healthcare
//            consent) — both profiles co-exist; BulkExportConsent is invoked
//            specifically when BulkExportGroup is created.
// ============================================================================
// NOTE (T2 S20): FSH written without IG build validation due to local disk
//                constraint. Pending validation: build via _genonce.sh when
//                disk recovery (Pitfall #65, ≥5GB free) achieved.
// ============================================================================

Profile: BulkExportConsent
Parent: MultiJurisdictionalConsent
Id: bulk-export-consent
Title: "Bulk Export Research Consent Profile"
Description: """
Profile of Consent specific to bulk FHIR export operations for research,
public health surveillance, or quality improvement purposes. Inherits
multi-jurisdictional policy structure from MultiJurisdictionalConsent
(GDPR/HIPAA/LGPD policies) but adds:

  - Mandatory research-purpose declaration
  - Mandatory dataPeriod specification (which data temporal range covered)
  - Mandatory regulatory basis extension (which legal article authorizes)
  - Stricter purposeOfUse binding (research-specific value set)
  - Mandatory link to BulkExportGroup (cohort definition)
"""

* ^experimental = false

// Override status — only active consents can authorize export
* status MS
* status = #active (exactly)

// Override scope — research-specific
* scope MS
* scope = http://terminology.hl7.org/CodeSystem/consentscope#research (exactly)
  * ^short = "Always research scope for this profile"

// Override category — research consent category
* category 1..* MS
* category = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH (exactly)
  * ^short = "Always healthcare research category"

// Patient — required (must be a patient consenting to research)
* patient 1..1 MS

// dateTime — when consent was given
* dateTime 1..1 MS

// Performer — typically the patient or legal guardian
* performer 1..* MS

// Organization — research org / sponsor
* organization 1..* MS
  * ^short = "Sponsoring research organization or IRB"

// Source — consent form (PDF/document) reference
* sourceAttachment 0..1 MS
  * ^short = "Reference to consent form attachment (PDF, scanned)"

// Inherit multi-jurisdictional policy slicing from parent
* policy 1..* MS

// Provision — research-specific authorizations
* provision 1..1 MS

// Type — required permit/deny
* provision.type 1..1 MS
* provision.type = #permit (exactly)
  * ^short = "Bulk export consent is always permit (deny would be no consent)"

// Period — temporal validity of consent
* provision.period 1..1 MS
  * ^short = "Period during which consent is valid (typically research project duration)"

// Actor — research personnel + sponsoring org
// (provision.actor.role binding inherited from MultiJurisdictionalConsent parent
// profile; do not re-bind here — IG Publisher 2.1.2 has resolution issues when
// the child profile restates the same canonical from hl7.terminology.r4 package).
* provision.actor 1..* MS
* provision.actor.role 1..1 MS
* provision.actor.reference 1..1 MS

// Action — what operations are permitted
* provision.action 1..* MS
* provision.action from BulkExportConsentActionVS (required)
  * ^short = "Restricted to access/disclose actions for export"

// Security label — sensitivity classification
* provision.securityLabel 1..* MS
* provision.securityLabel from http://terminology.hl7.org/ValueSet/v3-Confidentiality (required)

// Purpose — REQUIRED research-specific purpose
* provision.purpose 1..* MS
* provision.purpose from BulkExportPurposeVS (required)
  * ^short = "Research-specific purpose codes (mandatory for this profile)"

// dataPeriod — REQUIRED for export consent
* provision.dataPeriod 1..1 MS
  * ^short = "Temporal range of data covered by this consent (e.g., 2024-2026 observations)"

// Resource — what FHIR resources are exportable
* provision.class 1..* MS
* provision.class.system = "http://hl7.org/fhir/resource-types"
  * ^short = "Bound to FHIR resource types (Observation, Condition, etc.)"

// Code — specific data subset codes
* provision.code 0..* MS
  * ^short = "Specific codes within resource types (e.g., specific LOINC codes only)"

// Required extensions (in addition to inherited)
* extension contains
    BulkExportGroupRef named groupRef 1..1 MS and
    BulkExportProjectMetadata named projectMetadata 1..1 MS

// ============================================================================
// Extension: BulkExportGroupRef
// ============================================================================

Extension: BulkExportGroupRef
Id: bulk-export-group-ref
Title: "Bulk Export Group Reference Extension"
Description: """
Reference from BulkExportConsent to the BulkExportGroup cohort that this
consent authorizes. Bidirectional with BulkExportConsentRef extension on
BulkExportGroup (forming consent-cohort linked pair).
"""
* ^context.type = #element
* ^context.expression = "Consent"

* value[x] only Reference
* valueReference 1..1 MS
* valueReference only Reference(Group)

// ============================================================================
// Extension: BulkExportProjectMetadata
// ============================================================================

Extension: BulkExportProjectMetadata
Id: bulk-export-project-metadata
Title: "Bulk Export Research Project Metadata Extension"
Description: """
Metadata about the research project sponsoring the bulk export consent.
Captures IRB approval, project ID, principal investigator, and expected
data retention period beyond the consent's provision.period.
"""
* ^context.type = #element
* ^context.expression = "Consent"

* extension contains
    irbApproval 1..1 MS and
    projectId 1..1 MS and
    principalInvestigator 1..1 MS and
    dataRetentionPeriod 1..1 MS

* extension[irbApproval].value[x] only string
* extension[irbApproval].valueString ^short = "IRB approval reference number"

* extension[projectId].value[x] only Identifier
* extension[projectId].valueIdentifier ^short = "Research project unique identifier"

* extension[principalInvestigator].value[x] only Reference
* extension[principalInvestigator].valueReference only Reference(Practitioner or PractitionerRole)
* extension[principalInvestigator].valueReference ^short = "PI of the research project"

* extension[dataRetentionPeriod].value[x] only Period
* extension[dataRetentionPeriod].valuePeriod ^short = "Data retention period (typically extends beyond consent period)"

// ============================================================================
// ValueSet: Bulk Export Consent Actions
// ============================================================================

ValueSet: BulkExportConsentActionVS
Id: bulk-export-consent-action-vs
Title: "Bulk Export Consent Actions"
Description: "Restricted set of actions authorized by BulkExportConsent"
* ^status = #active
* ^experimental = false

* http://terminology.hl7.org/CodeSystem/consentaction#access "Access"
* http://terminology.hl7.org/CodeSystem/consentaction#disclose "Disclose"

// Note: 'collect', 'use', 'correct' are NOT included — bulk export is
// strictly access/disclose; modifications and corrections require separate
// consent under MultiJurisdictionalConsent profile.

// ============================================================================
// ValueSet: Bulk Export Purposes
// ============================================================================

ValueSet: BulkExportPurposeVS
Id: bulk-export-purpose-vs
Title: "Bulk Export Research Purposes"
Description: """
Research-specific purpose codes authorized for bulk FHIR export under
GDPR Art. 9.2.j (research exemption), LGPD Art. 11.II.c (research),
HIPAA §164.512(i) (research). Excludes general treatment/payment/operations
purposes (which fall under MultiJurisdictionalConsent base profile).
"""
* ^status = #active
* ^experimental = false

* http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#CLINTRCH "clinical trial research"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#PUBHLTH "public health"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#HQUALIMP "healthcare quality improvement"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#PATRQT "patient requested research participation"

// ============================================================================
// Example — Bulk Export Consent for HRV Research
// ============================================================================

Instance: BulkExportConsentHRVResearchExample
InstanceOf: BulkExportConsent
Title: "Example: Bulk Export Consent for HRV Decline Research Cohort"
Description: "Example consent authorizing bulk export of patient observations for HRV decline 90-day research cohort"
Usage: #example

* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#research
* category[0] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH
* patient.reference = "Patient/example-patient-001"
* dateTime = "2026-04-15T10:00:00Z"
* performer[0].reference = "Patient/example-patient-001"
* organization[0].reference = "Organization/research-org-fmup"

// Inherited multi-jurisdictional policies
* policy[gdpr].authority = "https://eur-lex.europa.eu/eli/reg/2016/679/oj"
* policy[gdpr].uri = "https://eur-lex.europa.eu/eli/reg/2016/679/art_9/par_2/pnt_j"
* policy[lgpd].authority = "http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm"
* policy[lgpd].uri = "http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm#art11"

// Provision — research bulk export
* provision.type = #permit
* provision.period.start = "2026-04-15"
* provision.period.end = "2027-04-15"
* provision.actor[0].role = http://terminology.hl7.org/CodeSystem/extra-security-role-type#humanuser "human user"
* provision.actor[0].reference.reference = "Practitioner/researcher-pi-001"
* provision.action[0] = http://terminology.hl7.org/CodeSystem/consentaction#access
* provision.action[1] = http://terminology.hl7.org/CodeSystem/consentaction#disclose
* provision.securityLabel[0] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#R "restricted"
* provision.purpose[0] = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"
* provision.dataPeriod.start = "2024-01-01"
* provision.dataPeriod.end = "2026-04-15"
* provision.class[0].system = "http://hl7.org/fhir/resource-types"
* provision.class[0].code = #Observation

// Extensions
* extension[groupRef].valueReference.reference = "Group/BulkExportGroupHRVDeclineExample"
* extension[projectMetadata].extension[irbApproval].valueString = "FMUP-IRB-2026-0042"
* extension[projectMetadata].extension[projectId].valueIdentifier.system = "https://2rdoc.pt/research-projects"
* extension[projectMetadata].extension[projectId].valueIdentifier.value = "HRV-DECLINE-90D-2026Q2"
* extension[projectMetadata].extension[principalInvestigator].valueReference.reference = "Practitioner/researcher-pi-001"
* extension[projectMetadata].extension[dataRetentionPeriod].valuePeriod.start = "2026-04-15"
* extension[projectMetadata].extension[dataRetentionPeriod].valuePeriod.end = "2031-04-15"
