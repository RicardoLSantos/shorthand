// ============================================================================
// Bulk FHIR Group Profile (Cohort Export)
// ============================================================================
// Date: 2026-05-07 (T2 S20 Caminho C — IG v0.3.0 sprint partial)
// Purpose: Profile Group resource for cohort definition + Bulk FHIR Export
//          ($export operation per Bulk Data Access IG). Enables research
//          and population-health workflows over lifestyle medicine cohorts.
// Reference: http://hl7.org/fhir/uv/bulkdata/STU2/
// Companion: Requires authorization via SMARTOnFHIRConformance.fsh
//            (system/Group.rs scope) + audit via AuditEventDataAccess.fsh
//            (Export-type events) + consent via BulkExportConsent.fsh.
// ============================================================================
// NOTE (T2 S20): FSH written without IG build validation due to local disk
//                constraint. Pending validation: build via _genonce.sh when
//                disk recovery (Pitfall #65, ≥5GB free) achieved.
// ============================================================================

Profile: BulkExportGroup
Parent: Group
Id: bulk-export-group
Title: "Bulk FHIR Export Group Profile"
Description: """
Profile for Group resources defining cohorts eligible for Bulk FHIR Data
Access $export operation. Cohorts may be defined by lifestyle medicine
domains (e.g., 'patients with HRV decline trend last 90 days', 'cohort
with WHO PA threshold non-adherence'), age band, or arbitrary clinical
criteria. The $export operation extracts all member observations across
the 11 lifestyle medicine domains for research/quality-improvement use.
"""

* ^experimental = false

// Type — Person (always — cohorts are patient cohorts in this IG)
* type 1..1 MS
* type = #person

// Actual — true (concrete enumerable cohort) vs false (description only)
* actual 1..1 MS
  * ^short = "True if member list is enumerated; false if criteria-based (uses characteristic only)"

// Active — must be true to be exportable
* active 1..1 MS
* active = true (exactly)
  * ^short = "Inactive groups MUST NOT be exported"

// Code — clinical/research category for the cohort
* code 1..1 MS
* code from BulkExportGroupCategoryVS (extensible)
  * ^short = "Clinical category of the cohort (research, QI, surveillance)"

// Name — human-readable cohort label
* name 1..1 MS
  * ^short = "Cohort label (e.g., 'HRV-decline-90d-2026Q2-cohort-001')"

// Quantity — total members
* quantity 0..1 MS
  * ^short = "Cardinality of the cohort at definition time"

// Managing entity — research org / IRB sponsor
* managingEntity 0..1 MS
  * ^short = "Research org, IRB, or QI committee sponsoring the cohort"

// Characteristic slicing — define cohort criteria
// IG Publisher requires every slice with discriminator type=#pattern to have
// a fixed value, pattern, or required binding on the discriminator path.
// Lifestyle-metric criteria use any LOINC code from LifestyleMetricCohortCriteriaVS
// (extensible), so they are represented as UN-SLICED characteristic entries
// rather than a dedicated slice (which would have no fixed pattern).
// The fixed-code slices ageRange (LOINC 30525-0) and clinicalCondition
// (LOINC 11450-4) remain explicit because each has a unique discriminating
// LOINC code.
* characteristic ^slicing.discriminator.type = #pattern
* characteristic ^slicing.discriminator.path = "code"
* characteristic ^slicing.rules = #open
* characteristic ^slicing.description = "Cohort criteria slices for demographic (ageRange) and clinical (clinicalCondition) constraints; lifestyle-metric criteria use un-sliced characteristic with LOINC binding."
* characteristic contains
    ageRange 0..1 MS and
    clinicalCondition 0..* MS

// Base characteristic constraints for un-sliced lifestyle-metric criteria
// (e.g., HRV-decline pattern, sleep duration threshold, step-count threshold).
// Authors SHOULD use LOINC codes from LifestyleMetricCohortCriteriaVS for code values.
//
// NOTE: VS binding on characteristic.code is NOT declared at base level.
// IG Publisher 2.1.2 propagates the binding metadata to characteristic.value[x],
// triggering a spurious "no bindable types [Range]" error when slices (ageRange)
// use valueRange. The VS remains documented (see LifestyleMetricCohortCriteriaVS)
// and authors should follow it; explicit FHIR binding deferred to v0.4.0 after
// IG Publisher upgrade resolves the propagation behaviour.
//
// Slice fixed codes (ageRange→LOINC#30525-0, clinicalCondition→LOINC#11450-4)
// are independently enforced. Cardinality on value[x] is inherited from FHIR R4
// Group.characteristic.value[x] (1..1) without re-declaration.
* characteristic.code 1..1 MS
* characteristic.exclude 1..1 MS
* characteristic.period 0..1 MS
  * ^short = "Period over which the criterion applies (e.g., last 90 days for HRV-decline)"

// Age range criterion
* characteristic[ageRange].code 1..1 MS
* characteristic[ageRange].code = http://loinc.org#30525-0 "Age"
// NOTE (T1 S43, 2026-05-23): value[x] intentionally NOT narrowed to Range here.
// FHIR R4 base Group.characteristic.value[x] carries an example binding
// (GroupCharacteristicValue). Narrowing this slice to only Range inherits that
// binding onto a non-bindable type → IG Publisher error "no bindable types [Range]".
// Keeping the base value[x] choice (which includes bindable CodeableConcept) keeps
// the inherited example binding valid. ageRange semantics are enforced by the fixed
// LOINC#30525-0 code + demonstrated via valueRange in the example below.
* characteristic[ageRange].exclude 1..1 MS

// Clinical condition criterion
* characteristic[clinicalCondition].code 1..1 MS
* characteristic[clinicalCondition].code = http://loinc.org#11450-4 "Problem list - Reported"
* characteristic[clinicalCondition].valueCodeableConcept 1..1 MS
* characteristic[clinicalCondition].exclude 1..1 MS

// Member references — for actual=true cohorts
* member 0..* MS
  * ^short = "Enumerated members (for actual=true cohorts). Empty for criteria-based cohorts."
* member.entity 1..1 MS
* member.entity only Reference(Patient)
* member.period 0..1 MS
  * ^short = "Period of cohort membership (e.g., entry/exit dates)"
* member.inactive 0..1 MS
  * ^short = "True if member entered then exited the cohort"

// Required extension — consent reference
* extension contains
    BulkExportConsentRef named consentRef 1..* MS
* extension[consentRef] ^short = "References to BulkExportConsent resources covering all members"

// ============================================================================
// Extension: BulkExportConsentRef
// ============================================================================

Extension: BulkExportConsentRef
Id: bulk-export-consent-ref
Title: "Bulk Export Consent Reference Extension"
Description: """
Extension referencing BulkExportConsent resources that cover the cohort's
members for the specific $export operation purpose. Required by the
BulkExportGroup profile to enforce consent provenance before export.
"""
* ^context.type = #element
* ^context.expression = "Group"

* value[x] only Reference
* valueReference 1..1 MS
* valueReference only Reference(Consent)
  * ^short = "Reference to BulkExportConsent profile instance"

// ============================================================================
// ValueSet: Bulk Export Group Categories
// ============================================================================

ValueSet: BulkExportGroupCategoryVS
Id: bulk-export-group-category-vs
Title: "Bulk Export Group Categories"
Description: "Category codes for Bulk FHIR Export Group cohort intent"
* ^status = #active
* ^experimental = false

// T2 S35 (2026-05-28 11:15 WEST) — opcional fix dos 2 displays canonical
// per v3-ActReason HL7 (resolve 2 INFORMATION entries em qa.txt linha 14017-14018).
// Pitfall #33 sub-rule: display deve match canonical (`en` / `en-US` per VS validator).
* http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#PUBHLTH "public health"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#HQUALIMP "health quality improvement"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#HSYSADMIN "health system administration"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#PATRQT "patient requested"

// ============================================================================
// ValueSet: Lifestyle Metric Cohort Criteria
// ============================================================================

ValueSet: LifestyleMetricCohortCriteriaVS
Id: lifestyle-metric-cohort-criteria-vs
Title: "Lifestyle Metric Cohort Criteria"
Description: """
LOINC + custom codes used as cohort selection criteria over lifestyle
medicine wearable observations. Reuses canonical LOINC codes verified
in IG terminology gap analysis (see HeartRateVariabilityCodeSystem.fsh).
"""
* ^status = #active
* ^experimental = false

// HRV criteria
* http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"
* http://loinc.org#76643-6 "R-R interval.standard deviation by EKG"
* http://loinc.org#76644-4 "R-R interval.coefficient of variation"

// Activity criteria
* http://loinc.org#41950-7 "Number of steps in unspecified time Pedometer"

// Sleep criteria
* http://loinc.org#93832-4 "Sleep duration"

// Heart rate criteria
* http://loinc.org#8867-4 "Heart rate"

// VO2 max
* http://loinc.org#60842-2 "Oxygen consumption (VO2)" // T2 S33 VRF-TERM-018: 92841-6 was "Countermeasure report" (not VO2max); 60842-2 matches the vo2max-estimation-observation profile

// SpO2
* http://loinc.org#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"

// ============================================================================
// OperationDefinition: $export reference
// ============================================================================
// The actual $export operation is defined upstream by the Bulk Data Access IG
// (http://hl7.org/fhir/uv/bulkdata/OperationDefinition/group-export). This IG
// profiles the Group resource that $export operates upon; it does NOT redefine
// the operation. CapabilityStatement (SMARTOnFHIRConformance.fsh) declares
// support for the canonical $export operation on Group resources matching
// this BulkExportGroup profile.
// ============================================================================

// ============================================================================
// Example — HRV Decline Cohort
// ============================================================================

Instance: BulkExportGroupHRVDeclineExample
InstanceOf: BulkExportGroup
Title: "Example: HRV Decline 90-day Cohort"
Description: "Example research cohort: patients with declining HRV trend over last 90 days"
Usage: #example

* type = #person
* actual = false
* active = true
* code = http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"
* name = "HRV-decline-90d-2026Q2-cohort-001"
* quantity = 247

// Un-sliced characteristic — HRV-decline criterion (lifestyle-metric semantic)
* characteristic[0]
  * code = http://loinc.org#80404-7 "R-R interval.standard deviation (Heart rate variability)"
  * valueRange.low.value = 30.0
  * valueRange.low.unit = "ms"
  * valueRange.high.value = 50.0
  * valueRange.high.unit = "ms"
  * exclude = false
  * period.start = "2026-02-07"
  * period.end = "2026-05-07"

* characteristic[ageRange]
  * code = http://loinc.org#30525-0 "Age"
  * valueRange.low.value = 40
  * valueRange.low.unit = "a"
  * valueRange.high.value = 70
  * valueRange.high.unit = "a"
  * exclude = false

* extension[consentRef].valueReference.reference = "Consent/BulkExportConsentHRVResearchExample"
