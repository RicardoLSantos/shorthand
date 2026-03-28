// =============================================================================
// CFM Resolution 2.454/2026 — Phase 2: Profiles
// Created: 2026-03-28 T1 S15
// Reference: CFM Resolution 2.454/2026 (effective August 2026)
// Gaps covered: CFM-GAP-02, CFM-GAP-04, CFM-GAP-05
// =============================================================================

// =============================================================================
// PROFILE: Communication AI Disclosure (Art. 4 + Art. 9 + Art. 11)
// =============================================================================

Profile: CommunicationAIDisclosure
Parent: Communication
Id: communication-ai-disclosure
Title: "Communication AI Disclosure"
Description: """
Profile for documenting AI transparency disclosures to patients per CFM 2.454.
Art. 4 requires clear notification of AI use. Art. 9 requires patient rights information.
Art. 11 prohibits AI from communicating diagnoses directly — sender MUST be Practitioner.
"""

* ^status = #active
* ^experimental = false
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* status 1..1 MS
* category 1..1 MS
* category from AIDisclosureCategoryVS (extensible)
* subject 1..1 MS
* subject only Reference(Patient)
* sender 1..1 MS
* sender only Reference(Practitioner or PractitionerRole)
  * ^short = "Physician who communicates the disclosure (Art. 11: AI cannot communicate directly)"
* recipient 1..* MS
* recipient only Reference(Patient)
* sent 0..1 MS
* payload 1..* MS
  * ^short = "Disclosure content: AI system identification, risk level, patient rights"
* payload.content[x] only string or Reference
* reasonCode 0..* MS
  * ^short = "Regulatory basis for disclosure (e.g., CFM 2.454 Art. 4)"

// =============================================================================
// PROFILE: Organization AI Governance (Art. 8)
// =============================================================================

Profile: OrganizationAIGovernance
Parent: Organization
Id: organization-ai-governance
Title: "Organization AI Governance Commission"
Description: """
Profile for healthcare organizations with AI governance responsibilities per CFM 2.454 Art. 8.
Documents the AI Commission, its Technical Director, and governance policies.
"""

* ^status = #active
* ^experimental = false
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* identifier 0..* MS
* active 1..1 MS
* type 1..* MS
  * ^short = "Organization type — must include AI governance commission"
* name 1..1 MS
  * ^short = "Commission name (e.g., Comissão de IA em Saúde)"
* contact 1..* MS
  * ^short = "Technical Director and governance contacts"
* contact.name 0..1 MS
* contact.telecom 0..* MS
* contact.purpose 0..1 MS
  * ^short = "Contact purpose (e.g., AI governance, technical direction)"
* partOf 0..1 MS
* partOf only Reference(Organization)
  * ^short = "Parent healthcare organization"

// =============================================================================
// PROFILE: PractitionerRole AI Director (Art. 8)
// =============================================================================

Profile: PractitionerRoleAIDirector
Parent: PractitionerRole
Id: practitioner-role-ai-director
Title: "Practitioner Role AI Director"
Description: """
Profile for the AI Technical Director (Responsável Técnico de IA) per CFM 2.454 Art. 8.
Designates the physician responsible for AI governance within the institution.
"""

* ^status = #active
* ^experimental = false
* ^publisher = "Ricardo Lourenço dos Santos, FMUP"

* active 1..1 MS
* period 0..1 MS
  * ^short = "Appointment period for AI Director role"
* practitioner 1..1 MS
* practitioner only Reference(Practitioner)
  * ^short = "The physician serving as AI Technical Director"
* organization 1..1 MS
* organization only Reference(Organization)
  * ^short = "Organization with AI governance responsibility"
* code 1..* MS
  * ^short = "Role code — AI Technical Director / Responsável Técnico de IA"
* specialty 0..* MS
  * ^short = "Specialties (e.g., digital health, AI governance, informatics)"
