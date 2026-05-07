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
* characteristic ^slicing.discriminator.type = #pattern
* characteristic ^slicing.discriminator.path = "code"
* characteristic ^slicing.rules = #open
* characteristic ^slicing.description = "Cohort criteria slices (lifestyle metric, demographic, clinical condition)"
* characteristic contains
    lifestyleMetric 0..* MS and
    ageRange 0..1 MS and
    clinicalCondition 0..* MS

// Lifestyle metric criterion (e.g., HRV-decline pattern)
* characteristic[lifestyleMetric].code 1..1 MS
* characteristic[lifestyleMetric].code from LifestyleMetricCohortCriteriaVS (extensible)
* characteristic[lifestyleMetric].value[x] 1..1 MS
* characteristic[lifestyleMetric].exclude 1..1 MS
* characteristic[lifestyleMetric].period 1..1 MS
  * ^short = "Period over which metric criterion applies (e.g., last 90 days)"

// Age range criterion
* characteristic[ageRange].code 1..1 MS
* characteristic[ageRange].code = http://loinc.org#30525-0 "Age"
* characteristic[ageRange].valueRange 1..1 MS
* characteristic[ageRange].exclude 1..1 MS

// Clinical condition criterion
* characteristic[clinicalCondition].code 1..1 MS
* characteristic[clinicalCondition].code = http://loinc.org#11450-4 "Problem list"
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

* http://terminology.hl7.org/CodeSystem/v3-ActReason#HRESCH "healthcare research"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#PUBHLTH "public health"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#HQUALIMP "healthcare quality improvement"
* http://terminology.hl7.org/CodeSystem/v3-ActReason#HSYSADMIN "healthcare system administration"
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
* http://loinc.org#80404-7 "R-R interval.standard deviation [Time] - SDNN"
* http://loinc.org#76643-6 "R-R interval.standard deviation by EKG"
* http://loinc.org#76644-4 "R-R interval.coefficient of variation"

// Activity criteria
* http://loinc.org#41950-7 "Number of steps in unspecified time Pedometer"

// Sleep criteria
* http://loinc.org#93832-4 "Sleep duration"

// Heart rate criteria
* http://loinc.org#8867-4 "Heart rate"

// VO2 max
* http://loinc.org#92841-6 "Maximal oxygen consumption normalized [Volume rate/mass]"

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

* characteristic[lifestyleMetric][0]
  * code = http://loinc.org#80404-7 "R-R interval.standard deviation [Time] - SDNN"
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

* extension[consentRef].valueReference.reference = "Consent/bulk-export-consent-hrv-decline-2026Q2"
