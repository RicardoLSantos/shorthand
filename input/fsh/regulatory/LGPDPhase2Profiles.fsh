// =============================================================================
// LGPD PHASE 2 — Organization, DPO, and Data Subject Request Profiles
// =============================================================================
// Date: 2026-03-15
// Purpose: LGPD Art. 5 (controlador, encarregado), Art. 18 (data subject rights),
//          Art. 37-38 (DPO designation and responsibilities)
// Context: PLAN_REGULATORY_LGPD_20260305.md — Phase 2
// =============================================================================

// ============================================================================
// Profile: OrganizationDataController
// LGPD Art. 5-VI: "controlador" — natural or legal person responsible for
// decisions regarding the processing of personal data.
// ============================================================================
Profile: OrganizationDataController
Parent: Organization
Id: organization-data-controller
Title: "LGPD Data Controller Organization"
Description: """
Organization profile for the LGPD data controller (controlador, Art. 5-VI).

The controller is responsible for decisions regarding the processing of personal
data. Under LGPD, the controller must:
- Designate a Data Protection Officer (Art. 37)
- Maintain records of processing activities (Art. 37, §1)
- Implement security measures (Art. 46)
- Notify ANPD and data subjects of security incidents (Art. 48)
- Respond to data subject requests within 15 days (Art. 18, §5)
"""
* type 1..1 MS
* type = http://terminology.hl7.org/CodeSystem/organization-type#prov
* name 1..1 MS
* identifier 1..* MS
* identifier ^short = "CNPJ or equivalent institutional identifier"
* contact 1..* MS
* contact ^short = "DPO contact information (Art. 41)"
* extension contains
    LGPDRegistrationNumber named lgpdRegistration 0..1 MS and
    DataProtectionOfficerReference named dpoReference 0..1 MS

// ============================================================================
// Profile: PractitionerRoleDPO
// LGPD Art. 37-38: "encarregado" (Data Protection Officer)
// ============================================================================
Profile: PractitionerRoleDPO
Parent: PractitionerRole
Id: practitioner-role-dpo
Title: "LGPD Data Protection Officer (DPO)"
Description: """
PractitionerRole profile for the LGPD Data Protection Officer (encarregado, Art. 37).

The DPO is responsible for (Art. 41):
- Accepting complaints and communications from data subjects
- Receiving communications from ANPD and adopting measures
- Advising the organization's employees on data protection practices
- Performing other duties determined by the controller or in supplementary regulations

The DPO's identity and contact information must be publicly available (Art. 41, §1).
"""
* practitioner 1..1 MS
* practitioner ^short = "The individual designated as DPO"
* organization 1..1 MS
* organization ^short = "The controller organization"
* code 1..1 MS
* code from DPORoleVS (required)
* specialty 0..* MS
* specialty ^short = "Data protection specializations (e.g., health data, AI systems)"
* telecom 1..* MS
* telecom ^short = "Public contact for data subject requests (Art. 41, §1)"
* period 0..1 MS
* period ^short = "Period of DPO designation"

// ============================================================================
// Profile: TaskDataSubjectRequest
// LGPD Art. 18: Data subject rights requests
// ============================================================================
Profile: TaskDataSubjectRequest
Parent: Task
Id: task-data-subject-request
Title: "LGPD Data Subject Rights Request"
Description: """
Task profile for managing LGPD data subject rights requests (Art. 18).

Supports all 8 data subject rights:
- (I) Confirmation of processing existence
- (II) Data access
- (III) Correction of incomplete/inaccurate/outdated data
- (IV) Anonymization, blocking, or deletion of unnecessary data
- (V) Data portability to another service provider
- (VI) Information about entities with which data was shared
- (VII) Information about consent denial consequences
- (VIII) Consent revocation

The controller must respond within 15 days (Art. 18, §5).
"""
* status MS
* status from DataSubjectRequestStatusVS (required)
* intent = #order
* intent MS
* code 1..1 MS
* code from LGPDDataSubjectRightVS (required)
* code ^short = "Which Art. 18 right is being exercised"
* for 1..1 MS
* for only Reference(Patient)
* for ^short = "The data subject (titular) making the request"
* requester 0..1 MS
* requester ^short = "Who submitted the request (may be patient or representative)"
* owner 1..1 MS
* owner only Reference(Organization)
* owner ^short = "The controller organization responsible for response"
* authoredOn 1..1 MS
* authoredOn ^short = "Date request was submitted"
* lastModified 0..1 MS
* restriction.period 0..1 MS
* restriction.period ^short = "Response deadline (15 days per Art. 18, §5)"
* output 0..* MS
* output ^short = "Result of the request (data bundle, confirmation, etc.)"
* note 0..* MS
* note ^short = "Communication history regarding the request"
* extension contains DataAnonymizationStatus named anonymizationStatus 0..1 MS

// ============================================================================
// Extensions
// ============================================================================
Extension: LGPDRegistrationNumber
Id: lgpd-registration-number
Title: "LGPD Registration Number"
Description: "Registration number with ANPD (Autoridade Nacional de Proteção de Dados), when applicable."
* value[x] only string

Extension: DataProtectionOfficerReference
Id: data-protection-officer-reference
Title: "Data Protection Officer Reference"
Description: "Reference to the designated DPO (PractitionerRoleDPO) for this organization."
* value[x] only Reference(PractitionerRole)

// ============================================================================
// ValueSets
// ============================================================================
ValueSet: DPORoleVS
Id: dpo-role-vs
Title: "DPO Role"
Description: "Role codes for LGPD Data Protection Officer (encarregado)."
* ^experimental = false
* ^status = #active
* AppLogicCS#lgpd-dpo "Data Protection Officer (Encarregado)"
* AppLogicCS#lgpd-dpo-deputy "Deputy Data Protection Officer"

ValueSet: LGPDDataSubjectRightVS
Id: lgpd-data-subject-right-vs
Title: "LGPD Data Subject Right"
Description: """
Data subject rights under LGPD Art. 18. Each code corresponds to a specific
right that the data subject (titular) may exercise.
"""
* ^experimental = false
* ^status = #active
* AppLogicCS#lgpd-right-confirmation "Right to Confirmation (Art. 18-I)"
* AppLogicCS#lgpd-right-access "Right to Access (Art. 18-II)"
* AppLogicCS#lgpd-right-correction "Right to Correction (Art. 18-III)"
* AppLogicCS#lgpd-right-anonymization "Right to Anonymization/Deletion (Art. 18-IV)"
* AppLogicCS#lgpd-right-portability "Right to Portability (Art. 18-V)"
* AppLogicCS#lgpd-right-sharing-info "Right to Sharing Information (Art. 18-VI)"
* AppLogicCS#lgpd-right-consent-info "Right to Consent Information (Art. 18-VII)"
* AppLogicCS#lgpd-right-revocation "Right to Consent Revocation (Art. 18-VIII)"
* AppLogicCS#lgpd-right-automated-review "Right to Automated Decision Review (Art. 20)"

ValueSet: DataSubjectRequestStatusVS
Id: data-subject-request-status-vs
Title: "Data Subject Request Status"
Description: "Status codes for LGPD data subject rights request processing."
* ^experimental = false
* ^status = #active
* http://hl7.org/fhir/task-status#requested "Requested"
* http://hl7.org/fhir/task-status#accepted "Accepted"
* http://hl7.org/fhir/task-status#in-progress "In Progress"
* http://hl7.org/fhir/task-status#completed "Completed"
* http://hl7.org/fhir/task-status#rejected "Rejected"
